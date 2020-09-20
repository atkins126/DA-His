unit UpdateServer_Organizer;

{
  ���������÷�����
    �ڷ�����AppStoreĿ¼��Ϊÿ����������App����һ����Ŀ¼��Ŀ¼������App��ID
}

interface

uses Classes,
  SysUtils,
  Menus,
  Forms,
  App_Common;

const
  // operation category �������
  socSys = 'ϵͳ';
  socData = '����';
  socView = '��ͼ';

  // operation ID
  soidHome = 'home';
  soidLogger = 'logger';


implementation

uses
  FileService_ServerBackend;


procedure OrganizeOperations();
begin
  with TViewOperation.Create(soidLogger) do
  begin
    Category := socSys;
    Caption := '���м�¼';
    ImageName := soidLogger;
    Order := 'S02';
    ShortKey := ShortCut(WORD('L'), [ssCtrl]);
    ViewClass := TLogView;
  end;
  // ע���������Ŀ¼
  FileServiceManager.RegisterLogicalName('AppStore', AppCore.AppPath + 'AppStore');
end;

initialization
  OrganizeOperations();

end.

