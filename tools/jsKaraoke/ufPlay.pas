unit ufPlay;

{$mode ObjFPC}{$H+}

interface

uses
    uBatpro_StringList,
    uPublieur,
    ublTexte,
    ublTiming,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

 { TfPlay }

 TfPlay
 =
  class(TForm)
   mFrancais: TMemo;
   mTranslitteration: TMemo;
    mCyrillique: TMemo;
    tShow: TTimer;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
  public
    pOnShow: TAbonnement_Objet_Proc;
    procedure _from( _bl, _blOld:TblTiming);
  end;

var
 fPlay: TfPlay;

implementation

{$R *.lfm}

{ TfPlay }

procedure TfPlay.tShowTimer(Sender: TObject);
var
   m_Height: Integer;
begin
     tShow.Enabled:= False;
     ClientWidth:= Trunc( ClientHeight*16/9);

     m_Height:= ClientHeight div 3;
     mTranslitteration.Height:= m_Height;
     mCyrillique      .Height:= m_Height;
     if Assigned( pOnShow) then pOnShow;
end;

procedure TfPlay.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfPlay.FormResize(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfPlay._from(_bl, _blOld: TblTiming);
var
   blT, blT_Old: TblTexte;
   T_OK, T_Old_OK: Boolean;
   function T_from_( _bl: TblTiming; out _blT: TblTexte): Boolean;
   begin
        Result:= Assigned( _bl);
        if not Result then exit;

        Result:= Affecte( _blT    , TblTexte, _bl.Texte_bl);
   end;
begin
     T_OK    := T_from_( _bl   , blT    );
     T_Old_OK:= T_from_( _blOld, blT_Old);

     mTranslitteration.Lines.Clear;
     mFrancais        .Lines.Clear;
     mCyrillique      .Lines.Clear;

     //if T_Old_OK then mTranslitteration.Lines.Add( blT_Old.Translitteration);
     if T_OK     then mTranslitteration.Lines.Add( blT    .Translitteration);

     //if T_Old_OK then mFrancais.Lines.Add( blT_Old.Francais);
     if T_OK     then mFrancais.Lines.Add( blT    .Francais);

     //if T_Old_OK then mCyrillique.Lines.Add( blT_Old.Cyrillique);
     if T_OK     then mCyrillique.Lines.Add( blT    .Cyrillique);
end;

end.

