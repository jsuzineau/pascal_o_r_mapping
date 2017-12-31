//créé par Fichier/Nouveau/dialogue/Dialogue de conciliation
{*****************************************************************}
{                                                                 }
{     Bibliothèque de composants visuels Delphi                   }
{     Dialogue Erreur et réconciliation standard ClientDataSet    }
{                                                                 }
{     Copyright (c) 1998 Borland International                    }
{                                                                 }
{*****************************************************************}

{ Pour utiliser ce dialogue, vous devez ajouter un appel à HandleReconcileError dans
  le gestionnaire d'événement OnReconcileError de TClientDataSet. (voir les démos sur les ensembles
  de données client).  Après l'ajout de cette unité à votre projet, activez le dialogue
  Options du projet et retirez cette fiche de la liste
  des fiches auto-créées, sinon la compilation génèrera une erreur. }

unit ufReconcileError;

interface

uses
  SysUtils, Windows, Variants, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DB, DBClient, Provider, ExtCtrls;

const
  ActionStr: array[TReconcileAction] of string = ('Ignorer', 'Abandon', 'Fusion',
    'Correct', 'Annuler', 'Rafraîchir');
  ValueUpdateKindStr
  :
   array[TUpdateKind] of string
   = ('Valeur modifiée', 'Valeur insérée', 'Valeur supprimée');
  TypeUpdateKindStr
  :
   array[TUpdateKind] of string
   = ('Modification', 'Insertion', 'Suppression');
  SCaption = 'Erreur de mise à jour - %s';
  SUnchanged = '<Inchangé>';
  SBinary = '(Binaire)';
  SAdt = '(ADT)';
  SArray = '(Tableau)';
  SFieldName = 'Nom de champ';
  SOriginal = 'Valeur originale';
  SConflict = 'Valeur incompatible';
  SNoData = '<Aucun enregistrement>';
  SNew = 'Nouveau';

type
  TfReconcileError = class(TForm)
    UpdateData: TStringGrid;
    Panel1: TPanel;
    ConflictsOnly: TCheckBox;
    ChangedOnly: TCheckBox;
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    UpdateType: TLabel;
    Label3: TLabel;
    IconImage: TImage;
    ActionGroup: TRadioGroup;
    ErrorMsg: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateDataSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure DisplayFieldValues(Sender: TObject);
    procedure UpdateDataSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);
  private
    FDataSet: TDataSet;
    FError: EReconcileError;
    FUpdateKind: TUpdateKind;
    FDataFields: TList;
    FCurColIdx: Integer;
    FNewColIdx: Integer;
    FOldColIdx: Integer;
    procedure AdjustColumnWidths;
    procedure InitDataFields;
    procedure InitUpdateData(HasCurValues: Boolean);
    procedure InitReconcileActions;
    procedure SetFieldValues(DataSet: TDataSet);
  public
    constructor CreateForm(DataSet: TDataSet; UpdateKind: TUpdateKind;
      Error: EReconcileError);
  end;

function HandleReconcileError(DataSet: TDataSet;  UpdateKind: TUpdateKind;
  ReconcileError: EReconcileError): TReconcileAction;

implementation

{$R *.dfm}

type
  PFieldData = ^TFieldData;
  TFieldData = record
    Field: TField;
    NewValue: string;
    OldValue: string;
    CurValue: string;
    EditValue: string;
    Edited: Boolean;
  end;

{ méthodes publiques et privées }

function HandleReconcileError(DataSet: TDataSet; UpdateKind: TUpdateKind;
  ReconcileError: EReconcileError): TReconcileAction;
var
  UpdateForm: TfReconcileError;
begin
  UpdateForm := TfReconcileError.CreateForm(DataSet, UpdateKind, ReconcileError);
  with UpdateForm do
  try
    if ShowModal = mrOK then
    begin
      Result := TReconcileAction(ActionGroup.Items.Objects[ActionGroup.ItemIndex]);
      if Result = raCorrect then SetFieldValues(DataSet);
    end else
      Result := raAbort;
  finally
    Free;
  end;
end;

{ Routine permettant de convertir une valeur variant en chaîne.
  Gère les types de champs binaires et les valeurs de champs "vide" (Inchangé) }

function VarToString(V: Variant; DataType: TFieldType): string;
const
  BinaryDataTypes: set of TFieldType = [ftBytes, ftVarBytes, ftBlob,
    ftGraphic..ftCursor];
begin
  try
    if VarIsClear(V) then
      Result := SUnchanged
    else if DataType in BinaryDataTypes then
      Result := SBinary
    else if DataType in [ftAdt] then
      Result := SAdt
    else if DataType in [ftArray] then
      Result := SArray
    else
      Result := VarToStr(V);
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

{ TReconcileErrorForm }

constructor TfReconcileError.CreateForm(DataSet: TDataSet;
  UpdateKind: TUpdateKind; Error: EReconcileError);
begin
  FDataSet := DataSet;
  FUpdateKind := UpdateKind;
  FError := Error;
  inherited Create(Application);
end;

{ Crée une liste des champs de données de l'ensemble de données et stocke les valeurs chaîne
  associées à NewValue, OldValue et Curvalue dans les valeurs chaîne
  pour faciliter le changement d'affichage }

procedure TfReconcileError.InitDataFields;
var
  I: Integer;
  FD: PFieldData;
  V: Variant;
  HasCurValues: Boolean;
begin
  HasCurValues := False;
  for I := 0 to FDataSet.FieldCount - 1 do
  with FDataset.Fields[I] do
  begin
    if (FieldKind <> fkData) then Continue;
    FD := New(PFieldData);
    try
      FD.Field := FDataset.Fields[I];
      FD.Edited := False;
      if FUpdateKind <> ukDelete then
        FD.NewValue := VarToString(NewValue, DataType);
      V := CurValue;
      if not VarIsClear(V) then HasCurValues := True;
      FD.CurValue := VarToString(CurValue, DataType);
      if FUpdateKind <> ukInsert then
        FD.OldValue := VarToString(OldValue, DataType);
      FDataFields.Add(FD);
    except
      Dispose(FD);
      raise;
    end;
  end;
  InitUpdateData(HasCurValues);
end;

{ Initialise les indices de colonne et les titres de grille }

procedure TfReconcileError.InitUpdateData(HasCurValues: Boolean);
var
  FColCount: Integer;
begin
  FColCount := 1;
  UpdateData.ColCount := 4;
  UpdateData.Cells[0,0] := SFieldName;
  if FUpdateKind <> ukDelete then
  begin
    FNewColIdx := FColCount;
    Inc(FColCount);
    UpdateData.Cells[FNewColIdx,0] := ValueUpdateKindStr[FUpdateKind];
  end else
  begin
    FOldColIdx := FColCount;
    Inc(FColCount);
    UpdateData.Cells[FOldColIdx,0] := SOriginal;
  end;
  if HasCurValues then
  begin
    FCurColIdx := FColCount;
    Inc(FColCount);
    UpdateData.Cells[FCurColIdx,0] := SConflict;
  end;
  if FUpdateKind = ukModify then
  begin
    FOldColIdx := FColCount;
    Inc(FColCount);
    UpdateData.Cells[FOldColIdx,0] := SOriginal;
  end;
  UpdateData.ColCount := FColCount;
end;

{ Met à jour le groupe de bouton radio de réconciliation à partir des actions de réconciliation valides }

procedure TfReconcileError.InitReconcileActions;

  procedure AddAction(Action: TReconcileAction);
  begin
    ActionGroup.Items.AddObject(ActionStr[Action], TObject(Action));
  end;

begin
  AddAction(raSkip);
  AddAction(raCancel);
  AddAction(raCorrect);
  if FCurColIdx > 0 then
  begin
    AddAction(raRefresh);
    AddAction(raMerge);
  end;
  ActionGroup.ItemIndex := 0;
end;

{ Met à jour la grille à partir des options d'affichage en cours }

procedure TfReconcileError.DisplayFieldValues(Sender: TObject);
var
  I: Integer;
  CurRow: Integer;
  Action: TReconcileAction;
begin
  if not Visible then Exit;
  Action := TReconcileAction(ActionGroup.Items.Objects[ActionGroup.ItemIndex]);
  UpdateData.Col := 1;
  UpdateData.Row := 1;
  CurRow := 1;
  UpdateData.RowCount := 2;
  UpdateData.Cells[0, CurRow] := SNoData;
  for I := 1 to UpdateData.ColCount - 1 do
    UpdateData.Cells[I, CurRow] := '';
  for I := 0 to FDataFields.Count - 1 do
    with PFieldData(FDataFields[I])^ do
    begin
      if ConflictsOnly.Checked and (CurValue = SUnChanged) then Continue;
      if ChangedOnly.Checked and (NewValue = SUnChanged) then Continue;
      UpdateData.RowCount := CurRow + 1;
      UpdateData.Cells[0, CurRow] := Field.DisplayName;
      if FNewColIdx > 0 then
      begin
        case Action of
          raCancel, raRefresh:
            UpdateData.Cells[FNewColIdx, CurRow] := SUnChanged;
          raCorrect:
            if Edited then
              UpdateData.Cells[FNewColIdx, CurRow] := EditValue else
              UpdateData.Cells[FNewColIdx, CurRow] := NewValue;
          else
            UpdateData.Cells[FNewColIdx, CurRow] := NewValue;
        end;
        UpdateData.Objects[FNewColIdx, CurRow] := FDataFields[I];
      end;
      if FCurColIdx > 0 then
        UpdateData.Cells[FCurColIdx, CurRow] := CurValue;
      if FOldColIdx > 0 then
        if (Action in [raMerge, raRefresh]) and (CurValue <> SUnchanged) then
           UpdateData.Cells[FOldColIdx, CurRow] := CurValue else
           UpdateData.Cells[FOldColIdx, CurRow] := OldValue;
      Inc(CurRow);
    end;
  AdjustColumnWidths;
end;

{ Pour les champs modifiés par l'utilisateur, copier les modifications
  dans la propriété NewValue du champ associé }

procedure TfReconcileError.SetFieldValues(DataSet: TDataSet);
var
  I: Integer;
begin
  for I := 0 to FDataFields.Count - 1 do
    with PFieldData(FDataFields[I])^ do
      if Edited then Field.NewValue := EditValue;
end;

procedure TfReconcileError.AdjustColumnWidths;
var
  NewWidth, I: integer;
begin
  with UpdateData do
  begin
    NewWidth := (ClientWidth - ColWidths[0]) div (ColCount - 1);
    for I := 1 to ColCount - 1 do
      ColWidths[I] := NewWidth - 1;
  end;
end;

{ Gestionnaires d'événements }

procedure TfReconcileError.FormCreate(Sender: TObject);
begin
  if FDataSet = nil then Exit;
  FDataFields := TList.Create;
  InitDataFields;
  Caption := Format(SCaption, [FDataSet.Name]);
  UpdateType.Caption := TypeUpdateKindStr[FUpdateKind];
  ErrorMsg.Text := FError.Message;
  if FError.Context <> '' then
    ErrorMsg.Lines.Add(FError.Context);
  ConflictsOnly.Enabled := FCurColIdx > 0;
  ConflictsOnly.Checked := ConflictsOnly.Enabled;
  ChangedOnly.Enabled := FNewColIdx > 0;
  InitReconcileActions;
  UpdateData.DefaultRowHeight := UpdateData.Canvas.TextHeight('SWgjp') + 7; { Ne pas localiser }
end;

procedure TfReconcileError.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(FDataFields) then
  begin
    for I := 0 to FDataFields.Count - 1 do
      Dispose(PFieldData(FDataFields[I]));
    FDataFields.Destroy;
  end;
end;

{ Définir l'indicateur Edited dans la liste DataField et enregistrer la valeur }

procedure TfReconcileError.UpdateDataSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  PFieldData(UpdateData.Objects[ACol, ARow]).EditValue := Value;
  PFieldData(UpdateData.Objects[ACol, ARow]).Edited := True;
end;

{ Activer l'édition dans la grille si on se trouve dans la colonne NewValue et
  que l'action de réconciliation en cours est raCorrect }

procedure TfReconcileError.UpdateDataSelectCell(Sender: TObject; Col,
  Row: Integer; var CanSelect: Boolean);
begin
  if (Col = FNewColIdx) and
    (TReconcileAction(ActionGroup.Items.Objects[ActionGroup.ItemIndex]) = raCorrect) then
    UpdateData.Options := UpdateData.Options + [goEditing] else
    UpdateData.Options := UpdateData.Options - [goEditing];
end;

end.
