unit ucBatpro_RadioGroup;
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
  SysUtils, Classes, VCL.Controls, VCL.StdCtrls, VCL.ExtCtrls,
  uClean,
  u_sys_;

type
 TBatpro_RadioGroup
 =
  class( TRadioGroup)
  private
    { Déclarations privées }
    Loaded_OK: Boolean;
    ButtonWidth : Integer;
    ButtonHeight: Integer;
    Old_ItemIndex: Integer;
    sNomFichier: String;
    Button: TButton;
    Memo: TMemo;
    procedure ButtonClick( Sender: TObject);
    procedure Positionne;
    procedure Apply_Old_ItemIndex;
  protected
    { Déclarations protégées }
    procedure Resize; override;
    procedure CreateWnd; override;
    procedure Loaded; override;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Batpro', [TBatpro_RadioGroup]);
end;

const
     sButton_Modif = 'Modif.';
     sButton_Sauver= 'Sauver';

{ TBatpro_RadioGroup }

constructor TBatpro_RadioGroup.Create(AOwner: TComponent);
begin
     inherited;

     ButtonWidth := 42;
     ButtonHeight:= 16;

     Button:= TButton.Create( Self);
     //with Button do ControlStyle:= ControlStyle + [csReplicatable];
     Button.Width := ButtonWidth;
     Button.Height:= ButtonHeight;
     Button.Visible:= True;
     Button.Parent:= Self;
     Button.OnClick:= ButtonClick;
     //Button.Cursor:= crArrow;
     Button.Caption:= sButton_Modif;

     Memo:= TMemo.Create( Self);
     Memo.Parent:= Self;
     Memo.Visible:= False;
     //Memo.ScrollBars:= ssVertical;

     Loaded_OK:= False;
     Old_ItemIndex:= -1;
end;

destructor TBatpro_RadioGroup.Destroy;
begin
     if Loaded_OK
     then
         begin
         if Items.Text = sys_Vide
         then
             begin
             if FileExists( sNomFichier)
             then
                 DeleteFile( sNomFichier);
             end
         else
             Items.SaveToFile( sNomFichier);
         end;
     inherited;
end;

procedure TBatpro_RadioGroup.Apply_Old_ItemIndex;
begin
     if Old_ItemIndex >= Items.Count
     then
         Old_ItemIndex:= Items.Count-1;

     ItemIndex:= Old_ItemIndex;
end;

procedure TBatpro_RadioGroup.Loaded;
var
   Owner_Name: String;
   I: Integer;
   sl: TStringList;
begin
     inherited;
     Loaded_OK:= True;
     Button.Name:= Name + '_Button';
     Memo  .Name:= Name + '_Memo'  ;

     Old_ItemIndex:= ItemIndex;

     if Assigned( Owner)
     then
         Owner_Name:= Owner.Name
     else
         Owner_Name:= sys_Vide;

     sNomFichier
     :=
       ChangeFileExt( ParamStr(0), '_'+Owner_Name+'_'+Name+'_Items.txt');

     sl:= TStringList.Create;
     try
        sl.Text:= Items.Text;
        if FileExists( sNomFichier)
        then
            begin
            Items.LoadFromFile(sNomFichier);
            if sl.Count > Items.Count
            then
                begin
                for I:= Items.Count to sl.Count - 1
                do
                  Items.Add( sl.Strings[ I]);
                end;
            end;
     finally
            Free_nil( sl);
            end;

     Apply_Old_ItemIndex;
end;

procedure TBatpro_RadioGroup.ButtonClick(Sender: TObject);
begin
     if Memo.Visible
     then
         begin
         Items.Text:= Memo.Lines.Text;
         Button.Caption:= sButton_Modif;
         Memo.Hide;
         Apply_Old_ItemIndex;
         end
     else
         begin
         Memo.Lines.Text:= Items.Text;
         Old_ItemIndex:= ItemIndex;
         Items.Text:= sys_Vide;
         Button.Caption:= sButton_Sauver;
         Memo.Show;
         end;
end;

procedure TBatpro_RadioGroup.Positionne;
const
     Marge= 4;
begin
     Button.Left:= ClientWidth -2 -ButtonWidth;
     Button.Top := 0;

     Memo.Left:= Marge;
     Memo.Top := Button.Top+Button.Height;
     Memo.Width := Width -2*Marge;
     Memo.Height:= Height-Marge-Memo.Top;
end;

procedure TBatpro_RadioGroup.Resize;
begin
     inherited;
     Positionne;
end;

procedure TBatpro_RadioGroup.CreateWnd;
begin
     inherited;
     Positionne;
end;

end.
