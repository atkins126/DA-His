unit HisClient_XNHUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, App_Function;


type
  TVar = array of Variant;
  TVarArray = array of array of Variant;

 T_XNH_01 =  Record  //������Ϣ
    CoopmedCode : String; //0�����
    PersonOrder : String; //1��Ա���
    AreaCode : String;     //2 ��������
    PersonName : String;   // 3��Ա����
    Ime_PY : String; //4ƴ����
    Ime_WB :String; //5�����
    Sex : String; //6�Ա�
    BirthDay : String; //7��������
    HomeAdrress : String; //8 ��ͥסַ
    RelationNameCode : String; //9������ϵ����
    RelationName : String; //10������ϵ����
    PersonCode : String; //11���֤��
    OpPersonCode : String;//12 �а��˴���
    OpPersonName : String; //13�а�������
    HouseType : String; //14 ������//  [1��һ��ũ����2���屣����3��ƶ������4����������5���Ҿ�����9��������24��ʾ�����屣������������]
    HouseHolder : String; //15�Ƿ���//  [1���ǣ�2����]
    HouseIsXHN : String; //16�Ƿ�κ� //[1���ǣ�2����]
    HouseState : String; //17��Ա״̬//[1��������2��Ǩ�룻4��Ǩ����4������]
    KindDay : String; //18�춯����
    InXHNYear : String; //19�κ����
    Holder20 : String;  //20����
    Holder21 : String; //21 ����
    Holder22 : String; //22 ����
    Holder23 : String; //23 ����
    Holder24 : String; //24 ����
    Holder25 : String; //25 ����
    Holder26 : String; //26 ����
 end;


Type
  T_XNH_02 =  Record          //��Ժ�Ǽ�
    AsOrganID	: String;       //��������
    AsAreaCode : string;      //������������(ʡ��ת����)
    AsCoopMedCode : String;   //�����
    AsExpressionsID	: String; //������ʽID
    AsPatientName	: String;   //��Ժ��������
    AiIDNo: Integer;          //���������
   //AiDiagNo : Integer:       //��ҽ���
    AsTurnID : Integer;       //ת�����
    AsIllCode:String;         //��Ժ���(�Ϲܰ��ṩ�ļ�������)
    AsIllName	: String;       //��Ժ���(�Ϲܰ��ṩ�ļ�������)
    AInDate	: TDatetime;      //��Ժ����
    Adke : String;            //�۶�
    AdLimitDef : String;      //�޶��(0�����ޣ�1���޶2������
    AsDoctorName : String;    //����ҽ��
    AsPatientId	: String;     //סԺ��
    AsFlag : String;          //����Ժ�����޸�סԺ��Ϣ
    AiDiagNo : String;        //�������
    AsExpenseKind	: String;   //21--סԺ����
    AsLimitIllCode : String;  //�����ּ�������
    DataBuffer: String;       //����ֵ
    AsBrithday : String;      //��������
    AsPersonCode : String;    //���֤�� 
  end;

Type
  T_XNH_03 =  Record        //������ϸ¼��
    AsOrganID:String;     //��������
    AsCoopMedCode:String; //����ҽ��֤��
    AiIDNo:Integer;        //���������
    AiDiagNo:Integer;      //��ҽ���
    AsItemCode:String;    //�º���Ŀ����
    AsHosCode:String;    //ҽԺ��Ŀ����
    ADInputDate : TDateTime;   //¼��ʱ��
    AfPrice	: Double;      //����
    AfNum : Double;        //����
    AfFee	: Double;        //���
    AsUnit : String;      //��λ��
    AsOfficeName: String;//��������
    AsDoctor: String;    //ҽ��
    AsCompound: String;  //��/������������
    DataBuffer: String;    //
   end;

Type
  T_XNH_04 =  Record          //��ũ�ϲ��˽��㡢Ԥ����
    AsOrganID	 : String;      //��������
    AsCoopMedCode	: String;  //����ҽ��֤��
    AiIDNo: Integer;       //���������
    AiDiagNo	: Integer;     //��ҽ���
    APreClearFlag	 : Integer; //Ԥ/������£�0-Ԥ���㣬1-���㣩
    ADayCount : Integer;     //סԺ����
    AOutDate	: TDatetime;   //��Ժʱ��
    AJsDate	: TDatetime;     //����ʱ��
    AOutStatus	: String;    //��Ժ״̬��1��������2����ת��3��δ����4��������9������)
    ATotalPrice : Currency;  //���ý��
    ACanPrice : Currency;    //�ɱ�������
    APrice : Currency;       //��������
    DataBuffer :	String;
   end;

Type
  T_XNH_05 =  Record          //ȡ��סԺ����
   AsOrganID	: String;       //��������
   AsCoopMedCode : String;    //����ҽ��֤��
   AiIDNo	: Integer;          //���������
   AiDiagNo	: Integer;        //��ҽ���
   DataBuffer	: String;       //
end;


Type
  T_XNH_06 =  Record          //��ȡסԺ������Ϣ����������
    AsOrganID	: String;       //��������
    AsCoopMedCode	: String;   //����ҽ��֤��
    AiIDNo	: Integer;        //���������
    AiDiagNo	: Integer;      //��ҽ���
    DataBuffer	: String;     //
   end;

Type
  T_XNH_07 =  Record          //ȡ����Ժ�Ǽ�
    AsOrganID	: String;       //��������
    AsCoopMedCode	: String;   //����ҽ��֤��
    AiIDNo	: Integer;        //���������
    AiDiagNo	: Integer;      //��ҽ���
    DataBuffer	: String;     //
   end;

Type
  T_XNH_08 =  Record          //��ʡũ�Ͽ�
    AsAreaID	: String;       //��������
    AsCardID	: String;       //����
    DataBuffer	: String;     //������ų��ȴ��� 10 ʱ ��ǰ6 λ Ϊ�������������ţ��ӵ���λ��ʼΪ����
   end;

Type
  T_XNH_09 =  Record          //��ȡת�ﲡ����Ϣ
    AsGrade  :String;         //ת�������ȼ� '1' ʡ�� '2' ��(��)��
    AsOrganID	: String;       //��������
    AsAreaID	: String;       //������������
    AsCardID	: String;       //����
    AsCoopmedcode : String;   //ũ��֤��
    AsIDNo  : String;         //�������
    DataBuffer	: String;     //������ų��ȴ��� 10 ʱ ��ǰ6 λ Ϊ�������������ţ��ӵ���λ��ʼΪ����
   end;


//Dll Info
function InitDLL(StrError:pchar):integer;stdcall;external 'LxClient.dll';
function GetHzPersonInfo(AsOrganID:pchar;AsCoopMedCode:pchar;DataBuffer:pchar):Integer; stdcall;external 'LxClient.dll';


function SaveInHosInfo(AsOrganID : pchar; AsCoopMedCode :pchar; AsExpressionsID : pchar; AsPatientName:pchar; AiIDNo: Integer;
                       AsIllCode : pchar; AsIllName: pchar; AInDate: pchar; Adke: pchar;AdLimitDef: pchar; AsDoctorName: pchar;
                       AsPatientid : pchar; Asflag : pchar; AiDiagNo: pchar; AsExpenseKind : PChar;
                       AsLimitIllCode :PChar; DataBuffer:pchar): Integer; stdcall; external 'LxClient.dll';
function SaveFreeList(AsOrganID :pchar; AsCoopMedCode:pchar;AiIDNo : Integer ; AiDiagNo : Integer;
                      AsItemCode : pchar; AsHosCode : pchar; ADInputDate: pchar;
                      AfPrice : Double; AfNum : Double; AfFee : Double;
                      AsUnit :pchar; AsOfficeName : pchar; AsDoctor : pchar; AsCompound: pchar;
                      DataBuffer: pchar): Integer; stdcall;external 'LxClient.dll';
//��ȡת�������Ϣ                      
function GetParmItem(AsOrganID:pchar;AsKind:pchar;DataBuffer:pchar):Integer; stdcall; external 'LxClient.dll';
function GetCheckItem(AsOrganID:pchar):Integer; stdcall; external 'LxClient.dll';
function PreClearing(AsOrganID, AsCoopMedCode: pchar; AiIDNo, AiDiagNo, APreClearFlag: Integer; ADayCount: Integer;
                     AOutDate, AJsDate, AOutStatus,DataBuffer : pchar): Integer; stdcall;external 'LxClient.dll';
function GetCalcFee(AsOrganID, AsCoopMedCode: pchar;AiIDNo, AiDiagNo:integer;DataBuffer:pchar): Integer; stdcall; external 'LxClient.dll';
function CanceCalcFee(AsOrganID :pchar;AsCoopMedCode:pchar;AiIDNo : Integer; AiDiagNo:Integer;DataBuffer:pchar): Integer; stdcall; external 'LxClient.dll';
function DeleteHosInfo(AsOrganID :pchar;AsCoopMedCode : pchar; AiIDNo : Integer;AiDiagNo : Integer;DataBuffer : pchar):Integer; stdcall; external 'LxClient.dll';
function TestComConn(ComI:Integer):Integer; stdcall;external 'LxClient.dll';
function zzUser_ReadCard(COMI: integer; rData: PChar):Integer; stdcall;external 'LxClient.dll';
function GetCoopMedCodeByCardID(aOrganID, aCardID: PChar; DataBuffer: PChar): Integer;stdcall;external 'LxClient.dll';
function zzGetCoopMedCodeByCardID(aOrganID,aAreaCode,aCardID:PChar;DataBuffer:PChar): Integer;stdcall;external 'LxClient.dll';
function GetZzinfo_zz(aGrade, aAreaCode: pchar; DataBuffer: pchar): Integer; stdcall;external 'LxClient.dll';
function DeleteFeeList(AsOrganID, AsCoopMedCode: pchar; AiIDNo, AiDiagNo: integer;
DataBuffer: pchar): Integer; stdcall;external 'LxClient.dll';
//����ʡ��ת����Ժ
function zzSaveInHosInfo(AsOrganID, aAreaCode, AsCoopMedCode, AsExpressionsID: pchar;AiIDNo, aTurnID: Integer;
                         AsIllCode, AsIllName, AInDate, Adke, AdLimitDef, AsDoctor, AsPatientId, AsExpenseKind,AsLimitIllCode,
                         DataBuffer: Pchar): Integer; stdcall; external 'LxClient.dll';


//�ڲ�����
//����ũ�����鷵��<>
//�ֽⷵ��ֵ
function ExChangeXNHText(DataBuffer : Pchar; FCount : Integer) : TVarArray;
//�ֽⷵ��ֵ
function ExChangeText(DataBuffer : Pchar; FCount : Integer; TextKind : string = '|') : TVar; overload;
function ExChangeText(DataBuffer : Pchar; TextKind : string = '|') : TVarArray; overload;
function ExChangeText(DataBuffer : Pchar; LineKind : string = '##'; TextKind : String ='@@') : TVarArray; overload;


//��̬���ӿ��ʼ��
function XNH_Init : Boolean;
//��ȡ������Ϣ
function XNH_GetHzPersonInfo(AsOrganID : String; AsCoopMedCode: String;
          ModifySign : Boolean=True) : Boolean;
//��Ժ���˵Ǽ�
function XNH_SaveInHosInfo : Boolean;
//ȡ����Ժ���˵Ǽ�
function XNH_DeleteInHosInfo : Boolean;
//������˻�����Ϣ����
procedure XNH_ClearInHospInfo;
//������ϸ¼��
function XNH_SaveFreeList : Boolean;
//��ũ�ϲ��˽��㡢Ԥ����
function XNH_OutReg(var RFile : TVar) : Boolean;
//��ũ�ϲ���ȡ������
function XNH_CancelOutReg : Boolean;
//ָ����ũ����Ժ��Ϣ
function XNH_GetInHosoInfo(InHospID : Integer) : Boolean;
//��ȡסԺ������Ϣ
function XNH_GetCalcFee : Boolean;
//���Զ�����
function XNH_TestComConn(ComID : Integer) : Boolean;
//��ȡˢ����Ϣ�����ܻ�ÿ���
function XNH_zzUser_ReadCard(COMI: integer):Boolean;
//���ݿ��Ż��ũ��֤��
function XNH_ZZGetCoopMedCodeByCardID(DefaultOrgerID:string;GradeID : String):Boolean;
//��ȡת�ﲡ����Ϣ(ʡ��1�����м�2)
function XNH_GetZzinfo_zz:Boolean;
// ��ȡת�������Ϣ
function XNH_GetParmItem : Boolean;
//ʡ��ת����Ժ���˵Ǽ�
function XNH_zzSaveInHosInfo : Boolean;



var
  G_NHOrganID : String;                    //��ũ������ID
  G_NHCoopMedCode : String;                //����ҽ��֤��
  G_NHIDNo : Integer;                      //���������
  G_NHDiagNo : Integer;                    //��ҽ���
  G_NHInHosp : T_XNH_02;                   //��ũ����Ժ��Ϣ
  G_NHCurrInHosp : T_XNH_02;               //ָ����ũ����Ժ��Ϣ
  G_NHDeteleInHosp : T_XNH_07;             //ȡ����ũ����Ժ��Ϣ
  G_NHFeeDetail : T_XNH_03;
  G_NHBalance : T_XNH_04;                  //ũ�Ͻ���
  G_NHReadCardID : T_XNH_08;               //������Ϣ
  G_NHZZInfo : T_XNH_09;                   //ʡũ��ת����Ϣ
  // G_NHPubInfo : T_XNH_06;               //ũ�Ϲ���������Ϣ(����)


implementation


function ExChangeXNHText(DataBuffer : Pchar; FCount : Integer) : TVarArray;
Var I,RCount : Integer;
    S ,S1: String;
    FStrPos : Array of Integer;
    RCountStr : Array of String;  //��¼��
begin

 S := PChar(DataBuffer);
 S := Trim(S) + '$$|';
 RCount := 0;
//��$$���зֽ�
 while Pos('$$|',S) > 1 do
 begin
   SetLength(RCountStr,RCount+1);
   RCountStr[RCount]:= Copy(S,1,Pos('$$|',S)-1);
   S := Copy(S,Pos('$$|',S)+3,(length(S)+3-Pos('$$|',S)));
   Inc(RCount);
 end;

 // ShowOK(InttoStr(RCount));
 //��|�Էֽ��н��в��
   SetLength(Result,RCount,FCount); //�Է���ֵ�����б�����
 for RCount := Low(RCountStr) to High(RCountStr) do
   begin
     //if (Copy(S,I,1) = '|') and (I <> 1) then  //��һ���ַ�����Ϊ"|"
      S := RCountStr[RCount];
      for I := 0 to FCount - 1 do
      begin
        Result[RCount,I] := Copy(S,1,Pos('|',S)-1);
        S := Copy(S,Pos('|',S)+1,(length(S)-Pos('|',S)));
      end;
   end;

end;


function ExChangeText(DataBuffer : Pchar; FCount : Integer; TextKind : string = '|') : TVar;
Var I,RCount,TextLength : Integer;
    S ,S1,Kind: String;
    FStrPos : Array of Integer;
    RCountStr : Array of String;  //��¼��
begin
  //1
  S := PChar(DataBuffer);
  Kind := TextKind;
  TextLength := Length(TextKind);
  S := Trim(S) + TextKind;
  SetLength(Result,0);
  SetLength(Result,FCount); //�Է���ֵ�����б�����
  for I := Low(Result) to High(Result) do
   begin
     Result[I] := Trim(Copy(S,TextLength,Pos(TextKind,S)-TextLength));
     S := Copy(S,Pos(TextKind,S)+TextLength,(length(S)-Pos(TextKind,S)));
   end;
end;


function ExChangeText(DataBuffer : Pchar; TextKind : string = '|') : TVarArray; overload;
Var I,RCount,TextLength : Integer;
    S ,S1,Kind: String;
    FStrPos : Array of Integer;
    RCountStr : Array of String;  //��¼��
begin
 try
   //2
  S := PChar(DataBuffer);
  //ȥ�� Chr(13)
  while Pos(Chr(13),S) > 1 do
  begin
    I := Pos(Chr(13),S);
    Insert('|',S,Pos(Chr(13),S));
    Delete(S,I+1,Length(Chr(13)));
    //'��1500��5000����        @@3500@@55%@@1925
    // ||��5000��999999����      @@33023.8021@@60%@@19814.2813
    //|| || || || || ##������ʽ������ȷⶥ�ߣ�17158.71Ԫ'
  end;

  //��||���зֽ�
  Kind := '|';
  TextLength := Length(Kind);
  S := S + Kind;
  RCount := 0;
 while Pos(Kind,S) > 1 do
 begin
   SetLength(RCountStr,RCount+1);
   RCountStr[RCount]:= Copy(S,1,Pos(Kind,S)-1);
   S := Copy(S,Pos(Kind,S)+TextLength,(length(S)+TextLength-Pos(Kind,S)));
   Inc(RCount);
 end;

  //��@@�Էֽ��н��в��
 SetLength(Result,RCount,4); //�Է���ֵ�����б�����
 Kind := '@@';
 TextLength := Length(Kind);
 for RCount := 0 to RCount - 1 do
   begin
      S := RCountStr[RCount]+Kind;
      for I := 0 to 3 do
      begin
        Result[RCount,I] := Trim(Copy(S,1,Pos(Kind,S)-TextLength+1));
        S := Copy(S,Pos(Kind,S)+TextLength,(length(S)-Pos(Kind,S)));
      end;
   end;
 except
  ShowError('�۷ֹ�ʽ����!');
 end;

end;


function ExChangeText(DataBuffer : Pchar; LineKind : string = '##'; TextKind : string ='@@') : TVarArray; overload;
Var I,RCount,TextLength : Integer;
    S ,S1,Kind: String;
    FStrPos : Array of Integer;
    RCountStr : Array of String;  //��¼��
begin
 try
   //3
  S := PChar(DataBuffer);
  //ȥ�� Chr(13)
 { while Pos(Chr(13),S) > 1 do
  begin
    I := Pos(Chr(13),S);
    Insert('|',S,Pos(Chr(13),S));
    Delete(S,I+1,Length(Chr(13)));
    //'��1500��5000����        @@3500@@55%@@1925
    // ||��5000��999999����      @@33023.8021@@60%@@19814.2813
    //|| || || || || ##������ʽ������ȷⶥ�ߣ�17158.71Ԫ'
  end;  }

  //��##���зֽ�  ����
  Kind := LineKind;
  TextLength := Length(Kind);
  S := S + Kind;
  S := Trim(S);
  RCount := 0;
  while Pos(Kind,S) > 0 do
  begin
   SetLength(RCountStr,RCount+1);
   RCountStr[RCount]:= Copy(S,1,Pos(Kind,S)-1);
   S := Copy(S,Pos(Kind,S)+TextLength,(length(S)+TextLength-Pos(Kind,S)));
   Inc(RCount);
  end;

  //��@@�Էֽ��н��в��  ����
 SetLength(Result,RCount,4); //�Է���ֵ�����б�����
 Kind := TextKind;
 TextLength := Length(Kind);
 for RCount := 0 to RCount - 1 do
   begin
      S := RCountStr[RCount]+Kind;
      for I := 0 to 3 do
      begin
        Result[RCount,I] := Trim(Copy(S,1,Pos(Kind,S)-TextLength+1));
        S := Copy(S,Pos(Kind,S)+TextLength,(length(S)-Pos(Kind,S)));
      end;
   end;
 except
  ShowError('�۷ֹ�ʽ����!');
 end;

end;

function XNH_Init : Boolean;
Var OutPchar : PChar;
begin
try
  GetMem(OutPchar,1024);
 if InitDLL(OutPchar) <> 0 then
   begin
    ShowError('ũ��ǰ�û���������:'+Pchar(OutPchar));
    Result := False;
   end
   else
    Result := True;
finally
  FreeMem(OutPchar);
end;

end;


function XNH_GetHzPersonInfo(AsOrganID : String; AsCoopMedCode: String; ModifySign : Boolean) : Boolean;
Var OutPchar : PChar;
    ReList : TVarArray;
    RCount,I ,J: Integer;
    S : String;
begin
  try
     Result := False;
     GetMem(OutPchar,2024);
     XNH_Init;
    if GetHzPersonInfo(PChar(AsOrganID),Pchar(AsCoopMedCode),OutPchar) <> 0 then
     begin
       ShowError(Pchar(OutPchar));
       //FreeMem(OutPchar);
       Exit;
     end;

     ReList := ExChangeXNHText(OutPchar,27);

    if ModifySign then  //�޸����ݿ��е�����
      begin
       S := 'Delete from XNH_PersonInfo where CoopmedCode = '''+AsCoopMedCode+''''+
            ' and  AreaCode = '''+ AsOrganID+'''';
//       Dm.PubQryExec1(S);
      end;

//       with Dm_Xnh.Q_XNH_PersonInfo do
//       begin
//         if Active then Active := false;
//         Parameters.ParamByName('CoopmedCode').Value := AsCoopMedCode;
//         Parameters.ParamByName('AreaCode').Value := AsOrganID;
//         Active := True;
//
//          for J := Low(ReList) to High(ReList) do
//          begin
//            Append;
//             for I := 0 to 25 do
//              begin
//               Fields[I+1].Value := Trim(ReList[J,I]);
//              end;
//            Post;
//           end;
//         UpdateBatch(arAll);
//       end;

     Result := True;

  finally
     //FreeMem(OutPchar);
  end;
end;



function XNH_SaveInHosInfo : Boolean;
Var OutPchar : PChar;
begin
      Result := False;
      GetMem(OutPchar,1024);
  if  SaveInHosInfo(PChar(G_NHInHosp.AsOrganID),
                    PChar(G_NHInHosp.AsCoopMedCode),
                    PChar(G_NHInHosp.AsExpressionsID),
                    PChar(G_NHInHosp.AsPatientName),
                    G_NHInHosp.AiIDNo,
                    PChar(G_NHInHosp.AsIllCode),
                    PChar(G_NHInHosp.AsIllName),
                    PChar(FormatDateTime('YYYY-MM-DD HH:MM:SS',G_NHInHosp.AInDate)),
                    PChar(G_NHInHosp.Adke),
                    PChar(G_NHInHosp.AdLimitDef),
                    PChar(G_NHInHosp.AsDoctorName),
                    PChar(G_NHInHosp.AsPatientId),
                    PChar(G_NHInHosp.AsFlag),
                    PChar(G_NHInHosp.AiDiagNo),
                    PChar(G_NHInHosp.AsExpenseKind),
                    PChar(G_NHInHosp.AsLimitIllCode),
                    OutPchar) <> 0 then
         begin
          ShowError(Pchar(OutPchar));
          Exit;
         end;
      G_NHInHosp.DataBuffer := PChar(OutPchar);
      Result := True;
end;


function XNH_DeleteInHosInfo : Boolean;
Var OutPchar : PChar;
begin
    Result := False;
    GetMem(OutPchar,1024);
    if DeleteHosInfo(PChar(G_NHDeteleInHosp.AsOrganID),
                     PChar(G_NHDeteleInHosp.AsCoopMedCode),
                           G_NHDeteleInHosp.AiIDNo,
                           G_NHDeteleInHosp.AiDiagNo,
                           OutPchar) <> 0 then
       begin
        ShowError(Pchar(OutPchar));
        Exit;
       end;
    Result := True;
end;


procedure XNH_ClearInHospInfo;
begin
G_NHInHosp.AsOrganID := '';
G_NHInHosp.AsCoopMedCode := '';   //�����
G_NHInHosp.AsExpressionsID := ''; //������ʽID
G_NHInHosp.AsPatientName := '';   //��Ժ��������
G_NHInHosp.AiIDNo := 0;          //���������
G_NHInHosp.AsIllCode := '';       //��Ժ���(�Ϲܰ��ṩ�ļ�������)
G_NHInHosp.AsIllName := '';       //��Ժ���(�Ϲܰ��ṩ�ļ�������)
G_NHInHosp.AInDate := date;      //��Ժ����
G_NHInHosp.Adke := '';            //�۶�
G_NHInHosp.AdLimitDef := '';      //�޶��(0�����ޣ�1���޶2������
G_NHInHosp.AsDoctorName := '';    //����ҽ��
G_NHInHosp.AsPatientId := '';     //סԺ��
G_NHInHosp.AsFlag := '0';         //����Ժ�����޸�סԺ��Ϣ
G_NHInHosp.AiDiagNo := '';        //�������
G_NHInHosp.AsExpenseKind	:= '';  //21--סԺ����
G_NHInHosp.AsTurnID := 0;         //ת����� (ʡ��ת��)
G_NHInHosp.DataBuffer := '';      //����ֵ

end;



//������ϸ¼��
function XNH_SaveFreeList : Boolean;
Var I,J : Integer;
    OutPchar : PChar;
begin
   Result := False;
   GetMem(OutPchar,1024);
  // for I := Low(G_NHFeeDetail) to High(G_NHFeeDetail) do
  // begin
    if SaveFreeList(PChar(G_NHFeeDetail.AsOrganID),
                    PChar(G_NHFeeDetail.AsCoopMedCode),
                    G_NHFeeDetail.AiIDNo,
                    G_NHFeeDetail.AiDiagNo,
                    PChar(G_NHFeeDetail.AsItemCode),
                    PChar(G_NHFeeDetail.AsHosCode),
                    PChar(FormatDateTime('YYYY-MM-DD HH:MM:SS',G_NHFeeDetail.ADInputDate)),
                    G_NHFeeDetail.AfPrice,
                    G_NHFeeDetail.AfNum,
                    G_NHFeeDetail.AfFee,
                    PChar(G_NHFeeDetail.AsUnit),
                    PChar(G_NHFeeDetail.AsOfficeName),
                    PChar(G_NHFeeDetail.AsDoctor),
                    PChar(G_NHFeeDetail.AsCompound),
                    OutPchar) <> 0 then
      begin
        ShowError(Pchar(OutPchar));
        ShowError('��ţ�'+G_NHFeeDetail.AsHosCode+','+G_NHFeeDetail.DataBuffer);
        Exit;
       end;
 //  end;
    Result := True;
end;


//��ũ�ϲ��˽��㡢Ԥ����
function XNH_OutReg(var RFile : TVar) : Boolean;
Var OutPchar : PChar;
begin
    Result := False;
    GetMem(OutPchar,1024);
    if PreClearing(PChar(G_NHBalance.AsOrganID),
                   PChar(G_NHBalance.AsCoopMedCode),
                   G_NHBalance.AiIDNo,
                   G_NHBalance.AiDiagNo,
                   G_NHBalance.APreClearFlag,
                   G_NHBalance.ADayCount,
                   PChar(FormatDateTime('YYYY-MM-DD HH:MM:SS',G_NHBalance.AOutDate)),
                   PChar(FormatDateTime('YYYY-MM-DD HH:MM:SS',G_NHBalance.AJsDate)),
                   PChar(G_NHBalance.AOutStatus),
                   OutPchar) <> 0 then
      begin
        ShowError(Pchar(OutPchar));
        Exit;
       end;

    G_NHBalance.DataBuffer := Pchar(OutPchar);
    RFile := ExChangeText(Pchar(OutPchar),10);
    Result := True;
end;



//��ũ�ϲ���ȡ������
function XNH_CancelOutReg : Boolean;
Var OutPchar : PChar;
begin
    Result := False;
    GetMem(OutPchar,1024);
   if CanceCalcFee(PChar(G_NHBalance.AsOrganID),
                   PChar(G_NHBalance.AsCoopMedCode),
                   G_NHBalance.AiIDNo,
                   G_NHBalance.AiDiagNo,
                   OutPchar) <> 0 then
      begin
        ShowError(Pchar(OutPchar));
        Exit;
       end;

    G_NHBalance.DataBuffer := Pchar(OutPchar);

    Result := True;


    if ShowYesNo('��ȷ��ɾ����ǰ�������ϴ���¼��?') then
      begin
       if DeleteFeeList(PChar(G_NHBalance.AsOrganID),
                        PChar(G_NHBalance.AsCoopMedCode),
                        G_NHBalance.AiIDNo,
                        G_NHBalance.AiDiagNo,OutPchar) <> 0 then
          begin
            ShowError(Pchar(OutPchar));
            Exit;
          end
          else ShowOK('�������ϴ���¼ɾ���ɹ���');
      end;
end;    



//ָ����ũ����Ժ��Ϣ
function XNH_GetInHosoInfo(InHospID : Integer) : Boolean;
Var S : string;
begin
 Result := False;
 S := 'Select * from XNH_InHosp where InHospID = ' + IntToStr(InHospID);
// Dm.PubQry2(S);
//
// if Dm.PubQuery2.RecordCount <= 0 then
//   begin
//     ShowWarning('��ǰũ�ϲ�����Ժ��Ϣ�����ڣ���˶Ժ����룡');
//     Exit;
//   end;
//
// with Dm.PubQuery2 do
// begin
//   G_NHCurrInHosp.AsOrganID := FieldByName('AsOrganID').AsString;
//   G_NHCurrInHosp.AsCoopMedCode := FieldByName('AsCoopMedCode').AsString;
//   G_NHCurrInHosp.AsExpressionsID := FieldByName('AsExpressionsID').AsString;
//   G_NHCurrInHosp.AsPatientName := FieldByName('AsPatientName').AsString;
//   G_NHCurrInHosp.AiIDNo := FieldByName('AiIDNo').AsInteger;
//   G_NHCurrInHosp.AsIllCode := FieldByName('AsIllCode').AsString;
//   G_NHCurrInHosp.AsIllName := FieldByName('AsIllName').AsString;
//   G_NHCurrInHosp.AInDate := FieldByName('AInDate').AsDateTime;
//   G_NHCurrInHosp.Adke := FieldByName('Adke').AsString;
//   G_NHCurrInHosp.AdLimitDef := FieldByName('AdLimitDef').AsString;
//   G_NHCurrInHosp.AsDoctorName := FieldByName('AsDoctorName').AsString;
//   G_NHCurrInHosp.AsPatientId := FieldByName('AsPatientId').AsString;
//   G_NHCurrInHosp.AsFlag := FieldByName('AsFlag').AsString;
//   G_NHCurrInHosp.AiDiagNo := FieldByName('AiDiagNo').AsString;
//   G_NHCurrInHosp.AsExpenseKind := FieldByName('AsExpenseKind').AsString;
//   G_NHCurrInHosp.DataBuffer := FieldByName('DataBuffer').AsString;
// end;

 Result := True;

end;


//��ȡסԺ������Ϣ
function XNH_GetCalcFee : Boolean;
const LineText1 = '$$';
      LineText3 = '@@';

Var OutPchar : PChar;
    I,J,RCount : Integer;
    S ,S1: String;
    FStrPos : Array of Integer;
    RCountStr : Array of String;  //��¼��
    ReFileStr,ReFile : TVar;  //��¼�ֶ���Ϣ
    ReArrayFlieStr : TVarArray;
begin
  {
 1003001047|��ï��|��ï��|��||���˻���||�人�г�����Ժ|2010-11-02|2010-12-15|43||ǰ��������|4|12992.02|7870.79|4030.22|0||||||||$$##00|ҩƷ��|2670.44|847.435|0##01|סԺ��|221|195|0##02|һ�����|812.7|691.2|0##03|���ͼ���|216|108|0##04|������|4065|3915|0##05|���Ʒ�|1248.35|1081.41|0##06|���Ʒ�|459.5|171.5|0##07|����|3299.03|861.24|0$$##��0��999999����@@7870.785@@51%@@4014.1004##���һ���ҩ��@@322.427@@5%@@16.1214##########ͬһ����ͬһҽԺ���סԺ�������ߣ�'
  }
 try
    Result := False;
    GetMem(OutPchar,1024);
   if GetCalcFee(PChar(G_NHBalance.AsOrganID),
                 PChar(G_NHBalance.AsCoopMedCode),
                 G_NHBalance.AiIDNo,
                 G_NHBalance.AiDiagNo,
                 OutPchar) <> 0 then
      begin
        ShowError(Pchar(OutPchar));
        G_NHBalance.DataBuffer := '';
        Exit;
      end;
    G_NHBalance.DataBuffer := Pchar(OutPchar);

   //--------------------------------------------------------->>�ֽ��߶�
    S := PChar(G_NHBalance.DataBuffer);
    S := Trim(S) + LineText1;
    RCount := 0;
   //��$$���зֽ�
   while Pos(LineText1,S) > 1 do
   begin
     SetLength(RCountStr,RCount+1);
     RCountStr[RCount]:= Copy(S,1,Pos(LineText1,S)-1);
     S := Copy(S,Pos(LineText1,S)+2,(length(S)+2-Pos(LineText1,S)));
     Inc(RCount);
   end;

//   Dm_XNH.XNHClearOutHospInfo := G_CurrHospID; //��ս�����������Ϣ
//   //--------------------------------------------------------->>���µ�һ�߶�
//   ReFileStr := ExChangeText(PChar(RCountStr[0]),22,'|');
//   ReFileStr[11] := G_CurrHospID;
//
//   with Dm_XNH.Q_XNH_OutHospInfo1 do
//     begin
//       Append;
//       for I := Low(ReFileStr) to High(ReFileStr) do
//       begin
//         Fields.Fields[I].Value := IsNullRv(ReFileStr[I],null);
//       end;
//       Post;
//       UpdateBatch(arall);
//       G_NHBalance.ATotalPrice := FieldByName('TotalPrice').AsCurrency;
//       G_NHBalance.ACanPrice := FieldByName('CanPrice').AsCurrency;
//       G_NHBalance.APrice := FieldByName('Price').AsCurrency;
//     end;

   //--------------------------------------------------------->>���µڶ��߶�
   ReFileStr := ExChangeText(PChar(Copy(RCountStr[1],3,Length(RCountStr[1])-2)),8,'##');

   for I := Low(ReFileStr) to High(ReFileStr) do
       begin
         ReFile := ExChangeText(PChar(VarToStr(ReFileStr[I])),5,'|');
//         with Dm_XNH.Q_XNH_OutHospInfo2 do
//           begin
//             Append;
//             for J := Low(ReFile) to High(ReFile) do
//             begin
//               Fields.Fields[J+1].Value := ReFile[J];
//             end;
//             Fields.Fields[0].Value := G_CurrHospID;
//             Post;
//             UpdateBatch(arall);
//           end;
       end;

   //--------------------------------------------------------->>���µ����߶�
    ReArrayFlieStr := ExChangeText(PChar(RCountStr[2]),'##','@@');

//     with Dm_XNH.Q_XNH_OutHospInfo3 do
//     begin
//       Append;
//       for I := Low(ReArrayFlieStr) to High(ReArrayFlieStr) do
//       begin
//         if ReArrayFlieStr[I,0] <> '' then
//          begin
//           Append;
//           FieldByName('HospID').Value := G_CurrHospID;
//           FieldByName('Line').AsString := ReArrayFlieStr[I,0];
//           IF ReArrayFlieStr[I,1] = '' then
//             FieldByName('CanPrice').AsCurrency := 0
//            ELSE
//             FieldByName('CanPrice').AsString := IsNullRv(ReArrayFlieStr[I,1],'0');
//
//            IF ReArrayFlieStr[I,2] = '' then
//             FieldByName('CanRatio').AsString := '0%'
//            ELSE
//             FieldByName('CanRatio').AsString := IsNullRv(ReArrayFlieStr[I,2],'0');
//
//           //FieldByName('CanRatio').AsString := ReArrayFlieStr[I,2];
//
//           if ReArrayFlieStr[I,3] = '' then
//             FieldByName('Price').AsCurrency := 0
//            else
//             FieldByName('Price').AsString := IsNullRv(ReArrayFlieStr[I,3],'0');
//           Post;
//          end;
//         UpdateBatch(arall);
//      end;
//       if State in [dsEdit, dsInsert] then Post;
//       UpdateBatch(arall);
//     end;

    Result := True;
   except
    abort;
   end;

end;

function XNH_TestComConn(ComID : Integer) : Boolean;
begin
 if TestComConn(ComID) <>0 then
   begin
    ShowError('������Com��ָ��������������ΪCom4��');
    Result := False
   end
  else Result := True; 
end;

function XNH_zzUser_ReadCard(COMI : integer):Boolean;
var I : Integer;
 S: String;
 OutPchar : PChar;
begin
 if not XNH_TestComConn(COMI) then Exit;
 ShowWarning('��������������������');

try
  GetMem(OutPchar,1024);
 if zzUser_ReadCard(COMI,OutPchar) <> 0 then
   begin
    ShowError('������������:'+Pchar(OutPchar));
    G_NHReadCardID.DataBuffer := '';
    Result := False;
   end
   else
    begin
     S := Pchar(OutPchar);
     G_NHReadCardID.AsAreaID:= Trim(Copy(S,0,6));
     G_NHReadCardID.AsCardID := Trim(Copy(S,7,10));
     Result := True;
     ShowOK('�����ɹ���');
    end;
finally
  FreeMem(OutPchar);
end;
end;


function XNH_ZZGetCoopMedCodeByCardID(DefaultOrgerID:string;GradeID:String):Boolean;
var I : Integer;
 S: String;
 OutPchar,aAreaCode,aCardID,aOrganID : PChar;
 OutPut : TVar;
begin
try
 if GradeID = '3' then
   begin
    GradeID := '1';  //3Ϊ�Ƕ��� תΪ1ʡ��
   end
  else
   begin
    if not XNH_zzUser_ReadCard(4) then Exit;
   end; 

  aOrganID := PChar(DefaultOrgerID);
  aAreaCode := PChar(G_NHReadCardID.AsAreaID);
  aCardID := PChar(G_NHReadCardID.AsCardID);

//�ֹ���ʡũ��
 { aOrganID := PChar('420000');
  aAreaCode := PChar('420922');
  aCardID := PChar('116949');
 }
  GetMem(OutPchar,1024);
  //ʡ��ת��
 if (GradeID='1') and (zzGetCoopMedCodeByCardID(aOrganID,aAreaCode,aCardID,OutPchar) <> 0) then
   begin
    ShowError('������������:'+Pchar(OutPchar));
    Result := False;
   end
   //�м�
  else if (GradeID='2') and (GetCoopMedCodeByCardID(aOrganID,aCardID,OutPchar) <> 0) then
   begin
    ShowError('������������:'+Pchar(OutPchar));
    Result := False;
   end
 else
    begin
     S := Pchar(OutPchar);
     OutPut := ExChangeText(OutPchar,2,'|');
     //�ɹ���д��ת�ﲡ����Ϣ
     G_NHZZInfo.AsGrade := GradeID;     //ʡ��1 ,��(��)��2
     G_NHZZInfo.AsOrganID := aOrganID;
     G_NHZZInfo.AsAreaID :=  aAreaCode;
     G_NHZZInfo.AsCardID := aCardID;
     G_NHZZInfo.AsCoopmedcode := OutPut[0];    //�ºϺţ�
     G_NHZZInfo.AsIDNo := OutPut[1];           //������ţ�
     Result := True;
    end;
finally
  FreeMem(OutPchar);
end;

end;


function XNH_GetZzinfo_zz:Boolean;
var
 S: String;
 OutPchar,AsGrade,AsAreaCode: PChar;
 AsIDNo : Integer;
 ReList : TVarArray;
begin
try
  //if PutOutPchar <> nil then FreeMem(OutPchar);

  GetMem(OutPchar,10240);

 //G_NHZZInfo.AsGrade := '1';
 //G_NHZZInfo.AsOrganID :='420000';;
 //G_NHZZInfo.AsAreaID := '429901';
 //G_NHZZInfo.AsCoopmedcode :='0101010107';
 //G_NHZZInfo.AsIDNo := '1';

 AsGrade := PChar(G_NHZZInfo.AsGrade);
 AsAreaCode := PChar(Trim(G_NHZZInfo.AsOrganID)+'$$'+
               Trim(G_NHZZInfo.AsAreaID)+'$$'+
               Trim(G_NHZZInfo.AsCoopmedcode)+'$$'+
               Trim(G_NHZZInfo.AsIDNo));


{ AsOrganID := PChar(G_NHZZInfo.AsOrganID);
 AsAreaID := PChar(G_NHZZInfo.AsAreaID);
 AsCoopmedcode := PChar(G_NHZZInfo.AsCoopmedcode);
 AsIDNo  := StrToInt(G_NHZZInfo.AsIDNo);
 }
 if GetZzinfo_zz(AsGrade,AsAreaCode,OutPchar) <> 0 then
   begin
    ShowError('��ȡת�ﲡ����Ϣ:'+Pchar(OutPchar));
    Result := False;
   end
 else
    begin
     if OutPchar = nil then
       begin
        ShowError('���ݴ�����������ԣ�');
        Result := False;
        Exit;
       end;
     S := Pchar(OutPchar);
     ReList := ExChangeXNHText(OutPchar,19);
     G_NHInHosp.AsCoopMedCode :=ReList[0,0];       //0�ºϺ�
     G_NHInHosp.AsPatientName :=ReList[0,1];   //1��������
     G_NHInHosp.AiIDNo :=ReList[0,2];          //2�������
     G_NHInHosp.AsAreaCode :=ReList[0,3];      //3������������
     G_NHInHosp.AsTurnID :=ReList[0,4];         //4ת�����
     G_NHInHosp.AsIllCode :=ReList[0,5];       //5�������
     G_NHInHosp.AsIllName :=ReList[0,6];       //6��������
     //G_NHInHosp. :=ReList[0,7];              //7תǰҽԺ
     //G_NHInHosp.AsOrganID :=ReList[0,8];       //8ת��ԭ��
     //G_NHInHosp.AsOrganID :=ReList[0,9];       //9�������
     //G_NHInHosp.AsOrganID :=ReList[0,10];      //10������λ
     //G_NHInHosp.AsOrganID :=ReList[0,11];      //11��������
     G_NHInHosp.AsPersonCode :=ReList[0,12];      //12���֤��
     G_NHInHosp.AsBrithday :=ReList[0,13];      //13��������
     //G_NHInHosp.AsOrganID :=ReList[0,14];      //14Ԥ��
     //G_NHInHosp.AsOrganID :=ReList[0,15];      //15Ԥ��
     //G_NHInHosp.AsOrganID :=ReList[0,16];      //16Ԥ��
     //G_NHInHosp.AsOrganID :=ReList[0,17];      //17Ԥ��
     //G_NHInHosp.AsOrganID :=ReList[0,18];      //18Ԥ��
     Result := True;
    end;
finally
   FreeMem(OutPchar);
end;


end;


function XNH_GetParmItem : Boolean;
{����
1�����������
2��������ʽĿ¼��
3��������ĿĿ¼��
4��ҽԺ��Ӧ��Ŀ��
5������������
6����������Ϣ��
7��ͳ�ƿ��� }
var
 S: String;
 OutPchar : PChar;
begin
 GetMem(OutPchar,50000);
 GetParmItem('420000','2',OutPchar);
 S := Pchar(OutPchar);
end;



function XNH_zzSaveInHosInfo : Boolean;
Var OutPchar : PChar;
begin
      Result := False;
      GetMem(OutPchar,1024);
  if  zzSaveInHosInfo(PChar(G_NHInHosp.AsOrganID),
                    PChar(G_NHInHosp.AsAreaCode),
                    PChar(G_NHInHosp.AsCoopMedCode),
                    PChar(G_NHInHosp.AsExpressionsID),
                    G_NHInHosp.AiIDNo,
                    G_NHInHosp.AsTurnID,
                    PChar(G_NHInHosp.AsIllCode),
                    PChar(G_NHInHosp.AsIllName),
                    PChar(FormatDateTime('YYYY-MM-DD HH:MM:SS',G_NHInHosp.AInDate)),
                    PChar(G_NHInHosp.Adke),
                    PChar(G_NHInHosp.AdLimitDef),
                    PChar(G_NHInHosp.AsDoctorName),
                    PChar(G_NHInHosp.AsPatientId),
                    PChar(G_NHInHosp.AsExpenseKind),
                    PChar(G_NHInHosp.AsLimitIllCode),
                    OutPchar) <> 0 then
         begin
          ShowError(Pchar(OutPchar));
          Exit;
         end;
      G_NHInHosp.DataBuffer := PChar(OutPchar);
      Result := True;
end;



end.





