unit uhdmSession;

{$mode delphi}

interface

uses
    uClean,
    uLog,
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
    function Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
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
  //Méthodes
  public
    function Execute( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
    procedure To_log;
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
     poolWork.Charge_Periode( _Debut, _Fin, _idTag, slCharge);
     Ajoute_slCharge;
     poolWork.Tri.Execute( sl);
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

function ThdmSession.Execute( _Debut, _Fin: TDateTime; _idTag: Integer): Boolean;
var
   Precedent: TblWork;

   I: TIterateur_Work;
   blWork: TblWork;

   bl: TblSession;

   Cumul_Semaine: TDateTime;
   Cumul_Jour: TDateTime;
   procedure Semaine_Change;
   begin
        if Assigned( bl)
        then
            begin
            bl.Cumul_Semaine:= Cumul_Semaine;
            bl.FinSemaine:= True;
            end;

        Cumul_Semaine:= 0;
   end;
   procedure Jour_Change;
   begin
        if blWork.Semaine_Differente( Precedent)
        then
            Semaine_Change;

        if Assigned( bl)
        then
            begin
            bl.Cumul_Jour:= Cumul_Jour;
            bl.FinJour:= True;
            end;

        Cumul_Jour:= 0;
   end;
   procedure Session_Change;
   begin
        if blWork.Jour_Different( Precedent)
        then
            Jour_Change;

        bl:= TblSession.Create( sl, nil, nil);
        Ajoute( bl);
   end;
begin
     haWork.Charge_Periode( _Debut, _Fin, _idTag);

     bl:= nil;
     Precedent:= nil;
     Cumul_Semaine:= 0;
     Cumul_Jour:= 0;
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
       Cumul_Jour   := Cumul_Jour    + blWork.Duree;
       Cumul_Semaine:= Cumul_Semaine + blWork.Duree;
       Log.PrintLn(  DateTimeToStr(blWork.End_)
                    +' Jour: '   +sNb_Heures_from_DateTime( Cumul_Jour   )
                    +' Semaine: '+sNb_Heures_from_DateTime( Cumul_Semaine)
                    );
       Precedent:= blWork;
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

end.

