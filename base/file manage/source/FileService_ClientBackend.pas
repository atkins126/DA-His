unit FileService_ClientBackend;

{
  �ļ�����ͻ��˿�
  v1.0 2013-1-5 ��ΰ��

  1. ��ͬʱ�������TFileServiceClient, �����ò�ͬ��RemoteService����������
     ������ͨѶ��
}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  uRORemoteService,
  uROClasses,
  uROTypes,
  App_Common,
  App_Function,
  App_DAModel,
  FileServiceLib_Intf;

const
  sFileMoveError = '%s�ļ�����ʧ��';
  sProcessCanceled = '������ȡ��';

  // �ϴ������ļ�������С��64K=$10000
  iTransferBlockSize = $20000;

type
  TOnDownloadFile = procedure(Sender: TObject; Info: FileInfo) of object;

  TFileServiceClient = class(TComponent)
  private
    FRemoteService: TRORemoteService;
    procedure DoCheck();
    function GetFileMD5(const FileName: string): string;
    procedure AssignFiles(Source, Dest: FileArray; const RootPath: string);
  public
    procedure InitService(ARemoteService: TRORemoteService);

    function FindLocalPath(const LocalPath: AnsiString): FileArray;
    function LocalFileAttr(const LocalFile: AnsiString): FileInfo;

    function FindPath(const ServerPath: AnsiString): FileArray;
    function UploadFile(const ClientFile, ServerFile: string; OnProgress: TOnProgress): Boolean;
    function UploadStream(Stream: TStream; const ServerFile: string; OnProgress: TOnProgress): Boolean;
    function UploadPath(const ServerPath, ClientPath: string; OnUploadFile: TOnDownloadFile;
      OnAllProgress, OnFileProgress: TOnProgress): Boolean;

    function DownloadFile(const ServerFile, ClientFile: string; FileSize: Integer=0; OnProgress: TOnProgress=nil): Boolean;
    function DownloadStream(const ServerFile: string; Stream: TStream; FileSize: Integer=0; OnProgress: TOnProgress=nil): Boolean;
    function DownloadPath(const ServerPath, ClientPath: string; OnDownloadFile: TOnDownloadFile;
      OnAllProgress, OnFileProgress: TOnProgress): Boolean;
    procedure UpdateClientFiles(const ServerPath, ClientPath: string;
      OnDownloadFile: TOnDownloadFile; OnAllProgress, OnFileProgress: TOnProgress);

    function RenameFile(const OldName: AnsiString; const NewName: AnsiString): Integer;
    function RemoveFile(const ServerFile: AnsiString): Integer;
    function FileAttr(const ServerFile: AnsiString): FileInfo;
    function ServiceValue(const ValueName: AnsiString): Variant;
  end;


implementation

{ TFileServiceClient }

procedure TFileServiceClient.AssignFiles(Source, Dest: FileArray; const RootPath: string);
var
  I: Integer;
begin
  for I := 0 to Source.Count - 1 do
  begin
    with Dest.Add do
    begin
      Assign(Source[I]);
      // ����ȫ��
      Name := RootPath + '\' + Name;
    end;
  end;
end;

procedure TFileServiceClient.DoCheck;
begin
  Check(FRemoteService = nil, '��������Զ�̷���');
end;

{
  �ӷ��������ص����ļ�������ָ��Ŀ¼
}

function TFileServiceClient.DownloadFile(const ServerFile, ClientFile: string;
  FileSize: Integer; OnProgress: TOnProgress): Boolean;
var
  Stream: TFileStream;
begin
  DoCheck();
  // ȷ��Ŀ¼�Ѿ�����
  ForceDirectories(ExtractFilePath(ClientFile));
  Stream := TFileStream.Create(ClientFile, fmCreate);
  try
    Result := DownloadStream(ServerFile, Stream, FileSize, OnProgress);
    AppCore.Logger.WriteFmt('%s�������.', [ClientFile], mtInfo, 0);
  finally
    FreeAndNil(Stream);
    // ɾ������ʧ��ʱ�ļ�
    if not Result then
      SysUtils.DeleteFile(ClientFile);
  end;
end;

{
  �ӷ�������������Ŀ¼��ֱ�ӷ���Ŀ��Ŀ¼����������ʱĿ¼��
  �д���ʱֱ���˳�
}

function TFileServiceClient.DownloadPath(const ServerPath,
  ClientPath: string; OnDownloadFile: TOnDownloadFile;
  OnAllProgress, OnFileProgress: TOnProgress): Boolean;
var
  ServerFiles, TempFiles: FileArray;
  ClientFileName: string;
  CurrentIndex: Integer;
  Canceled: Boolean;
begin
  DoCheck();
  CurrentIndex := 0;
  ServerFiles := FileArray.Create;
  with ServerFiles.Add do
  begin
    Name := ServerPath;
    Attr := faDirectory;
  end;
  try
    Canceled := False;
    while not Canceled and (CurrentIndex < ServerFiles.Count) do
    begin
      if Assigned(OnAllProgress) then
        OnAllProgress(ServerFiles.Count, CurrentIndex, Canceled);
      Check(Canceled, sProcessCanceled);

      if ((ServerFiles[CurrentIndex].Attr and faDirectory) <> 0) then
      begin
        TempFiles := FindPath(ServerFiles[CurrentIndex].Name);
        // ��¼�������������ҵ����ļ�
        AssignFiles(TempFiles, ServerFiles, ServerFiles[CurrentIndex].Name);
        FreeAndNil(TempFiles);
      end
      else if ((ServerFiles[CurrentIndex].Attr and faArchive) <> 0) then
      begin
        if Assigned(OnDownloadFile) then
          OnDownloadFile(Self, ServerFiles[CurrentIndex]);

        ClientFileName := StringReplace(ServerFiles[CurrentIndex].Name, ServerPath, ClientPath, [rfIgnoreCase]);
        Result := DownloadFile(ServerFiles[CurrentIndex].Name,
          ClientFileName,
          ServerFiles[CurrentIndex].Size,
          OnFileProgress);
        // �����ļ�ʱ��
        SysUtils.FileSetDate(ClientFileName, ServerFiles[CurrentIndex].Time)
      end;

      Inc(CurrentIndex);
    end;
  finally
    ServerFiles.Free;
  end;
end;

function TFileServiceClient.DownloadStream(const ServerFile: string;
  Stream: TStream; FileSize: Integer; OnProgress: TOnProgress): Boolean;
var
  Block: Binary;
  Canceled: Boolean;
  Info: FileInfo;
begin
  Result := False;
  Canceled := False;

  // ��ȡ�ļ���С
  if FileSize <= 0 then
  begin
    Info := (FRemoteService as IFileService).FileAttr(ServerFile);
    FileSize := Info.Size;
    FreeAndNil(Info);
  end;
  // һ������أ�ֱ���ļ�ĩβ
  while not Canceled and (Stream.Size < FileSize) do
  begin
    Block := (FRemoteService as IFileService).DownloadFile(ServerFile, Stream.Size, iTransferBlockSize);
    Stream.CopyFrom(Block, Block.Size);
    Block.Free; // ���صĿ��С���ܲ�����cBlockSize
    if Assigned(OnProgress) then
      OnProgress(FileSize, Stream.Size, Canceled);
    Check(Canceled and (Stream.Size < FileSize), sProcessCanceled);
  end;
  Result := True; 
end;

function TFileServiceClient.FileAttr(const ServerFile: AnsiString): FileInfo;
begin
  DoCheck();
  Result := (FRemoteService as IFileService).FileAttr(ServerFile);
end;

// ��������Ŀ¼
// LocalPath��ͨ���

function TFileServiceClient.FindLocalPath(
  const LocalPath: AnsiString): FileArray;
var
  SR: TSearchRec;
begin
  Result := FileArray.Create;
  // ��ʼ����
  if FindFirst(LocalPath, faDirectory or faArchive, SR) = 0 then
  try
    repeat
      if SR.Name = '.' then
        Continue;
      if SR.Name = '..' then
        Continue;

      with Result.Add do
      begin
        Name := SR.Name;
        Size := SR.Size;
        Time := SR.Time;
        Attr := SR.Attr;
        if ((Attr and faDirectory) <> 0) then
          MD5 := GetFileMD5(LocalPath + '\' + SR.Name)
        else
          MD5 := '';
      end;
    until FindNext(SR) <> 0;
  finally
    SysUtils.FindClose(SR);
  end;
end;

function TFileServiceClient.FindPath(const ServerPath: AnsiString): FileArray;
begin
  DoCheck();
  Result := (FRemoteService as IFileService).FindPath(ServerPath);
end;

function TFileServiceClient.GetFileMD5(const FileName: string): string;
begin
  // todo:
end;

procedure TFileServiceClient.InitService(ARemoteService: TRORemoteService);
begin
  FRemoteService := ARemoteService;
end;

// �����ļ�����

function TFileServiceClient.LocalFileAttr(
  const LocalFile: AnsiString): FileInfo;
var
  SR: TSearchRec;
begin
  if FileExists(LocalFile) then
  begin
    Result := FileInfo.Create;
    if FindFirst(LocalFile, faArchive, SR) = 0 then
    begin
      Result.Name := SR.Name;
      Result.Size := SR.Size;
      Result.Time := SR.Time;
      Result.Attr := SR.Attr;
      Result.MD5 := GetFileMD5(LocalFile);
    end;
    SysUtils.FindClose(SR);
  end
  else
    Result := nil;
end;

function TFileServiceClient.RemoveFile(
  const ServerFile: AnsiString): Integer;
begin
  DoCheck();
  Result := (FRemoteService as IFileService).RemoveFile(ServerFile);
end;

function TFileServiceClient.RenameFile(const OldName,
  NewName: AnsiString): Integer;
begin
  DoCheck();
  Result := (FRemoteService as IFileService).RenameFile(OldName, NewName);
end;

function TFileServiceClient.ServiceValue(
  const ValueName: AnsiString): Variant;
begin
  DoCheck();
  Result := (FRemoteService as IFileService).ServiceValue(ValueName);
end;

{
  ���ܸ���

  1. �Աȿͻ��˺ͷ������ϵ��ļ����޸�ʱ����ߴ�С����ͬ������
  2. ֻ��ȫ�����سɹ����ܸ��¿ͻ����ļ�
}

procedure TFileServiceClient.UpdateClientFiles(const ServerPath, ClientPath: string;
  OnDownloadFile: TOnDownloadFile; OnAllProgress, OnFileProgress: TOnProgress);
var
  ServerFiles, TempFiles: FileArray;
  DownloadedFiles: FileArray;
  TempPath, TempFileName: string;

  LocalAttr: FileInfo;
  CurrentIndex: Integer;
  Canceled: Boolean;
begin
  DoCheck();
  CurrentIndex := 0;
  DownloadedFiles := FileArray.Create;
  ServerFiles := FileArray.Create;
  {
    ��ʱĿ¼����Ŀ��Ŀ¼�У�����Ŀ��Ŀ¼����ʱĿ¼�ڲ�ͬ���ϣ�
    ������������ʱ�ɿ�������ļ��ƶ�
  }
  TempPath := IncludeTrailingBackslash(ClientPath) + 'temp\AutoUpdate';
  with ServerFiles.Add do
  begin
    Name := ServerPath;
    Attr := faDirectory;
  end;
  try
    // �����ʱĿ¼
    DelDirectory(TempPath);
    Canceled := False;
    while not Canceled and (CurrentIndex < ServerFiles.Count) do
    begin
      if Assigned(OnAllProgress) then
        OnAllProgress(ServerFiles.Count, CurrentIndex, Canceled);

      Check(Canceled, sProcessCanceled);

      if ((ServerFiles[CurrentIndex].Attr and faDirectory) <> 0) then
      begin
        TempFiles := FindPath(ServerFiles[CurrentIndex].Name);
        // ��¼�������������ҵ����ļ�
        AssignFiles(TempFiles, ServerFiles, ServerFiles[CurrentIndex].Name);
        FreeAndNil(TempFiles);
      end
      else if ((ServerFiles[CurrentIndex].Attr and faArchive) <> 0) then
      begin
          // ��ȡ��Ӧ�����ļ�����
        LocalAttr := LocalFileAttr(StringReplace(ServerFiles[CurrentIndex].Name,
          ServerPath, ClientPath, []));
        try
          if (LocalAttr = nil) or
            (LocalAttr.Size <> ServerFiles[CurrentIndex].Size) or
            (LocalAttr.Time <> ServerFiles[CurrentIndex].Time) then
          begin
            if Assigned(OnDownloadFile) then
              OnDownloadFile(Self, ServerFiles[CurrentIndex]);

            // ���ص���ʱĿ¼
            TempFileName := StringReplace(ServerFiles[CurrentIndex].Name, ServerPath, TempPath, []);
            DownloadFile(ServerFiles[CurrentIndex].Name,
              TempFileName,
              ServerFiles[CurrentIndex].Size,
              OnFileProgress);

              // ��¼���ص��ļ������ں����ƶ���Ŀ���ļ���
            with DownloadedFiles.Add do
            begin
              Assign(ServerFiles[CurrentIndex]);
              Name := TempFileName;
            end;
          end;
        finally
          FreeAndNil(LocalAttr);
        end;
      end;

      Inc(CurrentIndex);
    end;

    // �ƶ���ʱĿ¼��ָ��Ŀ¼
    for CurrentIndex := 0 to DownloadedFiles.Count - 1 do
    begin
      // Ŀ���ļ�
      TempFileName := StringReplace(DownloadedFiles[CurrentIndex].Name, TempPath, ClientPath, []);

      SysUtils.DeleteFile(TempFileName + '~');
      if not SysUtils.DeleteFile(TempFileName) then
        SysUtils.RenameFile(TempFileName, TempFileName + '~');

      ForceDirectories(ExtractFilePath(TempFileName));
      {
      if not Windows.MoveFileEx(PChar(DownloadedFiles[CurrentIndex].Name),
        PChar(TempFileName),
        MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING) then
      begin
        raise Exception.CreateFmt(sFileMoveError, [TempFileName]);
      end;
      }
      Windows.MoveFileEx(PChar(DownloadedFiles[CurrentIndex].Name),
        PChar(TempFileName),
        MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING);
      SysUtils.FileSetDate(TempFileName, DownloadedFiles[CurrentIndex].Time);

    end;
  finally
    ServerFiles.Free;
    DownloadedFiles.Free;
  end;
end;

{
  �ϴ������ļ�
}

function TFileServiceClient.UploadFile(const ClientFile, ServerFile: string;
  OnProgress: TOnProgress): Boolean;
var
  Stream: TFileStream;
begin
  DoCheck();
  Stream := TFileStream.Create(ClientFile, fmOpenRead);
  try
    Result := UploadStream(Stream, ServerFile, OnProgress);
  finally
    FreeAndNil(Stream);
  end;
end;

{
  �ϴ�����Ŀ¼
}

function TFileServiceClient.UploadPath(const ServerPath,
  ClientPath: string; OnUploadFile: TOnDownloadFile; OnAllProgress,
  OnFileProgress: TOnProgress): Boolean;
var
  ClientFiles, TempFiles: FileArray;
  CurrentIndex: Integer;
  Canceled: Boolean;
begin
  DoCheck();
  CurrentIndex := 0;
  ClientFiles := FileArray.Create;
  with ClientFiles.Add do
  begin
    Name := ClientPath;
    Attr := faDirectory;
  end;
  try
    Canceled := False;
    while not Canceled and (CurrentIndex < ClientFiles.Count) do
    begin
      if Assigned(OnAllProgress) then
        OnAllProgress(ClientFiles.Count, CurrentIndex, Canceled);
      Check(Canceled, sProcessCanceled);

      if ((ClientFiles[CurrentIndex].Attr and faDirectory) <> 0) then
      begin
        TempFiles := FindLocalPath(ClientFiles[CurrentIndex].Name + '\*.*');
        // ��¼�ҵ����ļ�
        AssignFiles(TempFiles, ClientFiles, ClientFiles[CurrentIndex].Name);
        FreeAndNil(TempFiles);
      end
      else if ((ClientFiles[CurrentIndex].Attr and faArchive) <> 0) then
      begin
        if Assigned(OnUploadFile) then
          OnUploadFile(Self, ClientFiles[CurrentIndex]);

        Result := UploadFile(ClientFiles[CurrentIndex].Name,
          StringReplace(ClientFiles[CurrentIndex].Name, ClientPath, ServerPath, [rfIgnoreCase]),
          OnFileProgress);
      end;

      Inc(CurrentIndex);
    end;
  finally
    ClientFiles.Free;
  end;
end;

function TFileServiceClient.UploadStream(Stream: TStream;
  const ServerFile: string; OnProgress: TOnProgress): Boolean;
var
  BlockSize: Integer;
  Canceled: Boolean;
  Block: Binary;
begin
  DoCheck();
  Result := False;
  Block := Binary.Create;
  Canceled := False;
  try
    // һ����ϴ�
    while not Canceled and (Stream.Position < Stream.Size) do
    begin
      BlockSize := Stream.Size - Stream.Position;
      if BlockSize > iTransferBlockSize then
        BlockSize := iTransferBlockSize;
      Block.SetSize(BlockSize);
      Block.Position := 0;

      Block.CopyFrom(Stream, BlockSize);
      (FRemoteService as IFileService).UploadFile(ServerFile, Stream.Size,
        Stream.Position - Block.Size, Block);
      if Assigned(OnProgress) then
        OnProgress(Stream.Size, Stream.Position, Canceled);
      Check(Canceled and (Stream.Position < Stream.Size), sProcessCanceled);
    end;
    Result := True;
  finally
    FreeAndNil(Block);
  end;
end;

end.

