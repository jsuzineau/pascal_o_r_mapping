unit uhdmSession;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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
    uLog,
    uEXE_INI,
    uVide,
    uuStrings,
    ufAccueil_Erreur,
    uBatpro_StringList,
    uBatpro_Element,
    ublSession,
    ublWork,
    ublTag,
    ublCalendrier,

    upoolWork,
    upoolTag,
    uhdmCalendrier,
 Classes, SysUtils;

type
 { ThaWork }

 ThaWork
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
    destructor  Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Work;
    function Iterateur_Decroissant: TIterateur_Work;
  //Méthodes
  public
    function Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
  end;

 ThaTag
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
    destructor  Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Tag;
    function Iterateur_Decroissant: TIterateur_Tag;
  end;

 { ThdmSession }

 ThdmSession
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create; reintroduce;
    destructor  Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Session;
    function Iterateur_Decroissant: TIterateur_Session;
  //Liste des Works
  public
    haWork: ThaWork;
  //Liste des Tags
  public
    haTag: ThaTag;
  //Méthodes
  public
    function Execute( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
    procedure To_log;
    procedure Vide;
  //Nombre heures par jour
  private
    NB_Heures_Jour: Double;
  //Calendrier
  public
    hdmCalendrier: ThdmCalendrier;
  //Cumul global
  public
    Cumul_Global : TWork_Cumul;
  //Text
  public
    function Text: String;
  end;

implementation

{ ThaWork }

constructor ThaWork.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
end;

destructor ThaWork.Destroy;
begin
     inherited;
end;

class function ThaWork.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Work;
end;

function ThaWork.Iterateur: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne);
end;

function ThaWork.Iterateur_Decroissant: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne_Decroissant);
end;

function ThaWork.Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
begin
     Clear;
     poolWork.Charge_Periode( _Debut, _Fin, _idTag, slCharge);
     Ajoute_slCharge;
     poolWork.Tri.Execute( sl);
end;

{ ThaTag }

constructor ThaTag.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
end;

destructor ThaTag.Destroy;
begin
     inherited;
end;

class function ThaTag.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Tag;
end;

function ThaTag.Iterateur: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne);
end;

function ThaTag.Iterateur_Decroissant: TIterateur_Tag;
begin
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);
end;


{ ThdmSession }

constructor ThdmSession.Create;
begin
     inherited Create( nil, TblSession, nil);
     if Classe_Elements <> TblSession
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+TblSession.ClassName
                          );
     haWork:= ThaWork.Create( nil, TblWork, nil);
     haTag:= ThaTag.Create( nil, TblTag, nil);
     NB_Heures_Jour:= EXE_INI.Assure_Double( 'NB_Heures_Jour', 5.75);
     Log.PrintLn( ClassName+'.NB_Heures_Jour= '+FloatToStr( NB_Heures_Jour));
     hdmCalendrier:= ThdmCalendrier.Create;
end;

destructor ThdmSession.Destroy;
begin
     Free_nil( hdmCalendrier);
     Free_nil( haTag);
     Free_nil( haWork);
     inherited;
end;

class function ThdmSession.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Session;
end;

function ThdmSession.Iterateur: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne);
end;

function ThdmSession.Iterateur_Decroissant: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne_Decroissant);
end;

function ThdmSession.Execute( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
var
   dtNB_Heures_Jour: TDateTime;
   Precedent: TblWork;

   I: TIterateur_Work;
   blWork: TblWork;

   bl: TblSession;

   Cumul_Semaine: TWork_Cumul;
   Cumul_Jour   : TWork_Cumul;
   procedure Semaine_Change;
   begin
        if Assigned( bl)
        then
            begin
            bl.Cumul_Semaine:= Cumul_Semaine;
            bl.FinSemaine:= True;
            end;

        Cumul_Semaine.Zero;
   end;
   procedure Traite_Cumul_Depassement;
   var
      Depassement: TDateTime;
   begin
        if {Vendredi}6=DayOfWeek(bl.Beginning)
        then
            Depassement:= Cumul_Jour.Total
        else
            Depassement:= Cumul_Jour.Total - dtNB_Heures_Jour;

        Cumul_Jour   .Add_Depassement( Depassement);
        Cumul_Semaine.Add_Depassement( Depassement);
        Cumul_Global .Add_Depassement( Depassement);
   end;
   procedure Jour_Change;
   begin
        if Assigned( bl)
        then
            Traite_Cumul_Depassement;

        if Assigned( Precedent)
        then
            hdmCalendrier.Affecte( Precedent.Beginning, Cumul_Jour, Cumul_Semaine, Cumul_Global);

        if blWork.Semaine_Differente( Precedent)
        then
            Semaine_Change;

        if Assigned( bl)
        then
            begin
            bl.Cumul_Jour:= Cumul_Jour;
            bl.FinJour:= True;
            end;

        Cumul_Jour.Zero;
   end;
   procedure Session_Change;
   begin
        if blWork.Jour_Different( Precedent)
        then
            Jour_Change;

       if Assigned( bl)
        then
            begin
            bl.Cumul_Global:= Cumul_Global;
            //bl.FinGlobal:= True;
            end;

        bl:= TblSession.Create( sl, nil, nil);
        Ajoute( bl);
   end;
   procedure Traite_Cumul;
   var
      Total: TDateTime;
   begin
        Total      := blWork.Duree;

        Cumul_Jour   .Add_Total( Total);
        Cumul_Semaine.Add_Total( Total);
        Cumul_Global .Add_Total( Total);
   end;
begin
     Vide;

     dtNB_Heures_Jour:= NB_Heures_Jour/24;

     hdmCalendrier.Formate( _Debut, _Fin);
     haWork.Charge_Periode( _Debut, _Fin, _idTag);

     Cumul_Global .Zero;
     Cumul_Semaine.Zero;
     Cumul_Jour   .Zero;
     bl:= nil;
     Precedent:= nil;
     I:= haWork.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( blWork) then continue;

       if     blWork.Session_Differente( Precedent)
          or (bl = nil)
       then
           Session_Change;

       bl.haWork.Ajoute( blWork);
       Traite_Cumul;
       Log.PrintLn(  DateTimeToStr(blWork.End_)
                    +' Jour: '   +Cumul_Jour   .To_String
                    +' Semaine: '+Cumul_Semaine.To_String
                    +' Global: ' +Cumul_Global .To_String
                    );
       Precedent:= blWork;
       end;
     if Assigned( bl)
     then
         begin
         bl.Cumul_Global := Cumul_Global ; bl.FinGlobal := True;
         bl.Cumul_Semaine:= Cumul_Semaine; bl.FinSemaine:= True;
         bl.Cumul_Jour   := Cumul_Jour   ; bl.FinJour   := True;
         end;
     Result:= True;
end;

procedure ThdmSession.To_log;
var
   I: TIterateur_Session;
   bl: TblSession;
   sl: TStringList;
   J: Integer;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       Log.PrintLn( DateToStr(bl.Beginning));
       sl:= TStringList.Create;
       try
          sl.Text:= bl.Libelle;
          for J:= 0 to sl.Count-1
          do
            Log.PrintLn( '  '+sl[J]);
       finally
              FreeAndNil( sl);
              end;
       end;
     Log.Affiche;
end;

procedure ThdmSession.Vide;
var
   I: TIterateur_Session;
   bl: TblSession;
begin
     I:= Iterateur_Decroissant;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;
       I.Supprime_courant;
       Free_nil( bl);
       end;
end;

function ThdmSession.Text: String;
var
   I: TIterateur_Session;
   bl: TblSession;
begin
     Result:= '';
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       Formate_Liste( Result, #13#10, bl.Libelle);
       Formate_Liste( Result, #13#10, '  ');
       end;
end;

end.

