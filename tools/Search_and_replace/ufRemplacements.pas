unit ufRemplacements;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfRemplacements }

 TfRemplacements
 =
  class(TForm)
   m: TMemo;
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String); reintroduce;
    destructor Destroy; override;
 //Méthodes
 public
  function NomFichier: String;
  procedure Charge;
  procedure Sauve;
  procedure Traite_Chaine( var _S: String);
 end;

function Assure_fRemplacements(var _fRemplacements: TfRemplacements; _Name: String): TfRemplacements;

implementation

{$R *.lfm}

function Assure_fRemplacements(var _fRemplacements: TfRemplacements; _Name: String): TfRemplacements;
begin
     if nil = _fRemplacements
     then
         _fRemplacements:= TfRemplacements.Create( _Name);
     Result:= _fRemplacements;
end;

{ TfRemplacements }

constructor TfRemplacements.Create( _Name: String);
begin
     inherited Create( nil);
     Name:= _Name;
end;

destructor TfRemplacements.Destroy;
begin
 inherited Destroy;
end;

function TfRemplacements.NomFichier: String;
begin
     Result
     :=
        IncludeTrailingPathDelimiter(ExtractFilePath( Application.ExeName))
       +'etc'+PathDelim
       +'Remplacements.ini';
end;

procedure TfRemplacements.Charge;
var
   nf: String;
begin
     nf:= NomFichier;
     if not FileExists( nf) then exit;

     m.Lines.LoadFromFile( nf);
end;

procedure TfRemplacements.Sauve;
var
   nf: String;
begin
     nf:= NomFichier;
     ForceDirectories( ExtractFilePath(nf));

     m.Lines.SaveToFile( nf);
end;

procedure TfRemplacements.Traite_Chaine(var _S: String);
var
   I: Integer;

   procedure Traite_Remplacement( _I: Integer);
   var
      sSearch, sReplace: String;
   begin
        sSearch := m.Lines.Names         [ I];
        sReplace:= m.Lines.ValueFromIndex[ I];
        //S:= UTF8StringReplace( S, sSearch, sReplace, [rfReplaceAll]); // unit LazUTF8
        _S:= StringReplace( _S, sSearch, sReplace, [rfReplaceAll]);
   end;
begin
     //SynEdit gère mal en UTF8 les caractères accentués par un deuxième caractère.
     //il accentue le caractère d'aprés au lieu d'accentuer le caractère d'avant
     //"VREME E DA V̌ARVIM" devient "VREME E DA VǍRVIM" dans l'éditeur de source de lazarus et synedit
     //_S:= StringReplace( _S, 'õ', #$CC#$8C'A', [rfReplaceAll]);
     for I:= 0 to m.Lines.Count-1
     do
       Traite_Remplacement( I);
end;



end.

