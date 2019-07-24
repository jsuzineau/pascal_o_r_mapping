unit utcIntervalle;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    uClean,
    u_sys_,
    uIntervalle,
    TestFramework;

type
 TtcIntervalle = class(TTestCase)
 private

 protected

//    procedure SetUp; override;
//    procedure TearDown; override;

 // Test methods
 private
   procedure interne_TestIntersection_avec_(     I1_Debut,     I1_Fin,
                                                 I2_Debut,     I2_Fin,
                                            Attendu_Debut,Attendu_Fin:Integer);
 published
   procedure TestCreate;
   procedure TestVide;
   procedure TestInit_from_;
   procedure TestIntersection_avec_;
   procedure TestContient;
 end;

implementation

uses SysUtils;

{ TtcIntervalle }

procedure TtcIntervalle.TestCreate;
var
   Debut,
   Fin  : TDateTime;
   I: TIntervalle;
begin
     Debut:= 0;
     Fin:= 0;
     I:= TIntervalle.Create( @Debut, @Fin  );
     try
        Check( I.Debut = Debut, 'TtcIntervalle.TestCreate, 1: I.Debut <> Debut');
        Check( I.Fin   = Fin  , 'TtcIntervalle.TestCreate, 2: I.Fin   <> Fin  ');
        Debut:= Trunc(Now);
        Fin  := Trunc(Now)+1;
        Check( I.Debut = Debut, 'TtcIntervalle.TestCreate, 3: I.Debut <> Debut');
        Check( I.Fin   = Fin  , 'TtcIntervalle.TestCreate, 4: I.Fin   <> Fin  ');
     finally
            Free_nil( I);
            end;
end;

procedure TtcIntervalle.TestVide;
var
   I: TIntervalle;
begin
     I:= TIntervalle.Create( nil, nil);
     try
        I.Debut:= 1;
        I.Fin  := 2;
        Check( not I.Vide, 'TtcIntervalle.TestVide, 1: I est Vide');
        I.Debut:= 2;
        I.Fin  := 1;
        Check(     I.Vide, 'TtcIntervalle.TestVide, 2: I n''est pas Vide');
     finally
            Free_nil( I);
            end;
end;

procedure TtcIntervalle.TestInit_from_;
var
   I1, I2: TIntervalle;
begin
     I1:= TIntervalle.Create( nil, nil);
     I2:= TIntervalle.Create( nil, nil);
     try
        I2.Debut:= 0;
        I2.Fin  := 0;
        Check( I1.Debut <> I2.Debut, 'TtcIntervalle.TestInit_from_, 1: I1.Debut =  I2.Debut');
        Check( I1.Fin   <> I2.Fin  , 'TtcIntervalle.TestInit_from_, 2: I1.Fin   =  I2.Fin  ');
        I2.Init_from_( I1);
        Check( I1.Debut =  I2.Debut, 'TtcIntervalle.TestInit_from_, 3: I1.Debut <> I2.Debut');
        Check( I1.Fin   =  I2.Fin  , 'TtcIntervalle.TestInit_from_, 4: I1.Fin   <> I2.Fin  ');
     finally
            Free_nil( I1);
            Free_nil( I2);
            end;
end;

procedure TtcIntervalle.interne_TestIntersection_avec_(     I1_Debut,      I1_Fin,
                                                            I2_Debut,      I2_Fin,
                                                       Attendu_Debut, Attendu_Fin: Integer);
var
   I1, I2: TIntervalle;
begin
     I1:= TIntervalle.Create( nil, nil);
     I2:= TIntervalle.Create( nil, nil);
     try
        I1.Debut:= I1_Debut;
        I1.Fin  := I1_Fin  ;
        I2.Debut:= I2_Debut;
        I2.Fin  := I2_Fin  ;
        I2.Intersection_avec_( I1);
        Check( (I2.Debut =  Attendu_Debut) and (I2.Fin   =  Attendu_Fin  ),
                'TtcIntervalle.interne_TestIntersection_avec_:'+sys_N
               +'Attendu: '+FormatDateTime( 'ddddd', Attendu_Debut)
               +' à '      +FormatDateTime( 'ddddd', Attendu_Fin  )+sys_N
               +'Obtenu : '+FormatDateTime( 'ddddd', I2.Debut)
               +' à '      +FormatDateTime( 'ddddd', I2.Fin  )
                );
     finally
            Free_nil( I1);
            Free_nil( I2);
            end;
end;

procedure TtcIntervalle.TestIntersection_avec_;
begin
interne_TestIntersection_avec_( 1, 3, 2, 4, 2, 3);//chevauchement
interne_TestIntersection_avec_( 1, 2, 3, 4, 3, 2);//disjoint
interne_TestIntersection_avec_( 1, 4, 2, 3, 2, 3);//I2 inclu dans I1
end;

procedure TtcIntervalle.TestContient;
var
   I: TIntervalle;
begin
     I:= TIntervalle.Create( nil, nil);
     try
        I.Debut:= 1;
        I.Fin  := 3;
        Check( I.Contient( 2)    , 'TtcIntervalle.TestContient, 1: 2 non trouvé dans [1,3]');
        Check( not I.Contient( 4), 'TtcIntervalle.TestContient, 2: 4 trouvé dans [1,3]');
     finally
            Free_nil( I);
            end;
end;

initialization

  TestFramework.RegisterTest('utcIntervalle Suite',
    TtcIntervalle.Suite);

end.
