unit utc_ChampsGrid;
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
    uClean,
    uChamp,
    uOD_Forms,
    uBatpro_StringList,
    uChampDefinitions,
    uChamps,
    ucChampsGrid,
    TestFrameWork,
    Windows, SysUtils, Classes, VCL.Controls, DB, Grids,VCL.Dialogs, VCL.StdCtrls, Buttons, VCL.Forms;

type
 Ttc_ChampsGrid
 =
  class(TTestCase)
  protected
    ChampDefinitions: TChampDefinitions;
    sl: TBatpro_StringList;
    procedure SetUp; override;
    procedure TearDown; override;
  //Fenêtre de test
  private
    F: TForm;
    cg: TChampsGrid;
    procedure BClick( Sender:TObject);
  // Test methods
  published
    procedure Test;
    procedure Test_Vidage;
  end;

implementation

uses Math, StrUtils;

type
 TTest
 =
  class( TChampsProvider)
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor  Destroy; override;
  //Champs
  public
    ChampDefinitions: TChampDefinitions;
    Champs: TChamps;
  //Attributs
  public
    I: Integer;
    S: String;
    D: Double;
    B: Boolean;
  //id
  private
    Fid: Integer;
    procedure Setid(const Value: Integer);
  public
    sID: String;
    property id: Integer read Fid write Setid;
  //interface TChampsProvider
  public
    function  GetChamps: TChamps; override;
    function Champ_a_editer(Contexte: Integer): TChamp; override;
  end;

{ TTest }

constructor TTest.Create;
const
     truc: array[0..3] of String = ('truc', 'troc', 'trac', 'tric');
begin
     inherited Create;
     Champs:= TChamps.Create( ClassName, nil, nil);
     ChampDefinitions:= Champs.ChampDefinitions;

     Champs.Ajoute_Integer( I, 'I', False);
     Champs.Ajoute_String ( S, 'S', False);
     Champs.Ajoute_Float  ( D, 'D', False);
     Champs.Ajoute_Boolean( B, 'B', False);

     Champs.Ajoute_Integer( Fid, 'id' , False);
     Champs.Ajoute_String ( sID, 'sID', False);

     I:= RandomRange( 0, 100);
     S:= RandomFrom( truc);
     D:= RandG( 50, 20);
     B:= Boolean( RandomRange(0,2));
end;

destructor TTest.Destroy;
begin
     Free_nil( Champs);
     inherited;
end;

function TTest.GetChamps: TChamps;
begin
     Result:= Champs;
end;

procedure TTest.Setid(const Value: Integer);
begin
     Fid := Value;
     sID:= 'Ligne n°'+IntToStr( id);
end;

function TTest.Champ_a_editer(Contexte: Integer): TChamp;
begin
     Result:= nil;
end;

{ Ttc_ChampsGrid }

procedure Ttc_ChampsGrid.SetUp;
var
   I: Integer;
   T: TTest;
begin
     inherited;
     sl:= TBatpro_StringList.Create;
     for I:= 0 to 10
     do
       begin
       T:= TTest.Create;
       T.id:= I;
       sl.AddObject( '', T);
       end;
end;

procedure Ttc_ChampsGrid.TearDown;
var
   I: Integer;
   O: TObject;
begin
     for I:= 0 to sl.Count-1
     do
       begin
       O:= sl.Objects[ I];
       sl.Objects[ I]:= nil;
       Free_nil( O);
       end;
     Free_nil( ChampDefinitions);
     Free_nil( sl);
     inherited;
end;

procedure Ttc_ChampsGrid.Test;
begin
     F:= TForm.Create( nil);
     try
        F.Name:= 'f_tc_ChampsGrid';
        F.Width:= 300;

        cg:= TChampsGrid.Create( F);
        cg.Parent:= F;
        cg.Align:= alClient;
        cg.Classe_Elements:= TTest;
        cg.sl:= sl;

        F.ShowModal;
     finally
            Free_nil( F);
            end;
end;

procedure Ttc_ChampsGrid.BClick(Sender: TObject);
begin
     cg.Row:= 8;
     cg.Col:= 5;

     cg.Refresh;
     uOD_Forms_ProcessMessages;
     sl.Delete( 3);
     cg.sl:= nil;
     cg.sl:= sl;
end;

procedure Ttc_ChampsGrid.Test_Vidage;
var
   B: TButton;
begin
     F:= TForm.Create( nil);
     try
        F.Name:= 'f_tc_ChampsGrid';
        F.Width:= 300;

        cg:= TChampsGrid.Create( F);
        cg.Parent:= F;
        cg.Align:= alClient;
        cg.Classe_Elements:= TTest;
        cg.sl:= sl;
        cg.Options:= cg.Options+[goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowMoving, goColMoving, goEditing, goAlwaysShowEditor];

        B:= TButton.Create( F);
        B.Parent:= F;
        B.OnClick:= BClick;
        B.Caption:= 'Tester';

        F.ShowModal;

     finally
            Free_nil( F);
            end;
end;

initialization

  TestFramework.RegisterTest('utc_ChampsGrid Suite', Ttc_ChampsGrid.Suite);

end.
