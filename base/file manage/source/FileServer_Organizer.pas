unit FileServer_Organizer;

interface

uses Classes,
  SysUtils,
  Menus,
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
end;

initialization
  OrganizeOperations();

end.

