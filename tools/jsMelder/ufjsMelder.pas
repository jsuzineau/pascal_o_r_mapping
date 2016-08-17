unit ufjsMelder;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uuStrings,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

{ TfjsMelder }

 TfjsMelder
 =
  class(TForm)
    procedure FormCreate(Sender: TObject);
  //Traite
  private
    procedure Traite;
  end;

var
 fjsMelder: TfjsMelder;

implementation

{$R *.lfm}

{ TfjsMelder }

procedure TfjsMelder.FormCreate(Sender: TObject);
begin
     Traite;
end;

procedure TfjsMelder.Traite;
var
   MeldCommand: String;
   RacineGauche, RacineDroite: String;
   NomFichier: String;
   NomFichier_sans_racine: String;
   NomGauche, NomDroite: String;

   procedure Traite_Nomfichier;
   var
      Racine: String;
   begin
        NomFichier:= ParamStr(1);
             if 1 = Pos( RacineGauche, NomFichier) then Racine:= RacineGauche
        else if 1 = Pos( RacineDroite, NomFichier) then Racine:= RacineDroite
        else                                            Racine:= '';
        NomFichier_sans_racine:= NomFichier;
        if '' <> Racine
        then
            StrToK( Racine, NomFichier_sans_racine);
        NomGauche:= RacineGauche+NomFichier_sans_racine;
        NomDroite:= RacineDroite+NomFichier_sans_racine;
        if '' = Racine then Racine:= ExtractFilePath( NomFichier);
        if '' = RacineGauche then EXE_INI.Assure_String( 'RacineGauche', Racine);
        if '' = RacineDroite then EXE_INI.Assure_String( 'RacineDroite', Racine);
   end;
   procedure _From_Ini;
   const
        MeldCommand_Default
        =
         {$IFDEF LINUX}
           '/usr/bin/meld'
         {$ELSE}
           'C:\Program Files (x86)\Meld\Meld.exe'
         {$ENDIF};
   begin
        MeldCommand := EXE_INI.Assure_String( 'MeldCommand' ,MeldCommand_Default);
        RacineGauche:= EXE_INI.Assure_String( 'RacineGauche',''                 );
        RacineDroite:= EXE_INI.Assure_String( 'RacineDroite',''                 );
   end;
begin
     if Paramcount < 1 then exit;

     _From_Ini;
     Traite_Nomfichier;

     SysUtils.ExecuteProcess(MeldCommand,[NomGauche,NomDroite]);

end;

end.

