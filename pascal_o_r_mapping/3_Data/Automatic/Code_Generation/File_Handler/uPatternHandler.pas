unit uPatternHandler;
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
    uForms,
    uBatpro_StringList,
    uGenerateur_de_code_Ancetre,
    SysUtils, Classes, Dialogs;

type

 { TPatternHandler }

 TPatternHandler
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _g: TGenerateur_de_code_Ancetre;
                        _Source: String;
                        _slParametres: TBatpro_StringList);
    destructor Destroy; override;
  //Attributs
  private
    g: TGenerateur_de_code_Ancetre;
    Source: String;
    slSource: TBatpro_StringList;
    slCible : TBatpro_StringList;
    slParametres: TBatpro_StringList;
    function RemplaceParametres( S: String): String;
  public
    procedure Produit;
  //déboguage
  private
    Log_Actif: Boolean;
    slLog: TBatpro_StringList;
  end;

implementation

{ TPatternHandler }

constructor TPatternHandler.Create( _g: TGenerateur_de_code_Ancetre;
                                    _Source: String;
                                    _slParametres: TBatpro_StringList);
begin
     g:= _g;

     Source         := _Source         ;
     slParametres   := _slParametres;

     slSource:= TBatpro_StringList.Create;
     if not FileExists( Source)
     then
         uForms_ShowMessage( 'Introuvable '+Source);
     slLog  := TBatpro_StringList.Create;

     slSource.LoadFromFile( g.sRepSource+Source);
     slLog.Add( 'Original de '+Source);
     slLog.Add( slSource.Text);

     slCible:= TBatpro_StringList.Create;

end;

destructor TPatternHandler.Destroy;
begin
     if Pos( 'udmd', Source) <> 0
     then
         slLog.SaveToFile( g.sRepCible+Source+'.log');
     FreeAndNil( slCible     );
     FreeAndNil( slSource    );
     FreeAndNil( slLog       );
     inherited;
end;

function TPatternHandler.RemplaceParametres( S: String): String;
var
   I: Integer;
   OldKey, NewKey: String;
begin
     Result:= S;
     for I:= 0 to slParametres.Count -1
     do
       begin
       OldKey:= slParametres.Names [ I];
       NewKey:= slParametres.Values[OldKey];
       if Log_Actif then slLog.Add( 'Remplacement de '+OldKey+' par '+NewKey);
       Result:= StringReplace(Result,OldKey,NewKey,[rfReplaceAll,rfIgnoreCase]);
       if Log_Actif then slLog.Add( Result);
       end;
end;

procedure TPatternHandler.Produit;
var
   CibleName: String;
   Chemin: String;
begin
     Log_Actif:= False;
     CibleName:= g.sRepCible+RemplaceParametres( Source);
     Chemin:= ExtractFilePath( CibleName);
     ForceDirectories( Chemin);

     Log_Actif:= True;
     slCible.Text:= RemplaceParametres( slSource.Text);
     slCible.SaveToFile( CibleName);
     Log_Actif:= False;
end;

end.
