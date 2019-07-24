unit uApplicationJoinPointFile;
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

 { TApplicationJoinPointFile }

 TApplicationJoinPointFile
 =
  class
  public
  //cycle de vie
  public
    constructor Create( _nfKey: String);
  //Attributs
  public
    nfKey       : String; sKey       : String;
    nfBegin     : String; sBegin     : String;
    nfElement   : String; sElement   : String;
    nfSeparateur: String; sSeparateur: String;
    nfEnd       : String; sEnd       : String;
  public
    Cle: String;
    Valeur: String;
  //Gestion de la visite d'une classe
  private
    Premier: Boolean;
  public
    procedure Initialise;
    procedure VisiteClasse( _cc: TContexteClasse);
    procedure Finalise;
    procedure To_Parametres( _sl: TStringList);
  end;

 TIterateur_ApplicationJoinPointFile
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TApplicationJoinPointFile);
    function  not_Suivant( var _Resultat: TApplicationJoinPointFile): Boolean;
  end;

 { TslApplicationJoinPointFile }

 TslApplicationJoinPointFile
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
    function Iterateur: TIterateur_ApplicationJoinPointFile;
    function Iterateur_Decroissant: TIterateur_ApplicationJoinPointFile;
  //Gestion de la visite d'une classe
  public
    procedure Initialise;
    procedure VisiteClasse( _cc: TContexteClasse);
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

function ApplicationJoinPointFile_from_sl( sl: TBatpro_StringList; Index: Integer): TApplicationJoinPointFile;
function ApplicationJoinPointFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TApplicationJoinPointFile;

implementation

function ApplicationJoinPointFile_from_sl( sl: TBatpro_StringList; Index: Integer): TApplicationJoinPointFile;
begin
     _Classe_from_sl( Result, TApplicationJoinPointFile, sl, Index);
end;

function ApplicationJoinPointFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TApplicationJoinPointFile;
begin
     _Classe_from_sl_sCle( Result, TApplicationJoinPointFile, sl, sCle);
end;

{ TIterateur_ApplicationJoinPointFile }

function TIterateur_ApplicationJoinPointFile.not_Suivant( var _Resultat: TApplicationJoinPointFile): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ApplicationJoinPointFile.Suivant( var _Resultat: TApplicationJoinPointFile);
begin
     Suivant_interne( _Resultat);
end;

{ TslApplicationJoinPointFile }

constructor TslApplicationJoinPointFile.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TApplicationJoinPointFile);
end;

destructor TslApplicationJoinPointFile.Destroy;
begin
     inherited;
end;

class function TslApplicationJoinPointFile.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_ApplicationJoinPointFile;
end;

function TslApplicationJoinPointFile.Iterateur: TIterateur_ApplicationJoinPointFile;
begin
     Result:= TIterateur_ApplicationJoinPointFile( Iterateur_interne);
end;

function TslApplicationJoinPointFile.Iterateur_Decroissant: TIterateur_ApplicationJoinPointFile;
begin
     Result:= TIterateur_ApplicationJoinPointFile( Iterateur_interne_Decroissant);
end;

procedure TslApplicationJoinPointFile.Initialise;
var
   I: TIterateur_ApplicationJoinPointFile;
   jpf: TApplicationJoinPointFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.Initialise;
       end;
end;

procedure TslApplicationJoinPointFile.VisiteClasse( _cc: TContexteClasse);
var
   I: TIterateur_ApplicationJoinPointFile;
   jpf: TApplicationJoinPointFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.VisiteClasse( _cc);
       end;
end;

procedure TslApplicationJoinPointFile.Finalise;
var
   I: TIterateur_ApplicationJoinPointFile;
   jpf: TApplicationJoinPointFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.Finalise;
       end;
end;

procedure TslApplicationJoinPointFile.To_Parametres(_sl: TStringList);
var
   I: TIterateur_ApplicationJoinPointFile;
   jpf: TApplicationJoinPointFile;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jpf) then Continue;
       jpf.To_Parametres( _sl);
       end;
end;

{ TApplicationJoinPointFile }

constructor TApplicationJoinPointFile.Create( _nfKey: String);
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

procedure TApplicationJoinPointFile.Initialise;
begin
     inherited;
     Valeur:= sBegin;
     Premier:= True;
end;

procedure TApplicationJoinPointFile.VisiteClasse(_cc: TContexteClasse);
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     Valeur:= Valeur+ _cc.Produit( 'Classe.', sElement);
end;

procedure TApplicationJoinPointFile.Finalise;
begin
     Valeur:= Valeur+sEnd;
     inherited;
end;

procedure TApplicationJoinPointFile.To_Parametres(_sl: TStringList);
begin
     _sl.Values[ Cle]:= Valeur;
end;

end.
