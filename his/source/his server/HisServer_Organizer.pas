unit HisServer_Organizer;

{
  HIS��̨��֯��

  Written by caowm (remobjects@qq.com)
  2014��10��
}

interface

uses
  Classes,
  SysUtils,
  Menus,
  Variants,
  App_Common,
  App_FastReport,
  App_DAServer,
  IdeaService_Impl,
  HisServer_Const,
  HisServer_Classes,
  HisService_System_Backend,
  HisService_Base_Backend,
  HisService_Dict_Backend,
  HisService_Clinic_Backend,
  HisService_Hosp_Backend,
  HisService_Medicine_Backend,
  HisService_Stat_Backend,
  HisService_Extend_Backend,
  HisService_YB_Backend,
  HisService_XNH_Backend;

function RefreshSchemaOperation(Sender: TBaseOperation; CommandID: Integer;
  const Param: array of Variant): Variant;

implementation

function RefreshSchemaOperation(Sender: TBaseOperation; CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  TBaseBackend(Sender.Data).RefreshSchema;
end;

{ �򿪵�ǰ��ͼ����ı�������� }

function DesignReport(Sender: TBaseOperation; AID: Integer;
  const AParam: array of Variant): Variant;
begin
  FastReport.DesignReport('');
end;

function MaintainServer(Sender: TBaseOperation; AID: Integer;
  const AParam: array of Variant): Variant;
const
  MaintainHint: array [Boolean] of string = ('�������˳�ά��״̬����������ʹ�ã�',
    '�������ѽ���ά��״̬���û�����ʹ�ã�');
begin
  RemoteServer.Maintaining := not RemoteServer.Maintaining;
  AppCore.Logger.Write(MaintainHint[RemoteServer.Maintaining], mtInfo, 0);
  Sender.Checked := RemoteServer.Maintaining;
end;

procedure InitServer();
begin
  AppCore.ID := sAppID;
  AppCore.Version := sAppVer;

  // ��̬�������ݷ���
  IdeaManager.RegisterServices('Idea.xml');

  with TViewOperation.Create(sOperationIDLogger) do
  begin
    Category := sOperationCategoryFile;
    Caption := '���м�¼';
    ImageName := sImageLogger;
    Order := 'S01';
    Flag := iOperationFlag_NoTree; // ����ʾ�ڲ�������
    ShortKey := ShortCut(WORD('L'), [ssCtrl]);
    ViewClass := TLogView;
  end;

//  with TProcOperation.Create(sOperationIDReport) do
//  begin
//    Category := sOperationCategoryFile;
//    Caption := '��Ʊ���';
//    ImageName := sOperationIDReport;
//    Order := 's011';
//    Flag := iOperationFlag_NoTree;
//    ShortKey := ShortCut(Ord('R'), [ssCtrl]);
//    OnExecute := DesignReport;
//  end;

  with TProcOperation.Create(sOperationIDReport) do
  begin
    Category := sOperationCategoryFile;
    Caption := 'ά��״̬';
    Order := 's012';
    Flag := iOperationFlag_NoTree;
    OnExecute := MaintainServer;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaSystem) do
  begin
    Category := sOperationCategoryData;
    Caption := '����ϵͳ����Schema';
    ImageName := sImageSchema;
    Order := 'S20';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := SystemBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaBase) do
  begin
    Category := sOperationCategoryData;
    Caption := '���ػ�������Schema';
    ImageName := sImageSchema;
    Order := 'S21';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := BaseDataBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaDict) do
  begin
    Category := sOperationCategoryData;
    Caption := '�����ֵ����Schema';
    ImageName := sImageSchema;
    Order := 'S21';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := DictBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaClinic) do
  begin
    Category := sOperationCategoryData;
    Caption := '�����������Schema';
    ImageName := sImageSchema;
    Order := 'S22';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := ClinicBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaHosp) do
  begin
    Category := sOperationCategoryData;
    Caption := '����סԺ����Schema';
    ImageName := sImageSchema;
    Order := 'S23';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := HospBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaMedicine) do
  begin
    Category := sOperationCategoryData;
    Caption := '����ҩƷ����Schema';
    ImageName := sImageSchema;
    Order := 'S24';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := MedicineBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaYB) do
  begin
    Category := sOperationCategoryData;
    Caption := '����ҽ������Schema';
    ImageName := sImageSchema;
    Order := 'S25';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := YBBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaXNH) do
  begin
    Category := sOperationCategoryData;
    Caption := '������ũ�Ϸ���Schema';
    ImageName := sImageSchema;
    Order := 'S26';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := XNHBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaStat) do
  begin
    Category := sOperationCategoryData;
    Caption := '����ͳ�Ʒ���Schema';
    ImageName := sImageSchema;
    Order := 'S27';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := StatBackend;
  end;

  with TProcOperation.Create(sOperationIDRefreshSchemaExtend) do
  begin
    Category := sOperationCategoryData;
    Caption := '������չ����Schema';
    ImageName := sImageSchema;
    Order := 'S28';
    Flag := iOperationFlag_NoTree;
    OnExecute := RefreshSchemaOperation;
    Data := ExtendBackend;
  end;

end;

initialization

InitServer;

end.
