unit HisServer_Const;

interface

const
  sAppID = 'DA-HIS-SERVER';
  sAppVer = '2020.09';

  // ����Schemaʱ��Ҫ�ȴ���ʱ��
  iWaitTimeBeforeUpdateSchema = 3000;

  // ���ݿ�����
  sDBNameHis = 'HIS_Base';

  // ����ҵ�����
  sOperationCategorySys = 'ϵͳ';
  sOperationCategoryFile = '�ļ�';
  sOperationCategoryData = '���ݷ���';
  sOperationCategoryHelp = '����';

  // ����ҵ����
  sOperationIDHome = 'home';
  sOperationIDLogger = 'logger';
  sOperationIDReport = 'report';
  sOperationIDMaintain = 'maintaining';
  sOperationIDOption = 'option';
  sOperationIDRefreshSchemaSystem = 'schema_system';
  sOperationIDRefreshSchemaBase = 'schema_base';
  sOperationIDRefreshSchemaDict = 'schema_dict';
  sOperationIDRefreshSchemaClinic = 'schema_clinic';
  sOperationIDRefreshSchemaHosp = 'schema_hosp';
  sOperationIDRefreshSchemaMedicine = 'schema_medicine';
  sOperationIDRefreshSchemaStat = 'schema_stat';
  sOperationIDRefreshSchemaExtend = 'schema_extend';
  sOperationIDRefreshSchemaYB = 'schema_yb';
  sOperationIDRefreshSchemaXNH = 'schema_xnh';

  // ͼƬ����
  sImagePreferences = 'preferences';
  sImageLogger = 'log';
  sImageSchema = 'schema';

implementation

end.
