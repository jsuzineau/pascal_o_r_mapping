unit uftcChamp_DateTimePicker;
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
    u_sys_,
    uChamps,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    upool_Ancetre_Ancetre,

  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphicso, FMX.Controls, FMX.Forms,
  Dialogs, ComCtrls, ucBatproDateTimePicker, SqlExpr, DB, StdCtrls,
  ucChamp_Label, ucChamp_DateTimePicker;

type
 TblTest_Champ_DateTimePicker
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    D: TDateTime;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Persistance désactivée
  public
    procedure Save_to_database; override;
  end;

type
  TftcChamp_DateTimePicker = class(TForm)
    Button1: TButton;
    cl: TChamp_Label;
    cdtp: TChamp_DateTimePicker;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    bl: TblTest_Champ_DateTimePicker;
  end;

var
  ftcChamp_DateTimePicker: TftcChamp_DateTimePicker;


implementation

{$R *.dfm}

{ TblTest_Champ_DateTimePicker }

constructor TblTest_Champ_DateTimePicker.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Test_Champ_DateTimePicker';
         CP.Font.Family:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= '';

     //champs persistants
     Champs.DateTime_from_Date( D, 'D');
end;

destructor TblTest_Champ_DateTimePicker.Destroy;
begin

  inherited;
end;

procedure TblTest_Champ_DateTimePicker.Save_to_database;
begin

end;

function TblTest_Champ_DateTimePicker.sCle: String;
begin
     Result:= '';
end;

procedure TftcChamp_DateTimePicker.Button1Click(Sender: TObject);
begin
     bl:= TblTest_Champ_DateTimePicker.Create( nil, nil, nil);
     Champs_Affecte( bl, [cdtp, cl]);
end;

initialization
              Clean_Create( ftcChamp_DateTimePicker, TftcChamp_DateTimePicker);
finalization
              Clean_Destroy( ftcChamp_DateTimePicker);
end.
