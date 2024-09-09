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
  bDecharger: TButton;
  pg: TProgressBar;
  procedure bChargerClick(Sender: TObject);
  procedure bDechargerClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private
   RepertoireTexte: String;
   slCyrillique      : TStringList;
   slTranslitteration: TStringList;
   slFrancais        : TStringList;
   sl3               : TStringList;
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
     sl3               := TStringList.Create;

     RepertoireTexte
     :=
        IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))
       +'Texte'+DirectorySeparator;
end;

procedure TfChargement.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slCyrillique      );
     FreeAndNil( slTranslitteration);
     FreeAndNil( slFrancais        );
end;

procedure TfChargement.bChargerClick(Sender: TObject);
var
   I: Integer;
   id: Integer;
   blTexte: TblTexte;
begin
     poolTexte.Vider_table;

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
     ShowMessage( 'Chargement terminé');
end;

procedure TfChargement.bDechargerClick(Sender: TObject);
var
   slLoaded: TslTexte;
   I: TIterateur_Texte;
   bl: TblTexte;
begin
     slCyrillique      .Clear;
     slTranslitteration.Clear;
     slFrancais        .Clear;
     sl3               .Clear;

     slLoaded:= TslTexte.Create(ClassName+'.bDechargerClick:slLoaded');
     try
        poolTexte.ToutCharger( slLoaded);
        I:= slLoaded.Iterateur;
        try
           while I.Continuer
           do
             begin
             if I.not_Suivant( bl) then continue;

             slCyrillique      .Add( bl.Cyrillique      );
             slTranslitteration.Add( bl.Translitteration);
             slFrancais        .Add( bl.Francais        );

             sl3.Add( bl.Cyrillique      );
             sl3.Add( bl.Translitteration);
             sl3.Add( bl.Francais        );
             end;
        finally
               FreeAndNil( I);
               end;
     finally
            FreeAndNil( slLoaded);
            end;

     slCyrillique      .SaveToFile( RepertoireTexte+'01_cyrillique.txt'      , TEncoding.UTF8);
     slTranslitteration.SaveToFile( RepertoireTexte+'02_translitteration.txt', TEncoding.UTF8);
     slFrancais        .SaveToFile( RepertoireTexte+'03_français.txt'        , TEncoding.UTF8);
     sl3               .SaveToFile( RepertoireTexte+'04_Paneurythmie.txt'    , TEncoding.UTF8);
     ShowMessage( 'Déchargement terminé');
end;

end.

