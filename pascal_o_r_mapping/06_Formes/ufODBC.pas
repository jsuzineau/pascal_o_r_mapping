unit ufODBC;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    udmDatabase,
    uSGBD,
    uSQLite3,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LazUTF8, IniFiles;

type

 { TfODBC }

 TfODBC = class(TForm)
  bAdministratorTool: TButton;
  bCustomizeDSN: TButton;
  bCree_Datasource: TButton;
  m: TMemo;
  Panel1: TPanel;
  procedure bAdministratorToolClick(Sender: TObject);
  procedure bCree_DatasourceClick(Sender: TObject);
  procedure bCustomizeDSNClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
  procedure Log( _s: String);
  function Compute_SQLite3_filename: String;
 public
  procedure CustomizeDSN_SQLITE;
  procedure Cree_Datasource_SQLITE;
 end;

function fODBC: TfODBC;

implementation

{$R *.lfm}
var
   FfODBC: TfODBC= nil;

function fODBC: TfODBC;
begin
     Clean_Get( Result, FfODBC, TfODBC);
end;

{ TfODBC }

procedure TfODBC.FormCreate(Sender: TObject);
begin
     m.Clear;
end;

procedure TfODBC.bAdministratorToolClick(Sender: TObject);
begin
     SysUtils.ExecuteProcess(UTF8ToSys('C:\Windows\System32\odbcad32.exe'), '', []);
end;

procedure TfODBC.bCree_DatasourceClick(Sender: TObject);
begin
     Cree_Datasource_SQLITE;
end;

procedure TfODBC.bCustomizeDSNClick(Sender: TObject);
begin
     CustomizeDSN_SQLITE;
end;

procedure TfODBC.Log(_s: String);
begin
     m.Lines.Add( DateTimeToStr( Now)+': '+_s);
end;

function TfODBC.Compute_SQLite3_filename: String;
var
   SQLite3: TSQLite3;
begin
     Result:= '';
     if not sgbdSQLite3 then exit;

     SQLite3:= dmDatabase.jsDataConnexion as TSQLite3;
     Result:= SQLite3.DataBase;

     if     (0 =  Pos(':' , Result)) // pas de C:\
        and (1 <> Pos('\\', Result)) // pas de chemin réseau \\truc
     then
         Result:= ExtractFilePath(Application.ExeName)+Result;
end;

procedure TfODBC.CustomizeDSN_SQLITE;
var
   SQLite3_filename: String;
   DSN_Filename: String;
   ini: TIniFile;
begin
     if not sgbdSQLite3
     then
         begin
         Log( ClassName+'.CustomizeDSN_SQLITE : Le SGBD courant n''est pas SQLite3');
         exit;
         end;

     SQLite3_filename:= Compute_SQLite3_filename;

     DSN_Filename:= ChangeFileExt( SQLite3_filename, '.dsn');

     ini:= TIniFile.Create( DSN_Filename);
     try
        ini.WriteString('ODBC', 'Database',SQLite3_filename);
        Log( 'Personnalisation DSN SQLite effectuée');
        Log( 'DSN    : '+DSN_Filename);
        Log( 'SQLite3: '+SQLite3_filename);
     finally
            FreeAndNil( ini);
            end;
end;

function SQLConfigDataSource( hwndParent: Integer;
                              fRequest: Integer;
                              lpszDriverString: PChar;
                              lpszAttributes: PChar
                              ): Integer; stdcall; external 'odbccp32.dll';
function SQLInstallerError( iError: WORD;
                            pfErrorCode: PDWORD;
                            lpszErrorMsg: String;
                            cbErrorMsgMax: WORD;
                            pcbErrorMsg: PWORD
                            ): integer; stdcall; external 'odbccp32.dll';

procedure TfODBC.Cree_Datasource_SQLITE;
const
     ODBC_ADD_DSN            = 1;
     ODBC_CONFIG_DSN         = 2;
     ODBC_REMOVE_DSN         = 3;
     ODBC_ADD_SYS_DSN        = 4;
     ODBC_CONFIG_SYS_DSN     = 5;
     ODBC_REMOVE_SYS_DSN     = 6;
     ODBC_REMOVE_DEFAULT_DSN = 7;
var
   SQLite3_filename: String;
   Driver: String;
   lpszAttributes: PChar;
   retCode: Integer;
   procedure Process_Error_Message;
   const
        SQL_ERROR               = -1;
        SQL_SUCCESS             = 0;
        SQL_SUCCESS_WITH_INFO   = 1;
        SQL_NO_DATA             = 100;
   var
      ErrorMessageSize: Word;
      ErrorMessage: String;
      iError: WORD;
      ErrorCode: DWORD;
   begin
        Log( ClassName+'.Cree_Datasource_SQLITE: Erreur');
        iError:= 1;
        while SQLInstallerError( iError, nil, ErrorMessage, 0, @ErrorMessageSize) <> SQL_NO_DATA
        do
          begin
          Inc(ErrorMessageSize);
          SetLength(ErrorMessage, ErrorMessageSize);
          SQLInstallerError( iError, @ErrorCode, ErrorMessage, ErrorMessageSize, @ErrorMessageSize);
          Log( 'ErrorCode   : '+IntToStr( ErrorCode));
          Log( 'ErrorMessage: '+SysToUTF8(ErrorMessage));
          Inc(iError);
          end;
   end;
begin
     SQLite3_filename:= Compute_SQLite3_filename;
     Driver:= 'SQLite3 ODBC Driver';
     lpszAttributes
     :=
       PChar
         (
          'DSN='+ChangeFileExt( ExtractFileName( SQLite3_filename), '')+#0
         +'DRIVER= '+Driver+#0
         +'JDConv=0'#0
         +'BigInt=0'#0
         +'LoadExt='#0
         +'OEMCP=0'#0
         +'JournalMode='#0
         +'FKSupport=0'#0
         +'NoWCHAR=0'#0
         +'NoCreat=1'#0
         +'LongNames=0'#0
         +'ShortNames=0'#0
         +'Timeout='#0
         +'NoTXN=0'#0
         +'SyncPragma='#0
         +'StepAPI=0'#0
         +'Database='+SQLite3_filename+#0#0);
  retCode:= SQLConfigDataSource( Handle, ODBC_ADD_DSN, PChar(Driver), lpszAttributes);
  if 0 <> retCode
  then
      Log( ClassName+'.Cree_Datasource_SQLITE: exécuté avec succés')
  else
      Process_Error_Message;
end;


end.

