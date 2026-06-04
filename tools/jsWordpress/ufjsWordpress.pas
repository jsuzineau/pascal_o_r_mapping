unit ufjsWordpress;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uuStrings,
    uOD_JCL,
    uMimeType,
    ujsWordpress_API_Client,
    urust_html_clean,
    ufHTML,
    uChrono,
    Classes, SysUtils,
    Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Spin,
    fpjson, DOM, XMLRead, XMLWrite, SAX_HTML, DOM_HTML;

type

 { TfjsWordpress }

 TfjsWordpress = class(TForm)
  bCreate: TButton;
  bFrom_Slug: TButton;
  bMe: TButton;
  bUpdate: TButton;
  bMediaCreate: TButton;
  bTraite_fichiers_htm: TButton;
  b_index_htm: TButton;
  cbCodePage: TCheckBox;
  cbCharset: TCheckBox;
  cbAdd_DOCTYPE_html: TCheckBox;
  eContent: TEdit;
  eCharset: TEdit;
  eMedia: TEdit;
  eID: TEdit;
  ePassword: TEdit;
  eRoot_URL: TEdit;
  eSlug: TEdit;
  eSource: TEdit;
  eStatus: TEdit;
  eTitle: TEdit;
  eUserName: TEdit;
  Label1: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  Label9: TLabel;
  m: TMemo;
  pc: TPageControl;
  rgImport: TRadioGroup;
  seCodePage: TSpinEdit;
  tsHTML_to_Wordpress: TTabSheet;
  tsWorpress_API: TTabSheet;
  procedure bCreateClick(Sender: TObject);
  procedure bFrom_SlugClick(Sender: TObject);
  procedure bMeClick(Sender: TObject);
  procedure bMediaCreateClick(Sender: TObject);
  procedure bTraite_fichiers_htmClick(Sender: TObject);
  procedure bUpdateClick(Sender: TObject);
  procedure b_index_htmClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private

 //API Worpress
 public
   function Pages_from_slug( _slug: String): String;
   function Page_Create( _Title, _Content, _slug, _status: String): String;
   function Page_Update( _id, _Title, _Content, _slug, _status: String): String;
   function Me: String;
   function Media_Create( _NomFichier:String):String;
 //Traitement HTML -> Wordpress
 public
   function Slug_from_url_path( _url_path: String):String;
   procedure Traite_Fichier(_NomFichier: String; _url_path: String);
   procedure Traite_fichiers;
 //Gestion des urls d'images
 public
   slIMG_src: TStringList;
   slIMG_src_w: TStringList;
 //Gestion des urls de pages
 public
   slPages: TStringList;
   procedure Save_sl;
 end;

var
 fjsWordpress: TfjsWordpress;

implementation

{$R *.lfm}

{ TfjsWordpress }

procedure TfjsWordpress.FormCreate(Sender: TObject);
begin
     slIMG_src  := TStringList.Create;
     slIMG_src_w:= TStringList.Create;
     slPages    := TStringList.Create;

     slPages    .LoadFromFile( ExtractFilePath(EXE_INI_Nom)+'slPages.txt'  );
     slIMG_src  .LoadFromFile( ExtractFilePath(EXE_INI_Nom)+'slIMG_src.txt'  );
     slIMG_src_w.LoadFromFile( ExtractFilePath(EXE_INI_Nom)+'slIMG_src_w.txt');

     m.Clear;
     eSource  .Text:=EXE_INI.ReadString( 'Options', 'eSource'  , eSource  .Text);
     eUserName.Text:=EXE_INI.ReadString( 'Options', 'eUserName', eUserName.Text);
     ePassword.Text:=EXE_INI.ReadString( 'Options', 'ePassword', ePassword.Text);
     eRoot_URL.Text:=EXE_INI.ReadString( 'Options', 'eRoot_URL', eRoot_URL.Text);
     eMedia   .Text:=EXE_INI.ReadString( 'Options', 'eMedia'   , eMedia   .Text);
     eCharset .Text:=EXE_INI.ReadString( 'Options', 'eCharset' , eCharset .Text);
end;

procedure TfjsWordpress.FormDestroy(Sender: TObject);
begin
     EXE_INI.WriteString( 'Options', 'eSource'  , eSource  .Text);
     EXE_INI.WriteString( 'Options', 'eUserName', eUserName.Text);
     EXE_INI.WriteString( 'Options', 'ePassword', ePassword.Text);
     EXE_INI.WriteString( 'Options', 'eRoot_URL', eRoot_URL.Text);
     EXE_INI.WriteString( 'Options', 'eMedia'   , eMedia   .Text);
     EXE_INI.WriteString( 'Options', 'eCharset' , eCharset .Text);

     Save_sl;

     FreeAndNil( slIMG_src  );
     FreeAndNil( slIMG_src_w);
     FreeAndNil( slPages    );
end;

procedure TfjsWordpress.Save_sl;
begin
     slPages    .SaveToFile( ExtractFilePath(EXE_INI_Nom)+'slPages.txt'    );
     slIMG_src  .SaveToFile( ExtractFilePath(EXE_INI_Nom)+'slIMG_src.txt'  );
     slIMG_src_w.SaveToFile( ExtractFilePath(EXE_INI_Nom)+'slIMG_src_w.txt');
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

function TfjsWordpress.Media_Create( _NomFichier: String): String;
   procedure Par_multipart_form_data;//ne fonctionne pas
   var
      wp: T_wp_v2_media_post;
   begin
        wp:= T_wp_v2_media_post.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
        try
           wp.Set_multipart_form_data;
           wp.slug(TJSONString.Create(Slug_from_url_path( _NomFichier)));
           wp.Add_File( _NomFichier);
           Result:= wp.Execute;
        finally
               FreeAndNil( wp);
               end;
   end;
   procedure Par_deux_appels;
   var
      wp1: T_wp_v2_media_post;
      wp2: T_wp_v2_media__id__patch;
   begin
        wp1:= T_wp_v2_media_post.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
        try
           wp1.Set_attachment;
           wp1.hc.AddHeader( 'Accept'             , 'application/json'                      );
           wp1.hc.AddHeader( 'User-Agent'         , 'jsWordpress'                           );
           wp1.Add_File( _NomFichier);
           Result:= wp1.Execute;
           String_to_File( ChangeFileExt(_NomFichier, '_img.json'), Result) ;
        finally
               FreeAndNil( wp1);
               end;

        //wp2:= T_wp_v2_media__id__patch.Create(eRoot_URL.Text, eUserName.Text, ePassword.Text);
        //try
        //   wp2.slug(TJSONString.Create(Slug_from_url_path( _NomFichier)));
        //   Result:= wp1.Execute;
        //finally
        //       FreeAndNil( wp1);
        //       end;
   end;
begin
     //Par_multipart_form_data;
     Par_deux_appels;
end;

function TfjsWordpress.Slug_from_url_path(_url_path: String): String;
begin
     if '' = _url_path
     then
         begin
         Result:= 'accueil';
         exit;
         end;
     Result:= ExtractFileName( _url_path);
     Result:= StringReplace( Result, '.html', '',[rfIgnoreCase]);
     Result:= StringReplace( Result, '.htm' , '',[rfIgnoreCase]);
end;

procedure TfjsWordpress.Traite_Fichier(_NomFichier: String; _url_path: String);
var
   slug: String;
   sTitle: String;
   sBody: String;

   function Traite_Codepage: String;
   var
      sFichier: RawByteString;
   begin
        sFichier:= String_from_File( _NomFichier);
        if cbCodePage.Checked
        then
            begin
            SetCodePage( sFichier, seCodePage.Value, False);
            Result:= AnsiToUtf8( sFichier);
            if cbCharset.Checked
            then
                Result:= StringReplace( Result, 'charset='+eCharset.Text, 'charset=UTF8', [rfIgnoreCase,rfReplaceAll]);
            end
        else
            Result:= sFichier;
        if cbAdd_DOCTYPE_html.Checked
        then
            Result:= '<!DOCTYPE html>'+Result;
        String_to_File( ChangeFileExt(_NomFichier, '_UTF8.html'), Result) ;
        Result:= html_clean( Result);
        String_to_File( ChangeFileExt(_NomFichier, '_html_clean.html'), Result) ;
   end;
   procedure Traite_par_html( _s: String); //ne fonctionne pas sur html malformé
   var
      ss: TStringStream;
      html: THTMLDocument;
      nRoot: TDOMNode;
      nBody: TDOMNode;
      function Has_img( _s:String):String;
      var
         i: Integer;
      begin
           i:= slIMG_src.IndexOf( _s);
           if -1 = i
           then
               Result:= ''
           else
               Result:= slIMG_src_w[i];
      end;
      function src_Wordpress_from_src( _src: String):String;
      var
         sPath: String;
         sJSON: String;
         jd,e: TJSONData;
         s:String;
      begin
           Result:= _src;
           if     (1 = Pos( 'http', _src))
              and not (1 = Pos( eSource.Text, _src))
           then
               exit;

           sPath:= IncludeTrailingPathDelimiter( eSource.Text)+_src;
           Result:= Has_img( sPath);
           if '' <> Result then exit;

           sJSON:= Media_Create( sPath);
           jd:= GetJSON( sJSON);
           e:= jd.FindPath( 'guid.rendered');
           s:= e.AsString;
           //strtok( 'wp-content/', s);
           //Set_Property( cir_e, 'src', 'wp-content/'+s);
           slIMG_src  .Add( sPath);
           slIMG_src_w.Add( s);
           Result:= s;
      end;
      procedure Traite_img;
      var
         cir: TCherche_Items_Recursif;
         cir_e: TDOMNode;
         src: String;
      begin
           cir:= TCherche_Items_Recursif.Create( nRoot, 'img', [], []);
           try
              for cir_e in cir.l
              do
                begin
                if not_Get_Property( cir_e, 'src', src) then continue;

                Set_Property( cir_e, 'src', src_Wordpress_from_src( src));
                end;
           finally
                  FreeAndNil( cir);
                  end;
      end;
   begin
        ss:= TStringStream.Create( _s);
        try
           ReadHTMLFile( html, ss);
        finally
               FreeAndNil( ss);
               end;
        try
           nRoot:= html.DocumentElement;
           sTitle:= Text_from_path( nRoot, 'head/title');
           Traite_img;

           nBody := Elem_from_path( nRoot, 'body');
           if nil = nBody
           then
               raise Exception.Create( 'tag body introuvable');

           sBody:= String_from_node( nBody);

        finally
               FreeAndNil( html);
               end;
   end;
   procedure Traite_par_StrToK( _s: String);
   begin
        StrToK('<title>', _s);
        sTitle:= StrToK('</title>', _s);

        StrToK('<body>', _s);
        sBody:= StrToK('</body>', _s);
   end;
begin
     if -1 <> slPages.IndexOf( _NomFichier) then exit;
     try
        slug:= Slug_from_url_path( _url_path);

        case rgImport.ItemIndex
        of
          0: Traite_par_html( Traite_Codepage);
          1: Traite_par_StrToK( Traite_Codepage);
          end;

        //m.Lines.Add( sBody);
        m.Lines.Add( Page_Create( sTitle, sBody, slug, 'published'));
        slPages.Add( _NomFichier);
        Save_sl;
     except
           on E: Exception
           do
             begin
             fHTML.Ouvre( _NomFichier, e);
             raise;
             end;
           end;
end;

procedure TfjsWordpress.Traite_fichiers;
var
   Source: String;
   sr: TSearchRec;
begin
     Chrono.Start;
     Chrono.Stop('début Traite_fichiers');
     Source:= IncludeTrailingPathDelimiter(eSource.Text);
     if 0 <> FindFirst( Source+'*.htm', faAnyFile, sr)
     then
         exit;
     try
        repeat
              if faDirectory = (sr.Attr and faDirectory)
              then
                  continue;
              Traite_Fichier( Source+sr.Name, sr.Name);
        until 0 <> FindNext( sr);
     finally
            FindClose( sr);
     end;
     Chrono.Stop('Fin Traite_fichiers');
     m.Lines.Add( '');
     m.Lines.Add( '');
     m.Lines.Add( 'Chrono: ');
     m.Lines.Add( Chrono.Get_Temps);
     m.Lines.Add( Chrono.Get_Liste);
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

procedure TfjsWordpress.b_index_htmClick(Sender: TObject);
begin
     Traite_Fichier( IncludeTrailingPathDelimiter( eSource.Text)+'index.htm', '');
end;

procedure TfjsWordpress.bTraite_fichiers_htmClick(Sender: TObject);
begin
     Traite_fichiers;
end;

procedure TfjsWordpress.bMeClick(Sender: TObject);
begin
     m.Lines.Add( Me);
end;

procedure TfjsWordpress.bMediaCreateClick(Sender: TObject);
begin
     m.Lines.Add( Media_Create( eMedia.Text));
end;

end.

