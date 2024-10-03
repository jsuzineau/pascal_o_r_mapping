object dmDatabase: TdmDatabase
  OldCreateOrder = True
  Height = 466
  Width = 1090
  object sqlc: TSQLConnection
    DriverName = 'Informix'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Informix'
      'HostName=ows2'
      'DataBase=a'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Informix TransIsolation=ReadCommited'
      'Trim Char=True'
      'User_Name=batpro')
    Left = 48
    Top = 16
  end
  object sqlcINFORMIX: TSQLConnection
    DriverName = 'Informix'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Informix'
      'HostName=ows2'
      'DataBase=a'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Informix TransIsolation=ReadCommited'
      'Trim Char=True')
    Left = 560
    Top = 16
  end
  object sqlcSYSMASTER: TSQLConnection
    DriverName = 'Informix'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=Informix'
      'HostName=ol_w2002'
      'DataBase=sysmaster'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Informix TransIsolation=ReadCommited'
      'Trim Char=True')
    Left = 656
    Top = 16
  end
  object sqlqSYSDATABASE: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    sysdatabases'
      'where'
      '         name <> '#39'sysmaster'#39
      '     and name <> '#39'sysutils'#39)
    SQLConnection = sqlcSYSMASTER
    Left = 656
    Top = 64
    object sqlqSYSDATABASEname: TStringField
      FieldName = 'name'
      FixedChar = True
      Size = 18
    end
    object sqlqSYSDATABASEpartnum: TIntegerField
      FieldName = 'partnum'
    end
    object sqlqSYSDATABASEowner: TStringField
      FieldName = 'owner'
      FixedChar = True
      Size = 8
    end
    object sqlqSYSDATABASEcreated: TDateField
      FieldName = 'created'
    end
    object sqlqSYSDATABASEis_logging: TIntegerField
      FieldName = 'is_logging'
    end
    object sqlqSYSDATABASEis_buff_log: TIntegerField
      FieldName = 'is_buff_log'
    end
    object sqlqSYSDATABASEis_ansi: TIntegerField
      FieldName = 'is_ansi'
    end
    object sqlqSYSDATABASEis_nls: TIntegerField
      FieldName = 'is_nls'
    end
    object sqlqSYSDATABASEflags: TSmallintField
      FieldName = 'flags'
    end
  end
  object cdSYSDATABASE: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pSYSDATABASE'
    ReadOnly = True
    Left = 656
    Top = 160
    object cdSYSDATABASEname: TStringField
      FieldName = 'name'
      FixedChar = True
      Size = 18
    end
    object cdSYSDATABASEpartnum: TIntegerField
      FieldName = 'partnum'
    end
    object cdSYSDATABASEowner: TStringField
      FieldName = 'owner'
      FixedChar = True
      Size = 8
    end
    object cdSYSDATABASEcreated: TDateField
      FieldName = 'created'
    end
    object cdSYSDATABASEis_logging: TIntegerField
      FieldName = 'is_logging'
    end
    object cdSYSDATABASEis_buff_log: TIntegerField
      FieldName = 'is_buff_log'
    end
    object cdSYSDATABASEis_ansi: TIntegerField
      FieldName = 'is_ansi'
    end
    object cdSYSDATABASEis_nls: TIntegerField
      FieldName = 'is_nls'
    end
    object cdSYSDATABASEflags: TSmallintField
      FieldName = 'flags'
    end
  end
  object pSYSDATABASE: TDataSetProvider
    DataSet = sqlqSYSDATABASE
    Options = [poReadOnly, poAllowMultiRecordUpdates, poDisableInserts, poDisableEdits, poDisableDeletes, poRetainServerOrder]
    Left = 656
    Top = 112
  end
  object dsSYSDATABASE: TDataSource
    DataSet = cdSYSDATABASE
    Left = 656
    Top = 208
  end
  object sqlm: TSQLMonitor
    FileName = 'dmDatabase.sqlm.txt'
    SQLConnection = sqlc
    Left = 488
    Top = 65
  end
  object sqlqPG_DATABASES: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      
        'SELECT datname FROM pg_database WHERE datistemplate IS FALSE AND' +
        ' datallowconn IS TRUE AND datname!='#39'postgres'#39)
    SQLConnection = sqlc
    Left = 192
    Top = 64
  end
  object cdPG_DATABASES: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pPG_DATABASES'
    ReadOnly = True
    Left = 192
    Top = 160
    object cdPG_DATABASESdatname: TStringField
      FieldName = 'datname'
      Size = 63
    end
  end
  object pPG_DATABASES: TDataSetProvider
    DataSet = sqlqPG_DATABASES
    Options = [poReadOnly, poAllowMultiRecordUpdates, poDisableInserts, poDisableEdits, poDisableDeletes]
    Left = 192
    Top = 112
  end
  object dsPG_DATABASES: TDataSource
    DataSet = cdPG_DATABASES
    Left = 192
    Top = 208
  end
  object sqlcGED: TSQLConnection
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'BlobSize=-1'
      'ErrorResourceFile=')
    Left = 848
    Top = 136
  end
  object sqlcMYSQL: TSQLConnection
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'BlobSize=-1'
      'ErrorResourceFile=')
    Left = 848
    Top = 16
  end
  object sqlcPostgres_vitavoom: TSQLConnection
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'BlobSize=-1'
      'ErrorResourceFile=')
    Left = 952
    Top = 16
  end
  object sqlqSHOW_DATABASES: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'show databases')
    SQLConnection = sqlc
    Left = 48
    Top = 64
    object StringField1: TStringField
      FieldName = 'Database'
      Required = True
      FixedChar = True
      Size = 64
    end
  end
  object cdSHOW_DATABASES: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pSHOW_DATABASES'
    ReadOnly = True
    Left = 48
    Top = 160
    object cdSHOW_DATABASESDatabase: TStringField
      FieldName = 'Database'
      Required = True
      FixedChar = True
      Size = 64
    end
  end
  object pSHOW_DATABASES: TDataSetProvider
    DataSet = sqlqSHOW_DATABASES
    Options = [poReadOnly, poAllowMultiRecordUpdates, poDisableInserts, poDisableEdits, poDisableDeletes]
    Left = 48
    Top = 112
  end
  object dsSHOW_DATABASES: TDataSource
    DataSet = cdSHOW_DATABASES
    Left = 48
    Top = 208
  end
  object sqlcPostgres: TSQLConnection
    DriverName = 'MySQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=24.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver250.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=24.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'BlobSize=-1'
      'ErrorResourceFile=')
    Left = 960
    Top = 120
  end
  object sqlcSQLSERVER: TSQLConnection
    ConnectionName = 'MSSQLConnection'
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MSSQL'
      'HostName=SRV2-ID2NSO\MSSQLSERVER'
      'DataBase=trfv8'
      'User_Name=sa'
      'Password=Ofnid@85'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'MSSQL TransIsolation=ReadCommited'
      'OS Authentication=False')
    Left = 576
    Top = 288
  end
  object sqlqSYS_DATABASES: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    sys.databases')
    SQLConnection = sqlcSQLSERVER
    Left = 312
    Top = 64
  end
  object cdSYS_DATABASES: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'pSYS_DATABASES'
    ReadOnly = True
    Left = 312
    Top = 160
    object cdSYS_DATABASESdatname: TStringField
      FieldName = 'datname'
      Size = 63
    end
  end
  object pSYS_DATABASES: TDataSetProvider
    DataSet = sqlqSYS_DATABASES
    Options = [poReadOnly, poAllowMultiRecordUpdates, poDisableInserts, poDisableEdits, poDisableDeletes]
    Left = 312
    Top = 112
  end
  object dsSYS_DATABASES: TDataSource
    DataSet = cdSYS_DATABASES
    Left = 312
    Top = 208
  end
  object SQLConnection1: TSQLConnection
    ConnectionName = 'MSSQLConnection'
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MSSQL'
      'HostName=SRV2-ID2NSO\MSSQLSERVER'
      'DataBase=trfv8'
      'User_Name=batpro'
      'Password=azerty'
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'MSSQL TransIsolation=ReadCommited'
      'OS Authentication=False')
    Left = 752
    Top = 288
  end
end
