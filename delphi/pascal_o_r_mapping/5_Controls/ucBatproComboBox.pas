unit ucBatproComboBox;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
    FMX.StdCtrls, DB, FMX.ListBox;

const
     Separateur_par_defaut= ' | ';

type
 TBatproComboBox_Line
 =
  class
  Cle, Libelle: String;
  end;

 TBatproComboBox
 =
  class(TComboBox)
  private
    { Déclarations privées }
    FDataSource: TDataSource;
    FKeyField  : String;
    FLabelField: String;
    //FDataLink: TFieldDataLink;
    FIsNull: Boolean;
    FSeparateur: String;
    FDisplayKey: Boolean;
    bLabel: Boolean;
    Chaine_Nulle: String;
    procedure ActiveChange(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure SetDataSource(Value: TDataSource);
    procedure SetKeyField(const Value: string);
    procedure SetLabelField(const Value: string);
    procedure From_Datasource;
    procedure To_Datasource;
    procedure SetIsNull(Value: Boolean);
  protected
    { Déclarations protégées }
    procedure Change; //override;
    procedure KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState); override;
    {
    procedure ComboWndProc( var Message: TMessage; ComboWnd: HWnd;
                            ComboProc: Pointer); override;
    }
    procedure Select; //override;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Vide;
    function KeyValue: String;
    function GotoKey(Value: String): Boolean;
  published
    { Déclarations publiées }
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property KeyField  : String      read FKeyField   write SetKeyField  ;
    property LabelField: String      read FLabelField write SetLabelField;
    property IsNull    : Boolean     read FIsNull     write SetIsNull    ;
    property Separateur: String      read FSeparateur write FSeparateur  ;
    property DisplayKey: Boolean     read FDisplayKey write FDisplayKey  ;
  end;

procedure Register;

implementation

uses
    uClean,
    u_sys_,
    uuStrings;

procedure Register;
begin
     RegisterComponents('Batpro', [TBatproComboBox]);
end;

constructor TBatproComboBox.Create( AOwner: TComponent);
begin
     FSeparateur:= Separateur_par_defaut;

     inherited Create( AOwner);

     {
     FDataLink:= TFieldDataLink.Create;
     FDataLink.Control := Self;
     FDataLink.OnActiveChange:= ActiveChange;
     FDataLink.OnDataChange  := DataChange  ;
     }
     FIsNull:= True;

     FDisplayKey:= False;
     bLabel:= False;
end;

destructor TBatproComboBox.Destroy;
begin
     //Free_nil( FDataLink);
     inherited;
end;

procedure TBatproComboBox.SetDataSource(Value: TDataSource);
begin
     {
     if not (FDataLink.DataSourceFixed and (csLoading in ComponentState))
     then
         begin
         FDataSource:= Value;
         FDataLink.DataSource:= Value;
         end;
     if Value <> nil
     then
         Value.FreeNotification( Self);
     }
end;

procedure TBatproComboBox.SetKeyField(const Value: string);
begin
     FKeyField:= Value;
     //FDataLink.FieldName:= Value;
end;

procedure TBatproComboBox.SetLabelField(const Value: string);
begin
     FLabelField:= Value;
     bLabel:= LabelField <> sys_Vide;
end;

procedure TBatproComboBox.From_Datasource;
var
   D: TDataset;
   Cle, Libelle: TField;
   Chaine: String;
   bcbl: TBatproComboBox_Line;
   LargeurMax: Integer;
   NullChar: Char;
begin
     {
     if    (Font.Family= sys_Courier_New)
        or (Font.Family= sys_Arial      )
     then
         NullChar:=Chr(151) // — tiret pleine largeur
     else
     }
         NullChar:= '-';    // - le signe moins
     Chaine_Nulle:= StringOfChar(NullChar, 3); //LargeurMax inconnu à ce point

     Vide;
     Items.Add( Chaine_Nulle);
     ItemIndex:= 0;
     FIsNull:= True;

     D:= DataSource.DataSet;
     if not D.Active then exit;

     Cle    := D.FieldByName( KeyField  );
     if bLabel
     then
         Libelle:= D.FieldByName( LabelField)
     else
         Libelle:= nil;

     LargeurMax:= 0;
     if FDisplayKey            then Inc( LargeurMax, Cle    .Size      );
     if FDisplayKey and bLabel then Inc( LargeurMax, Length(Separateur));
     if                 bLabel then Inc( LargeurMax, Libelle.Size      );

     Chaine_Nulle:= StringOfChar(NullChar, LargeurMax);
     Items.Strings[0]:= Chaine_Nulle;

     D.First;
     while not D.EOF
     do
       begin
       bcbl:= TBatproComboBox_Line.Create;
       bcbl.Cle:= Cle.AsString;
       if bLabel
       then
           bcbl.Libelle:= Libelle.AsString
       else
           bcbl.Libelle:= '';

       Chaine:= sys_Vide;
       if FDisplayKey            then Chaine:= Chaine + bcbl.Cle;
       if FDisplayKey and bLabel then Chaine:= Chaine + Separateur;
       if                 bLabel then Chaine:= Chaine + bcbl.Libelle;
       //potentiellement on peut avoir Chaine = sys_Vide à ce point
       //ce qui peut générer une exception sous Windows 2000 quand on
       //sélectionnera cette ligne dans le BatproComboBox (bug de Windows)
       //mais affecter alors une valeur différente à Chaine ne convient pas
       // non plus
       Items.AddObject( Chaine, bcbl);
       D.Next;
       end;
end;

procedure TBatproComboBox.To_Datasource;
var
   D: TDataset;
   Chaine: String;
   DebutSeparateur: Integer;
   ValeurCle: String;

   I: Integer;
   bcbl: TBatproComboBox_Line;
   bcbl_Trouve: Boolean;

   ValeurTexte: String;
   Cle: TField;
begin
     { à revoir pour FMX
     I:= ItemIndex;

     FIsNull:= I = 0;
     if FIsNull then exit;

     D:= DataSource.DataSet;
     if I > 0
     then
         begin
         ValeurTexte:= Items.Strings[I];
         if Self.Text <> ValeurTexte
         then
             I:= Items.IndexOf( Self.Text);
         end;

     bcbl_Trouve:= I > 0;
     if bcbl_Trouve
     then
         begin
         bcbl:= Items.Objects[ I] as TBatproComboBox_Line;
         bcbl_Trouve:= Assigned( bcbl);
         end
     else
         bcbl:= nil;

     if bcbl_Trouve
     then
         FIsNull:= not D.Locate( KeyField,
                                 Echappe_Apostrophes( bcbl.Cle),
                                 [])
     else
         begin
         Chaine:= Self.Text;
         FIsNull:= Chaine = sys_Vide;
         if not FIsNull
         then
             begin
             DebutSeparateur:= Pos( Separateur, Chaine);
             if DebutSeparateur = 0
             then
                 ValeurCle:= Chaine
             else
                 ValeurCle:= Copy( Chaine, 1, DebutSeparateur-1);

             // on tronque à la valeur maxi
             Cle:= D.FieldByName(KeyField);
             ValeurCle:= Copy( ValeurCle, 1, Cle.Size);

             FIsNull:= not D.Locate( KeyField,
                                     Echappe_Apostrophes( ValeurCle),
                                     []);
             end;
         end;
     }
end;

procedure TBatproComboBox.ActiveChange(Sender: TObject);
begin
     From_Datasource;
end;

procedure TBatproComboBox.DataChange(Sender: TObject);
begin
     //From_Datasource;
end;

procedure TBatproComboBox.Change;
begin
     To_Datasource;
     //à revoir pour FMX
     //inherited Change;
end;

procedure TBatproComboBox.Select;
begin
     To_Datasource;
     inherited;
end;

procedure TBatproComboBox.KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
     { à revoir pour FMX
     if Key = VK_F8
     then
         DroppedDown:= not DroppedDown
     else
         inherited KeyDown( Key, Shift);
     }
end;

procedure TBatproComboBox.Vide;
var
   I: Integer;
   Trash: TObject;
begin
     for I:= 0 to Items.Count-1
     do
       begin
       Trash:= Items.Objects[I];
       Items.Objects[I]:= nil;
       Free_nil( Trash);
       end;
     Clear;
end;

{ à revoir pour FMX
procedure TBatproComboBox.ComboWndProc( var Message: TMessage;
                                        ComboWnd: HWnd; ComboProc: Pointer);
begin
     if Message.Msg = WM_RBUTTONDOWN
     then
         DroppedDown:= not DroppedDown
     else
         inherited ComboWndProc( Message, ComboWnd, ComboProc);
end;
}

procedure TBatproComboBox.SetIsNull(Value: Boolean);
begin
     if FIsNull = Value then exit;
     if Value
     then
         ItemIndex:= 0
     else
         ItemIndex:= 1;
     To_Datasource;
end;

function TBatproComboBox.KeyValue: String;
var
   O: TObject;
   bcbl: TBatproComboBox_Line;
//   I: Integer;
begin
     Result:= sys_Vide;
     if not IsNull
     then
         begin
         O:= Items.Objects[ ItemIndex];
         if Assigned( O)
         then
             begin
             bcbl:= O as TBatproComboBox_Line;
             Result:= bcbl.Cle;
             end;
         end;
end;

function TBatproComboBox.GotoKey( Value: String): Boolean;
var
   O: TObject;
   bcbl: TBatproComboBox_Line;
   I: Integer;
begin
     Result:= False;
     IsNull:= True;

     for I:= 0 to Items.Count - 1
     do
       begin
       O:= Items.Objects[ I];
       if Assigned( O)
       then
           begin
           bcbl:= O as TBatproComboBox_Line;
           if bcbl.Cle = Value
           then
               begin
               ItemIndex:= I;
               To_Datasource; //rafraichit IsNull
               Result:= True;
               break;
               end;
           end;
       end;
end;

end.

