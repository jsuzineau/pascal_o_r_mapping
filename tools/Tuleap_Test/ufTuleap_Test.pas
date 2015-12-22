unit ufTuleap_Test;

{$mode objfpc}{$H+}

interface

uses
    uWSDL_codendi,
    uWSDL_codendi_proxy,
    uWSDL_project,
    uWSDL_project_proxy,
    uWSDL_svn,
    uWSDL_svn_proxy,
    uWSDL_tracker,
    uWSDL_tracker_proxy,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfTuleap_Test }

 TfTuleap_Test
 =
  class(TForm)
    bCreation: TButton;
    bCreation_Client: TButton;
    bLogout: TButton;
    m: TMemo;
    procedure bCreationClick(Sender: TObject);
    procedure bCreation_ClientClick(Sender: TObject);
    procedure bLogoutClick(Sender: TObject);
  private
    c: CodendiAPIPortType;
    s: Session;
    sk: UnicodeString;
    p: TuleapProjectAPIPortType;
    Projects: ArrayOfGroup;
    procedure Liste_Projects;
   end;

var
 fTuleap_Test: TfTuleap_Test;

implementation

{$R *.lfm}

{ TfTuleap_Test }

procedure TfTuleap_Test.bCreation_ClientClick(Sender: TObject);
begin
     c:= wst_CreateInstance_CodendiAPIPortType;
     if c= nil
     then
         begin
         ShowMessage( 'Echec wst_CreateInstance_CodendiAPIPortType');
         exit;
         end;
     s:= c.login('jean','azerty12');
     if s= nil
     then
         begin
         ShowMessage( 'Echec c.login');
         exit;
         end;
    sk:= s.session_hash;

    p:= wst_CreateInstance_TuleapProjectAPIPortType;
    if p= nil
    then
        begin
        ShowMessage( 'Echec wst_CreateInstance_TuleapProjectAPIPortType');
        exit;
        end;

    Projects:= c.getMyProjects( sk);
    if Projects= nil
    then
        begin
        ShowMessage( 'Echec c.getMyProjects( sk)');
        exit;
        end;
    Liste_Projects;
end;

procedure TfTuleap_Test.bLogoutClick(Sender: TObject);
begin
     c.logout( sk);
end;

procedure TfTuleap_Test.Liste_Projects;
var
   I: Integer;
   g: Group;
begin
     m.Clear;
     for I:= 0 to Projects.Length-1
     do
       begin
       g:= Projects.Item[ I];
       if nil = g then continue;

       m.Lines.Add( IntToStr(g.group_id)+' '+g.group_name);
       end;
end;

procedure TfTuleap_Test.bCreationClick(Sender: TObject);
var
   t: TuleapTrackerV5APIPortType;
begin
     t:= wst_CreateInstance_TuleapTrackerV5APIPortType;
     if nil = t
     then
         begin
         ShowMessage( 'Echec création t');
         exit;
         end;
     ShowMessage( 't créé avec succés');
end;

end.

