unit ufGenerateur_OpenAPI;

interface

uses
    uOpenAPI,
    ublAutomatic,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls;

type
 { TfGenerateur_OpenAPI }
 TfGenerateur_OpenAPI
 =
  class(TForm)
   m: TMemo;
    miFichier_Ouvrir: TMenuItem;
    miFichier: TMenuItem;
    mm: TMainMenu;
    od: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure miFichier_OuvrirClick(Sender: TObject);
  private
    NomFichier: String;
    OpenAPI: TOpenAPI;
    procedure Ouvrir( _NomFichier: String);
    procedure _from_OpenAPI;
  end;

var
 fGenerateur_OpenAPI: TfGenerateur_OpenAPI;

implementation

{$R *.lfm}

{ TfGenerateur_OpenAPI }

procedure TfGenerateur_OpenAPI.FormCreate(Sender: TObject);
begin
     OpenAPI:= nil;
     _from_OpenAPI;
end;

procedure TfGenerateur_OpenAPI.FormDropFiles( Sender: TObject;
                                          const FileNames: array of string);
begin
     if Length( FileNames) < 1 then exit;

     Ouvrir(FileNames[0]);
end;

procedure TfGenerateur_OpenAPI.miFichier_OuvrirClick(Sender: TObject);
begin
     FreeAndNil( OpenAPI);
     if not od.Execute then exit;

     Ouvrir(od.FileName);
end;

procedure TfGenerateur_OpenAPI.Ouvrir( _NomFichier: String);
begin
     NomFichier:= _NomFichier;
     OpenAPI:= TOpenAPI.Create( NomFichier);
     _from_OpenAPI;
end;

procedure TfGenerateur_OpenAPI._from_OpenAPI;
   procedure Traite_Schema( _s: TSchema);
      procedure Traite_Properties;
      var
         pl: TProperties_List;
         p: TProperty;
      begin
           pl:= _s.Get_Properties_List;
           try
              for p in pl
              do
                begin
                m.Lines.Add( '     '+p.name+': '+p.sArray+p.typ);
                end;
           finally
                  FreeAndNil( pl);
                  end;
      end;
   begin
        Traite_Properties;
   end;
   procedure Traite_Schemas;
   var
      sl: TSchema_List;
      s: TSchema;
   begin
        sl:= OpenAPI.Get_Schemas_List;
        try
           for s in sl
           do
             begin
             m.Lines.Add( '  '+s.name);

             Traite_Schema( s);
             end;
           m.Lines.Add( 'Traite_Schemas terminé. '+IntToStr(sl.Count)+' schemas');
        finally
               FreeAndNil( sl);
               end;
   end;
begin
     m.Clear;
     if nil = OpenAPI then exit;

     m.Lines.Add( NomFichier);
//     Traite_Schemas;

     m.Lines.Add( 'Début de la génération ...');
     Generateur_de_code.Execute_OpenAPI( OpenAPI);
     m.Lines.Add( 'Génération terminée.');
end;

end.

