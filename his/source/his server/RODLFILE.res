        ��  ��                  ^V  0   ��
 R O D L F I L E                     <?xml version="1.0" encoding="utf-8"?>
<Library Name="HisLibrary" UID="{EC0A790D-DA2A-4CB5-8896-9D18FF898EB9}" Version="3.0">
<Services>
<Service Name="DataAbstractService" UID="{709489E3-3AFE-4449-84C3-305C2862B348}" Abstract="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Interfaces>
<Interface Name="Default" UID="{4C2EC238-4FB4-434E-8CFF-ED25EEFF1525}">
<Documentation><![CDATA[   Service WinFormsDAServerService. This service has been automatically generated using the RODL template you can find in the Templates directory.]]></Documentation>
<Operations>
<Operation Name="GetSchema" UID="{684994AA-6829-4497-A054-0ACB6647E24F}">
<Parameters>
<Parameter Name="Result" DataType="Utf8String" Flag="Result">
</Parameter>
<Parameter Name="aFilter" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetData" UID="{7C394D25-2B02-4CC9-838B-7099B06F857C}">
<Parameters>
<Parameter Name="Result" DataType="Binary" Flag="Result">
</Parameter>
<Parameter Name="aTableNameArray" DataType="StringArray" Flag="In" >
</Parameter>
<Parameter Name="aTableRequestInfoArray" DataType="TableRequestInfoArray" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="UpdateData" UID="{8FBDE1AF-A3DA-487A-9E08-FB7F446F8DC6}">
<Parameters>
<Parameter Name="Result" DataType="Binary" Flag="Result">
</Parameter>
<Parameter Name="aDelta" DataType="Binary" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="ExecuteCommand" UID="{BEBB190E-A511-4808-9424-5594CB5B5F58}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="aCommandName" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aParameterArray" DataType="DataParameterArray" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="ExecuteCommandEx" UID="{B2C8E6DA-F233-4365-9F56-1590C0583604}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="aCommandName" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aInputParameters" DataType="DataParameterArray" Flag="In" >
</Parameter>
<Parameter Name="aOutputParameters" DataType="DataParameterArray" Flag="Out" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetTableSchema" UID="{CFD45BA0-FD52-40C5-951A-08FF71CF5059}">
<Parameters>
<Parameter Name="Result" DataType="Utf8String" Flag="Result">
</Parameter>
<Parameter Name="aTableNameArray" DataType="StringArray" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetCommandSchema" UID="{15345F7D-9962-485C-B383-BCB0397DD50A}">
<Parameters>
<Parameter Name="Result" DataType="Utf8String" Flag="Result">
</Parameter>
<Parameter Name="aCommandNameArray" DataType="StringArray" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="SQLGetData" UID="{F3A01874-E954-48F5-9DB3-315F248A0E08}">
<Parameters>
<Parameter Name="Result" DataType="Binary" Flag="Result">
</Parameter>
<Parameter Name="aSQLText" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aIncludeSchema" DataType="Boolean" Flag="In" >
</Parameter>
<Parameter Name="aMaxRecords" DataType="Integer" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="SQLGetDataEx" UID="{025A6E0D-8583-44C7-8F5F-6ADE175E446F}">
<Parameters>
<Parameter Name="Result" DataType="Binary" Flag="Result">
</Parameter>
<Parameter Name="aSQLText" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aIncludeSchema" DataType="Boolean" Flag="In" >
</Parameter>
<Parameter Name="aMaxRecords" DataType="Integer" Flag="In" >
</Parameter>
<Parameter Name="aDynamicWhereXML" DataType="Widestring" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="SQLExecuteCommand" UID="{C2525BDB-0CBA-4258-8016-37EB75C24BD7}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="aSQLText" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="SQLExecuteCommandEx" UID="{284F296C-A86B-410E-8A91-72D6E0DA86B9}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="aSQLText" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aDynamicWhereXML" DataType="Widestring" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetDatasetScripts" UID="{1025B82B-49FD-4D62-ACE1-908BAA8D330C}">
<Parameters>
<Parameter Name="Result" DataType="Utf8String" Flag="Result">
</Parameter>
<Parameter Name="DatasetNames" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="RegisterForDataChangeNotification" UID="{3BFC17C7-6676-4B43-A90D-ABEC10072B48}">
<Parameters>
<Parameter Name="aTableName" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="UnregisterForDataChangeNotification" UID="{F3D1B5FB-42FA-46B4-8528-16CF915D4B4D}">
<Parameters>
<Parameter Name="aTableName" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="SimpleLoginService" UID="{4DD93F46-E044-47B9-A0F6-B45CD60A233A}" Ancestor="BaseLoginService" Abstract="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Interfaces>
<Interface Name="Default" UID="{B186853B-168B-4E33-B798-467444BFC8C6}">
<Operations>
<Operation Name="Login" UID="{87E7258D-59B1-4E76-8619-BF46780562F0}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="aUserID" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aPassword" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aUserInfo" DataType="UserInfo" Flag="Out" >
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="BaseLoginService" UID="{745EED14-581E-47FC-B2BB-D4FAA6005B4F}" Abstract="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Interfaces>
<Interface Name="Default" UID="{C349DB54-9DFB-454E-AD23-6F2166A624A6}">
<Operations>
<Operation Name="LoginEx" UID="{2D036C75-65DC-42B0-B5AB-EC414F54B106}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="aLoginString" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="Logout" UID="{866D0287-09D7-4368-AA5A-D4718CF698AF}">
<Parameters>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="MultiDbLoginService" UID="{78596023-A368-4490-8BE4-224987698117}" Ancestor="BaseLoginService" Abstract="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Interfaces>
<Interface Name="Default" UID="{2C6D5764-01CE-447A-8264-27210B2C7371}">
<Operations>
<Operation Name="Login" UID="{64F02AE6-1EFD-40FD-979E-D0CC21320CCB}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="aUserID" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aPassword" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aConnectionName" DataType="Utf8String" Flag="In" >
</Parameter>
<Parameter Name="aUserInfo" DataType="UserInfo" Flag="Out" >
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="MultiDbLoginServiceV5" UID="{059B0FA5-5980-4811-8C8E-790402D62C62}" Ancestor="MultiDbLoginService" Abstract="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Interfaces>
<Interface Name="Default" UID="{5A78AB01-2097-4473-A4D5-78980FFD90E4}">
<Operations>
<Operation Name="GetConnectionNames" UID="{BF3AE66F-A496-4B4D-AEDC-A484F8E2B20E}">
<Parameters>
<Parameter Name="Result" DataType="StringArray" Flag="Result">
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetDefaultConnectionName" UID="{BA63F191-03A5-48FB-99D7-F48B150CB1C6}">
<Parameters>
<Parameter Name="Result" DataType="Utf8String" Flag="Result">
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_System" UID="{5634AA64-F444-406B-BE10-20ADC2E8A407}" Ancestor="DataAbstractService">
<Documentation><![CDATA[ϵͳ]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{1FC9C29C-F27D-43EC-8457-A461CA435F00}">
<Operations>
<Operation Name="IsFieldValueExists" UID="{F4660ACF-7D4D-4E94-BEF4-97008F82334A}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="ATableName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AFieldName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AFieldValue" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="ChangePassword" UID="{40B1E705-BC15-4836-A38D-2201C4F754E0}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="UserID" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="OldPassword" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="NewPassword" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="ResetPassword" UID="{FF33579F-59A2-4DDA-960F-09C9E597D4E1}">
<Parameters>
<Parameter Name="Result" DataType="Boolean" Flag="Result">
</Parameter>
<Parameter Name="UserID" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="NewPassword" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="WriteLog" UID="{301F0C13-7DA5-4FF5-813C-4BACA3A8C7CA}">
<Parameters>
<Parameter Name="Result" DataType="Integer" Flag="Result">
</Parameter>
<Parameter Name="AWorkerID" DataType="Integer" Flag="In" >
</Parameter>
<Parameter Name="AFlag" DataType="Integer" Flag="In" >
</Parameter>
<Parameter Name="ATitle" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AContent" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetParam" UID="{5D179B6E-8656-4677-A90F-F8705EA18BD4}">
<Parameters>
<Parameter Name="Result" DataType="Variant" Flag="Result">
</Parameter>
<Parameter Name="AParamName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="ADefaultValue" DataType="Variant" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="WriteParam" UID="{E575E5A2-C7B0-4495-AD5B-7C4B0215CBD9}">
<Parameters>
<Parameter Name="AParamName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AParamValue" DataType="Variant" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetNextNumber" UID="{D44D35A5-CB90-4F0A-B24C-F5520418201C}">
<Parameters>
<Parameter Name="Result" DataType="AnsiString" Flag="Result">
</Parameter>
<Parameter Name="NumberName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="NumberBits" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="YMDFlag" DataType="Integer" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="GetFieldMaxValue" UID="{56FC5494-6639-4FBF-B1A6-F596B94F45A0}">
<Parameters>
<Parameter Name="Result" DataType="Variant" Flag="Result">
</Parameter>
<Parameter Name="ATableName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="AFieldName" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="SelectOffice" UID="{C7082591-C4CE-43AE-831F-C384BEEB8ABE}">
<Parameters>
<Parameter Name="OfficeID" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="OfficeName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="OfficeUse" DataType="AnsiString" Flag="In" >
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Login" UID="{59B94C0F-2BD4-46E6-A881-BC135FEB4DE0}">
<Documentation><![CDATA[��¼]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{10F949D2-44BC-4DCC-AF4B-7753639820E8}">
<Operations>
<Operation Name="Login" UID="{6F5615AF-D9F1-4E62-8899-E2B5C0396F41}">
<Parameters>
<Parameter Name="Result" DataType="Utf8String" Flag="Result">
</Parameter>
<Parameter Name="LoginText" DataType="Utf8String" Flag="In" >
</Parameter>
</Parameters>
</Operation>
<Operation Name="Logout" UID="{7D23D103-EB70-4F8D-92DB-DFA7910539E2}">
<Parameters>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Clinic" UID="{5EADD916-1CD8-4EB6-8C60-EC43F65D49D8}" Ancestor="DataAbstractService">
<Documentation><![CDATA[����]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{1C385F48-3A91-4F12-83AE-D58168D762AF}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Report" UID="{CE609D4B-C67D-457B-896E-7333D5E44608}">
<Documentation><![CDATA[����]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{6C048047-65AB-41D3-992D-006CC36A489C}">
<Operations>
<Operation Name="PrintReport" UID="{CEB818EF-02EC-49D0-B541-183F16F06B79}">
<Parameters>
<Parameter Name="Result" DataType="Binary" Flag="Result">
</Parameter>
<Parameter Name="ReportName" DataType="AnsiString" Flag="In" >
</Parameter>
<Parameter Name="ParamNames" DataType="StringArray" Flag="In" >
</Parameter>
<Parameter Name="ParamValues" DataType="StringArray" Flag="In" >
</Parameter>
<Parameter Name="Flag" DataType="Integer" Flag="In" >
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Medicine" UID="{0E9A725A-713B-4888-BF96-5613BA694818}" Ancestor="DataAbstractService">
<Documentation><![CDATA[ҩƷ]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{E4228A93-FCF8-4622-9893-AA9E28733854}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Hosp" UID="{D9A192D6-D0E5-405B-908C-6752CC5591A3}" Ancestor="DataAbstractService">
<Documentation><![CDATA[סԺ]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{11757C5E-F670-4A43-9D41-3240EF47F6C4}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Base" UID="{7A3183A1-0F17-405C-9130-8425717B4138}" Ancestor="DataAbstractService">
<Documentation><![CDATA[��������]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{4CE2B46D-A4ED-49F7-A61A-D191B6CE5AED}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_YB" UID="{139667E6-D828-4826-9FED-36A6060C554C}" Ancestor="DataAbstractService">
<Documentation><![CDATA[ҽ��]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{39B98954-04FC-4673-A0EF-4B25F2A9AD88}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_XNH" UID="{0CB8B537-BA6F-4C57-A00D-441D6D7C643C}" Ancestor="DataAbstractService">
<Documentation><![CDATA[��ũ��]]></Documentation>
<Interfaces>
<Interface Name="Default" UID="{2DCAC131-1FFD-471C-BFD5-ABD666917F71}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Dict" UID="{BCF71E6C-F8DA-44C6-8C02-277F7D8D8144}" Ancestor="DataAbstractService">
<Interfaces>
<Interface Name="Default" UID="{723496C0-1F70-40F3-AAAF-B16C889409AC}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Extend" UID="{45C5FD31-4D2D-4113-A9EA-40C7151F3E3F}" Ancestor="DataAbstractService">
<Interfaces>
<Interface Name="Default" UID="{302E8555-52AC-493F-837C-674FB6D836D9}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
<Service Name="HisService_Stat" UID="{3568B6B2-F56E-4F96-9DB7-3A5B0488605A}" Ancestor="DataAbstractService">
<Interfaces>
<Interface Name="Default" UID="{061D6006-7BA4-4592-B850-062C42CE7C6F}">
<Operations>
</Operations>
</Interface>
</Interfaces>
</Service>
</Services>
<EventSinks>
<EventSink Name="DataChangeNotification" UID="{10309CDF-EA24-4F8B-9678-8D1EF426955F}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Interfaces>
<Interface Name="Default" UID="{1309480C-AEF8-48E0-A27F-E6090F441B46}">
<Operations>
<Operation Name="OnDataTableChanged" UID="{61437AB0-DD71-44D3-967A-25199CE8C1CD}">
<Parameters>
<Parameter Name="aTableName" DataType="Utf8String" Flag="In">
</Parameter>
<Parameter Name="aDelta" DataType="Binary" Flag="In">
</Parameter>
</Parameters>
</Operation>
</Operations>
</Interface>
</Interfaces>
</EventSink>
</EventSinks>
<Structs>
<Struct Name="DataParameter" UID="{960C67F1-F39A-43EF-9D45-E091ACE04A86}" AutoCreateParams="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="Name" DataType="Utf8String">
</Element>
<Element Name="Value" DataType="Variant">
</Element>
</Elements>
</Struct>
<Struct Name="TableRequestInfo" UID="{AD4D327E-650E-42AF-8D57-1166124FB515}" AutoCreateParams="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="UserFilter" DataType="Utf8String">
</Element>
<Element Name="IncludeSchema" DataType="Boolean">
</Element>
<Element Name="MaxRecords" DataType="Integer">
<CustomAttributes>
<Default Value="-1" />
</CustomAttributes>
</Element>
<Element Name="Parameters" DataType="DataParameterArray">
</Element>
</Elements>
</Struct>
<Struct Name="UserInfo" UID="{C07A7008-F183-4015-9503-5C8FAE347E1C}" AutoCreateParams="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="SessionID" DataType="Utf8String">
</Element>
<Element Name="UserID" DataType="Utf8String">
</Element>
<Element Name="Privileges" DataType="StringArray">
</Element>
<Element Name="Attributes" DataType="VariantArray">
</Element>
<Element Name="UserData" DataType="Binary">
</Element>
</Elements>
</Struct>
<Struct Name="TableRequestInfoV5" UID="{F212B25A-167B-409C-BE99-23348E82AA5E}" AutoCreateParams="1" Ancestor="TableRequestInfo" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="WhereClause" DataType="Xml">
</Element>
<Element Name="DynamicSelectFieldNames" DataType="StringArray">
</Element>
<Element Name="Sorting" DataType="ColumnSorting">
</Element>
</Elements>
</Struct>
<Struct Name="ColumnSorting" UID="{81A8FAD7-B72D-4962-AD43-CD8E827DBC12}" AutoCreateParams="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="FieldName" DataType="Utf8String">
</Element>
<Element Name="SortDirection" DataType="ColumnSortDirection">
</Element>
</Elements>
</Struct>
<Struct Name="TableRequestInfoV6" UID="{9BC1458B-11F9-44EB-81D9-06198336F72D}" AutoCreateParams="1" Ancestor="TableRequestInfo" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="Sql" DataType="Widestring">
</Element>
</Elements>
</Struct>
</Structs>
<Enums>
<Enum Name="ColumnSortDirection" UID="{EAEAD7D2-3A0E-48D6-BE19-A74265D14503}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<EnumValues>
<EnumValue Name="Ascending">
</EnumValue>
<EnumValue Name="Descending">
</EnumValue>
</EnumValues>
</Enum>
<Enum Name="ScriptExceptionType" UID="{60698D9B-61E3-4BDA-AA4C-58235FE6F4F5}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<EnumValues>
<EnumValue Name="ParserError">
</EnumValue>
<EnumValue Name="RuntimeError">
</EnumValue>
<EnumValue Name="Fail">
</EnumValue>
<EnumValue Name="UnexpectedException">
</EnumValue>
<EnumValue Name="Abort">
</EnumValue>
</EnumValues>
</Enum>
</Enums>
<Arrays>
<Array Name="DataParameterArray" UID="{3E639D01-FB07-458F-B9C4-C6550F504901}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<ElementType DataType="DataParameter" />
</Array>
<Array Name="TableRequestInfoArray" UID="{036958C2-1AC8-49B6-8A94-417198CB799F}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<ElementType DataType="TableRequestInfo" />
</Array>
<Array Name="StringArray" UID="{7E86C9FC-99E7-45F2-8A49-E59A7A017265}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<ElementType DataType="Utf8String" />
</Array>
<Array Name="VariantArray" UID="{5E7C5D64-FC5D-4B54-AC91-11B27ACA5FF4}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<ElementType DataType="Variant" />
</Array>
<Array Name="ColumnSortingArray" UID="{53481559-8F14-44C6-83E4-5E9A579AB0EC}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<ElementType DataType="ColumnSorting" />
</Array>
<Array Name="UserInfoArray" UID="{90816BC2-EC6D-4C03-8C36-B9C50A8F2B8E}" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<ElementType DataType="UserInfo" />
</Array>
</Arrays>
<Uses>
<Use Name="DataAbstract4" UID="{A2C475ED-9ED2-436F-987C-1DAD70EB7B87}" Rodl="$(Data Abstract for Delphi)\Source\DataAbstract4.RODL" AbsoluteRodl="C:\Program Files (x86)\RemObjects Software\Data Abstract for Delphi\Source\DataAbstract4.RODL" UsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}" DontCodeGen="1">
<Includes UID="{ECE5910F-040B-4BDF-9502-EDF7F95642CF}" Delphi="DataAbstract4" DotNet="RemObjects.DataAbstract.Server" ObjC="DataAbstract/DataAbstract4_Intf" Java="com.remobjects.dataabstract.intf" Cocoa="DataAbstract"/>
</Use>
</Uses>
<Exceptions>
<Exception Name="ScriptException" UID="{8BF890A1-81CF-4371-93FD-39E44CBD052F}" AutoCreateParams="1" FromUsedRodlUID="{DC8B7BE2-14AF-402D-B1F8-E1008B6FA4F6}">
<Elements>
<Element Name="Line" DataType="Integer">
</Element>
<Element Name="Column" DataType="Integer">
</Element>
<Element Name="Event" DataType="Utf8String">
</Element>
<Element Name="InnerStackTrace" DataType="Utf8String">
</Element>
<Element Name="Type" DataType="ScriptExceptionType">
</Element>
</Elements>
</Exception>
</Exceptions>
</Library>
