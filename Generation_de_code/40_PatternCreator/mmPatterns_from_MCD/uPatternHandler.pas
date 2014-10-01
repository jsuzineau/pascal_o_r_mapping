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
    SysUtils, Classes, Dialogs;

type
 TPatternHandler
 =
  class
  private
    Source: String;
    RepertoireCible: String;
    slSource: TStringList;
    slCible : TStringList;
    slParametres: TStringList;
    function RemplaceParametres( S: String): String;
  public
    constructor Create( _Source, _RepertoireCible: String;
                        _slParametres: TStringList);
    destructor Destroy; override;

    procedure Produit;
  //déboguage
  private
    Log_Actif: Boolean;
    slLog: TStringList;
  end;

implementation

{ TPatternHandler }

constructor TPatternHandler.Create( _Source, _RepertoireCible: String;
                                    _slParametres: TStringList);
begin
     Source         := _Source         ;
     RepertoireCible:= _RepertoireCible;
     slParametres   := _slParametres;

     slSource:= TStringList.Create;
     if not FileExists( Source)
     then
         ShowMessage( 'Introuvable '+Source);
     slLog  := TStringList.Create;

     slSource.LoadFromFile( Source);
     slLog.Add( 'Original de '+Source);
     slLog.Add( slSource.Text);

     slCible:= TStringList.Create;

end;

destructor TPatternHandler.Destroy;
begin
     if Pos( 'udmd', Source) <> 0
     then
         slLog.SaveToFile( RepertoireCible+ExtractFileName( Source)+'.log');
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
begin
     //slLog.Add( 'avant produit '+ExtractFileName( Source));
     //slLog.SaveToFile( RepertoireCible+ExtractFileName( Source)+'.log');
     //Log_Actif:= True;
     CibleName:= RemplaceParametres( ExtractFileName( Source));

     Log_Actif:= True;
     slCible.Text:= RemplaceParametres( slSource.Text);
     slCible.SaveToFile( RepertoireCible + CibleName);
     Log_Actif:= False;
end;

end.
