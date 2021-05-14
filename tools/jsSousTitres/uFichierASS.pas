unit uFichierASS;

{$mode objfpc}{$H+}

interface

uses
    uVide,
    uuStrings,
    uFichierODT, ublSousTitre,
 Classes, SysUtils, StrUtils;

type
 TFichierASS= class;

 { TVisite_CallBack }

 TVisite_CallBack
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _fa: TFichierASS);
    destructor Destroy; override;
  //Attributs
  public
    fa: TFichierASS;
  //Methodes
  public
    procedure Visite( _iLigne_ASS: Integer; _Prefixe: String; _Ancien_Texte: String; _Nouveau_Texte: String); virtual; abstract;
  end;

 { TFichierASS }

 TFichierASS
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    NomFichier: String;
    sl: TStringList;
    iEvent: Integer;
    iFormat: Integer;
    NbVirgules: Integer;
    slSousTitre: TslSousTitre;
  //Méthodes
  private
    function PosText( _s: String): Integer;
    procedure Visite( _fo: TFichierODT; _iColonne: Integer; _CallBack: TVisite_CallBack);
  public
    procedure Charger( _NomFichier: String);
    procedure Vider;
    procedure Init_from_( _fa: TFichierASS);
    procedure Produire( _fo: TFichierODT; _iColonne: Integer);
    function GetResultat( _fo: TFichierODT; _iColonne: Integer): String;
    procedure Charger_slSousTitre( _fo: TFichierODT; _iColonne: Integer);
    procedure Charger_slSousTitre_from_ASS( _fo: TFichierODT; _iColonne: Integer);
    function Texte( _i: Integer): String;
  end;

implementation

{ TVisite_CallBack }

constructor TVisite_CallBack.Create(_fa: TFichierASS);
begin
     fa:= _fa;
end;

destructor TVisite_CallBack.Destroy;
begin
     inherited Destroy;
end;

{ TFichierASS }

constructor TFichierASS.Create;
begin
     sl:= TStringList.Create;
     slSousTitre:= TslSousTitre.Create( ClassName+'.slSousTitre');
end;

destructor TFichierASS.Destroy;
begin
     FreeAndNil( sl);
     FreeAndNil( slSousTitre);
     inherited Destroy;
end;

procedure TFichierASS.Vider;
begin
     sl.Clear;
     Vide_StringList( slSousTitre);
end;

procedure TFichierASS.Charger( _NomFichier: String);
   procedure Format_Compte_Virgules;
   var
      s: String;
      i: Integer;
   begin
        s:= sl[iFormat];
        NbVirgules:= 0;
        i:= 1;
        repeat
              i:= PosEx( ',', s, i+1);
              if 0 <> i then Inc( NbVirgules);
        until i = 0;
   end;
begin
     NomFichier:= _NomFichier;
     Vider;
     sl.LoadFromFile( NomFichier);
     iEvent:= sl.IndexOf('[Events]');
     iFormat:= iEvent+1;
     Format_Compte_Virgules;
end;

procedure TFichierASS.Init_from_(_fa: TFichierASS);
begin
     NomFichier:= '';
     Vider;
     sl.Text   := _fa.sl.Text;
     iEvent    := _fa.iEvent    ;
     iFormat   := _fa.iFormat   ;
     NbVirgules:= _fa.NbVirgules;
end;

function TFichierASS.PosText(_s: String): Integer;
var
   i: Integer;
begin
     Result:= 1;
     for i:= 1 to NbVirgules
     do
       Result:= PosEx( ',', _s, Result+1);
     Inc(Result);//pour sauter la virgule
end;

procedure TFichierASS.Visite( _fo: TFichierODT;
                              _iColonne: Integer;
                              _CallBack: TVisite_CallBack);
var
   iColonne: Integer;
   t: TTableau;
   iLigneDebut: Integer;
   c: TColonne;
   i: Integer;
   iLigne_ASS: Integer;
   Ligne_ASS: String;
   Nouveau_Texte:String;
   Ancien_Texte:String;
   iPosText: Integer;
   Prefixe: String;
begin
     for t in _fo.tl
     do
       begin
       iLigneDebut:= iFormat + 1 + t.Debut;
       iColonne:= t.Check( _iColonne);
       c:= t.cl[ iColonne];
       for i:= 0 to c.sl.Count-1
       do
         begin
         iLigne_ASS:= iLigneDebut+i;
         if iLigne_ASS >= sl.Count then break;

         Ligne_ASS:= sl[iLigne_ASS];
         Nouveau_Texte:= c.sl[i];
         iPosText:= PosText( Ligne_ASS);
         Prefixe:= Copy( Ligne_ASS, 1, iPosText-1);
         Ancien_Texte:= Copy( Ligne_ASS, iPosText, Length(Ligne_ASS));

         _CallBack.Visite( iLigne_ASS, Prefixe, Ancien_Texte, Nouveau_Texte);
         end;
       end;
end;

{ TVisite_Produire }
type
 TVisite_Produire
 =
  class( TVisite_CallBack)
    procedure Visite( _iLigne_ASS: Integer; _Prefixe: String; _Ancien_Texte: String; _Nouveau_Texte: String); override;
  end;
procedure TVisite_Produire.Visite( _iLigne_ASS: Integer;
                                   _Prefixe: String;
                                   _Ancien_Texte: String;
                                   _Nouveau_Texte: String);
begin
     fa.sl[_iLigne_ASS]:=_Prefixe+_Nouveau_Texte;
end;

procedure TFichierASS.Produire( _fo: TFichierODT; _iColonne: Integer);
var
   vp: TVisite_Produire;
begin
     vp:= TVisite_Produire.Create( Self);
     try
        Visite( _fo, _iColonne, vp);
     finally
            FreeAndNil( vp);
            end;
end;

{ TVisite_GetResultat }
type
 TVisite_GetResultat
 =
  class( TVisite_CallBack)
  //Gestion du cycle de vie
  public
    constructor Create( _fa: TFichierASS);
    destructor Destroy; override;
  //Attributs
  public
    Resultat: String;
  //Methodes
  public
    procedure Visite( _iLigne_ASS: Integer; _Prefixe: String; _Ancien_Texte: String; _Nouveau_Texte: String); override;
  end;

constructor TVisite_GetResultat.Create(_fa: TFichierASS);
begin
     inherited;
     Resultat:= '';
end;

destructor TVisite_GetResultat.Destroy;
begin
     inherited Destroy;
end;

procedure TVisite_GetResultat.Visite( _iLigne_ASS: Integer;
                                      _Prefixe: String;
                                      _Ancien_Texte: String;
                                      _Nouveau_Texte: String);
var
   iASS: Integer;
begin
     iASS:= _iLigne_ASS-fa.iFormat;
     Formate_Liste( Resultat, #13#10, Format('%.3d',[iASS])+' '+_Ancien_Texte+#13#10'   '+_Nouveau_Texte);
end;

function TFichierASS.GetResultat(_fo: TFichierODT; _iColonne: Integer): String;
var
   vg: TVisite_GetResultat;
begin
     vg:= TVisite_GetResultat.Create( Self);
     try
        Visite( _fo, _iColonne, vg);
        Result:= vg.Resultat;
     finally
            FreeAndNil( vg);
            end;
end;

{ TVisite_Charger_slSousTitre }
type
 TVisite_Charger_slSousTitre
 =
  class( TVisite_CallBack)
  //Gestion du cycle de vie
  public
    constructor Create( _fa: TFichierASS);
    destructor Destroy; override;
  //Methodes
  public
    procedure Visite( _iLigne_ASS: Integer; _Prefixe: String; _Ancien_Texte: String; _Nouveau_Texte: String); override;
  end;

constructor TVisite_Charger_slSousTitre.Create( _fa: TFichierASS);
begin
     inherited;
end;

destructor TVisite_Charger_slSousTitre.Destroy;
begin
     inherited Destroy;
end;

procedure TVisite_Charger_slSousTitre.Visite( _iLigne_ASS: Integer;
                                              _Prefixe: String;
                                              _Ancien_Texte: String;
                                              _Nouveau_Texte: String);
var
   iASS: Integer;
   bl: TblSousTitre;
begin
     iASS:= _iLigne_ASS-fa.iFormat;

     bl:= TblSousTitre.Create( fa.slSousTitre, nil, nil);
     bl.id:= iASS;
     bl.SousTitre:= _Nouveau_Texte;
     fa.slSousTitre.AddObject( bl.sCle, bl);
end;

procedure TFichierASS.Charger_slSousTitre(_fo: TFichierODT; _iColonne: Integer);
var
   vc: TVisite_Charger_slSousTitre;
begin
     Vide_StringList( slSousTitre);
     vc:= TVisite_Charger_slSousTitre.Create( Self);
     try
        Visite( _fo, _iColonne, vc);
     finally
            FreeAndNil( vc);
            end;
end;

{ TVisite_Charger_slSousTitre_from_ASS }
type
 TVisite_Charger_slSousTitre_from_ASS
 =
  class( TVisite_CallBack)
  //Gestion du cycle de vie
  public
    constructor Create( _fa: TFichierASS);
    destructor Destroy; override;
  //Methodes
  public
    procedure Visite( _iLigne_ASS: Integer; _Prefixe: String; _Ancien_Texte: String; _Nouveau_Texte: String); override;
  end;

constructor TVisite_Charger_slSousTitre_from_ASS.Create( _fa: TFichierASS);
begin
     inherited;
end;

destructor TVisite_Charger_slSousTitre_from_ASS.Destroy;
begin
     inherited Destroy;
end;

procedure TVisite_Charger_slSousTitre_from_ASS.Visite( _iLigne_ASS: Integer;
                                              _Prefixe: String;
                                              _Ancien_Texte: String;
                                              _Nouveau_Texte: String);
var
   iASS: Integer;
   bl: TblSousTitre;
begin
     iASS:= _iLigne_ASS-fa.iFormat;

     bl:= TblSousTitre.Create( fa.slSousTitre, nil, nil);
     bl.id:= iASS;
     bl.SousTitre:= _Ancien_Texte;
     fa.slSousTitre.AddObject( bl.sCle, bl);
end;

procedure TFichierASS.Charger_slSousTitre_from_ASS( _fo: TFichierODT; _iColonne: Integer);
var
   vc: TVisite_Charger_slSousTitre_from_ASS;
begin
     Vide_StringList( slSousTitre);
     vc:= TVisite_Charger_slSousTitre_from_ASS.Create( Self);
     try
        Visite( _fo, _iColonne, vc);
     finally
            FreeAndNil( vc);
            end;
end;

function TFichierASS.Texte( _i: Integer): String;
var
   iLigne: Integer;
   iPosText: Integer;
   Ligne: String;
begin
     iLigne:= iFormat + 1 +_i;
     Ligne:= sl[iLigne];
     iPosText:= PosText( Ligne);
     Result:= Copy( Ligne, iPosText, Length(Ligne));
end;

end.

