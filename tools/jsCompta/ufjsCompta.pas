unit ufjsCompta;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode objfpc}{$H+}

interface

uses
    uLog,
    uChamp,
    uChamps,
    uuStrings,
    uBatpro_StringList,

    udmDatabase,

    ublType_Tag,
    ublTag,
    upoolTag,
    udkTag_LABEL,
    udkTag_LABEL_od,
    udkWork_haTag_LABEL,
    udkWork_haTag_from_Description_LABEL,

    ublWork,
    upoolWork,
    udkWork,

    ublDevelopment,
    upoolDevelopment,
    udkDevelopment,

    ublCategorie,
    upoolCategorie,

    ublState,
    upoolState,

    upoolProject,

    uodWork_from_Period,

    ufAutomatic,
    ufTemps,
    ufProject,
    ufType_Tag,
    ufTag,
    ufTest_VirtualTreeView,
    ufAutomatic_VST,
    ufTest_neo4j,
    ufTULEAP, sqlite3conn,

    uHTTP_Interface,

  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Menus, ucChampsGrid,
  ucDockableScrollbox, ucChamp_DateTimePicker, ucChamp_Edit, ucChamp_Memo,
  ucChamp_Lookup_ComboBox, uDockable, dateutils,LCLIntf;

type

 { TfjsCompta }

 TfjsCompta
 =
  class(TForm)
   bBug: TButton;
   bPoint: TButton;
   bProject_to_Tag: TButton;
   bStart: TButton;
   bStop: TButton;
   bTemps: TButton;
   bTULEAP: TButton;
   bCategorie_to_Tag: TButton;
   bDescription_to_Tag: TButton;
   bAutomatic_VST: TButton;
   bNEO4J: TButton;
   bStopAndStart: TButton;
   bNew_Tag_Project_from_Selection: TButton;
   bNew_Tag_Client_from_Selection: TButton;
   bBeginning_From: TButton;
   bHTTP: TButton;
   bVST: TButton;
   ceBeginning: TChamp_Edit;
   ceEnd: TChamp_Edit;
   clkcbCategorie: TChamp_Lookup_ComboBox;
   clkcbState: TChamp_Lookup_ComboBox;
   cmDevelopment_Description: TChamp_Memo;
   cmSolution: TChamp_Memo;
   cmWork_Description: TChamp_Memo;
   dtpBeginning_From: TDateTimePicker;
   dsbWork_Tag: TDockableScrollbox;
   dsbDevelopment: TDockableScrollbox;
   dsbWork: TDockableScrollbox;
   dsbWork_Tag_from_Description: TDockableScrollbox;
   dsbTag: TDockableScrollbox;
   gbDescription: TGroupBox;
   gbSolution: TGroupBox;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   Label7: TLabel;
   Label8: TLabel;
   Label9: TLabel;
   miTag: TMenuItem;
   miType_Tag: TMenuItem;
   miAutomatic: TMenuItem;
   miProject: TMenuItem;
   miVoir: TMenuItem;
   mm: TMainMenu;
   Panel1: TPanel;
   Panel10: TPanel;
   Panel13: TPanel;
   Panel2: TPanel;
   Panel3: TPanel;
   Panel4: TPanel;
   Panel5: TPanel;
   Panel6: TPanel;
   Panel7: TPanel;
   Panel8: TPanel;
   Panel9: TPanel;
   pWork: TPanel;
   pDevelopment: TPanel;
   Splitter1: TSplitter;
   Splitter2: TSplitter;
   Splitter4: TSplitter;
   Splitter6: TSplitter;
   t: TTimer;
   procedure bAutomatic_VSTClick(Sender: TObject);
   procedure bBeginning_FromClick(Sender: TObject);
   procedure bBugClick(Sender: TObject);
   procedure bCategorie_to_TagClick(Sender: TObject);
   procedure bDescription_to_TagClick(Sender: TObject);
   procedure bHTTPClick(Sender: TObject);
   procedure bNEO4JClick(Sender: TObject);
   procedure bNew_Tag_Client_from_SelectionClick(Sender: TObject);
   procedure bNew_Tag_Project_from_SelectionClick(Sender: TObject);
   procedure bPointClick(Sender: TObject);
   procedure bProject_to_TagClick(Sender: TObject);
   procedure bStartClick(Sender: TObject);
   procedure bStopAndStartClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure bTempsClick(Sender: TObject);
   procedure bTULEAPClick(Sender: TObject);
   procedure bVSTClick(Sender: TObject);
   procedure dsbWorkSelect(Sender: TObject);
   procedure dsbDevelopmentSelect(Sender: TObject);
   procedure dsbWorkTraite_Message(_dk: TDockable; _iMessage: Integer);
   procedure dsbWork_TagSuppression(Sender: TObject);
   procedure dsbWork_Tag_from_DescriptionSuppression(Sender: TObject);
   procedure FormShow(Sender: TObject);
   procedure miAutomaticClick(Sender: TObject);
   procedure miProjectClick(Sender: TObject);
   procedure miTagClick(Sender: TObject);
   procedure miType_TagClick(Sender: TObject);
   procedure pDevelopmentClick(Sender: TObject);
   procedure tTimer(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( TheOwner: TComponent); override;
    destructor Destroy; override;
  //méthodes
  private
    procedure Traite_Beginning_From;
    procedure _from_pool;
  //Work
  private
    blWork : TblWork;
    procedure _from_Work;
  //Development
  private
    blDevelopment: TblDevelopment;
    procedure _from_Development;
  //HTTP
  private
    procedure HTTP;
  end;

var
 fjsCompta: TfjsCompta;

implementation

{$R *.lfm}

{ TfjsCompta }

constructor TfjsCompta.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);

     dmDatabase.Ouvre_db;

     Caption:= Caption+' - '+dmDatabase.jsDataConnexion.Base_sur;
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;

     dsbWork.Classe_dockable:= TdkWork;
     dsbWork.Classe_Elements:= TblWork;

     dsbDevelopment.Classe_dockable:= TdkDevelopment;
     dsbDevelopment.Classe_Elements:= TblDevelopment;

     dsbWork_Tag.Classe_dockable:= TdkWork_haTag_LABEL;
     dsbWork_Tag.Classe_Elements:= TblTag;

     dsbWork_Tag_from_Description.Classe_dockable:= TdkWork_haTag_from_Description_LABEL;
     dsbWork_Tag_from_Description.Classe_Elements:= TblTag;

     dsbTag.Classe_dockable:= TdkTag_LABEL_od;
     dsbTag.Classe_Elements:= TblTag;
     dsbTag.Tri:= poolTag.Tri;
     dsbTag.Filtre:= poolTag.hfTag;

     dtpBeginning_From.Date:= Now-30;
end;

destructor TfjsCompta.Destroy;
begin
     inherited Destroy;
end;

procedure TfjsCompta.FormShow(Sender: TObject);
begin
     t.Enabled:= True;
end;

procedure TfjsCompta.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     Traite_Beginning_From;
end;

procedure TfjsCompta.Traite_Beginning_From;
var
   D: TDateTime;
   slWork: TslWork;
begin
     D:= dtpBeginning_From.Date;

     slWork:= TslWork.Create( ClassName+'slWork');
     try
        //poolWork.ToutCharger();
        poolWork.Charge_Periode( D, Now, 0, slWork);
        poolWork.TrierFiltre;
        slWork.Charger_Tags;
     finally
            FreeAndNil( slWork);
            end;

     //poolDevelopment.ToutCharger();
     _from_pool;
end;

procedure TfjsCompta._from_pool;
begin
     dsbWork       .sl:= poolWork.slFiltre;
     dsbDevelopment.sl:= poolDevelopment.slFiltre;

     poolTag.ToutCharger;
     poolTag.TrierFiltre;
     dsbTag        .sl:= poolTag.slFiltre;

     dsbWork       .Goto_Dernier;
     dsbDevelopment.Goto_Premier;
end;

procedure TfjsCompta._from_Work;
begin
     Champs_Affecte( blWork,
                     [
                      ceBeginning,
                      ceEnd,
                      cmWork_Description
                     ]);
     blWork.haTag.Charge;
     dsbWork_Tag.sl:= blWork.haTag.sl;

     blWork.haTag_from_Description.Charge;
     dsbWork_Tag_from_Description.sl:= blWork.haTag_from_Description.sl;
end;

procedure TfjsCompta._from_Development;
begin
     Champs_Affecte( blDevelopment,
                          [
                          clkcbCategorie,
                          clkcbState,
                          cmDevelopment_Description,
                          cmSolution
                          ]);
end;

procedure TfjsCompta.miType_TagClick(Sender: TObject);
begin
     fType_Tag.Execute;
end;

procedure TfjsCompta.miTagClick(Sender: TObject);
begin
     fTag.Show;
end;

procedure TfjsCompta.miProjectClick(Sender: TObject);
begin
     fProject.Execute;
end;

procedure TfjsCompta.miAutomaticClick(Sender: TObject);
begin
     fAutomatic.Show;
end;

procedure TfjsCompta.pDevelopmentClick(Sender: TObject);
begin

end;

procedure TfjsCompta.bStartClick(Sender: TObject);
var
   bl: TblWork;
begin
     bl:= poolWork.Start( 0);
     _from_pool;
     dsbWork.Goto_bl( bl);
end;

procedure TfjsCompta.bStopClick(Sender: TObject);
begin
     if blWork = nil then exit;
     blWork.Stop;
     _from_Work;
end;

procedure TfjsCompta.bStopAndStartClick(Sender: TObject);
var
   bl: TblWork;
begin
     if Assigned( blWork)
     then
         blWork.Stop;

     bl:= poolWork.Start( 0);
     _from_pool;
     dsbWork.Goto_bl( bl);
end;

procedure TfjsCompta.bTempsClick(Sender: TObject);
begin
     fTemps.Show;
end;

procedure TfjsCompta.bVSTClick(Sender: TObject);
begin
     fTest_VirtualTreeView.Show;
end;

procedure TfjsCompta.bPointClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= poolDevelopment.Point( 0);
     _from_pool;
     dsbDevelopment.Goto_bl( bl);
end;

procedure TfjsCompta.bBugClick(Sender: TObject);
var
   bl: TblDevelopment;
begin
     bl:= poolDevelopment.Bug( 0);
     _from_pool;
     dsbDevelopment.Goto_bl( bl);
end;

procedure TfjsCompta.bAutomatic_VSTClick(Sender: TObject);
begin
     fAutomatic_VST.Show;
end;

procedure TfjsCompta.bBeginning_FromClick(Sender: TObject);
begin
     Traite_Beginning_From;
end;

procedure TfjsCompta.bProject_to_TagClick(Sender: TObject);
begin
     poolProject.To_Tag;
end;

procedure TfjsCompta.bCategorie_to_TagClick(Sender: TObject);
begin
     poolCategorie.To_Tag;
end;

procedure TfjsCompta.bDescription_to_TagClick(Sender: TObject);
begin
     poolWork.Tag_from_Description;
end;

procedure TfjsCompta.bHTTPClick(Sender: TObject);
begin
     HTTP;
end;

procedure TfjsCompta.bNEO4JClick(Sender: TObject);
begin
     fTest_neo4j.Show;
end;

procedure TfjsCompta.bNew_Tag_Client_from_SelectionClick(Sender: TObject);
begin
     poolTag.Assure( Type_Tag_id_Client, cmWork_Description.SelText);
     dsbTag.sl:= poolTag.slFiltre;
end;

procedure TfjsCompta.bNew_Tag_Project_from_SelectionClick(Sender: TObject);
begin
     poolTag.Assure( Type_Tag_id_Project, cmWork_Description.SelText);
     dsbTag.sl:= poolTag.slFiltre;
end;

procedure TfjsCompta.bTULEAPClick(Sender: TObject);
begin
     fTULEAP.Show;
end;

procedure TfjsCompta.dsbWorkSelect(Sender: TObject);
begin
     dsbWork .Get_bl( blWork );
     _from_Work ;
end;

procedure TfjsCompta.dsbDevelopmentSelect(Sender: TObject);
begin
     dsbDevelopment.Get_bl( blDevelopment);
     _from_Development;
end;

procedure TfjsCompta.dsbWorkTraite_Message( _dk: TDockable; _iMessage: Integer);
var
   dk: TdkWork;
   dk_bl: TblWork;
   cDescription: TChamp;
begin
     if blWork = nil                        then exit;
     if Affecte_( dk, TdkWork, _dk)         then exit;
     if Affecte_( dk_bl, TblWork, dk.Objet) then exit;

     if udkWork_Copy_to_current <> _iMessage then exit;
     Formate_Liste( blWork.Description, #13#10, dk_bl.Description);
     cDescription:= blWork.Champs.Champ['Description'];
     if nil = cDescription then exit;
     cDescription.Publie_Modifications;

end;

procedure TfjsCompta.dsbWork_TagSuppression(Sender: TObject);
var
   blTag: TblTag;
begin
     dsbWork_Tag.Get_bl( blTag);
     blWork.haTag.Supprime( blTag);
     blWork.haTag_from_Description.Ajoute( blTag);
     _from_Work;
end;

procedure TfjsCompta.dsbWork_Tag_from_DescriptionSuppression(Sender: TObject);
var
   blTag: TblTag;
begin
     dsbWork_Tag_from_Description.Get_bl( blTag);
     blWork.haTag_from_Description.Enleve( blTag);
     blWork.Tag( blTag);
     _from_Work;
end;

procedure Traite_Test_AUT;
var
   Repertoire: String;
   uri: String;
  procedure Traite_Racine;
  var
     NomFichier: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( 'index.html');
       if FileExists( NomFichier)
       then
           begin
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_HTML( S);
           Log.PrintLn( 'Envoi racine ');
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
  procedure Traite_Fichier;
  var
     NomFichier: String;
     Extension: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( uri);
       if FileExists( NomFichier)
       then
           begin
           Log.PrintLn( 'Envoi fichier '#13#10+uri);
           Extension:= LowerCase(ExtractFileExt(uri));
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_MIME_from_Extension( S, Extension);
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
begin
     Repertoire:= 'C:\_freepascal\Test_angular_ui_tree\';
     uri:= HTTP_Interface.uri;
          if '' = uri                                  then Traite_Racine
     else                                                   Traite_Fichier;
end;
procedure TfjsCompta.HTTP;
var
   HTTP_Interface_URL: String= '';
   procedure Ecrit_URL;
   var
      S: String;
   begin
        //HTTP_Interface.Init_from_ClassName();
        S:= HTTP_Interface.Init;
        Caption:= Caption + ' - web sur '+ S;
        HTTP_Interface_URL:= S;
   end;
begin
     if Assigned(HTTP_Interface.th) then exit;//http déjà en cours

     uHTTP_Interface.Assurer_http_PortMapper:= False;
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;
     //poolProject  .ToutCharger;

     HTTP_Interface.Racine:= '';
     HTTP_Interfaces.Register_pool( poolProject    );
     HTTP_Interfaces.Register_pool( poolWork       );
     HTTP_Interfaces.Register_pool( poolDevelopment);
     HTTP_Interfaces.Register_pool( poolCategorie  );
     HTTP_Interfaces.Register_pool( poolState      );
     //HTTP_Interface.Register_pool( poolAutomatic  ); à voir, conflit avec uhAutomatic_ATB
     HTTP_Interface.slP.Ajoute( 'Test_AUT/', @Traite_Test_AUT);

     //hAutomatic_ATB.Execute_SQL( 'select * from a_cht  where phase <> "0" limit 0,100');
     //hAutomatic_ATB.Execute_SQL( 'select * from Work limit 0,100');
     //hAutomatic_AUT.Execute_SQL( 'select * from Work limit 0,100');

     Ecrit_URL;
     //HTTP_Interface.Run( True);
     HTTP_Interface.Run( False);
     {
     function ThttpRequete_securise.HTTP_Init: String;
     begin
          hi.Init_from_ClassName( ClassName, Self, HTTP_Traite);

          Result:= hi.Init;
     end;
     procedure ThttpRequete_securise.Execute;
     begin
          Log.PrintLn( 'Ecoute sur: '+ HTTP_Init);
          hi.Run( False);
          Log.PrintLn('http_run terminé');
     end;
     }

     OpenURL( HTTP_Interface_URL);
end;

end.

