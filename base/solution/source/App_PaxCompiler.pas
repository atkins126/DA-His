unit App_PaxCompiler;

{
  PaxCompiler��

  Written by caowm (remobjects@qq.com)
  2014��9��
}

interface

uses
  Classes,
  SysUtils,
  IniFiles,
  Forms,
  Menus,
  Import_Common,
  App_Common,
  App_DAModel,
  PaxProgram,              
  PaxCompiler,
  PaxInvoke,
  PaxRegister;

type

  TOnLoadScript = procedure(const ScriptID: string; var Script: string) of object;

  TPaxExecProc = function(CommandID: Integer; const Param: array of Variant): Variant;

  {
    PaxCompiler�ű�������

    ����TBaseOperation.Execute���̿�ʵ�ֽű�֮���໥����!!!
    ���дһ���ű�������
  }

  TPaxOperation = class(TBaseOperation)
  private
    FProgram: TPaxProgram;
    FScript: string;
    FCompiled: Boolean;
    FOnNeedScript: TOnLoadScript;
    FSelfVariable: TBaseOperation;
    procedure SetScript(const Value: string);
  protected
    function DoExecute(CommandID: Integer; const Param: array of Variant): Variant; override;
  public
    constructor Create(const AID: string; AOwner: TOperations = nil); override;
    destructor Destroy(); override;
    procedure ClearProgram();

    property Script: string read FScript write SetScript;
    property OnLoadScript: TOnLoadScript read FOnNeedScript write FOnNeedScript;
  end;

  TCustomScriptLoader = class(TComponent)
  public
    procedure LoadScriptOperation(); virtual; abstract;
    procedure DoLoadScript(const ScriptID: string; var Script: string); virtual; abstract;
  end;

  {
    ���ݿ�ű�������

    ����������ֶ�:
      ScriptID, Category, Caption, Flag, ShortKey, ImageName,
      CustomAttributes, Script, OrderNum, Memo
  }
  TDBScriptLoader = class(TCustomScriptLoader)
  private
    FScriptData: TCustomData;
  public
    procedure LoadScriptOperation(); override;
    procedure DoLoadScript(const ScriptID: string; var Script: string); override;

    property ScriptData: TCustomData read FScriptData write FScriptData;
  end;

  {
    todo: ���ؽű����������ʺ���չ����˹���
  }
  TLocalScriptLoader = class(TCustomScriptLoader)
  private
    FScriptFile: string;
  public
    procedure LoadScriptOperation(); override;
    procedure DoLoadScript(const ScriptID: string; var Script: string); override;

    property ScriptFile: string read FScriptFile write FScriptFile;
  end;


  function CompileProgram(AScript: string; AProgram: TPaxProgram; var MyOperation: TBaseOperation): Boolean;
  procedure OutputCompileError;

var
  Compiler: TPaxCompiler;
  PasLanguage: TPaxPascalLanguage;

implementation

procedure Println(Text: Variant);
begin
  AppCore.Logger.Write(Text, mtInfo, 0);
end;

procedure Initialize();
begin
  if Compiler = nil then
  begin
    Compiler := TPaxCompiler.Create(Application);
    PasLanguage := TPaxPascalLanguage.Create(Application);
    RegisterHeader(0, 'procedure Println(Text: Variant)', @Println);
  end;
end;

procedure OutputCompileError;
var
  I: Integer;
  S: string;
begin
  S := '�������: ';
  for I := 0 to Compiler.ErrorCount - 1 do
    S := S + #13#10 + Format('%s-[%d, %d]: %s'#13#10'%s',
      [Compiler.ErrorModuleName[I], Compiler.ErrorLineNumber[I],
      Compiler.ErrorLinePos[I], Compiler.ErrorLine[I],
        Compiler.ErrorMessage[I]]);
  raise Exception.Create(S);
end;

function CompileProgram(AScript: string; AProgram: TPaxProgram; var MyOperation: TBaseOperation): Boolean;
begin
  Initialize;

  Compiler.Reset;
  Compiler.RegisterLanguage(PasLanguage);
  Compiler.OnInclude := nil;
  Compiler.OnUsedUnit := nil;
  Compiler.RegisterVariable(0, 'MyOperation: TBaseOperation;', @MyOperation);
  Compiler.AddModule('main', PasLanguage.LanguageName);
  Compiler.AddCode('main', AScript);

  Result := Compiler.Compile(AProgram);
end;

{ TPaxOperation }

procedure TPaxOperation.ClearProgram;
var
  P: Pointer;
begin
  if FProgram.CodePtr <> nil then
  begin
    FCompiled := False;
    P := FProgram.GetAddress('DOCLEAR');
    if P <> nil then TProcedure(p)();
  end;
end;

constructor TPaxOperation.Create(const AID: string; AOwner: TOperations);
begin
  FProgram := TPaxProgram.Create(nil);
  FSelfVariable := Self;
  inherited;
end;

destructor TPaxOperation.Destroy;
begin
  ClearProgram;
  FProgram.Free;
  inherited;
end;

function TPaxOperation.DoExecute(CommandID: Integer; const Param: array of Variant): Variant;
var
  P: Pointer;

  procedure CompileAndExecute();
  begin
    if not FCompiled or (FProgram.CodePtr = nil) then
    begin
      AppCore.Logger.Write('���ڱ���ű�:' + Caption, mtInfo, 0);

      if (FScript = '') and Assigned(FOnNeedScript) then
        FOnNeedScript(GUID, FScript);

      if (FScript = '') then
        raise Exception.CreateFmt('%s-%s:˵�õĽű���', [Category, Caption]);

      if CompileProgram(FScript, FProgram, FSelfVariable) then
      begin
        FCompiled := True;
        FProgram.Run; //��ʼ��
      end
      else begin
        FScript := ''; // �Զ���սű�������¼���
        OutputCompileError();
      end
    end;

    //ȫ����������ʽ: 'UnitName.Something', ����Դ�ļ����ܴ���Ԫ��!!!
    P := FProgram.GetAddress('DOEXECUTE');  // ע�⣺���д��󲻻����¼��ؽű�
    if Assigned(P) then
      Result := TPaxExecProc(P)(CommandID, Param);
  end;

begin
  case CommandID of
    iOperationCommand_Clear: ClearProgram;
  else
    CompileAndExecute();
  end;
end;

procedure TPaxOperation.SetScript(const Value: string);
begin
  ClearProgram;
  FScript := Value;
end;


{ TDBScriptLoader }

procedure TDBScriptLoader.DoLoadScript(const ScriptID: string;
  var Script: string);
begin
  with FScriptData do
  begin
    OpenByKeyValue(ScriptID);
    if not Eof then
      Script := AsString['Script']
    else
      Script := '';
  end;
end;

procedure TDBScriptLoader.LoadScriptOperation;
begin
  AppCore.Logger.Write('���ڼ��ؽű�...', mtInfo, 0);
  with FScriptData do
  begin
    // ��û��ͣ�õ�
    OpenByFieldValue('Disabled', 0);
    while not Eof do
    begin
      with TPaxOperation.Create(AsString['ScriptID']) do
      begin
        Category := AsString['Category'];
        Caption := AsString['Caption'];
        Access := AsString['Access'];
        ImageName := AsString['ImageName'];
        ShortKey := TextToShortCut(AsString['ShortKey']);
        Flag := AsInteger['Flag'];
        Order := AsString['OrderNum'];
        CustomAttributes.Text := AsString['CustomAttributes'];
        Script := AsString['Script'];
        OnLoadScript := DoLoadScript;
      end;
      Next;
    end;
    Close;
  end;
end;

{ TLocalScriptLoader }

procedure TLocalScriptLoader.DoLoadScript(const ScriptID: string;
  var Script: string);
begin

end;

procedure TLocalScriptLoader.LoadScriptOperation;
begin

end;

end.

