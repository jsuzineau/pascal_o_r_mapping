unit uhdmSession;

{$mode delphi}

interface

uses
    uClean,
    ufAccueil_Erreur,
    uBatpro_StringList,
    uBatpro_Element,
    ublSession,
    ublWork,
    upoolWork,
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
    function Charge_Periode( _Debut, _Fin: TDateTime): Boolean;
  end;

 { ThdmSession }

 ThdmSession
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
    function Iterateur: TIterateur_Session;
    function Iterateur_Decroissant: TIterateur_Session;
  //Liste des Works
  public
    haWork: ThaWork;
  //Méthodes
  public
    function Execute( _Debut, _Fin: TDateTime): Boolean;
  end;

function hdmSession: ThdmSession;

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

function ThaWork.Charge_Periode( _Debut, _Fin: TDateTime): Boolean;
begin
     poolWork.Charge_Periode( _Debut, _Fin, slCharge);
     Ajoute_slCharge;
end;

{ ThdmSession }

var
   FhdmSession: ThdmSession= nil;

function hdmSession: ThdmSession;
begin
     if FhdmSession = nil
     then
         FhdmSession:= ThdmSession.Create( nil, TblSession, nil);
end;

constructor ThdmSession.Create( _Parent: TBatpro_Element;
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
     haWork:= ThaWork.Create( nil, TblWork, nil);
end;

destructor ThdmSession.Destroy;
begin
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

function ThdmSession.Execute( _Debut, _Fin: TDateTime): Boolean;
var
   Precedent: TblWork;

   I: TIterateur_Work;
   blWork: TblWork;

   bl: TblSession;

   Cumul_Semaine: TDateTime;
begin
     haWork.Charge_Periode( _Debut, _Fin);

     bl:= nil;
     Precedent:= nil;
     Cumul_Semaine:= 0;
     I:= haWork.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( blWork) then continue;

       if     blWork.Session_Differente( Precedent)
          or (bl = nil)
       then
           begin
           if blWork.Semaine_Differente( Precedent)
           then
               begin
               if Assigned( bl)
               then
                   begin
                   bl.Cumul_Semaine:= Cumul_Semaine;
                   bl.FinSemaine:= True;
                   end;

               Cumul_Semaine:= 0;
               end;
           bl:= TblSession.Create( sl, nil, nil);
           Ajoute( bl);
           end;

       bl.haWork.Ajoute( blWork);
       Cumul_Semaine:= Cumul_Semaine + blWork.Duree;
       Precedent:= blWork;
       end;
end;

initialization
finalization
            Free_nil( FhdmSession);
end.

