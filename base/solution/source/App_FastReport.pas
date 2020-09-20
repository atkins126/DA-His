unit App_FastReport;

{
  FastReport��

  Written by caowm (remobjects@qq.com)
  2014��9��
}

interface

uses
  SysUtils,
  Classes,
  Forms,
  DB,
  Controls,
  ADODB,
  Dialogs,
  App_Common,
  App_Function,

  frxClass,
  fs_iinterpreter,
  frxPrintDialog,
  frxPrinter,
  // ɾ������ĵ�Ԫ����С�������
  fs_iclassesrtti,
  fs_idialogsrtti,
  fs_iformsrtti,
  fs_ipascal,
  fs_igraphicsrtti,
  fs_iadortti,
  fs_idbctrlsrtti,
  fs_iextctrlsrtti,
  fs_ichartrtti,
  fs_iinirtti,

  frxDBSet,
  frxDesgn,
  frxExportText,
  frxExportXLS,
  frxDCtrl,
  frxGradient,
  frxChBox,
  frxCross,
  frxRich,
  frxChart,
  frxOLE,
  frxBarcode,
  frxExportCSV,
  frxExportImage,
  frxExportHTML,
  frxExportPDF,
  frxExportRTF,
  frxExportBaseDialog,
  frxADOComponents,
  frxFDComponents;

type

  TReportModule = class(TDataModule)
    frxADOComponents1: TfrxADOComponents;
    frxReport: TfrxReport;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxOLEObject1: TfrxOLEObject;
    frxChartObject1: TfrxChartObject;
    frxRichObject1: TfrxRichObject;
    frxCrossObject1: TfrxCrossObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxGradientObject1: TfrxGradientObject;
    frxDialogControls1: TfrxDialogControls;
    frxXLSExport1: TfrxXLSExport;
    frxDesigner: TfrxDesigner;
    frxDBDataset: TfrxDBDataset;
    frxPDFExport1: TfrxPDFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxJPEGExport1: TfrxJPEGExport;
    frxRTFExport1: TfrxRTFExport;
    fsScript: TfsScript;
    frxFDComponents1: TfrxFDComponents;
    procedure DataModuleCreate(Sender: TObject);
  private
    FDefaultPrinter: string;
    FReportFilePath: string; // Ĭ��ΪӦ�ó����Report��Ŀ¼
    procedure ClearDataSets();
    function GetPrinter: string;
    procedure SetPrinter(const Value: string);
    function GetDefaultPrinter: string;
  public
    procedure PrintReport(AReportName: string;
      const ADataSets: array of TDataSet; const ADataSetName: array of string;
      const AParams, AValues: array of Variant; APreviewIt: Boolean;
      const APrinter: string);

    procedure PrintStream(AStream: TStream; const AReportName: string;
      APreviewIt: Boolean; const APrinter: string);

    procedure DesignReport(AReportName: string;
      const ADataSets: array of TDataSet; const ADataSetName: array of string;
      const AParams, AValues: array of Variant); overload;

    procedure DesignReport(AReportName: string); overload;

    procedure SetupPrinter();

    function Evaluate(AExpression: string): Variant;

    property Printer: string read GetPrinter write SetPrinter;
    property DefaultPrinter: string read GetDefaultPrinter;
    property ReportFilePath: string read FReportFilePath write FReportFilePath;
  end;

function FastReport(): TReportModule;

implementation

{$R *.dfm}

var
  ReportModule: TReportModule;

type

  TFunction = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: string; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

function FastReport(): TReportModule;
begin
  if ReportModule = nil then
    ReportModule := TReportModule.Create(Application);
  Result := ReportModule;
end;

{ TFastReportModule }

procedure TReportModule.DesignReport(AReportName: string);
begin
  AReportName := FReportFilePath + AReportName;
  if FileExists(AReportName) then
    frxReport.LoadFromFile(AReportName);
  frxReport.DesignReport;
end;

procedure TReportModule.DesignReport(AReportName: string;
  const ADataSets: array of TDataSet; const ADataSetName: array of string;
  const AParams, AValues: array of Variant);
var
  I: Integer;
  DS: TfrxDBDataset;
begin
  // todo: test
  AReportName := FReportFilePath + AReportName;

  with frxReport do
    try
      Variables.Clear;
      // �����������
      for I := Low(ADataSets) to High(ADataSets) do
      begin
        DS := TfrxDBDataset.Create(Self);
        DS.UserName := ADataSetName[I];
        DS.DataSet := ADataSets[I];
        DataSets.Add(DS);
      end;

      FileName := AReportName;
      if FileExists(AReportName) then
        LoadFromFile(AReportName);

      for I := Low(AParams) to High(AParams) do
        Variables[AParams[I]] := AValues[I];

      DesignReport();
    finally
      // ������õ�����
      // DataSets.Clear;
      ClearDataSets;
    end;
end;

procedure TReportModule.PrintReport(AReportName: string;
  const ADataSets: array of TDataSet; const ADataSetName: array of string;
  const AParams, AValues: array of Variant; APreviewIt: Boolean;
  const APrinter: string);
var
  I: Integer;
  DS: TfrxDBDataset;
begin
  frxReport.ReportOptions.Name := AReportName;

  AReportName := FReportFilePath + AReportName;

  // ��ӡ���ԣ��ŵ�һϵ��ִ�й��̵����ȽϺ�
  if not FileExists(AReportName) then
    raise Exception.CreateFmt('�Ҳ�����ӡģ���ļ� %s.', [AReportName]);

  with frxReport do
    try
      Printer := APrinter;
      // ʹ�����ô�ӡ��
      if APrinter = '' then
        Printer := FDefaultPrinter;

      Variables.Clear;
      // �����������
      for I := Low(ADataSets) to High(ADataSets) do
      begin
        DS := TfrxDBDataset.Create(Self); // ���Ϊȫ��DataSet
        DS.UserName := ADataSetName[I];
        DS.DataSet := ADataSets[I];
        DataSets.Add(DS);
      end;

      LoadFromFile(AReportName);

      for I := Low(AParams) to High(AParams) do
        Variables[AParams[I]] := QuotedStr(AValues[I]);
      // ����ֵ������������ִ�У��ַ�������Ҫ������

      PrepareReport;

      if APreviewIt then
      begin
        PrintOptions.ShowDialog := True;
        ShowPreparedReport;
      end
      else
      begin
        PrintOptions.ShowDialog := False;
        Print;
      end;

    finally
      // ������õ�����
      // DataSets.Clear;
      ClearDataSets;
    end;
end;

procedure TReportModule.DataModuleCreate(Sender: TObject);
begin
  if (frxPrinters.PrinterIndex > -1) and (frxPrinters.Printers.Count > 0) then
    FDefaultPrinter := frxPrinters.Printers[frxPrinters.PrinterIndex];
  FReportFilePath := AppCore.AppPath + 'report\';
end;

procedure TReportModule.SetupPrinter;
begin
  with TfrxPrintDialog.Create(Application) do
  begin
    AReport := frxReport;
    ADuplexMode := frxReport.PrintOptions.Duplex;;
    ShowModal;
    if ModalResult = mrOk then
    begin
      // frxReport.PrintOptions.Duplex := DuplexMode;
    end;
    Free;
  end;
end;

{ TFunction }

function TFunction.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: string; Caller: TfsMethodHelper): Variant;
begin
  if MethodName = 'RMB' then
    Result := RMB(Caller.Params[0])
end;

constructor TFunction.Create(AScript: TfsScript);
begin
  inherited;
  with AScript do
  begin
    AddMethod('function RMB(Num: Currency): String', CallMethod, 'App');
    // todo: ��Ӹ����ӡҪ�õĺ���
  end;
end;

procedure TReportModule.ClearDataSets;
var
  I: Integer;
begin
  with frxReport do
  begin
    for I := DataSets.Count - 1 downto 0 do
    begin
      DataSets.Items[I].DataSet.Free;
    end;
    DataSets.Clear;
  end;
end;

procedure TReportModule.PrintStream(AStream: TStream; const AReportName: string;
  APreviewIt: Boolean; const APrinter: string);
begin
  with frxReport do
  begin
    // ָ���ĵ�����
    FileName := AReportName;

    // ���ô�ӡ��
    Printer := APrinter;
    if APrinter = '' then
      Printer := FDefaultPrinter;

    // ������˳���������д��˳��һ��
    // LoadFromStream(AStream);
    PreviewPages.LoadFromStream(AStream);

    if APreviewIt and (PreviewPages.Count > 0) then
    begin
      PrintOptions.ShowDialog := True;
      ShowPreparedReport;
    end
    else
    begin
      // �ڱ���ģ����ָ���Ƿ�ShowDialog
      PrintOptions.ShowDialog := False;
      Print;
    end;
  end;
end;

function TReportModule.GetPrinter: string;
begin
  if (frxPrinters.PrinterIndex > -1) and (frxPrinters.Printers.Count > 0) then
    Result := frxPrinters.Printers[frxPrinters.PrinterIndex]
  else
    Result := '';
end;

procedure TReportModule.SetPrinter(const Value: string);
begin
  if frxPrinters.Printers.IndexOf(Value) > -1 then
    frxPrinters.PrinterIndex := frxPrinters.Printers.IndexOf(Value);
end;

function TReportModule.GetDefaultPrinter: string;
begin
  Result := FDefaultPrinter;
end;

function TReportModule.Evaluate(AExpression: string): Variant;
begin
  // �������ڶ��߳�
  fsScript.Parent := fsGlobalUnit;
  Result := fsScript.Evaluate(AExpression);
  if fsScript.EvaluteRiseError then
    raise Exception.Create(fsScript.ErrorMsg);
end;

initialization

fsRTTIModules.Add(TFunction);

end.
