unit App_Common;

{
  �������

  Written by caowm (remobjects@qq.com)
  2014��9��
}

interface

{$DEFINE UsecxGraphics}

uses
  Windows,
  Classes,
  SysUtils,
  Graphics,
  Controls,
  Forms,
  Messages,
  Variants,
  Contnrs,
  IniFiles,
  ImgList,
  Jpeg,
  Types,
  Menus,
{$IFDEF UsecxGraphics}cxGraphics, dxGDIPlusClasses, {$ENDIF}
  ExtCtrls,
  StdCtrls,
  SyncObjs,
  ActnList;

const
  sAppCommonVersion = '0.9';
  sRootImageName = 'root';
  sFolderImageName = 'folder';
  sDefaultImageName = 'default';
  sAppSection = 'Application';

  CM_LOGGER = WM_USER + 1;

const
  // ҵ���־λ
  iOperationFlag_NoMenu = $0001; // ���˵����ر�־
  iOperationFlag_NoTree = $0002; // ���������ر�־
  iOperationFlag_Start = $0004; // ������־

  // ҵ������ 0~255ϵͳ����
  iOperationCommand_Default = 0; // Ĭ��
  iOperationCommand_Start = 1; // ����
  iOperationCommand_Clear = 2; // ����
  iOperationCommand_Notify = 3; // ��1������ΪSender����
  iOperationCommand_PluginControl = 4; // �Ƿ�֧�ֲ�����
  iOperationCommand_UnloadPlugin = 5; // ж�ز��
  iOperationCommand_Custom = 255; // �Զ�������

const
  // Build Tool Bar Flag
  BTN_SHOWCAPTION = $0001;
  BTN_NOTFLAT = $0002;
  BTN_CANBEFOCUSED = $0004;
  BTN_NOTTRANSPARENT = $0008;
  BTN_NOPOPUPMENU = $0010;
  BTN_NOTOOLBAR = $0020;

const
  // ����ID 0~255��ϵͳ����
  iFunctionID_UpdateApp = 1;

const
  sMessageSuccess = '�����ɹ�.';

type

  TSubject = class;

  { *
    �۲���

    һ��Observeֻ��Ӧһ��Subject, �ڴ���TObserver, TSubject֮��
    ����ʱ����Free, ����Detach.
    �������OnUpdate���Ĳ������٣�Ӧ���ȿ�����Sender�����״̬

    ʹ�÷���
    1 ����TSubject
    2 ����TObserver��Update����
    3 ����TSubject.Attach
    4 ����TSubject.Notify. ����֮ǰSender�뱣��״̬���Ա�Observer��ѯ
    * }
  TObserver = class(TObject)
  private
    FOnUpdate: TNotifyEvent;
    FSubject: TSubject;
  protected
    procedure Update(Sender: TObject); virtual;
  public
    constructor Create(OnUpdate: TNotifyEvent);
    destructor Destroy(); override;
    property OnUpdate: TNotifyEvent read FOnUpdate write FOnUpdate;
  end;

  { *
    ������
    * }
  TSubject = class(TObject)
  private
    FObservers: TList;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Attach(Observer: TObserver);
    procedure Detach(Observer: TObserver);
    procedure Notify(Sender: TObject); virtual;
  end;

  { *
    TImageListĿ¼�ļ���

    ��̬����Ŀ¼�е�ͼƬ, ����ΪͼƬָ��ͳһ�ĺ�׺.
    * }
  TFileImageList = class(TComponent)
  private
    FImageList: {$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF};
    FDisabledImages:
{$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF};
    FImagePath: string;
    FPostfix: string;
    FImageNames: TStrings;
    FDefaultIndex: Integer;
  public
    constructor Create(AOwner: TComponent; const AImagePath, AImageNamePostfix,
      ADefaultImageName: string; AImageWidth, AImageHeight: Integer);
      reintroduce;

    destructor Destroy(); override;
    function IndexOf(const AImageName: string): Integer;

    property ImageList:
{$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF} read FImageList;
    property DisabledImages:
{$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF} read FDisabledImages;
    property ImagePath: string read FImagePath;
    property ImageNames: TStrings read FImageNames;
    property DefaultIndex: Integer read FDefaultIndex;
  end;

  { *
    ͼƬ������

    �����С�����͵�ͼƬ����
    * }
  TImageCenter = class
  private
    FImagePath: string;
    FImageNames: TStrings;
  public
    constructor Create(const AImagePath: string);
    destructor Destroy(); override;
    function Get(const AImageName: string): TPicture;
    function GetBitmap(const AImageName: string): TBitmap;
  end;

type
  TLogType = (mtDebug, mtInfo, mtWarning, mtError);

  TLogInfo = class(TPersistent)
  private
    FRefCount: Integer; // ���ü���
    FTime: TDateTime;
    FType: TLogType;
    FCode: Integer;
    FText: string;
  public
    procedure Assign(Source: TPersistent); override;
    function AddRef(): Integer;
    function ReleaseRef(): Integer;

    property Time: TDateTime read FTime write FTime;
    property LogType: TLogType read FType write FType;
    property Code: Integer read FCode write FCode;
    property Text: string read FText write FText;
  end;

  { *
    ����������־��¼��

    ���ڳ�����ԣ������̰߳�ȫ�ġ�
    LogSubject��Sender��TLogInfo.
    * }
  TLogger = class
  private
    FLogMaxCount: Cardinal; // �����־����
    FLogFileMaxCount: Cardinal; // ��־�ļ�������
    FLogFileMaxSize: Cardinal; // ��־�ļ�����С
    FEnabled: Boolean;
    FLogLevel: Integer;
    FIniSection: string;
    FRewrite: Boolean;
    FTime: TDateTime;
    FLogType: TLogType;
    FCode: Integer;
    FText: string;
    FLogList: TStrings;
    FCriticalSection: TCriticalSection;
    FLogSubject: TSubject;

    procedure BackupLogFile(const ATempFileName: string; Index: Integer);
  public
    constructor Create();
    destructor Destroy(); override;
    procedure LoadState(AIniFile: TIniFile);
    procedure SaveState(AIniFile: TIniFile);
    procedure SaveLog(const ATempFileName: string);

    procedure Write(AValue: Variant; AType: TLogType; ACode: Integer);
    procedure WriteFmt(const AFormat: string; AValues: array of const;
      AType: TLogType; ACode: Integer);

    property Enabled: Boolean read FEnabled write FEnabled;
    property Rewrite: Boolean read FRewrite write FRewrite;
    property LogLevel: Integer read FLogLevel write FLogLevel;
    property MaxCount: Cardinal read FLogMaxCount write FLogMaxCount;
    property LogFileMaxCount: Cardinal read FLogFileMaxCount
      write FLogFileMaxCount;
    property LogFileMaxSize: Cardinal read FLogFileMaxSize
      write FLogFileMaxSize;
    property LogSubject: TSubject read FLogSubject;
    property LogList: TStrings read FLogList;
    property LogCriticalSection: TCriticalSection read FCriticalSection;

    property Time: TDateTime read FTime;
    property LogType: TLogType read FLogType;
    property Code: Integer read FCode;
    property Text: string read FText;
  end;

const
  cLogTypeText: array [TLogType] of string = ('����', '��Ϣ', '����', '����');
  cLogImageName: array [TLogType] of string = ('debug', 'info',
    'warning', 'error');

type
  TBaseViewPluginManager = class;
  TMainView = class;
  TBaseOperation = class;
  TProcOperation = class;
  TViewOperation = class;
  TOperations = class;
  TBaseViewClass = class of TBaseView;

  { *
    ҵ�����ִ�й���

    ������TObject.Dispatch(TMessage)һ��,��ȡ�̶�����ʽ,�������.
    �����ߺͱ�������֮�����Ԥ�ȹ涨�õ��ýӿ�.

    @Param Sender ������
    @Param CommandID ҵ���
    @Param Param ��Ӧ����
    * }

  TOperationEnumProc = procedure(AOperation: TBaseOperation) of object;
  TOperationState = (osCreating, osUpdating, osRemoving);

  TViewState = (vsShowing, vsHiding);

  { *
    ������ͼ

    ������ͼ��TMainView��TViewOperation����
    ����ģ��ɸ�����ͼ��Action�Զ��������߰�ť��
    ���д�����ͼ���й���Actionʱ������BaseView���������
    * }
  TBaseView = class(TForm)
  private
    FOperation: TBaseOperation;
    FViewActionList: TActionList;
    FHelpContent: string;
    FViewState: TViewState;
    FPluginManager: TBaseViewPluginManager;
    function GetActionList(): TActionList;
    procedure SetActionList(AActionList: TActionList);
  protected
    procedure SetOperation(const Value: TBaseOperation); virtual;
    function GetImageName(): string; virtual;
    function GetFreeOnClose(): Boolean; virtual;
    procedure DoShortCut(var Msg: TWMKey; var Handled: Boolean); virtual;

    procedure DoInitView(); virtual;
    procedure DoShowView(); virtual;
    procedure DoHideView(); virtual;
    function GetPluginManager(): TBaseViewPluginManager; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    function DoExecute(CommandID: Integer; const Param: array of Variant)
      : Variant; virtual;

    function BuildAction(ACaption, AImageName, AHint: string;
      AOnUpdate, AOnExecute: TNotifyEvent; AShortCut: TShortCut;
      ATag: Integer): TAction;

    procedure SaveSize();
    procedure RestoreSize(ADefaultWidth, ADefaultHeight: Integer);

    function GetPluginFlag(): Integer; virtual;
    function GetPluginLayoutGroup(AOperation: TBaseOperation)
      : TComponent; virtual;

    property FreeOnClose: Boolean read GetFreeOnClose;
    property Operation: TBaseOperation read FOperation write SetOperation;
    property ViewActions: TActionList read GetActionList write SetActionList;
    property ImageName: string read GetImageName;
    property HelpContent: string read FHelpContent write FHelpContent;
    property State: TViewState read FViewState write FViewState;
    property PluginFlag: Integer read GetPluginFlag;
    property PluginManager: TBaseViewPluginManager read FPluginManager;
  end;

  {
    ��ͼ���������

    ������������ӽ��棬���ֱ��ʹ�ô���
  }
  TBaseViewPluginManager = class(TComponent)
  private
    FPluginView: TBaseView;
    FPluginFlag: Integer;
    FPluginList: TList;
    function GetDefaultOperation: TBaseOperation;
  protected
    function CanPlugin(AOperation: TBaseOperation): Boolean; virtual;
    procedure UnloadPluginControl(AOperation: TBaseOperation);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure PluginOperations(AOperations: TOperations);
    procedure PluginOperation(AOperation: TBaseOperation); virtual;
    procedure ForEach(AEnumProc: TOperationEnumProc);

    procedure NotifyPlugin(CommandID: Integer); virtual;

    property PluginContainer: TBaseView read FPluginView write FPluginView;
    property PluginFlag: Integer read FPluginFlag write FPluginFlag;
    property PluginList: TList read FPluginList;
    property DefaultOperation: TBaseOperation read GetDefaultOperation;
  end;

  { ���м�¼��ͼ }
  TLogView = class(TBaseView)
  private
    FMemo: TMemo;
    FLogObserver: TObserver;
    procedure DoLogNotify(Sender: TObject);
    procedure CMLogger(var Msg: TMessage); message CM_LOGGER;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
  end;

  TMainSide = (msLeft, msRight, msBottom);

  { *
    �����ڻ���
    * }
  TMainView = class(TForm)
  private
  protected
    function GetViewSubject: TSubject; virtual; abstract;
    function GetActiveView: TBaseView; virtual; abstract;
    function GetMainMenu: TMainMenu; virtual; abstract;
    function GetActionList: TActionList; virtual; abstract;
    function GetViewCount(): Integer; virtual; abstract;
  public
    procedure ShowView(View: TBaseView); virtual;
    procedure CloseView(); virtual;
    procedure PreviousView(); virtual;
    procedure NextView(); virtual;
    procedure HideAllView(); virtual;

    procedure ShowSide(Side: TMainSide; Form: TForm); virtual; abstract;
    procedure CloseSide(Form: TForm); virtual; abstract;

    property MainMenu: TMainMenu read GetMainMenu;
    property ActionList: TActionList read GetActionList;
    property ViewCount: Integer read GetViewCount;
    property ActiveView: TBaseView read GetActiveView;
    property ViewSubject: TSubject read GetViewSubject;
  end;

  { *
    ��TBaseOperation��Ӧ��Action
    * }
  TOperationAction = class(TAction)
  private
    FBaseOperation: TBaseOperation;
    FNotifySender: TObject;
    procedure SetOperation(const Value: TBaseOperation);
  protected
    procedure DoOperationAction(Sender: TObject);
  public
    property Operation: TBaseOperation read FBaseOperation write SetOperation;
    property NotifySender: TObject read FNotifySender write FNotifySender;
  end;

  { *
    ҵ�����

    1 �е���ģ�飬��ʾһ�����������ܵ�(����).
    2 һ������ֻ����һ��TOperations.
    3 ����Data��������Ӧ�ó������.
    4 ���������û��Զ�����״̬�¼���Ҳ����ʱ����״̬�¼�
    5 Actions���ڴ���Operation���Ҽ��˵�
    * }
  TBaseOperation = class(TObject)
  private
    FOwner: TOperations;
    FGUID: string;
    FCaption: string;
    FHint: string;
    FChecked: Boolean;
    FOrder: string;
    FCategory: string;
    FImageName: string;
    FEnabled: Boolean;
    FVisible: Boolean;
    FShortCut: TShortCut;
    FFlag: Integer;
    FAccess: string;
    FCustomAttributes: TStrings;
    FData: TObject;
    FClicks: Integer;
    FState: TOperationState;
    FActions: TActionList;
    procedure SetChecked(const Value: Boolean);
    procedure SetImageName(const Value: string);
    procedure SetVisible(const Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetHint(const Value: string);
    procedure SetState(const Value: TOperationState);
    function GetOwner(): TOperations;
    procedure SetOwner(AOwner: TOperations);
    function GetActions: TActionList;
  protected
    procedure DoStateChange(); virtual;
    procedure LoadProperty(SL: TStrings); virtual;
    procedure SaveProperty(SL: TStrings); virtual;
    procedure DoBeforeExecute(); virtual;
    procedure DoAfterExecute(); virtual;
    function DoExecute(CommandID: Integer; const Param: array of Variant)
      : Variant; virtual;
  public
    constructor Create(const AID: string; AOwner: TOperations = nil); virtual;
    destructor Destroy(); override;

    class function NewSeparator(const AID, ACategory, AOrder: string)
      : TBaseOperation;

    function BuildAction(const ACaption, AImageName: string;
      AOnUpdate, AOnExecute: TNotifyEvent; ATag: Integer): TOperationAction;

    function GetOperationAction(AOwner: TBaseView): TOperationAction;

    procedure LoadState(AIniFile: TIniFile); virtual;
    procedure SaveState(AIniFile: TIniFile); virtual;

    function Execute(CommandID: Integer; const Param: array of Variant)
      : Variant; virtual;

    property GUID: string read FGUID;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Caption: string read FCaption write SetCaption;
    property Hint: string read FHint write SetHint;
    property Checked: Boolean read FChecked write SetChecked;
    property Visible: Boolean read FVisible write SetVisible;
    property Category: string read FCategory write FCategory;
    property ImageName: string read FImageName write SetImageName;
    property Order: string read FOrder write FOrder;
    property ShortKey: TShortCut read FShortCut write FShortCut;
    property Flag: Integer read FFlag write FFlag;
    property Access: string read FAccess write FAccess;
    property Data: TObject read FData write FData;
    property Clicks: Integer read FClicks write FClicks;
    property Owner: TOperations read GetOwner write SetOwner;
    property CustomAttributes: TStrings read FCustomAttributes;
    property State: TOperationState read FState write SetState;
    property Actions: TActionList read GetActions;
  end;

  TExecuteProc = function(Sender: TBaseOperation; CommandID: Integer;
    const Param: array of Variant): Variant;

  { *
    ����ҵ����

    ��һ��TExecuteProc��ִ�е�ҵ��.
    * }
  TProcOperation = class(TBaseOperation)
  private
    FOnExecute: TExecuteProc;
  protected
    function DoExecute(CommandID: Integer; const Param: array of Variant)
      : Variant; override;
  public
    property OnExecute: TExecuteProc read FOnExecute write FOnExecute;
  end;

  { *
    ��ͼҵ����

    ҵ����һ��BaseView��ִ��
    * }
  TViewOperation = class(TBaseOperation)
  private
    FView: TBaseView;
    FViewClass: TBaseViewClass;
    procedure FreeView;
  protected
    function GetViewClass(): TBaseViewClass; virtual;
    procedure SetViewClass(AClass: TBaseViewClass); virtual;
    function GetView(): TBaseView; virtual;
    function DoExecute(CommandID: Integer; const Param: array of Variant)
      : Variant; override;
  public
    destructor Destroy(); override;
    property View: TBaseView read GetView;
    property ViewClass: TBaseViewClass read GetViewClass write SetViewClass;
  end;

  { *
    ҵ������

    1. ֻ���Operation�ӽ�����ʣ�µ�������Operations����
    2. һ��OperationsӦֻ��һ����;����ֻ���ڹ����˵��Ͳ���Ŀ¼��
    3. ���Operation�ڴ���ʱ��ָ����������Ĭ��ʹ��AppCore.Operations��Ϊ������
    * }
  TOperations = class(TObject)
  private
    FBeforeExecute: TSubject;
    FAfterExecute: TSubject;
    FOperationChanged: TSubject;
    FItems: TObjectList;
    procedure DoOperationStart(Operation: TBaseOperation);
  protected
    procedure DoOperationBeforeExecute(Operation: TBaseOperation); virtual;
    procedure DoOperationAfterExecute(Operation: TBaseOperation); virtual;
    procedure DoOperationChanged(Operation: TBaseOperation); virtual;
    function GetItem(Index: Integer): TBaseOperation;
    procedure SetItem(Index: Integer; AObject: TBaseOperation);
    function GetCount(): Integer;
    function Add(AItem: TBaseOperation): Integer;
    procedure Remove(AItem: TBaseOperation);
  public
    constructor Create();
    destructor Destroy(); override;
    procedure LoadOperation(AConfig: TIniFile); virtual;
    procedure SaveOperation(AConfig: TIniFile); virtual;
    procedure SortByClick();
    procedure SortByOrder();
    procedure SortByCaption();
    procedure ForEach(AEnumProc: TOperationEnumProc);
    function SearchOperation(const OperationID: string): TBaseOperation;
    procedure StartOperation();

    property BeforeExecute: TSubject read FBeforeExecute;
    property AfterExecute: TSubject read FAfterExecute;
    property OperationChanged: TSubject read FOperationChanged;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBaseOperation read GetItem
      write SetItem; default;
  end;

  { ȫ�ֺ���ͳһ����Լ��
    �޷�����TMethod???
  }
  TFunctionDefinition = function(const AParam: array of Variant): Variant;

  {
    ȫ�ֺ�������

    ���������ɢ�ڸ����ĺ������á�
    ��Щ����ע���ͨ��һ������ID�����ʡ�
    ��TBaseOperation��ͬ������ʱ����֪��ID���͵���Լ����
    ��TBaseOperation��ͬ���ǣ����ǲ������ڲ˵��С�
  }
  TFunctionContainer = class
  private
    FFunctionList: TBucketList;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Register(AFunctionID: Integer; AFunction: TFunctionDefinition);
    function Execute(AFunctionID: Integer;
      const AParam: array of Variant): Variant;
  end;

  TBaseUser = class
  private
    FLoginSubject: TSubject;
    FID, FName: string;
    FPassword: string;
    FUnitID, FUnitName: string;
    FOfficeID, FOfficeName: string;
    FIsAdmin: Boolean;
    FAccesses: TStrings;
    FLogined: Boolean;
  protected
    property Accesses: TStrings read FAccesses;
  public
    constructor Create(); virtual;
    destructor Destroy(); override;

    function DoLogin(const AUserID, APassword: string): Boolean; virtual;
    function DoChangePassword(const AOldPassword, ANewPassword: string)
      : Boolean; virtual;
    procedure Logout(); virtual;
    function HaveAccess(const AAccessID: string): Boolean; virtual;
    procedure CheckAccess(AAccessID: string); virtual;

    property IsLogined: Boolean read FLogined write FLogined;
    property ID: string read FID write FID;
    property Name: string read FName write FName;
    property Password: string read FPassword write FPassword;
    property IsAdmin: Boolean read FIsAdmin write FIsAdmin;
    property UnitID: string read FUnitID write FUnitID;
    property UnitName: string read FUnitName write FUnitName;
    property OfficeID: string read FOfficeID write FOfficeID;
    property OfficeName: string read FOfficeName write FOfficeName;
    property LoginSubject: TSubject read FLoginSubject;
  end;

  { *
    Ӧ�ó���״̬
    * }
  TAppState = (asNone, asBeginning, asRunning, asAskQuit, asEnding);

  { *
    ���Ķ���

    1. ���й��������ȫ���¼������ԡ�
    2. ����MainView��״̬��asBeginningʱ����!!!
    3. ����ȫ���쳣��Ϣ
    * }
  TAppCore = class(TObject)
  private
    FState: TAppState;
    FID: string;
    FVersion: string; // ������汾
    FResourceVersion: string; // ��Դ�汾
    FExeName: string;
    FAppPath: string;
    FBinPath: string;
    FDataPath: string;
    FImagePath: string;
    FUserPath: string;
    FTempPath: string;
    FLogFileName: string;

    FOperations: TOperations;
    FFunctions: TFunctionContainer;
    FConfig: TIniFile; // �̶�����
    FIniFile: TIniFile; // �ɱ�����
    FUserIni: TIniFile; // ���û���ص�����
    FMainView: TMainView;
    FSmallImage: TFileImageList;
    FLargeImage: TFileImageList;
    FToolBarImage: TFileImageList;
    FImageCenter: TImageCenter;
    FLogger: TLogger;
    FStateSubject: TSubject;
    FUser: TBaseUser;

    FEventID: string; // ȫ���¼�
    FEventSubject: TSubject;

    FOldAppException: TExceptionEvent;

    procedure DoOnReady(Sender: TObject);
    procedure DoOnEnd(Sender: TObject);
    procedure OnAppException(Sender: TObject; E: Exception);
  protected
    procedure Init(); virtual;
    procedure SetMainView(AMainView: TMainView);
    procedure SetState(Value: TAppState);
  public
    constructor Create(); virtual;
    destructor Destroy(); override;

    property ID: string read FID write FID;
    property Version: string read FVersion write FVersion;
    property ResourceVersion: string read FResourceVersion
      write FResourceVersion;
    property ExeName: string read FExeName;
    property LogFileName: string read FLogFileName;
    property AppPath: string read FAppPath;
    property BinPath: string read FBinPath;
    property DataPath: string read FDataPath;
    property ImagePath: string read FImagePath;
    property UserPath: string read FUserPath;
    property TempPath: string read FTempPath;

    property Operations: TOperations read FOperations;
    property Functions: TFunctionContainer read FFunctions;

    property IniFile: TIniFile read FIniFile;
    property Config: TIniFile read FConfig;
    property UserIni: TIniFile read FUserIni;
    property MainView: TMainView read FMainView write SetMainView;
    property SmallImage: TFileImageList read FSmallImage;
    property LargeImage: TFileImageList read FLargeImage;
    property ToolBarImage: TFileImageList read FToolBarImage
      write FToolBarImage;
    property ImageCenter: TImageCenter read FImageCenter;
    property Logger: TLogger read FLogger;
    property State: TAppState read FState write SetState;
    property StateSubject: TSubject read FStateSubject;
    property User: TBaseUser read FUser write FUser;
    property EventID: string read FEventID write FEventID;
    property EventSubject: TSubject read FEventSubject;
  end;

var
  AppCore: TAppCore;

implementation

{$WARNINGS OFF}

type
  TGraphicAccess = class(TGraphic);

procedure TSubject.Attach(Observer: TObserver);
begin
  if Assigned(Observer) and (FObservers.IndexOf(Observer) < 0) then
  begin
    FObservers.Add(Observer);
    if Assigned(Observer.FSubject) then
      Observer.FSubject.Detach(Observer);
    Observer.FSubject := Self;
  end;
end;

constructor TSubject.Create();
begin
  inherited Create;
  FObservers := TList.Create;
end;

destructor TSubject.Destroy;
var
  I: Integer;
begin
  for I := Pred(FObservers.Count) downto 0 do
    Detach(TObserver(FObservers[I]));
  FObservers.Free;
  inherited;
end;

procedure TSubject.Detach(Observer: TObserver);
begin
  FObservers.Remove(Observer);
  Observer.FSubject := nil;
end;

procedure TSubject.Notify(Sender: TObject);
var
  I: Integer;
begin
  // ֪ͨ�Ĺ����п�ע���Լ�
  for I := Pred(FObservers.Count) downto 0 do
    TObserver(FObservers[I]).Update(Sender);
end;

{ TObserver }

constructor TObserver.Create(OnUpdate: TNotifyEvent);
begin
  inherited Create();
  FSubject := nil;
  FOnUpdate := OnUpdate;
end;

destructor TObserver.Destroy;
begin
  if Assigned(FSubject) then
    FSubject.Detach(Self);
  inherited;
end;

procedure TObserver.Update(Sender: TObject);
begin
  if Assigned(FOnUpdate) then
    FOnUpdate(Sender)
end;

{ TViewOperation }

destructor TViewOperation.Destroy;
begin
  FreeView;
  inherited;
end;

function TViewOperation.DoExecute(CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  // ��ֹ�����ͼ�ڳ����˳�ʱ�ͷź��ֱ�����
  if not(AppCore.State in [asAskQuit, asEnding]) or (FView <> nil) then
    Result := View.DoExecute(CommandID, Param);
end;

procedure TViewOperation.FreeView;
begin
  FreeAndNil(FView);
end;

function TViewOperation.GetView: TBaseView;
begin
  if FView = nil then
  begin
    if FViewClass = nil then
      FViewClass := GetViewClass;
    if FViewClass = nil then
      raise Exception.Create('û������TBaseViewClass');
    FView := FViewClass.Create(Application);
    FView.Operation := Self;
    FView.Caption := Caption;
  end;
  Result := FView;
end;

{ �������û��ָ��FViewClass�����������л�������Ҫ����ʱ���� }

function TViewOperation.GetViewClass: TBaseViewClass;
begin
  Result := FViewClass;
end;

procedure TViewOperation.SetViewClass(AClass: TBaseViewClass);
begin
  FreeView();
  FViewClass := AClass;
end;

{ TBaseView }

function TBaseView.DoExecute(CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  case CommandID of
    iOperationCommand_Default:
      AppCore.MainView.ShowView(Self);
  end;
end;

{ ��MainView��������ͼʱ������� }

procedure TBaseView.DoHideView();
begin

end;

procedure TBaseView.DoInitView();
begin
  OnShortCut := DoShortCut;
  ShowHint := True;
end;

{ ��MainView����ʾ��ͼʱ������� }

procedure TBaseView.DoShowView;
begin

end;

function TBaseView.GetActionList: TActionList;
begin
  if FViewActionList = nil then
  begin
    FViewActionList := TActionList.Create(Self);
    FViewActionList.Images := AppCore.ToolBarImage.ImageList;
  end;
  Result := FViewActionList;
end;

function TBaseView.GetImageName: string;
begin
  if FOperation <> nil then
    Result := FOperation.ImageName
  else
    Result := '';
end;

destructor TBaseView.Destroy;
begin
  FPluginManager.Free;
  if (FOperation <> nil) and FOperation.InheritsFrom(TViewOperation) then
    TViewOperation(FOperation).FView := nil;
  inherited;
end;

procedure TBaseView.SetActionList(AActionList: TActionList);
begin
  FreeAndNil(FViewActionList);
  FViewActionList := AActionList;
end;

{ �ر�ʱ�Ƿ��ͷ� }

function TBaseView.GetFreeOnClose: Boolean;
begin
  Result := True;
end;

function TBaseView.BuildAction(ACaption, AImageName, AHint: string;
  AOnUpdate, AOnExecute: TNotifyEvent; AShortCut: TShortCut;
  ATag: Integer): TAction;
begin
  Result := TAction.Create(Self);
  with Result do
  begin
    ActionList := ViewActions;
    Caption := ACaption;
    Hint := AHint;
    ImageIndex := AppCore.ToolBarImage.IndexOf(AImageName);
    OnUpdate := AOnUpdate;
    OnExecute := AOnExecute;
    ShortCut := AShortCut;
    Tag := ATag;
  end;
end;

{ ������Ƕ�����ͼ���ݿ�ݼ� }

procedure TBaseView.DoShortCut(var Msg: TWMKey; var Handled: Boolean);

  procedure SearchChildForm(AControl: TWinControl; var Msg: TWMKey;
    var Handled: Boolean);
  var
    I: Integer;
  begin
    for I := 0 to AControl.ControlCount - 1 do
      if AControl.Controls[I].InheritsFrom(TCustomForm) and
        TCustomForm(AControl.Controls[I]).Visible then
      begin
        Handled := TCustomForm(AControl.Controls[I]).IsShortCut(Msg);
        if Handled then
          Exit
        else
          SearchChildForm(TCustomForm(AControl.Controls[I]), Msg, Handled);
      end
      else if AControl.Controls[I].InheritsFrom(TWinControl) then
        SearchChildForm(TWinControl(AControl.Controls[I]), Msg, Handled);
  end;

begin
  SearchChildForm(Self, Msg, Handled);
end;

constructor TBaseView.Create(AOwner: TComponent);
var
  S: string;
begin
  S := ClassName;
  // �����Դ�д��ڴ���Ķ���  ���գ�InitInheritedComponent
  if (FindResource(FindResourceHInstance(FindClassHInstance(ClassType)),
    PChar(S), RT_RCDATA) <> 0) then
    inherited
  else
    inherited CreateNew(AOwner);
  DoInitView;
end;

procedure TBaseView.SetOperation(const Value: TBaseOperation);
begin
  FOperation := Value;
  if FOperation <> nil then
    Caption := FOperation.Caption;

  if PluginFlag <> 0 then
  begin
    if FPluginManager = nil then
    begin
      FPluginManager := GetPluginManager();

      with FPluginManager do
      begin
        PluginContainer := Self;
        PluginFlag := Self.PluginFlag;
      end;
    end;

    FPluginManager.PluginOperations(AppCore.Operations);
  end;
end;

procedure TBaseView.RestoreSize(ADefaultWidth, ADefaultHeight: Integer);
begin
  Width := AppCore.IniFile.ReadInteger(ClassName, 'DialogWidth', ADefaultWidth);
  Height := AppCore.IniFile.ReadInteger(ClassName, 'DialogHeight',
    ADefaultHeight);
end;

procedure TBaseView.SaveSize;
begin
  AppCore.IniFile.WriteInteger(ClassName, 'DialogWidth', Width);
  AppCore.IniFile.WriteInteger(ClassName, 'DialogHeight', Height);
end;

function TBaseView.GetPluginLayoutGroup(AOperation: TBaseOperation): TComponent;
begin
  Result := nil;
end;

function TBaseView.GetPluginFlag: Integer;
begin
  Result := 0;
end;

function TBaseView.GetPluginManager: TBaseViewPluginManager;
begin
  Result := TBaseViewPluginManager.Create(Self);
end;

{ TLogView }

procedure TLogView.CMLogger(var Msg: TMessage);
begin
  with TLogInfo(Msg.WParam) do
  begin
    if (Integer(LogType) >= AppCore.Logger.LogLevel) then
      FMemo.Lines.Add(Format('%s %s %d %s',
        [FormatDateTime('YYYY-MM-DD hh:mm:ss', Time), cLogTypeText[LogType],
        Code, Text]));
    if (AppCore.Logger.MaxCount > 0) and
      (FMemo.Lines.Count > AppCore.Logger.MaxCount) then
      FMemo.Lines.Clear;
    ReleaseRef;
  end;
end;

constructor TLogView.Create(AOwner: TComponent);
begin
  inherited;

  FLogObserver := TObserver.Create(DoLogNotify);

  with Self do
  begin
    Caption := '���м�¼';
    BorderStyle := bsSizeToolWin;
    FormStyle := fsStayOnTop;
    Width := 400;
    Height := 200;
    Font.Size := 10;
    Font.Name := '������';
  end;

  FMemo := TMemo.Create(nil);
  // FMemo.BorderStyle := bsNone;
  // FMemo.BevelInner := bvNone;
  // FMemo.BevelKind := bkNone;
  FMemo.ReadOnly := True;
  FMemo.Align := alClient;
  FMemo.ScrollBars := ssBoth;
  FMemo.Parent := Self;

  AppCore.Logger.LogCriticalSection.Enter;
  AppCore.Logger.LogSubject.Attach(FLogObserver);
  FMemo.Lines.Assign(AppCore.Logger.LogList);
  AppCore.Logger.LogCriticalSection.Leave;

  with AppCore.IniFile do
  begin
    SetBounds(ReadInteger(ClassName, 'Left', Left),
      ReadInteger(ClassName, 'Top', Top), ReadInteger(ClassName, 'Width',
      Width), ReadInteger(ClassName, 'Height', Height));
  end;
end;

destructor TLogView.Destroy;
begin
  FreeAndNil(FLogObserver);
  with AppCore.IniFile do
  begin
    WriteInteger(Self.ClassName, 'Left', Left);
    WriteInteger(Self.ClassName, 'Top', Top);
    WriteInteger(Self.ClassName, 'Width', Width);
    WriteInteger(Self.ClassName, 'Height', Height);
  end;
  inherited;
end;

procedure TLogView.DoLogNotify(Sender: TObject);
begin
  if AppCore.State = asRunning then
  begin
    TLogInfo(Sender).AddRef;
    PostMessage(Handle, CM_LOGGER, Integer(Sender), 0)
  end
end;

{ TAppCore }

constructor TAppCore.Create;
begin
  inherited;
  AppCore := Self;
  Init;
end;

destructor TAppCore.Destroy();
begin
  try

    FreeAndNil(FOperations);
    FreeAndNil(FFunctions);
    FreeAndNil(FSmallImage);
    FreeAndNil(FLargeImage);
    FreeAndNil(FImageCenter);
    FreeAndNil(FStateSubject);
    FreeAndNil(FEventSubject);
    FLogger.Write('�������', mtInfo, 0);

    FLogger.SaveLog(FLogFileName);
    FLogger.SaveState(FIniFile);
    FreeAndNil(FLogger);

    FreeAndNil(FIniFile);
    FreeAndNil(FConfig);
    FreeAndNil(FUserIni);

    // Application��AppCore֮ǰ��������Application��Children����AppCore֮ǰ�ͷ�
    // if Assigned(FOldAppException) then
    // Application.OnException := FOldAppException;  // �����DLL�������ͷ�
  except
    // �������������ܵ��³����޷��˳�
  end;
  inherited;
end;

procedure TAppCore.DoOnEnd(Sender: TObject);
begin
  // FOperations.SaveOperation(FConfig);
end;

procedure TAppCore.DoOnReady(Sender: TObject);
begin
  if FConfig.ReadBool(sAppSection, 'LoadOperations', False) then
    FOperations.LoadOperation(FConfig);

  if not Assigned(FOldAppException) then
  begin
    FOldAppException := Application.OnException;
    Application.OnException := OnAppException;
  end;

  FOperations.SortByOrder;
  FOperations.StartOperation; // ��������
end;

procedure TAppCore.Init;
var
  ModuleName: string;
begin
  FState := asNone;
  ModuleName := GetModuleName(hInstance);
  FAppPath := ExtractFileDir(ModuleName);
  // ExtractFileDir(Application.ExeName);
  FAppPath := ExtractFilePath(FAppPath);
  FExeName := ExtractFileName(ModuleName);
  // FLogFileName :=  ChangeFileExt(ModuleName, '.log'); // ChangeFileExt(Application.ExeName, '.log');
  FLogFileName := FAppPath + 'log\' + ChangeFileExt(FExeName, ''); // ��־�ļ���ģ��
  FBinPath := FAppPath + 'bin\';
  FDataPath := FAppPath + 'data\';
  FImagePath := FAppPath + 'image\';
  FTempPath := FAppPath + 'temp\';
  FUserPath := FAppPath + 'user\';

  FIniFile := TIniFile.Create(ChangeFileExt(ModuleName, '.ini'));
  FConfig := TIniFile.Create(ChangeFileExt(ModuleName, '.config.ini'));
  FUserIni := TIniFile.Create(ChangeFileExt(ModuleName, '.user.ini'));

  FLogger := TLogger.Create;
  FLogger.LoadState(FIniFile);

  FSmallImage := TFileImageList.Create(nil, FImagePath + '16\', '16',
    sDefaultImageName, 16, 16);
  FLargeImage := TFileImageList.Create(nil, FImagePath + '24\', '24',
    sDefaultImageName, 24, 24);
  FImageCenter := TImageCenter.Create(FImagePath);

  FStateSubject := TSubject.Create();
  FEventSubject := TSubject.Create();
  FOperations := TOperations.Create();
  FFunctions := TFunctionContainer.Create;

  FID := FConfig.ReadString(sAppSection, 'AppID', '���');
  FVersion := FConfig.ReadString(sAppSection, 'AppVer', '2.0');
  if FIniFile.ReadBool(sAppSection, 'UseLargeIcon', True) then
    FToolBarImage := FLargeImage
  else
    FToolBarImage := FSmallImage;

  FLogger.Write('��������', mtInfo, 0);
end;

procedure TAppCore.OnAppException(Sender: TObject; E: Exception);
begin
  FLogger.WriteFmt('����%s�쳣: %s', [E.ClassName, E.Message], mtError, 0);
  if Assigned(FOldAppException) then
    FOldAppException(Sender, E);
end;

procedure TAppCore.SetMainView(AMainView: TMainView);
begin
  FMainView := AMainView;
end;

procedure TAppCore.SetState(Value: TAppState);
begin
  if Value <> FState then
  begin
    FState := Value;
    FStateSubject.Notify(Self);

    case FState of
      asBeginning:
        DoOnReady(nil);
      asAskQuit:
        AppCore.Logger.Write('׼���˳�...', mtInfo, 0);
      asEnding:
        DoOnEnd(nil);
    end;
  end;
end;

{ TOperations }

constructor TOperations.Create();
begin
  inherited;
  FItems := TObjectList.Create(False);
  FBeforeExecute := TSubject.Create();
  FAfterExecute := TSubject.Create();
  FOperationChanged := TSubject.Create();
end;

destructor TOperations.Destroy;
var
  I: Integer;
begin
  for I := FItems.Count - 1 downto 0 do
    FItems[I].Free;
  FItems.Free;
  FBeforeExecute.Free;
  FAfterExecute.Free;
  FOperationChanged.Free;
  inherited;
end;

procedure TOperations.LoadOperation(AConfig: TIniFile);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].LoadState(AConfig);
  SortByOrder;
end;

procedure TOperations.SaveOperation(AConfig: TIniFile);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].SaveState(AConfig);

end;

function TOperations.SearchOperation(const OperationID: string): TBaseOperation;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if SameText(Items[I].GUID, OperationID) then
    begin
      Result := Items[I];
      Break;
    end;
end;

function CompareOperationClick(Item1, Item2: Pointer): Integer;
begin
  Result := TBaseOperation(Item2).Clicks - TBaseOperation(Item1).Clicks;
end;

procedure TOperations.SortByClick;
begin
  FItems.Sort(@CompareOperationClick);
end;

function CompareOperationOrder(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TBaseOperation(Item1).Order,
    TBaseOperation(Item2).Order);
end;

procedure TOperations.SortByOrder;
begin
  FItems.Sort(@CompareOperationOrder);
end;

function CompareOperationCaption(Item1, Item2: Pointer): Integer;
begin
  Result := AnsiCompareText(TBaseOperation(Item1).Caption,
    TBaseOperation(Item2).Caption);
end;

procedure TOperations.SortByCaption;
begin
  FItems.Sort(@CompareOperationCaption);
end;

function TOperations.GetItem(Index: Integer): TBaseOperation;
begin
  Result := TBaseOperation(FItems[Index]);
end;

procedure TOperations.SetItem(Index: Integer; AObject: TBaseOperation);
begin
  FItems[Index] := AObject;
end;

procedure TOperations.DoOperationBeforeExecute(Operation: TBaseOperation);
begin
  FBeforeExecute.Notify(Operation);
end;

procedure TOperations.DoOperationAfterExecute(Operation: TBaseOperation);
begin
  FAfterExecute.Notify(Operation);
end;

procedure TOperations.DoOperationChanged(Operation: TBaseOperation);
begin
  FOperationChanged.Notify(Operation);
end;

function TOperations.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TOperations.Add(AItem: TBaseOperation): Integer;
begin
  AItem.Owner := nil;
  Result := FItems.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TOperations.Remove(AItem: TBaseOperation);
begin
  FItems.Remove(AItem);
  AItem.FOwner := nil;
end;

procedure TOperations.ForEach(AEnumProc: TOperationEnumProc);
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    AEnumProc(Items[I]);
end;

procedure TOperations.StartOperation;
begin
  ForEach(DoOperationStart);
end;

procedure TOperations.DoOperationStart(Operation: TBaseOperation);
begin
  if (Operation.Flag and iOperationFlag_Start) <> 0 then
    Operation.Execute(iOperationCommand_Start, []);
end;

{ TFileImageList }

constructor TFileImageList.Create(AOwner: TComponent;
  const AImagePath, AImageNamePostfix, ADefaultImageName: string;
  AImageWidth, AImageHeight: Integer);
begin
  inherited Create(AOwner);
  FImageList :=
{$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF}.Create(nil);
  FImageList.Width := AImageWidth;
  FImageList.Height := AImageHeight;

  FDisabledImages :=
{$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF}.Create(nil);
  FDisabledImages.Width := AImageWidth;
  FDisabledImages.Height := AImageHeight;

  FImagePath := AImagePath;
  FPostfix := AImageNamePostfix;
  FImageNames := TStringList.Create;
  FDefaultIndex := IndexOf(ADefaultImageName);
end;

destructor TFileImageList.Destroy;
begin
  FImageNames.Free;
  FImageList.Free;
  FDisabledImages.Free;
  inherited;
end;

function TFileImageList.IndexOf(const AImageName: string): Integer;

  procedure BuildDisabledImage(Bitmap: TBitmap; Transparent: TColor);
  var
    I, J: Integer;
    R, G, B: Byte;
    C: TColor;
  begin
    with Bitmap.Canvas do
      for I := 0 to Bitmap.Width - 1 do
        for J := 0 to Bitmap.Height - 1 do
        begin
          C := Pixels[I, J];
          if C <> Transparent then
          begin
            R := GetRValue(C);
            G := GetGValue(C);
            B := GetBValue(B);
            C := (R + G + B + 765) div 6;
            Pixels[I, J] := RGB(C, C, C);
          end;
        end;
    DisabledImages.AddMasked(Bitmap, Transparent);
  end;

  function LoadImage(ImageList:
{$IFDEF UsecxGraphics}TcxImageList{$ELSE}TImageList{$ENDIF};
    const FileName: string): Integer;
  var
    NewName: string;
    Bitmap: TBitmap;
    G: TGraphic;
  label
    LoadImage;
  begin
    try
      // Result := FDefaultIndex;
      Result := -1;

      NewName := FileName + '.bmp';
      if FileExists(NewName) then
      begin
        G := TBitmap.Create;
        goto LoadImage;
      end;

{$IFDEF UsecxGraphics}
      NewName := FileName + '.png';
      if FileExists(NewName) then
      begin
        G := TdxPNGImage.Create;
        goto LoadImage;
      end;
{$ENDIF}
      // Ico�и�ϵͳ�������⣬��һ��Icon�ļ��ĳ���һ����ɾ����ͼ�꽫�������ã����������
      NewName := FileName + '.ico';
      if FileExists(NewName) then
      begin
        G := TIcon.Create;
        goto LoadImage;
      end;

      Exit;

    LoadImage:
      G.LoadFromFile(NewName);

      // ����ָ����С
      if ImageList.Count = 0 then
      begin
        ImageList.Width := G.Width;
        ImageList.Height := G.Height;
        DisabledImages.Width := G.Width;
        DisabledImages.Height := G.Height;
      end;

      if G is TBitmap then
        Result := ImageList.AddMasked(TBitmap(G),
          TBitmap(G).Canvas.Pixels[0, 0])
      else if G is TIcon then
        Result := ImageList.AddIcon(TIcon(G))
{$IFDEF UsecxGraphics}
      else if G is TdxPNGImage then
      begin
        Bitmap := TdxPNGImage(G).GetAsBitmap;
        // Result := ImageList.Add(Bitmap, nil);
        Result := ImageList.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
        Bitmap.Free;
      end
{$ENDIF};

      Bitmap := TBitmap.Create;
      Bitmap.Width := ImageList.Width;
      Bitmap.Height := ImageList.Height;
      TGraphicAccess(G).Draw(Bitmap.Canvas, Rect(0, 0, Bitmap.Width,
        Bitmap.Height));
      BuildDisabledImage(Bitmap, Bitmap.Canvas.Pixels[0, 0]);

      Bitmap.Free;
      G.Free;
    except
    end;
  end;

begin
  Result := FImageNames.IndexOf(AImageName);
  if Result < 0 then
  begin
    Result := LoadImage(FImageList, FImagePath + AImageName + FPostfix + '');
    FImageNames.AddObject(AImageName, TObject(Result));
  end
  else
    Result := Integer(FImageNames.Objects[Result]);
end;

{ TLogger }

constructor TLogger.Create;
begin
  FLogMaxCount := 1000;
  FLogFileMaxCount := 5;
  FLogFileMaxSize := 1024 * 1024 * 3; // 8M
  FIniSection := 'Logger';
  FEnabled := True;
  FRewrite := False;
  FCriticalSection := TCriticalSection.Create;
  FLogList := TStringList.Create;
  FLogSubject := TSubject.Create();
end;

destructor TLogger.Destroy;
begin
  FreeAndNil(FLogSubject);
  FreeAndNil(FLogList);
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TLogger.LoadState(AIniFile: TIniFile);
begin
  with AIniFile do
  begin
    FLogMaxCount := ReadInteger(FIniSection, 'MaxCount', FLogMaxCount);
    FLogFileMaxCount := ReadInteger(FIniSection, 'LogFileMaxCount',
      FLogFileMaxCount);
    FLogFileMaxSize := ReadInteger(FIniSection, 'LogFileMaxSize',
      FLogFileMaxSize);
    FEnabled := ReadBool(FIniSection, 'Enabled', True);
    FRewrite := ReadBool(FIniSection, 'Rewrite', False);
    FLogLevel := ReadInteger(FIniSection, 'LogLevel', Integer(mtInfo));
  end;
end;

procedure TLogger.SaveState(AIniFile: TIniFile);
begin
  with AIniFile do
  begin
    WriteInteger(FIniSection, 'MaxCount', FLogMaxCount);
    WriteInteger(FIniSection, 'LogFileMaxCount', FLogFileMaxCount);
    WriteInteger(FIniSection, 'LogFileMaxSize', FLogFileMaxSize);
    WriteBool(FIniSection, 'Enabled', FEnabled);
    WriteBool(FIniSection, 'Rewrite', FRewrite);
    WriteInteger(FIniSection, 'LogLevel', FLogLevel);
  end;
end;

procedure TLogger.Write(AValue: Variant; AType: TLogType; ACode: Integer);
var
  LogInfo: TLogInfo;
begin
  FCriticalSection.Enter;
  try
    FTime := Now;
    FLogType := AType;
    FCode := ACode;
    FText := AValue;

    if FEnabled and (Integer(FLogType) >= FLogLevel) then
    begin
      FLogList.Add(Format('%s %s %d %s', [FormatDateTime('YYYY-MM-DD hh:mm:ss',
        FTime), cLogTypeText[FLogType], FCode, FText]));
    end;

    if (FLogMaxCount > 0) and (FLogList.Count >= FLogMaxCount) then
    begin
      SaveLog(AppCore.LogFileName);
    end;

    if (AppCore <> nil) and (AppCore.State = asRunning) then
    begin
      LogInfo := TLogInfo.Create;
      LogInfo.Time := FTime;
      LogInfo.LogType := AType;
      LogInfo.Code := ACode;
      LogInfo.Text := FText; // Delphi���ַ���ֻ����������̰߳�ȫ��, ����IsMultiThread=True
      LogInfo.AddRef; // ��Ҫ���õĵط����ô˺�������ֹ���ͷ�
      FLogSubject.Notify(LogInfo); // �п�����ɰ�ť�¼�����
      LogInfo.ReleaseRef;
    end;

  finally
    FCriticalSection.Leave;
  end;
end;

procedure TLogger.SaveLog(const ATempFileName: string);
var
  Stream: TFileStream;
  FileName: string;
  RemoveLogFlag: Boolean;
begin
  FileName := ATempFileName + '0.log';
  RemoveLogFlag := False;
  try
    ForceDirectories(ExtractFileDir(ATempFileName));

    try
      if FRewrite or not FileExists(FileName) then
        Stream := TFileStream.Create(FileName, fmCreate)
      else
      begin
        Stream := TFileStream.Create(FileName, fmOpenWrite);
        Stream.Seek(0, soEnd);
      end;

      FLogList.SaveToStream(Stream);
      FLogList.Clear;

      // ��־�ļ��Ƿ񳬳���С
      RemoveLogFlag := Stream.Size > FLogFileMaxSize;

    finally
      Stream.Free;
    end;

    if RemoveLogFlag then
      BackupLogFile(ATempFileName, 0);
  except
    // �ܿ����Ǵ��̴��󣬺��Դ˴��������޷��˳�
  end;
end;

procedure TLogger.WriteFmt(const AFormat: string; AValues: array of const;
  AType: TLogType; ACode: Integer);
begin
  Write(Format(AFormat, AValues), AType, ACode);
end;

procedure TLogger.BackupLogFile(const ATempFileName: string; Index: Integer);
begin
  // ��־�ļ�����
  if Index < LogFileMaxCount then
  begin
    BackupLogFile(ATempFileName, Index + 1);
    RenameFile(ATempFileName + IntToStr(Index) + '.log',
      ATempFileName + IntToStr(Index + 1) + '.log')
  end
  else
  begin
    DeleteFile(ATempFileName + IntToStr(Index) + '.log');
  end;
end;

{ TBaseOperation }

function TBaseOperation.BuildAction(const ACaption, AImageName: string;
  AOnUpdate, AOnExecute: TNotifyEvent; ATag: Integer): TOperationAction;
begin
  Result := TOperationAction.Create(Actions);
  with Result do
  begin
    Operation := Self;
    ActionList := Actions;
    Caption := ACaption;
    Hint := ACaption;
    ImageIndex := AppCore.ToolBarImage.IndexOf(AImageName);
    OnUpdate := AOnUpdate;
    OnExecute := AOnExecute;
    Tag := ATag;
  end;
end;

constructor TBaseOperation.Create(const AID: string; AOwner: TOperations = nil);
begin
  FCustomAttributes := TStringList.Create;
  FEnabled := True;
  FVisible := True;
  FGUID := AID;
  FClicks := 0;

  if AOwner = nil then
    AOwner := AppCore.Operations;
  AOwner.Add(Self);

  State := osCreating;
end;

destructor TBaseOperation.Destroy;
begin
  State := osRemoving;

  FreeAndNil(FCustomAttributes);
  FreeAndNil(FActions);
  if FOwner <> nil then
    FOwner.FItems.Remove(Self);
  inherited;
end;

procedure TBaseOperation.DoAfterExecute;
begin
  if Assigned(Owner) then
    Owner.DoOperationAfterExecute(Self);
end;

procedure TBaseOperation.DoBeforeExecute;
begin
  if Assigned(Owner) then
    Owner.DoOperationBeforeExecute(Self);
end;

function TBaseOperation.DoExecute(CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  // do nothing
end;

procedure TBaseOperation.DoStateChange;
begin
  if Assigned(Owner) then
    Owner.DoOperationChanged(Self);
end;

function TBaseOperation.Execute(CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  if Enabled then
  begin
    DoBeforeExecute;
    Result := DoExecute(CommandID, Param);
    Inc(FClicks);
    DoAfterExecute;
  end;
end;

function TBaseOperation.GetActions: TActionList;
begin
  if FActions = nil then
    FActions := TActionList.Create(nil);
  Result := FActions;
end;

function TBaseOperation.GetOperationAction(AOwner: TBaseView): TOperationAction;
begin
  Result := TOperationAction.Create(AOwner);
  with Result do
  begin
    ActionList := AOwner.ViewActions;
    Operation := Self;
    Caption := FCaption;
    Hint := FHint;
    ShortCut := ShortKey;
    ImageIndex := AppCore.ToolBarImage.IndexOf(FImageName);
    OnExecute := DoOperationAction;
    Tag := BTN_SHOWCAPTION;
    NotifySender := AOwner; // ����ɵõ��˶���
  end;
end;

function TBaseOperation.GetOwner: TOperations;
begin
  Result := FOwner;
end;

procedure TBaseOperation.LoadProperty(SL: TStrings);
begin
  FOrder := SL[0];
  FCategory := SL[1];
  FCaption := SL[2];
  FImageName := SL[3];
  FShortCut := TextToShortCut(SL[4]);
  FFlag := StrToInt(SL[5]);
  FClicks := StrToInt(SL[6]);
end;

procedure TBaseOperation.LoadState(AIniFile: TIniFile);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SaveProperty(SL);
    SL.CommaText := AIniFile.ReadString('Operations', FGUID, SL.CommaText);
    LoadProperty(SL);
  except
  end;
  SL.Free;
end;

class function TBaseOperation.NewSeparator(const AID, ACategory, AOrder: string)
  : TBaseOperation;
begin
  Result := TBaseOperation.Create(AID);
  Result.Caption := '-';
  Result.Category := ACategory;
  Result.Order := AOrder;
end;

procedure TBaseOperation.SaveProperty(SL: TStrings);
begin
  SL.Add(FOrder);
  SL.Add(FCategory);
  SL.Add(FCaption);
  SL.Add(FImageName);
  SL.Add(ShortCutToText(FShortCut));
  SL.Add(IntToStr(FFlag));
  SL.Add(IntToStr(Clicks));
end;

procedure TBaseOperation.SaveState(AIniFile: TIniFile);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SaveProperty(SL);
    AIniFile.WriteString('Operations', FGUID, SL.CommaText);
  finally
    SL.Free;
  end;
end;

procedure TBaseOperation.SetCaption(const Value: string);
begin
  FCaption := Value;
  State := osUpdating;
end;

procedure TBaseOperation.SetChecked(const Value: Boolean);
begin
  if Value <> FChecked then
  begin
    FChecked := Value;
    State := osUpdating;
  end;
end;

procedure TBaseOperation.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    State := osUpdating;
  end;
end;

procedure TBaseOperation.SetHint(const Value: string);
begin
  if FHint <> Value then
  begin
    FHint := Value;
    DoStateChange;
  end;
end;

procedure TBaseOperation.SetImageName(const Value: string);
begin
  if FImageName <> Value then
  begin
    FImageName := Value;
    DoStateChange;
  end;
end;

procedure TBaseOperation.SetOwner(AOwner: TOperations);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then
      FOwner.Remove(Self);
    if AOwner <> nil then
      AOwner.Add(Self);
  end;
end;

procedure TBaseOperation.SetState(const Value: TOperationState);
begin
  FState := Value;
  DoStateChange;
end;

procedure TBaseOperation.SetVisible(const Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    State := osUpdating;
  end;
end;

{ TImageCenter }

constructor TImageCenter.Create(const AImagePath: string);
begin
  FImagePath := AImagePath;
  FImageNames := TStringList.Create;
end;

destructor TImageCenter.Destroy;
var
  I: Integer;
  Pic: TObject;
begin
  for I := 0 to FImageNames.Count - 1 do
  begin
    Pic := FImageNames.Objects[I];
    Pic.Free;
  end;
  FImageNames.Free;
  inherited;
end;

function TImageCenter.Get(const AImageName: string): TPicture;
var
  Index: Integer;
begin
  Result := nil;
  Index := FImageNames.IndexOf(AImageName);
  if Index < 0 then
  begin
    if FileExists(FImagePath + AImageName) then
    begin
      Result := TPicture.Create;
      try
        Result.LoadFromFile(FImagePath + AImageName);
      except
        FreeAndNil(Result);
      end;
    end;
    FImageNames.AddObject(AImageName, Result);
  end
  else
    Result := TPicture(FImageNames.Objects[Index]);
end;

function TImageCenter.GetBitmap(const AImageName: string): TBitmap;
var
  P: TPicture;
begin
  P := Get(AImageName);
  if P <> nil then
    Result := P.Bitmap
  else
    Result := nil;
end;

{ TProcOperation }

function TProcOperation.DoExecute(CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  if Assigned(FOnExecute) then
    Result := FOnExecute(Self, CommandID, Param);
end;

{ TFunctionContainer }

constructor TFunctionContainer.Create;
begin
  FFunctionList := TBucketList.Create();
end;

destructor TFunctionContainer.Destroy;
begin
  FreeAndNil(FFunctionList);
  inherited;
end;

function TFunctionContainer.Execute(AFunctionID: Integer;
  const AParam: array of Variant): Variant;
begin
  if FFunctionList.Exists(Pointer(AFunctionID)) then
    Result := TFunctionDefinition
      (FFunctionList.Data[Pointer(AFunctionID)])(AParam)
  else
    raise Exception.CreateFmt('û���ҵ�%d��������!', [AFunctionID]);
end;

procedure TFunctionContainer.Register(AFunctionID: Integer;
  AFunction: TFunctionDefinition);
var
  Temp: Pointer absolute AFunction;
begin
  FFunctionList.Add(Pointer(AFunctionID), Temp);
end;

{ TBaseUser }

procedure TBaseUser.CheckAccess(AAccessID: string);
begin
  if not HaveAccess(AAccessID) then
    raise Exception.Create('û��ִ��Ȩ��');
end;

constructor TBaseUser.Create;
begin
  inherited;
  FLoginSubject := TSubject.Create;
  FAccesses := TStringList.Create;
  AppCore.User := Self;
end;

destructor TBaseUser.Destroy;
begin
  FLoginSubject.Free;
  FAccesses.Free;
  inherited;
end;

function TBaseUser.DoChangePassword(const AOldPassword,
  ANewPassword: string): Boolean;
begin
  if FPassword = AOldPassword then
    FPassword := ANewPassword;
end;

function TBaseUser.DoLogin(const AUserID, APassword: string): Boolean;
begin

end;

function TBaseUser.HaveAccess(const AAccessID: string): Boolean;
begin
  Result := IsAdmin or (AAccessID = '') or (Accesses.IndexOf(AAccessID) > -1);
end;

procedure TBaseUser.Logout;
begin
  FLogined := False;
end;

{ TMainView }

procedure TMainView.CloseView;
begin

end;

procedure TMainView.HideAllView;
begin

end;

procedure TMainView.NextView;
begin

end;

procedure TMainView.PreviousView;
begin

end;

procedure TMainView.ShowView(View: TBaseView);
begin

end;

{ TLogInfo }

function TLogInfo.AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

procedure TLogInfo.Assign(Source: TPersistent);
begin
  if Source is TLogInfo then
  begin
    with TLogInfo(Source) do
    begin
      Self.FTime := FTime;
      Self.FType := FType;
      Self.FText := Copy(FText, 1, Length(FText));
      Self.Code := FCode;
    end;
  end
  else
    inherited;
end;

function TLogInfo.ReleaseRef: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Free;
end;

{ TOperationAction }

procedure TOperationAction.DoOperationAction(Sender: TObject);
begin
  // Ĭ�ϵ���Notity����
  if FBaseOperation <> nil then
    FBaseOperation.Execute(iOperationCommand_Notify, [Integer(NotifySender)]);
end;

procedure TOperationAction.SetOperation(const Value: TBaseOperation);
begin
  FBaseOperation := Value;
end;

{ TBaseViewPluginManager }

function TBaseViewPluginManager.CanPlugin(AOperation: TBaseOperation): Boolean;
begin
  Result := ((AOperation.Flag and PluginFlag) <> 0) and AOperation.Visible;
end;

constructor TBaseViewPluginManager.Create(AOwner: TComponent);
begin
  inherited;
  ComponentIndex := 0; // ��View�ͷ�ǰ��һ���õ�֪ͨ
  FPluginList := TList.Create;
end;

destructor TBaseViewPluginManager.Destroy;
begin
  ForEach(UnloadPluginControl);
  FPluginList.Free;
  inherited;
end;

procedure TBaseViewPluginManager.ForEach(AEnumProc: TOperationEnumProc);
var
  I: Integer;
begin
  for I := 0 to FPluginList.Count - 1 do
    AEnumProc(TBaseOperation(FPluginList[I]));
end;

function TBaseViewPluginManager.GetDefaultOperation: TBaseOperation;
begin
  if FPluginList.Count > 0 then
    Result := TBaseOperation(FPluginList[0])
  else
    Result := nil;
end;

procedure TBaseViewPluginManager.NotifyPlugin(CommandID: Integer);
var
  I: Integer;
begin
  for I := 0 to FPluginList.Count - 1 do
    TBaseOperation(FPluginList[I]).Execute(CommandID,
      [Integer(PluginContainer)]);
end;

procedure TBaseViewPluginManager.PluginOperation(AOperation: TBaseOperation);
begin
  if CanPlugin(AOperation) then
  begin
    if AOperation.CustomAttributes.IndexOf('PluginContainer') > -1 then
      AOperation.CustomAttributes.Delete
        (AOperation.CustomAttributes.IndexOf('PluginContainer'));

    if (PluginContainer.Operation <> nil) and
      (AOperation.CustomAttributes.IndexOf(PluginContainer.Operation.GUID) > -1)
    then
      AOperation.CustomAttributes.Delete
        (AOperation.CustomAttributes.IndexOf(PluginContainer.Operation.GUID));

    // ͨ��CustomAttributes��������, ע���п����ͷ�!
    AOperation.CustomAttributes.AddObject('PluginContainer', PluginContainer);

    // һ������ɳ����������ط�����ͬ�ĵط����岻ͬ�Ķ�������
    if (PluginContainer.Operation <> nil) then
      AOperation.CustomAttributes.AddObject(PluginContainer.Operation.GUID,
        PluginContainer);

    FPluginList.Add(Pointer(AOperation));
  end;
end;

procedure TBaseViewPluginManager.PluginOperations(AOperations: TOperations);
begin
  AOperations.ForEach(PluginOperation);
end;

procedure TBaseViewPluginManager.UnloadPluginControl
  (AOperation: TBaseOperation);
begin
  if StrToBoolDef(AOperation.CustomAttributes.Values['PluginControl'], False)
  then
    AOperation.Execute(iOperationCommand_UnloadPlugin,
      [Integer(PluginContainer)]);
end;

initialization

AppCore := TAppCore.Create;

finalization

FreeAndNil(AppCore);

end.
