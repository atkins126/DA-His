unit App_DevWizard;

{
  �򵼿�
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
  ExtCtrls,
  StdCtrls,
  Buttons,
  App_DevExpress,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxLayoutContainer,
  dxLayoutControl,
  dxLayoutControlAdapters,
  Menus,
  cxButtons;

type

  {
     �򵼽ӿ�

     1 ÿִ����һ��Ӧ���ú��Լ���״̬���Ա��������½���
     2 ����3����1��n-2��׼���׶Σ�n-1����ִ�н׶Σ���n����ʾ�����
     3 ��ִ�н׶���������Container.RefreshInterface
  }
  IWizard = interface
    ['{53BE1CB6-63FC-4207-96CE-E069C5C75ABF}']
    //����Container���������Լ���ʼ����Ĵ�С
    function GetWizardControl(): TControl;
    function GetWizardTitle(): string;
    function GetStepCount(): Integer;
    function GetCurrStep(): Integer;
    function GetCurrHint(): string;
    function GetCanCancel(): Boolean;
    function GetIsSuccess(): Boolean;


    procedure DoFirst();    // Container�ڿ�ʼ��ʱ����
    procedure DoPre();
    procedure DoNext();
    procedure DoCancel(); 

    //Container���������������ý���
    property WizardControl: TControl read GetWizardControl;
    property WizardTitle: string read GetWizardTitle;
    property StepCount: Integer read GetStepCount;
    property CurrentStep: Integer read GetCurrStep;
    property CurrentHint: string read GetCurrHint;
    property IsSuccess: Boolean read GetIsSuccess; // �����Ƿ�ִ�гɹ���־
    property CanCancel: Boolean read GetCanCancel; // ��ִ�й������Ƿ��ȡ��
  end;

  {
     ������
    1. ����ÿִ��һ��Ӧ��֤ˢ��һ�£���Wizard״̬ͬ��;
    2  ���һ���Զ���ʾ��ɰ�ť��������2���Զ���ʾִ�а�ť
  }
  IWizardContainer = interface
    // ����ִ�й����в�ѯ�˺���    
    function GetCancelClicked: Boolean;
    //�����Wizard�����ڽ�����, ������Wizard���������ñ���, ��С��
    procedure RefreshInterface();
    function ExecuteWizard(Wizard: IWizard): Boolean;
    property CancelClicked: Boolean read GetCancelClicked;
  end;

  TWizardContainer = class(TForm, IWizardContainer)
    lblStep: TLabel;
    lblHint: TLabel;
    WizardImage: TImage;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    IconItem: TdxLayoutItem;
    HeaderGroup: TdxLayoutGroup;
    DescriptionItem: TdxLayoutItem;
    CancelButton: TcxButton;
    CancelItem: TdxLayoutItem;
    ButtonGroup: TdxLayoutGroup;
    NextButton: TcxButton;
    NextItem: TdxLayoutItem;
    PreButton: TcxButton;
    PreItem: TdxLayoutItem;
    WizardItem: TdxLayoutItem;
    ExecButton: TcxButton;
    ExecItem: TdxLayoutItem;
    procedure PreButtonClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExecButtonClick(Sender: TObject);
  private
    { Private declarations }
    FCancelClicked: Boolean;
    FWizard: IWizard;
  protected
    procedure SetButton();
    procedure SetHint();
    function GetCancelClicked(): Boolean;
    procedure RefreshInterface();
    function ExecuteWizard(AWizard: IWizard): Boolean;
  public
    { Public declarations }
  end;

function GetWizardContainer(): IWizardContainer;

implementation

var
  WizardContainer: TWizardContainer;

{$R *.dfm}

function GetWizardContainer(): IWizardContainer;
begin
  if WizardContainer = nil then
    WizardContainer := TWizardContainer.Create(nil);
  Result := WizardContainer;
end;

function TWizardContainer.ExecuteWizard(AWizard: IWizard): Boolean;
var
  OldParent: TWinControl;
begin
  FCancelClicked := False;
  FWizard := AWizard;
  OldParent := AWizard.WizardControl.Parent;
  with FWizard do
  begin
    ClientWidth := WizardControl.Width;
    ClientHeight := WizardControl.Height + 100;
    Caption := WizardTitle;
    WizardControl.Parent := Self;
    WizardControl.Visible := True;
  end;
  WizardItem.Control := FWizard.WizardControl;
  FWizard.DoFirst;
  RefreshInterface;
  Result := ShowModal = mrOK;
  FWizard := nil;
  AWizard.WizardControl.Visible := False;
  WizardItem.Control := nil;
  AWizard.WizardControl.Parent := OldParent;
end;

procedure TWizardContainer.PreButtonClick(Sender: TObject);
begin
  try
    FWizard.DoPre;
  finally
    RefreshInterface;
  end;
end;

procedure TWizardContainer.NextButtonClick(Sender: TObject);
begin
  try
    FWizard.DoNext;
  finally
    RefreshInterface;
  end;
end;

procedure TWizardContainer.btnCancelClick(Sender: TObject);
begin
  if FWizard.CurrentStep < FWizard.StepCount - 2 then
    ModalResult := mrCancel
  else begin
    FCancelClicked := True;
  end;
end;

procedure TWizardContainer.SetButton;
begin
  with FWizard do
  begin
    // |0,1,2,3...StepCount-4,StepCount-3|StepCount-2|StepCount-1
    // |׼��                             |ִ��       |���
    PreButton.Enabled := (CurrentStep > 0) and (CurrentStep < StepCount - 2);
    NextButton.Enabled := (CurrentStep >= 0) and (CurrentStep < StepCount - 3);
    ExecItem.Enabled := CurrentStep in [StepCount - 3, StepCount - 1];
    if (CurrentStep = StepCount - 1) then
      ExecButton.Caption := '���'
    else
      ExecButton.Caption := 'ִ��';
    CancelButton.Enabled := (CurrentStep < StepCount - 2) or
      (CanCancel and (CurrentStep = StepCount - 2));
  end;
end;

procedure TWizardContainer.SetHint;
begin
  with FWizard do
  begin
    lblStep.Caption := IntToStr(StepCount) + '.' + IntToStr(CurrentStep);
    lblHint.Caption := CurrentHint;
  end;
end;

procedure TWizardContainer.FormShow(Sender: TObject);
begin
  FWizard.DoFirst;
end;

procedure TWizardContainer.RefreshInterface;
begin
  SetHint;
  SetButton;
  Application.ProcessMessages;
end;

procedure TWizardContainer.ExecButtonClick(Sender: TObject);
begin
  if FWizard.CurrentStep = FWizard.StepCount - 3 then
    NextButton.Click
  else
  begin
    if FWizard.IsSuccess then ModalResult := mrOk
    else ModalResult := mrCancel;
  end;  
end;

function TWizardContainer.GetCancelClicked: Boolean;
begin
  Result := FCancelClicked;
end;

initialization

finalization
  FreeAndNil(WizardContainer);

end.

