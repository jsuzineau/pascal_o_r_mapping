unit utc_Publieur;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
  uPublieur,
  TestFrameWork;

type

 Ttc_Publieur
 =
  class( TTestCase)
  private
    p: TPublieur;
    s: String;
    o: array[0..50] of TObjet;
    Messag: String;
    procedure Start;
    procedure Controle( Attendu: String);
    //procedure Controle_bt( Attendu: String);
    procedure AbonneTout;
    procedure AbonneRange(_Offset: Integer);
    procedure DesAbonneRange(_Offset: Integer);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // Test methods
    procedure Test;
    procedure AfficheDescription;
    procedure AfficheArborescence;
    procedure Test_avec_suppressions;
  end;

implementation

uses SysUtils;


//code pour test procédural
var
   static_s: PString;
procedure p_A;
begin
     static_s^:= static_s^+'A';
end;
procedure p_B;
begin
     static_s^:= static_s^+'B';
end;
procedure p_C;
begin
     static_s^:= static_s^+'C';
end;


{ Ttc_Publieur }

procedure Ttc_Publieur.Start;
begin
     s:= '';
     p.Publie_par_sk_pour_test;
     Messag
     :=
        'Avant'#13#10
       +s+#13#10
       +p.skObjet.List+#13#10;
     uPublieur_MoveTo_Count:= 0;
     uPublieur_MoveTo_Last := '';
end;

procedure Ttc_Publieur.Controle( Attendu: String);
var
   List,
   Obtenu: String;
begin
     s:= '';
     p.Publie;
     List:= p.skObjet.List;
     Obtenu:= s;
     if Attendu <> Obtenu
     then
         begin
         s:= '';
         p.Publie_par_sk_pour_test;
         Messag
         :=
            'MoveTo: '+IntToStr(uPublieur_MoveTo_Count)+#13#10
           +'        '+uPublieur_MoveTo_Last+#13#10
           +Messag
           +'Aprés'#13#10
           +s+#13#10
           +List+#13#10
           +'Attendu:>'+Attendu+'<'#13#10
           +'Obtenu :>'+Obtenu +'<';
         Check( false, Messag);
         end;
end;

//procedure Ttc_Publieur.Controle_bt(Attendu: String);
//var
//   Obtenu: String;
//begin
//     s:= '';
//     p.Publie_par_sk_pour_test;
//     Obtenu:= s;
//     Check( Attendu = Obtenu,
//             'Attendu:>'+Attendu+'<'#13#10
//            +'Obtenu :>'+Obtenu +'<');
//end;

procedure Ttc_Publieur.SetUp;
var
   i: Integer;
begin
     inherited;
     p:= TPublieur.Create( 'Ttc_Publieur.p');
     for I:= Low(o) to High(o)
     do
       o[i]:= TObjet.Create( i, p, @s);
     static_s:= @s;
end;

procedure Ttc_Publieur.TearDown;
var
   I: Integer;
begin
     inherited;
     FreeAndNil( p);
     for I:= Low(o) to High(o)
     do
       FreeAndNil( o[i]);
end;

procedure Ttc_Publieur.AbonneTout;
var
   i: Integer;
begin
     for i:= Low(o) to High(o)
     do
       begin
       o[i].Abonne1;
       o[i].Abonne2;
       end;
     p.Abonne( p_A);
     p.Abonne( p_B);
     p.Abonne( p_C);
end;

procedure Ttc_Publieur.AbonneRange( _Offset: Integer);
var
   i: Integer;
begin
     for i:= _Offset to _Offset+9
     do
       o[i].Abonne1;
end;

procedure Ttc_Publieur.DesAbonneRange( _Offset: Integer);
var
   i: Integer;
begin
     for i:= _Offset to _Offset+9
     do
       o[i].DesAbonne1;
end;

procedure Ttc_Publieur.Test;
begin
     uPublieur_s:= @s;
     Start;
     AbonneTout;
     Controle   ( '0a1b2c3d4e5f6g7h8i9jABC');

     Start;
     o[2].Desabonne1;
     Controle   ( '0a1bc3d4e5f6g7h8i9jABC');

     Start;
     o[8].Desabonne1;
     Controle( '0a1bc3d4e5f6g7hi9jABC');

     Start;
     p.Desabonne( p_B);
     Controle( '0a1bc3d4e5f6g7hi9jAC');

     Start;
     o[2].Abonne1;
     Controle( '0a1bc3d4e5f6g7hi9jAC2');

     Start;
     p.Abonne( p_B);
     Controle( '0a1bc3d4e5f6g7hi9jAC2B');
end;

procedure Ttc_Publieur.AfficheDescription;
begin
     AbonneTout;
     Check( False, p.Description);//juste pour afficher
end;

procedure Ttc_Publieur.AfficheArborescence;
begin
     AbonneTout;
     check(false,p.skObjet.List);
end;

procedure Ttc_Publieur.Test_avec_suppressions;
    procedure T( _Offset: Integer; Attendu: String);
    begin
         Start;
         AbonneRange( _Offset);
         Controle   ( Attendu);

         Start;
         DesAbonneRange( _Offset);
         Controle   ( '');
    end;
begin
     uPublieur_s:= @s;

     T(  0, '0123456789'          );
     T( 10, '10111213141516171819');
     T( 20, '20212223242526272829');
     T( 30, '30313233343536373839');
     T( 40, '40414243444546474849');
end;

initialization
              TestFramework.RegisterTest( 'utc_Publieur Suite', Ttc_Publieur.Suite);
end.

