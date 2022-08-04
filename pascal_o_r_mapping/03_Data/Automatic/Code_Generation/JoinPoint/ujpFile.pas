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
  SysUtils, Classes, FileUtil;

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
  protected
    Premier: Boolean;
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure Finalise; override;
  end;

 TjpfMembre
 =
  class( TjpFile)
  //Gestion de la visite d'une classe
  public
    procedure VisiteMembre(_cm: TContexteMembre); override;
  end;

 { TjpfDetail }

 TjpfDetail
 =
  class( TjpFile)
  //Gestion de la visite d'une classe
  public
    procedure VisiteDetail( s_Detail, sNomTableMembre: String); override;
  end;

 { TjpfAggregation }

 TjpfAggregation
 =
  class( TjpFile)
  //Gestion de la visite d'une classe
  public
    procedure VisiteAggregation( s_Aggregation, sNomTableMembre: String); override;
  end;

 { TIterateur_jpFile }

 TIterateur_jpFile
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TjpFile);
    function  not_Suivant( var _Resultat: TjpFile): Boolean;
  end;

 TIterateur_jpfMembre
 =
  class( TIterateur_jpFile)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TjpfMembre);
    function  not_Suivant( var _Resultat: TjpfMembre): Boolean;
  end;

 TIterateur_jpfDetail
 =
  class( TIterateur_jpFile)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TjpfDetail);
    function  not_Suivant( var _Resultat: TjpfDetail): Boolean;
  end;

 TIterateur_jpfAggregation
 =
  class( TIterateur_jpFile)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TjpfAggregation);
    function  not_Suivant( var _Resultat: TjpfAggregation): Boolean;
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

 TsljpfMembre
 =
  class( TsljpFile)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_jpfMembre;
    function Iterateur_Decroissant: TIterateur_jpfMembre;
  end;

 TsljpfDetail
 =
  class( TsljpFile)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_jpfDetail;
    function Iterateur_Decroissant: TIterateur_jpfDetail;
  end;

 TsljpfAggregation
 =
  class( TsljpFile)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_jpfAggregation;
    function Iterateur_Decroissant: TIterateur_jpfAggregation;
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
function jpfMembre_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpfMembre;
function jpfDetail_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpfDetail;
function jpfAggregation_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpfAggregation;

procedure ujpFile_EnumFiles( _sRepertoire: String; _ffe: TFileFoundEvent; _Mask: String= '*.*');

implementation

function jpFile_from_sl( sl: TBatpro_StringList; Index: Integer): TjpFile;
begin
     _Classe_from_sl( Result, TjpFile, sl, Index);
end;

function jpFile_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpFile;
begin
     _Classe_from_sl_sCle( Result, TjpFile, sl, sCle);
end;

function jpfMembre_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpfMembre;
begin
     _Classe_from_sl_sCle( Result, TjpfMembre, sl, sCle);
end;

function jpfDetail_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpfDetail;
begin
     _Classe_from_sl_sCle( Result, TjpfDetail, sl, sCle);
end;

function jpfAggregation_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjpfAggregation;
begin
     _Classe_from_sl_sCle( Result, TjpfAggregation, sl, sCle);
end;

procedure ujpFile_EnumFiles( _sRepertoire: String; _ffe: TFileFoundEvent; _Mask: String= '*.*');
var
   fs: TFileSearcher;
begin
     fs:= TFileSearcher.Create;
     try
        fs.OnFileFound:= _ffe;
        fs.Search( _sRepertoire, _Mask);
     finally
            FreeAndNil( fs);
            end;
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

{ TIterateur_jpfMembre }

function TIterateur_jpfMembre.not_Suivant( var _Resultat: TjpfMembre): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_jpfMembre.Suivant( var _Resultat: TjpfMembre);
begin
     Suivant_interne( _Resultat);
end;

{ TIterateur_jpfDetail }

function TIterateur_jpfDetail.not_Suivant( var _Resultat: TjpfDetail): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_jpfDetail.Suivant( var _Resultat: TjpfDetail);
begin
     Suivant_interne( _Resultat);
end;

{ TIterateur_jpfAggregation }

function TIterateur_jpfAggregation.not_Suivant( var _Resultat: TjpfAggregation): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_jpfAggregation.Suivant( var _Resultat: TjpfAggregation);
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
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.Initialise( _cc);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TsljpFile.VisiteMembre(_cm: TContexteMembre);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.VisiteMembre( _cm);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TsljpFile.VisiteDetail( s_Detail, sNomTableMembre: String);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.VisiteDetail( s_Detail, sNomTableMembre);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TsljpFile.VisiteAggregation(s_Aggregation, sNomTableMembre: String);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.VisiteAggregation( s_Aggregation, sNomTableMembre);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TsljpFile.Finalise;
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
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

procedure TsljpFile.To_Parametres(_sl: TStringList);
var
   I: TIterateur_jpFile;
   jpf: TjpFile;
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

{ TsljpfMembre }

constructor TsljpfMembre.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TjpfMembre);
end;

destructor TsljpfMembre.Destroy;
begin
     inherited;
end;

class function TsljpfMembre.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_jpfMembre;
end;

function TsljpfMembre.Iterateur: TIterateur_jpfMembre;
begin
     Result:= TIterateur_jpfMembre( Iterateur_interne);
end;

function TsljpfMembre.Iterateur_Decroissant: TIterateur_jpfMembre;
begin
     Result:= TIterateur_jpfMembre( Iterateur_interne_Decroissant);
end;

{ TsljpfDetail }

constructor TsljpfDetail.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TjpfDetail);
end;

destructor TsljpfDetail.Destroy;
begin
     inherited;
end;

class function TsljpfDetail.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_jpfDetail;
end;

function TsljpfDetail.Iterateur: TIterateur_jpfDetail;
begin
     Result:= TIterateur_jpfDetail( Iterateur_interne);
end;

function TsljpfDetail.Iterateur_Decroissant: TIterateur_jpfDetail;
begin
     Result:= TIterateur_jpfDetail( Iterateur_interne_Decroissant);
end;

{ TsljpfAggregation }

constructor TsljpfAggregation.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TjpfAggregation);
end;

destructor TsljpfAggregation.Destroy;
begin
     inherited;
end;

class function TsljpfAggregation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_jpfAggregation;
end;

function TsljpfAggregation.Iterateur: TIterateur_jpfAggregation;
begin
     Result:= TIterateur_jpfAggregation( Iterateur_interne);
end;

function TsljpfAggregation.Iterateur_Decroissant: TIterateur_jpfAggregation;
begin
     Result:= TIterateur_jpfAggregation( Iterateur_interne_Decroissant);
end;

{ TjpFile }

constructor TjpFile.Create( _nfKey: String);
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

procedure TjpFile.Initialise(_cc: TContexteClasse);
begin
     inherited;
     Valeur:= cc.Produit( 'Classe.', sBegin);
     Premier:= True;
end;

procedure TjpfMembre.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     Valeur:= Valeur+ cm.Produit( 'Membre.', sElement);
end;

procedure TjpfDetail.VisiteDetail(s_Detail, sNomTableMembre: String);
var
   Element: String;
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     Element:= sElement;
     Element:= StringReplace( Element, 'Detail.Classe',sNomTableMembre,[rfReplaceAll,rfIgnoreCase]);
     Element:= StringReplace( Element, 'Detail'       ,s_Detail       ,[rfReplaceAll,rfIgnoreCase]);
     Valeur:= Valeur+ Element;
end;

procedure TjpfAggregation.VisiteAggregation( s_Aggregation, sNomTableMembre: String);
var
   Element: String;
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     Element:= sElement;
     Element:= StringReplace( Element, 'Aggregation.Classe',sNomTableMembre,[rfReplaceAll,rfIgnoreCase]);
     Element:= StringReplace( Element, 'Aggregation'       ,s_Aggregation  ,[rfReplaceAll,rfIgnoreCase]);
     Valeur:= Valeur+ Element;
end;

procedure TjpFile.Finalise;
begin
     Valeur:= Valeur+cc.Produit( 'Classe.', sEnd);
     inherited;
end;

end.
