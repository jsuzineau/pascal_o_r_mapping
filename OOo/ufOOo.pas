unit ufOOo;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
  uClean,
  uGED,
  uOOo,
  uOD,
  udmxG3_UTI,
  ufpBas,
  ufMot_de_passe,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, FileCtrl, Menus,
  Spin;

type
 TCas_personnalisable
 =
  (
   cp_np,
   cp_p,
   cp_tous
  );

 TfOOo
 =
  class(TfpBas)
    pModeles: TPanel;
    lModele: TLabel;
    bVers_GED: TButton;
    pListesModeles: TPanel;
    Splitter: TSplitter;
    gbModeles_np: TGroupBox;
    flbModeles_np: TFileListBox;
    gbModeles: TGroupBox;
    flbModeles: TFileListBox;
    miOD: TMenuItem;
    gbImprimer: TGroupBox;
    bImprimer: TBitBtn;
    seNbExemplaires: TSpinEdit;
    lExemplaires: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
    procedure bVers_GEDClick(Sender: TObject);
    procedure flbModeles_npClick(Sender: TObject);
    procedure aValidationExecute(Sender: TObject);
    procedure flbModelesClick(Sender: TObject);
    procedure miODClick(Sender: TObject);
  //Méthodes
  private
   Cas_personnalisable: TCas_personnalisable;
   procedure Dimensionne_flb;
  public
    function Execute: Boolean; override;
  //parametres
  protected
    OpenDocument: Boolean;
    OOo: TOOo;
    OD: TOD;
  //Gestion de l'exécution
  protected
    procedure Parametres_from_; override;
    procedure Action( _Action: String); override;
  //Gestion du nom de fichier du modèle
  private
    From_flb_running: Boolean;
    procedure From_flb( _flb, _flb_nul: TFileListBox);
    procedure Assure_NomFichier_Modele;
  protected
    NomFichier_Modele : String;
  //Type d'appel
  protected
    Appel_depuis_Batpro6: Boolean;
  end;

implementation

{$R *.dfm}

{ TfOOo }

procedure TfOOo.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     OOo:= nil;
     OD:= nil;
     OpenDocument:= False;
     From_flb_running:= False;
     flbModeles_np.OnClick:= flbModeles_npClick;
     flbModeles   .OnClick:= flbModelesClick;
     Appel_depuis_Batpro6:= False;
end;

function TfOOo.Execute: Boolean;
begin
     Dimensionne_flb;

     lModele.Caption:= ExtractFilename( NomFichier_Modele);
     Result:= inherited Execute;
end;

procedure TfOOo.Dimensionne_flb;
var
   H: Integer;
   np_count, p_count, Total_count: Integer;
begin
     flbModeles_np.FileName:= OOo.Masque_Modeles_np;
     flbModeles_np.Update;
     flbModeles.FileName:= OOo.Masque_Modeles;
     flbModeles.Update;

          if flbModeles.Count = 0    then Cas_personnalisable:= cp_np
     else if flbModeles_np.Count = 0 then Cas_personnalisable:= cp_p
     else                                 Cas_personnalisable:= cp_tous;

     case Cas_personnalisable
     of
       cp_np:
         begin
         gbModeles_np.Visible:= True;
         gbModeles_np.Align  := alClient;

         Splitter    .Visible:= False;

         gbModeles   .Visible:= False;
         end;
       cp_p:
         begin
         gbModeles_np.Visible:= False;

         Splitter    .Visible:= False;

         gbModeles   .Visible:= True;
         gbModeles   .Align:= alClient;
         end
       else
         begin
         gbModeles_np.Visible:= True;
         gbModeles_np.Align:= alLeft;
         gbModeles_np.Width:= 185;

         Splitter.Visible:= True;
         Splitter.Left:= gbModeles_np.Left+gbModeles_np.Width+1;
         Splitter.Width:= 3;

         gbModeles   .Visible:= True;
         gbModeles   .Align:= alClient;
         end;
       end;
end;

procedure TfOOo.Assure_NomFichier_Modele;
var
   flb: TFileListBox;
begin
     if FileExists( NomFichier_Modele) then exit;

     case Cas_personnalisable
     of
       cp_np  : flb:= flbModeles_np;
       cp_p   : flb:= flbModeles;
       cp_tous: flb:= flbModeles_np;
       else     flb:= flbModeles;
       end;
     if flb.ItemIndex = -1
     then
         begin
         flb.ItemIndex:= 0;
         if Assigned( flb.OnClick)
         then
             flb.OnClick( nil);
         end;
end;

procedure TfOOo.From_flb( _flb, _flb_nul: TFileListBox);
begin
     if From_flb_running then exit;

     try
        From_flb_running:= True;

        NomFichier_Modele:= _flb.FileName;
        lModele.Caption:= ExtractFilename( NomFichier_Modele);
        if Assigned( OD)
        then
            OD .FNomFichier_Modele:= NomFichier_Modele;
        if Assigned( OOo)
        then
            OOo.FNomFichier_Modele:= NomFichier_Modele;

        _flb_nul.ItemIndex:= -1;

     finally
            From_flb_running:= False;
            end;
end;

procedure TfOOo.flbModeles_npClick(Sender: TObject);
begin
     From_flb( flbModeles_np, flbModeles);
end;

procedure TfOOo.flbModelesClick(Sender: TObject);
begin
     From_flb( flbModeles, flbModeles_np);
end;

procedure TfOOo.Parametres_from_;
begin
     inherited;
     Assure_NomFichier_Modele;
end;

procedure TfOOo.Action( _Action: String);
begin
     inherited;
     if OpenDocument
     then
         OD.Action( _Action)
     else
         OOo.Action( _Action);
end;

procedure TfOOo.aValidationExecute(Sender: TObject);
begin
     inherited;
     Action( 'V');
     if Appel_depuis_Batpro6
     then
         ModalResult:= mrOk
     else
         ModalResult:= mrNone;
end;

procedure TfOOo.bImprimerClick(Sender: TObject);
var
   I: Integer;
begin
     for I:= 1 to seNbExemplaires.Value
     do
       Action( 'I');
end;

procedure TfOOo.bVers_GEDClick(Sender: TObject);
begin
     if GED.not_Active then exit;

     Action( 'G');
end;

procedure TfOOo.miODClick(Sender: TObject);
begin
     with miOD do Checked:= not Checked;
     OpenDocument:= miOD.Checked;
end;

end.

