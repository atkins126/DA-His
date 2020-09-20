unit App_Function;

{
  ͨ�ú�����

  Written by caowm (remobjects@qq.com)
  2014��9��
}

interface

uses
  Classes,
  SysUtils,
  Windows,
  Messages,
  Forms,
  Dialogs,
  ZLib,
  jpeg,
  Menus,
  Controls,
  ActnList,
  Graphics,
  StdCtrls,
  TypInfo,
  StrUtils,
  IniFiles,
  ShellAPI,
  DB,
  Math,
  Types,
  Nb30,
  WinSock;

type
  TOnProgress = procedure(MaxValue, Position: Integer; var Canceled: Boolean)
    of object;
  TDataSetEnumProc = procedure(ADataSet: TDataSet; AParam: variant) of object;

  // ����DataSet
procedure EnumDataSet(ADataSet: TDataSet; AEnumProc: TDataSetEnumProc;
  AParam: variant);

{
  �ı����ƶȼ���
  Damerau-Levenshtein's distance
  untested
  http://www.delphiarea.com/articles/how-to-match-two-strings-approximately/
}
function DamerauLevenshteinDistance(const Str1, Str2: AnsiString): Integer;
function StringSimilarityRatio(const Str1, Str2: AnsiString;
  IgnoreCase: Boolean): Double;

// ����һ��Method
function MakeMethod(ACode: Pointer): TMethod;

// ������ʱ�ļ�
function GetTempFile(APrefix: AnsiString): AnsiString; overload;
function GetTempFile(ATempPath, APrefix: AnsiString): AnsiString; overload;
// ��ʱĿ¼(����'\')
function GetTempDirectory(): AnsiString;
// ɾ������Ŀ¼
function DelDirectory(const Source: AnsiString): Integer;
// ѡ����ļ�
function SelectFile(const AFilter: AnsiString;
  var AFileName: AnsiString): Boolean;

// Save a reference to a AnsiString and return a raw pointer to the AnsiString.
function RefString(const S: AnsiString): Pointer;
// Release a AnsiString that was referenced with RefString.
procedure ReleaseString(P: Pointer);

// ѹ��
procedure Compress(Source, Dest: TStream; BlockSize: Integer;
  OnProgress: TOnProgress = nil);
// ��ѹ
procedure Decompress(Source, Dest: TStream; OnProgress: TOnProgress = nil);

// ��ʾ��Ϣ
procedure ShowOK(Msg: string);
// ��ʾ����
procedure ShowHelp(Content: string);
// ��ʾ����
procedure ShowAbout(Content: string);
// ��ʾ����
procedure ShowWarning(Msg: string);
// ��ʾ������Ϣ
procedure ShowError(Msg: string);
// ��ʾ��ѡһ�Ի���
function ShowYesNo(Msg: string; YesOrNo: Boolean = True): Boolean;
// ��ʾ��ѡһ�Ի���
function ShowYesNoCancel(Msg: string): Integer;
// ��ʾ����Ի���
function ShowSave(ATitle, AFilter: string; var AFileName: string;
  ADefaultExt: string = 'xls'): Boolean;
// ��ʾ�򿪶Ի���
function ShowOpen(ATitle, AFilter: string; var AFileName: string): Boolean;

// ��ֹ����ڶ��δ�
function AlreadyRunning(): Boolean;
// �������ڶ��δ�
procedure AllowProgramTwiceOpen();

// ���ַ���ת��Ϊ�ɴ洢��XML�е��ַ�������Escape�����ַ�
function StrToXML(const S: AnsiString): AnsiString;

// ����ȫ�����������ģ�飬��������ΪClassRef�Ķ���List����������ƺͶ���
// ����������治��"."˵�����������Owner������������������������ģ����
procedure GetComponents(Owner: TComponent; ClassRef: TClass; List: TStrings;
  Skip: TComponent);

// ��ȡ����Ҵ�д
function RMB(Num: Currency): AnsiString;

// �������ÿؼ�
function CreateLabel(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect): TLabel;
function CreateControl(AOwner: TComponent; AParent: TWinControl;
  AClass: TControlClass; ABounds: TRect): TControl;
function CreateForm(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect; ABorderStyle: TBorderStyle): TForm;
function CreateEdit(AOwner: TComponent; AParent: TWinControl;
  ABounds: TRect): TEdit;
function CreateButton(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect): TButton;
function CreateGroupBox(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect): TGroupBox;

// ʹ��Ini�ļ���������
procedure ReadFromIni(Self: TPersistent; IniFile: TIniFile;
  const Section: AnsiString);
procedure WriteToIni(Self: TPersistent; IniFile: TIniFile;
  const Section: AnsiString);
procedure ClonePersistent(Source, Dest: TPersistent); overload;

// �ú���ƴ�����ȡƴ����ķ���
function GetPyOfHz(HzChar: PAnsiChar): AnsiString;
function GetPyHeadOfHz(HzChar: PAnsiChar): AnsiString;
function GetPyHeadOfHzs(HzChars: AnsiString): AnsiString;
function GetPyOfHzs(HzChars, Seperator: AnsiString): AnsiString;
function IsDouByte(C: AnsiChar): Boolean;

// ��ϵͳ����������ȡ���ֵ�ƴ������ĸ����Win7��ʧЧ
function GetPY(AStr: WideString): AnsiString;

// ��ȡ���������
function GetLocalName(): AnsiString;
// ��ȡ�����IP�����㣺�����������2�ż������������õ��������һ��
function GetLocalIP: AnsiString;
// ��ȡMac��ַ
function GetNetBIOSAddress: AnsiString;

{ Inch to Cm }
function Inch2Cm(const Inch: Extended): Extended;
{ Cm to Inch }
function Cm2Inch(const Cm: Extended): Extended;

{ ��ȡJPGͼƬ�ķֱ���, ��Ӣ��Ϊ��λ }
procedure GetJpgResolution(JPGFile: AnsiString; var HorzRes, VertRes: Word);
{ ����JPGͼƬ�ķֱ��ʣ���Ӣ��Ϊ��λ }
procedure SetJpgResolution(JPGFile: AnsiString; dpix, dpiy: Word);

{ ��ȡ�����в��� }
function GetCmdLineParam(const Param: AnsiString): AnsiString;

{ ��ȡ�ı���� }
function GetTextWidth(const AText: AnsiString; AFont: TFont): Integer;

{ ʮ�������ı�ת��Ϊ�ı� }
function HexToString(str: AnsiString): AnsiString;
function StringToHex(str: AnsiString): AnsiString;

{ ��ȡ�ַ����������Ǻ��� }
function GetCharCount(const AText: AnsiString): Integer;

{ ��TStingsת��Ϊ�ַ������� }
function StringListToArray(Source: TStrings): TStringDynArray;

{ �ѷ��ŷָ����ַ���ת��Ϊ�ַ������� }
function DelimitedTextToArray(DelimitedText: AnsiString;
  Delimiter: AnsiChar = ';'): TStringDynArray;

procedure BuildPopupMenu(AOwner: TComponent; APopupMenu: TPopupMenu;
  AActions: TActionList); overload;

procedure BuildPopupMenu(AOwner: TComponent; APopupMenu: TPopupMenu;
  AActions: array of TAction); overload;

procedure PlaceFormBelowControl(ATarget: TForm; AControl: TControl);

function StandardizeLocalDate(ADatetime: AnsiString): AnsiString;

// Ansi��UTF8�໥ת��
function AnsiToWide(const S: AnsiString): WideString;
function WideToUTF8(const WS: WideString): UTF8String;
function AnsiToUTF8(const S: AnsiString): UTF8String;
function UTF8ToWide(const US: UTF8String): WideString;
function WideToAnsi(const WS: WideString): AnsiString;
function UTF8ToAnsi(const S: UTF8String): AnsiString;

implementation

// ��������ʱ���ʽ�ַ���ת��Ϊ��׼��ʽ
function StandardizeLocalDate(ADatetime: AnsiString): AnsiString;
var
  LDatetime: TDatetime;
begin
  if ADatetime = '' then
    Result := ''
  else
  begin
    LDatetime := StrToDateTime(ADatetime);
    if Floor(LDatetime) = LDatetime then
      Result := FormatDateTime('YYYY-MM-DD', LDatetime)
    else
      Result := FormatDateTime('YYYY-MM-DD hh:mm:ss', LDatetime);
  end;
end;

procedure PlaceFormBelowControl(ATarget: TForm; AControl: TControl);
begin
  // ��λ���嵽һ���ؼ����·�
  with ATarget do
  begin
    if AControl <> nil then
    begin
      Left := AControl.ClientOrigin.X;
      Top := AControl.ClientOrigin.Y + AControl.Height + 8;
      if Left + Width > Screen.WorkAreaWidth then
        Left := Screen.WorkAreaWidth - Width;
      if Top + Height > Screen.WorkAreaHeight then
        Top := Screen.WorkAreaHeight - Height;
      Position := poDesigned;
    end
    else
    begin
      Position := poMainFormCenter;
    end;
  end;
end;

// �����ַ������ü������������ַ���ָ�롣���������DLLz�У��ɸ�Ч�����ַ���
// Save a reference to a AnsiString and return a raw pointer to the AnsiString.
function RefString(const S: AnsiString): Pointer;
var
  Local: AnsiString;
begin
  Local := S; // Increment the reference count.
  Result := Pointer(Local); // Save the AnsiString pointer.
  Pointer(Local) := nil; // Prevent decrementing the ref count.
end;

// Release a AnsiString that was referenced with RefString.
procedure ReleaseString(P: Pointer);
var
  Local: AnsiString;
begin
  Pointer(Local) := P;
  // Delphi frees the AnsiString when Local goes out of scope.
end;

procedure BuildPopupMenu(AOwner: TComponent; APopupMenu: TPopupMenu;
  AActions: TActionList); overload;
var
  ActionArray: array of TAction;
  I: Integer;
begin
  SetLength(ActionArray, AActions.ActionCount);
  for I := Low(ActionArray) to High(ActionArray) do
  begin
    ActionArray[I] := TAction(AActions[I]);
  end;
  BuildPopupMenu(AOwner, APopupMenu, ActionArray);
end;

procedure BuildPopupMenu(AOwner: TComponent; APopupMenu: TPopupMenu;
  AActions: array of TAction);
var
  I: Integer;
  SubMenu: TMenuItem;
begin
  Assert(APopupMenu <> nil);

  for I := Low(AActions) to High(AActions) do
  begin
    SubMenu := TMenuItem.Create(AOwner);
    APopupMenu.Items.Add(SubMenu);
    SubMenu.Action := AActions[I];
  end;
end;

function GetCharCount(const AText: AnsiString): Integer;
begin
  Result := Length(WideString(AText));
end;

{ TStingsת��Ϊ�ַ������� }
function StringListToArray(Source: TStrings): TStringDynArray;
var
  I: Integer;
begin
  SetLength(Result, Source.Count);
  for I := 0 to Source.Count - 1 do
  begin
    Result[I] := Source[I];
  end;
end;

function DelimitedTextToArray(DelimitedText: AnsiString; Delimiter: AnsiChar)
  : TStringDynArray;
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Delimiter := Char(Delimiter);
    SL.DelimitedText := DelimitedText;
    Result := StringListToArray(SL);
  finally
    SL.Free;
  end;
end;
// -----------------------------------------------
// �ַ���ת16�����ַ�
// -----------------------------------------------

function StringToHex(str: AnsiString): AnsiString;
var
  I: Integer;
  S: AnsiString;
begin
  for I := 1 to Length(str) do
  begin
    S := S + InttoHex(Integer(str[I]), 2);
  end;
  Result := S;
end;

// -----------------------------------------------
// 16�����ַ�ת�ַ���
// -----------------------------------------------

function HexToString(str: AnsiString): AnsiString;
var
  S, t: AnsiString;
  I: Integer;
begin
  S := '';
  I := 1;
  while I < Length(str) do
  begin
    t := str[I] + str[I + 1];
    S := S + chr(StrToInt('$' + t));
    I := I + 2;
  end;
  Result := S;
end;

// ����һ��Method, ��ҩ��Codeָ��Ĺ��̵ĵ�һ��������Self: TObject

function MakeMethod(ACode: Pointer): TMethod;
begin
  Result.Data := nil;
  Result.Code := ACode;
end;

{ ��ȡ�ı���� }
var
  FontBitmap: TBitmap;

function GetTextWidth(const AText: AnsiString; AFont: TFont): Integer;
begin
  if FontBitmap = nil then
    FontBitmap := TBitmap.Create;

  FontBitmap.Canvas.Font := AFont;
  Result := FontBitmap.Canvas.TextWidth(AText);
end;

{ ��ȡ�����в��� }

function GetCmdLineParam(const Param: AnsiString): AnsiString;
const
  ParamPrefix: set of AnsiChar = ['-', '/'];
var
  I: Integer;
  S: AnsiString;
begin
  Result := '';
  for I := 1 to ParamCount do
  begin
    S := LowerCase(ParamStr(I));
    if (S[1] in ParamPrefix) and (Pos(LowerCase(Param), S) = 2) then
    begin
      Result := Param; // û�ж�Ӧ��ֵʱ��Ĭ�ϲ������ƣ����������������
      if Length(S) > Length(Param) + 1 then
        Result := Copy(S, Length(Param) + 2, Length(S)) // ��Ϊ��������ֵ��һ��
      else if I < ParamCount then
      begin
        S := ParamStr(I + 1);
        // ��������ǲ�������Ϊ������һ��������ֵ
        if not(S[1] in ParamPrefix) then
          Result := S;
      end;
      Exit;
    end;
  end;
end;

const
  CPI = 2.54; // centimeters per inch

const
  IPC = 0.393700787; // inches per centimeter

  { DPI to DPC }

function Inch2Cm(const Inch: Extended): Extended;
begin
  Result := Inch * CPI;
end;

{ Cm to Inch }

function Cm2Inch(const Cm: Extended): Extended;
begin
  Result := Cm * IPC;
end;

{
  ��ȡJPGͼƬ�ķֱ���, ��λ: Inch

  ֻ�ܴ���JFIF��ʽ��JPG��
}

procedure GetJpgResolution(JPGFile: AnsiString; var HorzRes, VertRes: Word);
const
  BufferSize = 50;
var
  Buffer: AnsiString;
  Index: Integer;
  FileStream: TFileStream;
  DP: Byte;
  Measure: AnsiString;
begin
  FileStream := TFileStream.Create(JPGFile, fmOpenReadWrite);
  try
    SetLength(Buffer, BufferSize);
    FileStream.Read(Buffer[1], BufferSize);
    Index := Pos('JFIF' + #$00, Buffer);
    if Index <> 0 then
    begin
      FileStream.Seek(Index + 6, soFromBeginning);
      FileStream.Read(DP, 1);
      case DP of
        1:
          Measure := 'DPI'; // Dots Per Inch
        2:
          Measure := 'DPC'; // Dots Per Cm.
      end;
      FileStream.Read(HorzRes, 2); // x axis
      HorzRes := Swap(HorzRes);
      FileStream.Read(VertRes, 2); // y axis
      VertRes := Swap(VertRes);
      case DP of
        2:
          begin // convert cm to Inch
            HorzRes := Floor(HorzRes * CPI);
            VertRes := Floor(VertRes * CPI);
          end;
      end;
    end
    else
    begin
      // todo: ����EXIF��ʽ��jpg
      HorzRes := 200;
      VertRes := 200;
    end;
  finally
    FileStream.Free;
  end;
end;

{ ����JPGͼƬ�ķֱ��ʣ���Ӣ��Ϊ��λ }

procedure SetJpgResolution(JPGFile: AnsiString; dpix, dpiy: Word);
const
  BufferSize = 50;
  DPI = 1; // inch
  DPC = 2; // cm
var
  Buffer: AnsiString;
  Index: Integer;
  FileStream: TFileStream;
  xResolution: Word;
  yResolution: Word;
  _type: Byte;
begin
  FileStream := TFileStream.Create(JPGFile, fmOpenReadWrite);
  try
    SetLength(Buffer, BufferSize);
    FileStream.Read(Buffer[1], BufferSize);
    index := Pos('JFIF' + #$00, Buffer);
    if index <> 0 then
    begin
      FileStream.Seek(index + 6, soFromBeginning);
      _type := DPI;
      FileStream.write(_type, 1);
      xResolution := Swap(dpix);
      FileStream.write(xResolution, 2);
      yResolution := Swap(dpiy);
      FileStream.write(yResolution, 2);
    end
  finally
    FileStream.Free;
  end;
end;

function SelectFile(const AFilter: AnsiString;
  var AFileName: AnsiString): Boolean;
begin
  with TOpenDialog.Create(nil) do
  begin
    // InitialDir := GetCurrentDir;
    Options := [ofFileMustExist];
    Filter := AFilter;
    // OpenDialog.FilterIndex := 0;

    Result := Execute;
    if Result then
      AFileName := FileName;
    Free;
  end;
end;

function GetLocalName(): AnsiString;
var
  arr: array [0 .. MAX_COMPUTERNAME_LENGTH] of AnsiChar;
  d: DWORD;
begin
  d := SizeOf(arr);
  Windows.GetComputerNameA(arr, d);
  Result := arr;
end;

function GetLocalIP: AnsiString;
type
  TaPInAddr = array [0 .. 10] of PInAddr; // ���ڴ洢���ip��ַ�б�
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0 .. 63] of AnsiChar; // store hostname
  I: Integer;
  GInitData: TWSADATA;
  wVersion: Word;
begin
  wVersion := MAKEWORD(1, 1); // winsock dll version
  Result := '';
  if WSAStartup(wVersion, GInitData) = 0 then // ��ʼ��windows socket
  begin
    if GetHostName(Buffer, SizeOf(Buffer)) = 0 then // ���������
      phe := GetHostByName(Buffer);
    if phe = nil then
      Exit;
    pptr := PaPInAddr(phe^.h_addr_list);
    I := 0;
    while pptr^[I] <> nil do
    begin
      Result := StrPas(inet_ntoa(pptr^[I]^));
      Inc(I);
    end;
    WSACleanup; // �رա�����windows socket
  end;
end;

// MAC��ַ

function GetNetBIOSAddress: AnsiString;
var
  ncb: TNCB;
  status: TAdapterStatus;
  lanenum: TLanaEnum;
  procedure ResetAdapter(Num: AnsiChar);
  begin
    fillchar(ncb, SizeOf(ncb), 0);
    ncb.ncb_command := AnsiChar(NCBRESET);
    ncb.ncb_lana_num := AnsiChar(Num);
    Netbios(@ncb);
  end;

var
  I: Integer;
  lanNum: AnsiChar;
  address: record part1: Longint;
  part2: Word;
end
absolute status;
begin
  Result := '';
  fillchar(ncb, SizeOf(ncb), 0);
  ncb.ncb_command := AnsiChar(NCBENUM);
  ncb.ncb_buffer := @lanenum;
  ncb.ncb_length := SizeOf(lanenum);
  Netbios(@ncb);
  if lanenum.Length = #0 then
    Exit;
  lanNum := lanenum.lana[0];
  ResetAdapter(lanNum);
  fillchar(ncb, SizeOf(ncb), 0);
  ncb.ncb_command := AnsiChar(NCBASTAT);
  ncb.ncb_lana_num := lanNum;
  ncb.ncb_callname[0] := '*';
  ncb.ncb_buffer := @status;
  ncb.ncb_length := SizeOf(status);
  Netbios(@ncb);
  ResetAdapter(lanNum);
  for I := 0 to 5 do
  begin
    Result := Result + InttoHex(Integer(status.adapter_address[I]), 2);
    if (I < 5) then
      Result := Result + '-';
  end;
end;

procedure EnumDataSet(ADataSet: TDataSet; AEnumProc: TDataSetEnumProc;
  AParam: variant);
var
  bk: TBookmark;
begin
  Assert(ADataSet <> nil);
  Assert(Assigned(AEnumProc));

  with ADataSet do
    try
      DisableControls;
      bk := GetBookmark;
      First;
      while not Eof do
      begin
        AEnumProc(ADataSet, AParam);
        Next;
      end;
      GotoBookmark(bk);
    finally
      FreeBookmark(bk);
      EnableControls;
    end;
end;
{$I SpellTable.inc}

function IsDouByte(C: AnsiChar): Boolean;
begin
  Result := C >= #129;
end;

function GetPyOfHz(HzChar: PAnsiChar): AnsiString;
var
  C: AnsiChar;
  Index: Integer;
begin
  if (IsDouByte(HzChar[0])) and (HzChar[0] >= #129) and (HzChar[1] >= #64) then
  begin
    // �Ƿ�Ϊ GBK �ַ�
    case HzChar[0] of
      #163: // ȫ�� ASCII
        begin
          C := AnsiChar(Ord(HzChar[1]) - 128);
          if C in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '(', ')', '[', ']'] then
            Result := C;
        end;
      #162: // ��������
        begin
          if HzChar[1] > #160 then
            Result := CharIndex[Ord(HzChar[1]) - 160];
        end;
      #166: // ϣ����ĸ
        begin
          if HzChar[1] in [#$A1 .. #$B8] then
            Result := CharIndex2[Ord(HzChar[1]) - $A0]
          else if HzChar[1] in [#$C1 .. #$D8] then
            Result := CharIndex2[Ord(HzChar[1]) - $C0];
        end;
    else
      begin // ���ƴ������
        Index := SpellIndex[Ord(HzChar[0]) - 128, Ord(HzChar[1]) - 63];
        if Index <> 0 then
          Result := SpellTable[Index];
      end;
    end;
  end
  else
  begin
    // �� GBK �ַ�����, ������ַ�
    if HzChar[0] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '(', ')', '[', ']',
      '.', '!', '@', '#', '$', '%', '^', '&', '*', '-', '+', '<', '>', '?', ':',
      '"', '`', '~', '|', '\', '/'] then
      Result := HzChar[0];
  end;
end;

function GetPyOfHzs(HzChars, Seperator: AnsiString): AnsiString;
var
  I, len: Integer;
  Py: AnsiString;
begin
  Result := '';
  I := 0;
  while I < Length(HzChars) do
  begin
    if IsDouByte(HzChars[I]) then
      len := 2
    else
      len := 1;
    Py := GetPyOfHz(@HzChars[I]);
    Inc(I, len);
    if Result = '' then
      Result := Py
    else if (Py <> '') then
      Result := Result + Seperator + Py;
  end;
end;

function GetPyHeadOfHz(HzChar: PAnsiChar): AnsiString;
begin
  Result := Copy(GetPyOfHz(HzChar), 1, 1);
end;

function GetPyHeadOfHzs(HzChars: AnsiString): AnsiString;
var
  I, len: Integer;
begin
  Result := '';
  I := 1;
  while I <= Length(HzChars) do
  begin
    if IsDouByte(HzChars[I]) then
      len := 2
    else
      len := 1;
    Result := Result + GetPyHeadOfHz(@HzChars[I]);
    Inc(I, len);
  end;
end;

// ʹ��Shell APIɾ������Ŀ¼��Windows APIֻ��ɾ����Ŀ¼

function DelDirectory(const Source: AnsiString): Integer;
var
  fo: TSHFILEOPSTRUCTA;
begin
  fillchar(fo, SizeOf(fo), 0);
  with fo do
  begin
    Wnd := 0;
    wFunc := FO_DELETE;
    pFrom := PAnsiChar(Source + #0); // why need two null AnsiChar
    pTo := #0#0;
    fFlags := FOF_NOCONFIRMATION + FOF_SILENT;
  end;
  Result := SHFileOperationA(fo);
end;

procedure ClonePersistent(Source, Dest: TPersistent);
var
  PropCount, I: Integer;
  Props: PPropList;
  PropInfo: PPropInfo;
  Obj1, Obj2: TObject;
begin
  PropCount := GetPropList(Source, Props);
  try
    for I := 0 to PropCount - 1 do
    begin
      PropInfo := Props[I];
      case PropInfo.PropType^.Kind of
        tkInteger, tkChar, tkEnumeration, tkSet, tkWChar:
          SetOrdProp(Dest, PropInfo.Name, GetOrdProp(Source, PropInfo));
        tkFloat:
          SetFloatProp(Dest, PropInfo.Name, GetFloatProp(Source, PropInfo));
        tkString, tkLString:
          SetStrProp(Dest, PropInfo.Name, GetStrProp(Source, PropInfo));
        tkWString:
          SetWideStrProp(Dest, PropInfo.Name, GetWideStrProp(Source, PropInfo));
        tkInt64:
          SetInt64Prop(Dest, PropInfo.Name, GetInt64Prop(Source, PropInfo));
        tkVariant:
          SetVariantProp(Dest, PropInfo.Name, GetVariantProp(Source, PropInfo));
        tkClass:
          begin
            Obj1 := GetObjectProp(Source, PropInfo);
            Obj2 := GetObjectProp(Dest, PropInfo);
            if (Obj1 <> nil) and (Obj2 <> nil) and Obj1.InheritsFrom(TPersistent)
            then
              ClonePersistent(TPersistent(Obj1), TPersistent(Obj2));
          end;
      else
        // don't handle tkArray, tkRecord, tkDynArray
      end;
    end;
  finally
    FreeMem(Props);
  end;
end;

procedure ReadFromIni(Self: TPersistent; IniFile: TIniFile;
  const Section: AnsiString);
var
  PropCount, I: Integer;
  Props: PPropList;
  PropInfo: PPropInfo;
  Obj: TObject;
begin
  with IniFile do
  begin
    PropCount := GetPropList(Self, Props);
    try
      for I := 0 to PropCount - 1 do
      begin
        PropInfo := Props[I];
        case PropInfo.PropType^.Kind of
          tkInteger, tkChar, tkEnumeration, tkSet, tkWChar:
            SetOrdProp(Self, PropInfo.Name, ReadInteger(Section, PropInfo.Name,
              GetOrdProp(Self, PropInfo)));
          tkFloat:
            SetFloatProp(Self, PropInfo.Name, ReadFloat(Section, PropInfo.Name,
              GetFloatProp(Self, PropInfo)));
          tkString, tkLString:
            SetStrProp(Self, PropInfo.Name, ReadString(Section, PropInfo.Name,
              GetStrProp(Self, PropInfo)));
          tkWString:
            SetWideStrProp(Self, PropInfo.Name,
              ReadString(Section, PropInfo.Name, GetWideStrProp(Self,
              PropInfo)));
          tkInt64:
            SetInt64Prop(Self, PropInfo.Name,
              ReadInteger(Section, PropInfo.Name, GetInt64Prop(Self,
              PropInfo)));
          tkVariant:
            SetVariantProp(Self, PropInfo.Name,
              ReadString(Section, PropInfo.Name, GetVariantProp(Self,
              PropInfo)));
          tkClass:
            begin
              Obj := GetObjectProp(Self, PropInfo);
              if Obj.InheritsFrom(TPersistent) then
                ReadFromIni(TPersistent(Obj), IniFile,
                  Section + '.' + PropInfo.Name);
            end;
        else
          // don't handle tkArray, tkRecord, tkDynArray
        end;
      end;
    finally
      FreeMem(Props);
    end;
  end;
end;

procedure WriteToIni(Self: TPersistent; IniFile: TIniFile;
  const Section: AnsiString);
var
  PropCount, I: Integer;
  Props: PPropList;
  PropInfo: PPropInfo;
  Obj: TObject;
begin
  with IniFile do
  begin
    PropCount := GetPropList(Self, Props);
    try
      for I := 0 to PropCount - 1 do
      begin
        PropInfo := Props[I];
        case PropInfo.PropType^.Kind of
          tkInteger, tkChar, tkEnumeration, tkSet, tkWChar:
            WriteInteger(Section, PropInfo.Name, GetOrdProp(Self, PropInfo));
          tkFloat:
            WriteFloat(Section, PropInfo.Name, GetFloatProp(Self, PropInfo));
          tkString, tkLString:
            WriteString(Section, PropInfo.Name, GetStrProp(Self, PropInfo));
          tkWString:
            WriteString(Section, PropInfo.Name, GetWideStrProp(Self, PropInfo));
          tkInt64:
            WriteInteger(Section, PropInfo.Name, GetInt64Prop(Self, PropInfo));
          // ???
          tkVariant:
            WriteString(Section, PropInfo.Name, GetVariantProp(Self, PropInfo));
          tkClass:
            begin
              Obj := GetObjectProp(Self, PropInfo);
              if Obj.InheritsFrom(TPersistent) then
                WriteToIni(TPersistent(Obj), IniFile,
                  Section + '.' + PropInfo.Name);
            end;
        else
          // don't handle tkArray, tkRecord, tkDynArray
        end;
      end;
    finally
      FreeMem(Props);
    end;
  end;
end;

function DamerauLevenshteinDistance(const Str1, Str2: AnsiString): Integer;
var
  LenStr1, LenStr2: Integer;
  I, J, t, Cost, Minimum: Integer;
  pStr1, pStr2, S1, S2: PAnsiChar;
  d, RowPrv2, RowPrv1, RowCur, Temp: PIntegerArray;
begin
  LenStr1 := Length(Str1);
  LenStr2 := Length(Str2);
  // to save some space, make sure the second index points to the shorter AnsiString
  if LenStr1 < LenStr2 then
  begin
    t := LenStr1;
    LenStr1 := LenStr2;
    LenStr2 := t;
    pStr1 := PAnsiChar(Str2);
    pStr2 := PAnsiChar(Str1);
  end
  else
  begin
    pStr1 := PAnsiChar(Str1);
    pStr2 := PAnsiChar(Str2);
  end;
  // to save some time and space, look for exact match
  while (LenStr2 <> 0) and (pStr1^ = pStr2^) do
  begin
    Inc(pStr1);
    Inc(pStr2);
    Dec(LenStr1);
    Dec(LenStr2);
  end;
  // when one AnsiString is empty, length of the other is the distance
  if LenStr2 = 0 then
  begin
    Result := LenStr1;
    Exit;
  end;
  // calculate the edit distance
  t := LenStr2 + 1;
  GetMem(d, 3 * t * SizeOf(Integer));
  fillchar(d^, 2 * t * SizeOf(Integer), 0);
  RowCur := d;
  RowPrv1 := @d[t];
  RowPrv2 := @d[2 * t];
  S1 := pStr1;
  for I := 1 to LenStr1 do
  begin
    Temp := RowPrv2;
    RowPrv2 := RowPrv1;
    RowPrv1 := RowCur;
    RowCur := Temp;
    RowCur[0] := I;
    S2 := pStr2;
    for J := 1 to LenStr2 do
    begin
      Cost := Ord(S1^ <> S2^);
      Minimum := RowPrv1[J - 1] + Cost; // substitution
      t := RowCur[J - 1] + 1; // insertion
      if t < Minimum then
        Minimum := t;
      t := RowPrv1[J] + 1; // deletion
      if t < Minimum then
        Minimum := t;
      if (I <> 1) and (J <> 1) and (S1^ = (S2 - 1)^) and (S2^ = (S1 - 1)^) then
      begin
        t := RowPrv2[J - 2] + Cost; // transposition
        if t < Minimum then
          Minimum := t;
      end;
      RowCur[J] := Minimum;
      Inc(S2);
    end;
    Inc(S1);
  end;
  Result := RowCur[LenStr2];
  FreeMem(d);
end;

function StringSimilarityRatio(const Str1, Str2: AnsiString;
  IgnoreCase: Boolean): Double;
var
  MaxLen: Integer;
  Distance: Integer;
begin
  Result := 1.0;
  if Length(Str1) > Length(Str2) then
    MaxLen := Length(Str1)
  else
    MaxLen := Length(Str2);
  if MaxLen <> 0 then
  begin
    if IgnoreCase then
      Distance := DamerauLevenshteinDistance(LowerCase(Str1), LowerCase(Str2))
    else
      Distance := DamerauLevenshteinDistance(Str1, Str2);
    Result := Result - (Distance / MaxLen);
  end;
end;

const
  // ÿ��ƴ����ĸ��Ӧ�ĵ�һ������(23��)��Win7������
  FirstHZ: WideString = '򈲾�e�z���v�B���h�i�w����a�؇��U�R�X�F�R퍅�';
  // ����ƴ���õ�������ĸ(23��)
  Py: AnsiString = 'ABCDEFGHJKLMNOPQRSTWXYZ';

  // ��Win7�ϲ���δͨ��

function AnsiCompareStrByPhonetic(const S1, S2: AnsiString): Integer;
begin
  Result := CompareStringA(LOCALE_USER_DEFAULT, 0, PAnsiChar(S1), Length(S1),
    PAnsiChar(S2), Length(S2)) - 2
end;

function FindPYIndex(AChar: WideChar): AnsiString;
var
  Index: Integer;
begin
  for Index := 1 to Length(FirstHZ) do
  begin
    if AnsiCompareStrByPhonetic(AChar, FirstHZ[Index]) <= 0 then
    begin
      Result := Py[Index];
      Exit;
    end;
  end;
  Result := AChar;
end;

function GetPY(AStr: WideString): AnsiString;
var
  Index: Integer;
  str: WideChar;
begin
  Result := '';
  for Index := 1 to Length(AStr) do
  begin
    str := AStr[Index];
    if (Ord(str) >= 19968) and (Ord(str) <= 19968 + 20901) then
      Result := Result + FindPYIndex(str)
    else
      Result := Result + str;
  end;
end;

function GetTempFile(APrefix: AnsiString): AnsiString; overload;
var
  Path: AnsiString;
begin
  SetLength(Path, Max_Path);
  SetLength(Result, Max_Path);
  GetTempPath(Max_Path, @Path[1]);
  SetLength(Result, GetTempFileNameA(@Path[1], PAnsiChar(APrefix), 0,
    @Result[1]));
end;

function GetTempFile(ATempPath, APrefix: AnsiString): AnsiString; overload;
begin
  SetLength(Result, Max_Path);
  SetLength(Result, GetTempFileNameA(@ATempPath[1], PAnsiChar(APrefix), 0,
    @Result[1]));
end;

function GetTempDirectory(): AnsiString;
begin
  SetLength(Result, Max_Path);
  SetLength(Result, GetTempPath(Max_Path, @Result[1]));
end;

procedure Compress(Source, Dest: TStream; BlockSize: Integer;
  OnProgress: TOnProgress = nil);
var
  cs: TCompressionStream;
  Buffer: Pointer;
  L, Max, Position: Integer;
  Canceled: Boolean;
begin
  GetMem(Buffer, BlockSize);
  try
    L := Source.Size;
    // ��¼�ļ���С�Ϳ��С
    Dest.WriteBuffer(L, SizeOf(Integer));
    Dest.WriteBuffer(BlockSize, SizeOf(Integer));

    Max := (L + BlockSize - 1) div BlockSize;
    Position := 0;
    cs := TCompressionStream.Create(clMax, Dest);
    Canceled := False;
    try
      while not Canceled and (Position < Max) do
      begin
        if Position < Max - 1 then
          L := BlockSize
        else
          L := Source.Size - Source.Position;
        Source.ReadBuffer(Buffer^, L);
        cs.write(Buffer^, L);
        Inc(Position);
        if Assigned(OnProgress) then
          OnProgress(Max, Position, Canceled);
      end
    finally
      cs.Free;
    end;
  finally
    FreeMem(Buffer);
  end;
end;

procedure Decompress(Source, Dest: TStream; OnProgress: TOnProgress = nil);
var
  dcs: TDeCompressionStream;
  Buffer: Pointer;
  FileSize, BlockSize, L, Max, Position: Integer;
  Canceled: Boolean;
begin
  Source.Read(FileSize, SizeOf(Integer));
  Source.Read(BlockSize, SizeOf(Integer));
  Max := (FileSize + BlockSize - 1) div BlockSize;
  Position := 0;
  GetMem(Buffer, BlockSize);
  dcs := TDeCompressionStream.Create(Source);
  try
    Canceled := False;
    while (not Canceled) and (Position < Max) do
    begin
      if Position < Max - 1 then
        L := BlockSize
      else
        L := FileSize mod BlockSize;
      dcs.Read(Buffer^, L);
      Dest.write(Buffer^, L);
      Inc(Position);
      if Assigned(OnProgress) then
        OnProgress(Max, Position, Canceled);
    end;
  finally
    dcs.Free;
    FreeMem(Buffer);
  end;
end;

function GetDialogParentHandler(): HWND;
begin
  // ������Ƿ���ģʽ״̬��
  if (Screen.ActiveCustomForm <> nil) and
    (fsModal in Screen.ActiveCustomForm.FormState) then
    Result := Screen.ActiveCustomForm.Handle
  else
    Result := Application.Handle
end;

procedure ShowError(Msg: string);
begin
  Application.MessageBox(PChar(Msg), '����', MB_OK + MB_ICONERROR);
end;

procedure ShowOK(Msg: string);
begin
  Application.MessageBox(PChar(Msg), '��Ϣ', MB_OK + MB_ICONINFORMATION);
end;

procedure ShowHelp(Content: string);
begin
  Application.MessageBox(PChar(Content), '����', MB_OK + MB_ICONINFORMATION);
end;

procedure ShowAbout(Content: string);
begin
  Application.MessageBox(PChar(Content), '����', MB_OK + MB_ICONINFORMATION);
end;

procedure ShowWarning(Msg: string);
begin
  Application.MessageBox(PChar(Msg), '����', MB_OK + MB_ICONWARNING);
end;

function ShowYesNo(Msg: string; YesOrNo: Boolean = True): Boolean;
var
  Flag: Cardinal;
begin
  if YesOrNo then
    Flag := MB_YESNO + MB_ICONQUESTION
  else
    Flag := MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2;
  Result := Application.MessageBox(PChar(Msg), 'ѯ��', Flag) = ID_YES;
end;

function ShowYesNoCancel(Msg: string): Integer;
begin
  Result := Application.MessageBox(PChar(Msg), 'ѯ��',
    MB_YESNOCANCEL + MB_ICONQUESTION);
end;

// ��ʾ����Ի���

function ShowSave(ATitle, AFilter: string; var AFileName: string;
  ADefaultExt: string): Boolean;
begin
  with TSaveDialog.Create(nil) do
  begin
    Title := ATitle;
    Filter := AFilter;
    if AFilter = '' then
      Filter := '*.*|*.*';
    DefaultExt := ADefaultExt;
    FileName := AFileName;
    Options := Options + [ofOverwritePrompt];
    Result := Execute;
    if Result then
      AFileName := FileName;
    Free;
  end;
end;

// ��ʾ�򿪶Ի���

function ShowOpen(ATitle, AFilter: string; var AFileName: string): Boolean;
begin
  with TOpenDialog.Create(nil) do
  begin
    Title := ATitle;
    Filter := AFilter;
    FileName := AFileName;
    Result := Execute;
    if Result then
      AFileName := FileName;
    Free;
  end;
end;

var
  // ��ֹ��������εĻ�������
  AppMutexHandle: THandle;

function AlreadyRunning(): Boolean;
begin
  Result := False;
  AppMutexHandle := CreateMutex(nil, True, PChar(Application.Title));
  if AppMutexHandle <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(AppMutexHandle);
      // ShowWarning('�����Ѿ�����.');
      Result := True;
    end;
  end;
end;

procedure AllowProgramTwiceOpen();
begin
  if AppMutexHandle <> 0 then
    CloseHandle(AppMutexHandle);
end;

function StrToXML(const S: AnsiString): AnsiString;
const
  SpecChars = ['<', '>', '"', '&', #10, #13];
var
  I: Integer;

  procedure ReplaceChars(var S: AnsiString; I: Integer);
  begin
    Insert('#' + IntToStr(Ord(S[I])) + ';', S, I + 1);
    S[I] := '&';
  end;

begin
  Result := S;
  for I := Length(S) downto 1 do
    if S[I] in SpecChars then
      ReplaceChars(Result, I);
end;

procedure GetComponents(Owner: TComponent; ClassRef: TClass; List: TStrings;
  Skip: TComponent);
var
  I: Integer;

  procedure EnumComponents(f: TComponent);
  var
    I: Integer;
    C: TComponent;
  begin
    for I := 0 to f.ComponentCount - 1 do
    begin
      C := f.Components[I];
      if (C <> Skip) and (C is ClassRef) then
        // �������п�֪������������
        if f = Owner then
          List.AddObject(C.Name, C)
        else if ((f is TForm) or (f is TDataModule)) then
          List.AddObject(f.Name + '.' + C.Name, C)
        else
          // f��TFrameʱ����������
          List.AddObject(TControl(f).Parent.Name + '.' + f.Name + '.' +
            C.Name, C);
      if (C is TFrame) then
        EnumComponents(C);
    end;
  end;

begin
  List.Clear;
  for I := 0 to Screen.FormCount - 1 do
    EnumComponents(Screen.Forms[I]);
  for I := 0 to Screen.DataModuleCount - 1 do
    EnumComponents(Screen.DataModules[I]);
end;

function CreateLabel(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect): TLabel;
begin
  Result := TLabel.Create(AOwner);
  with Result do
  begin
    AutoSize := False;
    Parent := AParent;
    Caption := ATitle;
    BoundsRect := ABounds;
    WordWrap := True;
    // Layout := tlCenter;
  end;
end;

function CreateControl(AOwner: TComponent; AParent: TWinControl;
  AClass: TControlClass; ABounds: TRect): TControl;
begin
  Result := AClass.Create(AOwner);
  with Result do
  begin
    Parent := AParent;
    BoundsRect := ABounds;
  end;
end;

function CreateForm(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect; ABorderStyle: TBorderStyle): TForm;
begin
  Result := TForm.Create(AOwner);
  with Result do
  begin
    Parent := AParent;
    Caption := ATitle;
    BoundsRect := ABounds;
    BorderStyle := ABorderStyle;
    Position := poMainFormCenter;
  end;
end;

function CreateEdit(AOwner: TComponent; AParent: TWinControl;
  ABounds: TRect): TEdit;
begin
  Result := CreateControl(AOwner, AParent, TEdit, ABounds) as TEdit;
end;

function CreateButton(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect): TButton;
begin
  Result := CreateControl(AOwner, AParent, TButton, ABounds) as TButton;
  Result.Caption := ATitle;
end;

function CreateGroupBox(AOwner: TComponent; AParent: TWinControl;
  const ATitle: AnsiString; ABounds: TRect): TGroupBox;
begin
  Result := CreateControl(AOwner, AParent, TGroupBox, ABounds) as TGroupBox;
  Result.Caption := ATitle;
end;

const
  CHNum: array [0 .. 9] of AnsiString = ('��', 'Ҽ', '��', '��', '��', '��', '½', '��',
    '��', '��');
  UnitChar: array [1 .. 14] of AnsiString = ('��', '��', 'Ԫ', 'ʰ', '��', 'Ǫ', '��',
    'ʰ', '��', 'Ǫ', '��', 'ʰ', '��', 'Ǫ');

function UpperCHNum(Num: Integer): AnsiString;
begin
  Result := CHNum[Num mod 10]
end;

function RMB(Num: Currency): AnsiString;
var
  Index: Integer;
  NumStr: AnsiString;
  Digit: AnsiString;
  MinusFlag: Boolean;
begin
  Result := '';
  MinusFlag := Num < 0;
  if MinusFlag then
    Num := -Num;

  NumStr := Format('%0.2f', [Num]);
  NumStr := StringReplace(NumStr, '.', '', []);
  NumStr := ReverseString(NumStr);
  for Index := 1 to Length(NumStr) do
  begin
    Digit := UpperCHNum(StrToInt(NumStr[Index])) + UnitChar[Index];
    Result := Digit + Result;
  end;

  Result := StringReplace(Result, '��ʰ', '��', [rfReplaceAll]);
  Result := StringReplace(Result, '���', '��', [rfReplaceAll]);
  Result := StringReplace(Result, '��Ǫ', '��', [rfReplaceAll]);

  for Index := 0 to 20 do
    Result := StringReplace(Result, '����', '��', [rfReplaceAll]);

  Result := StringReplace(Result, '����', '��', [rfReplaceAll]);
  Result := StringReplace(Result, '����', '��', [rfReplaceAll]);
  Result := StringReplace(Result, '��Ԫ', 'Ԫ', [rfReplaceAll]);
  Result := StringReplace(Result, '����', '��', [rfReplaceAll]);
  Result := StringReplace(Result, '������', '��', [rfReplaceAll]);
  Result := StringReplace(Result, '���', '', [rfReplaceAll]);
  Result := StringReplace(Result, '���', '��', [rfReplaceAll]);

  if MinusFlag then
    Result := '��' + Result;
end;

function AnsiToWide(const S: AnsiString): WideString;
var
  len: Integer;
  WS: WideString;
begin
  Result := '';
  if (Length(S) = 0) then
    Exit;
  len := MultiByteToWideChar(CP_ACP, 0, PAnsiChar(S), -1, nil, 0);
  SetLength(WS, len - 1); // ���ؽ���Ѱ���'\0'��Ҫռ�õĿռ䣬�ʺ�C����dephi������-1
  MultiByteToWideChar(CP_ACP, 0, PAnsiChar(S), -1, PWideChar(WS), len);
  Result := WS;
end;

function WideToUTF8(const WS: WideString): UTF8String;
var
  len: Integer;
  US: UTF8String;
begin
  Result := '';
  if (Length(WS) = 0) then
    Exit;
  len := WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(US, len - 1);
  WideCharToMultiByte(CP_UTF8, 0, PWideChar(WS), -1, PAnsiChar(US), len,
    nil, nil);
  Result := US;
end;

function AnsiToUTF8(const S: AnsiString): UTF8String;
begin
  Result := WideToUTF8(AnsiToWide(S));
end;

function UTF8ToWide(const US: UTF8String): WideString;
var
  len: Integer;
  WS: WideString;
begin
  Result := '';
  if (Length(US) = 0) then
    Exit;
  len := MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(US), -1, nil, 0);
  SetLength(WS, len - 1);
  MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(US), -1, PWideChar(WS), len);
  Result := WS;
end;

function WideToAnsi(const WS: WideString): AnsiString;
var
  len: Integer;
  S: AnsiString;
begin
  Result := '';
  if (Length(WS) = 0) then
    Exit;
  len := WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, nil, 0, nil, nil);
  SetLength(S, len - 1);
  WideCharToMultiByte(CP_ACP, 0, PWideChar(WS), -1, PAnsiChar(S), len,
    nil, nil);
  Result := S;
end;

function UTF8ToAnsi(const S: UTF8String): AnsiString;
begin
  Result := WideToAnsi(UTF8ToWide(S));
end;

initialization

finalization

FreeAndNil(FontBitmap);

end.
