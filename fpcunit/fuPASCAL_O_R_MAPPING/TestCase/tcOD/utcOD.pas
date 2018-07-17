unit utcOD;

{$mode objfpc}{$H+}

interface

uses
    uOD,
    uOD_Table_Batpro,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 TtcOD
 =
 class(TTestCase)
 //Attributs
 private
   od: TOD_Table_Batpro;
 //Méthodes
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure TestHookUp;
 end;

implementation

procedure TtcOD.SetUp;
begin
     od:= TOD_Table_Batpro.Create;
end;

procedure TtcOD.TearDown;
begin
     FreeAndNil( od);
end;

procedure TtcOD.TestHookUp;
begin
     od.Init;
     od.FNomFichier_Modele:= 'tcOD.ott';
     od.SendMail_From:='jean.suzineau@wanadoo.fr';
     od.SendMail_Subject:='Test envoi de mail é à';
     od.SendMail_Body:= 'Bonjour,'#13#10'Ceci est un test d''envoi de mail. é à '#13#10'Cordialement';
     od.Action( 'SENDMAIL=jean.suzineau@wanadoo.fr');
end;

initialization

 RegisterTest(TtcOD);
end.

