unit UpdateClient_MainForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ShellAPI,
  
  uROSOAPMessage,
  uROXmlRpcMessage,
  uROIndyHTTPChannel,
  uROIndyTCPChannel,
  uROSuperTCPChannel,
  
  App_Function,
  App_Common,
  App_DAModel,
  FileServiceLib_Intf,
  FileService_ClientBackend,
  StdCtrls,
  ComCtrls,
  ActnList,
  Menus,
  XPMan;

const
  CM_UPDATEAPP = WM_USER + 1;

type
  TUpdateClientMainForm = class(TForm)
    DownButton: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    AppIDEdit: TEdit;
    Label2: TLabel;
    ServerEdit: TEdit;
    Label3: TLabel;
    AppPathEdit: TEdit;
    ProgressBar: TProgressBar;
    LogMemo: TMemo;
    XPManifest1: TXPManifest;
    AllCheckBox: TCheckBox;
    CancelButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
  private
    FAppExeName: string;
    FCanceled: Boolean;

    procedure LogInfo(const AInfo: string);
    procedure CheckCmdLine();
    function GetDownloadPath(): string;
    procedure EnableControls(Value: Boolean);
    procedure OnDownloadFile(Sender: TObject; Info: FileInfo);
    procedure OnFileProgress(MaxValue, Position: Integer; var Canceled: Boolean);
    procedure OnAllProgress(MaxValue, Position: Integer; var Canceled: Boolean);

    procedure CMUpdateApp(var AMsg: TMessage); message CM_UPDATEAPP;
  protected
    procedure LoadState();
    procedure SaveState();
  public
    { Public declarations }
    procedure StartUpdate();
  end;

var
  UpdateClientMainForm: TUpdateClientMainForm;
  Connection: TROConnection;
  FileService: TFileServiceClient;

implementation

uses
  UpdateAppLib_Intf;

const
  sUpdateInfo = 'AppUpdateInfo';

{$R *.dfm}

{ TUpdateClientMainForm }

procedure TUpdateClientMainForm.LoadState;
begin
  inherited;
  AppIDEdit.Text := AppCore.IniFile.ReadString(sUpdateInfo, 'AppID', '');
  AppPathEdit.Text := AppCore.IniFile.ReadString(sUpdateInfo, 'AppPath', '');
  // todo: ����Ĭ�ϸ��·�����
  ServerEdit.Text := AppCore.IniFile.ReadString(sUpdateInfo, 'Server', 'http://127.0.0.1:9800/bin');
end;

procedure TUpdateClientMainForm.SaveState;
begin
  inherited;
  with AppCore.IniFile do
  begin
    WriteString(sUpdateInfo, 'AppID', AppIDEdit.Text);
    WriteString(sUpdateInfo, 'AppPath', AppPathEdit.Text);
    // ��֤Ĭ�Ϸ�������ַ����
    //WriteString(sUpdateInfo, 'Server', ServerEdit.Text);
  end;
end;

procedure TUpdateClientMainForm.FormShow(Sender: TObject);
begin
  inherited;
  CheckCmdLine();
end;

procedure TUpdateClientMainForm.StartUpdate;
var
  DownloadPath: string;
begin
  EnableControls(False);
  CancelButton.Caption := 'ȡ��';
  try

    if (Trim(AppIDEdit.Text) = '') then
      raise Exception.Create('����д���ID');

    if (Trim(AppPathEdit.Text) = '') then
      raise Exception.Create('����д���Ŀ¼');

    if (Trim(ServerEdit.Text) = '') then
      raise Exception.Create('����д���ص�ַ');

    LogMemo.Clear;
    DownloadPath := GetDownloadPath;
    LogInfo('��ʼ����...');
    try
      FCanceled := False;

      FileService.InitService(Connection.ROService);

      if AllCheckBox.Checked then
        FileService.DownloadPath(DownloadPath, AppPathEdit.Text,
          OnDownloadFile, OnAllProgress, OnFileProgress)
      else
        FileService.UpdateClientFiles(DownloadPath, AppPathEdit.Text,
          OnDownloadFile, OnAllProgress, OnFileProgress);

      // ִ��������Ľű�UpdateScript.bat
      if FileExists(AppPathEdit.Text + '\UpdateScript.bat') then
      begin
        LogInfo('����ִ�и��½ű�...');
        ShellExecute(0, nil,  PChar(AppPathEdit.Text + '\UpdateScript.bat'), nil,
         PChar(AppPathEdit.Text), 0);
      end;

      LogInfo('�������.');
    except
      on E: Exception do
      begin
        LogInfo('���³���' + E.Message);
        raise;
      end;
    end;

    // ����Ӧ�ó���
    if (FAppExeName <> '') then
    begin
      if ShowYesNo('������ɣ��Ƿ����������������?') then
      begin
        ShellExecute(0, nil,  PChar(FAppExeName), nil, nil, 0);
        Close();
      end;
    end;
  finally    
    FAppExeName := ''; 
    CancelButton.Caption := '�ر�';
    EnableControls(True);
  end;
end;

procedure TUpdateClientMainForm.DownButtonClick(Sender: TObject);
begin
  StartUpdate;
end;

procedure TUpdateClientMainForm.CheckCmdLine;
begin
  if GetCmdLineParam('AppID') = '' then Exit;

  FAppExeName := GetCmdLineParam('AppExe');
  AppIDEdit.Text := GetCmdLineParam('AppID');
  AppPathEdit.Text := GetCmdLineParam('AppPath');
  if GetCmdLineParam('Server') <> '' then
    ServerEdit.Text := GetCmdLineParam('Server');
  AllCheckBox.Checked := GetCmdLineParam('All') <> '';

  if (AppIDEdit.Text = '') or
    (AppPathEdit.Text = '') or
    (ServerEdit.Text = '') then
    raise Exception.Create('�����в���ȷ��ʾ����'#13#10 +
      'UpdateClient.exe -AppExe "c:\program files\his\bin\client.exe" ' +
      '-AppID his_client -AppPath "c:\program files\his\" ' +
      '[-Server "http://10.2.10.114:9800/bin]" [-All]'#13#10#13#10 +
      '  AppExe��ʾ��ִ���ļ�'#13#10 +
      '  AppID��ʾ���ID'#13#10 +
      '  AppPath��ʾ�ͻ����������Ŀ¼'#13#10 +
      '  Server(��ѡ)��ʾ�������������'#13#10 +
      '  All(��ѡ)��ʾǿ�Ƹ���');

  PostMessage(Handle, CM_UPDATEAPP, 0, 0);
end;

function TUpdateClientMainForm.GetDownloadPath: string;
var
  DownloadPath: string;
  RequestInfo: TStrings;
  ResultInfo: TStrings;
begin
  Connection.ROService.ServiceName := 'UpdateAppService';
  Connection.TargetURL := ServerEdit.Text;

  RequestInfo := TStringList.Create;
  ResultInfo := TStringList.Create;
  try
    RequestInfo.Text := 'AppID=' + AppIDEdit.Text;
    ResultInfo.Text := (Connection.ROService as IUpdateAppService).GetUpdateInfo(RequestInfo.Text);
    Result := ResultInfo.Values['DownloadPath'];
  finally
    RequestInfo.Free;
    ResultInfo.Free;
  end;
end;

procedure TUpdateClientMainForm.EnableControls(Value: Boolean);
begin
  AppIDEdit.Enabled := Value;
  AppPathEdit.Enabled := Value;
  ServerEdit.Enabled := Value;
  DownButton.Enabled := Value;
  AllCheckBox.Enabled := Value;
end;

procedure TUpdateClientMainForm.OnDownloadFile(Sender: TObject;
  Info: FileInfo);
begin
  LogInfo('��������' + Info.Name);
  Application.ProcessMessages;
end;

procedure TUpdateClientMainForm.OnFileProgress(MaxValue, Position: Integer;
  var Canceled: Boolean);
begin
  ProgressBar.Max := MaxValue;
  ProgressBar.Position := Position;
  Application.ProcessMessages;    
  Canceled := FCanceled;
end;

procedure TUpdateClientMainForm.OnAllProgress(MaxValue,
  Position: Integer; var Canceled: Boolean);
begin
  Canceled := FCanceled;
end;

procedure TUpdateClientMainForm.LogInfo(const AInfo: string);
begin
  LogMemo.Lines.Add(Format('%s %s', [FormatDateTime('HH:MM:SS', Now), AInfo]));
end;

procedure TUpdateClientMainForm.FormCreate(Sender: TObject);
begin
  LoadState;
  Connection := TROConnection.Create(Self, ServerEdit.Text);
  FileService := TFileServiceClient.Create(Self);

  Caption := Application.Title;
end;

procedure TUpdateClientMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveState;
end;

procedure TUpdateClientMainForm.CancelButtonClick(Sender: TObject);
begin
  if CancelButton.Caption = 'ȡ��' then
    FCanceled := True
  else
    Close;
end;

procedure TUpdateClientMainForm.CMUpdateApp(var AMsg: TMessage);
begin
  StartUpdate;
end;

end.

