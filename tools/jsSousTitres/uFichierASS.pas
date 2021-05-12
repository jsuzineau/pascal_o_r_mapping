unit uFichierASS;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uFichierODT,
 Classes, SysUtils, StrUtils;

type

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
  //Méthodes
  private
    function PosText( _s: String): Integer;
  public
    procedure Charger( _NomFichier: String);
    procedure Init_from_( _fa: TFichierASS);
    procedure Produire( _fo: TFichierODT; _iColonne: Integer);
    function GetResultat( _fo: TFichierODT; _iColonne: Integer): String;
    function Texte( _i: Integer): String;
  end;

implementation

{ TFichierASS }

constructor TFichierASS.Create;
begin
     sl:= TStringList.Create;
end;

destructor TFichierASS.Destroy;
begin
     FreeAndNil( sl);
     inherited Destroy;
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
     sl.LoadFromFile( NomFichier);
     iEvent:= sl.IndexOf('[Events]');
     iFormat:= iEvent+1;
     Format_Compte_Virgules;
end;

procedure TFichierASS.Init_from_(_fa: TFichierASS);
begin
     NomFichier:= '';
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

procedure TFichierASS.Produire( _fo: TFichierODT; _iColonne: Integer);
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
       c:= t.cl.Items[ iColonne];
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

         sl[iLigne_ASS]:=Prefixe+Nouveau_Texte;
         end;
       end;
end;

function TFichierASS.GetResultat(_fo: TFichierODT; _iColonne: Integer): String;
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
   iASS: Integer;
begin
     Result:= '';
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

         iASS:= iLigne_ASS-iFormat;
         Formate_Liste( Result, #13#10, Format('%.3d',[iASS])+' '+Ancien_Texte+#13#10'   '+Nouveau_Texte);
         end;
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

