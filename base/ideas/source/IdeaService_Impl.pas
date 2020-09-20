unit IdeaService_Impl;

{
  ���ݷ������ģ��

  Written by caowm (remobjects@qq.com)
  2014��9��
}

{$I DataAbstract.inc}

interface

uses
  {vcl:} Classes, SyncObjs, SysUtils, uDASupportClasses, uROEventRepository,
  {RemObjects:} uROClientIntf, uROTypes, uROServer, uROServerIntf, uROSessions,
  uRORemoteDataModule,
  {Data Abstract:} uDAStreamableComponent, uDADataTable, uDABin2DataStreamer,
  uDAInterfaces, uDABusinessProcessor, uDAConnectionManager, uDASchema,
  {Ancestor Implementation:} DataAbstractService_Impl,
  {Used RODLs:} DataAbstract4_Intf,
  {Generated:} IdeaLibrary_Intf, uROClient, uDADataStreamer,
  uROClassFactories, uDAFields, uDADelta, uROComponent, uDAJSONDataStreamer;

const
  iWaitTimeBeforeUpdateSchema = 3000;

type
  TIdeaManager = class;
  TIdeaCollection = class;
  TIdeaItem = class;

  { TIdeaService }
  TIdeaService = class(TDataAbstractService, IIdeaService)
    procedure DataAbstractServiceActivate(const aClientID: TGUID;
      aSession: TROSession; const aMessage: IROMessage);
    procedure DataAbstractServiceCreate(Sender: TObject);
    procedure DataAbstractServiceUpdateDataBeginTransaction(Sender: TObject;
      var aUseDefaultTransactionLogic: Boolean);
  private
    FRefIdea: TIdeaItem;
  protected
    { IIdeaService methods }
  end;

  {
    ���ݷ��񼯳ɹ�����
    ===================================================================
    1. ���������ļ�Idea.xml����̬�������ݷ���
    2. ��ֻ̨��Ҫ�����޸�Schema���ܴﵽ�����޸����ݷ���
    3. ��ߵĹ�����Relativity Server����
  }
  TIdeaManager = class(TDAStreamableComponent)
  private
    FServices: TIdeaCollection;
    FSessionManager: TROCustomSessionManager;
    FEventRepository: TROEventRepository;
    FConnectionManager: TDAConnectionManager;
  protected
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy(); override;
    procedure RegisterServices(ADefinitionFile: string);

    property ConnectionManager: TDAConnectionManager read FConnectionManager
      write FConnectionManager;
    property SessionManager: TROCustomSessionManager read FSessionManager
      write FSessionManager;
    property EventRepository: TROEventRepository read FEventRepository
      write FEventRepository;
  published
    property Services: TIdeaCollection read FServices;
  end;

  TIdeaCollection = class(TSearcheableCollection)
  private
    function GetItem(Index: Integer): TIdeaItem;
  public
    constructor Create(aOwner: TPersistent);
    property Items[Index: Integer]: TIdeaItem read GetItem; default;
  end;

  TIdeaItem = class(TCollectionItem)
  private
    FServiceName: string;
    FConnectionName: string;
    FSchemaName: string;
    FSchemaCritical: TCriticalSection;
    FSchemaUpdating: Boolean;

    FSchema: TDASchema;
    FDAStreamer: TDADataStreamer;
    FFactory: IROClassFactory;
    procedure RegisterOperation();
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy(); override;
    function RegisterService(): TROClassFactory;
    function GetSchema(): TDASchema;
    procedure RefreshSchema(AIsFirstTime: Boolean = False);
    function GetDAStreamer(): TDADataStreamer;
  published
    property Name: string read FServiceName write FServiceName;
    property ServiceName: string read FServiceName write FServiceName;
    property ConnectionName: string read FConnectionName write FConnectionName;
    property SchemaName: string read FSchemaName write FSchemaName;
  end;

  TIdeaCreateFunc = procedure(out anInstance: IInterface; aData: TIdeaItem);

  TIdeaFactory = class(TROClassFactory)
  private
    FIdeaItem: TIdeaItem;
  protected
    procedure CreateInstance(const aClientID: TGUID;
      out anInstance: IInterface); override;
  public
    constructor Create(const anInterfaceName: string;
      aCreatorFunc: TIdeaCreateFunc; anInvokerClass: TROInvokerClass;
      aIdeaItem: TIdeaItem);
  end;

var
  IdeaManager: TIdeaManager; // ��ʹ�÷���������

implementation

{$IFDEF DELPHIXE2UP}
{%CLASSGROUP 'System.Classes.TPersistent'}
{$ENDIF}
{$R *.dfm}

uses
  {Generated:} IdeaLibrary_Invk, App_Common, App_DAServer;

procedure Create_IdeaService(out anInstance: IUnknown; aData: TIdeaItem);
var
  Service: TIdeaService;
begin
  Service := TIdeaService.Create(nil);
  with Service do
  begin
    FRefIdea := aData;
    ConnectionName := aData.ConnectionName;
    SessionManager := IdeaManager.SessionManager;
    EventRepository := IdeaManager.EventRepository;
  end;
  anInstance := Service;
end;

function RefreshSchemaOperation(Sender: TBaseOperation; CommandID: Integer;
  const Param: array of Variant): Variant;
begin
  TIdeaItem(Sender.Data).RefreshSchema;
end;

{ TIdeaService }

procedure TIdeaService.DataAbstractServiceActivate(const aClientID: TGUID;
  aSession: TROSession; const aMessage: IROMessage);
begin
  ServiceDataStreamer := FRefIdea.GetDAStreamer;
  ServiceSchema := FRefIdea.GetSchema;
end;

procedure TIdeaService.DataAbstractServiceCreate(Sender: TObject);
begin
  AllowWhereSQL := True;
end;

{ TIdeaManager }

constructor TIdeaManager.Create(aOwner: TComponent);
begin
  inherited;
  FServices := TIdeaCollection.Create(Self);
  FSessionManager := RemoteServer.SessionManager;
  FEventRepository := RemoteServer.EventRepository;
  FConnectionManager := RemoteServer.ConnectionManager;
end;

destructor TIdeaManager.Destroy;
begin
  FServices.Free;
  inherited;
end;

procedure TIdeaManager.RegisterServices(ADefinitionFile: string);
var
  I: Integer;
begin
  LoadFromFile(ADefinitionFile);
  for I := 0 to Services.Count - 1 do
    Services[I].RegisterService;
end;

{ TIdeaCollection }

constructor TIdeaCollection.Create(aOwner: TPersistent);
begin
  inherited Create(aOwner, TIdeaItem);
end;

function TIdeaCollection.GetItem(Index: Integer): TIdeaItem;
begin
  Result := TIdeaItem(inherited Items[index]);
end;

{ TIdeaItem }

constructor TIdeaItem.Create(Collection: TCollection);
begin
  inherited;
  FSchema := TDASchema.Create(nil);
  FSchemaCritical := TCriticalSection.Create;
  FDAStreamer := RemoteServer.NewDAStreamer(nil);
end;

destructor TIdeaItem.Destroy;
begin
  FDAStreamer.Free;
  FSchema.Free;
  FSchemaCritical.Free;
  if FFactory <> nil then
    UnRegisterClassFactory(FFactory);
  FFactory := nil;
  inherited;
end;

function TIdeaItem.GetDAStreamer: TDADataStreamer;
begin
  Result := FDAStreamer;
end;

function TIdeaItem.GetSchema: TDASchema;
begin
  if FSchemaUpdating then
  begin
    // �ȴ�Schema�������
    FSchemaCritical.Enter;
    try
    finally
      FSchemaCritical.Release;
    end;
  end;
  Result := FSchema;
end;

procedure TIdeaItem.RefreshSchema(AIsFirstTime: Boolean);
var
  SchemaFileName: string;
begin
  FSchemaCritical.Enter;
  FSchemaUpdating := True;
  try
    // �ȴ����д�����ɣ�ʱ��Խ�����ϸ���Խ��
    // ���е�DataService����ͨ��GetSchema����ȡSchema�������ɱ�֤��Schema����
    // �ڼ䲻����ֹ���
    if not AIsFirstTime then
      Sleep(iWaitTimeBeforeUpdateSchema);

    FSchema.Clear;
    SchemaFileName := AppCore.BinPath + SchemaName;
    if FileExists(SchemaFileName) then
    begin
      try
        FSchema.LoadFromFile(SchemaFileName);
        AppCore.Logger.Write(SchemaFileName + '�������.', mtInfo, 0);
      except
        on E: Exception do
          AppCore.Logger.Write('ϵͳ����Schema����ʧ�ܣ�ԭ��' + E.Message, mtError, 0);
      end;
    end
    else
      AppCore.Logger.WriteFmt('%sϵͳ�����ļ�δ�ҵ�', [SchemaFileName], mtError, 0);
  finally
    FSchemaUpdating := False;
    FSchemaCritical.Release;
  end;
end;

procedure TIdeaItem.RegisterOperation;
begin
  with TProcOperation.Create('Service_' + ServiceName) do
  begin
    Category := '���ݷ���';
    Caption := '����' + SchemaName;
    ImageName := ServiceName;
    Flag := iOperationFlag_NoTree; // ����ʾ�ڲ�������
    OnExecute := RefreshSchemaOperation;
    Data := Self;
    Order := 'z9';
  end;
end;

function TIdeaItem.RegisterService: TROClassFactory;
begin
  FSchema.ConnectionManager := IdeaManager.ConnectionManager;
  RegisterOperation;
  RefreshSchema(True);
  Result := TIdeaFactory.Create(ServiceName, Create_IdeaService,
    TIdeaService_Invoker, Self);
  FFactory := Result;
end;

{ TIdeaFactory }

constructor TIdeaFactory.Create(const anInterfaceName: string;
  aCreatorFunc: TIdeaCreateFunc; anInvokerClass: TROInvokerClass;
  aIdeaItem: TIdeaItem);
begin
  inherited Create(anInterfaceName, TRORemotableCreatorFunc(aCreatorFunc),
    anInvokerClass);
  FIdeaItem := aIdeaItem;
end;

procedure TIdeaFactory.CreateInstance(const aClientID: TGUID;
  out anInstance: IInterface);
begin
  TIdeaCreateFunc(CreatorFunc)(anInstance, FIdeaItem);
end;

procedure TIdeaService.DataAbstractServiceUpdateDataBeginTransaction
  (Sender: TObject; var aUseDefaultTransactionLogic: Boolean);
begin
  aUseDefaultTransactionLogic := False;
end;

initialization

IdeaManager := TIdeaManager.Create(nil);

finalization

FreeAndNil(IdeaManager);

end.
