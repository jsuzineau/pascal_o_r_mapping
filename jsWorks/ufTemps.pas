unit ufTemps;

{$mode delphi}

interface

uses
    uClean,
    ucDockableScrollbox,
    uOD_Temporaire,

    ublTag,
    upoolTag,
    udkTag_LABEL_od,

    uodWork_from_Period,

    ublCalendrier,
    uodSession,
    ublSession,
    uhdmSession,
    udkSession, uodCalendrier,

    uPhi_Form,

 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
 Buttons, ExtCtrls,LCLIntf, dateutils,Clipbrd, StdCtrls;

type

 { TfTemps }

 TfTemps
 =
 class(TForm)
  b0_Now: TButton;
  bCurrentDay: TButton;
  bDescription_Filter_cancel: TButton;
  bNextDay: TButton;
  bodCalendrier_Modele: TButton;
  bOK: TBitBtn;
  bPreviousDay: TButton;
  bSession: TButton;
  bTo_log: TButton;
  bodSession: TButton;
  bodCalendrier: TButton;
  bCurrentWeek: TButton;
  bCurrentMonth: TButton;
  bPreviousWeek: TButton;
  bPreviousMonth: TButton;
  bNextMonth: TButton;
  bNextWeek: TButton;
  bodSession_Modele: TButton;
  bRep: TButton;
  cbRestreindre_a_un_Tag: TCheckBox;
  cbEcrire_arrondi: TCheckBox;
  cbHeures_Supplementaires: TCheckBox;
  cbDepassement: TCheckBox;
  deDebut: TDateEdit;
  deFin: TDateEdit;
  ds: TDockableScrollbox;
  dsbTag: TDockableScrollbox;
  eDescription_Filter: TEdit;
  eFacture: TEdit;
  Label1: TLabel;
  Label12: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  mResume: TMemo;
  Panel1: TPanel;
  Splitter1: TSplitter;
  procedure b0_NowClick(Sender: TObject);
  procedure bDescription_Filter_cancelClick(Sender: TObject);
  procedure bPreviousMonthClick(Sender: TObject);
  procedure bCurrentMonthClick(Sender: TObject);
  procedure bNextMonthClick(Sender: TObject);
  procedure bPreviousWeekClick(Sender: TObject);
  procedure bCurrentWeekClick(Sender: TObject);
  procedure bNextWeekClick(Sender: TObject);
  procedure bPreviousDayClick(Sender: TObject);
  procedure bCurrentDayClick(Sender: TObject);
  procedure bNextDayClick(Sender: TObject);
  procedure bodCalendrierClick(Sender: TObject);
  procedure bodCalendrier_ModeleClick(Sender: TObject);
  procedure bodSessionClick(Sender: TObject);
  procedure bodSession_ModeleClick(Sender: TObject);
  procedure bOKClick(Sender: TObject);
  procedure bRepClick(Sender: TObject);
  procedure bSessionClick(Sender: TObject);
  procedure bTo_logClick(Sender: TObject);
  procedure cbEcrire_arrondiChange(Sender: TObject);
  procedure cbHeures_SupplementairesChange(Sender: TObject);
  procedure cbRestreindre_a_un_TagClick(Sender: TObject);
  procedure dsClick(Sender: TObject);
  procedure eFactureEnter(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure mResumeEnter(Sender: TObject);
 private
   function idTag: Integer;
 public
   hdmSession: ThdmSession;
 //Gestion bornes période
 private
   procedure Semaine( _D: TDateTime; _Delta: Integer=0);
   procedure Mois   ( _D: TDateTime; _Delta: Integer=0);
   procedure Jour   ( _D: TDateTime; _Delta: Integer=0);

 end;

function fTemps: TfTemps;

implementation

{$R *.lfm}

{ TfTemps }

var
   FfTemps: TfTemps= nil;

function fTemps: TfTemps;
begin
     Clean_Get( Result, FfTemps, TfTemps);
end;

procedure TfTemps.FormCreate(Sender: TObject);
begin
     deDebut.Date:= Date;
     deFin  .Date:= deDebut.Date;

     ds.Classe_dockable:= TdkSession;
     ds.Classe_Elements:= TblSession;

     dsbTag.Classe_dockable:= TdkTag_LABEL_od;
     dsbTag.Classe_Elements:= TblTag;

     hdmSession:= ThdmSession.Create;
     cbEcrire_arrondi.Checked:= ublSession_Ecrire_arrondi;
     cbHeures_Supplementaires.Checked:= ublCalendrier_Heures_Supplementaires;
     ThPhi_Form.Create( Self);

     eDescription_Filter.Text:= '';
end;

procedure TfTemps.FormDestroy(Sender: TObject);
begin
     Free_nil( hdmSession);
end;

procedure TfTemps.mResumeEnter(Sender: TObject);
begin
     Clipboard.AsText:= mResume.Text;
end;

function TfTemps.idTag: Integer;
var
   blTag: TblTag;
begin
     Result:= 0;

     if not cbRestreindre_a_un_Tag.Checked then exit;

     dsbTag.Get_bl( blTag);
     if nil = blTag then exit;

     Result:= blTag.id;
end;

procedure TfTemps.bOKClick(Sender: TObject);
var
   Resultat: String;
begin
     odWork_from_Period.Init( deDebut.Date, deFin.Date, idTag, '');
     Resultat:= odWork_from_Period.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfTemps.Semaine(_D: TDateTime; _Delta: Integer);
begin
          if _Delta < 0 then _D:= StartOfTheWeek( _D)-1
     else if _Delta > 0 then _D:=   EndOfTheWeek( _D)+1;

     deDebut.Date:= StartOfTheWeek( _D);
     deFin  .Date:=   EndOfTheWeek( _D);
end;

procedure TfTemps.Mois(_D: TDateTime; _Delta: Integer);
begin
          if _Delta < 0 then _D:= StartOfTheMonth( _D)-1
     else if _Delta > 0 then _D:=   EndOfTheMonth( _D)+1;

     deDebut.Date:= StartOfTheMonth( _D);
     deFin  .Date:=   EndOfTheMonth( _D);
end;

procedure TfTemps.Jour(_D: TDateTime; _Delta: Integer);
begin
          if _Delta < 0 then _D:= _D-1
     else if _Delta > 0 then _D:= _D+1;

     deDebut.Date:= _D;
     deFin  .Date:= _D;
end;

procedure TfTemps.bRepClick(Sender: TObject);
begin
     if not OpenDocument( OD_Temporaire.RepertoireTemp)
     then
         ShowMessage( 'OpenDocument failed on '+OD_Temporaire.RepertoireTemp);
end;

procedure TfTemps.bCurrentDayClick(Sender: TObject);
begin
     Jour( Now);
end;

procedure TfTemps.bPreviousDayClick(Sender: TObject);
begin
     Jour( deDebut.Date, -1);
end;

procedure TfTemps.bNextDayClick(Sender: TObject);
begin
     Jour( deDebut.Date, +1);
end;

procedure TfTemps.bCurrentWeekClick(Sender: TObject);
begin
     Semaine( Now);
end;

procedure TfTemps.bPreviousWeekClick(Sender: TObject);
begin
     Semaine( deDebut.Date, -1);
end;

procedure TfTemps.bNextWeekClick(Sender: TObject);
begin
     Semaine( deDebut.Date, +1);
end;

procedure TfTemps.bCurrentMonthClick(Sender: TObject);
begin
     Mois( Now);
end;

procedure TfTemps.bPreviousMonthClick(Sender: TObject);
begin
     Mois( deDebut.Date, -1);
end;

procedure TfTemps.bNextMonthClick(Sender: TObject);
begin
     Mois( deDebut.Date, +1);
end;

procedure TfTemps.bSessionClick(Sender: TObject);
begin
     ds.sl:= nil;
     hdmSession.Execute( deDebut.Date, deFin.Date+(23+(59)/60)/24, idTag, eDescription_Filter.Text);
     ds.sl:= hdmSession.sl;
     mResume.Text:= hdmSession.Text;
end;

procedure TfTemps.bTo_logClick(Sender: TObject);
begin
     hdmSession.To_log;
end;

procedure TfTemps.cbEcrire_arrondiChange(Sender: TObject);
begin
     ublSession_Ecrire_arrondi:= cbEcrire_arrondi.Checked;
end;

procedure TfTemps.cbHeures_SupplementairesChange(Sender: TObject);
begin
     ublCalendrier_Heures_Supplementaires:= cbHeures_Supplementaires.Checked;
end;

procedure TfTemps.cbRestreindre_a_un_TagClick(Sender: TObject);
begin
     if not cbRestreindre_a_un_Tag.Checked then exit;

     poolTag.ToutCharger;
     poolTag.TrierFiltre;
     dsbTag.sl:= poolTag.slFiltre;
end;

procedure TfTemps.dsClick(Sender: TObject);
begin

end;

procedure TfTemps.eFactureEnter(Sender: TObject);
begin
     eFacture.Text:= Clipboard.AsText;
end;

procedure TfTemps.b0_NowClick(Sender: TObject);
var
   Resultat: String;
begin
     odWork_from_Period.Init( 0, Now, idTag, '');
     Resultat:= odWork_from_Period.Visualiser;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfTemps.bDescription_Filter_cancelClick(Sender: TObject);
begin
     eDescription_Filter.Text:= '';
end;

procedure TfTemps.bodCalendrierClick(Sender: TObject);
var
   od: TodCalendrier;
   Resultat: String;
begin
     od:= TodCalendrier.Create( cbDepassement.Checked);
     try
        od.Init( hdmSession.hdmCalendrier);
        Resultat:= od.Visualiser;
        if not OpenDocument( Resultat)
        then
            ShowMessage( 'OpenDocument failed on '+Resultat);
     finally
            FreeAndNil( od);
            end;
end;

procedure TfTemps.bodCalendrier_ModeleClick(Sender: TObject);
var
   od: TodCalendrier;
   Resultat: String;
begin
     od:= TodCalendrier.Create( cbDepassement.Checked);
     try
        od.Init( hdmSession.hdmCalendrier);
        Resultat:= od.Editer_Modele_Impression;
        if not OpenDocument( Resultat)
        then
            ShowMessage( 'OpenDocument failed on '+Resultat);
     finally
            FreeAndNil( od);
            end;
end;

procedure TfTemps.bodSessionClick(Sender: TObject);
var
   odSession: TodSession;
   Resultat: String;
begin
     odSession:= TodSession.Create;
     try
        odSession.Init( hdmSession, eFacture.Text);
        Resultat:= odSession.Visualiser;
     finally
            FreeAndNil( odSession);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfTemps.bodSession_ModeleClick(Sender: TObject);
var
   odSession: TodSession;
   Resultat: String;
begin
     odSession:= TodSession.Create;
     try
        odSession.Init( hdmSession, eFacture.Text);
        Resultat:= odSession.Editer_Modele_Impression;
     finally
            FreeAndNil( odSession);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

initialization
finalization
            Clean_Destroy( FfTemps);
end.

