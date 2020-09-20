unit FileService_ServerBackend;

{
  �ļ��������˿�
  ��ΰ�� (remobjects@qq.com)
  v1.0 2013-1-5 

  1 �������ļ���FileService���¶����߼�Ŀ¼�Ͷ�Ӧ����Ŀ¼
  2 ��������Ҳ��ͨ��RegisterLogicalName������Ŀ¼

  todo: trigger event
}

interface

uses Classes,
  SysUtils,
  StrUtils,
  App_Common,
  App_Function,
  uROClasses,
  ShellAPI,
  SyncObjs,
  DateUtils,
  uROXMLIntf,
  uROClientIntf,
  uROTypes,
  uROServer,
  uROServerIntf,
  uROSessions,
  {Required:} uRORemoteDataModule,
  FileServiceLib_Intf;

const
  // file operation string
  sfoFileNotExists = '%s�ļ�������';
  sfoFolderNotExists = '%sĿ¼������';
  sfoFileRenameError = '%s�ļ�������ʧ��';
  sfoFolderRenameError = '%sĿ¼������ʧ��';
  sfoFileRemoveError = '%sɾ��ʧ��';
  sfoFileMoveError = '%s�ļ��ƶ�ʧ��';
  sfoLogicalIsEmpty = '[�ļ�����]û��ָ���߼�����';
  sfoLogicalNotExists = '[�ļ�����]�Ҳ����߼�����';
  sfoFileDeleteError = '%s�ļ�ɾ��ʧ�ܣ�����%d';
  sfoFolderDelteError = '%sĿ¼ɾ��ʧ��';
  sfoDownloadNotMatch = '%s�ļ����ش�С��ƥ��';
  sfoDownloadBlockEqualZero = '�����ļ������0';
  sfoUploadConflict = '�ϴ��ļ���ͻ';
  sfoUploadNoMatch = '�ϴ����ļ���С����λ�á��������ϴβ�ƥ��';

  // �ϴ��ļ�ʧЧʱ��10��
  ifoCleanTimeout = 10000;
  ifoMaxFileSize = $10000000;

type
  TUploadingFile = class;

  TFileServiceManager = class
  private
    FLogicalList: TStrings;
    // �ļ��ϴ�����ֶ�
    FUploadFiles: TStrings;
    FCritical: TCriticalSection;
    FCleanTimer: TROThreadTimer;
    // �ļ��ϴ���غ���
    procedure CleanUploadFiles();
    function GetUploadingFile(ID: string): TUploadingFile;
    procedure RemoveUploadFile(ID: string);
    function AddUploadingFile(const ClientID, LogicalName: string; FileSize: Integer): TUploadingFile;
    procedure CleanTimerEvent(CurrentTickCount: cardinal);

    function GetFileMD5(const PhysicalName: string): string;
    procedure CheckExists(const PhysicalName: string);
  public
    constructor Create();
    destructor Destroy(); override;

    procedure RegisterLogicalName(const LogicalName, PhysicalPath: string);
    function LogicalToPhysical(const LogicalName: string): string;

    function FindPath(Sender: TRORemoteDataModule; const Path: AnsiString): FileArray;
    function FileAttr(Sender: TRORemoteDataModule; const FileName: AnsiString): FileInfo;
    function UploadFile(Sender: TRORemoteDataModule; const FileName: AnsiString; const FileSize, StartPos: Integer; const Block: Binary): Integer;
    function DownloadFile(Sender: TRORemoteDataModule; const FileName: AnsiString; const StartPos: Integer; const BlockSize: Integer): Binary;
    function RenameFile(Sender: TRORemoteDataModule; const OldName: AnsiString; const NewName: AnsiString): Integer;
    function RemoveFile(Sender: TRORemoteDataModule; const FileName: AnsiString): Integer;
    function ServiceValue(Sender: TRORemoteDataModule; const ValueName: AnsiString): Variant;
  end;

  // �����ϴ����ļ�����, �������ʱĿ¼��
  TUploadingFile = class
  private
    FClientID: string;
    FLogicalName: string;
    FPhysicalName: string;
    FTempFileName: string;
    FTempFileStream: TFileStream;
    FFileSize: Integer;
    FLastTime: TDateTime;
  public
    constructor Create(const AClientID, ALogicalName, APhysicalName: string; AFileSize: Integer);
    destructor Destroy(); override;
  end;

var
  FileServiceManager: TFileServiceManager;

implementation

uses Windows;

{ TFileServiceManager }

procedure TFileServiceManager.CheckExists(const PhysicalName: string);
begin
  Check(not FileExists(PhysicalName), sfoFileNotExists, [PhysicalName]);
end;

constructor TFileServiceManager.Create;
begin
  // �߼����б�
  FLogicalList := TStringList.Create;
  // �����ϴ����ļ��б�
  FUploadFiles := TStringList.Create;
  FCritical := TCriticalSection.Create;
  // ��ʱ�������ʧЧ���ϴ��ļ�
  FCleanTimer := TROThreadTimer.Create(CleanTimerEvent, ifoCleanTimeout div 4);
  // ��ȡ�߼����б�
  AppCore.IniFile.ReadSectionValues('FileService', FLogicalList);
end;

destructor TFileServiceManager.Destroy;
begin
  FreeAndNil(FCleanTimer);
  FreeAndNil(FLogicalList);
  CleanUploadFiles();
  FreeAndNil(FUploadFiles);
  FreeAndNil(FCritical);
end;

// �����ļ�

function TFileServiceManager.DownloadFile(Sender: TRORemoteDataModule;
  const FileName: AnsiString; const StartPos, BlockSize: Integer): Binary;
var
  FileSize: Int64;
  MemStream: TFileStream;
  Physical: string;
begin
  Physical := LogicalToPhysical(FileName);
  CheckExists(Physical);

  MemStream := TFileStream.Create(Physical, fmShareDenyWrite); // fmOpenRead;
  Result := Binary.Create;
  try
    FileSize := MemStream.Size;
    // ������
    Check(BlockSize <= 0, sfoDownloadBlockEqualZero);
    Check(StartPos >= FileSize, sfoDownloadNotMatch);

    MemStream.Position := StartPos;
    if StartPos + BlockSize > FileSize then
      Result.CopyFrom(MemStream, FileSize - StartPos)
    else
      Result.CopyFrom(MemStream, BlockSize);
  finally
    MemStream.Free;
  end;
end;

// ��ȡ�ļ�����

function TFileServiceManager.FileAttr(Sender: TRORemoteDataModule;
  const FileName: AnsiString): FileInfo;
var
  Physical: string;
  SR: TSearchRec;
begin
  Physical := LogicalToPhysical(FileName);
  CheckExists(Physical);

  Result := FileInfo.Create;
  if FindFirst(Physical, faArchive, SR) = 0 then
  begin
    Result.Name := SR.Name;
    Result.Size := SR.Size;
    Result.Time := SR.Time;
    Result.Attr := SR.Attr;
  end;
  SysUtils.FindClose(SR);
end;

// ����Ŀ¼���о�Ŀ¼�µ������ļ���Ŀ¼, ��������Ŀ¼

function TFileServiceManager.FindPath(Sender: TRORemoteDataModule;
  const Path: AnsiString): FileArray;
var
  I: Integer;
  SR: TSearchRec;
  Physical: string;
begin
  Result := FileArray.Create;
  if Path = '' then
  begin
    // ���ûָ���κ����ƣ������߼��б�
    for I := 0 to FLogicalList.Count - 1 do
    begin
      with Result.Add do
      begin
        Name := FLogicalList.Names[I];
        Size := 0;
        Attr := faDirectory;
        Time := DateTimeToFileDate(Now());
        MD5 := '';
      end;
    end;
  end
  else
  begin
    Physical := LogicalToPhysical(Path);
    Check(not DirectoryExists(Physical), sfoFolderNotExists, [Path]);

    // ��ʼ����
    if FindFirst(Physical + '\*.*', faDirectory or faArchive, SR) = 0 then
    try
      repeat
        if SR.Name = '.' then Continue;
        if SR.Name = '..' then Continue;

        with Result.Add do
        begin
          Name := SR.Name;
          Size := SR.Size;
          Time := SR.Time;
          Attr := SR.Attr;
          if ((Attr and faDirectory) <> 0) then
            MD5 := GetFileMD5(Physical + '\' + SR.Name)
          else
            MD5 := '';
        end;
      until FindNext(SR) <> 0;
    finally
      SysUtils.FindClose(SR);
    end;
  end;
end;

// ��ȡ�ļ���MD5ֵ, �����жϿͻ��˺ͷ������ϵ��ļ��Ƿ�һ��
// ����һ���жϷ�ʽ�����ļ��޸�ʱ�ʹ�С

function TFileServiceManager.GetFileMD5(const PhysicalName: string): string;
begin
  // todo:
  Result := '';
end;

// ת���߼�����������
// �߼�����ʽ��logicalname\dir1\dir2\filename.ext

function TFileServiceManager.LogicalToPhysical(const LogicalName: string): string;
var
  Logical: string;
  Physical: string;
begin
  Logical := StringReplace(Trim(LogicalName), '/', '\', [rfReplaceAll]);
  if (Pos('\', Logical) > 0) then
    Logical := LeftStr(Logical, Pos('\', Logical) - 1);
  Check(Logical = '', sfoLogicalIsEmpty);
  Physical := FLogicalList.Values[Logical];
  Check(Physical = '', sfoLogicalNotExists, [Logical]);
  Result := StringReplace(Trim(LogicalName), Logical, Physical, []);
end;

procedure TFileServiceManager.RegisterLogicalName(const LogicalName,
  PhysicalPath: string);
begin
  // todo: ����ͻ��˹����ʱ���迼���̰߳�ȫ
  FLogicalList.Values[LogicalName] := ExcludeTrailingBackslash(PhysicalPath);
  AppCore.Logger.WriteFmt('[�ļ�����]ע�����߼�Ŀ¼%s=%s', [LogicalName, PhysicalPath], mtInfo, 0);
end;

// ɾ���ļ�����Ŀ¼

function TFileServiceManager.RemoveFile(Sender: TRORemoteDataModule;
  const FileName: AnsiString): Integer;
var
  Physical: string;
begin
  Physical := LogicalToPhysical(FileName);
  if FileExists(Physical) then
  begin
    if not SysUtils.DeleteFile(Physical) then
      raise Exception.CreateFmt(sfoFileDeleteError, [FileName, GetLastError()]);
  end
  else if DirectoryExists(Physical) then
  begin
    if (DelDirectory(Physical) <> 0) then
      raise Exception.CreateFmt(sfoFolderDelteError, [FileName]);
  end
  else
    raise Exception.CreateFmt(sfoFileNotExists, [FileName]);
  Result := 0;
end;

// �ļ�����Ŀ¼������

function TFileServiceManager.RenameFile(Sender: TRORemoteDataModule;
  const OldName, NewName: AnsiString): Integer;
var
  Physical1, Physical2: string;
begin
  Physical1 := LogicalToPhysical(OldName);
  Physical2 := ExtractFilePath(Physical1) + '\' + NewName;
  if FileExists(Physical1) or DirectoryExists(Physical1) then
  begin
    if not SysUtils.RenameFile(Physical1, Physical2) then
      raise Exception.CreateFmt(sfoFileRenameError, [OldName]);
  end
  else
    raise Exception.CreateFmt(sfoFileNotExists, [OldName]);
  Result := 0;
end;

// todo: ��ͻ���ͨѶ��صķ������ֵ

function TFileServiceManager.ServiceValue(Sender: TRORemoteDataModule;
  const ValueName: AnsiString): Variant;
begin

end;

// �ϴ��ļ����ͻ���ֻ�ܵ��߳��ϴ�ͬһ���ļ������ܿ����߳��ϴ�ͬһ���ļ�
// �����Զ��߳��ϴ�����ļ�

function TFileServiceManager.UploadFile(Sender: TRORemoteDataModule;
  const FileName: AnsiString; const FileSize, StartPos: Integer;
  const Block: Binary): Integer;
var
  UploadingFile: TUploadingFile;
  ClientID, PhysicalName: string;
begin
  Result := 0;

  ClientID := GUIDToString(Sender.ClientID);
  // ���ļ�����Ϊ�ϴ��ļ���Ψһ��ʶ
  UploadingFile := GetUploadingFile(FileName);
  // ����ǵ�1���ϴ������ݣ�UploadingFileΪ�գ�������½�
  if UploadingFile = nil then
    UploadingFile := AddUploadingFile(ClientID, Filename, FileSize);

  // �ж������ͻ����Ƿ��ϴ���ͬ�ļ�
  Check(UploadingFile.FClientID <> ClientID, sfoUploadConflict);

  try
    // ������. ��ƥ��ʱ��˵���ϴ����ֻ���
    if ((UploadingFile.FFileSize <> FileSize) or
      (UploadingFile.FLogicalName <> FileName) or
      (UploadingFile.FTempFileStream.Size <> StartPos) or
      (UploadingFile.FTempFileStream.Size + Block.Size > FileSize)) then
    begin
      raise Exception.Create(sfoUploadNoMatch);
    end;

    // ����
    UploadingFile.FTempFileStream.CopyFrom(Block, Block.Size);
    // ���·���ʱ��
    UploadingFile.FLastTime := Now();

    // ����ϴ����
    if FileSize = UploadingFile.FTempFileStream.Size then
    try
      // �ͷ���ʱ�����Ա��ƶ�
      FreeAndNil(UploadingFile.FTempFileStream);
      // ��ʱ�ļ��ƶ���ָ��Ŀ¼
      // ���⣺�����ʱĿ¼��Ŀ��Ŀ¼����ͬһ���ϣ��ƶ����ļ���ʱ��Ƚϳ�
      if not Windows.MoveFileEx(PChar(UploadingFile.FTempFileName),
        PChar(UploadingFile.FPhysicalName),
        MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING) then
      begin
        raise Exception.CreateFmt(sfoFileMoveError, [FileName]);
      end;
    finally
      // ����������ɹ������������ϴ����ļ�����
      RemoveUploadFile(FileName);
    end;
  except
    // һ��������������ϴ��ļ�
    RemoveUploadFile(FileName);
    raise;
  end;
end;

// ���δ��ɵ��ϴ��ļ�

procedure TFileServiceManager.CleanUploadFiles;
begin
  FCritical.Enter;
  try
    while FUploadFiles.Count > 0 do
    begin
      FUploadFiles.Objects[FUploadFiles.Count - 1].Free;
      FUploadFiles.Delete(FUploadFiles.Count - 1);
    end;
  finally
    FCritical.Leave;
  end;
end;

// ����ID��ȡ�����ϴ����ļ�

function TFileServiceManager.GetUploadingFile(ID: string): TUploadingFile;
var
  I: Integer;
begin
  FCritical.Enter;
  try
    I := FUploadFiles.IndexOf(ID);
    if I > -1 then
      Result := TUploadingFile(FUploadFiles.Objects[I])
    else
      Result := nil;
  finally
    FCritical.Leave;
  end;
end;

// ��ʱ����ʧЧ���ϴ��ļ�

procedure TFileServiceManager.CleanTimerEvent(CurrentTickCount: cardinal);
var
  I: Integer;
begin
  FCritical.Enter;
  try
    for I := FUploadFiles.Count - 1 downto 0 do
    begin
      with TUploadingFile(FUploadFiles.Objects[I]) do
      begin
        // ��ʱδ�ϴ�����δ�ϴ����(�ϴ���ɵĴ��ļ����������ƶ�)
        if (SecondsBetween(Now, FLastTime) * 1000 > ifoCleanTimeout) and
          (FTempFileStream <> nil) then
        begin
          Free;
          FUploadFiles.Delete(I);
        end;
      end;
    end;
  finally
    FCritical.Leave;
  end;
end;

// ɾ���ϴ����ļ�����

procedure TFileServiceManager.RemoveUploadFile(ID: string);
var
  I: Integer;
begin
  FCritical.Enter;
  try
    I := FUploadFiles.IndexOf(ID);
    if I > -1 then
    begin
      FUploadFiles.Objects[I].Free;
      FUploadFiles.Delete(I);
    end;
  finally
    FCritical.Leave;
  end
end;

// �½��ϴ��ļ�

function TFileServiceManager.AddUploadingFile(const ClientID,
  LogicalName: string; FileSize: Integer): TUploadingFile;
var
  PhysicalName: string;
begin
  FCritical.Enter;
  try
    if FUploadFiles.IndexOf(LogicalName) < 0 then
    begin
      // ����߼����Ƿ���ȷ
      PhysicalName := LogicalToPhysical(LogicalName);
      Result := TUploadingFile.Create(ClientID, LogicalName, PhysicalName, FileSize);
      FUploadFiles.AddObject(LogicalName, Result);
    end
    else
      raise Exception.Create(sfoUploadConflict);
  finally
    FCritical.Leave;
  end;
end;

{ TUploadingFile }

constructor TUploadingFile.Create(const AClientID, ALogicalName, APhysicalName: string; AFileSize: Integer);
begin
  // �ϴ��ϴ�ʱ�䣬��ʱ��δ�ϴ����ļ��������Զ����
  FLastTime := Now;
  FFileSize := AFileSize;
  FClientID := AClientID;
  FLogicalName := ALogicalName;
  FPhysicalName := APhysicalName;
  // �ϴ����ļ�ֱ�ӷ���ָ��Ŀ¼�У�������ʱ�ļ���������Ҫ�ƶ��ļ�������
  ForceDirectories(ExtractFilePath(APhysicalName));
  FTempFileName := APhysicalName + '.tmp';
  FTempFileStream := TFileStream.Create(FTempFileName, fmCreate);
end;

destructor TUploadingFile.Destroy;
begin
  FreeAndNil(FTempFileStream);      
  // ����ͷ�ǰû���������ļ������������
  SysUtils.DeleteFile(FTempFileName + '.tmp');
  inherited;
end;

initialization
  FileServiceManager := TFileServiceManager.Create;

finalization
  FreeAndNil(FileServiceManager);

end.

