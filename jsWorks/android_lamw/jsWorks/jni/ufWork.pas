{Hint: save all files to location: \jni }
unit ufWork;

{$mode delphi}

interface

uses
    //uLog,
    //uChamps,

    ublWork,

 Classes, SysUtils, AndroidWidget, Laz_And_Controls, ucjChamp_Edit;
 
type

	{ TfWork }

 TfWork
 =
  class(jForm)
			bDemarrer: jButton;
			jceBeginning: TjChamp_Edit;
			jceDescription: TjChamp_Edit;
			jceEnd: TjChamp_Edit;
			jEditText1: jEditText;
			jpBeginning: jPanel;
			jpEnd: jPanel;
			jTextView1: jTextView;
			jTextView2: jTextView;
			procedure bDemarrerClick(Sender: TObject);
  //Work
  //private
  //  bl: TblWork;
  end;

function fWork: TfWork;

implementation
 
{$R *.lfm}

{ TfWork }

var
   FfWork: TfWork= nil;

function fWork: TfWork;
begin
     if nil = FfWork
     then
         begin
         WriteLn( 'ufWork.fWork: avant CreateForm');
         gApp.CreateForm( TfWork, FfWork);
         WriteLn( 'ufWork.fWork: avant FfWork.Init( gApp);');
         FfWork.Init( gApp);
         end;
     Result:= FfWork;
end;

procedure TfWork.bDemarrerClick(Sender: TObject);
begin

end;

end.



public java.lang.Object jEditText_Create(long pasobj ) {
  return (java.lang.Object)( new jEditText(this.activity,this,pasobj));
}


