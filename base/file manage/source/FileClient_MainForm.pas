unit FileClient_MainForm;

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
  ActnList,
  Dialogs,
  App_Common,
  App_Function,
  App_Class,
  App_DevExpress,
  App_DAModel,
  App_Dev_Toolbar,
  FileService_ClientBackend,
  FileServiceLib_Intf,
  FileCtrl,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxCustomData,
  cxStyles,
  cxTL,
  cxTLdxBarBuiltInMenu,
  dxLayoutContainer,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  DB,
  cxDBData,
  cxGridLevel,
  cxClasses,
  cxGridCustomView,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridDBTableView,
  cxGrid,
  cxInplaceContainer,
  dxLayoutControl,
  dxBar,
  cxTextEdit,
  cxSpinEdit,
  uROTypes,
  cxCalendar, cxNavigator;

type

  TFileClientForm = class(TBaseView)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    FolderTree: TcxTreeList;
    dxLayoutControl1Item1: TdxLayoutItem;
    cxGridLevel1: TcxGridLevel;
    cxGrid: TcxGrid;
    dxLayoutControl1Item2: TdxLayoutItem;
    FileTable: TcxGridTableView;
    ColumnName: TcxGridColumn;
    ColumnSize: TcxGridColumn;
    ColumnTime: TcxGridColumn;
    ColumnAttr: TcxGridColumn;
    ColumnExt: TcxGridColumn;
    FolderColumn: TcxTreeListColumn;
    OpenDialog: TOpenDialog;
    dxLayoutControl1SplitterItem1: TdxLayoutSplitterItem;
    procedure FolderTreeFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
  private
    { Private declarations }
    FBarManager: TdxBarManager;
    FTargetUrl: string;
    FFileConnection: TROConnection;
    FFileClient: TFileServiceClient;
    FDownloadPath: string;
    FTempPath: string;
    procedure DoConnectServer(Sender: TObject);
    procedure DoSearchPath(Sender: TObject);
    procedure DoRename(Sender: TObject);
    procedure DoDelete(Sender: TObject);
    procedure DoDownload(Sender: TObject);
    procedure DoUpload(Sender: TObject);
    procedure DoUploadDir(Sender: TObject);
    procedure DoDownloadDir(Sender: TObject);
    procedure DoUpdateDir(Sender: TObject);
    function GetFullFolderName(Node: TcxTreeListNode): string;
    procedure FindPath();
    procedure ProgressEvent(Max, Position: Integer; var Canceled: Boolean);
    procedure FileDownloadEvent(Sender: TObject; Info: FileInfo);
    procedure FileUploadEvent(Sender: TObject; Info: FileInfo);
  protected

  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
  end;

var
  FileClientForm: TFileClientForm; 
  DevStatusBar: TDevStatusBar;

implementation

{$R *.dfm}

const
  cBlockSize = $FFFF;

  { TFileClientForm }

constructor TFileClientForm.Create(aOwner: TComponent);
begin
  inherited;
  FTargetUrl := AppCore.IniFile.ReadString(sAppSection, 'TargetUrl', 'supertcp://127.0.0.1:9818/bin');
  FFileConnection := TROConnection.Create(Self, FTargetUrl);
  FFileClient := TFileServiceClient.Create(Self);
  FFileClient.InitService(FFileConnection.ROService);

  FolderTree.Images := AppCore.SmallImage.ImageList;
  FolderTree.Styles := DevExpress.GetTreeStyle;
  FileTable.Styles := DevExpress.GetGridStyle;

  // �����ļ����Ŀ¼
  FDownloadPath := 'E:\test\download';
  FTempPath := AppCore.AppPath + 'temp\upgrade';

  with TAction.Create(Self) do
  begin
    Caption := '���ӷ�����';
    ImageIndex := AppCore.ToolBarImage.IndexOf('server');
    OnExecute := DoConnectServer;
    ActionList := ViewActions;
  end;

  with TAction.Create(Self) do
  begin
    Caption := 'ˢ��Ŀ¼';
    ImageIndex := AppCore.ToolBarImage.IndexOf('search');
    OnExecute := DoSearchPath;
    ActionList := ViewActions;
  end;
  with TAction.Create(Self) do
  begin
    Caption := '������';
    ImageIndex := AppCore.ToolBarImage.IndexOf('rename');
    OnExecute := DoRename;
    ActionList := ViewActions;
  end;
  with TAction.Create(Self) do
  begin
    Caption := 'ɾ��';
    ImageIndex := AppCore.ToolBarImage.IndexOf('delete');
    OnExecute := DoDelete;
    ActionList := ViewActions;
  end;
  with TAction.Create(Self) do
  begin
    Caption := '�����ļ�';
    ImageIndex := AppCore.ToolBarImage.IndexOf('download');
    OnExecute := DoDownload;
    ActionList := ViewActions;
  end;
  with TAction.Create(Self) do
  begin
    Caption := '�ϴ��ļ�';
    ImageIndex := AppCore.ToolBarImage.IndexOf('upload');
    OnExecute := DoUpload;
    ActionList := ViewActions;
  end;
  with TAction.Create(Self) do
  begin
    Caption := '�ϴ�Ŀ¼';
    ImageIndex := AppCore.ToolBarImage.IndexOf('uploaddir');
    OnExecute := DoUploadDir;
    ActionList := ViewActions;
  end;

  with TAction.Create(Self) do
  begin
    Caption := '���¿ͻ���Ŀ¼';
    ImageIndex := AppCore.ToolBarImage.IndexOf('update_dir');
    OnExecute := DoUpdateDir;
    ActionList := ViewActions;
  end;
  with TAction.Create(Self) do
  begin
    Caption := '��������Ŀ¼';
    ImageIndex := AppCore.ToolBarImage.IndexOf('download_dir');
    OnExecute := DoDownloadDir;
    ActionList := ViewActions;
  end;

  FBarManager := CreateBarManager(Self);
  
  BuildDevToolBar(CreateBar(FBarManager, '�ļ�����'), ViewActions, 0);
end;

// ȡ�����οؼ����˽ڵ��Ŀ¼ȫ��

function TFileClientForm.GetFullFolderName(Node: TcxTreeListNode): string;
begin
  if Node = nil then
    Result := ''
  else if Node.Parent = FolderTree.Root then
    Result := Node.Texts[0]
  else
    Result := GetFullFolderName(Node.Parent) + '\' + Node.Texts[0];
end;

procedure TFileClientForm.DoSearchPath(Sender: TObject);
begin
  if FolderTree.FocusedNode <> nil then
    FolderTree.FocusedNode.DeleteChildren
  else
    FolderTree.Clear;
  FindPath;
end;

// �������ļ�����Ŀ¼

procedure TFileClientForm.DoRename(Sender: TObject);
var
  OldName, NewName: string;
begin
  if FolderTree.Focused and (FolderTree.FocusedNode <> nil) and
    (FolderTree.FocusedNode.Parent <> FolderTree.Root) then
  begin
    OldName := GetFullFolderName(FolderTree.FocusedNode);
  end
  else if FileTable.Focused and (FileTable.DataController.FocusedRecordIndex >
    -1) then
  begin
    OldName :=
      FileTable.DataController.Values[FileTable.DataController.FocusedRecordIndex,
      ColumnName.Index];
    OldName := GetFullFolderName(FolderTree.FocusedNode) + '\' + OldName;
  end;

  if OldName <> '' then
  begin
    NewName := ExtractFileName(OldName);
    if InputQuery('������', '������������:', NewName) then
      if (NewName <> OldName) then
      begin
        FFileClient.RenameFile(OldName, NewName);
        if FolderTree.Focused then
          FolderTree.FocusedNode.Values[0] := NewName
        else
          FileTable.DataController.Values[FileTable.DataController.FocusedRecordIndex, ColumnName.Index] :=
            NewName;
      end;
  end;
end;

// ɾ���ļ�����Ŀ¼

procedure TFileClientForm.DoDelete(Sender: TObject);
var
  OldName: string;
  Node: TcxTreeListNode;
  TreeFocued: Boolean;
begin
  if FolderTree.Focused and (FolderTree.FocusedNode <> nil) and
    (FolderTree.FocusedNode.Parent <> FolderTree.Root) then
  begin
    OldName := GetFullFolderName(FolderTree.FocusedNode); 
    TreeFocued := True;
  end
  else if FileTable.Focused and (FileTable.DataController.FocusedRecordIndex > -1) then
  begin
    TreeFocued := False;
    OldName := FileTable.DataController.Values[FileTable.DataController.FocusedRecordIndex, ColumnName.Index];
    OldName := GetFullFolderName(FolderTree.FocusedNode) + '\' + OldName;
  end;

  if (OldName <> '') then
  begin
    if ShowYesNo('ȷ��ɾ����') then
    begin
      FFileClient.RemoveFile(OldName);

      if TreeFocued then
      begin
        Node := FolderTree.FocusedNode.getPrevSibling;
        if Node = nil then
          Node := FolderTree.FocusedNode.Parent;
        FolderTree.FocusedNode.Delete;
        Node.Focused := True;
      end
      else
        FileTable.DataController.DeleteFocused;
    end;
  end;
end;

procedure TFileClientForm.FolderTreeFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode,
  AFocusedNode: TcxTreeListNode);
begin
  FindPath();
end;

// ����Ŀ¼

procedure TFileClientForm.FindPath;
var
  FileName: string;
  Files: FileArray;
  I, J: Integer;
  PN: TcxTreeListNode;

  function IsChildExists(ParentNode: TcxTreeListNode; const Text: string):
      Boolean;
  var
    K: Integer;
  begin
    Result := False;
    for K := 0 to ParentNode.Count - 1 do
    begin
      if (ParentNode.Items[K].Texts[0] = Text) then
      begin
        Result := True;
        break;
      end;
    end;
  end;

begin
  PN := FolderTree.FocusedNode;
  if (FolderTree.Count = 0) then
    FileName := ''
  else if (PN <> nil) then
    FileName := GetFullFolderName(PN)
  else
    Exit;

  Files := FFileClient.FindPath(FileName);
  FileTable.DataController.BeginUpdate();
  try
    FileTable.DataController.RecordCount := 0;
    for I := 0 to Files.Count - 1 do
    begin
      if ((Files[I].Attr and faDirectory) <> 0) then
      begin
        if (PN = nil) then
        begin
          with FolderTree.Add do
          begin
            Texts[0] := Files[I].Name;
            ImageIndex := AppCore.SmallImage.IndexOf('folder');
          end;
        end
        else
        begin
          if not IsChildExists(PN, Files[I].Name) then
            with PN.AddChild do
            begin
              Texts[0] := Files[I].Name;
              ImageIndex := AppCore.SmallImage.IndexOf('folder');
            end;
        end;
      end
      else
      begin
        // todo: display file icon
        J := FileTable.DataController.AppendRecord;
        FileTable.DataController.Values[J, ColumnName.Index] := Files[I].Name;
        FileTable.DataController.Values[J, ColumnExt.Index] :=
          ExtractFileExt(Files[I].Name);
        FileTable.DataController.Values[J, ColumnSize.Index] := Files[I].Size;
        FileTable.DataController.Values[J, ColumnTime.Index] :=
          FileDateToDateTime(Files[I].Time);
        FileTable.DataController.Values[J, ColumnAttr.Index] := Files[I].Attr;
      end;
    end;
  finally
    if PN <> nil then PN.Expanded := True;
    FileTable.DataController.EndUpdate;
  end;
  Files.Free;
end;

// �����ļ�

procedure TFileClientForm.DoDownload(Sender: TObject);
var
  FileName: string;
  DestName: string;
begin
  if FileTable.Focused and (FileTable.DataController.FocusedRecordIndex > -1) then
  begin
    if SelectDirectory(DestName, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
    begin
      // ȡ��Ҫ���ص��ļ���
      FileName := FileTable.DataController.Values[FileTable.DataController.FocusedRecordIndex, ColumnName.Index];
      DestName := DestName + '\' + FileName;
      FileName := GetFullFolderName(FolderTree.FocusedNode) + '\' + FileName;
      AppCore.MainView.Enabled := False;
      try
        FFileClient.DownloadFile(FileName, DestName,
          FileTable.DataController.Values[FileTable.DataController.FocusedRecordIndex, ColumnSize.Index],
          ProgressEvent);
        AppCore.Logger.Write(DestName + '�������', mtInfo, 0);
      finally
        AppCore.MainView.Enabled := True;
      end;
    end;
  end;
end;

procedure TFileClientForm.ProgressEvent(Max, Position: Integer; var Canceled:
  Boolean);
begin
  DevStatusBar.ShowProgress(Max, Position);
  //Application.ProcessMessages;
end;

// �ϴ��ļ�

procedure TFileClientForm.DoUpload(Sender: TObject);
var
  DestPath: string;
begin
  DestPath := GetFullFolderName(FolderTree.FocusedNode);
  if OpenDialog.Execute and InputQuery('ѯ��', '���������Ŀ¼', DestPath) then
  begin
    FFileClient.UploadFile(OpenDialog.FileName,
      DestPath + '\' + ExtractFileName(OpenDialog.FileName),
      ProgressEvent);
    // ˢ�½���
    FindPath();
  end;
end;

procedure TFileClientForm.DoDownloadDir(Sender: TObject);
var
  SourcePath, DestPath: string;
begin
  SourcePath := GetFullFolderName(FolderTree.FocusedNode);
  if SelectDirectory(Format('��������%s, ѡ����Ŀ¼', [SourcePath]), '.\', DestPath) then
  begin
    // ��ѡ���Ŀ¼���Զ�����������Ŀ¼
    DestPath := DestPath + '\' + FolderTree.FocusedNode.Texts[0];
    AppCore.MainView.Enabled := False;
    try
      FFileClient.DownloadPath(
        SourcePath,
        DestPath,
        FileDownloadEvent,
        nil,
        ProgressEvent);
      AppCore.Logger.Write('�������', mtInfo, 0);
    finally
      AppCore.MainView.Enabled := True;
    end;
  end;
end;

procedure TFileClientForm.FileDownloadEvent(Sender: TObject; Info: FileInfo);
begin
  AppCore.Logger.WriteFmt('��������%s, ��С%0.0n', [Info.Name, Info.Size * 1.0], mtDebug, 0);
end;

procedure TFileClientForm.DoConnectServer(Sender: TObject);
begin
  if InputQuery('���÷�������ַ', '��ַ��ʽ��http://10.2.10.1:9818/bin', FTargetUrl) then
  begin
    FFileConnection.TargetURL := FTargetUrl;
    FolderTree.Clear;
    AppCore.IniFile.WriteString(sAppSection, 'TargetUrl', FTargetUrl);
    FindPath;
  end;
end;

procedure TFileClientForm.DoUpdateDir(Sender: TObject);
var
  SourcePath, DestPath: string;
begin
  SourcePath := GetFullFolderName(FolderTree.FocusedNode);
  if SelectDirectory(Format('������%s������Ŀ¼���¿ͻ����ļ�����ѡ��ͻ���Ŀ¼', [SourcePath]), '.\', DestPath) then
  begin
    AppCore.MainView.Enabled := False;
    try
      FFileClient.UpdateClientFiles(
        SourcePath,
        DestPath,
        FileDownloadEvent,
        nil,
        ProgressEvent);
      AppCore.Logger.Write('�������', mtInfo, 0);
    finally
      AppCore.MainView.Enabled := True;
    end;
  end;
end;

procedure TFileClientForm.DoUploadDir(Sender: TObject);
var
  DestPath: string;
  ClientPath: string;
begin
  DestPath := GetFullFolderName(FolderTree.FocusedNode);
  if SelectDirectory('��ѡ���ϴ���Ŀ¼', '', ClientPath) and
    InputQuery('ѯ��', '���������Ŀ¼', DestPath) then
  begin
    try
      FFileClient.UploadPath(DestPath, ClientPath,
        FileUploadEvent, nil, ProgressEvent);
      AppCore.Logger.Write('�ϴ����', mtInfo, 0);
    finally
      // ˢ�½���
      FindPath();
    end;
  end;
end;

procedure TFileClientForm.FileUploadEvent(Sender: TObject; Info: FileInfo);
begin
  AppCore.Logger.WriteFmt('�����ϴ�%s, ��С%0.0n', [Info.Name, Info.Size * 1.0], mtInfo, 0);
end;

initialization
  DevStatusBar := TDevStatusBar.Create(Application);



end.

