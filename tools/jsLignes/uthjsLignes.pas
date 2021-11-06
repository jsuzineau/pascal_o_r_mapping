unit uthjsLignes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
    Classes, ComCtrls;

type
    TthjsLignes
    =
     class(TThread)
     public
       constructor Create(aRootPath: String; _Exclus: String);
       destructor Destroy; override;
     protected
       RootPath: String;
       Node, NewNode: TTreeNode;
       Libelle: String;
       Exclus: TStringList;
       procedure Execute; override;
       function TraiteRepertoire(Parent: TTreeNode; Path: String): Int64;
       procedure PrepareLibelle(Taille: Int64; NomFichier: String; Exclu: Boolean);
       procedure DoAddNode;
       procedure DoChangeNodeText;
     end;

var
   thjsLignes: TthjsLignes;
   //FinLigne: PChar= #13#10;
   FinLigne: PChar= LineEnding;
   NbLignes_Pages: Integer= 150;

implementation

uses
    ufjsLignes, SysUtils;
{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure thjsLignes.UpdateCaption;
    begin
      Form1.Caption := 'Mise à jour dans un thread';
    end; }

{ thjsLignes }

constructor TthjsLignes.Create( aRootPath: String; _Exclus: String);
begin
     RootPath:= aRootPath;
     Exclus:= TStringList.Create;
     Exclus.Text:= _Exclus;
     inherited Create( False);
end;

destructor TthjsLignes.Destroy;
begin
     Exclus.Free;
     inherited;
end;

procedure TthjsLignes.DoAddNode;
begin
     NewNode:= fjsLignes.Tree.Items.AddChild( Node, Libelle);
end;

procedure TthjsLignes.DoChangeNodeText;
begin
     Node.Text:= Libelle;
end;

procedure TthjsLignes.PrepareLibelle(Taille: Int64; NomFichier: String; Exclu: Boolean);
var
   Pages: Extended;
begin
     Pages:= Taille / NbLignes_Pages;
     Libelle:= Format('%.6d  %7.2f pages, %6d lignes, %s',[Taille, Pages,Taille,NomFichier]);
     if Exclu
     then
         Libelle:= '      ('+Libelle+')';
end;

function NombreLignes( Path, NomFichier: String): Integer;
var
   FileName: String;
   F: File;
   TailleF: Integer;
   LS: Integer;
   S: String;
   I: Integer;
begin
     Result:= 0;
     try
        FileName:= Path+PathDelim+NomFichier;
        AssignFile( F, FileName);
        FileMode:= 0;
        Reset( F, 1);
        TailleF:= FileSize(F);
        LS:= TailleF+1;
        SetLength( S, LS);
        BlockRead( F, S[1], TailleF);
        CloseFile( F);
        S[ LS]:= #0;

        Result:= 1;
        I:= 1;
        while I <= LS
        do
          begin
          case S[I]
          of
            #13:
              begin
              Inc(Result);
              if (I < LS) and (#10 = S[I+1]) then Inc(I);
              end;
            #10:
              Inc(Result);
            end;
          Inc(I);
          end;

     except
           on E: Exception
           do
             begin
             end;
           end;
end;

function TthjsLignes.TraiteRepertoire(Parent: TTreeNode; Path: String): Int64;
var
   SearchRec: TSearchRec;
   Courant: TTreeNode;
   NomFichier, NomComplet: String;
   Taille: Int64;
   NomMAJ, Ext: String;
   Exclu: Boolean;
   procedure CreeNode( TailleNode: Int64);
   begin
        Taille:= TailleNode;

        Node:= Parent;
        PrepareLibelle( Taille, NomFichier, Exclu);
        Synchronize( DoAddNode);
        Courant:= NewNode;
        Courant.Data:= StrNew( PChar( NomComplet));//pas de destructeur pour l'instant
   end;
begin
     Result:= 0;
     if FindFirst( Path+PathDelim+{$ifdef unix}'*'{$else}'*.*'{$endif}, faAnyFile, SearchRec) = 0
     then
         repeat
               NomFichier:= SearchRec.Name;
               NomComplet:= Path+PathDelim+NomFichier;
               NomMAJ:= UpperCase( NomFichier);
               Ext:= ExtractFileExt( NomMAJ);
               Exclu:= Exclus.IndexOf( NomComplet) >= 0;

               if SearchRec.Attr and faDirectory = 0
               then
                   if (Ext = '.PAS') or (Ext = '.DPR') or (Ext = '.PP' ) or (Ext = '.INC') or
                      (Ext = '.ASP') or (Ext = '.PHP') or (Ext = '.4GL') or (Ext = '.PER') or
                      (Ext = '.JS' ) or (Ext = '.TS' ) or (Ext = '.CSS') or (Ext = '.CS') or
                      (Ext = '.HTML') or (Ext = '.HTM')
                   then
                       CreeNode( NombreLignes(Path, NomFichier))
                   else
                       Taille:= 0
               else
                   begin
                   CreeNode( 0);
                   if (NomFichier <> '.') and (NomFichier <> '..')
                   then
                       begin
                       Taille:= TraiteRepertoire( Courant, NomComplet);
                       Node:= Courant;
                       PrepareLibelle( Taille, NomFichier, Exclu);
                       Synchronize( DoChangeNodeText);
                       end;
                   end;
               if not Exclu
               then
                   Inc( Result, Taille);
         until FindNext( SearchRec) <> 0;
     FindClose( SearchRec);
     Parent.AlphaSort;
end;


procedure TthjsLignes.Execute;
var
   Parent: TTreeNode;
   Taille: Int64;
begin
     { Placez le code du thread ici}
     Node:= nil;
     Libelle:= RootPath;
     Synchronize( DoAddNode);
     Parent:= NewNode;
     Taille:= TraiteRepertoire( Parent, RootPath);
     Node:= Parent;
     PrepareLibelle( Taille, RootPath, False);
     Synchronize( DoChangeNodeText);
     Parent.AlphaSort;
     FreeOnTerminate:= True;
     if Self = thjsLignes
     then
         thjsLignes:= nil;
end;

initialization
              thjsLignes:= nil;
end.


/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/01_Batpro_Composants/2_source/Dialer
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/01_Batpro_Composants/07_FreeWare
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/02_Batpro_Formes/01_source/pucDico/suBatpro_Dico
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/06_Batpro_Dico
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/15_TurboSyncD7Full
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/25_Batpro_Sauvegarde/08_sources_externes
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/39_GED/04_StarUML
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/48_site_web
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/sources_externes
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/LGPL/OOoDelphiReportEngine/sources_externes
/home/jean/01_Projets/06_adibat/01_delphi/2010_delphi/55_php
