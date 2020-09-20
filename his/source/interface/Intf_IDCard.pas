unit Intf_IDCard;

{
  ���֤�Ķ����ӿ�
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  DateUtils,
  jpeg,
  Menus,
  StrUtils,
  cxGraphics,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxButtons,
  uROClasses,
  App_Common,
  App_FastReport;

const
  sReadState = '����״̬';
  sNotOpen = '������δ��';

  sOpenPortError = '�򿪴���ʧ��!';
  sTimeOutError = 'ͨѶ��ʱ!';
  sRecError = '����ʧ��!';
  sXpError = '��Ƭ�������!';
  sFileExtError = 'wlt�ļ���׺����!';
  sFileOpenError = 'wlt�ļ��򿪴���!';
  sFileFormatError = 'wlt�ļ���ʽ����!';
  sJmError = '���δ��Ȩ!';
  sCardError = '����֤����!';
  sUnknowError = 'δ֪����!';

  sSwipe = '��ſ�...';
  sReadOK = '�����ɹ�!�����һ�ſ�...';
  sReadError = '����ʧ��!�����·ſ�...';
  sNewAddError = '������סַʧ��!';
  sIINSNDNError = '��оƬ��ʧ��!';
  sReading = '���ڶ���...';

  Lib = 'termb.dll';

function InitComm(Port: Integer): Integer; stdcall; external Lib;
function InitCommExt(): Integer; stdcall; external Lib;
function Authenticate(): Integer; stdcall; external Lib;
function Read_Content(Active: Integer): Integer; stdcall; external Lib;
function Read_Content_Path(FileName: PChar; Active: Integer): Integer; stdcall;
  external Lib;
function CloseComm(): Integer; stdcall; external Lib;
function GetSAMID(SAMID: PChar): Integer; stdcall; external Lib;
function GetPhoto(FileName: PChar): Integer; stdcall; external Lib;

const
  NationTable: array [1 .. 56] of string = ('��', '�ɹ�', '��', '��', 'ά���', '��',
    '��', '׳', '����', '����', '��', '��', '��', '��', '����', '����', '������', '��', '��', '����',
    '��', '�', '��ɽ', '����', 'ˮ', '����', '����', '����', '�¶�����', '��', '���Ӷ�', '����', 'Ǽ',
    '����', '����', 'ë��', '����', '����', '����', '����', '������', 'ŭ', '���α��', '����˹', '���¿�',
    '�°�', '����', 'ԣ��', '��', '������', '����', '���״�', '����', '�Ű�', '���', '��ŵ');

type

  { ���֤�ֶ� }
  TIDField = (idName, idSex, idNation, idBirth, idAddress, idID, idSender,
    idValidStartDate, idValidEndDate, idAlwaysValid, idNewAddress);

  { ���֤�� }
  TIdentity = class(TPersistent)
  private
    FName: string;
    FSexCode: Integer;
    FNationCode: Integer;
    FBirthday: TDate;
    FAddress: string;
    FID: string;
    FSender: string;
    FValidStartDate: TDate;
    FValidEndDate: TDate;
    FAlwaysValid: Boolean;
    FNewAddress: string;
    FPhoto: Graphics.TBitmap;
    function GetSex(): string;
    function GetNation(): string;
  public
    constructor Create();
    destructor Destroy(); override;
    property Photo: Graphics.TBitmap read FPhoto;
  published
    property Name: string read FName write FName;
    property SexCode: Integer read FSexCode write FSexCode;
    property Sex: string read GetSex;
    property NationCode: Integer read FNationCode write FNationCode;
    property Nation: string read GetNation;
    property Birthday: TDate read FBirthday write FBirthday;
    property Address: string read FAddress write FAddress;
    property ID: string read FID write FID;
    property Sender: string read FSender write FSender;
    property ValidStartDate: TDate read FValidStartDate write FValidStartDate;
    property ValidEndDate: TDate read FValidEndDate write FValidEndDate;
    property AlwaysValid: Boolean read FAlwaysValid write FAlwaysValid;
    property NewAddress: string read FNewAddress write FNewAddress;
  end;

  {
    ���֤�Ķ���
    ���ܣ�
    1 ��ʱ�Ķ����֤��Ϣ����ɨ�赽�����֤ʱ�����¼�
    2 �ṩ����״̬�¼�
    3 �������������֤��Ϣ
  }
  TIDReader = class
  private
    FIdentity: TIdentity; // ��ǰ���֤
    FInterval: Cardinal;
    FActive: Boolean;
    FReady: Boolean; // �������Ƿ�׼����
    FStatus: string; // ��ǰ״̬
    FTimer: TROThreadTimer;
    FOnReading: TNotifyEvent;
    FOnStatus: TNotifyEvent;
    procedure SetActive(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnReading(Value: TNotifyEvent);
    procedure SetOnStatus(Value: TNotifyEvent);
    procedure DoTimer(CurrentTickCount: Cardinal);

    procedure Open;
    procedure Close;
    procedure DoReading();
    procedure DoStatus();
    procedure UpdateID();
  public
    constructor Create();
    destructor Destroy(); override;
    function ReadCard(): Boolean;
    procedure PrintIdentity(Preview: Boolean = False);
  published
    property Identity: TIdentity read FIdentity;
    property Active: Boolean read FActive write SetActive;
    property Interval: Cardinal read FInterval write SetInterval;
    property Ready: Boolean read FReady;
    property Status: string read FStatus;
    property OnReading: TNotifyEvent read FOnReading write SetOnReading;
    property OnStatus: TNotifyEvent read FOnStatus write SetOnStatus;
  end;

  TIDForm = class(TBaseView)
    NameLabel: TLabel;
    SexLabel: TLabel;
    NationLabel: TLabel;
    PhotoImg: TImage;
    AddressLabel: TLabel;
    IDLabel: TLabel;
    SenderLabel: TLabel;
    ValidDateLabel: TLabel;
    YearLabel: TLabel;
    NewAddressLabel: TLabel;
    Image1: TImage;
    Image2: TImage;
    MonthLabel: TLabel;
    DayLabel: TLabel;
    PrintBtn: TcxButton;
    CancelBtn: TcxButton;
    OKBtn: TcxButton;
    StatusLabel: TLabel;
    ReadBtn: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReadBtnClick(Sender: TObject);
  private
    procedure DoStatus(Sender: TObject);
    procedure DoReading(Sender: TObject);
  public
    { Public declarations }
  end;

function ShowIDCard(): Boolean;
function GetNationName(AValue: Integer): string;

var
  IDReader: TIDReader;

implementation

{$R *.dfm}

var
  IDForm: TIDForm;

function GetNationName(AValue: Integer): string;
begin
  if (AValue >= 1) and (AValue <= 56) then
    Result := NationTable[AValue]
  else
    Result := '';
end;

function ShowIDCard(): Boolean;
begin
  if IDForm = nil then
    IDForm := TIDForm.Create(Application);
  Result := IDForm.ShowModal = mrOk;
end;

procedure TIDForm.DoReading(Sender: TObject);
begin
  with IDReader.Identity do
  begin
    NameLabel.Caption := Name;
    SexLabel.Caption := Sex;
    NationLabel.Caption := Nation;
    YearLabel.Caption := IntToStr(YearOf(Birthday));
    MonthLabel.Caption := IntToStr(MonthOf(Birthday));
    DayLabel.Caption := IntToStr(DayOf(Birthday));
    AddressLabel.Caption := Address;
    IDLabel.Caption := ID;
    PhotoImg.Picture.Bitmap := Photo;
    // PhotoImg.Transparent := True;
    // PhotoImg.Picture.Bitmap.Transparent := True;
    // PhotoImg.Picture.Bitmap.TransparentMode := tmFixed; //tmAuto;
    PhotoImg.Picture.Bitmap.TransparentColor :=
      PhotoImg.Picture.Bitmap.Canvas.Pixels[0, 0];
    // clWhite; //254 shl 16 + 254 shl 8 + 254;

    SenderLabel.Caption := Sender;
    if AlwaysValid then
      ValidDateLabel.Caption := '����'
    else
      ValidDateLabel.Caption := FormatDateTime('YYYY.MM.DD', ValidEndDate);
    ValidDateLabel.Caption := FormatDateTime('YYYY.MM.DD', ValidStartDate) + '-'
      + ValidDateLabel.Caption;

    NewAddressLabel.Caption := NewAddress;
  end;

  OKBtn.Enabled := True;
end;

procedure TIDForm.DoStatus(Sender: TObject);
begin
  StatusLabel.Caption := TIDReader(Sender).Status;
end;

procedure TIDForm.FormCreate(Sender: TObject);
begin
  inherited;
  IDReader.OnReading := DoReading;
  IDReader.OnStatus := DoStatus;
end;

procedure TIDForm.PrintBtnClick(Sender: TObject);
begin
  IDReader.PrintIdentity(False);
end;

{ TIdentity }

constructor TIdentity.Create;
begin
  FPhoto := Graphics.TBitmap.Create();
  FPhoto.Transparent := True;
  FPhoto.TransparentMode := tmAuto;
end;

destructor TIdentity.Destroy;
begin
  FPhoto.Free;
  inherited;
end;

function TIdentity.GetNation: string;
begin
  Result := GetNationName(FNationCode);
end;

function TIdentity.GetSex: string;
begin
  case FSexCode of
    0:
      Result := 'δ֪';
    1:
      Result := '��';
    2:
      Result := 'Ů';
  else
    Result := 'δ˵��';
  end;
end;

{ TIDReader }

procedure TIDReader.Close;
begin
  CloseComm;
  FReady := False;
  FStatus := sNotOpen;
  DoStatus;
end;

constructor TIDReader.Create;
begin
  FInterval := 1500;
  FStatus := sNotOpen;
  FIdentity := TIdentity.Create;
end;

destructor TIDReader.Destroy;
begin
  Active := False;
  Close;
  FreeAndNil(FIdentity);
  inherited;
end;

procedure TIDReader.DoReading;
begin
  if Assigned(FOnReading) then
    FOnReading(Self);
end;

procedure TIDReader.DoStatus;
begin
  if Assigned(FOnStatus) then
    FOnStatus(Self);
end;

procedure TIDReader.Open;
var
  Answer: Integer;
  Port: Integer;
begin
  if FReady then
    Close();

  FStatus := '���ڴ�ͨѶ�˿�...';
  DoStatus;

  Answer := InitCommExt(); // ���ܴ�USB�ڣ�����
  if Answer <> 1 then
  begin
    for Port := 1001 to 1004 do
    begin
      Answer := InitComm(Port);
      if Answer = 1 then
        Break;
    end;
  end;

  FReady := Answer = 1;
  case Answer of
    1:
      FStatus := sReadState;
  else
    FStatus := sOpenPortError;
  end;
  DoStatus;
end;

function TIDReader.ReadCard(): Boolean;
var
  Answer: Integer;
begin
  Result := False;

  if not FReady then
    Open;
  if not FReady then
    Exit;

  FStatus := sReading;
  DoStatus;

  Answer := Authenticate();
  if Answer = 1 then
  begin
    Answer := Read_Content(1);
    Result := Answer = 1;
    case Answer of
      1:
        FStatus := sReadOK;
      -1:
        FStatus := sXpError;
      -2:
        FStatus := sFileExtError;
      -3:
        FStatus := sFileOpenError;
      -4:
        FStatus := sFileFormatError;
      -5:
        FStatus := sJmError;
    else
      FStatus := sReadError;
    end;
    DoStatus;
    if Result then
      UpdateID();
  end
  else
  begin
    FStatus := sSwipe;
    DoStatus;
  end
end;

procedure TIDReader.SetActive(Value: Boolean);
begin
  if Value = FActive then
    Exit;
  FActive := Value;

  if Value then
    FTimer := TROThreadTimer.Create(DoTimer, FInterval, True)
  else
    FreeAndNil(FTimer);
end;

procedure TIDReader.SetOnReading(Value: TNotifyEvent);
begin
  FOnReading := Value;
end;

procedure TIDReader.SetOnStatus(Value: TNotifyEvent);
begin
  FOnStatus := Value;
end;

procedure TIDReader.UpdateID;
var
  Buffer: WideString;
  WZFile: TFileStream;
const
  WZSize = 290; // �����ĵ�������סַ��ʵ��WZ.txt����
begin
  WZFile := TFileStream.Create(ExtractFilePath(ParamStr(0)) + '\wz.txt',
    fmOpenRead);
  try
    SetLength(Buffer, WZSize + 1);
    WZFile.Read(Buffer[1], WZSize);
    with FIdentity do
    begin
      // ����SDK��ȡ���ֶ�
      FName := Trim(MidStr(Buffer, 1, 15));
      FSexCode := StrToInt(MidStr(Buffer, 16, 1));
      FNationCode := StrToInt(MidStr(Buffer, 17, 2));
      FBirthday := EncodeDate(StrToInt(MidStr(Buffer, 19, 4)),
        StrToInt(MidStr(Buffer, 23, 2)), StrToInt(MidStr(Buffer, 25, 2)));
      FAddress := Trim(MidStr(Buffer, 27, 35));
      FID := Trim(MidStr(Buffer, 62, 18));
      FSender := Trim(MidStr(Buffer, 80, 15));
      FValidStartDate := EncodeDate(StrToInt(MidStr(Buffer, 95, 4)),
        StrToInt(MidStr(Buffer, 99, 2)), StrToInt(MidStr(Buffer, 101, 2)));
      FAlwaysValid := MidStr(Buffer, 103, 2) = '����';
      if not FAlwaysValid then
        FValidEndDate := EncodeDate(StrToInt(MidStr(Buffer, 103, 4)),
          StrToInt(MidStr(Buffer, 107, 2)), StrToInt(MidStr(Buffer, 109, 2)))
      else
        FValidEndDate := EncodeDate(YearOf(FValidStartDate) + 200,
          MonthOf(FValidStartDate), DayOf(FValidStartDate));
      // 200���㳤����Ч��
      FNewAddress := Trim(MidStr(Buffer, 111, 18));
      FPhoto.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\zp.bmp');
    end;

    DoReading();
  finally
    WZFile.Free;
  end;
end;

procedure TIDReader.PrintIdentity(Preview: Boolean);
begin
  with FIdentity do
    FastReport.PrintReport('���֤.fr3', [], [], ['CardName', 'CardSex',
      'CardNation', 'CardBirth', 'CardAddress', 'CardID', 'PhotoFile',
      'CardSender', 'CardStartDate', 'CardEndDate', 'CardAlwaysValid'],
      [QuotedStr(Name), QuotedStr(Sex), QuotedStr(Nation), Birthday,
      QuotedStr(Address), QuotedStr(ID), QuotedStr(ExtractFilePath(ParamStr(0))
      + 'zp.bmp'), QuotedStr(Sender), ValidStartDate, ValidEndDate,
      AlwaysValid], Preview, '');
end;

procedure TIDReader.DoTimer(CurrentTickCount: Cardinal);
begin
  ReadCard;
end;

procedure TIDReader.SetInterval(Value: Cardinal);
begin
  if FTimer <> nil then
    FTimer.Timeout := Value;
end;

procedure TIDForm.FormShow(Sender: TObject);
begin
  // IDReader.Active := True;
end;

procedure TIDForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IDReader.Active := False;
end;

procedure TIDForm.ReadBtnClick(Sender: TObject);
begin
  IDReader.ReadCard;
end;

initialization

IDReader := TIDReader.Create;

finalization

FreeAndNil(IDReader);

end.
