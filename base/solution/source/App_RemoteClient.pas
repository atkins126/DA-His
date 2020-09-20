unit App_RemoteClient;

{
  RemObjects DataAbstrat�ͻ���ͨѶ�����

  1. Ĭ��ʹ��SuperTCP������Organizer������Ϊ����ͨѶͨ��
  2. ����Զ����غͱ�������
}

interface

uses
  SysUtils,
  Classes,
  Forms,
  Windows,
  Dialogs,
  DB,
  App_Common,
  uROClient,
  DataAbstract4_Intf,
  uROClientIntf,
  uDAScriptingProvider,
  uDADataTable,
  uDAMemDataTable,
  uRODynamicRequest,
  uDARemoteDataAdapter,
  uDADataStreamer,
  uDABin2DataStreamer,
  uRORemoteService,
  uROBinMessage,
  uDAInterfaces,
  uROEventRepository,
  uROSuperTCPChannel,
  uROBaseSuperChannel,
  uROBaseSuperTCPChannel,
  uDADataAdapter,
  uROBaseHTTPClient,
  uROIndyHTTPChannel,
  uDARemoteCommand,
  uDADesigntimeCall;


type
  TROClient = class(TDataModule)
    BinMessage: TROBinMessage;
    RemoteService: TRORemoteService;
    DataStreamer: TDABin2DataStreamer;
    DataAdapter: TDARemoteDataAdapter;
    TestTable: TDAMemDataTable;
    TestSource: TDADataSource;
    EventReceiver: TROEventReceiver;
    DARemoteCommand: TDARemoteCommand;
    DADesigntimeCall: TDADesigntimeCall;
    LoginService: TRORemoteService;
    DATestCall: TDADesigntimeCall;
    SuperChannel: TROSuperTCPChannel;
    HttpChannel: TROIndyHTTPChannel;
    procedure DataAdapterBeforeGetDataCall(Sender: TObject; Request: TRODynamicRequest);
    procedure DataAdapterAfterGetDataCall(Sender: TObject; Request: TRODynamicRequest);
    procedure DataAdapterGetSchemaCallBeforeExecute(Sender: TRODynamicRequest);
    procedure DataAdapterUpdateDataCallAfterExecute(Sender: TRODynamicRequest);
    procedure DataAdapterUpdateDataCallExecuteError(Sender: TRODynamicRequest;
      Error: Exception; var Ignore: Boolean);
    procedure DataAdapterUpdateDataCallBeforeExecute(
      Sender: TRODynamicRequest);
  private
    PerformanceCounter1, PerformanceCounter2, PerformanceFrequency: Int64;
  public
  end;

var
  ROClient: TROClient;

implementation

{$R *.dfm}

const
  sConfigSection = 'RemoteClient';

{ TRemoteClientModule }

procedure TROClient.DataAdapterBeforeGetDataCall(Sender: TObject;
  Request: TRODynamicRequest);
begin
  AppCore.Logger.Write('���ڲ�ѯ����...', mtDebug, 0);
  QueryPerformanceCounter(PerformanceCounter1);
end;

procedure TROClient.DataAdapterAfterGetDataCall(Sender: TObject;
  Request: TRODynamicRequest);
begin
  QueryPerformanceCounter(PerformanceCounter2);
  QueryPerformanceFrequency(PerformanceFrequency);
  AppCore.Logger.WriteFmt('��ѯ��ʱ %0.3f ��',
    [(PerformanceCounter2 - PerformanceCounter1) / PerformanceFrequency],
    mtDebug, 0);
end;

procedure TROClient.DataAdapterGetSchemaCallBeforeExecute(
  Sender: TRODynamicRequest);
begin
  AppCore.Logger.Write('�������������ڲ�ѯSchema...', mtDebug, 0);
end;

procedure TROClient.DataAdapterUpdateDataCallBeforeExecute(
  Sender: TRODynamicRequest);
begin
  AppCore.Logger.Write('�����ύ����...', mtDebug, 0);
end;

procedure TROClient.DataAdapterUpdateDataCallAfterExecute(
  Sender: TRODynamicRequest);
begin
  AppCore.Logger.Write('�����ύ�ɹ�', mtDebug, 0);
end;

procedure TROClient.DataAdapterUpdateDataCallExecuteError(
  Sender: TRODynamicRequest; Error: Exception; var Ignore: Boolean);
begin
  AppCore.Logger.Write('�����ύʧ�ܣ�ԭ��' + Error.Message, mtError, 0);
end;

initialization
  ROClient := TROClient.Create(nil);

finalization
  FreeAndNil(ROClient);

end.

