unit tcSQLITE_LastInsertId;

{$mode delphi}{$H+}

interface

uses
    uSGBD,
    ujsDataContexte,
    uSQLite3,
    uRequete,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcSQLITE_LastInsertId }

 TtcSQLITE_LastInsertId
 =
  class(TTestCase)
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestHookUp;
  private
   c: TSQLite3;
   function GetConnexion:TjsDataConnexion;
  end;

implementation

procedure TtcSQLITE_LastInsertId.TestHookUp;
var
   r: TRequete;
   id: Integer;
begin
     c:= TSQLite3.Create( sgbd_SQLite3);
     try
        r:= TRequete.Create( GetConnexion);
        try
           c.ExecQuery( 'insert into Work default values');
           id:= c.Last_Insert_id( 'Work');
           if 0 = id
           then
               Fail( 'Echec de TSQLite3.Last_Insert_id');
        finally
               FreeAndNil( r);
               c.Ferme_db;
               end;
     finally
            FreeAndNil( c);
            end;
end;

function TtcSQLITE_LastInsertId.GetConnexion: TjsDataConnexion;
begin
     Result:= c;
end;

procedure TtcSQLITE_LastInsertId.SetUp;
begin

end;

procedure TtcSQLITE_LastInsertId.TearDown;
begin

end;

initialization

 RegisterTest(TtcSQLITE_LastInsertId);
end.

