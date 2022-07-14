unit uTemplateHandler;
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

 { TTemplateHandler }

 TTemplateHandler
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
    function Calcule_NomCible: String;
  public //pas propre, passé en public pour que TcsMenuHandler
         //puisse éventuellement surcharger l'initialisation
         //faite avant par l'exploration directe du répertoire
    slParametres: TBatpro_StringList;
  private
    function RemplaceParametres( S: String): String;
  public
    procedure Produit;
  //déboguage
  private
    Log_Actif: Boolean;
    slLog: TBatpro_StringList;
  //Répertoire racine
  protected
    function GetRepertoire: String; virtual;
  end;

 { TApplicationTemplateHandler }

 TApplicationTemplateHandler
 =
  class( TTemplateHandler)
  //Répertoire racine
  protected
    function GetRepertoire: String; override;
  end;

 TIterateur_TemplateHandler
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TTemplateHandler);
    function  not_Suivant( var _Resultat: TTemplateHandler): Boolean;
  end;

 { TslTemplateHandler }

 TslTemplateHandler
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_TemplateHandler;
    function Iterateur_Decroissant: TIterateur_TemplateHandler;
  end;

function TemplateHandler_from_sl( sl: TBatpro_StringList; Index: Integer): TTemplateHandler;
function TemplateHandler_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TTemplateHandler;

implementation

function TemplateHandler_from_sl( sl: TBatpro_StringList; Index: Integer): TTemplateHandler;
begin
     _Classe_from_sl( Result, TTemplateHandler, sl, Index);
end;

function TemplateHandler_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TTemplateHandler;
begin
     _Classe_from_sl_sCle( Result, TTemplateHandler, sl, sCle);
end;

{ TIterateur_TemplateHandler }

function TIterateur_TemplateHandler.not_Suivant( var _Resultat: TTemplateHandler): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_TemplateHandler.Suivant( var _Resultat: TTemplateHandler);
begin
     Suivant_interne( _Resultat);
end;

{ TslTemplateHandler }

constructor TslTemplateHandler.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TTemplateHandler);
end;

destructor TslTemplateHandler.Destroy;
begin
     inherited;
end;

class function TslTemplateHandler.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TemplateHandler;
end;

function TslTemplateHandler.Iterateur: TIterateur_TemplateHandler;
begin
     Result:= TIterateur_TemplateHandler( Iterateur_interne);
end;

function TslTemplateHandler.Iterateur_Decroissant: TIterateur_TemplateHandler;
begin
     Result:= TIterateur_TemplateHandler( Iterateur_interne_Decroissant);
end;

{ TApplicationTemplateHandler }

function TApplicationTemplateHandler.GetRepertoire: String;
begin
     Result:= g.sRepertoireApplicationTemplate;
end;

{ TTemplateHandler }

constructor TTemplateHandler.Create( _g: TGenerateur_de_code_Ancetre;
                                    _Source: String;
                                    _slParametres: TBatpro_StringList);
var
   Source_FullPath: String;
begin
     g:= _g;

     Source         := _Source         ;
     slParametres   := _slParametres;

     Source_FullPath:= GetRepertoire+Source;
     slSource:= TBatpro_StringList.Create;
     if not FileExists( Source_FullPath)
     then
         uForms_ShowMessage( 'Introuvable '+Source);
     slLog  := TBatpro_StringList.Create;

     slSource.LoadFromFile( Source_FullPath);
     slLog.Add( 'Original de '+Source);
     slLog.Add( slSource.Text);

     slCible:= TBatpro_StringList.Create;

end;
function TTemplateHandler.GetRepertoire: String;
begin
     Result:= g.sRepertoireTemplate;
end;


destructor TTemplateHandler.Destroy;
begin
     if Pos( 'udk', Source) <> 0
     then
         slLog.SaveToFile( Calcule_NomCible+'.log');
     FreeAndNil( slCible     );
     FreeAndNil( slSource    );
     FreeAndNil( slLog       );
     inherited;
end;

function TTemplateHandler.Calcule_NomCible: String;
begin
     Result:= g.sRepertoireResultat+RemplaceParametres( Source);
end;

function TTemplateHandler.RemplaceParametres( S: String): String;
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

procedure TTemplateHandler.Produit;
var
   CibleName: String;
   Chemin: String;
begin
     Log_Actif:= False;
     CibleName:= Calcule_NomCible;
     Chemin:= ExtractFilePath( CibleName);
     ForceDirectories( Chemin);

     Log_Actif:= True;
     slCible.Text:= RemplaceParametres( slSource.Text);
     slCible.SaveToFile( CibleName);
     Log_Actif:= False;
end;

end.
