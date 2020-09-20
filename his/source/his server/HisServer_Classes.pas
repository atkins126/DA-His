unit HisServer_Classes;

{
  HIS��̨�������

  Written by caowm (remobjects@qq.com)
  2014��10��
}

interface

uses
  SysUtils,
  Classes,
  Variants,
  SyncObjs,
  uROXMLIntf,
  uROClientIntf,
  uROTypes,
  uROServer,
  uROServerIntf,
  uROSessions,
  uRORemoteDataModule,
  uDADataStreamer,
  uDAInterfaces,
  DataAbstractService_Impl,
  DataAbstract4_Intf,
  uDASchema,
  uROClient,
  App_Common,
  App_DAServer,
  HisServer_Const;

type

  {
     ��������̨����֧����

     1 �ڶ��̲߳�������Schema�������, ��Чʵ�ֶ�̬����Schema
     2 DataStreamerĿǰͳһ
  }
  TBaseBackend = class(TDataModule)
  private
    FSchemaCritical: TCriticalSection;
    FSchemaUpdating: Boolean;
    FDAStreamer: TDADataStreamer;
  protected
    function InternalGetSchema(): TDASchema; virtual; abstract;
    function GetSchemaFileName(): string; virtual; abstract;
  public
    destructor Destroy(); override;
    function GetSchema(): TDASchema; virtual;
    function GetDAStreamer(): TDADataStreamer;
    procedure RefreshSchema(AIsFirstTime: Boolean = False);
    procedure AfterConstruction(); override;
  end;

implementation

{$R *.dfm}

{ TBaseBackend }

procedure TBaseBackend.AfterConstruction;
begin
  inherited;
  FSchemaCritical := TCriticalSection.Create;
  FDAStreamer := RemoteServer.NewDAStreamer(Self);
  RefreshSchema(True);
end;

destructor TBaseBackend.Destroy;
begin
  FreeAndNil(FSchemaCritical);
  inherited;
end;

{ �����ڶ��̷߳��ʵĲ������� }
function TBaseBackend.GetDAStreamer: TDADataStreamer;
begin
  Result := FDAStreamer;
end;

function TBaseBackend.GetSchema: TDASchema;
begin
  if FSchemaUpdating then
  begin
    try
      // �ȴ�Schema�������
      FSchemaCritical.Enter;
    finally
      FSchemaCritical.Leave;
    end;
  end;
  Result := InternalGetSchema;
end;

{ ���¼���Schema }

procedure TBaseBackend.RefreshSchema(AIsFirstTime: Boolean);
var
  SchemaFileName: string;
begin
  FSchemaCritical.Enter;
  FSchemaUpdating := True;
  try
    // �ȴ����д�����ɣ�ʱ��Խ�����ϸ���Խ��
    // ���е�DataService����ͨ��GetSchema����ȡSchema�������ɱ�֤��Schema����
    // �ڼ䲻����ֹ���
    if not AIsFirstTime then
      Sleep(iWaitTimeBeforeUpdateSchema);

    InternalGetSchema.Clear;
    SchemaFileName := AppCore.BinPath + GetSchemaFileName;
    if FileExists(SchemaFileName) then
    begin
      try
        InternalGetSchema.LoadFromFile(SchemaFileName);
        AppCore.Logger.Write(SchemaFileName + '�������.', mtInfo, 0);
      except
        on E: Exception do
          AppCore.Logger.Write('ϵͳ����Schema����ʧ�ܣ�ԭ��' + E.Message, mtError, 0);
      end;
    end
    else
      AppCore.Logger.WriteFmt('%sϵͳ�����ļ�δ�ҵ�', [SchemaFileName], mtError, 0);
  finally
    FSchemaCritical.Leave;
    FSchemaUpdating := False;
  end; 
end;

end.
