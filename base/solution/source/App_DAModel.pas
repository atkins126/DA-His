{
  ����DataAbstract������ģ�ͻ����

  Written by caowm (remobjects@qq.com)
  2014��9��
}

unit App_DAModel;

interface

{$WARNINGS OFF}
{ .$Define EnableDAModelLogger }

uses
  SysUtils,
  Classes,
  Variants,
  StrUtils,
  DB,
  Contnrs,
  TypInfo,
  Types,
  Windows,
  FMTBcd,
  uROClient,
  uRODL,
  uROClientIntf,
  uRODynamicRequest,
  uDAScriptingProvider,
  DataAbstract4_Intf,
  uDADataTable,
  uDAMemDataTable,
  uDARemoteDataAdapter,
  uDADataStreamer,
  uDABin2DataStreamer,
  uRORemoteService,
  uDAInterfaces,
  uROEventRepository,
  uROBaseSuperChannel,
  uROBaseSuperTCPChannel,
  uDADataAdapter,
  uDADesigntimeCall,
  uROClasses,
  uDARemoteCommand,
  uROBinMessage,
  uROJsonMessage,
  uROLocalChannel,
  uROLocalServer,
  uDAWhere,
  uROMessage,
  uROTransportChannel,
  uDAFields,
  uDASchemaClasses,
  uDAXMLAdapter,
  uDAJSONDataStreamer,
  uROXmlRpcMessage,
  uROSOAPMessage,
{$IFDEF EnableDAModelLogger}App_Common, {$ENDIF}
  uDACore,
  App_Function;

{ ���·�����֯��Ԫ��
  uROJSONMessage,
  uROXmlRpcMessage,
  uROSOAPMessage,
  uROBaseHTTPClient,
  uROIndyHTTPChannel,
  uROIndyTCPChannel,
  uROSuperTCPChannel,
}
// uDAScriptingProvider,
// uDAEcmaScriptEngine,
// uDASpiderMonkeyScriptProvider,

const
  sTargetListSection = 'TargetList';

  sDataAdapterNotSet = 'û����������������:%s';
  sDataDefinitionDuplicate = '�ظ������߼�����:%s';
  sCommonDataContainerNotExists = 'û���ҵ���������:%s';
  sCommonDataIndexOutOfRange = '������������������Χ';
  sWorkerNoAccess = 'û�в���Ȩ��';

const
  sDABinaryOperator: array [TDABinaryOperator] of string = (' And ', ' Or ',
    ' Xor ', ' < ', ' <= ', ' > ', ' >= ', ' <> ', ' = ', ' Like ', ' In ',
    ' + ', ' - ', ' * ', ' / ', ' not in ');
  //
  // const
  // // ��Ԫ������(Binary Operator)
  // dboAnd = 0;
  // dboOr = 1;
  // dboXor = 2;
  // dboLess = 3;
  // dboLessOrEqual = 4;
  // dboGreater = 5;
  // dboGreaterOrEqual = 6;
  // dboNotEqual = 7;
  // dboEqual = 8;
  // dboLike = 9;
  // dboIn = 10;
  //
  // // �ֶ�����
  // datUnknown = 0;
  // datString = 1;
  // datDateTime = 2;
  // datFloat = 3;
  // datCurrency = 4;
  // datAutoInc = 5;
  // datInteger = 6;
  // datLargeInt = 7;
  // datBoolean = 8;
  // datMemo = 9;
  // datBlob = 10;
  // datWideString = 11;
  // datWideMemo = 12;
  // datLargeAutoInc = 13;
  // datByte = 14;
  // datShortInt = 15;
  // datWord = 16;
  // datSmallInt = 17;
  // datCardinal = 18;
  // datLargeUInt = 19;
  // datGuid = 20;
  // datXml = 21;
  // datDecimal = 22;
  // datSingleFloat = 23;
  // datFixedChar = 24;
  // datFixedWideChar = 25;
  // datCursor = 26;
  //
  // // ������־
  // fIn = 0;
  // fOut = 1;
  // fInOut = 2;
  // fResult = 3;
  //
  // // ��������
  // rtInteger = 0;
  // rtDateTime = 1;
  // rtDouble = 2;
  // rtCurrency = 3;
  // rtWidestring = 4;
  // rtString = 5;
  // rtInt64 = 6;
  // rtBoolean = 7;
  // rtVariant = 8;
  // rtBinary = 9;
  // rtXML = 10;
  // rtGuid = 11;
  // rtDecimal = 12;
  // rtUTF8String = 13;
  // rtXsDateTime = 14;
  // rtUserDefined = 15;

type

  { Data Export interface }
  IDataExportWizard = interface
    ['{174AE4D9-6F2A-4573-AE01-F4D25C236DD0}']
    procedure ExportData(ADataSet: TDataSet; AExportFields: string);
  end;

  { Data Import interface }
  IDataImportWizard = interface
    ['{04812F0C-5A73-4508-9105-04C22248A062}']
    procedure ImportData(ADataSet: TDataSet;
      AImportFields, AKeyColumns: string);
  end;

  TVariantArray = array of Variant;
  TDABinaryOperatorArray = array of TDABinaryOperator;

  TCustomData = class;
  TDataConnection = class;

  { Զ�̷������� }
  TROConnection = class(TComponent)
  private
    FTargetUrl: string;
    FTargetList: TStrings;
    FTargetIndex: Integer;
    FLoginServiceName: string;
    FSystemServiceName: string;
    FMessage: TROMessage;
    FChannel: TROTransportChannel;
    FService: TRORemoteService;
    FDynamicRequest: TRODynamicRequest;

{$IFDEF EnableDAModelLogger}
    PerformanceCounter1, PerformanceCounter2, PerformanceFrequency: Int64;
    procedure DataAdapterBeforeGetDataCall(Sender: TObject;
      Request: TRODynamicRequest);
    procedure DataAdapterAfterGetDataCall(Sender: TObject;
      Request: TRODynamicRequest);
    procedure DataAdapterGetSchemaCallBeforeExecute(Sender: TRODynamicRequest);
    procedure DataAdapterUpdateDataCallAfterExecute(Sender: TRODynamicRequest);
    procedure DataAdapterUpdateDataCallExecuteError(Sender: TRODynamicRequest;
      Error: Exception; var Ignore: Boolean);
    procedure DataAdapterUpdateDataCallBeforeExecute(Sender: TRODynamicRequest);
{$ENDIF}
  protected
    procedure SetTargetIndex(const Value: Integer);
    procedure SetTargetUrl(ATargetUrl: string); virtual;
  public
    constructor Create(AOwner: TComponent; ATargetUrl: string); virtual;
    destructor Destroy(); override;

    procedure ConnectLocalServer(ALocalServer: TROLocalServer);

    procedure MakeRequest(const AServiceName, AMethodName: string;
      AParamName: array of string; AParamValue: array of Variant;
      AParamType: array of TRODataType; AParamFlag: array of TRODLParamFlag);

    procedure BeginMethod(AServiceName, AMethodName: string);
    procedure SetMethodParam(AParamName: string; AParamValue: Variant;
      AParamType: Integer; AParamFlag: Integer);
    procedure EndMethod();
    function GetMethodParam(ParamName: string): Variant;

    function Login(ALoginText: string): string;
    procedure Logout();

    property TargetUrl: string read FTargetUrl write SetTargetUrl;
    property TargetList: TStrings read FTargetList;
    // Organizer����TargetUrl/TargetList
    property TargetIndex: Integer read FTargetIndex write SetTargetIndex;
    property LoginServiceName: string read FLoginServiceName
      write FLoginServiceName;
    property SystemServiceName: string read FSystemServiceName
      write FSystemServiceName;
    property ROMessage: TROMessage read FMessage;
    property Channel: TROTransportChannel read FChannel;
    property ROService: TRORemoteService read FService;
    property DynamicRequest: TRODynamicRequest read FDynamicRequest;
  end;

  // ����TDADataTable�Ĺ���
  TDataTableEnumProc = procedure(ADataTable: TDADataTable; AParam: Variant)
    of object;
  // ����TDADataTable.Fields�Ĺ���
  TTableFieldEnumProc = procedure(AField: TDAField; AParam: Variant) of object;
  // ��¼ѡ�����
  TRecordSelectionProc = function(ADataTable: TDADataTable): Boolean of object;

  // ��ȡѡ��ļ�¼�õ��ļ�¼
  TSelectTableRecord = record
    ResultList: TStrings;
    ResultField: string;
    CompareField: string;
    CompareValue: Variant;
  end;

  PSelectTableRecord = ^TSelectTableRecord;

  // ��ȡѡ��ļ�¼�õ��ļ�¼
  TSumTableRecord = record
    SumResult: Double;
    SumField: string;
    CompareField: string;
    CompareValue: Variant;
  end;

  PSumTableRecord = ^TSumTableRecord;

  { ������ͼ��� }
  TDataViewType = (dvGrid, dvBand, dvCard, dvChart, dvTree, dvPivot, dvForm);

  {
    ���ݷ����Ӧ�Ŀͻ���ͨѶ���

    ʹ��TDataServiceContainer.RegisterDataService���д���
  }
  TCustomDataService = class(TComponent)
  private
    FDataService: TRORemoteService;
    FDataStreamer: TDADataStreamer;
    FDataAdapter: TDARemoteDataAdapter;
    FDACommand: TDARemoteCommand;
    FDataConnection: TDataConnection;

    procedure CorrectService();
    function GetDataAdapter: TDARemoteDataAdapter;
    function GetDataService: TRORemoteService;
    function GetDACommand(): TDARemoteCommand;
    procedure DoBeforeExecuteCommandEx(Sender: TRODynamicRequest);
    procedure DoAfterExecuteCommandEx(Sender: TRODynamicRequest);
  public
    constructor Create(const AServiceName: string;
      ADataConnection: TDataConnection);

    procedure BeginCommand(ACommandName: string);
    procedure SetCommandParam(AParamName: string; AParamValue: Variant);
    procedure EndCommand();
    function GetCommandOutputParam(AParamName: string): Variant;

    property DAService: TRORemoteService read GetDataService;
    property DAAdapter: TDARemoteDataAdapter read GetDataAdapter;
    property DACommand: TDARemoteCommand read GetDACommand;
    property DAConnection: TDataConnection read FDataConnection;
  end;

  TCustomDataServiceClass = class of TCustomDataService;

  {
    ���ݷ�������
  }
  TDataConnection = class(TROConnection)
  private
    FDataAdapter: TDARemoteDataAdapter;
    FDataStreamer: TDADataStreamer;
    FDAStreamer: string;
    FDataServiceList: TObjectList;
    function NewDAStreamer(AOwner: TComponent): TDADataStreamer;
  public
    constructor Create(AOwner: TComponent; ATargetUrl: string;
      ADAStreamer: string); reintroduce;
    destructor Destroy(); override;

    function RegisterDataService(const AServiceName: string)
      : TCustomDataService; overload;
    function RegisterDataService(const AServiceName: string;
      AServiceClass: TCustomDataServiceClass): TCustomDataService; overload;
    function GetDataService(const AServiceName: string): TCustomDataService;

    property DataAdapter: TDARemoteDataAdapter read FDataAdapter;
  end;

  {
    ���ݻ���

    1. ע���ڵ�¼֮ǰ���ܷ���Table��Source

    2. ͨ��Ӧʹ��Open��������, ����ʹ��Table.Active:=True

    3. ͨ������RemoteDataAdapter.FillSchema����Schema�ж����������䵽
    TDAMemDataTable.CustomAttributes��TDAField.CustomAttributes�С�

    4. DataTable��CustomAttributesĿǰ���ܴ�Schema��ֱ�ӻ�ȡ��ֻ�������ж���, ����
    ��Schema�����һ���̶����Ƶ��ֶ�_Attr��ר��������DataTable���Զ������ԡ����
    �ֶ�Ҳ�ɸ��������һЩ��������<><><><><><><><><><><>(�������ѽ��)

    5. CustomAttributes�е������������ִ�Сд��
    �������Բο������ĵ�DataAbstract Schema.xls.

    6. ����DataTable���Զ��������ж���һ��ColorField���ԣ�����ָ���е�
    ����ɫ�����ڸ��ֶΡ�

    7. һ���ֶ���LookupResultFields�Զ��������п�ָ�����Lookup���������

    8. ��Schema�п�ָ��IndexFieldNames���ڲ�ѯ��ɺ��Զ�����
    ���Table.AutoSortRecords���ڱ༭���ݺ�����Զ����򣡣�����

    9. ���������ݷ�����ʱ�������ƴ��󣬿����������ر���

    10. �������ӱ��Զ��������ܣ����������ӱ���Ҫͬʱ�༭�����ݡ�
    ����EanableScroll/DisableScroll��������ʱ����TriggerScroll
    �ӱ��󶨵�����BindMaster�����߱�д��ӦOnScroll�¼�
    һ����ɰ󶨶�ɴӴ�!

    ������ݰ󶨵���TCustomTableGridDataView, ��ҪEnableScroll��TableView���𴥷�scroll

    ������¿���TCustomTableGridDataView.OnRecordScroll

    11. ����ʱ���Դ���������ѯʱ�ɾݴ˽��в�ͬ��ѯ�������߼�����Ҳ�ɾݴ������жϡ�
    Ŀǰʹ�ó�����Schema��һ�����壬��Ҫ�ݴ����ɶ���ֵ����ݱ�

  }
  TCustomData = class(TComponent)
  private
    FDataConnection: TDataConnection;
    FServiceName: string;
    FLogicalName: string;
    FTable: TDAMemDataTable;
    FSource: TDADataSource;
    // FScriptProvider: TDASpiderMonkeyScriptProvider;
    FKeyFieldNames: string;
    FAccess: string; // �����ֵ�ά��
    FDialogImage: string;
    FReporterNames: TStrings;
    FReporterTypeField: string;
    FReporterGroupField: string; // ��ӡ�����ֶΣ���ͬ��ֻ��ӡһ��
    FOnScroll: TNotifyEvent; // ���������ͼ��ͬ������ʱ����
    FOnBeforePost: TNotifyEvent;
    FOnBeforeDelete: TNotifyEvent;
    FOnAfterPost: TNotifyEvent;
    FOnAfterInsert: TNotifyEvent;
    FOnCalcFields: TNotifyEvent;
    FOnBeforeFilter: TNotifyEvent;

    FScrollObservers: TObjectList;
    FForeignField: string; // ����ֶΣ��������ӱ��ѯ
    FMasterData: TCustomData; // ����
    FMasterKey: Variant;
    FCreateParam: Variant;
    FAutoSave: Boolean; // �Զ�����

    FFilterFields: TStrings;
    FFilterFromServer: Boolean; // �Ƿ�ͨ�����������й���
    FFilterMinLen: Integer; // ������С����
    FFilterCompareOperator: string; // ���˱ȽϷ�

    FFixFilterField: string;
    FFixFilterText: string;
    FFixFilterOperator: TDABinaryOperator;

    function GetTable(): TDAMemDataTable;
    function GetSource(): TDADataSource;
    procedure SetLogicalName(ALogicalName: string);
    function GetDefaultViewType(): TDataViewType;
    function GetDescription(): string;
    function GetCategory(): string;

    procedure SetIndexFieldNames(AValue: string);
    function GetIndexFieldNames(): string;
    function GetKeyValue(): Variant;
    function GetAsString(const FieldName: string): string;
    procedure SetAsString(const FieldName: string; const Value: string);
    function GetAsVariant(const FieldName: string): Variant;
    procedure SetAsVariant(const FieldName: string; const Value: Variant);
    function GetAsCurrency(const FieldName: string): Currency;
    procedure SetAsCurrency(const FieldName: string; const Value: Currency);
    function GetAsBoolean(const FieldName: string): Boolean;
    procedure SetAsBoolean(const FieldName: string; const Value: Boolean);
    function GetAsInteger(const FieldName: string): Integer;
    procedure SetAsInteger(const FieldName: string; const Value: Integer);
    function GetAsDouble(const FieldName: string): Double;
    procedure SetAsDouble(const FieldName: string; const Value: Double);
    function GetCustomAttributes: TStrings;
    function GetFieldCustomAttributes(const FieldName: string): TStrings;
    function GetAsDecimal(const FieldName: string): TBCD;
    procedure SetAsDecimal(const FieldName: string; const Value: TBCD);
    function GetAsDateTime(const FieldName: string): TDateTime;
    procedure SetAsDateTime(const FieldName: string; const Value: TDateTime);
    function GetOldValue(const FieldName: string): Variant;
    function GetScrollObservers: TObjectList;
    function GetLogChanges: Boolean;
    procedure SetLogChanges(const Value: Boolean);
    function GetFieldLogChanges(const FieldName: string): Boolean;
    procedure SetFieldLogChanges(const FieldName: string; const Value: Boolean);
    function GetFieldDisplayLabel(const FieldName: string): string;
    procedure SetFieldDisplayText(const FieldName, Value: string);
    function GetParamValue(const ParamName: string): Variant;
    procedure SetParamValue(const ParamName: string; const Value: Variant);
    function GetMaxRecords: Integer;
    procedure SetMaxRecords(const Value: Integer);
    function GetParamCount: Integer;
    procedure SetFilterText(const Value: string);
    function GetFilterText: string;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;

    procedure InitTableBeforeOpen(ATable: TDAMemDataTable); virtual;
    procedure InitTableAfterSchema(ATable: TDAMemDataTable); virtual;
    procedure InitTableField(AField: TDAField; AParam: Variant); virtual;
    procedure SetFieldDefaultValue(AField: TDAField; AParam: Variant); virtual;
    procedure ValidatFieldValue(AField: TDAField; AParam: Variant); virtual;

    procedure DoInternalOpen(); virtual;
    procedure DoDataBeforePost(Sender: TDADataTable); virtual;
    procedure DoDataBeforeDelete(Sender: TDADataTable); virtual;
    procedure DoDataAfterInsert(Sender: TDADataTable); virtual;
    procedure DoDataAfterEdit(Sender: TDADataTable); virtual;
    procedure DoDataAfterPost(Sender: TDADataTable); virtual;
    procedure DoDataAfterScroll(Sender: TDADataTable); virtual;
    procedure DoDataCalcFields(Sender: TDADataTable); virtual;
    procedure DoMasterScroll(Sender: TDADataTable); virtual;
    procedure DoAutoSave(); virtual;
    procedure DoDataBeforeFilter(); virtual;

    property ScrollObservers: TObjectList read GetScrollObservers;
  public
    constructor Create(AOwner: TComponent; ADataConnection: TDataConnection;
      const AServiceName, ALogicalName: string); virtual;
    destructor Destroy(); override;

    procedure InitData();

    function CanEdit(): Boolean; virtual;
    function CanInsert(): Boolean; virtual;
    function CanDelete(): Boolean; virtual;
    function CanSave(): Boolean; virtual;
    function CanCancel(): Boolean; virtual;
    function CanQuery(): Boolean; virtual;
    function CanPrint(): Boolean; virtual;

    procedure Edit(); virtual;
    procedure Insert(); virtual;
    procedure Delete(); virtual;
    procedure Save(); virtual;
    procedure Cancel(); virtual;
    procedure First();
    procedure Prior();
    procedure Next();
    procedure Last();
    function Eof: Boolean;
    function RecID: Integer;
    function RecordCount(): Integer;
    function FieldByName(AName: string): TDAField;
    function GetBookmark(): TBookmark;
    procedure GotoBookmark(Bookmark: TBookmark);
    procedure FreeBookmark(Bookmark: TBookmark);
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean;

    procedure BindMaster(AMaster: TCustomData; const AForeignField: string);
    procedure QueryAfterMasterScroll(); virtual;
    procedure TriggerScroll();
    procedure DisableScroll();
    procedure EnableScroll();
    procedure DisableControls();
    procedure EnableControls();
    procedure EnableBatchUpdate();
    procedure DisableBatchUpdate();
    procedure ApplyUpdates(); virtual;

    procedure Open(); virtual;
    procedure Close(); virtual;
    procedure Refresh(); virtual;

    procedure EditWithNoLogChanges(FieldNames: array of string;
      FieldValues: array of Variant);
    procedure AssignFieldValue(const AFieldName: string; ASource: TCustomData;
      var ADone: Boolean); virtual;
    procedure ClearAllFieldValues();

    procedure SetFixFilter(const AFieldName, AFilterText: string;
      AFilterOperator: TDABinaryOperator = dboEqual); virtual;
    function GetFixFilterWhereText(): string;

    procedure DoLocalFilter(const AFilterText: string); virtual;
    procedure DoServerFilter(const AFilterText: string); virtual;

    procedure BuildDynamicWhere(const AFieldNames: array of string;
      const AFieldValues: array of Variant;
      const AOperators: array of TDABinaryOperator;
      const AListOperator: array of TDABinaryOperator);

    procedure OpenByList(const AFieldNames: array of string;
      const AFieldValues: array of Variant;
      const AOperators: array of TDABinaryOperator;
      const AListOperator: array of TDABinaryOperator);

    procedure OpenByFieldValue(const AFieldName: string; AFieldValue: Variant;
      AOperator: TDABinaryOperator = dboEqual);

    procedure OpenByPeriod(const ADateFieldName: string;
      ABeginDate, AEndDate: TDateTime);

    procedure OpenByBetween(const AFieldName: string;
      AStartValue, AEndValue: Variant);

    procedure OpenByKeyValue(AValue: Variant);

    procedure OpenByWhereText(const AText: string); deprecated;

    procedure OpenByParam(const AParamNames: array of string;
      const AParamValues: array of Variant);

    procedure CreateLocalTableFields(const ATableAttributes: string;
      const AFieldNames: array of string;
      const AFieldTypes: array of TDADataType;
      const AFieldSizes: array of Integer;
      const AFieldAttributes: array of string);

    function GetRecordText(const AFieldNames: string;
      ASeperator: string = ' '): string;

    property DataConnection: TDataConnection read FDataConnection;
    property Table: TDAMemDataTable read GetTable;
    property Source: TDADataSource read GetSource;
    property LogicalName: string read FLogicalName write SetLogicalName;
    property KeyFieldNames: string read FKeyFieldNames;
    property KeyValue: Variant read GetKeyValue;
    property DefaultViewType: TDataViewType read GetDefaultViewType;
    property IndexFieldNames: string read GetIndexFieldNames
      write SetIndexFieldNames;
    property Description: string read GetDescription;
    property LogChanges: Boolean read GetLogChanges write SetLogChanges;
    property Category: string read GetCategory;
    property Access: string read FAccess;
    property DialogImage: string read FDialogImage;
    property ReporterNames: TStrings read FReporterNames;
    property ReporterTypeField: string read FReporterTypeField
      write FReporterTypeField;
    property ReporterGroupField: string read FReporterGroupField
      write FReporterGroupField;
    property MasterData: TCustomData read FMasterData;
    property MasterKey: Variant read FMasterKey;
    property CreateParam: Variant read FCreateParam write FCreateParam;
    property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
    property FilterFields: TStrings read FFilterFields;
    property FilterFromServer: Boolean read FFilterFromServer
      write FFilterFromServer;
    property FilterText: string read GetFilterText write SetFilterText;
    property CustomAttributes: TStrings read GetCustomAttributes;
    property FieldCustomAttributes[const FieldName: string]: TStrings
      read GetFieldCustomAttributes;
    property FieldLogChanges[const FieldName: string]: Boolean
      read GetFieldLogChanges write SetFieldLogChanges;
    property FieldDisplayLabel[const FieldName: string]: string
      read GetFieldDisplayLabel write SetFieldDisplayText;
    property ParamValue[const ParamName: string]: Variant read GetParamValue
      write SetParamValue;
    property ParamCount: Integer read GetParamCount;
    property AutoSave: Boolean read FAutoSave write FAutoSave;
    property OldValue[const FieldName: string]: Variant read GetOldValue;
    property AsString[const FieldName: string]: string read GetAsString
      write SetAsString;
    property AsBoolean[const FieldName: string]: Boolean read GetAsBoolean
      write SetAsBoolean;
    property AsInteger[const FieldName: string]: Integer read GetAsInteger
      write SetAsInteger;
    property AsFloat[const FieldName: string]: Double read GetAsDouble
      write SetAsDouble;
    property AsDateTime[const FieldName: string]: TDateTime read GetAsDateTime
      write SetAsDateTime;
    property AsCurrency[const FieldName: string]: Currency read GetAsCurrency
      write SetAsCurrency;
    property AsVariant[const FieldName: string]: Variant read GetAsVariant
      write SetAsVariant;
    property AsDecimal[const FieldName: string]: TBCD read GetAsDecimal
      write SetAsDecimal;

  published
    property OnScroll: TNotifyEvent read FOnScroll write FOnScroll;
    property OnBeforePost: TNotifyEvent read FOnBeforePost write FOnBeforePost;
    property OnBeforeDelete: TNotifyEvent read FOnBeforeDelete
      write FOnBeforeDelete;
    property OnAfterPost: TNotifyEvent read FOnAfterPost write FOnAfterPost;
    property OnAfterInsert: TNotifyEvent read FOnAfterInsert
      write FOnAfterInsert;
    property OnCalcFields: TNotifyEvent read FOnCalcFields write FOnCalcFields;
    property OnBeforeFilter: TNotifyEvent read FOnBeforeFilter
      write FOnBeforeFilter;
  end;

  TCustomDataClass = class of TCustomData;

const
  // Data Definition Flag
  DD_DICTIONARY = $0001; // �ֵ��־

type

  { ������� }
  TDataDefinition = class
  private
    FDataConnection: TDataConnection;
    FServiceName: string;
    FLogicalName: string;
    FFlag: Integer;
    FData: TCustomData;
    FDataClass: TCustomDataClass;
    FCreateParam: Variant;

    function GetData(): TCustomData;
  public
    constructor Create(ADataConnection: TDataConnection;
      AServiceName, ALogicalName: string; ADataClass: TCustomDataClass;
      AFlag: Integer; ACreateParam: string);
    destructor Destroy(); override;

    function CreateData(AOwner: TComponent): TCustomData;

    property DAClient: TDataConnection read FDataConnection;
    property ServiceName: string read FServiceName;
    property LogicanName: string read FLogicalName;
    property Flag: Integer read FFlag;
    property DataClass: TCustomDataClass read FDataClass;
    property CreateParam: Variant read FCreateParam;
    property CustomData: TCustomData read GetData;
  end;

  {
    ��������

    1 �Զ��������ݣ�����CreateData������������(���ⲿ����)
    2 ֻ��GetSource���Զ������ݣ�GetItemByLogicalName�����в��Զ�������
    3 Ӧ��ע���������ݣ����ڼ��й���
  }
  TDataContainer = class
  private
    FDataList: TStringList;
    function GetDataDefinition(const ALogicalName: string): TDataDefinition;
    function GetDataDefinition2(Index: Integer): TDataDefinition;
    function GetItemByLogicalName(const ALogicalName: string): TCustomData;
    function GetCount(): Integer;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure RegisterData(ADataConnection: TDataConnection;
      const AServiceName, ALogicalName: string; AFlag: Integer;
      ACreateParam: string); overload;

    procedure RegisterData(ADataConnection: TDataConnection;
      const AServiceName, ALogicalName: string; ADataClass: TCustomDataClass;
      AFlag: Integer; ACreateParam: string); overload;

    procedure RegisterData(ADataConnection: TDataConnection;
      const AServiceName, ALogicalName: string; ADataClassName: String;
      AFlag: Integer; ACreateParam: string); overload;

    function CreateData(AOwner: TComponent; const ALogicalName: string)
      : TCustomData;

    function GetSource(const ALogicalName: string): TDADataSource;
    property Items[const ALogicalName: string]: TCustomData
      read GetItemByLogicalName; default;
    property ItemsByIndex[AIndex: Integer]: TDataDefinition
      read GetDataDefinition2;
    property Count: Integer read GetCount;
  end;

procedure EnumDataTable(ADataTable: TDADataTable; AEnumProc: TDataTableEnumProc;
  AParam: Variant);

procedure EnumDataTableField(ADataTable: TDADataTable;
  AEnumProc: TTableFieldEnumProc; AParam: Variant);

procedure DataTable_CopyFieldsDefinition(ASource, ADest: TDADataTable;
  AIgnoreAutoInc: Boolean);

procedure DataTable_CopyAllData(ASource, ADest: TCustomData);

procedure DataTable_CopySelectedData(ASource, ADest: TCustomData;
  AMultiSelectField: string;
  ASourceFields, ADestFields: array of string); overload;

procedure DataTable_CopySelectedData(ASource, ADest: TCustomData;
  AMultiSelectField: string); overload;

procedure DataTable_CopySelectedData(ASource, ADest: TCustomData;
  ARecordSelectionProc: TRecordSelectionProc); overload;

procedure DataTable_CopyCurrentRecord(ASource, ADest: TDADataTable); overload;

procedure DataTable_CopyCurrentRecord(ASource, ADest: TDADataTable;
  ASourceFields, ADestFields: array of string); overload;

procedure DataTable_GetSelectedList(ADataTable: TDADataTable;
  AResultList: TStrings; const AResultField, ACompareField: string;
  ACompareValue: Variant);

function DataTable_GetSelectedCommaText(ADataTable: TDADataTable;
  const AResultField, ACompareField: string; ACompareValue: Variant): string;

procedure DataTable_SaveToXmlStream(ADataTable: TDADataTable; AStream: TStream;
  MaxRows: Integer = -1);

function DataTable_GetXmlText(ADataTable: TDADataTable;
  MaxRows: Integer = -1): string;

procedure DataTable_SaveToXmlFile(ADataTable: TDADataTable; AFileName: string);

procedure DataTable_LoadFromXmlFile(ADataTable: TDADataTable;
  AFileName: string);

procedure DataTable_SaveToJsonStream(ADataTable: TDADataTable; AStream: TStream;
  MaxRows: Integer = -1);

function DataTable_GetJsonText(ADataTable: TDADataTable;
  MaxRows: Integer = -1): string;

procedure DataTable_SaveToJsonFile(ADataTable: TDADataTable; AFileName: string);

procedure DataTable_LoadFromJsonFile(ADataTable: TDADataTable;
  AFileName: string);

procedure DataTable_SetFieldsVisible(ADataTable: TDADataTable;
  AVisibleFields: array of string; AVisible: Boolean = True); overload;

procedure DataTable_SetFieldsVisible(ADataTable: TDADataTable;
  ACommaFields: string; AVisible: Boolean = True); overload;

function DataTable_GetSelectedSum(ADataTable: TDADataTable;
  const ASumField, ACompareField: string; ACompareValue: Variant): Double;

procedure DataTable_IntoEditState(ADataTable: TDADataTable);

procedure DataTable_UpdateFieldValue(ADataTable: TDADataTable;
  const AField: string; AValue: Variant);

var
  DataContainer: TDataContainer; // ����(�߼�)��������
  DataConnection: TDataConnection; // ����֯�ߴ���

  DataExportWizard: IDataExportWizard; // ��Advanced Data Export Wizard����
  DataImportWizard: IDataImportWizard; // ��Advanced Data Import Wizard����

implementation

// �������м�¼ָ���ֶε�ֵ
procedure DataTable_UpdateFieldValue(ADataTable: TDADataTable;
  const AField: string; AValue: Variant);
var
  bk: TBookmark;
begin
  ADataTable.DisableControls;
  try
    bk := ADataTable.GetBookmark;
    ADataTable.First;

    while not ADataTable.Eof do
    begin
      ADataTable.Edit;
      ADataTable.FieldByName(AField).Value := AValue;
      ADataTable.Post;;

      ADataTable.Next;
    end;
    ADataTable.GotoBookmark(bk);
  finally
    ADataTable.FreeBookmark(bk);
  end;
end;

procedure DataTable_IntoEditState(ADataTable: TDADataTable);
begin
  // ʹDataTable����༭״̬
  if not(ADataTable.State in [dsEdit, dsInsert]) then
    if ADataTable.Eof then
      ADataTable.Append
    else
      ADataTable.Edit;
end;

procedure DataTable_SaveToXmlStream(ADataTable: TDADataTable; AStream: TStream;
  MaxRows: Integer);
var
  Streamer: TDAXmlDataStreamer;
  bk: TBookmark;
begin
  Streamer := TDAXmlDataStreamer.Create(nil);
  if ADataTable.State in [dsEdit, dsInsert] then
    ADataTable.Post;
  bk := ADataTable.GetBookmark;
  ADataTable.DisableControls;
  try
    if MaxRows < 0 then
      ADataTable.First;
    Streamer.WriteDataset(AStream, ADataTable, [woRows], MaxRows);
  finally
    Streamer.Free;
    ADataTable.GotoBookmark(bk);
    ADataTable.EnableControls;
  end;
end;

function DataTable_GetXmlText(ADataTable: TDADataTable;
  MaxRows: Integer): string;
var
  StringStream: TStringStream;
begin
  // ��ȡDataTable��XML�ı���ʾ����洢���̵�XML�������ͽ��������
  // �ɶ�̬�޸�ҵ�����̣��������޸����
  StringStream := TStringStream.Create('', TEncoding.UTF8);
  try
    DataTable_SaveToXmlStream(ADataTable, StringStream, MaxRows);
    Result := StringStream.DataString;
    // ȥ����1��: <?xml version="1.0" encoding="utf-8"?>, SQLServer����ת����ʽ
    Result := Copy(Result, Pos('<XMLData>', Result), Length(Result));
  finally
    StringStream.Free;
  end;
end;

{ ��XML��ʽ�������� }

procedure DataTable_SaveToXmlFile(ADataTable: TDADataTable; AFileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(AFileName, fmCreate);
  try
    DataTable_SaveToXmlStream(ADataTable, FileStream);
  finally
    FileStream.Free;
  end;
end;

{ ��XML��ʽ�������� }

procedure DataTable_LoadFromXmlFile(ADataTable: TDADataTable;
  AFileName: string);
var
  Streamer: TDAXmlDataStreamer;
  FileStream: TFileStream;
begin
  Streamer := TDAXmlDataStreamer.Create(nil);
  try
    FileStream := TFileStream.Create(AFileName, fmOpenRead);
    try
      Streamer.ReadDataset(FileStream, ADataTable)
    finally
      FileStream.Free;
    end;
  finally
    Streamer.Free;
  end;
end;

procedure DataTable_SaveToJsonStream(ADataTable: TDADataTable; AStream: TStream;
  MaxRows: Integer);
var
  Streamer: TDAJSONDataStreamer;
  bk: TBookmark;
begin
  Streamer := TDAJSONDataStreamer.Create(nil);
  if ADataTable.State in [dsEdit, dsInsert] then
    ADataTable.Post;
  bk := ADataTable.GetBookmark;
  ADataTable.DisableControls;
  try
    if MaxRows < 0 then
      ADataTable.First;
    Streamer.WriteDataset(AStream, ADataTable, [woRows], MaxRows);
  finally
    Streamer.Free;
    ADataTable.GotoBookmark(bk);
    ADataTable.EnableControls;
  end;
end;

function DataTable_GetJsonText(ADataTable: TDADataTable;
  MaxRows: Integer): string;
var
  StringStream: TStringStream;
begin
  // ��ȡDataTable��XML�ı���ʾ����洢���̵�XML�������ͽ��������
  // �ɶ�̬�޸�ҵ�����̣��������޸����
  StringStream := TStringStream.Create('');
  try
    DataTable_SaveToJsonStream(ADataTable, StringStream, MaxRows);
    Result := StringStream.DataString;
    // ȥ����1��: <?xml version="1.0" encoding="utf-8"?>, SQLServer����ת����ʽ
    Result := Copy(Result, Pos('<XMLData>', Result), Length(Result));
  finally
    StringStream.Free;
  end;
end;

{ ��JSON��ʽ�������� }

procedure DataTable_SaveToJsonFile(ADataTable: TDADataTable; AFileName: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(AFileName, fmCreate);
  try
    DataTable_SaveToJsonStream(ADataTable, FileStream);
  finally
    FileStream.Free;
  end;
end;

{ ��JSON��ʽ�������� }

procedure DataTable_LoadFromJsonFile(ADataTable: TDADataTable;
  AFileName: string);
var
  Streamer: TDAJSONDataStreamer;
  FileStream: TFileStream;
begin
  Streamer := TDAJSONDataStreamer.Create(nil);
  try
    FileStream := TFileStream.Create(AFileName, fmOpenRead);
    try
      Streamer.ReadDataset(FileStream, ADataTable)
    finally
      FileStream.Free;
    end;
  finally
    Streamer.Free;
  end;
end;

{ �����ֶζ��� }

procedure DataTable_CopyFieldsDefinition(ASource, ADest: TDADataTable;
  AIgnoreAutoInc: Boolean);
var
  I: Integer;
begin
  ADest.CustomAttributes.Assign(ASource.CustomAttributes);
  ADest.Fields.Clear;
  for I := 0 to ASource.FieldCount - 1 do
  begin
    if not SameText(ASource.Fields[I].Name, 'RecID') then
      with ADest.Fields.Add do
      begin
        Assign(ASource.Fields[I]);

        if AIgnoreAutoInc and (DataType = datAutoInc) then
          DataType := datInteger;
      end;
  end;
end;

{ ����ȫ����Ϣ }

procedure DataTable_CopyAllData(ASource, ADest: TCustomData);
var
  bk: TBookmark;
begin
  ADest.DisableControls;
  ASource.DisableControls;
  try
    bk := ASource.GetBookmark;
    ASource.Save;
    ASource.First;

    while not ASource.Eof do
    begin
      ADest.Insert;
      DataTable_CopyCurrentRecord(ASource.Table, ADest.Table);
      ADest.Save;

      ASource.Next;
    end;
    ASource.GotoBookmark(bk);
  finally
    ASource.FreeBookmark(bk);
    ADest.EnableControls;
    ASource.EnableControls;
  end;
end;

{ ����ѡ��ļ�¼ }

procedure DataTable_CopySelectedData(ASource, ADest: TCustomData;
  AMultiSelectField: string; ASourceFields, ADestFields: array of string);
var
  bk: TBookmark;
begin
  ADest.DisableControls;
  ASource.DisableControls;
  try
    bk := ASource.GetBookmark;
    ASource.Save;
    ASource.First;
    while not ASource.Eof do
    begin
      if ASource.FieldByName(AMultiSelectField).AsBoolean then
      begin
        ADest.Insert;
        DataTable_CopyCurrentRecord(ASource.Table, ADest.Table, ASourceFields,
          ADestFields);
        ADest.Save;
      end;
      ASource.Next;
    end;
    ASource.GotoBookmark(bk);
  finally
    ADest.Cancel;
    ASource.FreeBookmark(bk);
    ADest.EnableControls;
    ASource.EnableControls;
  end;
end;

procedure DataTable_CopySelectedData(ASource, ADest: TCustomData;
  AMultiSelectField: string);
var
  bk: TBookmark;
begin
  ADest.DisableControls;
  ASource.DisableControls;
  try
    bk := ASource.GetBookmark;
    ASource.Save;
    ASource.First;
    while not ASource.Eof do
    begin
      if ASource.FieldByName(AMultiSelectField).AsBoolean then
      begin
        ADest.Insert;
        DataTable_CopyCurrentRecord(ASource.Table, ADest.Table);
        ADest.Save;
      end;
      ASource.Next;
    end;
    ASource.GotoBookmark(bk);
  finally
    ASource.FreeBookmark(bk);
    ADest.Cancel;
    ADest.EnableControls;
    ASource.EnableControls;
  end;
end;

procedure DataTable_CopySelectedData(ASource, ADest: TCustomData;
  ARecordSelectionProc: TRecordSelectionProc); overload;
var
  bk: TBookmark;
begin
  ADest.DisableControls;
  ASource.DisableControls;
  try
    bk := ASource.GetBookmark;
    ASource.Save;
    ASource.First;
    while not ASource.Eof do
    begin
      if ARecordSelectionProc(ASource.Table) then
      begin
        ADest.Insert;
        DataTable_CopyCurrentRecord(ASource.Table, ADest.Table);
        ADest.Save;
      end;
      ASource.Next;
    end;
    ASource.GotoBookmark(bk);
  finally
    ASource.FreeBookmark(bk);
    ADest.Cancel;
    ADest.EnableControls;
    ASource.EnableControls;
  end;
end;

{ ���Ʊ�ĵ�ǰ��¼���ֶ�ֵ }

procedure DataTable_CopyCurrentRecord(ASource, ADest: TDADataTable);
var
  I: Integer;
  FieldName: string;
begin
  for I := 0 to ADest.FieldCount - 1 do
  begin
    FieldName := ADest.Fields[I].Name;
    if not SameText(FieldName, 'RecID') and
      not(ADest.Fields[I].DataType in [datAutoInc, datLargeAutoInc]) and
      (ASource.FindField(FieldName) <> nil) then
      ADest.Fields[I].Value := ASource.FieldByName(FieldName).Value;
  end;
end;

{ ���Ʊ�ĵ�ǰ��¼���ֶ�ֵ }

procedure DataTable_CopyCurrentRecord(ASource, ADest: TDADataTable;
  ASourceFields, ADestFields: array of string);
var
  I: Integer;
begin
  Assert(Length(ASourceFields) = Length(ADestFields));
  for I := 0 to Length(ADestFields) - 1 do
  begin
    if not(ADest.FieldByName(ADestFields[I]).DataType in [datAutoInc,
      datLargeAutoInc]) then
      ADest.FieldByName(ADestFields[I]).Value :=
        ASource.FieldByName(ASourceFields[I]).Value;
  end;
end;

procedure DataTable_SetFieldsVisible(ADataTable: TDADataTable;
  AVisibleFields: array of string; AVisible: Boolean);
var
  I: Integer;
begin
  // ����Table�ֶεĿɼ��ԣ������ֶοɼ����෴
  // ���ڹ�����ͬ�Ľ��棬��������ʾ�ʹ���༭������ͬ
  for I := 0 to ADataTable.FieldCount - 1 do
    ADataTable.Fields[I].Visible := not AVisible;
  for I := 0 to Length(AVisibleFields) - 1 do
    ADataTable.FieldByName(AVisibleFields[I]).Visible := AVisible;
end;

procedure DataTable_SetFieldsVisible(ADataTable: TDADataTable;
  ACommaFields: string; AVisible: Boolean);
var
  FieldStrings: TStrings;
  I: Integer;
begin
  // ����Table�ֶεĿɼ��ԣ������ֶοɼ����෴
  // ���ڹ�����ͬ�Ľ��棬��������ʾ�ʹ���༭������ͬ
  for I := 0 to ADataTable.FieldCount - 1 do
    ADataTable.Fields[I].Visible := not AVisible;

  FieldStrings := TStringList.Create();
  try
    FieldStrings.CommaText := ACommaFields;
    for I := 0 to FieldStrings.Count - 1 do
    begin
      ADataTable.FieldByName(FieldStrings[I]).Visible := AVisible;
    end;
  finally
    FieldStrings.Free;
  end;
end;

{ ������ }

procedure EnumDataTable(ADataTable: TDADataTable; AEnumProc: TDataTableEnumProc;
  AParam: Variant);
var
  bk: TBookmark;
begin
  Assert(ADataTable <> nil);
  Assert(Assigned(AEnumProc));
  Assert(ADataTable.Active);

  with ADataTable do
    try
      DisableControls;
      bk := GetBookmark;
      First;
      while not Eof do
      begin
        AEnumProc(ADataTable, AParam);
        Next;
      end;
      GotoBookmark(bk);
    finally
      FreeBookmark(bk);
      EnableControls;
    end;
end;

{ ��������ֶΣ����������п�����ֶ� }

procedure EnumDataTableField(ADataTable: TDADataTable;
  AEnumProc: TTableFieldEnumProc; AParam: Variant);
var
  I: Integer;
  Fields: array of TDAField;
begin
  SetLength(Fields, ADataTable.Fields.Count);
  // �����������ڱ���ʱ������ֶΡ������ֶε�˳��
  for I := 0 to ADataTable.Fields.Count - 1 do
    Fields[I] := ADataTable.Fields[I];
  for I := Low(Fields) to High(Fields) do
    AEnumProc(Fields[I], AParam);
end;

procedure SelectTableCompareProc(Self: TObject; ATable: TDADataTable;
  AParam: Variant);
begin
  with ATable, PSelectTableRecord(Integer(AParam))^ do
  begin
    if FieldByName(CompareField).AsVariant = CompareValue then
      ResultList.Add(FieldByName(ResultField).AsString)
  end;
end;

procedure DataTable_GetSelectedList(ADataTable: TDADataTable;
  AResultList: TStrings; const AResultField, ACompareField: string;
  ACompareValue: Variant);
var
  Param: TSelectTableRecord;
begin
  { �Ƚ�һ���ֶε�ֵ���Ӷ��õ���һ���ֶ�ֵ���б� }
  with Param do
  begin
    ResultList := AResultList;
    ResultField := AResultField;
    CompareField := ACompareField;
    CompareValue := ACompareValue;
  end;
  EnumDataTable(ADataTable,
    TDataTableEnumProc(MakeMethod(@SelectTableCompareProc)), Integer(@Param));
end;

function DataTable_GetSelectedCommaText(ADataTable: TDADataTable;
  const AResultField, ACompareField: string; ACompareValue: Variant): string;
var
  ResultList: TStringList;
begin
  ResultList := TStringList.Create;
  try
    DataTable_GetSelectedList(ADataTable, ResultList, AResultField,
      ACompareField, ACompareValue);
    Result := ResultList.CommaText;
  finally
    ResultList.Free;
  end;
end;

procedure SumTableCompareProc(Self: TObject; ATable: TDADataTable;
  AParam: Variant);
begin
  with ATable, PSumTableRecord(Integer(AParam))^ do
  begin
    if FieldByName(CompareField).AsVariant = CompareValue then
      SumResult := SumResult + FieldByName(SumField).AsFloat;
  end;
end;

function DataTable_GetSelectedSum(ADataTable: TDADataTable;
  const ASumField, ACompareField: string; ACompareValue: Variant): Double;
var
  EnumParam: TSumTableRecord;
begin
  { �Ƚ�һ���ֶε�ֵ���Ӷ��õ���һ���ֶ�ֵ�ĺ� }
  with EnumParam do
  begin
    SumResult := 0;
    SumField := ASumField;
    CompareField := ACompareField;
    CompareValue := ACompareValue;
  end;
  EnumDataTable(ADataTable, TDataTableEnumProc(MakeMethod(@SumTableCompareProc)
    ), Integer(@EnumParam));
  Result := EnumParam.SumResult;
end;

{ TROConnection }

procedure TROConnection.BeginMethod(AServiceName, AMethodName: string);
begin
  ROService.ServiceName := AServiceName;
  DynamicRequest.MethodName := AMethodName;
  DynamicRequest.Params.Clear;
end;

procedure TROConnection.ConnectLocalServer(ALocalServer: TROLocalServer);
begin
  FreeAndNil(FMessage);
  FreeAndNil(FChannel);

  { ����Ϊ�ڲ�������Ĭ��Bin��ʽ }
  FMessage := TROBinMessage.Create(Self);
  FChannel := TROLocalChannel.Create(Self);
  TROLocalChannel(FChannel).ServerChannel := ALocalServer;

  FService.Message := FMessage;
  FService.Channel := FChannel;
end;

constructor TROConnection.Create(AOwner: TComponent; ATargetUrl: string);
begin
  inherited Create(AOwner);

  FLoginServiceName := 'LoginService';
  FSystemServiceName := 'SystemService';
  FTargetList := TStringList.Create;

  FService := TRORemoteService.Create(Self);
  FDynamicRequest := TRODynamicRequest.Create(Self);
  FDynamicRequest.RemoteService := FService;

  SetTargetUrl(ATargetUrl);
end;

{$IFDEF EnableDAModelLogger}

procedure TROConnection.DataAdapterAfterGetDataCall(Sender: TObject;
  Request: TRODynamicRequest);
begin
  QueryPerformanceCounter(PerformanceCounter2);
  QueryPerformanceFrequency(PerformanceFrequency);
  AppCore.Logger.WriteFmt('��ѯ��ʱ %0.3f ��',
    [(PerformanceCounter2 - PerformanceCounter1) /
    PerformanceFrequency], mtDebug);
end;

procedure TROConnection.DataAdapterBeforeGetDataCall(Sender: TObject;
  Request: TRODynamicRequest);
begin
  AppCore.Logger.Write('���ڲ�ѯ����...', mtDebug);
  QueryPerformanceCounter(PerformanceCounter1);
end;

procedure TROConnection.DataAdapterGetSchemaCallBeforeExecute
  (Sender: TRODynamicRequest);
begin
  AppCore.Logger.Write('�������������ڲ�ѯSchema...', mtDebug);
end;

procedure TROConnection.DataAdapterUpdateDataCallAfterExecute
  (Sender: TRODynamicRequest);
begin
  AppCore.Logger.Write('�����ύ�ɹ�', mtDebug);
end;

procedure TROConnection.DataAdapterUpdateDataCallBeforeExecute
  (Sender: TRODynamicRequest);
begin
  AppCore.Logger.Write('�����ύ����...', mtDebug);
end;

procedure TROConnection.DataAdapterUpdateDataCallExecuteError
  (Sender: TRODynamicRequest; Error: Exception; var Ignore: Boolean);
begin
  AppCore.Logger.Write('�����ύʧ�ܣ�ԭ��' + Error.Message, mtError);
end;
{$ENDIF}

destructor TROConnection.Destroy;
begin
  FreeAndNil(FMessage);
  FreeAndNil(FChannel);
  FreeAndNil(FTargetList);
  inherited;
end;

procedure TROConnection.EndMethod;
begin
  DynamicRequest.Execute(nil);
end;

function TROConnection.GetMethodParam(ParamName: string): Variant;
begin
  Result := DynamicRequest.ParamByName(ParamName).AsVariant;
end;

function TROConnection.Login(ALoginText: string): string;
begin
  MakeRequest(FLoginServiceName, 'Login', ['LoginText', 'Result'],
    [ALoginText, ''], [rtUtf8String, rtUtf8String], [fIn, fResult]);
  Result := FDynamicRequest.Params.ResultParam.AsString;
end;

procedure TROConnection.Logout;
begin
  MakeRequest(FLoginServiceName, 'Logout', [], [], [], []);
end;

// ��̬���÷����еķ��������ƣ������漰�Ĳ���ֻ���Ǽ����ͣ�����ʱ��������

procedure TROConnection.MakeRequest(const AServiceName, AMethodName: string;
  AParamName: array of string; AParamValue: array of Variant;
  AParamType: array of TRODataType; AParamFlag: array of TRODLParamFlag);
var
  I: Integer;
begin
  Assert((Length(AParamName) = Length(AParamValue)) and
    (Length(AParamValue) = Length(AParamType)), '���鳤�Ȳ�һ��');

  FService.ServiceName := AServiceName;
  with FDynamicRequest do
  begin
    MethodName := AMethodName;
    Params.Clear;
    for I := 0 to Length(AParamName) - 1 do
    begin
      with Params.Add do
      begin
        Name := AParamName[I];
        DataType := AParamType[I];
        Value := AParamValue[I];
        Flag := AParamFlag[I];
      end;
    end;
    Execute(nil);
  end;
end;

procedure TROConnection.SetMethodParam(AParamName: string; AParamValue: Variant;
  AParamType, AParamFlag: Integer);
begin
  with DynamicRequest.Params.Add do
  begin
    Name := AParamName;
    Value := AParamValue;
    Flag := TRODLParamFlag(AParamFlag);
    DataType := TRODataType(AParamType);
  end;
end;

procedure TROConnection.SetTargetIndex(const Value: Integer);
begin
  FTargetIndex := Value;
  if FTargetIndex >= FTargetList.Count then
    FTargetIndex := FTargetList.Count - 1;

  if (FTargetIndex < 0) and (FTargetList.Count > 0) then
    FTargetIndex := 0;

  if FTargetIndex >= 0 then
    TargetUrl := FTargetList.ValueFromIndex[FTargetIndex];
end;

procedure TROConnection.SetTargetUrl(ATargetUrl: string);
begin
  FreeAndNil(FMessage);
  FreeAndNil(FChannel);
  FTargetUrl := ATargetUrl;
  FMessage := TROMessage.MessageMatchingTargetUrl(ATargetUrl);
  FChannel := TROTransportChannel.ChannelMatchingTargetUrl(ATargetUrl);
  FService.Message := FMessage;
  FService.Channel := FChannel;
  if FMessage.InheritsFrom(TROJSONMessage) then
  begin
    with TROJSONMessage(FMessage) do
    begin
      IncludeTypeName := True;
      SessionIdAsId := True;
      SendExtendedException := True;
      WrapResult := True;
    end;
  end
  else if FMessage.InheritsFrom(TROXmlRpcMessage) then
  begin
    TROXmlRpcMessage(FMessage).SendSessionId := True;
  end;
end;

{ TCustomData }

function TCustomData.CanCancel: Boolean;
begin
  Result := Table.State in [dsEdit, dsInsert]
end;

procedure TCustomData.Cancel;
begin
  if CanCancel then
  begin
    Table.Cancel;
  end;
end;

function TCustomData.CanDelete: Boolean;
begin
  Result := not Table.ReadOnly and Table.Active and not Table.Eof and
    (Table.State in [dsBrowse]);
end;

{ ֻ����Table��״̬���ж��Ƿ�ɱ༭�����롢ɾ�� }

function TCustomData.CanEdit: Boolean;
begin
  Result := not Table.ReadOnly and Table.Active and not Table.Eof and
    (Table.State in [dsBrowse]);
end;

function TCustomData.CanInsert: Boolean;
begin
  Result := ((MasterData = nil) or (not MasterData.Eof)) and
    (not Table.ReadOnly) and Table.Active
  // and (Table.State in [dsBrowse]);
end;

function TCustomData.CanPrint: Boolean;
begin
  Result := Table.Active and not Table.Eof and (Table.State in [dsBrowse]) and
    (ReporterNames.Count > 0)
end;

function TCustomData.CanQuery: Boolean;
begin
  Result := ((MasterData = nil) or (not MasterData.Eof)) and
    not(Table.State in [dsEdit, dsInsert])
end;

function TCustomData.CanSave: Boolean;
begin
  Result := Table.State in [dsEdit, dsInsert];
end;

procedure TCustomData.Close;
begin
  DoAutoSave;
  Table.Close;
end;

constructor TCustomData.Create(AOwner: TComponent;
  ADataConnection: TDataConnection; const AServiceName, ALogicalName: string);
begin
  inherited Create(AOwner);
  FDataConnection := ADataConnection;
  FServiceName := AServiceName;
  FLogicalName := ALogicalName;
  FFilterFields := TStringList.Create;
  FFilterFields.Delimiter := ';';
  FReporterNames := TStringList.Create;
  FReporterNames.Delimiter := ';';
end;

procedure TCustomData.Delete;
begin
  Table.Delete;
end;

procedure TCustomData.DoDataAfterInsert(Sender: TDADataTable);
begin
  ClearAllFieldValues();
  if Assigned(FOnAfterInsert) then
    FOnAfterInsert(Self);
end;

procedure TCustomData.DoDataBeforeDelete(Sender: TDADataTable);
begin

end;

procedure TCustomData.DoDataBeforePost(Sender: TDADataTable);
begin
  EnumDataTableField(Sender, ValidatFieldValue, Null);

  if Assigned(FOnBeforePost) then
    FOnBeforePost(Self);
end;

procedure TCustomData.DoDataAfterPost(Sender: TDADataTable);
begin
  if Assigned(FOnAfterPost) then
    FOnAfterPost(Self);
end;

procedure TCustomData.Edit;
begin
  Table.Edit;
end;

function TCustomData.GetDefaultViewType: TDataViewType;
var
  Attr: string;
begin
  Attr := Trim(Table.CustomAttributes.Values['DefaultViewType']);
  if Attr = '' then
    Attr := 'dvGrid';
  Result := TDataViewType(GetEnumValue(TypeInfo(TDataViewType), Attr));
end;

function TCustomData.GetSource: TDADataSource;
begin
  if FSource = nil then
  begin
    FSource := TDADataSource.Create(Self);
    FSource.DataTable := Table;
    FSource.AutoEdit := False;
  end;
  Result := FSource;
end;

{ �״η���ʱ�Ŵ���DataTable }

function TCustomData.GetTable: TDAMemDataTable;
begin
  if FTable = nil then
  begin
    FTable := TDAMemDataTable.Create(Self);
    FTable.LogicalName := FLogicalName;
    FTable.BeforePost := DoDataBeforePost;
    FTable.BeforeDelete := DoDataBeforeDelete;
    FTable.AfterInsert := DoDataAfterInsert;
    FTable.AfterPost := DoDataAfterPost;
    FTable.AfterEdit := DoDataAfterEdit;
    // FTable.AfterScroll := DoDataAfterScroll;
    FTable.OnCalcFields := DoDataCalcFields;

    // ���������ݷ�����ʱ���������ر�ʹ��(ע�⣺�������������ͬ)
    if (FServiceName = '') or (FDataConnection = nil) then
    begin
      Table.RemoteFetchEnabled := False;
    end
    else
    begin
      FTable.RemoteDataAdapter := FDataConnection.GetDataService(FServiceName)
        .DAAdapter;
      FTable.RemoteUpdatesOptions := [ruoOnPost];

      // �����û�л�ȡSchema(��һ�η���)
      if FTable.FieldCount = 0 then
      begin
        InitTableBeforeOpen(FTable);
        Check(FTable.RemoteDataAdapter = nil, sDataAdapterNotSet,
          [FLogicalName]);

        // ��ȡSchema
        FTable.RemoteDataAdapter.FillSchema([FTable]);
        {
          // ���ؽű�
          FTable.RemoteDataAdapter.FillScripts([FTable]);
          if FTable.ScriptCode.Text <> '' then
          begin
          FScriptProvider := TDASpiderMonkeyScriptProvider.Create(nil);
          FTable.ScriptingProvider := FScriptProvider;
          end;
        }
        InitTableAfterSchema(FTable);
      end;
    end;
  end;
  Result := FTable;
end;

{
  �ڻ�ȡSchema�󱻵��ã��ɽ�һ���ֶ������Զ������ԡ�
  Schema���Ѱ��������Ķ���
}

procedure TCustomData.InitTableAfterSchema(ATable: TDAMemDataTable);
var
  I: Integer;
  SortFields: TStringDynArray;
  SortDirection: array of TDASortDirection;

  procedure SetSortDirection();
  var
    I: Integer;
  begin
    SetLength(SortDirection, Length(SortFields));
    for I := 0 to Length(SortFields) - 1 do
      SortDirection[I] := sdAscending;
  end;

begin
  FKeyFieldNames := '';
  FAccess := ATable.CustomAttributes.Values['Access'];
  IndexFieldNames := ATable.CustomAttributes.Values['IndexFieldNames'];
  // ʵ���Զ�����������IndexFieldNames/AutoSortRecords/Sort��
  // ����AfterPost�¼��е����������ڴ�й¶???
  if IndexFieldNames <> '' then
  begin
    ATable.AutoSortRecords := True;
    SortFields := DelimitedTextToArray(IndexFieldNames);
    SetSortDirection();
    ATable.Sort(SortFields, SortDirection);
  end;

  FDialogImage := ATable.CustomAttributes.Values['DialogImage'];
  FReporterNames.DelimitedText := ATable.CustomAttributes.Values
    ['ReporterNames'];
  FReporterTypeField := ATable.CustomAttributes.Values['ReporterTypeField'];
  FReporterGroupField := ATable.CustomAttributes.Values['ReporterGroupField'];

  FFilterFromServer := StrToBoolDef(ATable.CustomAttributes.Values
    ['FilterFromServer'], False);
  FFilterFields.DelimitedText := ATable.CustomAttributes.Values['FilterFields'];
  FFilterMinLen := StrToIntDef(ATable.CustomAttributes.Values
    ['FilterMinLen'], 0);
  FFilterCompareOperator := ATable.CustomAttributes.Values
    ['FilterCompareOperator'];
  if FFilterCompareOperator = '' then
    FFilterCompareOperator := 'like';

  // ���û�ж�������ֶΣ����Զ���������ı��ֶ�
  if FFilterFields.Count = 0 then
    for I := 0 to ATable.Fields.Count - 1 do
    begin
      if ATable.Fields[I].DataType in [datString, datWideString] then
        FFilterFields.Add(ATable.Fields[I].Name);
    end;

  EnumDataTableField(ATable, InitTableField, Null);
  // �����Զ��������У��������������ȡ. ���KeyFieldNames�Ѿ����ڣ��������ԣ�����ͻ
  ATable.CustomAttributes.Add('KeyFieldNames=' + KeyFieldNames);
  ATable.MaxRecords := StrToIntDef(ATable.CustomAttributes.Values
    ['MaxRecords'], -1);

end;

{ �ڻ�ȡSchemaǰ�����ã������������磺IndexFieldNames������ }

procedure TCustomData.InitTableBeforeOpen(ATable: TDAMemDataTable);
begin

end;

{ ��ȡ�ֶε��Զ������� }

procedure TCustomData.InitTableField(AField: TDAField; AParam: Variant);
var
  AttrValue: string;
  LookupField: TDAField;
  LookupData: TCustomData;
  LookupFields: TStrings;
  I: Integer;
begin
  if AField.InPrimaryKey then
  begin
    if FKeyFieldNames = '' then
      FKeyFieldNames := AField.Name
    else
      FKeyFieldNames := FKeyFieldNames + ';' + AField.Name
  end;

  AttrValue := Trim(AField.CustomAttributes.Values['Lookup']);
  if StrToBoolDef(AttrValue, False) then
  begin
    // ���Lookup�ֶ�
    // ���ܽ�Schema�е��ֶ�����ΪLookup�����򽫵��²�ѯʱ�ֶθ�����ƥ��
    // Lookup�ֶ���TableView��ʾʱ���Զ����������б�
    // ����������Schema��ֱ�Ӷ���Lookup�ֶ�
    LookupFields := TStringList.Create;
    try
      LookupFields.Delimiter := ';';
      LookupFields.DelimitedText :=
        Trim(AField.CustomAttributes.Values['LookupResultFields']);

      // �������ô������Lookup�ֶ�
      for I := 0 to LookupFields.Count - 1 do
      begin
        LookupField := FTable.Fields.Add;
        LookupField.Index := AField.Index + 1 + I;
        LookupField.Lookup := True;
        LookupField.LookupCache := True;
        LookupField.KeyFields :=
          Trim(AField.CustomAttributes.Values['KeyFields']);
        // û��ָ��ʱ�������Ǳ��ֶε�Lookup
        if LookupField.KeyFields = '' then
          LookupField.KeyFields := AField.Name;
        LookupField.LookupResultField := LookupFields.Strings[I];

        LookupData := DataContainer
          [AField.CustomAttributes.Values['LookupSource']];
        with LookupData.Source.DataTable.FieldByName
          (LookupField.LookupResultField) do
        begin
          LookupField.LookupSource := LookupData.Source;
          LookupField.DisplayLabel := DisplayLabel;
          LookupField.Name := AField.Name + '_' + Name;
          LookupField.LookupKeyFields := LookupData.KeyFieldNames;
          LookupField.DataType := DataType;
          LookupField.Size := Size;
          LookupField.Alignment := Alignment;
          LookupField.DecimalPrecision := DecimalPrecision;
          LookupField.DecimalScale := DecimalScale;
        end;
      end;
    finally
      LookupFields.Free;
    end;
  end;
end;

procedure TCustomData.Insert;
begin
  // Table.Insert;
  Table.Append;
end;

{
  ���û�д����ݣ��������
  ע�⣺��û�е�¼֮ǰ����Open
  �����ǰʹ����DynamicWhere, �������������
}

procedure TCustomData.Open;
begin
  DoInternalOpen;
end;

{ ˢ�� }

procedure TCustomData.Refresh;
begin
  Close;
  Open;
end;

{ ����DataAdapter������DataTable }

procedure TCustomData.Save;
begin
  if CanSave then
    Table.Post;
end;

{ ����LogicalName������DataTable }

procedure TCustomData.SetLogicalName(ALogicalName: string);
begin
  FLogicalName := ALogicalName;
  if FTable <> nil then
  begin
    FTable.Close;
    FTable.Fields.Clear;
  end;
end;

function TCustomData.GetDescription: string;
begin
  Result := Table.CustomAttributes.Values['Description'];
  if Result = '' then
    Result := FLogicalName;
end;

function TCustomData.GetCategory: string;
begin
  Result := Table.CustomAttributes.Values['Category'];
  if Result = '' then
    Result := 'δ����';
end;

{ �����ñ������Ȩ�� }
procedure TCustomData.SetFieldDefaultValue(AField: TDAField; AParam: Variant);
begin
  if (FMasterData <> nil) and (FForeignField = AField.Name) then
  begin
    // �Զ�Ϊ�󶨵����������ֶθ�ֵ
    AField.Value := FMasterData.GetKeyValue;
  end
  else if (AField.DefaultValue <> '') then
    AField.Value := AField.DefaultValue
  else if AField.DataType in [datFloat, datCurrency, datInteger, datLargeInt,
    datBoolean, datByte, datShortInt, datWord, datSmallInt, datCardinal,
    datLargeUInt, datDecimal, datSingleFloat] then
    AField.Value := 0
  else if AField.DataType in [datString, datWideString] then
    AField.Value := ''
  else if (AField.DataType = datDateTime) and AField.Required then
  begin
    if StrToBoolDef(AField.CustomAttributes.Values['Properties.SaveTime'], True)
    then
      AField.Value := Now()
    else
      AField.Value := Date();
  end
  else if AField.DataType = datGuid then
    AField.Value := GUIDToString(NewGuid);
end;

function TCustomData.GetKeyValue: Variant;
begin
  // ���ƣ������Ƕ���ֶ�
  if not Table.Eof then
    Result := Table.FieldByName(KeyFieldNames).AsVariant
  else
    Result := Null;
end;

procedure TCustomData.SetIndexFieldNames(AValue: string);
begin
  Table.IndexFieldNames := AValue;
end;

function TCustomData.GetIndexFieldNames: string;
begin
  Result := Table.IndexFieldNames;
end;

procedure TCustomData.First;
begin
  FTable.First;
end;

procedure TCustomData.Last;
begin
  FTable.Last;
end;

procedure TCustomData.Next;
begin
  FTable.Next;
end;

procedure TCustomData.Prior;
begin
  FTable.Prior;
end;

{
  ���߷�������Ϊ��������ʱʹ�ã����㴴���ֶΡ�
  ֻ��datString,datWideString�ֶ���Ҫָ�����ݴ�С������Ϊ0
}

procedure TCustomData.CreateLocalTableFields(const ATableAttributes: string;
  const AFieldNames: array of string; const AFieldTypes: array of TDADataType;
  const AFieldSizes: array of Integer; const AFieldAttributes: array of string);
var
  I: Integer;
begin
  Check((Length(AFieldNames) <> Length(AFieldTypes)) or
    (Length(AFieldTypes) <> Length(AFieldSizes)) or
    (Length(AFieldSizes) <> Length(AFieldAttributes)),
    'TCustomData.CreateClientFileds������С��һ��');

  Table.ClearFields;
  Table.CustomAttributes.Delimiter := ';';
  Table.CustomAttributes.DelimitedText := ATableAttributes;

  for I := 0 to Length(AFieldNames) - 1 do
  begin
    with Table.Fields.Add do
    begin
      Name := AFieldNames[I];
      DataType := AFieldTypes[I];
      if DataType in [datString, datWideString] then
        Size := AFieldSizes[I];
      CustomAttributes.Delimiter := ';';
      CustomAttributes.DelimitedText := AFieldAttributes[I];
    end;
  end;
end;

procedure TCustomData.DoDataCalcFields(Sender: TDADataTable);
begin
  if Assigned(FOnCalcFields) then
    FOnCalcFields(Self);
end;

procedure TCustomData.ValidatFieldValue(AField: TDAField; AParam: Variant);
begin
  // todo: У���ֶ�ֵ
  // if AField.Required and (AField.DataType in [datString, datWideString]) then
  // Check(Trim(AField.AsString) = '', '������%s', [AField.DisplayLabel]);
end;

{ ���ֶε�ֵ��ѯ }

procedure TCustomData.OpenByFieldValue(const AFieldName: string;
  AFieldValue: Variant; AOperator: TDABinaryOperator = dboEqual);
begin
  Close();
  with Table do
  begin
    // Where.Clear;
    DynamicWhere.Clear;
    DynamicWhere.Expression := DynamicWhere.NewBinaryExpression
      (DynamicWhere.NewField(LogicalName, AFieldName),
      DynamicWhere.NewConstant(AFieldValue, FieldByName(AFieldName).DataType),
      AOperator);
  end;
  DoInternalOpen;
end;

{ ��ʱ��β�ѯ }

procedure TCustomData.OpenByPeriod(const ADateFieldName: string;
  ABeginDate, AEndDate: TDateTime);
begin
  // ֻ��ѯ����ͳ�Ƶķ��ã��·�Ʊ�������˷ѷ�Ʊ������ͳ��
  OpenByList([ADateFieldName, ADateFieldName], [ABeginDate, AEndDate],
    [dboGreaterOrEqual, dboLessOrEqual], [dboAnd]);
end;

{ ������ֵ��ѯ }

procedure TCustomData.OpenByBetween(const AFieldName: string;
  AStartValue, AEndValue: Variant);
begin
  OpenByList([AFieldName, AFieldName], [AStartValue, AEndValue],
    [dboGreaterOrEqual, dboLessOrEqual], [dboAnd]);
end;

{ ������ֶε�ֵ���в�ѯ }

procedure TCustomData.OpenByList(const AFieldNames: array of string;
  const AFieldValues: array of Variant;
  const AOperators: array of TDABinaryOperator;
  const AListOperator: array of TDABinaryOperator);
begin
  Close;
  BuildDynamicWhere(AFieldNames, AFieldValues, AOperators, AListOperator);
  DoInternalOpen;
end;

procedure TCustomData.DoInternalOpen;
begin
  with Table do
    if not Active then
    begin
      DisableControls;
      try
        Open;
      finally
        EnableControls;
      end;
    end;
end;

procedure TCustomData.BuildDynamicWhere(const AFieldNames: array of string;
  const AFieldValues: array of Variant;
  const AOperators: array of TDABinaryOperator;
  const AListOperator: array of TDABinaryOperator);
var
  I: Integer;
  NewExpression, Expression: TDAWhereExpression;
  lDynamicWhere: TDAWhereBuilder;
begin
  Check((Length(AFieldNames) <> Length(AFieldValues)) or
    (Length(AFieldValues) <> Length(AOperators)), '��ѯ�ֶ��б�ֵ�б��ȽϷ��б�ĸ�����һ��');

  Check((Length(AFieldNames) - 1 <> Length(AListOperator)),
    '�����б�����������ֶ��б����-1');

  Close();
  lDynamicWhere := Table.DynamicWhere;
  lDynamicWhere.Clear;
  for I := 0 to Length(AFieldNames) - 1 do
  begin
    NewExpression := lDynamicWhere.NewBinaryExpression
      (lDynamicWhere.NewField('', AFieldNames[I]),
      lDynamicWhere.NewConstant(AFieldValues[I], FieldByName(AFieldNames[I])
      .DataType), AOperators[I]);
    if I = 0 then
      Expression := NewExpression
    else
      Expression := lDynamicWhere.NewBinaryExpression(Expression, NewExpression,
        AListOperator[I - 1]);
  end;
  lDynamicWhere.Expression := Expression;
end;

procedure TCustomData.BindMaster(AMaster: TCustomData;
  const AForeignField: string);
begin
  // ֻ�ܰ�һ����������󶨴�nil��
  if FMasterData <> nil then
  begin
    FMasterData.ScrollObservers.Remove(Self);
    FMasterData.RemoveFreeNotification(Self);
  end;
  FMasterData := AMaster;
  FForeignField := AForeignField;
  if FMasterData <> nil then
  begin
    FMasterData.ScrollObservers.Add(Self);
    FMasterData.FreeNotification(Self);
    FMasterData.TriggerScroll;
  end;
end;

procedure TCustomData.DoMasterScroll(Sender: TDADataTable);
begin
  Close; // Close�����Զ�����
  FMasterKey := Null;
  if (FMasterData.Table.State in [dsBrowse]) and not FMasterData.Table.Eof then
  begin
    FMasterKey := FMasterData.GetKeyValue;
  end;
  QueryAfterMasterScroll();
end;

procedure TCustomData.TriggerScroll;
var
  I: Integer;
begin
  if Assigned(FOnScroll) then
  begin
    FOnScroll(Self);
    // AppCore.Logger.Write(LogicalName + ' scrolled. ' +
    // KeyFieldNames + ' = ' + VarToStr(KeyValue));
  end;
  if FScrollObservers <> nil then
    for I := 0 to FScrollObservers.Count - 1 do
      TCustomData(FScrollObservers[I]).DoMasterScroll(Self.Table);
end;

procedure TCustomData.DoDataAfterScroll(Sender: TDADataTable);
begin
  TriggerScroll;
end;

procedure TCustomData.DisableScroll;
begin
  Table.AfterScroll := nil;
end;

{ EnableScrollӦ����û�а󶨵���ͼʱʹ�� }

procedure TCustomData.EnableScroll;
begin
  Table.AfterScroll := DoDataAfterScroll;
  TriggerScroll;
end;

procedure TCustomData.OpenByKeyValue(AValue: Variant);
begin
  OpenByFieldValue(KeyFieldNames, AValue);
end;

procedure TCustomData.OpenByWhereText(const AText: string);
begin
  Close();
  with Table do
  begin
    DynamicWhere.Clear;
    PlainWhereClause := AText;
  end;
  DoInternalOpen;
end;

procedure TCustomData.OpenByParam(const AParamNames: array of string;
  const AParamValues: array of Variant);
var
  I: Integer;
begin
  Check((Length(AParamNames) <> Length(AParamValues)), '��ѯ�������ƺ�ֵ�б������һ��');

  with Table do
  begin
    Close();
    for I := 0 to Length(AParamNames) - 1 do
    begin
      ParamByName(AParamNames[I]).Value := AParamValues[I];
    end;
  end;
  DoInternalOpen;
end;

function TCustomData.Eof: Boolean;
begin
  Result := Table.Eof;
end;

procedure TCustomData.InitData;
begin
  GetTable();
end;

procedure TCustomData.DoLocalFilter(const AFilterText: string);
var
  I: Integer;
  S, T, Operand: string;
begin
  { ���ع������� }
  if (FFilterMinLen > 0) and (Length(AFilterText) < FFilterMinLen) then
    Exit;

  DoDataBeforeFilter;

  with Table do
  begin
    Filtered := False;
    if Trim(AFilterText) = '' then
      Exit;
    S := '';
    for I := 0 to FilterFields.Count - 1 do
    begin
      if FFilterCompareOperator = 'like' then
        Operand := QuotedStr('%' + AFilterText + '%')
      else
        Operand := QuotedStr(AFilterText);

      T := FilterFields[I] + ' ' + FFilterCompareOperator + ' ' + Operand;

      if S <> '' then
        S := S + ' or ' + T
      else
        S := T;
    end;
    if FFixFilterField <> '' then
    begin
      S := S + ' and ' + FFixFilterField + '=' + FFixFilterText;
      // todo: ֻ����'='?
    end;
    Filter := S;
    Filtered := True;
  end;
end;

{
  ͨ����������������
  1 Ĭ�ϰ�AFilterText��������FilterText
  2 ���߸����ֶ��б�̬����DynamicWhere
  3 ����ɸ���Ĭ��ʵ��
}

procedure TCustomData.DoServerFilter(const AFilterText: string);
var
  WhereText: string;

  function GetWhereText(): string;
  var
    I: Integer;
    Temp, Operand: string;
  begin
    Result := '';
    for I := 0 to FilterFields.Count - 1 do
    begin
      if FFilterCompareOperator = 'like' then
        Operand := QuotedStr('%' + AFilterText + '%')
      else
        Operand := QuotedStr(AFilterText);

      Temp := FilterFields[I] + ' ' + FFilterCompareOperator + ' ' + Operand;
      if Result = '' then
        Result := Temp
      else
        Result := Result + ' or ' + Temp;
    end;
  end;

begin
  if (FFilterMinLen > 0) and (Length(AFilterText) < FFilterMinLen) then
    Exit;
  DoDataBeforeFilter;
  if ParamCount > 0 then
  begin
    ParamValue['FilterText'] := AFilterText;
    Refresh;
  end
  else
  begin
    // todo: �ĳ�dynamicwhere
    WhereText := GetWhereText;
    if FFixFilterField <> '' then
    begin
      WhereText := GetFixFilterWhereText + ' and (' + WhereText + ')';
    end;
    OpenByWhereText(WhereText);
  end;
end;

destructor TCustomData.Destroy;
begin
  DoAutoSave;
  // ������Ӱ�
  BindMaster(nil, '');
  FFilterFields.Free;
  FScrollObservers.Free;
  FReporterNames.Free;
  inherited;
end;

procedure TCustomData.SetFixFilter(const AFieldName, AFilterText: string;
  AFilterOperator: TDABinaryOperator);
begin
  FFixFilterField := AFieldName;
  FFixFilterText := AFilterText;
  FFixFilterOperator := AFilterOperator;
end;

{ ��������ģʽ }

procedure TCustomData.EnableBatchUpdate;
begin
  Table.RemoteUpdatesOptions := [];
end;

procedure TCustomData.DisableBatchUpdate;
begin
  Table.RemoteUpdatesOptions := [ruoOnPost];
end;

function TCustomData.GetFixFilterWhereText: string;
begin
  if FFixFilterField = '' then
    Result := ''
  else
    Result := FFixFilterField + sDABinaryOperator[FFixFilterOperator] +
      QuotedStr(FFixFilterText);
end;

procedure TCustomData.DisableControls;
begin
  Table.DisableControls;
end;

procedure TCustomData.EnableControls;
begin
  Table.EnableControls;
end;

function TCustomData.GetBookmark: TBookmark;
begin
  Result := Table.GetBookmark;
end;

procedure TCustomData.GotoBookmark(Bookmark: TBookmark);
begin
  Table.GotoBookmark(Bookmark);
end;

function TCustomData.FieldByName(AName: string): TDAField;
begin
  Result := Table.FieldByName(AName);
end;

function TCustomData.RecordCount: Integer;
begin
  Result := Table.RecordCount;
end;

function TCustomData.RecID: Integer;
begin
  Result := Table.RecNo - 1;
end;

function TCustomData.GetAsString(const FieldName: string): string;
begin
  Result := Table.FieldByName(FieldName).AsString;
end;

procedure TCustomData.SetAsString(const FieldName: string; const Value: string);
begin
  Table.FieldByName(FieldName).AsString := Value;
end;

function TCustomData.GetAsVariant(const FieldName: string): Variant;
begin
  Result := Table.FieldByName(FieldName).AsVariant;
end;

procedure TCustomData.SetAsVariant(const FieldName: string;
  const Value: Variant);
begin
  Table.FieldByName(FieldName).AsVariant := Value;
end;

function TCustomData.GetAsCurrency(const FieldName: string): Currency;
begin
  Result := Table.FieldByName(FieldName).AsCurrency;
end;

procedure TCustomData.SetAsCurrency(const FieldName: string;
  const Value: Currency);
begin
  Table.FieldByName(FieldName).AsCurrency := Value;
end;

function TCustomData.GetAsBoolean(const FieldName: string): Boolean;
begin
  Result := Table.FieldByName(FieldName).AsBoolean;
end;

procedure TCustomData.SetAsBoolean(const FieldName: string;
  const Value: Boolean);
begin
  Table.FieldByName(FieldName).AsBoolean := Value;
end;

function TCustomData.GetAsInteger(const FieldName: string): Integer;
begin
  Result := Table.FieldByName(FieldName).AsInteger;
end;

procedure TCustomData.SetAsInteger(const FieldName: string;
  const Value: Integer);
begin
  Table.FieldByName(FieldName).AsInteger := Value
end;

function TCustomData.GetCustomAttributes: TStrings;
begin
  Result := Table.CustomAttributes;
end;

function TCustomData.GetFieldCustomAttributes(const FieldName: string)
  : TStrings;
begin
  Result := Table.FieldByName(FieldName).CustomAttributes;
end;

function TCustomData.GetAsDouble(const FieldName: string): Double;
begin
  Result := Table.FieldByName(FieldName).AsFloat;
end;

procedure TCustomData.SetAsDouble(const FieldName: string; const Value: Double);
begin
  Table.FieldByName(FieldName).AsFloat := Value;
end;

function TCustomData.GetAsDecimal(const FieldName: string): TBCD;
begin
  Result := Table.FieldByName(FieldName).AsDecimal;
end;

procedure TCustomData.SetAsDecimal(const FieldName: string; const Value: TBCD);
begin
  Table.FieldByName(FieldName).AsDecimal := Value;
end;

function TCustomData.GetAsDateTime(const FieldName: string): TDateTime;
begin
  Result := Table.FieldByName(FieldName).AsDateTime;
end;

procedure TCustomData.SetAsDateTime(const FieldName: string;
  const Value: TDateTime);
begin
  Table.FieldByName(FieldName).AsDateTime := Value;
end;

procedure TCustomData.ApplyUpdates;
begin
  Table.ApplyUpdates();
end;

function TCustomData.GetOldValue(const FieldName: string): Variant;
begin
  Result := Table.FieldByName(FieldName).OldValue;
end;

function TCustomData.GetScrollObservers: TObjectList;
begin
  if FScrollObservers = nil then
    FScrollObservers := TObjectList.Create(False);
  Result := FScrollObservers;
end;

procedure TCustomData.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if AComponent = FMasterData then
  begin
    FMasterData := nil;
  end;
  inherited;
end;

function TCustomData.GetLogChanges: Boolean;
begin
  Result := Table.LogChanges;
end;

procedure TCustomData.SetLogChanges(const Value: Boolean);
begin
  Table.LogChanges := Value;
end;

function TCustomData.GetFieldLogChanges(const FieldName: string): Boolean;
begin
  Result := Table.FieldByName(FieldName).LogChanges;
end;

procedure TCustomData.SetFieldLogChanges(const FieldName: string;
  const Value: Boolean);
begin
  Table.FieldByName(FieldName).LogChanges := Value;
end;

function TCustomData.Locate(const KeyFields: string; const KeyValues: Variant;
  Options: TLocateOptions): Boolean;
begin
  Result := Table.Locate(KeyFields, KeyValues, Options);
end;

function TCustomData.GetRecordText(const AFieldNames: string;
  ASeperator: string): string;
var
  FieldList: TStrings;
  I: Integer;
  OneFieldText: string;
begin
  FieldList := TStringList.Create;
  try
    FieldList.Delimiter := ';';
    FieldList.DelimitedText := AFieldNames;
    for I := 0 to FieldList.Count - 1 do
    begin
      OneFieldText := FieldDisplayLabel[FieldList[I]] + ':' +
        AsString[FieldList[I]];
      if I = 0 then
        Result := OneFieldText
      else
        Result := Result + ASeperator + OneFieldText;
    end;
  finally
    FieldList.Free;
  end;
end;

function TCustomData.GetFieldDisplayLabel(const FieldName: string): string;
begin
  Result := Table.FieldByName(FieldName).DisplayLabel;
end;

procedure TCustomData.SetFieldDisplayText(const FieldName, Value: string);
begin
  Table.FieldByName(FieldName).DisplayLabel := Value;
end;

function TCustomData.GetParamValue(const ParamName: string): Variant;
begin
  Result := Table.Params.ParamByName(ParamName).Value;
end;

procedure TCustomData.SetParamValue(const ParamName: string;
  const Value: Variant);
begin
  Table.Params.ParamByName(ParamName).Value := Value;
end;

procedure TCustomData.QueryAfterMasterScroll;
begin
  // ����ɸ�����Ҫ�����ӵĲ�ѯ
  OpenByFieldValue(FForeignField, FMasterKey);
end;

procedure TCustomData.FreeBookmark(Bookmark: TBookmark);
begin
  Table.FreeBookmark(Bookmark);
end;

procedure TCustomData.EditWithNoLogChanges(FieldNames: array of string;
  FieldValues: array of Variant);
var
  OldLogChanges: Boolean;
  I: Integer;
begin
  Assert(Length(FieldNames) = Length(FieldValues));

  OldLogChanges := LogChanges;
  LogChanges := False;
  try
    Edit;
    for I := 0 to Length(FieldNames) - 1 do
      AsVariant[FieldNames[I]] := FieldValues[I];
    Save;
  finally
    LogChanges := OldLogChanges;
  end;
end;

function TCustomData.GetMaxRecords: Integer;
begin
  Result := Table.MaxRecords;
end;

procedure TCustomData.SetMaxRecords(const Value: Integer);
begin
  Table.MaxRecords := Value;
end;

procedure TCustomData.AssignFieldValue(const AFieldName: string;
  ASource: TCustomData; var ADone: Boolean);
begin
  // Wrapper����������ʱ����
  // ������Ը���FieldName��Source���Զ��帳ֵ
end;

procedure TCustomData.DoAutoSave;
begin
  if FAutoSave then
    try
      Save;
    except
    end;
end;

procedure TCustomData.ClearAllFieldValues;
begin
  // ��������ֶε�ֵ���ָ���Ĭ��ֵ
  if not(Table.State in [dsEdit, dsInsert]) then
    Table.Edit;
  EnumDataTableField(Table, SetFieldDefaultValue, Null);
end;

function TCustomData.GetParamCount: Integer;
begin
  Result := Table.Params.Count;
end;

procedure TCustomData.SetFilterText(const Value: string);
begin
  Table.Filtered := False;
  if Value = '' then
    Exit;
  Table.Filter := Value;
  Table.Filtered := True;
end;

function TCustomData.GetFilterText: string;
begin
  Result := Table.Filter;
end;

procedure TCustomData.DoDataAfterEdit(Sender: TDADataTable);
begin

end;

procedure TCustomData.DoDataBeforeFilter;
begin
  // ���������ò�ѯ����
  if Assigned(FOnBeforeFilter) then
    FOnBeforePost(Self);
end;

{ TDataContainer }

constructor TDataContainer.Create;
begin
  FDataList := TStringList.Create();
  // FDataList.Sorted := True;
end;

function TDataContainer.CreateData(AOwner: TComponent;
  const ALogicalName: string): TCustomData;
begin
  // �������ݣ����ⲿ�����ͷ�
  Result := GetDataDefinition(ALogicalName).CreateData(AOwner);
end;

destructor TDataContainer.Destroy;
var
  I: Integer;
begin
  for I := 0 to FDataList.Count - 1 do
    FDataList.Objects[I].Free;
  FreeAndNil(FDataList);
  inherited;
end;

function TDataContainer.GetCount: Integer;
begin
  Result := FDataList.Count;
end;

function TDataContainer.GetDataDefinition(const ALogicalName: string)
  : TDataDefinition;
var
  Index: Integer;
begin
  Index := FDataList.IndexOf(ALogicalName);
  Check(Index < 0, sCommonDataContainerNotExists, [ALogicalName]);
  Result := TDataDefinition(FDataList.Objects[Index]);
end;

function TDataContainer.GetDataDefinition2(Index: Integer): TDataDefinition;
begin
  Check((Index < 0) and (index >= Count), sCommonDataIndexOutOfRange);
  Result := TDataDefinition(FDataList.Objects[Index]);
end;

function TDataContainer.GetItemByLogicalName(const ALogicalName: string)
  : TCustomData;
begin
  Result := GetDataDefinition(ALogicalName).CustomData;
  // Result.InitData(); // ��ʼ��Schema
end;

{ ��Ҫ��Lookup�ֶ����á��˷����Զ������� }

function TDataContainer.GetSource(const ALogicalName: string): TDADataSource;
begin
  with Items[ALogicalName] do
  begin
    Open;
    Result := Source;
  end;
end;

procedure TDataContainer.RegisterData(ADataConnection: TDataConnection;
  const AServiceName, ALogicalName: string; AFlag: Integer;
  ACreateParam: string);
begin
  RegisterData(ADataConnection, AServiceName, ALogicalName, TCustomData, AFlag,
    ACreateParam);
end;

procedure TDataContainer.RegisterData(ADataConnection: TDataConnection;
  const AServiceName, ALogicalName: string; ADataClass: TCustomDataClass;
  AFlag: Integer; ACreateParam: string);
var
  DataItem: TDataDefinition;
begin
  Check(FDataList.IndexOf(ALogicalName) > -1, sDataDefinitionDuplicate,
    [ALogicalName]);
  DataItem := TDataDefinition.Create(ADataConnection, AServiceName,
    ALogicalName, ADataClass, AFlag, ACreateParam);
  FDataList.AddObject(ALogicalName, DataItem);
end;

procedure TDataContainer.RegisterData(ADataConnection: TDataConnection;
  const AServiceName, ALogicalName: string; ADataClassName: String;
  AFlag: Integer; ACreateParam: string);
begin
  RegisterData(ADataConnection, AServiceName, ALogicalName,
    TCustomDataClass(GetClass(ADataClassName)), AFlag, ACreateParam);
end;

{ TCustomDataService }

procedure TCustomDataService.BeginCommand(ACommandName: string);
begin
  with DACommand.ExecuteCall do
  begin
    ParamByName(OutgoingCommandNameParameter).AsString := ACommandName;
    with ParamByName(OutgoingParametersParameter) do
    begin
      AsComplexType := DataParameterArray.Create;
      OwnsComplexType := True;
    end;
  end;
end;

procedure TCustomDataService.CorrectService;
begin
  // TDataConnection��������TargetUrlʱ���ؽ�Channel/Message����ʱ��ͬ�������������
  if FDataService.Channel <> FDataConnection.Channel then
    FDataService.Channel := FDataConnection.Channel;
  if FDataService.Message <> FDataConnection.ROMessage then
    FDataService.Message := FDataConnection.ROMessage;
end;

constructor TCustomDataService.Create(const AServiceName: string;
  ADataConnection: TDataConnection);
begin
  inherited Create(nil);
  FDataConnection := ADataConnection;

  FDataService := TRORemoteService.Create(Self);
  with FDataService do
  begin
    ServiceName := AServiceName;
    Channel := ADataConnection.Channel;
    Message := ADataConnection.ROMessage;
  end;

  FDataStreamer := FDataConnection.NewDAStreamer(Self);
  FDataAdapter := TDARemoteDataAdapter.Create(Self);
  with FDataAdapter do
  begin
    DataStreamer := FDataStreamer;
    Assign(FDataConnection.DataAdapter);
    RemoteService := FDataService;
    CacheSchema := True;
  end;
end;

procedure TCustomDataService.DoAfterExecuteCommandEx(Sender: TRODynamicRequest);
var
  lParam: TRORequestParam;
begin
  lParam := Sender.Params.FindParam
    (DACommand.ExecuteCall.IncomingParametersParameter);
  if Assigned(lParam) then
    lParam.OwnsComplexType := True; // ��ֹ�ڴ�й¶
end;

procedure TCustomDataService.DoBeforeExecuteCommandEx
  (Sender: TRODynamicRequest);
var
  lParam: TRORequestParam;
begin
  lParam := Sender.Params.FindParam
    (DACommand.ExecuteCall.IncomingParametersParameter);
  if Assigned(lParam) then
    lParam.OwnsComplexType := True; // ��ֹ�ڴ�й¶
end;

procedure TCustomDataService.EndCommand;
var
  Cmd: TDASQLCommand;
begin
  with DAAdapter.Schema, DACommand.ExecuteCall do
  begin
    Cmd := Commands.SQLCommandByName(ParamByName(OutgoingCommandNameParameter)
      .AsString);
    Check(Cmd = nil, '��ǰ������Ч');
    Execute();
  end;
end;

function TCustomDataService.GetCommandOutputParam(AParamName: string): Variant;
var
  I: Integer;
begin
  with DataParameterArray(DACommand.ExecuteCall.ParamByName('aOutputParameters')
    .AsComplexType) do
    for I := 0 to Count - 1 do
      if SameText(AParamName, Items[I].Name) then
      begin
        Result := Items[I].Value;
        Exit;
      end;
end;

function TCustomDataService.GetDACommand: TDARemoteCommand;
begin
  if FDACommand = nil then
  begin
    FDACommand := TDARemoteCommand.Create(Self);
    FDACommand.RemoteService := FDataService;
    // FDACommand.ExecuteCall.RefreshParams(); ����Ӧ��̬������Service
    with FDACommand.ExecuteCall do
    begin
      Params.Clear();
      IncomingAffectedRowsParameter := Params.Add('Result', rtInteger,
        fResult).Name;
      OutgoingCommandNameParameter := Params.Add('aCommandName', rtUtf8String,
        fIn).Name;
      Params.Add('aInputParameters', rtUserDefined, fIn, 'DataParameterArray');
      Params.Add('aOutputParameters', rtUserDefined, fOut,
        'DataParameterArray');
      OutgoingParametersParameter := 'aInputParameters';
      IncomingParametersParameter := 'aOutputParameters';
      OnBeforeExecute := DoBeforeExecuteCommandEx;
      OnAfterExecute := DoAfterExecuteCommandEx;
      MethodName := 'ExecuteCommandEx';
    end;
  end;
  CorrectService;
  Result := FDACommand;
end;

function TCustomDataService.GetDataAdapter: TDARemoteDataAdapter;
begin
  CorrectService;
  Result := FDataAdapter;
end;

function TCustomDataService.GetDataService: TRORemoteService;
begin
  CorrectService;
  Result := FDataService;
end;

procedure TCustomDataService.SetCommandParam(AParamName: string;
  AParamValue: Variant);
begin
  with DACommand.ExecuteCall do
  begin
    with DataParameterArray(ParamByName(OutgoingParametersParameter)
      .AsComplexType).Add do
    begin
      Name := AParamName;
      Value := AParamValue;
    end;
  end;
end;

{ TDataConnection }

constructor TDataConnection.Create(AOwner: TComponent; ATargetUrl: string;
  ADAStreamer: string);
begin
  inherited Create(AOwner, ATargetUrl);
  FDataServiceList := TObjectList.Create(True);
  FDAStreamer := ADAStreamer;
  FDataStreamer := NewDAStreamer(Self);
  FDataAdapter := TDARemoteDataAdapter.Create(Self);
  with FDataAdapter do
  begin
    RemoteService := FService;
    DataStreamer := FDataStreamer;
{$IFDEF EnableDAModelLogger}
    AfterGetDataCall := DataAdapterAfterGetDataCall;
    BeforeGetDataCall := DataAdapterBeforeGetDataCall;
    GetSchemaCall.OnBeforeExecute := DataAdapterGetSchemaCallBeforeExecute;
    UpdateDataCall.OnAfterExecute := DataAdapterUpdateDataCallAfterExecute;
    UpdateDataCall.OnBeforeExecute := DataAdapterUpdateDataCallBeforeExecute;
    UpdateDataCall.OnExecuteError := DataAdapterUpdateDataCallExecuteError;
{$ENDIF}
  end;
end;

destructor TDataConnection.Destroy;
begin
  FreeAndNil(FDataServiceList);
  inherited;
end;

function TDataConnection.GetDataService(const AServiceName: string)
  : TCustomDataService;
var
  Index: Integer;
begin
  Result := nil;
  if (AServiceName = '') then
    Exit;

  for Index := 0 to FDataServiceList.Count - 1 do
  begin
    if SameText(TCustomDataService(FDataServiceList[Index])
      .DAService.ServiceName, AServiceName) then
    begin
      Result := TCustomDataService(FDataServiceList[Index]);
      Break;
    end;
  end;
  if Result = nil then
  begin
    // �Զ�ע�����ݷ���
    Result := RegisterDataService(AServiceName);
  end;
end;

function TDataConnection.NewDAStreamer(AOwner: TComponent): TDADataStreamer;
begin
  if SameText(FDAStreamer, 'JSON') then
    Result := TDAJSONDataStreamer.Create(AOwner)
  else
    Result := TDABin2DataStreamer.Create(AOwner);
end;

function TDataConnection.RegisterDataService(const AServiceName: string;
  AServiceClass: TCustomDataServiceClass): TCustomDataService;
begin
  Assert(AServiceClass <> nil);
  // if GetDataService(AServiceName) <> nil then
  // raise Exception.CreateFmt('�����ظ�ע�����ݷ���%s', [AServiceName]);

  Result := AServiceClass.Create(AServiceName, Self);
  FDataServiceList.Add(Result);
end;

function TDataConnection.RegisterDataService(const AServiceName: string)
  : TCustomDataService;
begin
  Result := RegisterDataService(AServiceName, TCustomDataService);
end;

{ TDataDefinition }

constructor TDataDefinition.Create(ADataConnection: TDataConnection;
  AServiceName, ALogicalName: string; ADataClass: TCustomDataClass;
  AFlag: Integer; ACreateParam: string);
begin
  FDataConnection := ADataConnection;
  FServiceName := AServiceName;
  FLogicalName := ALogicalName;
  FDataClass := ADataClass;
  if FDataClass = nil then
    FDataClass := TCustomData;
  FFlag := AFlag;
  FCreateParam := ACreateParam;
end;

function TDataDefinition.CreateData(AOwner: TComponent): TCustomData;
begin
  Result := FDataClass.Create(AOwner, FDataConnection, FServiceName,
    FLogicalName);
  Result.CreateParam := FCreateParam;
end;

destructor TDataDefinition.Destroy;
begin
  FreeAndNil(FData);
  inherited;
end;

function TDataDefinition.GetData: TCustomData;
begin
  if FData = nil then
    FData := CreateData(nil);
  Result := FData;
end;

initialization

DataContainer := TDataContainer.Create;

finalization

FreeAndNil(DataContainer);

end.
