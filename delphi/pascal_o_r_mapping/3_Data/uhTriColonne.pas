unit uhTriColonne;
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
    uForms,
    uClean,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    uDataUtilsU,
  {$IFDEF MSWINDOWS}
  Variants, Grids, DBGrids, StdCtrls, FMX.Controls,
  {$ENDIF}
  SysUtils, Classes,
  FMTBcd, DB, Provider, DBClient, SqlExpr;

type
  {$IFNDEF MSWINDOWS}
  //juste pour permettre la compilation
  TMouseButton= TObject;
  TShiftState= TObject;
  TDBGrid= TObject;
  TColumn=TObject;
  TDBGridClickEvent=procedure(Column:TColumn)of object;
  TMouseEvent=procedure( Sender:TObject;
                         Button:TMouseButton;
                         Shift:TShiftState;
                         X,Y:Integer)of object;
  TLabel= TObject;

  {$ENDIF}
 ThTriColonne
 =
  class
  protected
    LastShift: TShiftState;
    dbg: TDBGrid;
    cd: TClientDataset;
    l: TLabel;
    Champs, ChampsDecroissants: String;
    CalcFields_Map: TBatpro_StringList;//donne le champ à trier pour un champ calculé donné
    procedure dbgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dbgTitleClick(Column: TColumn);
    procedure Retablit_Titres;
    function Traduit( var NomChamp: String): Boolean;
  public
    Groupe_Libelle: String;
    OnTitleClick: TDBGridClickEvent;
    OnMouseDown: TMouseEvent;
    constructor Create( un_dbg: TDBGrid; un_cd: TClientDataset; un_l: TLabel= nil);
    destructor Destroy; override;
    procedure Add_CalcField( CalcFieldName, SortFieldName: String);
    procedure Reset;
  end;

implementation

const
     sys_Index_hTriColonne = 'Index_hTriColonne';

{ ThTriColonne }

constructor ThTriColonne.Create( un_dbg: TDBGrid; un_cd: TClientDataset;
                                 un_l: TLabel= nil);
begin
     dbg:= un_dbg;
     cd:= un_cd;
     l:= un_l;
     OnTitleClick:= nil;

     {$IFDEF MSWINDOWS}
     if Assigned( dbg.OnTitleClick)
     then
         uForms_ShowMessage( 'Erreur à signaler au développeur: '+
                      NamePath(dbg)+'.OnTitleClick <> nil');
     dbg.OnTitleClick:= dbgTitleClick;

     if Assigned( dbg.OnMouseDown)
     then
         uForms_ShowMessage( 'Erreur à signaler au développeur: '+
                      NamePath(dbg)+'.OnMouseDown <> nil');
     dbg.OnMouseDown:= dbgMouseDown;
     {$ENDIF}

     Champs            := sys_Vide;
     ChampsDecroissants:= sys_Vide;

     CalcFields_Map:= TBatpro_StringList.Create;
end;

destructor ThTriColonne.Destroy;
begin
     Retablit_Titres;
     Free_nil( CalcFields_Map);
     {$IFDEF MSWINDOWS}
     dbg.OnTitleClick:= nil;
     {$ENDIF}
     inherited;
end;

procedure ThTriColonne.dbgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     LastShift:= Shift;
     if Assigned(OnMouseDown)
     then
         OnMouseDown( Sender, Button, Shift, X, Y);
end;

function IndexString_AddToken( Old, Token: String): String;
begin
     Result:= Old;
     if Result <> sys_Vide
     then
         Result:= Result+';';
     Result:= Result + Token;
end;

function IndexLibelle_AddToken( Old, Token: String): String;
begin
     Result:= Old;
     if Result <> sys_Vide
     then
         Result:= Result+', ';
     Result:= Result + Token;
end;

function IndexString_Add( Old, Champ: String; var Nouveau: Boolean): String;
var                    //on rajoute Champ dans Old s'il n'y est pas
   Token: String;
   Trouve: Boolean;
begin
     Trouve:= False;
     Result:= sys_Vide;

     while Old <> sys_Vide
     do
       begin
       Token:= StrToK( ';', Old);
       Trouve:= Trouve or (Token = Champ);
       Result:= IndexString_AddToken( Result, Token);
       end;
     Nouveau:= not Trouve;
     if Nouveau
     then
         Result:= IndexString_AddToken( Result, Champ);
end;

function IndexString_Toggle( Old, Champ: String; var Absent: Boolean): String;
var                    //on rajoute Champ dans Old s'il n'y est pas
   Token: String;      //on enlève  Champ dans Old s'il y est
   Trouve: Boolean;
begin
     Trouve:= False;
     Result:= sys_Vide;

     while Old <> sys_Vide
     do
       begin
       Token:= StrToK( ';', Old);
       Trouve:= Trouve or (Token = Champ);
       if Token <> Champ
       then
           Result:= IndexString_AddToken( Result, Token);
       end;
     if not Trouve
     then
         Result:= IndexString_AddToken( Result, Champ);

     Absent:= Trouve;//si on l'a trouvé on l'a enlevé.

end;

function Sans_Symbole( S: String): String;
var
   L: Integer;
begin
     Result:= S;
     L:= Length( Result);
     if L > 0
     then
         begin
         if Result[L] in ['/','\']
         then
             Delete( Result, L, 1);
         end;
end;

function Column_Caption( Old: String; Croissant: Boolean): String;
begin
     Result:= Sans_Symbole( Old);

     if Croissant
     then
         Result:= Result+'/'
     else
         Result:= Result+'\';
end;

function IndexLibelle_Toggle( Old, Libelle: String): String;
var                    //on rajoute Champ dans Old s'il n'y est pas
   Token: String;      //on enlève  Champ dans Old s'il y est
   Libell: String;
   Trouve: Boolean;
   function Libell_egal_Token: Boolean;
   var
      Toke: String;
   begin
        Toke:= Sans_Symbole( Token);
        Result:= Libell = Toke;
        Trouve:= Trouve or Result;
   end;
begin
     Result:= sys_Vide;

     Trouve:= False;
     Libell:= Sans_Symbole( Libelle);

     while Old <> sys_Vide
     do
       begin
       Token:= StrToK( ', ', Old);
       if Libell_egal_Token
       then
           Result:= IndexLibelle_AddToken( Result, Libelle)
       else
           Result:= IndexLibelle_AddToken( Result, Token)
           ;
       end;
     if not Trouve
     then
         Result:= IndexLibelle_AddToken( Result, Libelle);
end;

procedure ThTriColonne.Retablit_Titres;
{$IFDEF MSWINDOWS}
var
   I: Integer;
begin
     for I:= 0 to dbg.Columns.Count-1
     do
       with dbg.Columns.Items[I].Title
       do
         Caption:= Sans_Symbole( Caption);
end;
{$ELSE}
begin
end;
{$ENDIF}

function ThTriColonne.Traduit( var NomChamp: String): Boolean;
begin
     NomChamp:= CalcFields_Map.Values[ NomChamp];
     Result:= NomChamp <> sys_Vide;
end;

procedure ThTriColonne.dbgTitleClick(Column: TColumn);
var
   Champ: TField;
   NomChamp: String;
   Caption: String;
   slIndex: TBatpro_StringList;
   iid: Integer;
   Croissant: Boolean;
   OK: Boolean;
   procedure AjouteChamp;
   var
      Nouveau: Boolean;
   begin
        Champs:= IndexString_Add( Champs, NomChamp, Nouveau);
        if not Nouveau
        then
            ChampsDecroissants
            :=
              IndexString_Toggle( ChampsDecroissants, NomChamp, Croissant);
   end;
begin
     Croissant:= True;

     {$IFDEF MSWINDOWS}
     Champ:= Column.Field;
     if Assigned( Champ)
     then
         begin
         NomChamp:= Champ.FieldName;
         if    (Champ.Calculated)
            or (Champ.FieldKind = fkLookup)
         then
             OK:= Traduit( NomChamp)
         else
             OK:= True;

         if not OK
         then
             uForms_ShowMessage('Pas de possibilité de tri prévue sur ce champ')
         else
             begin
             if ssShift in LastShift
             then
                 AjouteChamp
             else
                 if Champs = NomChamp
                 then
                     AjouteChamp
                 else
                     begin
                     Champs            := NomChamp;
                     ChampsDecroissants:= sys_Vide;
                     Groupe_Libelle    := sys_Vide;
                     Retablit_Titres;
                     end;

             slIndex:= TBatpro_StringList.Create;
             try
                cd.GetIndexNames( slIndex);
                iid:= slIndex.IndexOf( sys_Index_hTriColonne);
                if iid <> -1
                then
                    cd.DeleteIndex( sys_Index_hTriColonne);

                cd.AddIndex(sys_Index_hTriColonne,Champs,[],ChampsDecroissants);
                cd.IndexName:= sys_Index_hTriColonne;
             finally
                    Free_nil( slIndex);
                    end;

             Caption:= Column_Caption( Column.Title.Caption, Croissant);
             Groupe_Libelle:= IndexLibelle_Toggle( Groupe_Libelle, Caption);
             Column.Title.Caption:= Caption;

             if Assigned( l)
             then
                 begin
                 l.Visible:= True;
                 l.Caption:= 'Tri par '+ Groupe_Libelle+
                             ' (Majuscule + Clic pour ajouter des colonnes)';
                 end;
             end;
         end;
     {$ENDIF}
     if Assigned(OnTitleClick)
     then
         OnTitleClick( Column);
end;

procedure ThTriColonne.Add_CalcField( CalcFieldName, SortFieldName: String);
begin
     CalcFields_Map.Values[ CalcFieldName]:= SortFieldName;
end;

procedure ThTriColonne.Reset;
begin
     Retablit_Titres;
     cd.IndexName:= sys_Vide;
     {$IFDEF MSWINDOWS}
     if Assigned( l)
     then
         begin
         l.Visible:= True;
         l.Caption:= 'Aucun tri';
         end;
     {$ENDIF}
end;

end.
