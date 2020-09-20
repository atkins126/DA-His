unit FileClient_Organizer;

interface

uses
  Classes,
  SysUtils,
  Menus,

  dxCore,
     
  uROSOAPMessage,
  uROXmlRpcMessage,
  uROIndyHTTPChannel,
  uROIndyTCPChannel,
  uROSuperTCPChannel,

  dxSkinsdxBarPainter,
  dxSkinsdxStatusBarPainter,
  dxSkinBlue, 
  dxSkinDarkSide,
  dxSkinLilian,

  App_Common,
  App_DevOptions,
  App_Dev_Toolbar;

const
  // operation category ҵ�����
  socSys = 'ϵͳ';
  socData = '����';
  socView = '��ͼ';
  socFile = '�ļ�';

  // operation ID  ҵ��ID
  soidHome = 'home';
  soidLogger = 'logger';
  soidFileClient = 'file';
  soidOption = 'option';

  // ͼƬ����
  sinPreferences = 'preferences';

implementation

uses FileClient_MainForm;

procedure OrganizeOperations();
begin
  with TViewOperation.Create(soidFileClient) do
  begin
    Category := socSys;
    Caption := '�ļ�����';
    ImageName :=soidFileClient;
    Order := 'S01';
    ShortKey := ShortCut(WORD('F'), [ssCtrl]);
    ViewClass := TFileClientForm;
  end;
  with TViewOperation.Create(soidLogger) do
  begin
    Category := socSys;
    Caption := '���м�¼';
    ImageName :=soidLogger;
    Order := 'S02';
    ShortKey := ShortCut(WORD('L'), [ssCtrl]);
    ViewClass := TLogView;
  end;
  with TViewOperation.Create(soidOption) do
  begin
    Category := socSys;
    Caption := '��������';
    ImageName :=sinPreferences;
    Order := 'S03';
    ViewClass := TOptionSetForm;
  end;
end;

procedure InitApp();
begin
  OrganizeOperations;
end;

initialization
  InitApp();

end.

