unit ufChargement;

{$mode ObjFPC}{$H+}

interface

uses
    ublTexte,
    upoolTexte,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls;

type

 { TfChargement }

 TfChargement = class(TForm)
  bCharger: TButton;
  pg: TProgressBar;
  procedure bChargerClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private
   slCyrillique      : TStringList;
   slTranslitteration: TStringList;
   slFrancais        : TStringList;
 public

 end;

var
 fChargement: TfChargement;

implementation

{$R *.lfm}

{ TfChargement }

procedure TfChargement.FormCreate(Sender: TObject);
begin
     slCyrillique      := TStringList.Create;
     slTranslitteration:= TStringList.Create;
     slFrancais        := TStringList.Create;
end;

procedure TfChargement.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slCyrillique      );
     FreeAndNil( slTranslitteration);
     FreeAndNil( slFrancais        );
end;

procedure TfChargement.bChargerClick(Sender: TObject);
var
   RepertoireTexte: String;
   I: Integer;
   id: Integer;
   blTexte: TblTexte;
begin
     RepertoireTexte
     :=
        IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))
       +'Texte'+DirectorySeparator;
     slCyrillique      .LoadFromFile( RepertoireTexte+'01_cyrillique.txt'      , TEncoding.UTF8);
     slTranslitteration.LoadFromFile( RepertoireTexte+'02_translitteration.txt', TEncoding.UTF8);
     slFrancais        .LoadFromFile( RepertoireTexte+'03_français.txt'        , TEncoding.UTF8);
     pg.Min:=0;
     pg.Max:=slCyrillique.Count-1;
     for I:= 0 to slCyrillique.Count-1
     do
       begin
       id:= I+1;

       blTexte:= poolTexte.Assure(id);
       blTexte.Cyrillique      := slCyrillique      [I];
       blTexte.Translitteration:= slTranslitteration[I];
       blTexte.Francais        := slFrancais        [I];
       blTexte.Save_to_database;

       pg.Position:= I;
       end;
end;

end.

