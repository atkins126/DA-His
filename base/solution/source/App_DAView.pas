unit App_DAView;

{
  ���ݴ������

  Written by caowm (remobjects@qq.com)
  2014��9��
}

interface

uses
  SysUtils,
  Classes,
  Forms,
  Messages,
  Menus,
  Controls,
  Variants,
  ActnList,
  StrUtils,
  DB,
  ExtCtrls,
  Contnrs,
  Windows,
  IniFiles,
  uDAInterfaces,
  uDADataTable,
  uROClasses,
  uDAWhere,
  uDACore,
  uDAFields,
  cxDBData,
  cxDBEdit,
  cxEdit,
  cxCheckBox,
  cxTextEdit,
  cxCalendar,
  cxButtons,
  cxButtonEdit,
  cxSpinEdit,
  cxMemo,
  cxDropDownEdit,
  cxFilter,
  cxGrid,
  cxGridLevel,
  cxGridCustomView,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridDBTableView,
  cxGridBandedTableView,
  cxGridDBBandedTableView,
  cxGridCardView,
  cxGridDBCardView,
  cxGridChartView,
  cxGridDBChartView,
  cxDBPivotGrid,
  cxGridDBDataDefinitions,
  cxClasses,
  cxControls,
  cxCustomData,
  cxCustomPivotGrid,
  cxGridPopupMenu,
  cxGridCustomPopupMenu,
  cxTL,
  cxDBTL,
  dxBar,
  dxLayoutControl,
  dxLayoutContainer,
  App_Function,
  App_Common,
  App_DevExpress,
  App_Class,
  // App_DataWizard,
  App_DAModel;

const
  sDataNameMiscReport = 'Misc_Report';
  sDataNameMiscReportParam = 'Misc_ReportParam';

  sDataViewName_Table = 'TableView';
  sDataViewName_Card = 'CardView';
  sDataViewName_Tree = 'TreeView';
  sDataViewName_Form = 'FormView';

  sPopupViewName_DictIME = 'DictIME';
  sPopupViewName_AgeIME = 'AgeIME';

  sDeleteDataConfirm = 'ȷ��ɾ��������?';
  sControlHaveWrapped = '%s�ؼ��Ѱ�װ';

  sActionCategoryNavigate = 'Navigate';
  sActionCategoryData = 'Data';
  sActionCategoryBusiness = 'Business';

  sLayoutGroupOperation = '�������';
  sLayoutGroupInput = '�������';

const
  CM_TABLECELLCLICK = WM_USER + 1;

type

  // ����ͼ����������ɸѡ������ͬ������ͼ֮��������������
  TNavigateAction = (naFirst, naNext, naPrior, naLast);
  TNavigateDataEvent = procedure(Sender: TObject;
    NavigateAction: TNavigateAction) of object;

  {
    ������ͼ����

    1 ��������ʱ�Զ�������
    2 Ĭ��ʵ�ֱ���ӿ�
    3 Ĭ�ϴ������ֿؼ�����ݲ˵�������Action�������ֶ��б����ݹ����������˿ؼ�
    4 ����ʱ��οؼ�,�������ѯ����Ҫ��
    5 ��ǿ����ɸѡ��ѡ���ܣ��ֵ����������ĵط�������̳�
    ����һ���̶�ɸѡ�ֶΡ���Ӧ�ı���ɸѡ��
  }
  TCustomDataView = class(TBaseLayoutView)
  private
    FCustomData: TCustomData;
    FAutoEdit: Boolean;
    FViewPopupMenu: TdxBarPopupMenu;
    FOnNavigateData: TNavigateDataEvent;
    FOnDoubleClickView: TNotifyEvent;
    FBeginDateEdit: TcxDateEdit;
    FEndDateEdit: TcxDateEdit;

    FInserting: Boolean;
    FDeleting: Boolean;
    FEditing: Boolean;
    FQuerying: Boolean;
    FExporting: Boolean;
    FImporting: Boolean;
    FPrinting: Boolean;

    FViewGroup: TdxLayoutGroup;
    FToolBarGroup: TdxLayoutGroup;
    FViewActionGroup: TdxLayoutGroup;
    FFilterLayoutItem: TdxLayoutItem;
    FPeriodGroup: TdxLayoutGroup;
    FBeginDateItem: TdxLayoutItem;
    FEndDateItem: TdxLayoutItem;
    FClientGroup: TdxLayoutGroup;

    FFirstAction: TAction;
    FPriorAction: TAction;
    FNextAction: TAction;
    FLastAction: TAction;

    FInsertAction: TAction;
    FEditAction: TAction;
    FDeleteAction: TAction;
    FSaveAction: TAction;
    FCancelAction: TAction;
    FExportAction: TAction;
    FImportAction: TAction;
    FPrintAction: TAction;
    FQueryAction: TAction;
    FChartAction: TAction;

    FMultiSelectField: string; // ��ѡ�ֶ�����
    FMultiSelectCategoryField: string; // ��ѡ����ֶΣ���ĳһ���н��ж�ѡ��
    FMultiSelectCategoryFieldValue: Variant; // ��ǰ����ֶε�ֵ
    FSelectAllAction: TAction;
    FSelectNoneAction: TAction;
    FSelectInverseAction: TAction;

    FFilterFields: TStrings;
    FFilterButtonEdit: TcxButtonEdit;
    FOnFilterEnter: TNotifyEvent; // �����ֶΰ�Enter��ʱ����
    FFixFilterField: string;
    FFixFilterText: string;
    FFixFilterOp: TcxFilterOperatorKind;
    FShowPrintDialog: Boolean;

    FChartView: TCustomDataView;

    function GetFilterFields(): TStrings;
    procedure DoFilterChange(Sender: TObject);
    procedure DoFilterEditButton(Sender: TObject; AButtonIndex: Integer);
    procedure DoFilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function GetFilterText: string;
    procedure SetFilterText(const Value: string);
    procedure SetMultiSelectField(const Value: string);
    procedure RecordMultiSelectCategoryFieldValue();
    procedure EnumMultiSelectCount(ADataTable: TDADataTable; AParam: Variant);
    function GetBeginDate: TDateTime;
    function GetEndDate: TDateTime;
    procedure SetBeginDate(const Value: TDateTime);
    procedure SetEndDate(const Value: TDateTime);
  protected
    procedure CreateCloseAction();

    procedure OnFirstUpdate(Sender: TObject);
    procedure OnInsertUpdate(Sender: TObject);
    procedure OnEditUpdate(Sender: TObject);
    procedure OnDeleteUpdate(Sender: TObject);
    procedure OnSaveUpdate(Sender: TObject);
    procedure OnCancelUpdate(Sender: TObject);
    procedure OnQueryUpdate(Sender: TObject);
    procedure OnExportUpdate(Sender: TObject);
    procedure OnImportUpdate(Sender: TObject);
    procedure OnPrintUpdate(Sender: TObject);
    procedure OnSelectUpdate(Sender: TObject);

    procedure OnCloseExecute(Sender: TObject);
    procedure OnFirstExecute(Sender: TObject);
    procedure OnLastExecute(Sender: TObject);
    procedure OnPriorExecute(Sender: TObject);
    procedure OnNextExecute(Sender: TObject);
    procedure OnInsertExecute(Sender: TObject);
    procedure OnEditExecute(Sender: TObject);
    procedure OnDeleteExecute(Sender: TObject);
    procedure OnSaveExecute(Sender: TObject);
    procedure OnCancelExecute(Sender: TObject);
    procedure OnQueryExecute(Sender: TObject);
    procedure OnExportExecute(Sender: TObject);
    procedure DoImportExecute(Sender: TObject);
    procedure OnPrintExecute(Sender: TObject);
    procedure OnChartExecute(Sender: TObject);
    procedure OnSelectAllExecute(Sender: TObject); virtual;
    procedure OnSelectNoneExecute(Sender: TObject); virtual;
    procedure OnSelectInverseExecute(Sender: TObject); virtual;

    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    procedure DoMultiSelect(ADataTable: TDADataTable; AParam: Variant); virtual;
    procedure BuildFilterFields(); virtual;
    function DoNavigateEvent(NavigateAction: TNavigateAction): Boolean; virtual;

    procedure SetAutoEdit(AValue: Boolean); virtual;

    procedure SetDeleting(const Value: Boolean); virtual;
    procedure SetEditing(const Value: Boolean); virtual;
    procedure SetExporting(const Value: Boolean); virtual;
    procedure SetImporting(const Value: Boolean); virtual;
    procedure SetInserting(const Value: Boolean); virtual;
    procedure SetPrinting(const Value: Boolean); virtual;
    procedure SetQuerying(const Value: Boolean); virtual;

    procedure ResetActionCaption(AAction: TAction; const ACaption: string);

    procedure BuildViewLayout(); override;
    procedure BuildViewComponent(); virtual;
    procedure BuildViewAction(); virtual;
    procedure BuildViewToolBar(); virtual;
    procedure BuildViewPopupMenu(); virtual;
    procedure SetData(ACustomData: TCustomData); virtual;

  public
    destructor Destroy(); override;
    function GetPluginLayoutGroup(AOperation: TBaseOperation)
      : TComponent; override;

    function CanInsert(): Boolean; virtual;
    function CanEdit(): Boolean; virtual;
    function CanDelete(): Boolean; virtual;
    function CanSave(): Boolean; virtual;
    function CanCancel(): Boolean; virtual;
    function CanQuery(): Boolean; virtual;
    function CanExport(): Boolean; virtual;
    function CanImport(): Boolean; virtual;
    function CanPrint(): Boolean; virtual;
    function CanNavigate(): Boolean; virtual;

    procedure GoFirst(); virtual;
    procedure GoNext(); virtual;
    procedure GoPrior(); virtual;
    procedure GoLast(); virtual;
    procedure DataInsert(); virtual;
    procedure DataEdit(); virtual;
    function DataDelete(AAskConfirm: Boolean = True): Boolean; virtual;
    procedure DataSave(); virtual;
    procedure DataCancel(); virtual;
    procedure DataExport(); virtual;
    procedure DataImport(); virtual;
    procedure DataPrint(); virtual;
    procedure DataQuery(); virtual;
    procedure ShowChart(); virtual;

    function FieldByName(const AName: string): TDAField;
    function GetVisibleFields(): string; virtual;
    procedure SetVisibleFields(Fields: string); virtual;

    procedure DoLocalFilter(const AValue: string); virtual;
    procedure DoServerFilter(const AValue: string); virtual;
    procedure CheckSelected(); virtual;
    function GetMultiSelectCount: Integer;

    procedure SetActionVisible(AAction: TAction; AVisible: Boolean);
    procedure SetActionsVisible(AActionArray: array of TAction;
      AVisible: Boolean = True);
    procedure SetDataEditing(AValue: Boolean);
    function HaveDataAfterFilter(): Boolean; virtual;
    procedure SetFixFilter(AFieldName: string = ''; AFilterText: string = '';
      AOperator: TcxFilterOperatorKind = foEqual);

    procedure SaveViewLayout(AIniFile: TIniFile); virtual;
    procedure RestoreViewLayout(AIniFile: TIniFile); virtual;
    procedure SetFieldEditing(AFieldNames: array of string); virtual;
    procedure SetPeriodFormatYearMonth();
    procedure SetPeriodFormatYear();
    procedure SetOnlyOneDate();

    property FirstAction: TAction read FFirstAction;
    property PriorAction: TAction read FPriorAction;
    property NextAction: TAction read FNextAction;
    property LastAction: TAction read FLastAction;

    property InsertAction: TAction read FInsertAction;
    property DeleteAction: TAction read FDeleteAction;
    property EditAction: TAction read FEditAction;
    property SaveAction: TAction read FSaveAction;
    property CancelAction: TAction read FCancelAction;
    property ExportAction: TAction read FExportAction;
    property ImportAction: TAction read FImportAction;
    property PrintAction: TAction read FPrintAction;
    property QueryAction: TAction read FQueryAction;
    property ChartAction: TAction read FChartAction;

    property SelectAllAction: TAction read FSelectAllAction;
    property SelectNoneAction: TAction read FSelectNoneAction;
    property SelectInverseAction: TAction read FSelectInverseAction;

    property Inserting: Boolean read FInserting write SetInserting;
    property Deleting: Boolean read FDeleting write SetDeleting;
    property Editing: Boolean read FEditing write SetEditing;
    property Querying: Boolean read FQuerying write SetQuerying;
    property Exporting: Boolean read FExporting write SetExporting;
    property Importing: Boolean read FImporting write SetImporting;
    property Printing: Boolean read FPrinting write SetPrinting;

    property ViewData: TCustomData read FCustomData write SetData;
    property BeginDateEdit: TcxDateEdit read FBeginDateEdit;
    property EndDateEdit: TcxDateEdit read FEndDateEdit;
    property FilterEdit: TcxButtonEdit read FFilterButtonEdit;
    property ViewPopupMenu: TdxBarPopupMenu read FViewPopupMenu;

    property ViewGroup: TdxLayoutGroup read FViewGroup;
    property ToolBarGroup: TdxLayoutGroup read FToolBarGroup;
    property ActionGroup: TdxLayoutGroup read FViewActionGroup;
    property FilterEditItem: TdxLayoutItem read FFilterLayoutItem;
    property PeriodGroup: TdxLayoutGroup read FPeriodGroup;
    property BeginDateItem: TdxLayoutItem read FBeginDateItem;
    property EndDateItem: TdxLayoutItem read FEndDateItem;
    property ClientGroup: TdxLayoutGroup read FClientGroup;

    property AutoEdit: Boolean read FAutoEdit write SetAutoEdit;
    property FilterFields: TStrings read GetFilterFields;
    property FilterText: string read GetFilterText write SetFilterText;
    property FixFilterField: string read FFixFilterField;
    property FixFilterText: string read FFixFilterText;
    property MultiSelectField: string read FMultiSelectField
      write SetMultiSelectField; // ��ѡ�ֶ�
    property MultiSelectCategoryField: string read FMultiSelectCategoryField
      write FMultiSelectCategoryField; // ��ѡ����ֶ�
    property ShowPrintDialog: Boolean read FShowPrintDialog
      write FShowPrintDialog;
  published
    property BeginDate: TDateTime read GetBeginDate write SetBeginDate;
    property EndDate: TDateTime read GetEndDate write SetEndDate;
    property OnNavigateData: TNavigateDataEvent read FOnNavigateData
      write FOnNavigateData;
    property OnFilterPressEnter: TNotifyEvent read FOnFilterEnter
      write FOnFilterEnter;
    property OnDoubleClickView: TNotifyEvent read FOnDoubleClickView
      write FOnDoubleClickView;

  end;

  TCustomDataPrintProc = procedure(Sender: TCustomData;
    ShowPrintDialog: Boolean);
  TCustomDataViewClass = class of TCustomDataView;

  {
    ��������ͼ
    1 ����Schema�Զ������༭��
    2 �ṩ�Ի���ģʽ�����߶��Զ���Ӧ
  }
  TFormDataView = class(TCustomDataView)
  private
    FImage: TImage;
    FEditorGroup: TdxLayoutGroup;
    FEditorContainer: TdxLayoutGroup;
    FImageItem: TdxLayoutItem;

    FOKButton: TcxButton;
    FCancelButton: TcxButton;
    FOKItem: TdxLayoutItem;
    FCancelItem: TdxLayoutItem;
    FBottomGroup: TdxLayoutGroup;

    procedure DoFormShow(Sender: TObject);
    procedure DoFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetViewImage(const Value: string);
  protected
    procedure BuildViewComponent(); override;
    procedure BuildViewAction(); override;
    procedure BuildViewPopupMenu(); override;
    procedure SetData(ACustomData: TCustomData); override;

    procedure DoOKClick(Sender: TObject); virtual;
    procedure DoCancelClick(Sender: TObject); virtual;

    procedure BuildDataEditor(); virtual;
  public
    property EditorGroup: TdxLayoutGroup read FEditorGroup;
    property Image: TImage read FImage;
    property ImageName: string write SetViewImage;
    property OKButton: TcxButton read FOKButton;
    property CancelButton: TcxButton read FCancelButton;
    property BottomGroup: TdxLayoutGroup read FBottomGroup;
    property OKItem: TdxLayoutItem read FOKItem;
    property CancelItem: TdxLayoutItem read FCancelItem;
  end;

  TFormDataViewClass = class of TFormDataView;

  {
    ��TcxGrid��Ϊ������������ͼ����
    1 ������Ӧ���ݱ���ͼ�����UseFormForEditing=True, ��ô�ڱ༭ʱ���Զ��򿪱���ͼ
    2 �Զ�����ViewData.TriggerScroll
    3 �Զ�����TcxButtonEdit�¼�
    4 ����ÿ��ѡ��ļ�¼��ForEachSelected, ���ڶ�ѡ����
  }
  TCustomGridDataView = class(TCustomDataView)
  private
    FGridLayoutItem: TdxLayoutItem;
    FGrid: TcxGrid;
    FGridPopupMenu: TcxGridPopupMenu;
    FGridView: TcxCustomGridView;
    FGridViewPopupMenu: TPopupMenu;
    FFormViewClass: TFormDataViewClass;
    FFormView: TFormDataView;
    FFormViewAction: TAction;
    FUseFormForEditing: Boolean;
    FOnRecordScroll: TNotifyEvent;
    FOptionsDataEditing: Boolean;

    function GetFormView(): TFormDataView;
    procedure SyncFormData();
    procedure DoMenuItemExpandAll(Sender: TObject);
    procedure DoMenuItemCollapseAll(Sender: TObject);
    procedure DoGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoTableCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure DoFocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  protected
    FViewClass: TcxCustomGridViewClass;

    procedure BuildViewComponent(); override;
    procedure BuildViewAction(); override;
    procedure BuildFilterFields(); override;

    function GetDataController(): TcxGridDBDataController; virtual;
    procedure BuildEditButtonEvent(); virtual;
    procedure DoGridNavigate(Sender: TObject;
      NavigateAction: TNavigateAction); virtual;
    procedure DoActionShowFormView(Sender: TObject); virtual;
    procedure DoEditButtonClick(Sender: TObject;
      AButtonIndex: Integer); virtual;

    procedure DoTableCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean); virtual;

    procedure DoTableCellClickMsg(var Msg: TMessage); message CM_TABLECELLCLICK;

    procedure ConfigViewAfterData(); virtual;
  public
    procedure GoFirst(); override;
    procedure GoNext(); override;
    procedure GoPrior(); override;
    procedure GoLast(); override;

    function CanEdit(): Boolean; override;
    function CanDelete(): Boolean; override;
    procedure DataInsert(); override;
    procedure DataEdit(); override;
    procedure DataQuery(); override;
    function DataDelete(AAskConfirm: Boolean = True): Boolean; override;
    procedure DataExport(); override;
    function HaveDataAfterFilter(): Boolean; override;
    procedure DoLocalFilter(const AValue: string); override;

    procedure ExtractNameAndKeyValue(const ANameFields, AKeyField: string;
      ADest: TStrings);
    procedure SaveViewLayout(AIniFile: TIniFile); override;
    procedure RestoreViewLayout(AIniFile: TIniFile); override;
    procedure SetFieldEditing(AFieldNames: array of string); override;
    procedure FocusFirstVisibleColumn(); virtual;
    procedure ForEachSelected(AProc: TNotifyEvent);

    property FormViewAction: TAction read FFormViewAction;
    property Grid: TcxGrid read FGrid;
    property GridPopupMenu: TcxGridPopupMenu read FGridPopupMenu;
    property GridView: TcxCustomGridView read FGridView;
    property GridViewPopupMenu: TPopupMenu read FGridViewPopupMenu;
    property DataController: TcxGridDBDataController read GetDataController;
    property GridLayoutItem: TdxLayoutItem read FGridLayoutItem;
    property FormView: TFormDataView read GetFormView;
    property FormViewClass: TFormDataViewClass read FFormViewClass
      write FFormViewClass;
    property UseFormForEditing: Boolean read FUseFormForEditing
      write FUseFormForEditing;
    property OnRecordScroll: TNotifyEvent read FOnRecordScroll
      write FOnRecordScroll;
    property OptionsDataEditing: Boolean read FOptionsDataEditing
      write FOptionsDataEditing;
  end;

  { ���������ͼ }
  TTableGridDataView = class(TCustomGridDataView)
  private
    FLastReporterGroupValue: string;
    FView: TcxGridDBTableView;
    procedure DoDataPrint(Sender: TObject);
  protected
    procedure BuildViewComponent(); override;
    procedure BuildViewPopupMenu(); override;
    procedure SetData(Data: TCustomData); override;
    procedure SetAutoEdit(AValue: Boolean); override;
    function GetDataController(): TcxGridDBDataController; override;
  public
    function CanQuery(): Boolean; override;
    procedure DataInsert(); override;
    procedure DataEdit(); override;
    procedure DataPrint(); override;
    function GetVisibleFields(): string; override;
    procedure SetVisibleFields(Fields: string); override;
    procedure SaveViewLayout(AIniFile: TIniFile); override;
    procedure RestoreViewLayout(AIniFile: TIniFile); override;

    procedure EnableMultiSelect();
    procedure DisableMultiSelect();

    property TableView: TcxGridDBTableView read FView;
  end;

  { Band���������ͼ }
  TBandGridDataView = class(TCustomGridDataView)
  private
    FView: TcxGridDBBandedTableView;
  protected
    procedure BuildViewComponent(); override;
    procedure BuildViewPopupMenu(); override;
    procedure SetData(Data: TCustomData); override;
    procedure SetAutoEdit(AValue: Boolean); override;
    function GetDataController(): TcxGridDBDataController; override;
  public
    function CanQuery(): Boolean; override;
    procedure DataInsert(); override;
    procedure DataEdit(); override;
    function GetVisibleFields(): string; override;
    procedure SaveViewLayout(AIniFile: TIniFile); override;
    procedure RestoreViewLayout(AIniFile: TIniFile); override;

    procedure EnableMultiSelect();
    procedure DisableMultiSelect();

    property BandView: TcxGridDBBandedTableView read FView;
  end;

  { ��Ƭ������ͼ }
  TCardGridDataView = class(TCustomGridDataView)
  private
    FView: TcxGridDBCardView;
  protected
    procedure BuildViewComponent(); override;
    procedure BuildViewPopupMenu(); override;
    procedure SetData(Data: TCustomData); override;
    procedure SetAutoEdit(AValue: Boolean); override;
    function GetDataController(): TcxGridDBDataController; override;
  public
    procedure DataInsert(); override;
    procedure DataEdit(); override;
    function CanQuery(): Boolean; override;
    procedure SaveViewLayout(AIniFile: TIniFile); override;
    procedure RestoreViewLayout(AIniFile: TIniFile); override;

    property CardView: TcxGridDBCardView read FView;
  end;

  {
    ͼ��������ͼ

    1 ���Զ���ͼ��ʱ����Access Violation, �޸����´��룺
    Unit cxGridChartView
    constructor TcxGridChartOptionsTreeView.Create
    ע�����У�Style.HotTrack := False;
  }
  TChartGridDataView = class(TCustomGridDataView)
  private
    FView: TcxGridDBChartView;
  protected
    procedure BuildViewComponent(); override;
    procedure BuildViewPopupMenu(); override;
    procedure BuildViewToolBar(); override;
    procedure SetData(Data: TCustomData); override;
  public
    function CanInsert(): Boolean; override;
    function CanEdit(): Boolean; override;
    function CanDelete(): Boolean; override;
    property ChartView: TcxGridDBChartView read FView;
  end;

  { ������������ͼ }
  TPivotDataView = class(TCustomDataView)
  private
    FPivot: TcxDBPivotGrid;
    FPivotLayoutItem: TdxLayoutItem;
    FGridLayoutItem: TdxLayoutItem;
  protected
    procedure BuildViewComponent(); override;
    procedure BuildViewToolBar(); override;
    procedure BuildViewPopupMenu(); override;
    procedure SetData(Data: TCustomData); override;
  public
    function CanInsert(): Boolean; override;
    function CanEdit(): Boolean; override;
    function CanDelete(): Boolean; override;
    function CanExport(): Boolean; override;
    procedure DataExport(); override;
    property PivotGrid: TcxDBPivotGrid read FPivot;
    property PivotLayoutItem: TdxLayoutItem read FGridLayoutItem;
  end;

  {
    ����������ͼ

    ��Node�����ı�ʱ����ViewData.TriggerScroll
  }
  TTreeDataView = class(TCustomDataView)
  private
    FTreeView: TcxDBTreeList;
    FOnRecordScroll: TNotifyEvent;
    FOptionsDataEditing: Boolean;
    procedure DoFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure DoTreeDblClick(Sender: TObject);
  protected
    FTreeLayoutItem: TdxLayoutItem;
    procedure BuildViewComponent(); override;
    procedure BuildFilterFields(); override;
    procedure SetData(Data: TCustomData); override;
    procedure SetAutoEdit(AValue: Boolean); override;
  public
    procedure GoFirst(); override;
    procedure GoNext(); override;
    procedure GoPrior(); override;
    procedure GoLast(); override;

    function CanQuery(): Boolean; override;
    function CanExport(): Boolean; override;
    procedure DataInsert(); override;
    procedure DataEdit(); override;
    function DataDelete(AAskConfirm: Boolean = True): Boolean; override;
    procedure DataExport(); override;
    procedure DoLocalFilter(const AValue: string); // override;
    property TreeView: TcxDBTreeList read FTreeView;
    property TreeLayoutItem: TdxLayoutItem read FTreeLayoutItem;
    property OnRecordScroll: TNotifyEvent read FOnRecordScroll
      write FOnRecordScroll;
    property OptionsDataEditing: Boolean read FOptionsDataEditing
      write FOptionsDataEditing;
  end;

  {
    ����������ͼҵ��

    1 ViewClass���Բ����ã�����Schemaָ����ͼ����
    2 ��ָ�����ݣ�����ָ��CommonDataContainer�е�����
  }
  TDataViewOperation = class(TViewOperation)
  private
    FCustomData: TCustomData;
    FOwnsData: Boolean;
  protected
    function GetViewClass(): TBaseViewClass; override;
    function GetView(): TBaseView; override;
  public
    destructor Destroy(); override;

    property ViewData: TCustomData read FCustomData write FCustomData;
    property OwnsData: Boolean read FOwnsData write FOwnsData;
  end;

  {
    �����ֵ�ά����ͼ

    ����CustomData��Schema�Ķ�������ʾ��ͬ����ͼ
    ÿ������һ����ͼ
  }
  TDictManageView = class(TBaseLayoutView)
  private
    FDictTree: TcxTreeList;
    FViewLayoutItem: TdxLayoutItem;

    procedure DoTreeChange(Sender: TObject);
    procedure BuildTree();
  protected
    procedure BuildViewLayout(); override;
    procedure BuildViewComponent();
  public
    destructor Destroy(); override;
    procedure LocateDict(const ALogicalName: string);
  end;

  TPopupEditorWrapper = class;
  TPopupEditorWrapInfo = class;

  IPopupEditorForm = interface
    ['{5BD2A9A0-DC98-45F4-A517-125F85E83CF0}']
    procedure DoPopupInit(Sender: TPopupEditorWrapInfo);
    procedure DoPopup(Sender: TPopupEditorWrapInfo);
    procedure DoPopupClose(Sender: TPopupEditorWrapInfo);
    function DoModalDialog(Sender: TPopupEditorWrapInfo;
      const AFilterText: string): Boolean;
  end;

  {
    ��������ѡ��

    ��ע��������ͼ�������������롢ѡ��
  }
  TDictIMEDialog = class(TBaseDialog, IPopupEditorForm)
  private
    FRegisteredDataView: TStrings;

    FOpened: Boolean;
    FOldWidth: Integer;
    FOldHeight: Integer;
    FDictName: string;
    FDictData: TCustomData;
    FNotifier: TNotifyEvent;
    FCurView: TCustomDataView;
    FViewItem: TdxLayoutItem;

    FPopupWrapInfo: TPopupEditorWrapInfo;

    procedure DoFormResize(Sender: TObject);
  protected
    procedure DoDialogOK(Sender: TObject); override;
    procedure DoDialogCancel(Sender: TObject); override;

    function GetDataView(AViewName: string): TCustomDataView;
    procedure RestoreDict();
    procedure SaveDict();
    procedure FocusFilter();
    procedure EditData();

    procedure DoPopupOK(Sender: TObject);
    { IPopupEditorForm }
    procedure DoPopupInit(Sender: TPopupEditorWrapInfo);
    procedure DoPopup(Sender: TPopupEditorWrapInfo);
    procedure DoPopupClose(Sender: TPopupEditorWrapInfo);
    function DoModalDialog(Sender: TPopupEditorWrapInfo;
      const AFilterText: string): Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure RegisterDataView(AViewName: string;
      AViewClass: TCustomDataViewClass);

    function Start(ASender: TControl; ADataName, AViewName, AFilterText: string;
      ANotifier: TNotifyEvent): Boolean;

    function StartIME(ASender: TControl; ACustomData: TCustomData;
      AViewName, AFilterText: string; ANotifier: TNotifyEvent;
      AShowOnly: Boolean): Boolean;

    // �ֵ�����ɹ��󽫷����ֵ����ݣ�����Ϊnil
    property DictData: TCustomData read FDictData;
  end;

  { �������� }
  TAgeIMEDialog = class(TBaseDialog, IPopupEditorForm)
  private
    FAgeEdit: TcxSpinEdit;
    FNotifier: TNotifyEvent;
    FPopupWrapInfo: TPopupEditorWrapInfo;
    procedure EditData();
    procedure DoPopupOK(Sender: TObject);
  protected
    procedure DoDialogOK(Sender: TObject); override;
    procedure DoDialogCancel(Sender: TObject); override;
    procedure BuildDialog; override;
    { IPopupEditorForm }
    procedure DoPopupInit(Sender: TPopupEditorWrapInfo);
    procedure DoPopup(Sender: TPopupEditorWrapInfo);
    procedure DoPopupClose(Sender: TPopupEditorWrapInfo);
    function DoModalDialog(Sender: TPopupEditorWrapInfo;
      const AFilterText: string): Boolean;
  public
    function Start(ASender: TControl; ANotifier: TNotifyEvent): Boolean;
  end;

  {
    ���ݰ󶨿ؼ��������ͼ�����ֵ����뷨��װ��Ϣ

    1 ����PopupEdit�����õ���ʽ�༭��
    2 �����ͨ�༭��������ģʽ�Ի���
  }
  TPopupEditorWrapInfo = class(TWrapInfo)
  private
    FProperties: TcxCustomEditProperties;
    FDataSource: TDADataSource;
    FDataTable: TDADataTable;
    FField: TDAField;
    FButtonAction: TAction;
    FClearAction: TAction;
    FOldGridEditKeyEvent: TcxGridEditKeyPressEvent;
    FPopupControl: TObject;
    FEditorName: string;
    FPopupEditorForm: TForm;
    FGetValueFields: TStrings;
    FSetValueFields: TStrings;
    FDictName: string;
    FDictTable: TDADataTable;
    FMultiEditorAttributes: TStrings;
    FFreeEditing: Boolean; // �Ƿ�����ɱ༭�������ü����¼�
    FFreeAppending: Boolean; // ���ɷ�ʽ�������Ƿ�ϲ���ȥ������Ϊ�滻
    FFreeAppendChar: string;

    procedure ShowModalPopuForm(const AFilterText: string);
    procedure DoButtonAction(Sender: TObject);
    procedure DoActionClear(Sender: TObject);
    function GetButtonAction: TAction;
    function GetClearAction: TAction;
    procedure DoPopupEnter(Sender: TObject);
  protected
    procedure EditData();
    procedure ClearData();
    procedure DoGridEditKeyPress(Sender: TcxCustomGridTableView;
      AItem: TcxCustomGridTableItem; AEdit: TcxCustomEdit; var Key: Char);
  public
    constructor Create(ATarget: TComponent); override;
    destructor Destroy(); override;
    procedure Wrap(); override;

    procedure DoKeyPress(Sender: TObject; var Key: Char);
    procedure DoPopupOK(Sender: TObject);
    procedure DoPopup(Sender: TObject);
    procedure DoPopupInit(Sender: TObject);
    procedure ClosePopup();
    procedure DoPopupClose(Sender: TcxControl; AReason: TcxEditCloseUpReason);

    property ButtonAction: TAction read GetButtonAction;
    property ClearAction: TAction read GetClearAction;
    property DataSource: TDADataSource read FDataSource write FDataSource;
    property DataTable: TDADataTable read FDataTable write FDataTable;
    property Properties: TcxCustomEditProperties read FProperties
      write FProperties;
    property Field: TDAField read FField write FField;
    property SetValueField: TStrings read FSetValueFields;
    property GetValueField: TStrings read FGetValueFields;
    property DictName: string read FDictName write FDictName;
    property MultiEditorAttributes: TStrings read FMultiEditorAttributes;
  end;

  { ����ʽ�ֵ����뷨��װ�� }
  TPopupEditorWrapper = class(TControlWrapper)
  private
    FRegisteredEditor: TStrings;
    FCreatedEditor: TStrings;
    FOldOnWrapProperties: TOnWrapProperties;
  protected
    function GetWrapInfoClass(): TWrapInfoClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure WrapDataControl(AControl: TComponent;
      AProperties: TcxCustomEditProperties; AField: TDAField;
      ASource: TDADataSource; AMultiEditorAttributes: TStrings);

    procedure WrapProperites(AColumn: TComponent;
      AProperties: TcxCustomEditProperties; AField: TDAField;
      ASource: TDADataSource; AMultiEditorAttributes: TStrings);

    procedure RegisterPopupEditor(const AEditorName: string;
      AEditor: TFormClass);
    function GetPopupEditor(const AEditorName: string): TForm;
  end;

  {
    ��ӡ������ͼ

    ʹ��ǰ��ע�ṫ�����ݣ�Misc_Report, Misc_ReportParam
  }
  TReportConfigView = class(TBaseLayoutView)
  private
    FReportData: TCustomData;
    FParamData: TCustomData;
    FReportView: TTableGridDataView;
    FParamView: TTableGridDataView;
    FOnPrint: TNotifyEvent;

    function BuildLocalParamData(): TCustomData;
    function BuildLocalReportData(): TCustomData;
    function GetReportName: string;
  protected
    procedure BuildViewLayout(); override;
    procedure DoPrintReport(Sender: TObject); virtual;
  public
    function GetParamNameArray(): TVariantArray;
    function GetParamValueArray(): TVariantArray;

    property ReportName: string read GetReportName;
    property ReportView: TTableGridDataView read FReportView;
    property ParamView: TTableGridDataView read FParamView;
    property OnPrint: TNotifyEvent read FOnPrint write FOnPrint;
  end;

function DictIME: TDictIMEDialog;

function GetDataViewClass(ADataViewType: TDataViewType): TCustomDataViewClass;

function EditData(ACustomData: TCustomData): Boolean;

var
  PopupEditorWrapper: TPopupEditorWrapper; // �ֵ������װ��
  CustomDataPrintProc: TCustomDataPrintProc;

implementation

{$WARNINGS OFF}

type
  TcxCustomEditAccess = class(TcxCustomEdit);

var
  EditDataView: TFormDataView;

function EditData(ACustomData: TCustomData): Boolean;
begin
  if EditDataView = nil then
  begin
    EditDataView := TFormDataView.Create(Application);
    EditDataView.Position := poMainFormCenter;
    EditDataView.BorderStyle := bsDialog;
  end;
  EditDataView.Caption := ACustomData.Description;
  EditDataView.ViewData := ACustomData;
  Result := EditDataView.ShowModal = mrOk;
end;

function DictIME: TDictIMEDialog;
begin
  Result := TDictIMEDialog(PopupEditorWrapper.GetPopupEditor
    (sPopupViewName_DictIME));
end;

{
  AFilterFields����Ҫ���˵��ֶκͶ�Ӧ��
  AFixFilterField: �̶��Ĺ����ֶ�
  AFixFilterText: �̶��Ĺ����ı�
  ��TreeList�е�Filter��Ч????
}

procedure BuildFilter(AFilter: TcxDataFilterCriteria; AFilterFields: TStrings;
  const AText: string; const AFixFilterField: string = '';
  const AFixFilterText: string = '';
  AFixFilterOp: TcxFilterOperatorKind = foEqual);
var
  I: Integer;
  FilterRoot: TcxFilterCriteriaItemList;
begin
  with AFilter do
  begin
    Active := False;
    Root.Clear;
    if (AText = '') and (AFixFilterField = '') then
      Exit;

    if AFixFilterField <> '' then
    begin
      Root.BoolOperatorKind := fboAnd;
      Root.AddItem(TcxDBDataController(AFilter.DataController)
        .GetItemByFieldName(AFixFilterField), AFixFilterOp, AFixFilterText,
        AFixFilterField);
      FilterRoot := Root.AddItemList(fboOr);
    end
    else
    begin
      Root.BoolOperatorKind := fboOr;
      FilterRoot := Root;
    end;

    if (AText <> '') then
      for I := 0 to AFilterFields.Count - 1 do
        FilterRoot.AddItem(AFilterFields.Objects[I], foLike, '%' + AText + '%',
          AFilterFields[I]);

    Active := True;
  end;
end;

function GetDataViewClass(ADataViewType: TDataViewType): TCustomDataViewClass;
const
  ViewClassArray: array [TDataViewType] of TCustomDataViewClass =
    (TTableGridDataView, TBandGridDataView, TCardGridDataView,
    TChartGridDataView, TTreeDataView, TPivotDataView, TFormDataView);
begin
  if Integer(ADataViewType) > Integer(dvForm) then
    ADataViewType := dvForm;
  if Integer(ADataViewType) < 0 then
    ADataViewType := dvGrid;
  Result := ViewClassArray[ADataViewType];
end;

{ TCustomDataView }

procedure TCustomDataView.BuildFilterFields;
var
  I: Integer;
begin
  {
    ���������ֶ��б�
    ����ɽ�һ���Ż�
    �����������ʱ���ô˹���
  }
  FilterFields.Clear;
  if ViewData = nil then
    Exit;

  // һ������ģ�Ϳ������ڶ����ͼ�У����ÿ����ͼ�������Լ��Ĺ����ֶ�
  FilterFields.AddStrings(ViewData.FilterFields);
  // ���û�ж�������ֶΣ����Զ���������ı��ֶ�
  if FilterFields.Count = 0 then
    for I := 0 to ViewData.Table.Fields.Count - 1 do
    begin
      if ViewData.Table.Fields[I].DataType in [datString, datWideString] then
        FilterFields.Add(ViewData.Table.Fields[I].Name);
    end;
end;

{ ��װAction }
procedure TCustomDataView.BuildViewAction;
begin
  FFirstAction := BuildAction('��һ��', 'first', '', OnFirstUpdate, OnFirstExecute,
    ShortCut(VK_UP, [ssAlt, ssShift]), 0);
  FPriorAction := BuildAction('��һ��', 'prior', '', OnFirstUpdate, OnPriorExecute,
    ShortCut(VK_UP, [ssAlt]), 0);
  FNextAction := BuildAction('��һ��', 'next', '', OnFirstUpdate, OnNextExecute,
    ShortCut(VK_DOWN, [ssAlt]), 0);
  FLastAction := BuildAction('���һ��', 'last', '', OnFirstUpdate, OnLastExecute,
    ShortCut(VK_DOWN, [ssAlt, ssShift]), 0);
  FFirstAction.Visible := False;
  FPriorAction.Visible := False;
  FNextAction.Visible := False;
  FLastAction.Visible := False;

  FQueryAction := BuildAction('ˢ��', 'query', '', OnQueryUpdate, OnQueryExecute,
    ShortCut(Ord('Q'), [ssCtrl]), BTN_SHOWCAPTION);
  FExportAction := BuildAction('����', 'export', '', OnExportUpdate,
    OnExportExecute, 0, BTN_NOPOPUPMENU);
  FImportAction := BuildAction('����', 'import', '', OnImportUpdate,
    DoImportExecute, 0, BTN_SHOWCAPTION or BTN_NOPOPUPMENU);
  FPrintAction := BuildAction('��ӡ', 'print', '', OnPrintUpdate, OnPrintExecute,
    ShortCut(Ord('P'), [ssCtrl]), BTN_SHOWCAPTION);
  FCancelAction := BuildAction('ȡ��', 'cancel', '', OnCancelUpdate,
    OnCancelExecute, 0, BTN_SHOWCAPTION or BTN_NOPOPUPMENU);
  FSaveAction := BuildAction('����', 'post', '', OnSaveUpdate, OnSaveExecute,
    ShortCut(Ord('S'), [ssCtrl]), BTN_SHOWCAPTION or BTN_NOPOPUPMENU);
  FEditAction := BuildAction('�༭', 'edit', '', OnEditUpdate, OnEditExecute,
    ShortCut(VK_F2, []), BTN_SHOWCAPTION);
  FDeleteAction := BuildAction('ɾ��', 'del', '', OnDeleteUpdate, OnDeleteExecute,
    ShortCut(VK_DELETE, [ssCtrl]), BTN_SHOWCAPTION or BTN_NOPOPUPMENU);
  FInsertAction := BuildAction('����', 'add', '', OnInsertUpdate, OnInsertExecute,
    ShortCut(VK_F8, []), BTN_SHOWCAPTION);
  FChartAction := BuildAction('ͼ��', 'chart', '', nil, OnChartExecute, 0,
    BTN_SHOWCAPTION);
  FChartAction.GroupIndex := 1;

  FImportAction.Visible := False;
  FPrintAction.Visible := False;
  FSaveAction.Visible := False;
  FCancelAction.Visible := False;
  FDeleteAction.Visible := False;
  FEditAction.Visible := False;
  FInsertAction.Visible := False;
  FChartAction.Visible := False;

  FSelectAllAction := BuildAction('ȫѡ', 'select_all', '', OnSelectUpdate,
    OnSelectAllExecute, 0, BTN_SHOWCAPTION);
  FSelectNoneAction := BuildAction('��ѡ', 'select_none', '', OnSelectUpdate,
    OnSelectNoneExecute, 0, BTN_SHOWCAPTION);
  FSelectInverseAction := BuildAction('��ѡ', 'select_inverse', '',
    OnSelectUpdate, OnSelectInverseExecute, 0, BTN_SHOWCAPTION);
  FSelectAllAction.Visible := False;
  FSelectNoneAction.Visible := False;
  FSelectInverseAction.Visible := False;
end;

{ ��װ������ }

procedure TCustomDataView.BuildViewToolBar;
begin
  {
    ע�⣺ֻ����BarManager����֮����ܵ��á���BarManagerֻ�����������д�����
    ��ֻ�������崴������ܵ���BuildViewToolBar��BuildViewPopupMenu����ͬ��;
  }
  BuildLayoutToolBar(FViewActionGroup, ViewActions);
end;

{ ��װ��ͼ }

procedure TCustomDataView.BuildViewComponent;
begin
  if FFilterButtonEdit = nil then
  begin
    FFilterButtonEdit := TcxButtonEdit.Create(Self);
    FFilterButtonEdit.OnKeyDown := DoFilterKeyDown;
    with FFilterButtonEdit.Properties do
    begin
      Buttons[0].Caption := '��';
      Buttons[0].Kind := bkText;
      MaxLength := 20;
      OnChange := DoFilterChange;
      OnButtonClick := DoFilterEditButton;
      ClearKey := ShortCut(VK_DELETE, []);
    end;

    FBeginDateEdit := TcxDateEdit.Create(Self);
    FEndDateEdit := TcxDateEdit.Create(Self);
    FBeginDateEdit.Date := Date();
    FEndDateEdit.Date := Date();

    FViewPopupMenu := TdxBarPopupMenu.Create(Self);
    FViewPopupMenu.BarManager := DevExpress.BarManager;

    with ViewLayout do
    begin
      FViewGroup := Items.CreateGroup();
      with FViewGroup do
      begin
        AlignHorz := ahClient;
        AlignVert := avClient;
        ShowBorder := False;

        // �������������
        FToolBarGroup := CreateGroup();
        with FToolBarGroup do
        begin
          LayoutDirection := ldHorizontal;
          ShowBorder := False;

          // ����ʱ��β�ѯ���
          FPeriodGroup := CreateGroup();
          with FPeriodGroup do
          begin
            Visible := False;
            ShowBorder := False;
            LayoutDirection := ldHorizontal;
            AlignVert := avCenter;
            FBeginDateItem := CreateItemForControl(FBeginDateEdit);
            with FBeginDateItem do
            begin
              Caption := '��ʼʱ��:';
              AlignVert := avCenter;
            end;
            FEndDateItem := CreateItemForControl(FEndDateEdit);
            with FEndDateItem do
            begin
              Caption := '����ʱ��:';
              AlignVert := avCenter;
            end;
          end;

          FViewActionGroup := CreateGroup();
          FViewActionGroup.ShowBorder := False;
          FViewActionGroup.LayoutDirection := ldHorizontal;

          // ����ɸѡ���
          FFilterLayoutItem := CreateItemForControl(FFilterButtonEdit);
          with FFilterLayoutItem do
          begin
            AlignVert := avCenter;
            Caption := 'ɸѡ:';
            Visible := False;
          end;
        end;

        FClientGroup := CreateGroup();
        with FClientGroup do
        begin
          // LayoutDirection := ldTabbed;
          ShowBorder := False;
          AlignHorz := ahClient;
          AlignVert := avClient;
        end;
      end; // ViewGroup

    end;
  end;
end;

{ ��װ�����˵� }
procedure TCustomDataView.BuildViewPopupMenu;
begin
  BuildBarPopupMenu(Self, ViewPopupMenu, ViewActions, '');
end;

function TCustomDataView.CanCancel: Boolean;
begin
  Result := (FCustomData <> nil) and FCustomData.CanCancel;
end;

function TCustomDataView.CanDelete: Boolean;
begin
  Result := FDeleting and (FCustomData <> nil) and FCustomData.CanDelete;
end;

function TCustomDataView.CanEdit: Boolean;
begin
  Result := FEditing and (FCustomData <> nil) and FCustomData.CanEdit;
end;

function TCustomDataView.CanExport: Boolean;
begin
  Result := FExporting and (FCustomData <> nil) and FCustomData.Table.Active;
end;

function TCustomDataView.CanImport: Boolean;
begin
  Result := FImporting and (FCustomData <> nil) and FCustomData.Table.Active;
end;

function TCustomDataView.CanInsert: Boolean;
begin
  Result := FInserting and (FCustomData <> nil) and FCustomData.CanInsert;
end;

function TCustomDataView.CanPrint: Boolean;
begin
  Result := FPrinting or ((FCustomData <> nil) and FCustomData.CanPrint());
end;

function TCustomDataView.CanQuery: Boolean;
begin
  Result := FQuerying and (FCustomData <> nil) and FCustomData.CanQuery;
end;

function TCustomDataView.CanSave: Boolean;
begin
  Result := (FCustomData <> nil) and FCustomData.CanSave;
end;

procedure TCustomDataView.DataCancel();
begin
  FCustomData.Cancel;
end;

function TCustomDataView.DataDelete(AAskConfirm: Boolean = True): Boolean;
begin
  Result := False;
  if not AAskConfirm or ShowYesNo(Caption + ': ' + sDeleteDataConfirm) then
  begin
    FCustomData.Delete;
    Result := True;
  end;
end;

procedure TCustomDataView.DataEdit();
begin
  if FCustomData <> nil then
    FCustomData.Edit;
end;

procedure TCustomDataView.DataExport();
begin
  if DataExportWizard <> nil then
    DataExportWizard.ExportData(ViewData.Table.Dataset, GetVisibleFields);
end;

procedure TCustomDataView.DataImport;
begin
  if DataImportWizard <> nil then
    DataImportWizard.ImportData(ViewData.Table.Dataset, GetVisibleFields,
      ViewData.KeyFieldNames);
end;

procedure TCustomDataView.DataInsert();
begin
  if FCustomData <> nil then
    FCustomData.Insert;
end;

procedure TCustomDataView.DataPrint();
begin
  if Assigned(CustomDataPrintProc) then
    CustomDataPrintProc(ViewData, ShowPrintDialog);
end;

procedure TCustomDataView.DataQuery();
begin
  if FCustomData <> nil then
  begin
    FCustomData.Refresh;
  end;
end;

procedure TCustomDataView.DataSave();
begin
  if FCustomData <> nil then
    FCustomData.Save;
end;

function TCustomDataView.GetFilterFields: TStrings;
begin
  if FFilterFields = nil then
    FFilterFields := TStringList.Create;
  Result := FFilterFields;
end;

function TCustomDataView.CanNavigate: Boolean;
begin
  Result := (ViewData <> nil) and ViewData.Table.Active;
end;

procedure TCustomDataView.GoFirst;
begin
  if CanNavigate then
    if not DoNavigateEvent(naFirst) then
      ViewData.First;
end;

procedure TCustomDataView.GoLast;
begin
  if CanNavigate then
    // û�������¼�ʱ�����Լ���Ĭ�϶���
    if not DoNavigateEvent(naLast) then
      ViewData.Last;
end;

procedure TCustomDataView.GoNext;
begin
  if CanNavigate then
    if not DoNavigateEvent(naNext) then
      ViewData.Next;
end;

procedure TCustomDataView.GoPrior;
begin
  if CanNavigate then
    if not DoNavigateEvent(naPrior) then
      ViewData.Prior;
end;

procedure TCustomDataView.OnFirstExecute(Sender: TObject);
begin
  GoFirst;
end;

procedure TCustomDataView.OnFirstUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := CanNavigate;
end;

procedure TCustomDataView.OnLastExecute(Sender: TObject);
begin
  GoLast;
end;

procedure TCustomDataView.OnNextExecute(Sender: TObject);
begin
  GoNext;
end;

procedure TCustomDataView.OnPriorExecute(Sender: TObject);
begin
  GoPrior;
end;

procedure TCustomDataView.OnCancelExecute(Sender: TObject);
begin
  DataCancel;
end;

procedure TCustomDataView.OnCancelUpdate(Sender: TObject);
begin
  FCancelAction.Enabled := CanCancel;
end;

procedure TCustomDataView.OnDeleteExecute(Sender: TObject);
begin
  DataDelete(True);
end;

procedure TCustomDataView.OnDeleteUpdate(Sender: TObject);
begin
  FDeleteAction.Enabled := CanDelete;
end;

procedure TCustomDataView.OnEditExecute(Sender: TObject);
begin
  DataEdit;
end;

procedure TCustomDataView.OnEditUpdate(Sender: TObject);
begin
  FEditAction.Enabled := CanEdit;
end;

procedure TCustomDataView.OnExportExecute(Sender: TObject);
begin
  DataExport;
end;

procedure TCustomDataView.DoImportExecute(Sender: TObject);
begin
  DataImport;
end;

procedure TCustomDataView.OnExportUpdate(Sender: TObject);
begin
  FExportAction.Enabled := CanExport;
end;

procedure TCustomDataView.OnImportUpdate(Sender: TObject);
begin
  FImportAction.Enabled := CanImport;
end;

procedure TCustomDataView.OnInsertExecute(Sender: TObject);
begin
  DataInsert;
end;

procedure TCustomDataView.OnInsertUpdate(Sender: TObject);
begin
  FInsertAction.Enabled := CanInsert;
end;

procedure TCustomDataView.OnPrintExecute(Sender: TObject);
begin
  DataPrint;
end;

procedure TCustomDataView.OnPrintUpdate(Sender: TObject);
begin
  FPrintAction.Enabled := CanPrint;
end;

procedure TCustomDataView.OnQueryExecute(Sender: TObject);
begin
  DataQuery;
end;

procedure TCustomDataView.OnQueryUpdate(Sender: TObject);
begin
  FQueryAction.Enabled := CanQuery;
end;

procedure TCustomDataView.OnSaveExecute(Sender: TObject);
begin
  DataSave;
end;

procedure TCustomDataView.OnSaveUpdate(Sender: TObject);
begin
  FSaveAction.Enabled := CanSave;
end;

procedure TCustomDataView.SetData(ACustomData: TCustomData);
var
  Attr: string;
begin
  FMultiSelectField := '';
  FCustomData := ACustomData;
  SetAutoEdit(FAutoEdit);
  if (FCustomData <> nil) then
  begin
    MultiSelectField := FCustomData.Table.CustomAttributes.Values
      ['MultiSelectField'];
    Printing := ACustomData.ReporterNames.Count > 0;

    // ͬһ�������ڶ���ط�ʱ��������ֱ����ã����ɷ���Schema��
    Attr := FCustomData.CustomAttributes.Values['AutoEdit'];
    if Attr <> '' then
      AutoEdit := StrToBoolDef(Attr, False);

    Attr := FCustomData.CustomAttributes.Values['ShowFilterEdit'];
    if Attr <> '' then
      FilterEditItem.Visible := StrToBoolDef(Attr, False);

    Attr := FCustomData.CustomAttributes.Values['ShowGridChart'];
    if Attr <> '' then
      SetActionVisible(ChartAction, StrToBoolDef(Attr, False));

    FCustomData.FreeNotification(Self);
    if (not FCustomData.Table.Active) then
      DataQuery;
    // ����û�д�ʱ�����޷�������������, OpenӦ��д�ϻ����Ĳ�ѯ����
    // ������SetData֮ǰ�����ݣ�����������������
  end;
end;

destructor TCustomDataView.Destroy;
begin
  SaveViewLayout(AppCore.UserIni);
  FCustomData := nil;
  FreeAndNil(FFilterFields);
  inherited;
end;

procedure TCustomDataView.SetAutoEdit(AValue: Boolean);
begin
  FAutoEdit := AValue;
  if FCustomData <> nil then
    FCustomData.Source.AutoEdit := FAutoEdit;
end;

procedure TCustomDataView.DoLocalFilter(const AValue: string);
begin
  ViewData.DoLocalFilter(AValue);
end;

procedure TCustomDataView.DoServerFilter(const AValue: string);
begin
  ViewData.DoServerFilter(AValue);
end;

procedure TCustomDataView.DoFilterChange(Sender: TObject);
begin
  if ViewData.FilterFromServer then
    DoServerFilter(FFilterButtonEdit.Text)
  else
    DoLocalFilter(FFilterButtonEdit.Text);
end;

procedure TCustomDataView.DoFilterEditButton(Sender: TObject;
  AButtonIndex: Integer);
begin
  FFilterButtonEdit.Text := '';
end;

function TCustomDataView.DoNavigateEvent(NavigateAction
  : TNavigateAction): Boolean;
begin
  if Assigned(FOnNavigateData) then
  begin
    FOnNavigateData(Self, NavigateAction);
    Result := True
  end
  else
    Result := False;
end;

{ ������Action��ص�TControl�Լ�TdxLayoutItem�Ŀɼ��� }

procedure TCustomDataView.SetActionVisible(AAction: TAction; AVisible: Boolean);

  procedure SetActionControlItem(AParentControl: TWinControl);
  var
    I: Integer;
    Item: TdxLayoutItem;
  begin
    for I := 0 to AParentControl.ControlCount - 1 do
    begin
      if (AParentControl.Controls[I].Action = AAction) then
      begin
        Item := ViewLayout.FindItem(AParentControl.Controls[I]);
        if Item <> nil then
          Item.Visible := AVisible;
      end;
      if AParentControl.Controls[I].InheritsFrom(TWinControl) then
        SetActionControlItem(TWinControl(AParentControl.Controls[I]));
    end;
  end;

begin
  AAction.Visible := AVisible;
  SetActionControlItem(Self);
end;

procedure TCustomDataView.SetDataEditing(AValue: Boolean);
begin
  Editing := AValue;
  Deleting := AValue;
  Inserting := AValue;
  // ʹ��Ӧ�༭Action�ɼ�
  SetActionsVisible([InsertAction, DeleteAction, EditAction, SaveAction,
    CancelAction], AValue);
end;

{ ����Action�Ŀɼ��� }

procedure TCustomDataView.SetActionsVisible(AActionArray: array of TAction;
  AVisible: Boolean = True);
var
  I: Integer;
begin
  {
    for I := 0 to ViewActions.ActionCount - 1 do
    begin
    SetActionVisible(TAction(ViewActions[I]), not AVisible);
    end;
  }
  for I := 0 to Length(AActionArray) - 1 do
  begin
    SetActionVisible(AActionArray[I], AVisible);
  end;
end;

procedure TCustomDataView.DoFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Ord(Key) = VK_RETURN) and (Shift = []) then
  begin
    if HaveDataAfterFilter and Assigned(FOnFilterEnter) then
      FOnFilterEnter(Sender);
  end
  else if (Ord(Key) = VK_UP) and (Shift = []) then
    GoPrior
  else if (Ord(Key) = VK_DOWN) and (Shift = []) then
    GoNext
  else if (Ord(Key) = VK_UP) and (Shift = [ssCtrl]) then
    GoFirst
  else if (Ord(Key) = VK_DOWN) and (Shift = [ssCtrl]) then
    GoLast
end;

function TCustomDataView.HaveDataAfterFilter: Boolean;
begin
  Result := CanQuery and not ViewData.Table.EOF;
end;

{ ��ӹ̶���ɸѡ���� }

procedure TCustomDataView.SetFixFilter(AFieldName, AFilterText: string;
  AOperator: TcxFilterOperatorKind);
const
  DAOperator: array [foEqual .. foLike] of TDABinaryOperator = (dboEqual,
    dboNotEqual, dboLess, dboLessOrEqual, dboGreater,
    dboGreaterOrEqual, dboLike);
begin
  FFixFilterField := AFieldName;
  FFixFilterText := AFilterText;
  FFixFilterOp := AOperator;

  if FCustomData <> nil then
  begin
    FCustomData.SetFixFilter(AFieldName, AFilterText, DAOperator[AOperator]);
  end;

  DoFilterChange(FFilterButtonEdit);
end;

function TCustomDataView.FieldByName(const AName: string): TDAField;
begin
  Result := ViewData.Table.FieldByName(AName);
end;

procedure TCustomDataView.BuildViewLayout;
begin
  FShowPrintDialog := True;
  inherited;
  FEditing := False;
  FInserting := False;
  FDeleting := False;
  FQuerying := True;
  FExporting := True;
  FPrinting := False;

  BuildViewComponent;
  BuildViewAction;
  BuildViewToolBar;
  BuildViewPopupMenu;
end;

{ ��ȡ�ɼ����ֶΣ��ö��Ÿ��� }

function TCustomDataView.GetVisibleFields: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to ViewData.Table.Fields.Count - 1 do
  begin
    if ViewData.Table.Fields[I].Visible then
    begin
      if Result = '' then
        Result := ViewData.Table.Fields[I].Name
      else
        Result := Result + ',' + ViewData.Table.Fields[I].Name;
    end;
  end;
end;

procedure TCustomDataView.SetDeleting(const Value: Boolean);
begin
  FDeleting := Value;
  SetActionVisible(DeleteAction, Value);
end;

procedure TCustomDataView.SetEditing(const Value: Boolean);
begin
  FEditing := Value;
  SetActionsVisible(EditAction, Value);
end;

procedure TCustomDataView.SetExporting(const Value: Boolean);
begin
  FExporting := Value;
  SetActionsVisible(ExportAction, Value);
end;

procedure TCustomDataView.SetImporting(const Value: Boolean);
begin
  FImporting := Value;
  SetActionsVisible(ImportAction, Value);
end;

procedure TCustomDataView.SetInserting(const Value: Boolean);
begin
  FInserting := Value;
  SetActionVisible(InsertAction, Value);
end;

procedure TCustomDataView.SetPrinting(const Value: Boolean);
begin
  FPrinting := Value;
  SetActionVisible(PrintAction, Value);
end;

procedure TCustomDataView.SetQuerying(const Value: Boolean);
begin
  FQuerying := Value;
  SetActionVisible(QueryAction, Value);
end;

{ ����Action����, �����������¶����׼Action, ��BuildActionʱ���� }

procedure TCustomDataView.ResetActionCaption(AAction: TAction;
  const ACaption: string);
begin
  AAction.Tag := AAction.Tag or BTN_SHOWCAPTION;
  AAction.Caption := ACaption;
end;

procedure TCustomDataView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FCustomData) then
  begin
    FCustomData := nil;
  end;
  inherited;
end;

function TCustomDataView.GetFilterText: string;
begin
  Result := FilterEdit.Text;
end;

procedure TCustomDataView.SetFilterText(const Value: string);
begin
  FilterEdit.Text := Value;
end;

procedure TCustomDataView.OnSelectNoneExecute(Sender: TObject);
begin
  DataSave;
  EnumDataTable(FCustomData.Table, DoMultiSelect, 0);
end;

procedure TCustomDataView.OnSelectAllExecute(Sender: TObject);
begin
  DataSave;
  RecordMultiSelectCategoryFieldValue();
  EnumDataTable(FCustomData.Table, DoMultiSelect, 1);
end;

procedure TCustomDataView.OnSelectInverseExecute(Sender: TObject);
begin
  DataSave;
  EnumDataTable(FCustomData.Table, DoMultiSelect, 2);
end;

procedure TCustomDataView.OnSelectUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (FCustomData <> nil) and (MultiSelectField <> '');
end;

procedure TCustomDataView.DoMultiSelect(ADataTable: TDADataTable;
  AParam: Variant);
begin
  ViewData.Edit;
  if (FMultiSelectCategoryField = '') or
    (FMultiSelectCategoryFieldValue = ADataTable.FieldByName
    (FMultiSelectCategoryField).Value) then
    case AParam of
      0:
        ADataTable.FieldByName(MultiSelectField).AsBoolean := False;
      1:
        ADataTable.FieldByName(MultiSelectField).AsBoolean := True;
      2:
        ADataTable.FieldByName(MultiSelectField).AsBoolean :=
          not ADataTable.FieldByName(MultiSelectField).AsBoolean;
    end;
  ViewData.Save;
end;

procedure TCustomDataView.SetMultiSelectField(const Value: string);
begin
  FMultiSelectField := Value;
  SetActionsVisible([FSelectAllAction, FSelectNoneAction, FSelectInverseAction],
    (FMultiSelectField <> '') and ViewData.FieldByName(Value).Visible);
end;

procedure TCustomDataView.RecordMultiSelectCategoryFieldValue;
begin
  // ��¼�µ�ǰ��ѡ����ֶε�ֵ
  if FMultiSelectCategoryField <> '' then
    FMultiSelectCategoryFieldValue := FCustomData.Table.FieldByName
      (FMultiSelectCategoryField).Value;
end;

procedure TCustomDataView.CheckSelected;
begin
  // ���ѡ��������Ƿ���ȷ
  if (ViewData = nil) and ViewData.EOF then
    raise Exception.Create('ѡ�����');

  if (MultiSelectField <> '') and (GetMultiSelectCount = 0) then
  begin
    raise Exception.Create('�����ѡ��')
  end;
end;

function TCustomDataView.GetMultiSelectCount: Integer;
begin
  Result := 0;
  if MultiSelectField <> '' then
    EnumDataTable(ViewData.Table, EnumMultiSelectCount, Integer(@Result));
end;

procedure TCustomDataView.EnumMultiSelectCount(ADataTable: TDADataTable;
  AParam: Variant);
begin
  if FieldByName(MultiSelectField).AsBoolean then
    PInteger(Integer(AParam))^ := PInteger(Integer(AParam))^ + 1;
end;

procedure TCustomDataView.RestoreViewLayout(AIniFile: TIniFile);
begin

end;

procedure TCustomDataView.SaveViewLayout(AIniFile: TIniFile);
begin

end;

procedure TCustomDataView.SetFieldEditing(AFieldNames: array of string);
begin
  // �����ֶεĿɱ༭״̬
end;

function TCustomDataView.GetBeginDate: TDateTime;
begin
  BeginDateEdit.PostEditValue;
  Result := BeginDateEdit.Date;
end;

function TCustomDataView.GetEndDate: TDateTime;
begin
  EndDateEdit.PostEditValue;
  Result := EndDateEdit.Date;
end;

procedure TCustomDataView.SetBeginDate(const Value: TDateTime);
begin
  BeginDateEdit.Date := Value;
end;

procedure TCustomDataView.SetEndDate(const Value: TDateTime);
begin
  EndDateEdit.Date := Value;
end;

procedure TCustomDataView.SetPeriodFormatYear;
begin
  BeginDateEdit.Properties.DisplayFormat := 'YYYY��';
  EndDateEdit.Properties.DisplayFormat :=
    BeginDateEdit.Properties.DisplayFormat;
  BeginDateItem.Caption := '��ʼ���';
  EndDateItem.Caption := '�������';
  BeginDateEdit.Properties.EditFormat := 'YYYY';
  EndDateEdit.Properties.EditFormat := BeginDateEdit.Properties.EditFormat;
end;

procedure TCustomDataView.SetPeriodFormatYearMonth;
begin
  BeginDateEdit.Properties.DisplayFormat := 'YYYY��MM��';
  EndDateEdit.Properties.DisplayFormat :=
    BeginDateEdit.Properties.DisplayFormat;
  BeginDateItem.Caption := '��ʼ����';
  EndDateItem.Caption := '��������';
  BeginDateEdit.Properties.EditFormat := 'YYYY-MM';
  EndDateEdit.Properties.EditFormat := BeginDateEdit.Properties.EditFormat;
end;

procedure TCustomDataView.OnCloseExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCustomDataView.CreateCloseAction;
begin
  // Ӧ����BuildActions������
  BuildAction('�ر�', 'close', '', nil, OnCloseExecute, ShortCut(VK_ESCAPE, []),
    BTN_SHOWCAPTION or BTN_NOPOPUPMENU);
end;

procedure TCustomDataView.SetOnlyOneDate;
begin
  PeriodGroup.Visible := True;
  BeginDateItem.Caption := '��ѯ����';
  EndDateItem.Visible := False; // ֻ�����ѯһ��ļ�¼
end;

function TCustomDataView.GetPluginLayoutGroup(AOperation: TBaseOperation)
  : TComponent;
begin
  Result := ToolBarGroup;
end;

procedure TCustomDataView.SetVisibleFields(Fields: string);
begin

end;

procedure TCustomDataView.ShowChart;
begin
  if FChartView = nil then
  begin
    FChartView := TChartGridDataView.Create(Self);
    FChartView.BorderStyle := bsNone;
    FChartView.IsEmbedded := True;
    FChartView.ToolBarGroup.Visible := False;

    with ViewGroup.CreateItemForControl(FChartView) do
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;

    // ��¼���������
    FChartView.Tag := Integer(ViewGroup.Items[ViewGroup.Count - 1]);
  end;

  if (ViewData <> nil) and (FChartView.ViewData <> ViewData) then
  begin
    FChartView.ViewData := ViewData;
  end;

  ChartAction.Checked := not ChartAction.Checked;
  // ͼ�����ʾ��ԭ��ͼ��ʾ�෴
  TdxLayoutItem(FChartView.Tag).Visible := ChartAction.Checked;
  ClientGroup.Visible := not ChartAction.Checked;
end;

procedure TCustomDataView.OnChartExecute(Sender: TObject);
begin
  ShowChart;
end;

{ TCustomGridDataView }

procedure TCustomGridDataView.BuildFilterFields;
var
  I: Integer;
begin
  inherited;
  for I := 0 to FilterFields.Count - 1 do
  begin
    // ��¼�¹����ֶζ�Ӧ��Column���ù��˸���
    FilterFields.Objects[I] := TcxDBDataController(GridView.DataController)
      .GetItemByFieldName(FilterFields[I]);
    // TCustomGridDataView�������DataController����TcxDBDataController
  end;
end;

procedure TCustomGridDataView.BuildViewAction;
begin
  inherited;
  FFormViewAction := BuildAction('����ͼ', 'form', '', FEditAction.OnUpdate,
    DoActionShowFormView, 0, 0);
  FFormViewAction.Visible := False;
end;

procedure TCustomGridDataView.BuildViewComponent;
var
  ViewMenuItem: TMenuItem;
begin
  inherited;
  if FGrid = nil then
  begin
    FGrid := TcxGrid.Create(Self);
    FGrid.Levels.Add;

    FGridLayoutItem := ClientGroup.CreateItemForControl(FGrid);
    with FGridLayoutItem do
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;

    FGridView := FGrid.CreateView(FViewClass);
    FGrid.Levels[0].GridView := FGridView;
    FGrid.Levels[0].Caption := '����';
    FGridView.OnMouseUp := DoGridMouseUp;
    if GridView.InheritsFrom(TcxCustomGridTableView) then
      with TcxCustomGridTableView(GridView) do
      begin
        OnCellDblClick := DoTableCellDblClick;
        OnCellClick := DoTableCellClick;
        OnFocusedRecordChanged := DoFocusedRecordChanged;
      end;
    // Ϊ��ֻ�ڵ�Ԫ�񵯳��˵����ű�д���¼��������ʹ��PopupMenu����
    // FGrid.PopupMenu := ViewPopupMenu;

    FGridPopupMenu := TcxGridPopupMenu.Create(Self);
    FGridPopupMenu.Grid := FGrid;
    FGridViewPopupMenu := TPopupMenu.Create(Self);
    with TcxPopupMenuInfo(FGridPopupMenu.PopupMenus.Add) do
    begin
      HitTypes := [gvhtExpandButton, gvhtRecord]; // gvhtGroupByBox
      PopupMenu := FGridViewPopupMenu;
      GridView := FGridView;
    end;

    ViewMenuItem := TMenuItem.Create(Self);
    ViewMenuItem.Caption := 'ȫ��չ��';
    ViewMenuItem.OnClick := DoMenuItemExpandAll;
    FGridViewPopupMenu.Items.Add(ViewMenuItem);

    ViewMenuItem := TMenuItem.Create(Self);
    ViewMenuItem.Caption := 'ȫ���۵�';
    ViewMenuItem.OnClick := DoMenuItemCollapseAll;
    FGridViewPopupMenu.Items.Add(ViewMenuItem);

    FFormViewClass := TFormDataView;
  end;
end;

function TCustomGridDataView.CanDelete: Boolean;
begin
  Result := inherited CanDelete and
    (GridView.DataController.FocusedRecordIndex > -1)
end;

function TCustomGridDataView.CanEdit: Boolean;
begin
  Result := inherited CanEdit and
    (GridView.DataController.FocusedRecordIndex > -1)
end;

function TCustomGridDataView.DataDelete(AAskConfirm: Boolean): Boolean;
begin
  // FView.DataController.DeleteSelection;
  // ���������еķ���������ģ�ͺ���ͼ����
  Result := inherited DataDelete;

  with GridView do
  begin
    // DataController.UpdateItems(False);
    DataController.ClearSelection;
    DataController.SyncSelectionFocusedRecord;
  end;
end;

procedure TCustomGridDataView.DataEdit;
begin
  inherited;

  if UseFormForEditing then
  begin
    // FormViewAction.Execute;
    DoActionShowFormView(FormViewAction);
    DataCancel;
    DataController.SyncSelectionFocusedRecord;
  end
  else
    Grid.SetFocus;
  with GridView do
  begin
    Focused := True;
    DataController.ClearSelection;
    // DataController.Edit;
    DataController.SyncSelectionFocusedRecord;
    // ���ý���
  end;
end;

procedure TCustomGridDataView.DataExport;
begin
  DevExpress.ExportGrid(FGrid);
end;

procedure TCustomGridDataView.DataInsert;
begin
  if UseFormForEditing then
  begin
    SyncFormData;
  end;

  if UseFormForEditing then
  begin
    inherited;
    // FormViewAction.Execute;
    DoActionShowFormView(FormViewAction);
    DataCancel;
    // DataController.ClearSelection;
    DataController.SyncSelectionFocusedRecord;
  end
  else
    with GridView do
    begin
      Grid.SetFocus;
      DataController.ClearSelection;
      // ���������еķ���������ģ�ͺ���ͼ����
      inherited;
      // ���ý���
      if GridView.InheritsFrom(TcxGridTableView) then
        TcxGridTableView(GridView).Controller.FocusedColumn.Editing := True
      else if GridView.InheritsFrom(TcxGridDBCardView) then
        TcxGridDBCardView(GridView).Controller.FocusedItem.Editing := True;
      FocusFirstVisibleColumn();
      DataController.SyncSelectionFocusedRecord;
    end;
end;

procedure TCustomGridDataView.DoFocusedRecordChanged
  (Sender: TcxCustomGridTableView; APrevFocusedRecord, AFocusedRecord
  : TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if ViewData <> nil then
  begin
    ViewData.TriggerScroll;
  end;
  if Assigned(FOnRecordScroll) then
    FOnRecordScroll(GridView);
end;

procedure TCustomGridDataView.DoGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  if (Button = mbRight) and (ViewPopupMenu.ItemLinks.VisibleItemCount > 0) and
    (GridView.GetHitTest(X, Y).HitTestCode in [htNone, htCell]) then
  begin
    P.X := X;
    P.Y := Y;
    P := Grid.ClientToScreen(P);
    ViewPopupMenu.Popup(P.X, P.Y);
  end;
end;

procedure TCustomGridDataView.DoGridNavigate(Sender: TObject;
  NavigateAction: TNavigateAction);
begin
  case NavigateAction of
    naFirst:
      GoFirst;
    naLast:
      GoLast;
    naNext:
      GoNext;
    naPrior:
      GoPrior;
  end;
end;

procedure TCustomGridDataView.DoTableCellDblClick
  (Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  if Assigned(OnDoubleClickView) then
    OnDoubleClickView(GridView);
end;

procedure TCustomGridDataView.DoTableCellClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  // �Զ��༭��ѡ�ֶ�
  if (MultiSelectField <> '') and (AButton = mbLeft) then
  begin
    if ACellViewInfo.Item = DataController.GetItemByFieldName(MultiSelectField)
    then
    begin
      PostMessage(Handle, CM_TABLECELLCLICK, 0, 0);
    end;
  end;
end;

{ ��ȡ��ֵ�ԣ����ڻ�ȡLookupColumn�е���ʾ���� }

procedure TCustomGridDataView.ExtractNameAndKeyValue(const ANameFields,
  AKeyField: string; ADest: TStrings);
var
  NameColumnIndex, KeyColumnIndex, I, J: Integer;
  NameFieldList: TStrings;
  NameKeyValue: string;
begin
  ADest.Clear;
  NameFieldList := TStringList.Create;
  try
    NameFieldList.CommaText := ANameFields;

    with TcxGridDBDataController(GridView.DataController) do
    begin
      KeyColumnIndex := GetItemByFieldName(AKeyField).Index;
      for I := 0 to RecordCount - 1 do
      begin
        NameKeyValue := '';
        for J := 0 to NameFieldList.Count - 1 do
        begin
          NameColumnIndex := GetItemByFieldName(NameFieldList[J]).Index;
          NameKeyValue := NameKeyValue + DisplayTexts[I, NameColumnIndex] + ' ';
        end;
        ADest.Add(NameKeyValue + '=' + DisplayTexts[I, KeyColumnIndex]);
      end;
    end;
  finally
    NameFieldList.Free;
  end;
end;

procedure TCustomGridDataView.FocusFirstVisibleColumn;
var
  I: Integer;
begin
  if GridView.InheritsFrom(TcxGridTableView) then
    with TcxGridTableView(GridView) do
      for I := 0 to VisibleColumnCount - 1 do
        if VisibleColumns[I].Options.Focusing and VisibleColumns[I].Options.Editing
        then
        begin
          VisibleColumns[I].Focused := True;
          VisibleColumns[I].Editing := True;
          Break;
        end;
end;

function TCustomGridDataView.GetFormView: TFormDataView;
begin
  if FFormView = nil then
  begin
    FFormView := FFormViewClass.Create(Self);
    FFormView.Caption := Caption;
    FFormView.Position := poMainFormCenter;
    // �������ͬ��
    FFormView.OnNavigateData := DoGridNavigate;
    FFormView.AutoEdit := AutoEdit;
    FFormView.SetDataEditing(True); // ע��: ���ݿ�ɾ��������???
    FFormView.BorderStyle := bsDialog;
  end;
  Result := FFormView;
end;

procedure TCustomGridDataView.GoFirst;
begin
  if not DoNavigateEvent(naFirst) then
  begin
    FGridView.DataController.GotoFirst;
    FGridView.DataController.SyncSelectionFocusedRecord;
  end;
end;

procedure TCustomGridDataView.GoLast;
begin
  if not DoNavigateEvent(naLast) then
  begin
    FGridView.DataController.GotoLast;
    FGridView.DataController.SyncSelectionFocusedRecord;
  end;
end;

procedure TCustomGridDataView.GoNext;
begin
  if not DoNavigateEvent(naNext) then
  begin
    FGridView.DataController.GotoNext;
    // ������ѡ����Ҫͬ��
    FGridView.DataController.SyncSelectionFocusedRecord;
  end;
end;

procedure TCustomGridDataView.GoPrior;
begin
  if not DoNavigateEvent(naPrior) then
  begin
    FGridView.DataController.GotoPrev;
    FGridView.DataController.SyncSelectionFocusedRecord;
  end;
end;

function TCustomGridDataView.HaveDataAfterFilter: Boolean;
begin
  Result := inherited HaveDataAfterFilter() and
    (FGridView.DataController.FocusedRecordIndex > -1)
end;

procedure TCustomGridDataView.RestoreViewLayout(AIniFile: TIniFile);
begin

end;

procedure TCustomGridDataView.DoActionShowFormView(Sender: TObject);
begin
  SyncFormData;
  FormView.ShowModal;
end;

{ �����񲼾� }

procedure TCustomGridDataView.SaveViewLayout(AIniFile: TIniFile);
begin

end;

procedure TCustomGridDataView.DoLocalFilter(const AValue: string);
begin
  if (ViewData = nil) then
    Exit;
  BuildFilter(GridView.DataController.Filter, FilterFields, AValue,
    FFixFilterField, FFixFilterText, FFixFilterOp);
  GridView.DataController.SyncSelected(True);
end;

procedure TCustomGridDataView.SyncFormData;
begin
  if FormView.ViewData <> ViewData then
  begin
    FormView.SetData(ViewData);
    FormView.Caption := Caption;
    FormView.Width := StrToIntDef(ViewData.Table.CustomAttributes.Values
      ['Form.Width'], 640);
    FormView.Height := StrToIntDef(ViewData.Table.CustomAttributes.Values
      ['Form.Height'], 480);
  end;
end;

{ ΪButtonEdit����Ĭ�ϵ��¼������������д�¼��������ֻ�踲��DoEditButtonClick }

procedure TCustomGridDataView.BuildEditButtonEvent;
var
  I: Integer;
begin
  if GridView.InheritsFrom(TcxCustomGridTableView) then
    with TcxCustomGridTableView(GridView) do
      for I := 0 to ItemCount - 1 do
      begin
        if Items[I].Properties is TcxButtonEditProperties then
          with TcxButtonEditProperties(Items[I].Properties) do
          begin
            OnButtonClick := DoEditButtonClick;
          end;
      end
end;

procedure TCustomGridDataView.DoEditButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin

end;

{
  ö��ѡ���¼

  DataSet��¼ָ�������¼��ͬ��������
}

procedure TCustomGridDataView.ForEachSelected(AProc: TNotifyEvent);
var
  BK: TBookmark;
  I: Integer;
  LastRecordIndex: Integer;
  ARowIndex: Integer;
  ARowInfo: TcxRowInfo;
  RecordKeyValue: Variant;
  SelectedRecord: array of Variant;
begin
  ViewData.Table.DisableControls;
  // DataController.BeginUpdate;
  // BK := ViewData.GetBookmark;
  try

    // DataController.ForEachRow�����ƣ�
    // Dataset��¼ָ����ѡ��ͬ������: DataControllerҪ��GridModeģʽ��
    // GridView.DataController.ForEachRow(True, AProc);

    SetLength(SelectedRecord, DataController.GetSelectedCount);
    LastRecordIndex := -1;
    // �ȼ�¼ѡ��ļ�ֵ����Ϊ��ö���ڼ䲻���޸�����
    for I := 0 to DataController.GetSelectedCount - 1 do
    begin
      // TcxDBDataController(GridView.DataController).FocusSelectedRow(I);
      ARowIndex := DataController.GetSelectedRowIndex(I);
      ARowInfo := DataController.GetRowInfo(ARowIndex);
      // ���Է�����
      if ARowInfo.RecordIndex <> LastRecordIndex then
      begin
        // ��ȡ��ֵ���ǵ���Schema��ָ�������ֶ�
        RecordKeyValue := DataController.GetRecordId(ARowInfo.RecordIndex);
        SelectedRecord[I] := RecordKeyValue;
        LastRecordIndex := ARowInfo.RecordIndex;
      end
      else
        SelectedRecord[I] := null;
    end;

    // ö�ټ�¼�����޸�����
    for I := 0 to Length(SelectedRecord) - 1 do
    begin
      if ViewData.Table.Locate(ViewData.KeyFieldNames, SelectedRecord[I], [])
      then
        AProc(ViewData);
    end;

    // ViewData.GotoBookmark(BK);
  finally
    // ViewData.FreeBookmark(BK); // ע���ͷ�
    // DataController.EndUpdate;
    ViewData.Table.EnableControls;
  end;
end;

procedure TCustomGridDataView.DoMenuItemExpandAll(Sender: TObject);
begin
  DataController.Groups.FullExpand;
end;

procedure TCustomGridDataView.DoMenuItemCollapseAll(Sender: TObject);
begin
  DataController.Groups.FullCollapse;
end;

function TCustomGridDataView.GetDataController: TcxGridDBDataController;
begin
  Result := nil;
end;

procedure TCustomGridDataView.DoTableCellClickMsg(var Msg: TMessage);
begin
  ViewData.DisableControls;
  try
    try
      ViewData.Edit; // DataEdit�ڲ���ʾQueryActionʱ������
      ViewData.Table.FieldByName(MultiSelectField).AsBoolean :=
        not ViewData.Table.FieldByName(MultiSelectField).AsBoolean;
      ViewData.Save;
    except
      ViewData.Cancel;
      raise;
    end;
  finally
    ViewData.EnableControls;
  end;
end;

procedure TCustomGridDataView.SetFieldEditing(AFieldNames: array of string);
var
  I: Integer;
  Column: TcxCustomGridTableItem;
begin
  // ��ָ�����ֶ��⣬���඼���ɱ༭
  for I := 0 to ViewData.Table.FieldCount - 1 do
  begin
    Column := DataController.GetItemByFieldName(ViewData.Table.Fields[I].Name);
    if Column <> nil then
    begin
      Column.Options.Editing := False;
      // Column.Focusing := False;
    end;
  end;
  for I := 0 to Length(AFieldNames) - 1 do
  begin
    Column := DataController.GetItemByFieldName(AFieldNames[I]);
    if Column <> nil then
      Column.Options.Editing := True;
  end;
end;

procedure TCustomGridDataView.ConfigViewAfterData;
var
  Attr: string;
begin
  Attr := FCustomData.CustomAttributes.Values['ShowGridPopupMenu'];
  if StrToBoolDef(Attr, True) then
    GridPopupMenu.Grid := Grid
  else
    GridPopupMenu.Grid := nil;

  Attr := FCustomData.CustomAttributes.Values['OptionsData.Editing'];
  FOptionsDataEditing := StrToBoolDef(Attr, False);

  Attr := FCustomData.CustomAttributes.Values['UseFormForEditing'];
  if not FUseFormForEditing and (Attr <> '') then
    FUseFormForEditing := StrToBoolDef(Attr, False);
end;

procedure TCustomGridDataView.DataQuery;
begin
  inherited;
  DataController.SyncSelectionFocusedRecord;
end;

{ TTableGridDataView }

procedure TTableGridDataView.BuildViewComponent;
begin
  FViewClass := TcxGridDBTableView;
  inherited;
  // ShowFilterText := True;
  FView := TcxGridDBTableView(GridView);
end;

procedure TTableGridDataView.BuildViewPopupMenu;
begin
  inherited;
  // TableView.OnMouseDown := DoTableMouseDown;
  // TableView.PopupMenu := ViewPopupMenu;
  // TableViewPopupMenuWrapper.WrapTableView(TableView, ViewPopupMenu);
end;

function TTableGridDataView.CanQuery: Boolean;
begin
  Result := inherited CanQuery;
  // ��Action��ˢ���¼��н���༭״̬����
  if Result and (FCustomData.Table.State in [dsBrowse]) and
    TableView.OptionsData.Editing and not AutoEdit and not OptionsDataEditing
  then
    TableView.OptionsData.Editing := False;
end;

procedure TTableGridDataView.SetData(Data: TCustomData);
begin
  TableView.DataController.DataSource := nil;
  TableView.ClearItems;
  inherited;

  if Data = nil then
    Exit;

  {
    1 ���ݷ����仯ʱ,���SmartRefresh=False��Grid�����±���Table!!!

    2 ����SmartRefresh=Falseʱ��ʹ��DataTable.Scroll�¼�ʱע�⣺�ڱ�������ǰ
    ����Scroll�¼��������ָ�Scroll�¼���
    ������TableView.OnFocusedRecordChanged�¼����DataTable.Scroll�¼�

    3 ʹ��SmartRefresh��Ҫʹ��DataController�����ݲ�����������ͬ��View��DataSet��

    4 �������ʹ��DataSet�����ݲ���������Ҫ�ֶ�����DataController.UpdateItems,
    ���¼������������Լ������ݡ�

    5 ���鲻ʹ��SmartRefresh������̫�ࡣ
  }

  { ���½�����ͼ }
  DevExpress.BuildTableView(TableView, FCustomData.Source);
  BuildEditButtonEvent;
  BuildFilterFields;
  RestoreViewLayout(AppCore.UserIni);

  ConfigViewAfterData;
end;

procedure TTableGridDataView.SetAutoEdit(AValue: Boolean);
begin
  inherited;
  FView.OptionsData.Editing := AValue;
end;

procedure TTableGridDataView.DataEdit;
begin
  inherited;
  if not UseFormForEditing then
  begin
    TableView.OptionsData.Editing := True;
    TableView.Controller.FocusedColumn.Editing := True;
  end;
end;

procedure TTableGridDataView.DataInsert;
begin
  inherited;
  if not UseFormForEditing then
  begin
    TableView.OptionsData.Editing := True;
    FocusFirstVisibleColumn();
  end;
end;

procedure TTableGridDataView.SaveViewLayout(AIniFile: TIniFile);
var
  I: Integer;
begin
  if ViewData = nil then
    Exit;
  // AIniFile.EraseSection(ViewData.LogicalName);
  for I := 0 to TableView.ColumnCount - 1 do
  begin
    AIniFile.WriteInteger(ViewData.LogicalName,
      TableView.Columns[I].DataBinding.FieldName, TableView.Columns[I].Width);
  end;
end;

procedure TTableGridDataView.RestoreViewLayout(AIniFile: TIniFile);
var
  I, W: Integer;
  Cols: TStrings;
  Col: TcxGridDBColumn;
begin
  if ViewData = nil then
    Exit;

  Cols := TStringList.Create;
  TableView.BeginUpdate();
  try
    AIniFile.ReadSectionValues(ViewData.LogicalName, Cols);
    if Cols.Count = 0 then
      Exit;

    for I := 0 to Cols.Count - 1 do
    begin
      Col := TableView.GetColumnByFieldName(Cols.Names[I]);
      if (Col <> nil) then
        with Col do
        begin
          Width := StrToIntDef(Cols.ValueFromIndex[I], Width);
        end;
    end;
  finally
    TableView.EndUpdate;
    Cols.Free;
  end;
end;

function TTableGridDataView.GetVisibleFields: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to TableView.ColumnCount - 1 do
  begin
    if TableView.Columns[I].Visible then
      if Result = '' then
        Result := TableView.Columns[I].DataBinding.FieldName
      else
        Result := Result + ',' + TableView.Columns[I].DataBinding.FieldName;
  end;
end;

procedure TTableGridDataView.DisableMultiSelect;
begin
  TableView.OptionsSelection.MultiSelect := False;
end;

procedure TTableGridDataView.EnableMultiSelect;
begin
  TableView.OptionsSelection.MultiSelect := True;
end;

function TTableGridDataView.GetDataController: TcxGridDBDataController;
begin
  Result := TableView.DataController;
end;

procedure TTableGridDataView.DataPrint;
begin
  FLastReporterGroupValue := '';
  FShowPrintDialog := True;
  // û��ѡ�����ݣ��Զ�ѡ��ǰ��
  if DataController.GetSelectedCount = 0 then
    DataController.SyncSelectionFocusedRecord;
  ForEachSelected(DoDataPrint);
end;

procedure TTableGridDataView.DoDataPrint(Sender: TObject);
begin
  // ������ͬ��ļ�¼
  if (ViewData.ReporterGroupField = '') or
    (FLastReporterGroupValue <> ViewData.AsString[ViewData.ReporterGroupField])
  then
  begin
    inherited DataPrint();
    if ViewData.ReporterGroupField <> '' then
      FLastReporterGroupValue := ViewData.AsString[ViewData.ReporterGroupField];
    ShowPrintDialog := False; // ��ӡ��һ����¼������ʾ�Ի���
  end;
end;

procedure TTableGridDataView.SetVisibleFields(Fields: string);
var
  I: Integer;
begin
  Fields := Fields + ';';
  for I := 0 to TableView.ColumnCount - 1 do
  begin
    TableView.Columns[I].Visible :=
      Pos(TableView.Columns[I].DataBinding.FieldName + ';', Fields) > 0
  end;
end;

{ TTreeDataView }

procedure TTreeDataView.BuildFilterFields;
var
  I: Integer;
begin
  inherited;
  for I := 0 to FilterFields.Count - 1 do
  begin
    // TreeList�޷�������????
    FilterFields.Objects[I] := TreeView.GetColumnByFieldName(FilterFields[I]);
  end;
end;

procedure TTreeDataView.BuildViewComponent;
begin
  inherited;
  if FTreeView = nil then
  begin
    FTreeView := TcxDBTreeList.Create(Self);
    FTreeView.Parent := Self;
    FTreeView.PopupMenu := ViewPopupMenu;
    FTreeView.OnFocusedNodeChanged := DoFocusedNodeChanged;
    FTreeView.OnDblClick := DoTreeDblClick;
    FTreeLayoutItem := ClientGroup.CreateItemForControl(FTreeView);
    with FTreeLayoutItem do
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;
  end;
end;

function TTreeDataView.CanExport: Boolean;
begin
  Result := CanQuery and (ViewData.Table.RecordCount > 0)
end;

function TTreeDataView.CanQuery: Boolean;
begin
  Result := inherited CanQuery;
  // ��Action��ˢ���¼��н���༭״̬����
  if Result and (FCustomData.Table.State in [dsBrowse]) and
    TreeView.OptionsData.Editing and not AutoEdit and not OptionsDataEditing
  then
    TreeView.OptionsData.Editing := False;
end;

function TTreeDataView.DataDelete(AAskConfirm: Boolean = True): Boolean;
begin
  Result := inherited DataDelete;
  if Result and (TreeView.FocusedNode <> nil) then
    TreeView.FocusedNode.Selected := True;
end;

procedure TTreeDataView.DataEdit();
begin
  TreeView.SetFocus;
  inherited;
  TreeView.OptionsData.Editing := True;
  TreeView.FocusedNode.Selected := True;
end;

procedure TTreeDataView.DataExport();
begin
  DevExpress.ExportTreeList(FTreeView);
end;

procedure TTreeDataView.DataInsert();
begin
  TreeView.SetFocus;
  inherited;
  TreeView.FocusedNode.Selected := True;
  TreeView.OptionsData.Editing := True;
end;

procedure TTreeDataView.DoFocusedNodeChanged(Sender: TcxCustomTreeList;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  if ViewData <> nil then
    ViewData.TriggerScroll;
  if Assigned(FOnRecordScroll) then
    FOnRecordScroll(TreeView);
end;

procedure TTreeDataView.DoTreeDblClick(Sender: TObject);
begin
  if Assigned(OnDoubleClickView) then
    OnDoubleClickView(TreeView)
end;

procedure TTreeDataView.DoLocalFilter(const AValue: string);
begin
  {
    if (ViewData = nil) then Exit;
    // TreeView��֧�ֹ���
    BuildFilter(TreeView.DataController.Filter, FilterFields, AValue,
    FFixFilterField, FFixFilterText, FFixFilterOp);
    TreeView.DataController.SyncSelected(True);
  }
  inherited;
end;

procedure TTreeDataView.SetAutoEdit(AValue: Boolean);
begin
  inherited;
  FTreeView.OptionsData.Editing := True;
end;

procedure TTreeDataView.SetData(Data: TCustomData);
begin
  TreeView.DataController.DataSource := nil;
  TreeView.DeleteAllColumns;
  inherited;
  if Data = nil then
    Exit;

  FOptionsDataEditing := StrToBoolDef(FCustomData.CustomAttributes.Values
    ['OptionsData.Editing'], False);

  { ���½�������ͼ }
  DevExpress.BuildTreeView(TreeView, FCustomData.Source);
  BuildFilterFields;
  // TreeView.Root.Expand(False);
  ExpandTreeView(TreeView.Root, 1);
end;

{ TDataOperation }

destructor TDataViewOperation.Destroy;
begin
  if FOwnsData then
    FreeAndNil(FCustomData);
  inherited;
end;

function TDataViewOperation.GetView: TBaseView;
begin
  Result := inherited GetView;
  if (TCustomDataView(Result).ViewData = nil) and (FCustomData <> nil) then
  begin
    TCustomDataView(Result).ViewData := FCustomData;
    TCustomDataView(Result).SetDataEditing(True);
  end;
end;

{ ���û��ָ��ViewClass������schema�Ķ������ʹ�õ���ͼ }

function TDataViewOperation.GetViewClass: TBaseViewClass;
begin
  Result := GetDataViewClass(FCustomData.DefaultViewType);
end;

procedure TTreeDataView.GoFirst;
begin
  if not DoNavigateEvent(naFirst) then
    TreeView.DataController.GotoFirst;
end;

procedure TTreeDataView.GoLast;
begin
  if not DoNavigateEvent(naLast) then
    TreeView.DataController.GotoLast;
end;

procedure TTreeDataView.GoNext;
begin
  if not DoNavigateEvent(naNext) then
    TreeView.DataController.GotoNext;
end;

procedure TTreeDataView.GoPrior;
begin
  if not DoNavigateEvent(naPrior) then
    TreeView.DataController.GotoPrev;
end;

{ TFormDataView }

procedure TFormDataView.BuildDataEditor;
begin
  { ����Data������ }
  ViewLayout.BeginUpdate;
  try
    FreeAndNil(FEditorContainer);
    if ViewData = nil then
      Exit;
    FEditorContainer := FEditorGroup.CreateGroup();
    FEditorContainer.ShowBorder := False;
    DevExpress.BuildFormView(FEditorContainer, ViewData);
  finally
    ViewLayout.EndUpdate;
  end;
end;

procedure TFormDataView.BuildViewAction;
begin
  inherited;
  FirstAction.Visible := True;
  PriorAction.Visible := True;
  NextAction.Visible := True;
  LastAction.Visible := True;
end;

procedure TFormDataView.BuildViewComponent;
begin
  inherited;
  KeyPreview := True;
  OnShow := DoFormShow;
  OnKeyDown := DoFormKeyDown;
  ViewLayout.LookAndFeel := DevExpress.dxLayoutDialog;
  ViewLayout.Align := alNone;
  ViewLayout.Items.AlignHorz := ahLeft;
  ViewLayout.Items.AlignVert := avTop;
  ViewLayout.AutoSize := True;
  // FEditorContainerĬ�ϰ�����FEditorGroup��
  // ViewLayout.Items.AlignVert := avTop;
  // �����avClient�������Զ�������ĸ߶�
  // FEditorGroup := ViewGroup.CreateGroup();
  FEditorGroup := ClientGroup.CreateGroup();
  FEditorGroup.ShowBorder := False;

  FImage := TImage.Create(Self);
  with FImage do
  begin
    AutoSize := True;
    Transparent := True;
  end;

  FOKButton := BuildDXButton(Self, 'ȷ��(&Q)', DoOKClick);
  FCancelButton := BuildDXButton(Self, 'ȡ��(&X)', DoCancelClick);
  FCancelButton.Cancel := True;

  with ViewGroup do
  begin
    FImageItem := CreateItemForControl(FImage);
    with FImageItem do
    begin
      Index := 0;
      Visible := False;
      AlignHorz := ahRight;
    end;
  end;

  FBottomGroup := ViewGroup.CreateGroup();
  with FBottomGroup do
  begin
    // AlignVert := avBottom;
    LayoutDirection := ldHorizontal;
    ShowBorder := False;
    with CreateGroup() do
    begin
      AlignHorz := ahRight;
      LayoutDirection := ldHorizontal;
      ShowBorder := False;
      FOKItem := CreateItemForControl(FOKButton);
      FCancelItem := CreateItemForControl(FCancelButton);
    end;
  end;
end;

procedure TFormDataView.BuildViewPopupMenu;
begin
  SaveAction.Execute;
  ModalResult := mrOk;
end;

procedure TFormDataView.DoCancelClick(Sender: TObject);
begin
  CancelAction.Execute;
  ModalResult := mrCancel;
end;

procedure TFormDataView.DoFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // �ڱ��ؼ�֮�䰴�س���ת��Memo�ؼ��а�סCtrl����
  if (Key = VK_RETURN) then
  begin
    PostMessage(Handle, WM_KEYDOWN, VK_TAB, 0);
  end;
end;

procedure TFormDataView.DoFormShow(Sender: TObject);
begin
  if ViewLayout.Align <> alClient then
  begin
    ClientHeight := ViewLayout.Height;
    ClientWidth := ViewLayout.Width;
    // ViewLayout.Align := alClient;
  end;
  FocusFirstControl;
end;

procedure TFormDataView.DoOKClick(Sender: TObject);
begin
  SaveAction.Execute;
  ModalResult := mrOk;
end;

procedure TFormDataView.SetData(ACustomData: TCustomData);
begin
  inherited;
  ToolBarGroup.Visible := StrToBoolDef(ACustomData.CustomAttributes.Values
    ['FormToolBar'], True);
  ImageName := ACustomData.CustomAttributes.Values['FormImageName'];
  BuildDataEditor;
end;

procedure TFormDataView.SetViewImage(const Value: string);
begin
  FImage.Picture := AppCore.ImageCenter.Get(Value);
  FImageItem.Visible := FImage.Picture.Graphic <> nil;
end;

{ TDictIMEDialog }

constructor TDictIMEDialog.Create(AOwner: TComponent);
begin
  FRegisteredDataView := TStringList.Create;

  RegisterDataView(sDataViewName_Table, TTableGridDataView);
  RegisterDataView(sDataViewName_Card, TCardGridDataView);
  RegisterDataView(sDataViewName_Tree, TTreeDataView);
  RegisterDataView(sDataViewName_Form, TFormDataView);

  inherited;
  Visible := False;
  LayoutAutoSize := False;

  FViewItem := DialogGroup.CreateItemForControl(nil);
  FViewItem.AlignHorz := ahClient;
  FViewItem.AlignVert := avClient;
end;

destructor TDictIMEDialog.Destroy;
begin
  FRegisteredDataView.Free;
  inherited;
end;

procedure TDictIMEDialog.DoDialogOK(Sender: TObject);
begin
  if (FCurView.HaveDataAfterFilter) then
  begin
    FOpened := False;
    FDictData := FCurView.ViewData;

    if Assigned(FNotifier) then
    begin
      FNotifier(Self);
    end
    else
    begin
      // ��������Ϣ�����ⱨ��cannnot focus invisible or disabled controls
      Application.ProcessMessages;
      ModalResult := mrOk;
    end;
  end;
end;

procedure TDictIMEDialog.DoFormResize(Sender: TObject);
begin
  FOldWidth := Width;
  FOldHeight := Height;
end;

function TDictIMEDialog.Start(ASender: TControl;
  ADataName, AViewName, AFilterText: string; ANotifier: TNotifyEvent): Boolean;
begin
  Result := StartIME(ASender, DataContainer.Items[ADataName], AViewName,
    AFilterText, ANotifier, False);
end;

{
  ע�⣺����������ķ������ܻ������ε��ã�����
  �˷�����ģʽ�������뷨
}

function TDictIMEDialog.StartIME(ASender: TControl; ACustomData: TCustomData;
  AViewName, AFilterText: string; ANotifier: TNotifyEvent;
  AShowOnly: Boolean): Boolean;
begin
  FViewItem.Control := nil;
  if FCurView <> nil then
    FCurView.Visible := False;

  // ������ڶ��δ�
  if not FOpened then
  begin
    FDictName := ACustomData.LogicalName;
    RestoreDict();

    FOpened := True;
    Caption := ACustomData.Description;

    FNotifier := ANotifier;

    if AViewName = '' then
      AViewName := ACustomData.Table.CustomAttributes.Values['IME.ViewName'];

    if FRegisteredDataView.IndexOf(AViewName) < 0 then
      AViewName := sDataViewName_Table;

    FCurView := GetDataView(AViewName);

    with FCurView do
    begin
      Visible := True;
      // ����Schema��Access���ò���
      SetDataEditing((ACustomData.Access <> '') and
        AppCore.User.HaveAccess(ACustomData.Access));
      SetData(ACustomData);
      FilterEdit.Text := Trim(AFilterText);
      Printing := False;

      // ToolBarGroup.Visible := not AShowOnly;
    end;
    FViewItem.Control := FCurView;
    OKItem.Visible := not AShowOnly;
    if AShowOnly then
      CancelButton.Caption := '�ر�'
    else
      CancelButton.Caption := 'ȡ��';

    Result := False;

    if not Assigned(FNotifier) then
    begin
      PlaceFormBelowControl(Self, ASender);
      BorderStyle := bsSizeable;
      Result := Execute;
      SaveDict();
      FOpened := False;
    end;

    if not Assigned(ANotifier) and Result then
    begin
      // �����Զ�������һ�������
      // ����: (Cannot focus a disabled or invisible window)
      // PostMessage(Screen.ActiveControl.Handle, WM_KEYDOWN, VK_RETURN, 0);
    end;
  end;
end;

procedure TDictIMEDialog.FocusFilter;
begin
  with FCurView do
  begin
    FilterEdit.SetFocus;
    FilterEdit.SelLength := 0;
    FilterEdit.SelStart := Length(FilterEdit.Text);
  end;
end;

procedure TDictIMEDialog.RestoreDict;
begin
  // AppCore.Logger.Write('RestoreDict: ' + FDictName, mtInfo, 0);
  FOldWidth := AppCore.UserIni.ReadInteger(FDictName, 'PopupWidth_', 480);
  FOldHeight := AppCore.UserIni.ReadInteger(FDictName, 'PopupHeight_', 320);

  // �ָ�����ʽ�����еĴ�С
  OnResize := nil;
  Width := FOldWidth;
  Height := FOldHeight;
  OnResize := DoFormResize;
end;

procedure TDictIMEDialog.SaveDict;
begin
  // AppCore.Logger.Write('SaveDict: ' + FDictName, mtInfo, 0);
  if FCurView <> nil then
  begin
    FCurView.SaveViewLayout(AppCore.UserIni);
    AppCore.UserIni.WriteInteger(FDictName, 'PopupWidth_', FOldWidth);
    AppCore.UserIni.WriteInteger(FDictName, 'PopupHeight_', FOldHeight);
  end;
  OnResize := nil;
end;

procedure TDictIMEDialog.DoPopupClose(Sender: TPopupEditorWrapInfo);
begin
  FOpened := False;
  SaveDict;
end;

procedure TDictIMEDialog.DoPopupInit(Sender: TPopupEditorWrapInfo);
begin
  FPopupWrapInfo := Sender;
  FOpened := False;
  Start(Screen.ActiveControl, Sender.DictName, '', '', DoPopupOK);
end;

procedure TDictIMEDialog.DoPopup(Sender: TPopupEditorWrapInfo);
begin
end;

function TDictIMEDialog.DoModalDialog(Sender: TPopupEditorWrapInfo;
  const AFilterText: string): Boolean;
begin
  FPopupWrapInfo := Sender;
  Result := Start(Screen.ActiveControl, Sender.DictName, '', AFilterText, nil);
  if Result then
  begin
    EditData;
  end;
end;

procedure TDictIMEDialog.EditData;
begin
  FPopupWrapInfo.EditData;
end;

procedure TDictIMEDialog.DoPopupOK(Sender: TObject);
begin
  EditData;
  FPopupWrapInfo.DoPopupOK(Sender);
end;

function TDictIMEDialog.GetDataView(AViewName: string): TCustomDataView;
begin
  Result := TCustomDataView(FindComponent('DataView_' + AViewName));
  if Result = nil then
  begin
    Result := TCustomDataViewClass(FRegisteredDataView.Objects
      [FRegisteredDataView.IndexOf(AViewName)]).Create(Self);
    with Result do
    begin
      Name := 'DataView_' + AViewName;
      BorderStyle := bsNone;
      FilterEditItem.Visible := True;
      FilterEditItem.Index := 0;
      OnFilterPressEnter := DoDialogOK;
      OnDoubleClickView := DoDialogOK;
    end;

    // ������ͼ�������ʵ�����
    if Result.ClassType = TTableGridDataView then
      with TTableGridDataView(Result) do
      begin
        TableView.FilterBox.Visible := fvNever;
      end;
  end;
end;

procedure TDictIMEDialog.RegisterDataView(AViewName: string;
  AViewClass: TCustomDataViewClass);
begin
  if FRegisteredDataView.IndexOf(AViewName) < 0 then
    FRegisteredDataView.AddObject(AViewName, TObject(AViewClass));
end;

procedure TDictIMEDialog.DoDialogCancel(Sender: TObject);
begin
  FOpened := False;
  FDictData := nil;
  if Assigned(FNotifier) then
  begin
    FPopupWrapInfo.ClosePopup;
  end
  else
    ModalResult := mrCancel;
end;

{ TDictManageView }

procedure TDictManageView.BuildTree;
var
  I: Integer;
  CustomData: TCustomData;
  ParentNode: TcxTreeListNode;

  function GetParentNode(ACustomData: TCustomData): TcxTreeListNode;
  var
    Category: string;
  begin
    Category := Trim(ACustomData.Category);
    if Category = '' then
      Category := 'δ����';
    Result := FDictTree.FindNodeByText(Category, FDictTree.Columns[0], nil,
      False, True, False, tlfmExact);
    if (Result = nil) then
    begin
      Result := FDictTree.Root.AddChild;
      Result.Texts[0] := Category;
      Result.ImageIndex := AppCore.SmallImage.IndexOf(sFolderImageName);
    end;
  end;

begin
  for I := 0 to DataContainer.Count - 1 do
  begin
    // �ɸ���TDataDefinition.Flag����TreeView������
    // �����DataContainerȫ���������ֵ��
    CustomData := DataContainer.ItemsByIndex[I].CustomData;
    ParentNode := GetParentNode(CustomData);
    with ParentNode.AddChild do
    begin
      Texts[0] := CustomData.Description;
      Texts[1] := CustomData.LogicalName;
      ImageIndex := AppCore.SmallImage.IndexOf(sDefaultImageName);
      Data := CustomData;
      // AppCore.Logger.Write(Texts[0] + ' ' + Texts[1]);
    end;
  end;
end;

procedure TDictManageView.BuildViewComponent;
begin
  FDictTree := TcxTreeList.Create(Self);
  with FDictTree do
  begin
    OptionsView.ColumnAutoWidth := True;
    OptionsData.Editing := False;
    OptionsData.Deleting := False;
    OptionsSelection.CellSelect := False;
    Images := AppCore.SmallImage.ImageList;
    with CreateColumn() do
    begin
      Caption.Text := '�ֵ�Ŀ¼';
    end;
    with CreateColumn() do
    begin
      Caption.Text := '�߼�����';
      Visible := False;
    end;
    with CreateColumn() do
    begin
      Caption.Text := '��ͼ����'; // ��Ӧ��ͼ�����ڴ�����
      Visible := False;
    end;
  end;

  with ViewLayout.Items do
  begin
    LayoutDirection := ldHorizontal;

    with CreateItemForControl(FDictTree) do
    begin
      AlignHorz := ahLeft;
      AlignVert := avClient;
      Index := 0;
      Width := AppCore.IniFile.ReadInteger(Self.ClassName, 'LeftWidth', 200);
    end;

    CreateItem(TdxLayoutSplitterItem).Index := 1;
    FViewLayoutItem := TdxLayoutItem(CreateItem());
    with FViewLayoutItem do
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;
  end;

  BuildTree;

  FDictTree.OnSelectionChanged := DoTreeChange;
end;

destructor TDictManageView.Destroy;
begin
  AppCore.IniFile.WriteInteger(ClassName, 'LeftWidth',
    ViewLayout.Items[0].Width);
  inherited;
end;

procedure TDictManageView.BuildViewLayout;
begin
  inherited;
  BuildViewComponent;
end;

{
  ѡ��ͬ���ֵ�ʱ��ʾ��Ӧ��ͼ
  ÿ�����ݵ�����һ����Ӧ��ͼ������������
}

procedure TDictManageView.DoTreeChange(Sender: TObject);
var
  DictView: TCustomDataView;
  DictData: TCustomData;
begin
  if FDictTree.FocusedNode = nil then
    Exit;

  with FDictTree.FocusedNode do
  begin
    if Data <> nil then
    begin
      // ���ص�ǰ�ֵ���ͼ
      if FViewLayoutItem.Control <> nil then
      begin
        FViewLayoutItem.Control.Visible := False;
        FViewLayoutItem.Control := nil;
      end;

      DictData := TCustomData(Data);

      if VarIsNull(Values[2]) then
      begin
        // ������ǰ�ֵ����ͼ
        DictView := GetDataViewClass(DictData.DefaultViewType).Create(Self);
        if DictView.InheritsFrom(TCustomGridDataView) then
          with TCustomGridDataView(DictView) do
            SetActionVisible(FormViewAction, True);
        DictView.SetDataEditing(True);
        DictView.Caption := DictData.Description;
        DictView.BorderStyle := bsNone;
        DictView.FilterEditItem.Visible := True;
        Values[2] := Integer(DictView);
        DictView.SetData(DictData);
      end
      else
        DictView := TCustomDataView(Integer(Values[2]));
      // �Զ��༭���ݣ���SetData֮��֮ǰ���������е�����(BuildView��
      // OptionsData.Editing����ΪFalse)
      DictView.AutoEdit := True;

      // ��ʾ��ͼ
      FViewLayoutItem.Control := DictView;
    end;
  end;
end;

procedure TDictManageView.LocateDict(const ALogicalName: string);
var
  DictNode: TcxTreeListNode;
begin
  DictNode := FDictTree.FindNodeByText(ALogicalName, FDictTree.Columns[1]);
  if DictNode <> nil then
    DictNode.Focused := True;
end;

{ TBandGridDataView }

procedure TBandGridDataView.BuildViewComponent;
begin
  FViewClass := TcxGridDBBandedTableView;
  inherited;
  FView := TcxGridDBBandedTableView(GridView);
end;

procedure TBandGridDataView.BuildViewPopupMenu;
begin
  inherited;
  // BandView.PopupMenu := ViewPopupMenu;
  // TableViewPopupMenuWrapper.WrapTableView(BandView, ViewPopupMenu);
end;

function TBandGridDataView.CanQuery: Boolean;
begin
  Result := inherited CanQuery;
  // ��Action��ˢ���¼��н���༭״̬����
  if Result and (FCustomData.Table.State in [dsBrowse]) and
    BandView.OptionsData.Editing and not AutoEdit and not OptionsDataEditing
  then
    BandView.OptionsData.Editing := False;
end;

procedure TBandGridDataView.DataEdit;
begin
  inherited;
  if not UseFormForEditing then
  begin
    BandView.OptionsData.Editing := True;
    BandView.Controller.FocusedColumn.Editing := True;
  end;
end;

procedure TBandGridDataView.DataInsert;
begin
  inherited;
  if not UseFormForEditing then
  begin
    BandView.OptionsData.Editing := True;
    FocusFirstVisibleColumn();
  end;
end;

procedure TBandGridDataView.DisableMultiSelect;
begin
  BandView.OptionsSelection.MultiSelect := False;
end;

procedure TBandGridDataView.EnableMultiSelect;
begin
  BandView.OptionsSelection.MultiSelect := True;
end;

function TBandGridDataView.GetDataController: TcxGridDBDataController;
begin
  Result := BandView.DataController;
end;

function TBandGridDataView.GetVisibleFields: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to BandView.ColumnCount - 1 do
  begin
    if BandView.Columns[I].Visible then
      if Result = '' then
        Result := BandView.Columns[I].DataBinding.FieldName
      else
        Result := Result + ',' + BandView.Columns[I].DataBinding.FieldName;
  end;
end;

procedure TBandGridDataView.RestoreViewLayout(AIniFile: TIniFile);
var
  I, W: Integer;
  Cols: TStrings;
  Col: TcxGridDBBandedColumn;
begin
  Assert(ViewData <> nil);

  Cols := TStringList.Create;
  BandView.BeginUpdate();
  try
    AIniFile.ReadSectionValues(ViewData.LogicalName, Cols);
    if Cols.Count = 0 then
      Exit;

    for I := 0 to Cols.Count - 1 do
    begin
      Col := BandView.GetColumnByFieldName(Cols.Names[I]);
      if (Col <> nil) then
        with Col do
        begin
          Width := StrToIntDef(Cols.ValueFromIndex[I], Width);
          if Width > 1000 then
            Width := 100;
        end;
    end;
  finally
    BandView.EndUpdate;
    Cols.Free;
  end;
end;

procedure TBandGridDataView.SaveViewLayout(AIniFile: TIniFile);
var
  I, W: Integer;
begin
  if ViewData = nil then
    Exit;
  // AIniFile.EraseSection(ViewData.LogicalName);
  for I := 0 to BandView.ColumnCount - 1 do
  begin
    AIniFile.WriteInteger(ViewData.LogicalName,
      BandView.Columns[I].DataBinding.FieldName, BandView.Columns[I].Width);
  end;
end;

procedure TBandGridDataView.SetAutoEdit(AValue: Boolean);
begin
  inherited;
  FView.OptionsData.Editing := AValue;
end;

procedure TBandGridDataView.SetData(Data: TCustomData);
begin
  BandView.DataController.DataSource := nil;
  BandView.ClearItems;
  inherited;
  if Data = nil then
    Exit;

  DevExpress.BuildBandView(BandView, FCustomData.Source);
  BuildEditButtonEvent;
  BuildFilterFields;
  RestoreViewLayout(AppCore.UserIni);

  ConfigViewAfterData();
end;

{ TChartGridDataView }

procedure TChartGridDataView.BuildViewComponent;
begin
  FViewClass := TcxGridDBChartView;
  inherited;
  FView := TcxGridDBChartView(GridView);
  PeriodGroup.Visible := True;
end;

procedure TChartGridDataView.BuildViewPopupMenu;
begin
  inherited;
  // sChartView.PopupMenu := ViewPopupMenu;
end;

procedure TChartGridDataView.BuildViewToolBar;
begin
  BuildLayoutToolBar(ActionGroup, [FExportAction, FQueryAction]);
end;

function TChartGridDataView.CanDelete: Boolean;
begin
  Result := False;
end;

function TChartGridDataView.CanEdit: Boolean;
begin
  Result := False;
end;

function TChartGridDataView.CanInsert: Boolean;
begin
  Result := False;
end;

procedure TChartGridDataView.SetData(Data: TCustomData);
begin
  ChartView.ClearSeries;
  ChartView.ClearDataGroups;
  ChartView.DataController.DataSource := nil;
  inherited;
  if Data = nil then
    Exit;
  DevExpress.BuildChartView(ChartView, FCustomData.Source);
  BuildFilterFields;
end;

{ TPivotDataView }

procedure TPivotDataView.BuildViewComponent;
begin
  inherited;
  if FPivot = nil then
  begin
    FPivot := TcxDBPivotGrid.Create(Self);

    FPivotLayoutItem := ClientGroup.CreateItemForControl(FPivot);
    with FPivotLayoutItem do
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;
  end;
  PeriodGroup.Visible := True;
end;

procedure TPivotDataView.BuildViewPopupMenu;
begin
  // ȥ����ݲ˵�
end;

procedure TPivotDataView.BuildViewToolBar;
begin
  // BuildLayoutToolBar(ActionGroup, [FExportAction, FQueryAction]);
  inherited;
end;

function TPivotDataView.CanDelete: Boolean;
begin
  Result := False;
end;

function TPivotDataView.CanEdit: Boolean;
begin
  Result := False;
end;

function TPivotDataView.CanExport: Boolean;
begin
  Result := (ViewData <> nil) and ViewData.Table.Active;
end;

function TPivotDataView.CanInsert: Boolean;
begin
  Result := False;
end;

procedure TPivotDataView.DataExport;
begin
  DevExpress.ExportPivot(FPivot);
end;

procedure TPivotDataView.SetData(Data: TCustomData);
begin
  PivotGrid.DeleteAllFields;
  PivotGrid.DataController.DataSource := nil;
  inherited;
  DevExpress.BuildPivotGrid(FPivot, Data.Source);
end;

{ TCardGridDataView }

procedure TCardGridDataView.BuildViewComponent;
begin
  FViewClass := TcxGridDBCardView;
  inherited;
  FView := TcxGridDBCardView(GridView);
end;

procedure TCardGridDataView.BuildViewPopupMenu;
begin
  inherited;
  // CardView.PopupMenu := ViewPopupMenu;
  // TableViewPopupMenuWrapper.WrapTableView(CardView, ViewPopupMenu);
end;

function TCardGridDataView.CanQuery: Boolean;
begin
  Result := inherited CanQuery;
  // ��Action��ˢ���¼��н���༭״̬����
  if Result and (FCustomData.Table.State in [dsBrowse]) and
    CardView.OptionsData.Editing and not AutoEdit and not OptionsDataEditing
  then
    CardView.OptionsData.Editing := False;
end;

procedure TCardGridDataView.DataEdit;
begin
  inherited;
  if not UseFormForEditing then
  begin
    CardView.OptionsData.Editing := True;
    CardView.Controller.FocusedRow.Editing := True;
  end;
end;

procedure TCardGridDataView.DataInsert;
begin
  inherited;
  if not UseFormForEditing then
  begin
    CardView.OptionsData.Editing := True;
  end;
end;

function TCardGridDataView.GetDataController: TcxGridDBDataController;
begin
  Result := CardView.DataController;
end;

procedure TCardGridDataView.RestoreViewLayout(AIniFile: TIniFile);
begin
  inherited;
  if ViewData = nil then
    Exit;
  CardView.OptionsView.CardWidth := AIniFile.ReadInteger(ViewData.LogicalName,
    'CardWidth_', CardView.OptionsView.CardWidth);
end;

procedure TCardGridDataView.SaveViewLayout(AIniFile: TIniFile);
begin
  inherited;
  if ViewData = nil then
    Exit;
  AIniFile.ReadInteger(ViewData.LogicalName, 'CardWidth_',
    CardView.OptionsView.CardWidth);
end;

procedure TCardGridDataView.SetAutoEdit(AValue: Boolean);
begin
  inherited;
  FView.OptionsData.Editing := AValue;
end;

procedure TCardGridDataView.SetData(Data: TCustomData);
begin
  CardView.ClearItems;
  CardView.DataController.DataSource := nil;
  inherited;
  if Data = nil then
    Exit;
  DevExpress.BuildCardView(CardView, FCustomData.Source);
  BuildEditButtonEvent;
  BuildFilterFields;
  RestoreViewLayout(AppCore.UserIni);
  ConfigViewAfterData();
end;

{ TPopupEditorWrapInfo }

constructor TPopupEditorWrapInfo.Create(ATarget: TComponent);
begin
  inherited;
  FGetValueFields := TStringList.Create;
  FGetValueFields.Delimiter := ';';
  FSetValueFields := TStringList.Create;
  FSetValueFields.Delimiter := ';';
  FMultiEditorAttributes := TStringList.Create;
  // AppCore.Logger.Write(ClassName + ' Created');
end;

destructor TPopupEditorWrapInfo.Destroy;
begin
  // AppCore.Logger.Write(ClassName + ' Destroyed');
  FreeAndNil(FButtonAction);
  FreeAndNil(FClearAction);
  FreeAndNil(FGetValueFields);
  FreeAndNil(FSetValueFields);
  FreeAndNil(FMultiEditorAttributes);
  inherited;
end;

procedure TPopupEditorWrapInfo.DoButtonAction(Sender: TObject);
begin
  ShowModalPopuForm('');
end;

procedure TPopupEditorWrapInfo.DoPopupOK(Sender: TObject);
begin
  TcxDBPopupEdit(FPopupControl).DroppedDown := False;
  if Screen.ActiveControl <> nil then
    PostMessage(Screen.ActiveControl.Handle, WM_KEYDOWN, VK_RETURN, 0);
end;

procedure TPopupEditorWrapInfo.DoGridEditKeyPress
  (Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Char);
begin
  if (AItem = Target) then
    DoKeyPress(AEdit, Key)
  else if Assigned(FOldGridEditKeyEvent) then
    FOldGridEditKeyEvent(Sender, AItem, AEdit, Key);
end;

procedure TPopupEditorWrapInfo.DoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', ' ']) then
  begin
    ShowModalPopuForm(Key);
    Key := #0;
  end;
end;

procedure TPopupEditorWrapInfo.DoPopupInit(Sender: TObject);
begin
  (FPopupEditorForm as IPopupEditorForm).DoPopupInit(Self);
end;

procedure TPopupEditorWrapInfo.DoPopup(Sender: TObject);
begin
  FPopupControl := Sender;
  (FPopupEditorForm as IPopupEditorForm).DoPopup(Self);
end;

procedure TPopupEditorWrapInfo.DoPopupClose(Sender: TcxControl;
  AReason: TcxEditCloseUpReason);
begin
  (FPopupEditorForm as IPopupEditorForm).DoPopupClose(Self);
  // û���������䣬��Popup֮�����ShowModalPopuForm��can't modal a visible form.
  with FPopupEditorForm do
  begin
    Align := alNone;
    Visible := False;
    Parent := nil;
  end;
end;

procedure TPopupEditorWrapInfo.ShowModalPopuForm(const AFilterText: string);
begin
  (FPopupEditorForm as IPopupEditorForm).DoModalDialog(Self, AFilterText);
end;

procedure TPopupEditorWrapInfo.Wrap;
var
  TempAttributes: TStrings;

  procedure AddButton(Properties: TcxCustomEditProperties);
  begin
    with Properties.Buttons.Add do
    begin
      Default := True;
      Kind := bkGlyph;
      AppCore.SmallImage.ImageList.GetImage
        (AppCore.SmallImage.IndexOf('Dict'), Glyph);
      Action := ButtonAction;
    end;
  end;

begin
  FPopupEditorForm := TPopupEditorWrapper(Wrapper).GetPopupEditor(FEditorName);
  if FPopupEditorForm = nil then
    Exit;

  // ����Column.OnGetProperties
  TempAttributes := FMultiEditorAttributes;
  if TempAttributes.Count = 0 then
    TempAttributes := FField.CustomAttributes;

  FFreeEditing := StrToBoolDef(TempAttributes.Values['IME.FreeEditing'], False);
  FFreeAppending := StrToBoolDef(TempAttributes.Values
    ['IME.FreeAppending'], False);
  FFreeAppendChar := TempAttributes.Values['IME.FreeAppendChar'];

  SetValueField.DelimitedText := TempAttributes.Values['IME.SetValueField'];
  GetValueField.DelimitedText := TempAttributes.Values['IME.GetValueField'];
  DictName := TempAttributes.Values['IME.DictName'];

  if DictName <> '' then
  begin
    FDictTable := DataContainer.Items[DictName].Table;
    if (GetValueField.Text = '') then
      GetValueField.Text := DataContainer.Items[DictName].KeyFieldNames;
  end;

  if SetValueField.Text = '' then
    SetValueField.Text := FField.Name;

  if Target.InheritsFrom(TcxCustomPopupEdit) and
    StrToBoolDef(TempAttributes.Values['PopupEdit.AutoDropdown'], False) then
    with TcxCustomPopupEdit(Target) do
    begin
      OnEnter := DoPopupEnter;
    end;

  if FProperties.InheritsFrom(TcxPopupEditProperties) then
  begin
    with TcxPopupEditProperties(FProperties) do
    begin
      // PopupAutoSize := True;
      PopupControl := FPopupEditorForm;
      OnPopup := DoPopup;
      OnInitPopup := DoPopupInit;
      OnClosePopup := DoPopupClose;
      // PopupSysPanelStyle := True;
      ReadOnly := True; // ��ɻ�ɫ����???
    end;
  end
  else if Target.InheritsFrom(TcxCustomEdit) then
    with TcxCustomEdit(Target) do
    begin
      AddButton(ActiveProperties);
      if not FFreeEditing then
        OnKeyPress := DoKeyPress;
    end
  else if Target.InheritsFrom(TcxCustomGridTableItem) then
  begin
    with TcxCustomGridTableItem(Target) do
    begin
      AddButton(Properties);
    end;
    if not FFreeEditing then
    begin
      // �����¼�
      FOldGridEditKeyEvent := TcxCustomGridTableItem(Target)
        .GridView.OnEditKeyPress;
      TcxCustomGridTableItem(Target).GridView.OnEditKeyPress := nil;
      // û������һ�䣬����һ�䲻������?? ��ΪDX���ж��¼��������Ƿ���ͬʱ������"@"����?
      // ��ǰû�����������������Ϊû�д����¼�
      TcxCustomGridTableItem(Target).GridView.OnEditKeyPress :=
        DoGridEditKeyPress;
    end;
  end
  else if Target.InheritsFrom(TcxTreeListColumn) then
  begin
    with TcxTreeListColumn(Target) do
    begin
      AddButton(Properties);
    end;
  end;

  // ��������ť
  if StrToBoolDef(TempAttributes.Values['IME.ClearButton'], False) then
    with FProperties.Buttons.Add do
    begin
      Action := ClearAction;
      Kind := bkText;
      AppCore.SmallImage.ImageList.GetImage
        (AppCore.SmallImage.IndexOf('Clear'), Glyph);
    end;
end;

procedure TPopupEditorWrapInfo.EditData;
var
  I: Integer;
  S, SeparateChar: string;
  Done: Boolean;
begin
  if FDataSource.AutoEdit then
    DataTable_IntoEditState(FDataTable);

  if (FDataTable.Owner is TCustomData) and (FDictTable.Owner is TCustomData)
  then
  begin
    Done := False;
    TCustomData(FDataTable.Owner).AssignFieldValue(FField.Name,
      TCustomData(FDictTable.Owner), Done);
    if Done then
      Exit;
  end;

  // �ڱ༭״̬�Ÿ�ֵ����
  if FDataTable.State in [dsEdit, dsInsert] then
    // Ϊ���ֶθ�ֵ
    for I := 0 to FSetValueFields.Count - 1 do
    begin
      if not(FDataTable.State <> dsEdit) then
        FDataTable.Edit; // ���TreeView������

      if not FFreeEditing and not FFreeAppending then
        FDataTable.FieldByName(FSetValueFields[I]).AsString :=
          FDictTable.FieldByName(FGetValueFields[I]).AsString
      else
      begin
        S := FDataTable.FieldByName(FSetValueFields[I]).AsString;
        if (S = '') or (RightStr(S, 1) = FFreeAppendChar) then
          SeparateChar := ''
        else
          SeparateChar := FFreeAppendChar;
        // ����������ģʽ��Ӧ�ò��漰����ֶ�
        FDataTable.FieldByName(FSetValueFields[I]).AsString := S + SeparateChar
          + FDictTable.FieldByName(FGetValueFields[I]).AsString
      end;
    end;
end;

procedure TPopupEditorWrapInfo.ClosePopup;
begin
  TcxDBPopupEdit(FPopupControl).DroppedDown := False;
end;

procedure TPopupEditorWrapInfo.ClearData;
var
  I: Integer;
begin
  if FDataSource.AutoEdit then
    DataTable_IntoEditState(FDataTable);

  // �༭״̬�в��������
  if (FDataTable.State in [dsEdit, dsInsert]) then
    // Ϊ���ֶθ�ֵ
    for I := 0 to FSetValueFields.Count - 1 do
    begin
      FDataTable.Edit; // ���TreeView������
      if FDataTable.FieldByName(FSetValueFields[I]).DataType
        in [datString, datMemo, datWideString] then
        FDataTable.FieldByName(FSetValueFields[I]).Value := ''
      else
        FDataTable.FieldByName(FSetValueFields[I]).Value := 0;
    end;
end;

procedure TPopupEditorWrapInfo.DoActionClear(Sender: TObject);
begin
  ClearData;
end;

function TPopupEditorWrapInfo.GetButtonAction: TAction;
begin
  if FButtonAction = nil then
  begin
    FButtonAction := TAction.Create(nil);
    FButtonAction.OnExecute := DoButtonAction;
    FButtonAction.Caption := '...';
    FButtonAction.Hint := '��ѯ����';
    FButtonAction.ShortCut := ShortCut(Ord('D'), [ssCtrl]);
  end;
  Result := FButtonAction;
end;

function TPopupEditorWrapInfo.GetClearAction: TAction;
begin
  if FClearAction = nil then
  begin
    FClearAction := TAction.Create(nil);
    FClearAction.OnExecute := DoActionClear;
    FClearAction.Caption := 'C';
    FClearAction.Hint := '���';
  end;
  Result := FClearAction;
end;

procedure TPopupEditorWrapInfo.DoPopupEnter(Sender: TObject);
begin
  TcxCustomPopupEdit(Sender).DroppedDown := True;
end;

{ TPopupEditorWrapper }

constructor TPopupEditorWrapper.Create(AOwner: TComponent);
begin
  inherited;
  // ����Wrapper��Ҫ����������ԣ��Ա㴫���¼�
  FOldOnWrapProperties := DevExpress.OnWrapProperties;
  DevExpress.OnWrapProperties := WrapProperites;
  FRegisteredEditor := TStringList.Create;
  FCreatedEditor := TStringList.Create;
  RegisterPopupEditor(sPopupViewName_DictIME, TDictIMEDialog);
  RegisterPopupEditor(sPopupViewName_AgeIME, TAgeIMEDialog);
end;

destructor TPopupEditorWrapper.Destroy;
begin
  FRegisteredEditor.Free;
  FCreatedEditor.Free;
  inherited;
end;

function TPopupEditorWrapper.GetPopupEditor(const AEditorName: string): TForm;
var
  I: Integer;
begin
  I := FRegisteredEditor.IndexOf(AEditorName);
  if I > -1 then
  begin

    Result := TForm(FCreatedEditor.Objects[I]);
    if Result = nil then
    begin
      Result := TFormClass(FRegisteredEditor.Objects[I]).Create(Application);
      FCreatedEditor.Objects[I] := Result;
    end;
  end
  else
    Result := nil;
end;

function TPopupEditorWrapper.GetWrapInfoClass: TWrapInfoClass;
begin
  Result := TPopupEditorWrapInfo;
end;

procedure TPopupEditorWrapper.RegisterPopupEditor(const AEditorName: string;
  AEditor: TFormClass);
begin
  FRegisteredEditor.AddObject(AEditorName, TObject(AEditor));
  FCreatedEditor.AddObject(AEditorName, nil);
end;

procedure TPopupEditorWrapper.WrapDataControl(AControl: TComponent;
  AProperties: TcxCustomEditProperties; AField: TDAField;
  ASource: TDADataSource; AMultiEditorAttributes: TStrings);
var
  EditorName: string;
  PopupWrapInfo: TPopupEditorWrapInfo;
begin
  if AMultiEditorAttributes <> nil then
  begin
    EditorName := AMultiEditorAttributes.Values['PopupEditor'];
    if EditorName = '' then
    begin
      EditorName := AMultiEditorAttributes.Values['IME.DictName'];
      if EditorName <> '' then
        EditorName := sPopupViewName_DictIME;
    end;
  end
  else
  begin
    EditorName := AField.CustomAttributes.Values['PopupEditor'];
    if EditorName = '' then
    begin
      EditorName := AField.CustomAttributes.Values['IME.DictName'];
      if EditorName <> '' then
        EditorName := sPopupViewName_DictIME;
    end;
  end;

  if EditorName <> '' then
  begin
    PopupWrapInfo := TPopupEditorWrapInfo(Wrap(AControl));
    with PopupWrapInfo do
    begin
      FEditorName := EditorName;
      DataSource := ASource;
      DataTable := ASource.DataTable;
      Properties := AProperties;
      Field := AField;
      if AMultiEditorAttributes <> nil then
        FMultiEditorAttributes.Text := AMultiEditorAttributes.Text;
      Wrap();
    end;
  end;
end;

procedure TPopupEditorWrapper.WrapProperites(AColumn: TComponent;
  AProperties: TcxCustomEditProperties; AField: TDAField;
  ASource: TDADataSource; AMultiEditorAttributes: TStrings);
begin
  WrapDataControl(AColumn, AProperties, AField, ASource,
    AMultiEditorAttributes);

  if Assigned(FOldOnWrapProperties) then
    FOldOnWrapProperties(AColumn, AProperties, AField, ASource,
      AMultiEditorAttributes);
end;

{ TReportConfigView }

function TReportConfigView.BuildLocalParamData: TCustomData;
begin
  Result := TCustomData.Create(Self, nil, '', 'ReportParam');

  Result.CustomAttributes.Add('OptionsView.DataRowHeight=50');

  with Result.Table.Fields.Add('ReportName', datString, 200) do
  begin
    Visible := False;
    InPrimaryKey := True;
    DisplayLabel := '������';
  end;
  with Result.Table.Fields.Add('ParamName', datString, 50) do
  begin
    DisplayLabel := '������';
    InPrimaryKey := True;
  end;
  with Result.Table.Fields.Add('ParamValue', datString, 3000) do
  begin
    DisplayLabel := '����ֵ';
    CustomAttributes.Add('Properties=Memo')
  end;

  with Result.Table.Fields.Add('Memo', datString, 200) do
  begin
    DisplayLabel := '��ע';
    CustomAttributes.Add('Properties=Memo')
  end;
end;

function TReportConfigView.BuildLocalReportData: TCustomData;
begin
  Result := TCustomData.Create(Self, nil, '', 'Report');

  with Result.Table.Fields.Add('ReportName', datString, 200) do
  begin
    InPrimaryKey := True;
    DisplayLabel := '������';
  end;
  with Result.Table.Fields.Add('Category', datString, 50) do
  begin
    Visible := False;
    CustomAttributes.Add('GroupIndex=0');
    DisplayLabel := '����';
  end;
  with Result.Table.Fields.Add('Memo', datString, 200) do
  begin
    DisplayLabel := '��ע';
    CustomAttributes.Add('Properties=Memo')
  end;
end;

procedure TReportConfigView.BuildViewLayout;
begin
  inherited;

  FReportData := DataContainer.Items[sDataNameMiscReport];
  if FReportData = nil then
    FReportData := BuildLocalReportData;

  FParamData := DataContainer.Items[sDataNameMiscReportParam];
  if FParamData = nil then
    FParamData := BuildLocalParamData;

  FParamData.BindMaster(FReportData, 'ReportName');

  FReportView := TTableGridDataView.Create(Self);
  with FReportView do
  begin
    BorderStyle := bsNone;
    Width := 350;
    SetDataEditing(True);
    SetActionsVisible([PrintAction]);
    PrintAction.OnExecute := DoPrintReport;
    InsertAction.ShortCut := 0;
    EditAction.ShortCut := 0;
    // Importing := True;
    IsEmbedded := True;
    ViewGroup.Caption := '��ӡ�б�';
    ViewGroup.ShowBorder := True;
    ViewData := FReportData;
    Printing := True;
  end;

  FParamView := TTableGridDataView.Create(Self);
  with FParamView do
  begin
    BorderStyle := bsNone;
    SetDataEditing(True);
    // Importing := True;
    IsEmbedded := True;
    ViewGroup.Caption := '��ӡ����';
    ViewGroup.ShowBorder := True;
    ViewData := FParamData;
  end;

  with ViewLayout.Items do
  begin
    LayoutDirection := ldHorizontal;
    AlignVert := avClient;
    AlignHorz := ahClient;

    with CreateItemForControl(FReportView) do
    begin
      AlignHorz := ahLeft;
      AlignVert := avClient;
    end;

    CreateItem(TdxLayoutSplitterItem);

    with CreateItemForControl(FParamView) do
    begin
      AlignHorz := ahClient;
      AlignVert := avClient;
    end;
  end;
end;

procedure TReportConfigView.DoPrintReport(Sender: TObject);
begin
  // ������ʵ�ִ�ӡ
  if Assigned(OnPrint) then
    OnPrint(Sender);
end;

function TReportConfigView.GetParamNameArray: TVariantArray;
begin
  SetLength(Result, FParamData.RecordCount);
  FParamData.First;
  while not FParamData.EOF do
  begin
    Result[FParamData.RecID] := FParamData.AsString['ParamName'];
    FParamData.Next;
  end;
end;

function TReportConfigView.GetParamValueArray: TVariantArray;
begin
  SetLength(Result, FParamData.RecordCount);
  FParamData.First;
  while not FParamData.EOF do
  begin
    Result[FParamData.RecID] := FParamData.AsString['ParamValue'];
    FParamData.Next;
  end;
end;

function TReportConfigView.GetReportName: string;
begin
  Result := FReportData.AsString['ReportName'];
end;

{ TAgeIMEDialog }

procedure TAgeIMEDialog.BuildDialog;
begin
  inherited;
  BorderStyle := bsDialog;
  Caption := '��������';
  FAgeEdit := TcxSpinEdit.Create(Self);
  FAgeEdit.Properties.MinValue := 0;
  FAgeEdit.Properties.MaxValue := 150;
  with DialogGroup.CreateItemForControl(FAgeEdit) do
  begin
    // Caption := '����';
  end;
end;

procedure TAgeIMEDialog.DoDialogCancel(Sender: TObject);
begin
  if Assigned(FNotifier) then
  begin
    FPopupWrapInfo.ClosePopup;
  end
  else
    ModalResult := mrCancel;
end;

procedure TAgeIMEDialog.DoDialogOK(Sender: TObject);
begin
  if Assigned(FNotifier) then
  begin
    FNotifier(Self);
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

function TAgeIMEDialog.DoModalDialog(Sender: TPopupEditorWrapInfo;
  const AFilterText: string): Boolean;
begin
  FPopupWrapInfo := Sender;
  FAgeEdit.Value := 0;
  Result := Start(Screen.ActiveControl, nil);
  if Result then
  begin
    EditData;
  end;
end;

procedure TAgeIMEDialog.DoPopup(Sender: TPopupEditorWrapInfo);
begin
  FAgeEdit.Value := 0;
end;

procedure TAgeIMEDialog.DoPopupClose(Sender: TPopupEditorWrapInfo);
begin
end;

procedure TAgeIMEDialog.DoPopupInit(Sender: TPopupEditorWrapInfo);
begin
  FPopupWrapInfo := Sender;
  Start(Screen.ActiveControl, DoPopupOK);
end;

procedure TAgeIMEDialog.DoPopupOK(Sender: TObject);
begin
  EditData;
  FPopupWrapInfo.DoPopupOK(Sender);
end;

procedure TAgeIMEDialog.EditData;
begin
  DataTable_IntoEditState(FPopupWrapInfo.FDataTable);
  FPopupWrapInfo.FDataTable.FieldByName(FPopupWrapInfo.FSetValueFields[0])
    .AsDateTime := Round(Date() - FAgeEdit.Value * 365.25);
end;

function TAgeIMEDialog.Start(ASender: TControl;
  ANotifier: TNotifyEvent): Boolean;
begin
  Result := False;
  FNotifier := ANotifier;
  if not Assigned(FNotifier) then
  begin
    PlaceFormBelowControl(Self, ASender);
    Result := Execute;
  end;
end;

initialization

PopupEditorWrapper := TPopupEditorWrapper.Create(nil);

finalization

FreeAndNil(PopupEditorWrapper);

end.
