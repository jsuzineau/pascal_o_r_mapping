unit uApplicationJoinPointFile_OpenAPI_Path;
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
    ujpFile,
    uOpenAPI,
  SysUtils, Classes;

type

 { TApplicationJoinPointFile_OpenAPI_Path }

 TApplicationJoinPointFile_OpenAPI_Path
 =
  class(TJoinPointFile_Ancetre)
  public
  //cycle de vie
  public
    constructor Create( _nfKey: String);override;
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
    procedure VisitePath( _p: TPath);
    procedure Finalise;
    procedure To_Parametres( _sl: TStringList);
  end;

 TIterateur_ApplicationJoinPointFile_OpenAPI_Path
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path);
    function  not_Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path): Boolean;
  end;

 { TslApplicationJoinPointFile_OpenAPI_Path }

 TslApplicationJoinPointFile_OpenAPI_Path
 =
  class( TslJoinPointFile_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
    function Iterateur_Decroissant: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
  //Gestion de la visite d'une classe
  public
    procedure Initialise;
    procedure VisitePath( _p: TPath);
    procedure Finalise;
    procedure To_Parametres( _sl: TStringList);
  end;

function ApplicationJoinPointFile_OpenAPI_Path_from_sl( sl: TBatpro_StringList; Index: Integer): TApplicationJoinPointFile_OpenAPI_Path;
function ApplicationJoinPointFile_OpenAPI_Path_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TApplicationJoinPointFile_OpenAPI_Path;

implementation

function ApplicationJoinPointFile_OpenAPI_Path_from_sl( sl: TBatpro_StringList; Index: Integer): TApplicationJoinPointFile_OpenAPI_Path;
begin
     _Classe_from_sl( Result, TApplicationJoinPointFile_OpenAPI_Path, sl, Index);
end;

function ApplicationJoinPointFile_OpenAPI_Path_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TApplicationJoinPointFile_OpenAPI_Path;
begin
     _Classe_from_sl_sCle( Result, TApplicationJoinPointFile_OpenAPI_Path, sl, sCle);
end;

{ TIterateur_ApplicationJoinPointFile_OpenAPI_Path }

function TIterateur_ApplicationJoinPointFile_OpenAPI_Path.not_Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ApplicationJoinPointFile_OpenAPI_Path.Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path);
begin
     Suivant_interne( _Resultat);
end;

{ TslApplicationJoinPointFile_OpenAPI_Path }

constructor TslApplicationJoinPointFile_OpenAPI_Path.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TApplicationJoinPointFile_OpenAPI_Path);
     Classe_JoinPointFile:= TApplicationJoinPointFile_OpenAPI_Path;
end;

destructor TslApplicationJoinPointFile_OpenAPI_Path.Destroy;
begin
     inherited;
end;

class function TslApplicationJoinPointFile_OpenAPI_Path.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
end;

function TslApplicationJoinPointFile_OpenAPI_Path.Iterateur: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
begin
     Result:= TIterateur_ApplicationJoinPointFile_OpenAPI_Path( Iterateur_interne);
end;

function TslApplicationJoinPointFile_OpenAPI_Path.Iterateur_Decroissant: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
begin
     Result:= TIterateur_ApplicationJoinPointFile_OpenAPI_Path( Iterateur_interne_Decroissant);
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path.Initialise;
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
   jpf: TApplicationJoinPointFile_OpenAPI_Path;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.Initialise;
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path.VisitePath(_p: TPath);
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
   jpf: TApplicationJoinPointFile_OpenAPI_Path;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.VisitePath( _p);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path.Finalise;
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
   jpf: TApplicationJoinPointFile_OpenAPI_Path;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.Finalise;
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path.To_Parametres(_sl: TStringList);
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path;
   jpf: TApplicationJoinPointFile_OpenAPI_Path;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.To_Parametres( _sl);
          end;
     finally
            FreeAndNil( I);
            end;
end;

{ TApplicationJoinPointFile_OpenAPI_Path }

constructor TApplicationJoinPointFile_OpenAPI_Path.Create( _nfKey: String);
   procedure RemoveTrailing_LineEnding( var _s: String);
   var
      ls: Integer;
      lle: Integer;
   begin
        lle:= Length( LineEnding);
        ls := Length( _s);
        if ls < lle then exit;

        Delete( _s, ls-lle+1, lle);
   end;
   function s_from_nf( _nf: String):String;
   begin
        Result:= String_from_File( _nf);
        RemoveTrailing_LineEnding( Result);
   end;
begin
     nfKey       := _nfKey;
     nfBegin     := StringReplace( nfKey, s_key_, s_begin_     , [rfReplaceAll]);
     nfElement   := StringReplace( nfKey, s_key_, s_element_   , [rfReplaceAll]);
     nfSeparateur:= StringReplace( nfKey, s_key_, s_separateur_, [rfReplaceAll]);
     nfEnd       := StringReplace( nfKey, s_key_, s_end_       , [rfReplaceAll]);

     sKey       := s_from_nf( nfKey       );
     sBegin     := s_from_nf( nfBegin     );
     sElement   := s_from_nf( nfElement   );
     sSeparateur:= s_from_nf( nfSeparateur);
     sEnd       := s_from_nf( nfEnd       );

     Cle:= sKey;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path.Initialise;
begin
     inherited;
     Valeur:= sBegin;
     Premier:= True;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path.VisitePath(_p: TPath);
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     Valeur:= Valeur+ _p.Produit( 'Path.', sElement);
end;

procedure TApplicationJoinPointFile_OpenAPI_Path.Finalise;
begin
     Valeur:= Valeur+sEnd;
     inherited;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path.To_Parametres(_sl: TStringList);
begin
     _sl.Values[ Cle]:= Valeur;
end;

end.
