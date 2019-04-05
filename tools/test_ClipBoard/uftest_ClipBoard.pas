unit uftest_ClipBoard;

{$mode objfpc}{$H+}

interface

uses
    RegExpr,
    Clipbrd, LCLType,

 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

 { Tftest_ClipBoard }

 Tftest_ClipBoard
 =
  class(TForm)
    Button1: TButton;
    m: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure CheckClipboard;
    procedure ReadClip( _Format : ANSIString);
  public

  end;

{ TClipBoardFormat_String }

TClipBoardFormat_String
=
 class
 //Vie
 public
   constructor Create( _Name:String);
   destructor Destroy; override;
 //Nom de format
 public
   Name: String;
 //Parsing
 protected
   procedure Decode; virtual; abstract;
 //Brut
 public
   Brut: String;
   LBrut: Integer;
   pBrut: PChar;
   procedure Brut_from_Clipboard;
   function Brut_Copy( _Debut, _Longueur: Integer): String;
 //Log
 protected
   procedure Log( _S: String);
 public
   procedure DoLog; virtual;
 end;

{ Tcbfs_HTML_Format }

Tcbfs_HTML_Format
=
 class(TClipBoardFormat_String)
 //Vie
 public
   constructor Create( _Name:String);
   destructor Destroy; override;
 //Parsing
 protected
   re: TRegExpr;
   function vString ( _Index: Integer): String;
   function vInteger( _Index: Integer): Integer;
   function RegExp_pattern: String;
   function RegExp_pattern_Fragment_Source: String;
   function RegExp_pattern_Fragment_Selection_Source: String;
   procedure Decode; override;
 //Attributs
 public
   Version: String;
   HTMLStart: Integer;
   HTMLEnd  : Integer;
   FragmentStart: Integer;
   FragmentEnd  : Integer;
   SelectionStart: Integer;
   SelectionEnd  : Integer;
   SourceURL: String;
 //Header
 public
   function Header: String;
 //HTML
 public
   function HTML: String;
 //Fragment
 public
   function Fragment: String;
 //Selection
 public
   function Selection: String;
 //Log
 public
   procedure DoLog; override;
 end;

var
   ftest_ClipBoard: Tftest_ClipBoard;
   mLog: TMemo=nil;

implementation

{$R *.lfm}

{ TClipBoardFormat_String }

constructor TClipBoardFormat_String.Create(_Name: String);
begin
     inherited Create;
     Name:= _Name;
     Brut_from_Clipboard;
     Decode;
     DoLog;
end;

destructor TClipBoardFormat_String.Destroy;
begin
     inherited Destroy;
end;

procedure TClipBoardFormat_String.Brut_from_Clipboard;
var
   ms: TMemoryStream;
   cf : TClipboardFormat;
   sl : TStringList;
begin
     Brut:= '';
     if Name = '' then exit;
     ms:= TMemoryStream.Create;
     sl:= TStringList.Create;
     try
        if Clipboard.HasFormatName( Name)
        then
            begin
            cf:= ClipBoard.FindFormatID( Name);
            ClipBoard.GetFormat( cf, ms);
            if ms.Size > 0
            then
                begin
                ms.Seek(0, soFromBeginning);
                sl.LoadFromStream(ms);
                Brut:= sl.Text;
                end;
            end;
   finally
          sl.Free;
          ms.Free;
          end;
   pBrut:= PChar(Brut);
   LBrut:= Length( Brut);
end;

function TClipBoardFormat_String.Brut_Copy( _Debut, _Longueur: Integer): String;
var
   pResult: PChar;
begin
     SetLength( Result, _Longueur);
     pResult:= PChar(Result);
     Move( pBrut[_Debut], pResult[0], _Longueur);
end;

procedure TClipBoardFormat_String.Log( _S: String);
begin
     mLog.Lines.Add( _S);
end;

procedure TClipBoardFormat_String.DoLog;
begin
     Log( '##########################################################');
     Log( Name);
     Log( '##########################################################');
     Log( 'Format brut:');
     Log( Brut);
     Log( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end;

{ Tcbfs_HTML_Format }

constructor Tcbfs_HTML_Format.Create(_Name: String);
begin
     inherited;
end;

destructor Tcbfs_HTML_Format.Destroy;
begin
     inherited Destroy;
end;

function Tcbfs_HTML_Format.vString(_Index: Integer): String;
begin
     Result:= re.Match[ _Index];
end;

function Tcbfs_HTML_Format.vInteger(_Index: Integer): Integer;
var
   S: String;
begin
     S:= vString( _Index);
     if not TryStrToInt( S, Result)
     then
         Result:= -1;
end;

function Tcbfs_HTML_Format.RegExp_pattern: String;
begin
     Result
     :=
        'Version:(\S+)\s+'
       +'StartHTML:(\d+)\s+'
       +'EndHTML:(\d+)\s+';
end;

function Tcbfs_HTML_Format.RegExp_pattern_Fragment_Source: String;
begin
     Result
     :=
        'Version:(\S+)\s+'
       +'StartHTML:(\d+)\s+'
       +'EndHTML:(\d+)\s+'
       +'StartFragment:(\d+)\s+'
       +'EndFragment:(\d+)\s+'
       +'SourceURL:(\S+)';
end;

function Tcbfs_HTML_Format.RegExp_pattern_Fragment_Selection_Source: String;
begin
     Result
     :=
        'Version:(\S+)\s+'
       +'StartHTML:(\d+)\s+'
       +'EndHTML:(\d+)\s+'
       +'StartFragment:(\d+)\s+'
       +'EndFragment:(\d+)\s+'
       +'StartSelection:(\d+)\s+'
       +'EndSelection:(\d+)\s+'
       +'SourceURL:(\S+)';
end;

procedure Tcbfs_HTML_Format.Decode;
     function not_pattern( _pattern: String): Boolean;
     begin
          re:= TRegExpr.Create( _pattern);
          Result:= not re.Exec( Brut);
          if Result
          then
              FreeAndNil( re);
     end;
     function not_Fragment_Selection_Source: Boolean;
     begin
          Result:= not_pattern( RegExp_pattern_Fragment_Selection_Source);
          if Result then exit;
          Version       := vString ( 1);
          HTMLStart     := vInteger( 2);
          HTMLEnd       := vInteger( 3);
          FragmentStart := vInteger( 4);
          FragmentEnd   := vInteger( 5);
          SelectionStart:= vInteger( 6);
          SelectionEnd  := vInteger( 7);
          SourceURL     := vString ( 8);
          FreeAndNil( re);
     end;
     function not_Fragment_Source: Boolean;
     begin
          Result:= not_pattern( RegExp_pattern_Fragment_Source);
          if Result then exit;
          Version      := vString ( 1);
          HTMLStart    := vInteger( 2);
          HTMLEnd      := vInteger( 3);
          FragmentStart:= vInteger( 4);
          FragmentEnd  := vInteger( 5);
          SourceURL    := vString ( 6);
          FreeAndNil( re);
     end;
     function not_Minimal: Boolean;
     begin
          Result:= not_pattern( RegExp_pattern);
          if Result then exit;
          Version      := vString ( 1);
          HTMLStart    := vInteger( 2);
          HTMLEnd      := vInteger( 3);
          FreeAndNil( re);
     end;
     procedure Parse;
     var
        sl: TStringList;
        function sl_vString ( _Name: String): String;
        var
           I: Integer;
        begin
             Result:= '';
             I:= sl.IndexOfName( _Name);
             if -1 = I then exit;
             Result:= sl.ValueFromIndex[I];
        end;
        function sl_vInteger( _Name: String): Integer;
        var
           S: String;
        begin
             S:= sl_vString( _Name);
             if not TryStrToInt( S, Result)
             then
                 Result:= -1;
        end;
     begin
          Version       := '';
          HTMLStart     := -1;
          HTMLEnd       := -1;
          FragmentStart := -1;
          FragmentEnd   := -1;
          SelectionStart:= -1;
          SelectionEnd  := -1;
          SourceURL     := '';

          if not_Minimal then exit;

          sl:= TStringList.Create;
          try
             sl.Text:= Header;
             sl.NameValueSeparator:=':';

             FragmentStart := sl_vInteger( 'StartFragment' );
             FragmentEnd   := sl_vInteger( 'EndFragment'   );
             SelectionStart:= sl_vInteger( 'StartSelection');
             SelectionEnd  := sl_vInteger( 'EndSelection'  );
             SourceURL     := sl_vString ( 'SourceURL'     );
          finally
                 FreeAndNil( sl);
                 end;
     end;
begin
     Parse;
end;

function Tcbfs_HTML_Format.Header: String;
begin
     Result:= Copy( Brut, 1, HTMLStart);
end;

function Tcbfs_HTML_Format.HTML: String;
begin
     Result:= Brut_Copy( HTMLStart, HTMLEnd-HTMLStart+4);
end;

function Tcbfs_HTML_Format.Fragment: String;
begin
     Result:= Brut_Copy( FragmentStart, FragmentEnd-FragmentStart+4);
end;

function Tcbfs_HTML_Format.Selection: String;
begin
     Result:= Brut_Copy( SelectionStart, SelectionEnd-SelectionStart+4);
end;

procedure Tcbfs_HTML_Format.DoLog;
begin
     inherited DoLog;
     Log( 'HTML Format Version:'+Version);
     Log( 'URL source:'+SourceURL);
     Log( 'code HTML complet:');
     Log( HTML);
     Log( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
     Log( 'Fragment HTML:');
     Log( Fragment);
     Log( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
     Log( 'Selection HTML:');
     Log( Selection);
     Log( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
end;

{ Tftest_ClipBoard }

procedure Tftest_ClipBoard.FormCreate(Sender: TObject);
begin
     mLog:= m;
end;

procedure Tftest_ClipBoard.Button1Click(Sender: TObject);
begin
     CheckClipboard;
end;

procedure Tftest_ClipBoard.CheckClipboard;
var
    I: integer;
    sl: TStringList;
    sFormat: String;
begin
     m.clear;
     sl:= TStringList.Create;
     try
        ClipBoard.SupportedFormats(sl);
        m.Lines.AddStrings( sl);

        m.Append('####################################');
        for i := 0 to sl.Count-1
        do
          begin
          sFormat:= sl.Strings[i];
          m.Append(sFormat+':');
          case sFormat
          of
            'text/html'            ,
            'text/_moz_htmlcontext',
            'text/_moz_htmlinfo'   ,
            'text/plain'           ,
            'text/x-moz-url-priv'  ,
            'Rich Text Format'     ,
            'UTF8_STRING'          : ReadClip( sFormat);
            'HTML Format'          : Tcbfs_HTML_Format.Create( sFormat).Free;
            end;
          end;

     finally
            sl.Free;
            end;
end;

procedure Tftest_ClipBoard.ReadClip(_Format: ANSIString);
var
   ms: TMemoryStream;
   cf : TClipboardFormat;
   sl : TStringList;
begin
     if _Format = '' then exit;
     ms:= TMemoryStream.Create;
     sl:= TStringList.Create;
     try
        if Clipboard.HasFormatName( _Format)
        then
            begin
            m.Lines.Add('>>>>>>>>>>>>>>>>>>>>');
            cf:= ClipBoard.FindFormatID( _Format);
            ClipBoard.GetFormat( cf, ms);
            if ms.Size > 0
            then
                begin
                ms.Seek(0, soFromBeginning);
                sl.LoadFromStream(ms);
                m.Lines.AddStrings(sl, False);
                end;
            m.Lines.Add('<<<<<<<<<<<<<<<<<<<<<<');
            end;
   finally
          sl.Free;
          ms.Free;
          end;
end;
end.

