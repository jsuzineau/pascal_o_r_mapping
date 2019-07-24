unit uOD_Patch;

interface

uses
    uOpenDocument,
    uOD_TextFieldsCreator,
    uOD_Error,
  SysUtils, Classes, Types;

type
 Tprocedure_OD_Patch_CallBack= procedure ( _D: TOpenDocument) of object;
 TOD_Patch
 =
  class
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Callback sur une série de documents
  public
    procedure Execute( _Masque_Nom_Fichier: String;
                       _CallBack: Tprocedure_OD_Patch_CallBack);
  //Chercher/Remplacer sur une série de documents avec callback pour jauge de progression
  private
    Search_and_Replace_CallBack  : Tprocedure_OD_Patch_CallBack;
    Search_and_Replace_Search    ,
    Search_and_Replace_Replace_by: TStringDynArray;
    Search_and_Replace_KeepValue: Boolean;
    procedure OpenDocument_Search_and_Replace( _D: TOpenDocument);
  public
    //pour un préfixe de nom de champ
    procedure Search_and_Replace( _D: TOpenDocument;
                                  _Search, _Replace_by: TStringDynArray;
                                  _CallBack: Tprocedure_OD_Patch_CallBack;
                                  _KeepValue: Boolean= False); overload;
    procedure Search_and_Replace( _Masque_Nom_Fichier: String;
                                  _Search, _Replace_by: TStringDynArray;
                                  _CallBack: Tprocedure_OD_Patch_CallBack;
                                  _KeepValue: Boolean= False); overload;
    //pour un nom de champ
    procedure Search_and_Replace_FieldName( _D: TOpenDocument;
                                            _Prefixe,
                                            _Old_DisplayLabel,
                                            _New_DisplayLabel: String;
                                            _CallBack: Tprocedure_OD_Patch_CallBack;
                                            _KeepValue: Boolean= False); overload;
    procedure Search_and_Replace_FieldName( _Masque_Nom_Fichier: String;
                                            _Prefixe,
                                            _Old_DisplayLabel,
                                            _New_DisplayLabel: String;
                                            _CallBack: Tprocedure_OD_Patch_CallBack;
                                            _KeepValue: Boolean= False); overload;
  //Chercher/Remplacer dans une valeur de champ
  //sur une série de documents avec callback pour jauge de progression
  private
    Search_and_Replace_Value_CallBack  : Tprocedure_OD_Patch_CallBack;
    Search_and_Replace_Value_DisplayLabel: String;
    Search_and_Replace_Value_Search    ,
    Search_and_Replace_Value_Replace_by: TStringDynArray;
    Search_and_Replace_Value_IgnoreCase: Boolean;
    procedure OpenDocument_Search_and_Replace_Value( _D: TOpenDocument);
  public
    procedure Search_and_Replace_Value( _D: TOpenDocument;
                                        _DisplayLabel: String;
                                        _Search, _Replace_by: TStringDynArray;
                                        _CallBack: Tprocedure_OD_Patch_CallBack=nil;
                                        _IgnoreCase: Boolean= True); overload;
    procedure Search_and_Replace_Value( _D: TOpenDocument;
                                        _DisplayLabel: String;
                                        _Search, _Replace_by: String;
                                        _CallBack: Tprocedure_OD_Patch_CallBack=nil;
                                        _IgnoreCase: Boolean= True); overload;
    procedure Search_and_Replace_Value( _Masque_Nom_Fichier: String;
                                        _DisplayLabel: String;
                                        _Search, _Replace_by: TStringDynArray;
                                        _CallBack: Tprocedure_OD_Patch_CallBack=nil;
                                        _IgnoreCase: Boolean= True); overload;
    procedure Search_and_Replace_Value( _Masque_Nom_Fichier: String;
                                  _DisplayLabel: String;
                                  _Search, _Replace_by: String;
                                  _CallBack: Tprocedure_OD_Patch_CallBack=nil;
                                  _IgnoreCase: Boolean= True); overload;
  end;

function OD_Patch: TOD_Patch;

implementation

var
   FOD_Patch: TOD_Patch= nil;

function OD_Patch: TOD_Patch;
begin
     if FOD_Patch = nil
     then
         FOD_Patch:= TOD_Patch.Create;

     Result:= FOD_Patch;
end;


{ TOD_Patch }

constructor TOD_Patch.Create;
begin

end;

destructor TOD_Patch.Destroy;
begin

  inherited;
end;

procedure TOD_Patch.Execute( _Masque_Nom_Fichier: String;
                             _CallBack: Tprocedure_OD_Patch_CallBack);
var
   Repertoire: String;
   F: TSearchRec;
   NomFichier: String;
   D: TOpenDocument;
   procedure Do_Callback;
   begin
        if not Assigned( _CallBack) then exit;

        _CallBack( D)
   end;
begin
     Repertoire:= ExtractFilePath( _Masque_Nom_Fichier);
     if 0=FindFirst( _Masque_Nom_Fichier, faAnyFile, F)
     then
         begin
         repeat
               if (F.Attr and faDirectory) <> 0 then continue;

               NomFichier:= Repertoire+F.Name;

               D:= TOpenDocument.Create( NomFichier);
               try
                  Do_Callback;
                  D.Save;
               finally
                      FreeAndNil( D);
                      end;
         until FindNext( F) <> 0;
         FindClose( F);
         end;
end;

procedure TOD_Patch.Search_and_Replace( _D: TOpenDocument;
                                        _Search,
                                        _Replace_by: TStringDynArray;
                                        _CallBack: Tprocedure_OD_Patch_CallBack;
                                        _KeepValue: Boolean);
   procedure Do_CallBack;
   begin
        if not Assigned( _CallBack) then exit;

        _CallBack( _D);
   end;
   procedure Traite;
   var
      OD_TextFieldsCreator: TOD_TextFieldsCreator;
   begin
        if _Search = nil then exit;

        OD_TextFieldsCreator:= TOD_TextFieldsCreator.Create( _D);
        try
           OD_TextFieldsCreator.Search_and_Replace( _Search, _Replace_by, _KeepValue);
        finally
               FreeAndNil( OD_TextFieldsCreator);
               end;
   end;
begin
     Do_CallBack;
     Traite;
end;

procedure TOD_Patch.Search_and_Replace_FieldName( _D: TOpenDocument;
                                                  _Prefixe,
                                                  _Old_DisplayLabel,
                                                  _New_DisplayLabel: String;
                                                  _CallBack: Tprocedure_OD_Patch_CallBack;
                                                  _KeepValue: Boolean);
var
   Old_FieldName, New_FieldName: String;
   Search, Replace_by: TStringDynArray;
   function T( _DisplayLabel: String): String;
   begin
        Result
        :=
            _Prefixe
          + '_'
          + TOD_TextFieldsCreator.OD_FieldName_from_DisplayLabel(_DisplayLabel);

   end;
begin
     SetLength( Search    , 1);
     SetLength( Replace_by, 1);

     Search    [0]:= T( _Old_DisplayLabel);
     Replace_by[0]:= T( _New_DisplayLabel);

     Search_and_Replace( _D,
                         Search, Replace_by,
                         _CallBack,
                         _KeepValue);
end;

procedure TOD_Patch.OpenDocument_Search_and_Replace( _D: TOpenDocument);
begin
     Search_and_Replace( _D,
                         Search_and_Replace_Search    ,
                         Search_and_Replace_Replace_by,
                         Search_and_Replace_CallBack  ,
                         Search_and_Replace_KeepValue);
end;

procedure TOD_Patch.Search_and_Replace_Value( _D: TOpenDocument;
                                              _DisplayLabel: String;
                                              _Search, _Replace_by: TStringDynArray;
                                              _CallBack: Tprocedure_OD_Patch_CallBack;
                                              _IgnoreCase: Boolean);
   procedure Do_CallBack;
   begin
        if not Assigned( _CallBack) then exit;

        _CallBack( _D);
   end;
   procedure Traite;
   var
      OD_TextFieldsCreator: TOD_TextFieldsCreator;
   begin
        if _Search = nil then exit;

        OD_TextFieldsCreator:= TOD_TextFieldsCreator.Create( _D);
        try
           OD_TextFieldsCreator.Search_and_Replace_Value( _DisplayLabel,
                                                          _Search    ,
                                                          _Replace_by,
                                                          _IgnoreCase);
        finally
               FreeAndNil( OD_TextFieldsCreator);
               end;
   end;
begin
     Do_CallBack;
     Traite;
end;

procedure TOD_Patch.Search_and_Replace_Value( _D: TOpenDocument;
                                              _DisplayLabel,
                                              _Search,
                                              _Replace_by: String;
                                              _CallBack: Tprocedure_OD_Patch_CallBack;
                                              _IgnoreCase: Boolean);
var
   Search, Replace_by: TStringDynArray;
begin
     SetLength( Search    , 1);
     SetLength( Replace_by, 1);

     Search    [0]:= _Search;
     Replace_by[0]:= _Replace_by;

     Search_and_Replace_Value( _D,
                               _DisplayLabel,
                               Search, Replace_by,
                               _CallBack, _IgnoreCase);
end;

procedure TOD_Patch.OpenDocument_Search_and_Replace_Value( _D: TOpenDocument);
begin
     Search_and_Replace_Value( _D,
                               Search_and_Replace_Value_DisplayLabel,
                               Search_and_Replace_Value_Search    ,
                               Search_and_Replace_Value_Replace_by,
                               Search_and_Replace_Value_CallBack,
                               Search_and_Replace_Value_IgnoreCase);

end;

procedure TOD_Patch.Search_and_Replace( _Masque_Nom_Fichier: String;
                                        _Search, _Replace_by: TStringDynArray;
                                        _CallBack: Tprocedure_OD_Patch_CallBack;
                                        _KeepValue: Boolean= False);
begin
     Search_and_Replace_CallBack  := _CallBack  ;
     Search_and_Replace_Search    := _Search    ;
     Search_and_Replace_Replace_by:= _Replace_by;
     Search_and_Replace_KeepValue := _KeepValue ;
     if     Length( Search_and_Replace_Search    )
         <> Length( Search_and_Replace_Replace_by)
     then
         begin
         OD_Error.Execute(  'Erreur à signaler au développeur: TOD_Patch.Search_and_Replace:'#13#10
                           +'Length( Search_and_Replace_Search    )='+IntToStr(Length( Search_and_Replace_Search    ))+#13#10
                           +'Length( Search_and_Replace_Replace_by)='+IntToStr(Length( Search_and_Replace_Replace_by)));
         exit;
         end;
     try
        Execute( _Masque_Nom_Fichier, OpenDocument_Search_and_Replace);
     finally
            Search_and_Replace_CallBack  := nil;
            Search_and_Replace_Search    := nil;
            Search_and_Replace_Replace_by:= nil;
            end;
end;

procedure TOD_Patch.Search_and_Replace_FieldName( _Masque_Nom_Fichier,
                                                  _Prefixe,
                                                  _Old_DisplayLabel,
                                                  _New_DisplayLabel: String;
                                                  _CallBack: Tprocedure_OD_Patch_CallBack;
                                                  _KeepValue: Boolean= False);
var
   Old_FieldName, New_FieldName: String;
   Search, Replace_by: TStringDynArray;
   function T( _DisplayLabel: String): String;
   begin
        Result
        :=
            _Prefixe
          + '_'
          + TOD_TextFieldsCreator.OD_FieldName_from_DisplayLabel(_DisplayLabel);

   end;
begin
     SetLength( Search    , 1);
     SetLength( Replace_by, 1);

     Search    [0]:= T( _Old_DisplayLabel);
     Replace_by[0]:= T( _New_DisplayLabel);

     Search_and_Replace( _Masque_Nom_Fichier,
                         Search, Replace_by,
                         _CallBack,
                         _KeepValue);
end;

procedure TOD_Patch.Search_and_Replace_Value( _Masque_Nom_Fichier,
                                              _DisplayLabel: String;
                                              _Search,
                                              _Replace_by: TStringDynArray;
                                              _CallBack: Tprocedure_OD_Patch_CallBack= nil;
                                              _IgnoreCase: Boolean= True);
begin
     Search_and_Replace_Value_CallBack  := _CallBack  ;
     Search_and_Replace_Value_DisplayLabel:= _DisplayLabel  ;
     Search_and_Replace_Value_Search    := _Search    ;
     Search_and_Replace_Value_Replace_by:= _Replace_by;
     Search_and_Replace_Value_IgnoreCase:= _IgnoreCase;
     if     Length( Search_and_Replace_Value_Search    )
         <> Length( Search_and_Replace_Value_Replace_by)
     then
         begin
         OD_Error.Execute(  'Erreur à signaler au développeur: TOD_Patch.Search_and_Replace_Value:'#13#10
                           +'Length( Search_and_Replace_Value_Search    )='+IntToStr(Length( Search_and_Replace_Value_Search    ))+#13#10
                           +'Length( Search_and_Replace_Value_Replace_by)='+IntToStr(Length( Search_and_Replace_Value_Replace_by)));
         exit;
         end;
     try
        Execute( _Masque_Nom_Fichier, OpenDocument_Search_and_Replace_Value);
     finally
            Search_and_Replace_Value_CallBack  := nil;
            Search_and_Replace_Value_Search    := nil;
            Search_and_Replace_Value_Replace_by:= nil;
            end;
end;

procedure TOD_Patch.Search_and_Replace_Value( _Masque_Nom_Fichier,
                                              _DisplayLabel,
                                              _Search, _Replace_by: String;
                                              _CallBack: Tprocedure_OD_Patch_CallBack;
                                              _IgnoreCase: Boolean);
var
   Search, Replace_by: TStringDynArray;
begin
     SetLength( Search    , 1);
     SetLength( Replace_by, 1);

     Search    [0]:= _Search;
     Replace_by[0]:= _Replace_by;

     Search_and_Replace_Value( _Masque_Nom_Fichier,
                               _DisplayLabel,
                               Search,
                               Replace_by,
                               _CallBack,
                               _IgnoreCase);
end;

initialization

finalization
            FreeAndNil( FOD_Patch);
end.
