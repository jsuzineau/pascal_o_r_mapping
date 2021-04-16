unit uPublieur;
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
{$mode delphi}
interface

uses
    uClean,
    uSkipList,
    uBatpro_StringList,
    ufAccueil_Erreur,
    uJCL,
  SysUtils, Classes;

type

 TPublieur= class;
 TObjet // cette classe ne sert que pour le test dans utc_Publieur
 =      // elle a été placée ici pour permettre des affichages de déboguage
  class // plus poussés
  //Gestion du cycle de vie
  public
    constructor Create( _I: Integer; _p: TPublieur; _s: PString);
    destructor Destroy; override;
  //Attributs
  public
    I: Integer;
    p: TPublieur;
    s: PString;
  //Méthodes
  private
    procedure p_publie1;
    procedure p_publie2;
  public
    procedure Abonne1;
    procedure Desabonne1;
    procedure Abonne2;
    procedure Desabonne2;
  end;

 TAbonnement_Procedure_Proc= procedure;

 TAbonnement_Objet_Proc= procedure of object;

 TListe_Abonnements = class;

 TAbonnement
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Liste_Abonnements: TListe_Abonnements);
  //Méthodes
  public
    procedure DoProc; virtual; abstract;
    function Description: String; virtual; abstract;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  virtual; abstract;
    // a < self :-1  a=self :0  a > self :+1
  //Attributs Liste
  public
    Liste_Abonnements: TListe_Abonnements;
    Precedent, Suivant: TAbonnement;
  //Méthodes Liste
  public
    procedure Detache_interne;
    procedure Detache;
  end;

 TAbonnement_Procedure
 =
  class( TAbonnement)
  //Gestion du cycle de vie
  public
    constructor Create( _Proc: TAbonnement_Procedure_Proc;
                        _Liste_Abonnements: TListe_Abonnements);
  //Attributs
  public
    Proc: TAbonnement_Procedure_Proc;
  //Méthodes surchargées
  public
    procedure DoProc; override;
    function Description: String; override;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  end;

 TIterateur_Abonnement_Procedure
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TAbonnement_Procedure);
    function  not_Suivant( var _Resultat: TAbonnement_Procedure): Boolean;
  end;

 { TslAbonnement_Procedure }

 TslAbonnement_Procedure
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
    function Iterateur: TIterateur_Abonnement_Procedure;
    function Iterateur_Decroissant: TIterateur_Abonnement_Procedure;
  //Méthodes
  public
    procedure Ajoute( _Cle: String; _Proc: TAbonnement_Procedure_Proc);
    procedure Enleve( _Cle: String);
  end;

 TAbonnement_Objet
 =
  class( TAbonnement)
  //Gestion du cycle de vie
  public
    constructor Create( _Objet: TObject; _Proc: TAbonnement_Objet_Proc;
                        _Liste_Abonnements: TListe_Abonnements);
  //Attributs
  public
    Objet: TObject;
    Proc: TAbonnement_Objet_Proc;
  //Méthodes surchargées
  public
    procedure DoProc; override;
    function  Description: String; override;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  end;

 TIterateur_Abonnement_Objet
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TAbonnement_Objet);
    function  not_Suivant( var _Resultat: TAbonnement_Objet): Boolean;
  end;

 { TslAbonnement_Objet }

 TslAbonnement_Objet
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
    function Iterateur: TIterateur_Abonnement_Objet;
    function Iterateur_Decroissant: TIterateur_Abonnement_Objet;
    //Méthodes
    public
      procedure Ajoute( _Cle: String; _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
      procedure Enleve( _Cle: String);
  end;

 TListe_Abonnements
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Debut, Fin: TAbonnement;
  //Méthodes
  public
    procedure Append ( _a: TAbonnement);
    procedure Detache( _a: TAbonnement);
    procedure Remplace( _Avant, _Apres: TAbonnement);
  //Iterateur
  public
    aIterateur_Suivant: TAbonnement;
    procedure Iterateur_Start;
    procedure Iterateur_Suivant( var _Resultat: TAbonnement);
    function  Iterateur_EOF: Boolean;
  end;

 TskiAbonnement
 =
  class(TSkipList_Item)
  //Gestion du cycle de vie
  public
    constructor Create( _Key: Pointer; _Value: TObject); override;
  //Méthodes
  public
    function Description: String; virtual;
  //Attributs
  public
    A: TAbonnement;
  //Clé
  public
    function Key: Pointer; override;
  //Libelle
  protected
    function Libelle_interne: String; override;
  //Comparaison
  public
    function  Compare( _Key: Pointer):Shortint;  override;
    // a < self :-1  a=self :0  a > self :+1
  end;

 TPublieur
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String);
    destructor Destroy; override;
  //Attributs
  //private
  public //mis en public pour tests
    skProcedure: TSkipList;
    skObjet    : TSkipList;
    Liste_Abonnements: TListe_Abonnements;
  public
    Name: String;
    Log_Publications: Boolean;
  //Tests
  private
    slSupprimes: TBatpro_StringList;
  //Méthodes
  public
    procedure Abonne   (                  _Proc: TAbonnement_Procedure_Proc); overload;
    procedure Abonne   ( _Objet: TObject; _Proc: TAbonnement_Objet_Proc    ); overload;

    procedure Desabonne(                  _Proc: TAbonnement_Procedure_Proc); overload;
    procedure Desabonne( _Objet: TObject; _Proc: TAbonnement_Objet_Proc    ); overload;
    procedure Publie;
    procedure Publie_par_sk_pour_test;

    function Description: String;
  //Activation
  public
    Actif: Boolean;
  end;

var
   uPublieur_Indentation: String= '';
   uPublieur_Log_Publications: Boolean = False;
   uPublieur_Actif: Boolean = True;
   uPublieur_MoveTo_Count: Integer= 0;
   uPublieur_MoveTo_Last: String= '';
   uPublieur_s: PString=nil;

function Abonnement_Procedure_from_sl( sl: TBatpro_StringList; Index: Integer): TAbonnement_Procedure;
function Abonnement_Procedure_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TAbonnement_Procedure;

function Abonnement_Objet_from_sl( sl: TBatpro_StringList; Index: Integer): TAbonnement_Objet;
function Abonnement_Objet_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TAbonnement_Objet;


implementation

{ TObjet }

constructor TObjet.Create( _I: Integer; _p: TPublieur; _s: PString);
begin
     I:= _I;
     p:= _p;
     s:= _s;
end;

destructor TObjet.Destroy;
begin

end;

procedure TObjet.p_publie1;
begin
     s^
     :=
        s^
       +IntToStr(I)
       //+'($'+IntToHex( Integer( Self), 8)+')'
       ;
end;

procedure TObjet.p_publie2;
begin
     s^
     :=
        s^
       +Chr(Ord('a')+I)
       //+'($'+IntToHex( Integer( Self), 8)+')'
       ;
end;

procedure TObjet.Abonne1;
begin
     {$IFDEF FPC_OBJFPC }
     p.Abonne( Self, @p_publie1);
     {$ELSE}
     p.Abonne( Self, p_publie1);
     {$ENDIF}
end;

procedure TObjet.Desabonne1;
begin
     {$IFDEF FPC_OBJFPC }
     p.Desabonne( Self, @p_publie1);
     {$ELSE}
     p.Desabonne( Self, p_publie1);
     {$ENDIF}
end;

procedure TObjet.Abonne2;
begin
     {$IFDEF FPC_OBJFPC }
     p.Abonne( Self, @p_publie2);
     {$ELSE}
     p.Abonne( Self, p_publie2);
     {$ENDIF}
end;


procedure TObjet.Desabonne2;
begin
     {$IFDEF FPC_OBJFPC }
     p.Desabonne( Self, @p_publie2);
     {$ELSE}
     p.Desabonne( Self, p_publie2);
     {$ENDIF}
end;

{ TAbonnement }

constructor TAbonnement.Create( _Liste_Abonnements: TListe_Abonnements);
begin
     inherited Create;
     Liste_Abonnements:= _Liste_Abonnements;
     Suivant  := nil;
     Precedent:= nil;
end;

procedure TAbonnement.Detache_interne;
begin
     if Assigned( Precedent) then Precedent.Suivant  := Suivant  ;
     if Assigned( Suivant  ) then Suivant  .Precedent:= Precedent;
     Suivant  := nil;
     Precedent:= nil;
end;

procedure TAbonnement.Detache;
begin
     if Assigned( Liste_Abonnements)
     then
         Liste_Abonnements.Detache( Self)
     else
         Detache_interne;
end;

{ TAbonnement_Procedure }
function Abonnement_Procedure_from_sl( sl: TBatpro_StringList; Index: Integer): TAbonnement_Procedure;
begin
     _Classe_from_sl( Result, TAbonnement_Procedure, sl, Index);
end;

function Abonnement_Procedure_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TAbonnement_Procedure;
begin
     _Classe_from_sl_sCle( Result, TAbonnement_Procedure, sl, sCle);
end;

constructor TAbonnement_Procedure.Create( _Proc: TAbonnement_Procedure_Proc;
                                          _Liste_Abonnements: TListe_Abonnements);
begin
     inherited Create( _Liste_Abonnements);
     Proc := _Proc;
end;

function TAbonnement_Procedure.Compare(_Key: Pointer): Shortint;
    // a < self :-1  a=self :0  a > self :+1
var
   ap: TAbonnement_Procedure;
begin
     if TObject(_Key) is TAbonnement_Procedure
     then
         ap:= TAbonnement_Procedure( TObject(_Key))
     else
         ap:= nil;

          if ap = nil                            then Result:=  0
     else if Integer(@ap.Proc) < Integer(@Proc)  then Result:= -1
     else if Integer(@ap.Proc) = Integer(@Proc)  then Result:=  0
     else                                             Result:= +1;
end;

function TAbonnement_Procedure.Description: String;
begin
     Result:= uPublieur_Indentation+
              'procedure à l''adresse $'+IntToHex( Integer( @Proc), 8);
end;

procedure TAbonnement_Procedure.DoProc;
begin
     if Assigned( Proc)
     then
         Proc;
end;

{ TIterateur_Abonnement_Procedure }

function TIterateur_Abonnement_Procedure.not_Suivant( var _Resultat: TAbonnement_Procedure): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Abonnement_Procedure.Suivant( var _Resultat: TAbonnement_Procedure);
begin
     Suivant_interne( _Resultat);
end;

{ TslAbonnement_Procedure }

constructor TslAbonnement_Procedure.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TAbonnement_Procedure);
end;

destructor TslAbonnement_Procedure.Destroy;
begin
     inherited;
end;

class function TslAbonnement_Procedure.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Abonnement_Procedure;
end;

function TslAbonnement_Procedure.Iterateur: TIterateur_Abonnement_Procedure;
begin
     Result:= TIterateur_Abonnement_Procedure( Iterateur_interne);
end;

function TslAbonnement_Procedure.Iterateur_Decroissant: TIterateur_Abonnement_Procedure;
begin
     Result:= TIterateur_Abonnement_Procedure( Iterateur_interne_Decroissant);
end;

procedure TslAbonnement_Procedure.Ajoute( _Cle: String; _Proc: TAbonnement_Procedure_Proc);
var
   ap: TAbonnement_Procedure;
begin
     Enleve( _Cle);

     ap:= TAbonnement_Procedure.Create( _Proc, nil);
     AddObject( _Cle, ap);
end;

procedure TslAbonnement_Procedure.Enleve( _Cle: String);
var
   I: Integer;
   O: TObject;
begin
     I:= IndexOf( _Cle);
     if -1 = I then exit;

     O:=Objects[I];
     Free_nil( O);

     Delete( I);
end;

{ TAbonnement_Objet }

function Abonnement_Objet_from_sl( sl: TBatpro_StringList; Index: Integer): TAbonnement_Objet;
begin
     _Classe_from_sl( Result, TAbonnement_Objet, sl, Index);
end;

function Abonnement_Objet_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TAbonnement_Objet;
begin
     _Classe_from_sl_sCle( Result, TAbonnement_Objet, sl, sCle);
end;

constructor TAbonnement_Objet.Create( _Objet: TObject;
                                      _Proc: TAbonnement_Objet_Proc;
                                      _Liste_Abonnements: TListe_Abonnements);
begin
     inherited Create( _Liste_Abonnements);
     Objet:= _Objet;
     Proc := _Proc;
end;

function TAbonnement_Objet.Compare( _Key: Pointer): Shortint;
    // a < self :-1  a=self :0  a > self :+1
var
   ao: TAbonnement_Objet;
   ao_Proc: TAbonnement_Objet_Proc;
begin
     if TObject( _Key) is TAbonnement_Objet
     then
         ao:= TAbonnement_Objet( TObject( _Key))
     else
         ao:= nil;

          if ao = nil                           then Result:=  0
     else if Integer(ao.Objet) < Integer(Objet) then Result:= -1
     else if Integer(ao.Objet) = Integer(Objet)
     then
         begin
         ao_Proc:= ao.Proc;
              if ao = nil                           then Result:=  0
         else if Integer(@ao_Proc) < Integer(@Proc) then Result:= -1
         else if Integer(@ao_Proc) = Integer(@Proc) then Result:=  0
         else                                            Result:= +1;
         end
     else                                                Result:= +1;

end;

function TAbonnement_Objet.Description: String;
var
   Objet_is_TComponent: Boolean;
   Objet_is_TObjet: Boolean;
begin
     Result:= uPublieur_Indentation+'Objet ';
     Objet_is_TComponent:= False;
     Objet_is_TObjet:= False;

     try
        if Self = nil then exit;
     except
           on E:Exception
           do
             Result
             :=
                Result
               +'sur test Self = nil : Exception >'+E.Message+'<';
           end;

     try
        if Objet = nil
        then
            begin
            Result:= Result + '<nil>';
            exit;
            end;
     except
           on E:Exception
           do
             Result
             :=
                Result
               +'sur test Objet = nil : Exception >'+E.Message+'<';
           end;


     try
        Objet_is_TComponent:= Objet is TComponent;
     except
           on E:Exception
           do
             Result
             :=
                Result
               +'sur test Objet is TComponent : Exception >'+E.Message+'<';
           end;

     if Objet_is_TComponent
     then
         try
            Result:= Result+TComponent(Objet).Name
         except
               on E:Exception
               do
                 Result
                 :=
                    Result
                   +'sur test TComponent(Objet).Name : Exception >'+E.Message+'<';
               end
     else
         try
            Result:= Result+'$'+IntToHex( Integer( Objet), 8);
         except
               on E:Exception
               do
                 Result
                 :=
                    Result
                   +'sur test Integer( Objet) : Exception >'+E.Message+'<';
               end;

     try
        Result:= Result+': '+Objet.ClassName;
     except
           on E:Exception
           do
             Result
             :=
                Result
               +'sur Objet.ClassName: Exception >'+E.Message+'<';
           end;

     try
        Objet_is_TObjet:= Objet is TObjet;
     except
           on E:Exception
           do
             Result
             :=
                Result
               +'sur Objet is TObjet: Exception >'+E.Message+'<';
           end;

     if Objet_is_TObjet
     then
         try
            Result:= Result+', valeur I: '+IntToStr(TObjet(Objet).I);
         except
               on E:Exception
               do
                 Result
                 :=
                    Result
                   +' sur TObjet(Objet).I : Exception >'+E.Message+'<';
               end;
end;

procedure TAbonnement_Objet.DoProc;
var
   M: TMethod;
begin
     if Assigned( Proc)
     then
         begin
         M:= TMethod(Proc);
         if M.Data = nil
         then
             fAccueil_Erreur('TAbonnement_Objet.DoProc: Appel sur méthode d''un objet nil', 'Erreur système');
         if M.Code = nil
         then
             fAccueil_Erreur('TAbonnement_Objet.DoProc: Appel sur méthode à nil', 'Erreur système');
         try
            Proc;
         except
               on E: Exception
               do
                 begin
                 {$IFDEF FPC}
                 DumpExceptionBackTrace( Output);
                 {$ENDIF}
                 uJCL_StackTrace( 'TAbonnement_Objet.DoProc: ', E);
                 end;
               end;
         end;
end;

{ TIterateur_Abonnement_Objet }

function TIterateur_Abonnement_Objet.not_Suivant( var _Resultat: TAbonnement_Objet): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Abonnement_Objet.Suivant( var _Resultat: TAbonnement_Objet);
begin
     Suivant_interne( _Resultat);
end;

{ TslAbonnement_Objet }

constructor TslAbonnement_Objet.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TAbonnement_Objet);
end;

destructor TslAbonnement_Objet.Destroy;
begin
     inherited;
end;

class function TslAbonnement_Objet.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Abonnement_Objet;
end;

function TslAbonnement_Objet.Iterateur: TIterateur_Abonnement_Objet;
begin
     Result:= TIterateur_Abonnement_Objet( Iterateur_interne);
end;

function TslAbonnement_Objet.Iterateur_Decroissant: TIterateur_Abonnement_Objet;
begin
     Result:= TIterateur_Abonnement_Objet( Iterateur_interne_Decroissant);
end;

procedure TslAbonnement_Objet.Ajoute( _Cle: String; _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
var
   ao: TAbonnement_Objet;
begin
     Enleve( _Cle);

     ao:= TAbonnement_Objet.Create( _Objet, _Proc, nil);
     AddObject( _Cle, ao);
end;

procedure TslAbonnement_Objet.Enleve(_Cle: String);
var
   I: Integer;
   O: TObject;
begin
     I:= IndexOf( _Cle);
     if -1 = I then exit;

     O:=Objects[I];
     Free_nil( O);

     Delete( I);
end;

{ TListe_Abonnements }

constructor TListe_Abonnements.Create;
begin
     Debut:= nil;
     Fin  := nil;
end;

destructor TListe_Abonnements.Destroy;
begin

     inherited;
end;

procedure TListe_Abonnements.Append( _a: TAbonnement);
begin
     if _a = nil then exit;

     if Debut = nil
     then
         Debut:= _a
     else
         begin
         Fin  .Suivant  := _a;
         _a.Precedent:= Fin  ;
         end;

     Fin:= _a;
end;

procedure TListe_Abonnements.Detache( _a: TAbonnement);
begin
     if _a =nil then exit;

     if Fin   = _a then Fin  := _a.Precedent;
     if Debut = _a then Debut:= _a.Suivant  ;

     _a.Detache_interne;
end;

procedure TListe_Abonnements.Iterateur_Start;
begin
     aIterateur_Suivant:= Debut;
end;

procedure TListe_Abonnements.Iterateur_Suivant( var _Resultat: TAbonnement);
begin
     _Resultat:= aIterateur_Suivant;
     if Assigned( aIterateur_Suivant)
     then
         aIterateur_Suivant:= aIterateur_Suivant.Suivant;
end;

function TListe_Abonnements.Iterateur_EOF: Boolean;
begin
     Result:= aIterateur_Suivant = nil;
end;

procedure TListe_Abonnements.Remplace( _Avant, _Apres: TAbonnement);
   procedure Remplace_interne( var _a: TAbonnement);
   begin
        if _a = _Avant
        then
            _a:= _Apres;
   end;
begin
     Remplace_interne( Debut);
     Remplace_interne( Fin  );
end;

{ TskiAbonnement }

constructor TskiAbonnement.Create( _Key: Pointer; _Value: TObject);
begin
     inherited Create( _Key, _Value);
     Affecte_( A, TAbonnement, _Value);
end;

function TskiAbonnement.Description: String;
begin
     Result:= '';
     try
        if A = nil
        then
            Result:= 'A=nil'
        else
            Result:= A.Description;
     except
           on E:Exception
           do
             Result
             :=
                Result
               +' Exception >'+E.Message+'<';
           end;
end;

function TskiAbonnement.Key: Pointer;
begin
     Result:= A;
end;

function TskiAbonnement.Libelle_interne: String;
begin
     Result:= Description;
end;

function TskiAbonnement.Compare( _Key: Pointer): Shortint;
begin
     if A = nil
     then
         Result:= -1
     else
         Result:= A.Compare( _Key);
end;

{ TPublieur }

constructor TPublieur.Create(_Name: String);
begin
     inherited Create;
     Name:= _Name;
     Log_Publications:= False;
     Actif:= True;
     Liste_Abonnements:= TListe_Abonnements.Create;
     skProcedure:= TSkipList.Create( TAbonnement_Procedure, TskiAbonnement, Name + '.skProcedure');
     skObjet    := TSkipList.Create( TAbonnement_Objet    , TskiAbonnement, Name + '.skObjet'    );

     slSupprimes:= TBatpro_StringList.Create;
end;

destructor TPublieur.Destroy;
begin
     Free_nil( slSupprimes);
     Free_nil( skProcedure      );
     Free_nil( skObjet          );
     Free_nil( Liste_Abonnements);
     inherited;
end;

procedure TPublieur.Abonne( _Proc: TAbonnement_Procedure_Proc);
var
   ap: TAbonnement_Procedure;
begin
     ap:= TAbonnement_Procedure.Create( _Proc, Liste_Abonnements);
     Liste_Abonnements.Append( ap);
     skProcedure.Insert( ap, ap);
end;

procedure TPublieur.Abonne( _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
var
   ao: TAbonnement_Objet;
begin
     ao:= TAbonnement_Objet.Create( _Objet, _Proc, Liste_Abonnements);
     Liste_Abonnements.Append( ao);
     skObjet.Insert( ao, ao);
end;

procedure TPublieur.Desabonne( _Proc: TAbonnement_Procedure_Proc);
var
   ap: TAbonnement_Procedure;
   a: TAbonnement;
   skia: TskiAbonnement;
begin
     ap:= TAbonnement_Procedure.Create( _Proc, nil);
     try
        skia:= TskiAbonnement(skProcedure.Search( ap));
        if Assigned( skia)
        then
            a:= skia.a
        else
            a:= nil;

        skProcedure.Delete( ap);
        if Assigned( a)
        then
            begin
            Liste_Abonnements.Detache( a);
            Free_nil( a);
            end;
     finally
            Free_nil( ap);
            end;
end;

procedure TPublieur.Desabonne( _Objet: TObject; _Proc: TAbonnement_Objet_Proc);
var
   ao: TAbonnement_Objet;
   a: TAbonnement;
   skia: TskiAbonnement;
begin
     ao:= TAbonnement_Objet.Create( _Objet, _Proc, nil);
     try
        skia:= TskiAbonnement(skObjet.Search( ao));
        if Assigned( skia)
        then
            a:= skia.a
        else
            a:= nil;

        skObjet.Delete( ao);
        if Assigned( a)
        then
            begin
            Liste_Abonnements.Detache( a);
            Free_nil( a);
            end;
     finally
            Free_nil( ao);
            end;
end;

procedure TPublieur.Publie;
const
     sDelta_Indentation= '   ';
var
   Old_uPublieur_Log_Publications: Boolean;
   a: TAbonnement;
begin
     if not uPublieur_Actif then exit;
     if not Actif then exit;
     Old_uPublieur_Log_Publications:= uPublieur_Log_Publications;
     uPublieur_Indentation:= uPublieur_Indentation + sDelta_Indentation;
     try
        uPublieur_Log_Publications:= uPublieur_Log_Publications or Log_Publications;

        if uPublieur_Log_Publications
        then
            //fAccueil_Log( 'Publieur $'+IntToHex( Integer( Self), 8)+'.Publie: ');
            fAccueil_Log( uPublieur_Indentation+Name+'.Publie : ');
        uPublieur_Indentation:= uPublieur_Indentation + sDelta_Indentation;
        try
           Liste_Abonnements.Iterateur_Start;
           while not Liste_Abonnements.Iterateur_EOF
           do
             begin
             Liste_Abonnements.Iterateur_Suivant( a);
             if Assigned( a)
             then
                 begin
                 if uPublieur_Log_Publications
                 then
                     fAccueil_Log( a.Description);
                 //uPublieur_s^:= uPublieur_s^+'(skia $'+IntToHex( Integer( skia), 8)+')';
                 a.DoProc;
                 end;
             end;
        finally
               System.Delete( uPublieur_Indentation, 1, Length(sDelta_Indentation));
               end;
     finally
            uPublieur_Log_Publications:= Old_uPublieur_Log_Publications;
            System.Delete( uPublieur_Indentation, 1, Length(sDelta_Indentation));
            end;
end;

procedure TPublieur.Publie_par_sk_pour_test;
const
     sDelta_Indentation= '   ';
var
   Old_uPublieur_Log_Publications: Boolean;
   a: TAbonnement;
begin
     if not uPublieur_Actif then exit;
     if not Actif then exit;
     Old_uPublieur_Log_Publications:= uPublieur_Log_Publications;
     uPublieur_Indentation:= uPublieur_Indentation + sDelta_Indentation;
     try
        uPublieur_Log_Publications:= uPublieur_Log_Publications or Log_Publications;

        if uPublieur_Log_Publications
        then
            //fAccueil_Log( 'Publieur $'+IntToHex( Integer( Self), 8)+'.Publie: ');
            fAccueil_Log( uPublieur_Indentation+Name+'.Publie : ');
        uPublieur_Indentation:= uPublieur_Indentation + sDelta_Indentation;
        try
           try
              skProcedure.Iterateur_Start;
              while not skProcedure.Iterateur_EOF
              do
                begin
                skProcedure.Iterateur_Suivant( a);
                if Assigned( a)
                then
                    begin
                    if uPublieur_Log_Publications
                    then
                        fAccueil_Log( a.Description);
                    a.DoProc;
                    end;
                end;
           finally
                  skProcedure.Iterateur_Stop;
                  end;
           skObjet.Iterateur_Start;
           try
              while not skObjet.Iterateur_EOF
              do
                begin
                skObjet.Iterateur_Suivant( a);
                if Assigned( a)
                then
                    begin
                    if uPublieur_Log_Publications
                    then
                        fAccueil_Log( a.Description);
                    //uPublieur_s^:= uPublieur_s^+'(a $'+IntToHex( Integer( a), 8)+')';
                    //if a.Objet is TObjet
                    //then
                    //    uPublieur_s^:= uPublieur_s^+'(a.objet.i :'+IntToStr( TObjet(a.Objet).I)+')';
                    a.DoProc;
                    end;
                end;
              finally
                     skObjet.Iterateur_Stop;
                     end;
        finally
               System.Delete( uPublieur_Indentation, 1, Length(sDelta_Indentation));
               end;
     finally
            uPublieur_Log_Publications:= Old_uPublieur_Log_Publications;
            System.Delete( uPublieur_Indentation, 1, Length(sDelta_Indentation));
            end;
end;

function TPublieur.Description: String;
var
   a: TAbonnement;
begin
     Result:= '';
     Liste_Abonnements.Iterateur_Start;
     while not Liste_Abonnements.Iterateur_EOF
     do
       begin
       Liste_Abonnements.Iterateur_Suivant( a);
       if Assigned( a)
       then
           Result:= Result + a.Description+#13#10;
       end;
end;

end.
