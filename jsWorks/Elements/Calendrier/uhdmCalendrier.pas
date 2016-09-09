unit uhdmCalendrier;

{$mode delphi}

interface

uses
    uClean,
    uLog,
    uEXE_INI,
    uVide,
    ufAccueil_Erreur,
    uBatpro_StringList,
    uBatpro_Element,
    ublCalendrier,
 Classes, SysUtils,dateutils;

type
 { ThdmCalendrier }

 ThdmCalendrier
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
    function Iterateur: TIterateur_Calendrier;
    function Iterateur_Decroissant: TIterateur_Calendrier;
  //Méthodes
  public
    procedure Vide;
    function Formate( _Debut, _Fin: TDateTime): Boolean;
    function Formate_Mois( _D: TDateTime): Boolean;
    procedure Affecte( _D: TDateTime; _Cumul_Jour, _Cumul_Semaine, _Cumul_Global: TWork_Cumul);
    procedure To_log;
  //Debut Fin
  public
    Debut, Fin: TDateTime;
  end;

implementation

{ ThdmCalendrier }

constructor ThdmCalendrier.Create;
begin
     inherited Create( nil, TblCalendrier, nil);
     if Classe_Elements <> TblCalendrier
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+TblCalendrier.ClassName
                          );
end;

destructor ThdmCalendrier.Destroy;
begin
     inherited;
end;

class function ThdmCalendrier.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Calendrier;
end;

function ThdmCalendrier.Iterateur: TIterateur_Calendrier;
begin
     Result:= TIterateur_Calendrier( Iterateur_interne);
end;

function ThdmCalendrier.Iterateur_Decroissant: TIterateur_Calendrier;
begin
     Result:= TIterateur_Calendrier( Iterateur_interne_Decroissant);
end;

function ThdmCalendrier.Formate( _Debut, _Fin: TDateTime): Boolean;
var
   D: Integer;
   bl: TblCalendrier;
begin
     Vide;
     Debut:= _Debut;
     Fin  := _Fin;
     for D:= Trunc(_Debut) to Trunc(_Fin)
     do
       begin
       bl:= TblCalendrier.Create( sl, nil, nil);
       bl.D:= D;
       Ajoute( bl);
       end;
     Result:= True;
end;

function ThdmCalendrier.Formate_Mois(_D: TDateTime): Boolean;
begin
     Result:= Formate( StartOfTheMonth(_D), EndOfTheMonth(_D));
end;

procedure ThdmCalendrier.Affecte( _D: TDateTime; _Cumul_Jour, _Cumul_Semaine, _Cumul_Global: TWork_Cumul);
var
   bl: TblCalendrier;
begin
     bl:= blCalendrier_from_sl_sCle( sl, TblCalendrier.sCle_from_( _D));
     if nil = bl then exit;

     bl.Cumul_Jour   .Cumul:= _Cumul_Jour   ;
     bl.Cumul_Semaine.Cumul:= _Cumul_Semaine;
     bl.Cumul_Global .Cumul:= _Cumul_Global ;
end;

procedure ThdmCalendrier.To_log;
var
   I: TIterateur_Calendrier;
   bl: TblCalendrier;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       Log.PrintLn(   DateToStr(bl.D) + ', '+bl.Cumul_Jour.sLog);
       end;
     Log.Affiche;
end;

procedure ThdmCalendrier.Vide;
var
   I: TIterateur_Calendrier;
   bl: TblCalendrier;
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

end.

