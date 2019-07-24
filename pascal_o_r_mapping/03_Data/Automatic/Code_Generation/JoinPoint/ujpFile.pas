unit ujpFile;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    uuStrings,
    uBatpro_StringList,
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
  SysUtils, Classes;

type

 { TjpFile }

 TjpFile
 =
  class( TJoinPoint)
  public
  //cycle de vie
  public
    constructor Create( _nfKey: String);
  // attributs
  public
    nfKey       : String; sKey       : String;
    nfBegin     : String; sBegin     : String;
    nfElement   : String; sElement   : String;
    nfSeparateur: String; sSeparateur: String;
    nfEnd       : String; sEnd       : String;
  //Gestion de la visite d'une classe
  private
    Premier: Boolean;
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure VisiteMembre(_cm: TContexteMembre); override;
    procedure Finalise; override;
  end;

 TIterateur_jpFile
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TjpFile);
    function  not_Suivant( var _Resultat: TjpFile): Boolean;
  end;

 { TsljpFile }

 TsljpFile
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
    function Iterateur: TIterateur_jpFile;
    function Iterateur_Decroissant: TIterateur_jpFile;
  //Gestion de la visite d'une classe
  public
    procedure Initialise( _cc: TContexteClasse);
    procedure VisiteMembre( _cm: TContexteMembre);
    procedure VisiteDetail( s_Detail, sNomTableMembre: String);
    procedure VisiteAggregation( s_Aggregation, sNomTableMembre: String);
    procedure Finalise;
    procedure To_Parametres( _sl: TStringList);
  end;



const
     s_key_       = '.01_key.'       ;
     s_begin_     = '.02_begin.'     ;
     s_element_   = '.03_element.'   ;
     s_separateur_= '.04_separateur.';
     s_end_       = '.05_end.'       ;

     s_key_mask='*'+s_key_+'*';

function jpFile_from_sl( sl: TBatpro_StringList; Index: Integer): TjpFile;
function jpFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpFile;

implementation

function jpFile_from_sl( sl: TBatpro_StringList; Index: Integer): TjpFile;
begin
     _Classe_from_sl( Result, TjpFile, sl, Index);
end;

function jpFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpFile;
begin
     _Classe_from_sl_sCle( Result, TjpFile, sl, sCle);
end;

{ TIterateur_jpFile }

function TIterateur_jpFile.not_Suivant( var _Resultat: TjpFile): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_jpFile.Suivant( var _Resultat: TjpFile);
begin
     Suivant_interne( _Resultat);
end;

{ TsljpFile }

constructor TsljpFile.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TjpFile);
end;

destructor TsljpFile.Destroy;
begin
     inherited;
end;

class function TsljpFile.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_jpFile;
end;

function TsljpFile.Iterateur: TIterateur_jpFile;
begin
     Result:= TIterateur_jpFile( Iterateur_interne);
end;

function TsljpFile.Iterateur_Decroissant: TIterateur_jpFile;
begin
     Result:= TIterateur_jpFile( Iterateur_interne_Decroissant);
end;

procedure TsljpFile.Initialise( _cc: TContexteClasse);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.Initialise( _cc);
       end;
end;

procedure TsljpFile.VisiteMembre(_cm: TContexteMembre);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.VisiteMembre( _cm);
       end;
end;

procedure TsljpFile.VisiteDetail( s_Detail, sNomTableMembre: String);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.VisiteDetail( s_Detail, sNomTableMembre);
       end;
end;

procedure TsljpFile.VisiteAggregation(s_Aggregation, sNomTableMembre: String);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.VisiteAggregation( s_Aggregation, sNomTableMembre);
       end;
end;

procedure TsljpFile.Finalise;
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.Finalise;
       end;
end;

procedure TsljpFile.To_Parametres(_sl: TStringList);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.To_Parametres( _sl);
       end;
end;

{ TjpFile }

constructor TjpFile.Create( _nfKey: String);
begin
     nfKey       := _nfKey;
     nfBegin     := StringReplace( nfKey, s_key_, s_begin_     , [rfReplaceAll]);
     nfElement   := StringReplace( nfKey, s_key_, s_element_   , [rfReplaceAll]);
     nfSeparateur:= StringReplace( nfKey, s_key_, s_separateur_, [rfReplaceAll]);
     nfEnd       := StringReplace( nfKey, s_key_, s_end_       , [rfReplaceAll]);

     sKey       := String_from_File( nfKey       );
     sBegin     := String_from_File( nfBegin     );
     sElement   := String_from_File( nfElement   );
     sSeparateur:= String_from_File( nfSeparateur);
     sEnd       := String_from_File( nfEnd       );

     Cle:= sKey;
end;

procedure TjpFile.Initialise(_cc: TContexteClasse);
begin
     inherited;
     Valeur:= cc.Produit( 'Classe.', sBegin);
     Premier:= True;
end;

procedure TjpFile.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     Valeur:= Valeur+ cm.Produit( 'Membre.', sElement);
end;

procedure TjpFile.Finalise;
begin
     Valeur:= Valeur+cc.Produit( 'Classe.', sEnd);
     inherited;
end;

end.
