unit ufjsAudacity;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uReels,
    uClean,
    uuStrings,
    uChamp,
    uChamps,
    uBatpro_StringList,
    ublPassage,
    upoolPassage,
    uDockable,
    udkPassage,
    ucDockableScrollbox,
    uAudacity,
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Menus, ExtCtrls, ActnList, Spin, Buttons, ButtonPanel,
  fpspreadsheetgrid, fpsallformats;

type

  { TfjsAudacity }

 TfjsAudacity
 =
  class(TForm)
   bSend: TButton;
   bTest_Select_seconds: TButton;
   bGetSelectionStart: TButton;
   b_from_XLSX: TButton;
   dsbPassage: TDockableScrollbox;
   eSend: TEdit;
   m: TMemo;
    od: TOpenDialog;
    Panel2: TPanel;
    sd: TSaveDialog;
    Splitter1: TSplitter;
    tStart: TTimer;
    procedure bGetSelectionStartClick(Sender: TObject);
    procedure bSendClick(Sender: TObject);
    procedure bTest_Select_secondsClick(Sender: TObject);
    procedure b_from_XLSXClick(Sender: TObject);
    procedure dsbPassageTraite_Message(_dk: TDockable; _iMessage: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tStartTimer(Sender: TObject);
  private
    Audacity: TAudacity;
    procedure Log( _s: String);
    procedure _from_poolPassage;
    procedure Applique_Modifications;
  end;

var
  fjsAudacity: TfjsAudacity;

implementation

uses
  fpcanvas, lazutf8,
  fpstypes, fpsutils, fpsReaderWriter, fpspreadsheet;


{ TfjsAudacity }

procedure TfjsAudacity.FormCreate(Sender: TObject);
begin
     dsbPassage.Classe_dockable:= TdkPassage;
     dsbPassage.Classe_Elements:= TblPassage;
     m.Text:= '';
     Audacity:= TAudacity.Create;
     tStart.Enabled:= True;
end;

procedure TfjsAudacity.FormDestroy(Sender: TObject);
begin
     Audacity.Fermer;
     FreeAndNil( Audacity);
end;

procedure TfjsAudacity.tStartTimer(Sender: TObject);
begin
     tStart.Enabled:= False;
     Audacity.OnLog:= @Log;
     Audacity.Ouvrir;
     Audacity.Test;
     _from_poolPassage;
end;

procedure TfjsAudacity.Log(_s: String);
begin
     m.Lines.Add( _s);
     m.CaretPos:= TPoint.Create(1, m.Lines.Count-1);
end;

procedure TfjsAudacity._from_poolPassage;
begin
     poolPassage.ToutCharger;
     dsbPassage.sl:= poolPassage.slFiltre;
     dsbPassage.Goto_Dernier;
end;

procedure TfjsAudacity.Applique_Modifications;
var
   I: TIterateur;
   bl: TblPassage;
begin
     I:= poolPassage.slFiltre.Iterateur_interne_Decroissant;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;
       if Reel_Zero( bl.Pourcentage) then continue;

       Audacity.Select_seconds( bl.Debut_seconds, bl.Fin_seconds);
       Audacity.ChangeTempo( bl.Pourcentage, True);
       end;

end;

procedure TfjsAudacity.bSendClick(Sender: TObject);
begin
     Audacity.do_command(eSend.Text);
     eSend.Text:= '';
end;

procedure TfjsAudacity.bGetSelectionStartClick(Sender: TObject);
begin
     Audacity.do_command('GetSelectionStart:');
end;

procedure TfjsAudacity.bTest_Select_secondsClick(Sender: TObject);
begin
     Audacity.Test_Select_seconds;
end;

procedure TfjsAudacity.b_from_XLSXClick(Sender: TObject);
begin
     poolPassage._from_xlsx( EXE_INI.Assure_String('NomFichier', 'Liste _passages_à_traiter.xlsx'),
                             2, 49);
     _from_poolPassage;
end;

procedure TfjsAudacity.dsbPassageTraite_Message( _dk: TDockable;
                                                 _iMessage: Integer);
var
   dk: TdkPassage;
   dk_bl: TblPassage;
   procedure Applique;
   begin
        Audacity.Select_seconds( dk_bl.Debut_seconds, dk_bl.Fin_seconds);
        Audacity.ChangeTempo( dk_bl.Pourcentage, True);
   end;
   procedure GetSelection;
   const
        sSelection_txt= 'E:\03_travail\FBU\Ghislaine\jsAudacity\Selection.txt';
   var
      T: Text;
      function GetDateTime: TDateTime;
      var
         S: string;
         Erreur: Integer;
         D: Double;
      begin
           Readln( T, S);
           Val( S, D, Erreur);
           if Erreur > 0
           then
               Result:= 0
           else
               Result:= (D/3600)/24;
      end;
   begin
        String_to_File( sSelection_txt, '');//effacement fichier
        Audacity.do_command( 'GetSelection');
        AssignFile( T, sSelection_txt);
        Reset(T);
        dk_bl.cDebut.asDatetime:= GetDateTime;
        dk_bl.cFin  .asDatetime:= GetDateTime;
        CloseFile(T);
   end;
   procedure Do_Selection;
   begin
        Audacity.Select_seconds( dk_bl.Debut_seconds, dk_bl.Fin_seconds);
        Audacity.Play;
   end;
begin
     if Affecte_( dk, TdkPassage, _dk)         then exit;
     if Affecte_( dk_bl, TblPassage, dk.Objet) then exit;

     case _iMessage
     of
       udkPassage_Applique    : Applique    ;
       udkPassage_GetSelection: GetSelection;
       udkPassage_Select_Play : Do_Selection;
       end;
     //C:\Users\Jean\AppData\Roaming\audacity\Macros\GetSelectionStart.txt
     //GetSelectionStart
end;

//infludo 25-30 gtes 3-5x /jour
//immuchoc 2cp 2x/jour

initialization
  {$I ufjsAudacity.lrs}

end.


