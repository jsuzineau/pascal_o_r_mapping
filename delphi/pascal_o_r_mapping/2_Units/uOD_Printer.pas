unit uOD_Printer;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    uOD_Forms,
    uOpenDocument,
    uOD_Temporaire,
    uOD_TextFieldsCreator,
    uODRE_Table,
    uOD_TextTableManager,
    uOOoStrings,
  {$IFDEF MSWINDOWS}
  Windows,{pour CopyFile}
  {$ELSE}
  fileutil,
  {$ENDIF}
  SysUtils, Classes, DB;

type
 TOD_Printer
 =
  class
  private
   D: TOpenDocument;
   OD_TextFieldsCreator: TOD_TextFieldsCreator;
   OD_TextTableManager: TOD_TextTableManager;
   procedure Ouvre( _NomFichier: String);
   procedure Ferme;
  public
    procedure AssureModele( NomFichierModele: String;
                            ParametresNoms: array of string;
                            Maitres: array of TDataset;
                            Details: array of TODRE_Table
                            );
    function Execute( NomFichierModele, sTitreEtat: String;
                      ParametresNoms,
                      ParametresValeurs: array of string;
                      Maitres     : array of TDataset;
                      Details     : array of TODRE_Table;
                      ReadOnly    : Boolean = False): String;
  end;

var
   OD_Printer: TOD_Printer= nil;

implementation

const
     s_Titre= 'OD_Printer_Titre';

{ TOD_Printer }

procedure TOD_Printer.Ouvre( _NomFichier: String);
begin
     D:= TOpenDocument.Create( _NomFichier);
     OD_TextFieldsCreator:= TOD_TextFieldsCreator.Create( D);
     OD_TextTableManager := TOD_TextTableManager .Create( D);
end;

procedure TOD_Printer.Ferme;
var
   Nom: String;
begin
     Nom:= D.Nom;
     D.Save;
     FreeAndNil( OD_TextTableManager );
     FreeAndNil( OD_TextFieldsCreator);
     FreeAndNil( D);
end;

procedure TOD_Printer.AssureModele( NomFichierModele: String;
                                    ParametresNoms: array of string;
                                    Maitres: array of TDataset;
                                    Details: array of TODRE_Table);
var
   I, Longueur: Integer;
   NouveauModele: Boolean;
begin
     NouveauModele:= not FileExists( NomFichierModele);


     if NouveauModele
     then
         uOD_Forms_ShowMessage(  'Création d''un document vide non gérée pour l''instant'#13#10
                      +'Veuillez créer un document vide nommé '+NomFichierModele);

     Ouvre( NomFichierModele);
     try
        //champ Titre
        OD_TextFieldsCreator.Execute_Modele( s_Titre, NouveauModele);

        //Paramètres
        Longueur:= Length( ParametresNoms);
        if Longueur <> 0
        then
            for I:= 0 to Longueur-1
            do
              OD_TextFieldsCreator.Execute_Modele( ParametresNoms[I],
                                                   NouveauModele);
        //champs du dataset maitre
        for I:= Low( Maitres) to High( Maitres)
        do
          OD_TextFieldsCreator.Execute_Modele( Maitres[I] , NouveauModele, True);

        //table du dataset détail
        for I:= Low( Details) to High( Details)
        do
          OD_TextTableManager.Execute_Modele( Details[I], NouveauModele);
     finally
            Ferme;
            end;
end;

function TOD_Printer.Execute( NomFichierModele, sTitreEtat: String;
                              ParametresNoms,
                              ParametresValeurs: array of string;
                              Maitres     : array of TDataset;
                              Details     : array of TODRE_Table;
                              ReadOnly    : Boolean = False): String;
var
   NomFichier: String;
   I, Longueur: Integer;
   F: Variant;
begin
     if ExtractFilePath( NomFichierModele) = ''
     then
         NomFichierModele:= ExtractFilePath( ParamStr(0))+ NomFichierModele;

     Result:= '';
     if not FileExists( NomFichierModele)
     then
         begin
         Modele_inexistant( NomFichierModele);
         exit;
         end;

     NomFichier:= OD_Temporaire.Nouveau_ODT( 'OD_Printer');
     CopyFile( PChar(NomFichierModele), PChar( NomFichier), False);

     {$IFNDEF FPC}
     if not FileExists( NomFichier) //2015/01/27: temporisation éventuelle
     then                           //ajoutée suite au message d'erreur
         Sleep( 10000);             //rencontré chez Kieffer sur Windows 7 et 8
     {$ENDIF}

     Ouvre( NomFichier);
     try
        D.Set_Property( D.Get_xmlContent_TEXT,'text:use-soft-page-breaks','true');

        //champ Titre
        OD_TextFieldsCreator.Execute( s_Titre, sTitreEtat);

        //Paramètres
        Longueur:= Length( ParametresNoms);
        if Longueur <> 0
        then
            for I:= 0 to Longueur-1
            do
              OD_TextFieldsCreator.Execute( ParametresNoms[I], ParametresValeurs[I]);

        //champs du dataset maitre
        for I:= Low( Maitres) to High( Maitres)
        do
          OD_TextFieldsCreator.Execute( Maitres[ I], True);

        //table du dataset détail
        for I:= Low( Details) to High( Details)
        do
          OD_TextTableManager.Remplit( Details[I]);

        D.Freeze_fields;
        //D.Delete_unused_styles;
     finally
            Ferme;
            end;
     Result:= NomFichier;
end;


initialization
              OD_Printer:= TOD_Printer.Create;
finalization
              FreeAndNil( OD_Printer);
end.
