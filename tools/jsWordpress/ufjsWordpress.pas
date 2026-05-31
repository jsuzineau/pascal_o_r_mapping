unit ufjsWordpress;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uuStrings,
    ujsWordpress_API_Client,
    Classes, SysUtils, Forms, Controls, Graphics,
    Dialogs, ExtCtrls, StdCtrls, fpjson;

type

 { TfjsWordpress }

 TfjsWordpress = class(TForm)
  bFrom_Slug: TButton;
  bCreate: TButton;
  bUpdate: TButton;
  bMe: TButton;
  eContent: TEdit;
  ePassword: TEdit;
  eUserName: TEdit;
  eID: TEdit;
  eStatus: TEdit;
  eTitle: TEdit;
  eRoot_URL: TEdit;
  eSlug: TEdit;
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  m: TMemo;
  Panel1: TPanel;
  procedure bCreateClick(Sender: TObject);
  procedure bFrom_SlugClick(Sender: TObject);
  procedure bMeClick(Sender: TObject);
  procedure bUpdateClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private

 public
   function Pages_from_slug( _slug: String): String;
   function Page_Create( _Title, _Content, _slug, _status: String): String;
   function Page_Update( _id, _Title, _Content, _slug, _status: String): String;
   function Me: String;
 end;

var
 fjsWordpress: TfjsWordpress;

implementation

{$R *.lfm}

{ TfjsWordpress }

procedure TfjsWordpress.FormCreate(Sender: TObject);
begin
     m.Clear;
     eUserName.Text:=EXE_INI.ReadString( 'Options', 'eUserName', eUserName.Text);
     ePassword.Text:=EXE_INI.ReadString( 'Options', 'ePassword', ePassword.Text);
     eRoot_URL.Text:=EXE_INI.ReadString( 'Options', 'eRoot_URL', eRoot_URL.Text);
end;

procedure TfjsWordpress.FormDestroy(Sender: TObject);
begin
     EXE_INI.WriteString( 'Options', 'eUserName', eUserName.Text);
     EXE_INI.WriteString( 'Options', 'ePassword', ePassword.Text);
     EXE_INI.WriteString( 'Options', 'eRoot_URL', eRoot_URL.Text);
end;

function TfjsWordpress.Pages_from_slug( _slug: String): String;
var
   wp: T_wp_v2_pages_get;
begin
     wp:= T_wp_v2_pages_get.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
     try
        wp.slug    ( _slug);
        wp.per_page( '100');
        m.Lines.Add( wp.url);
        Result:= wp.Execute;
        String_to_File( ExtractFilePath(Application.ExeName)+'log'+DirectorySeparator+'Courant.html', Result);
     finally
            FreeAndNil( wp);
            end;
end;

function TfjsWordpress.Page_Create(_Title, _Content, _slug, _status: String): String;
var
   wp: T_wp_v2_pages_post;
begin
     wp:= T_wp_v2_pages_post.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
     try
        wp.title  ( TJSONString.Create(_Title  ));
        wp.content( TJSONString.Create(_Content));
        wp.slug   ( TJSONString.Create(_slug   ));
        wp.status ( TJSONString.Create({_status}'publish' ));
        Result:= wp.Execute;
     finally
            FreeAndNil( wp);
            end;
end;

function TfjsWordpress.Page_Update( _id, _Title, _Content, _slug, _status: String): String;
var
   wp: T_wp_v2_pages__id__post;
begin
     wp:= T_wp_v2_pages__id__post.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
     try
        wp.id     ( _id);
        wp.title  ( TJSONString.Create(_Title  ));
        wp.content( TJSONString.Create(_Content));
        wp.slug   ( TJSONString.Create(_slug   ));
        wp.status ( TJSONString.Create({_status}'publish'));
        m.Lines.Add( wp.url);
        m.Lines.Add( wp.Properties.AsJSON);
        Result:= wp.Execute;
     finally
            FreeAndNil( wp);
            end;
end;

function TfjsWordpress.Me: String;
var
   wp: T_wp_v2_users_me_get;
begin
     wp:= T_wp_v2_users_me_get.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
     try
        m.Lines.Add(wp.http.Headers.Text);
        Result:= wp.Execute;
     finally
            FreeAndNil( wp);
            end;
end;


procedure TfjsWordpress.bFrom_SlugClick(Sender: TObject);
begin
     m.Lines.Add( Pages_from_slug( eSlug.Text));
end;

procedure TfjsWordpress.bCreateClick(Sender: TObject);
begin
     m.Lines.Add( Page_Create( eTitle.Text, eContent.Text, eSlug.Text, eStatus.Text));
end;

procedure TfjsWordpress.bUpdateClick(Sender: TObject);
begin
     m.Lines.Add( Page_Update( eID.Text, eTitle.Text, eContent.Text, eSlug.Text, eStatus.Text));
end;

procedure TfjsWordpress.bMeClick(Sender: TObject);
begin
     m.Lines.Add( Me);
end;



end.

