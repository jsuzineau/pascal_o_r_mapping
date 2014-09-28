unit uhRequete;
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
// "handler" de requete

interface

uses
    uForms,
    ufAccueil_Erreur,
    uBatpro_StringList,
    u_sys_,
    uChrono,
    uClean,
    uDataUtilsU,
    uDataUtilsF,
    uVide,
    uBatpro_Ligne,
    uPublieur,
    uhTriColonne,
    uhField,
    {$IFDEF MSWINDOWS}
    ufProgression,
    ufClientDataset_Delta,
    {$ENDIF}
  SysUtils, Classes, DB, DBTables, BufDataset;



type
 ThRequete_Datalink= class;

 TDatasetScrolledEvent= procedure (Distance: Integer) of object;

 ThRequete
 =
  class( TObject)
  private
    FDetailsActifs: Boolean;
    Datalink: ThRequete_Datalink;
    procedure Assure_Events_NIL;
    procedure Update_Details;
    procedure SetDetailsActifs( Value: Boolean);
  protected
    Details: TList;// liste de datasets détail à rafraichir dans le cadre
                   // d'une relation maitre détail
    procedure qBeforeOpen (DataSet: TDataSet); virtual;
    procedure qAfterOpen  (DataSet: TDataSet); virtual;
    procedure qAfterInsert(DataSet: TDataSet); virtual;
    procedure qAfterClose (DataSet: TDataSet); virtual;
    procedure qCalcFields (DataSet: TDataSet); virtual;
    procedure qBeforePost (DataSet: TDataSet); virtual;
    procedure qAfterScroll(DataSet: TDataSet); virtual;
    function sfConcat(var S: String; FieldName, Separator: String; sFormat: String = ''): Integer;
    procedure dsDataChange(Sender: TObject; Field: TField);
    function Cree_Element: TBatpro_Ligne; virtual;
  public
    Q: TDataSet;
    ds: TDataSource;
    T: TBatpro_StringList;
    BeforeVide, AfterRemplit, pBeforePost, pAfter_Update_Details: TPublieur;
    BeforeOpen  ,
    AfterOpen   ,
    AfterInsert ,
    AfterClose  ,
    OnCalcFields,
    BeforePost  ,
    AfterScroll : TDataSetNotifyEvent;
    OnDataChange: TDataChangeEvent;//DS
    OnDatasetScrolled: TDatasetScrolledEvent;
    Classe_Elements: TBatpro_Ligne_Class;
    Designation: String;
    AfficherProgressionDetails: Boolean;
    AfficherChronoDetails: Boolean;
    constructor Create( unQ: TDataSet; unDS: TDataSource;
                        unClasse_Elements: TBatpro_Ligne_Class); virtual;
    destructor Destroy; override;
    procedure Vide;    virtual;
    procedure Remplit; virtual;
    function Cherche_L( L: TBatpro_StringList; sCle: String): TBatpro_Ligne;
    function Cherche( sCle: String): TBatpro_Ligne;

    function StringField_from_FieldName(FieldName: String): TStringField;
    function   DateField_from_FieldName(FieldName: String): TDateField;
    function  FloatField_from_FieldName(FieldName: String): TFloatField;

    function  StringField_Value( Field: String): String;
    function    DateField_Value( Field: String): TDateTime;
    function IntegerField_Value( Field: String): Integer;

    //type de champs différents selon BDE ou DBExpress
    function   Float_Value( Field: String): double;

    function Set_StringField ( Field: String; Value: String   ): Boolean;
    function Set_DateField   ( Field: String; Value: TDateTime): Boolean;
    function Set_IntegerField( Field: String; Value: Integer  ): Boolean;

    //type de champs différents selon BDE ou DBExpress
    function Set_Float  ( Field: String; Value: double   ): Boolean;

    function Assure_fkCalculated(Contexte: String; F: TField): Boolean;

    function    AddDetail( D: TDataset): Integer;
    function RemoveDetail( D: TDataset): Integer;

    function    AddNid( hNid: ThRequete): Integer;
    function RemoveNid( hNid: ThRequete): Integer;

    procedure    Add_hField( hField: ThField);
    procedure Remove_hField( hField: ThField);

    procedure CalcFields_Map( hTriColonne: ThTriColonne); virtual;
    property DetailsActifs: Boolean read FDetailsActifs write SetDetailsActifs;
  //Flag de remplissage pendant ouverture
  private
    FRemplit_AfterOpen: Boolean;
  public
    property Remplit_AfterOpen: Boolean read FRemplit_AfterOpen;
  //Gestion des nids
  protected
    Nids   : TList;// liste de handlers de nids (tables stockées dans un champ)
                   // -> nid d'oiseau (cf Borland: nested tables,nested dataset)
  public
    procedure Ouvre_Nid; virtual;
    procedure Ferme_Nid; virtual;
  end;

 ThRequete_Class= class of ThRequete;

 ThRequete_Datalink
 =
  class( TDataLink)
  private
  protected
    hr: ThRequete;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure UpdateData; override;
    procedure RecordChanged(Field: TField); override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
    {$IFDEF MSWINDOWS}
    procedure DataEvent(Event: TDataEvent; Info: Integer); override;
    {$ENDIF}
    procedure CheckBrowseMode; override;

  public
    constructor Create( un_hr: ThRequete);
    destructor Destroy; override;

  end;

var
   Classe_hNid: ThRequete_Class = nil;

implementation

procedure ThRequete.Assure_Events_NIL;
var
   Messag: String;
   OK: Boolean;
   procedure Traite_Event( Nom, Event: String);
   begin
        Messag:= Messag+ Format( '  %s.%s <> nil'#13#10,
                                 [Nom, Event]);
        OK:= False;
   end;
   procedure Traite_q_Event( Event: String);
   begin
        Traite_Event( Q.Name, Event);
   end;
   procedure Traite_ds_Event( Event: String);
   begin
        Traite_Event( DS.Name, Event);
   end;
begin
     OK:= True;

     Messag:= Format( 'Problème à signaler au développeur: '#13#10+
                      '  %s::%s'#13#10,
                      [ParamStr(0), Dataset_Owner_Name( Q)]);
     if Assigned( Q.BeforeOpen  ) then Traite_q_Event('BeforeOpen  ');
     if Assigned( Q.AfterOpen   ) then Traite_q_Event('AfterOpen   ');
     if Assigned( Q.AfterInsert ) then Traite_q_Event('AfterInsert ');
     if Assigned( Q.AfterClose  ) then Traite_q_Event('AfterClose  ');
     if Assigned( Q.OnCalcFields) then Traite_q_Event('OnCalcFields');
     if Assigned( Q.BeforePost  ) then Traite_q_Event('BeforePost  ');
     if Assigned( Q.AfterScroll ) then Traite_q_Event('AfterScroll ');

     if DS = nil
     then
         begin
         Messag:= Messag+ 'le DS passé au HR est à nil '#13#10;
         OK:= False;
         end
     else
         begin
         if Assigned( DS.OnDataChange) then Traite_ds_Event('OnDataChange');
         end;

     if not OK then uForms_ShowMessage( Messag);
end;

procedure ThRequete.qBeforeOpen(DataSet: TDataSet);
begin
     inherited;
     if Assigned(BeforeOpen) then BeforeOpen( DataSet);
end;

procedure ThRequete.qAfterOpen(DataSet: TDataSet);
begin
     inherited;
     if Assigned(AfterOpen) then AfterOpen( DataSet);
     try
        FRemplit_AfterOpen:= True;
        Remplit;
     finally
            FRemplit_AfterOpen:= False;
            end;
end;

procedure ThRequete.qAfterInsert(DataSet: TDataSet);
begin
     inherited;
     if Assigned(AfterInsert) then AfterInsert( DataSet);
end;

procedure ThRequete.qAfterClose(DataSet: TDataSet);
begin
     inherited;
     if Assigned(AfterClose) then AfterClose( DataSet);
     Vide;
end;

procedure ThRequete.qCalcFields(DataSet: TDataSet);
begin
     inherited;
     if Assigned(OnCalcFields) then OnCalcFields( DataSet);
end;

procedure ThRequete.qBeforePost(DataSet: TDataSet);
begin
     inherited;
     pBeforePost.Publie;
     if Assigned( BeforePost) then BeforePost( DataSet);
end;

procedure ThRequete.qAfterScroll(DataSet: TDataSet);
begin
     inherited;
     Update_Details;
     if Assigned( AfterScroll) then AfterScroll( DataSet);
end;

constructor ThRequete.Create( unQ: TDataSet; unDS: TDataSource;
                              unClasse_Elements: TBatpro_Ligne_Class);
begin
     inherited Create;

     Q := unQ ;
     DS:= unDS;
     Classe_Elements:= unClasse_Elements;
     T := TBatpro_StringList.Create;

     BeforeVide           := TPublieur.Create(ClassName+'($'+IntToHex(Integer(Self),8)+').BeforeVide           ');
     AfterRemplit         := TPublieur.Create(ClassName+'($'+IntToHex(Integer(Self),8)+').AfterRemplit         ');
     pBeforePost          := TPublieur.Create(ClassName+'($'+IntToHex(Integer(Self),8)+').pBeforePost          ');
     pAfter_Update_Details:= TPublieur.Create(ClassName+'($'+IntToHex(Integer(Self),8)+').pAfter_Update_Details');
     BeforeOpen  := nil;
     AfterOpen   := nil;
     AfterInsert := nil;
     AfterClose  := nil;
     OnCalcFields:= nil;
     BeforePost  := nil;
     AfterScroll := nil;
     OnDataChange:= nil;

     OnDatasetScrolled:= nil;

     FRemplit_AfterOpen:= False;
     Designation:= sys_Vide;
     AfficherProgressionDetails:= False;
     AfficherChronoDetails:= False;

     Assure_Events_NIL;

     q.BeforeOpen  := qBeforeOpen ;
     q.AfterOpen   := qAfterOpen  ;
     q.AfterInsert := qAfterInsert;
     q.AfterClose  := qAfterClose ;
     q.OnCalcFields:= qCalcFields ;
     q.BeforePost  := qBeforePost ;
     q.AfterScroll := qAfterScroll;

     Details:= TList.Create;
     Nids   := TList.Create;

     if Assigned( ds)
     then
         begin
         ds.OnDataChange:= dsDataChange;
         end;

     DetailsActifs:= True;
     Datalink:= ThRequete_Datalink.Create( Self);
end;

destructor ThRequete.Destroy;
begin
     Vide;

     Free_nil( Datalink);

     if Assigned( ds)
     then
         ds.OnDataChange:= OnDataChange;//restauration ancienne valeur

     Free_nil( Nids   );
     Free_nil( Details);

     q.BeforeOpen  := nil;
     q.AfterOpen   := nil;
     q.AfterInsert := nil;
     q.AfterClose  := nil;
     q.OnCalcFields:= nil;
     q.BeforePost  := nil;
     q.AfterScroll := nil;

     Free_nil( BeforeVide           );
     Free_nil( AfterRemplit         );
     Free_nil( pBeforePost          );
     Free_nil( pAfter_Update_Details);
     Free_nil( T);
     inherited;
end;

function ThRequete.Cree_Element: TBatpro_Ligne;
begin
     Result:= Classe_Elements.Create( T, q, nil);
end;

procedure ThRequete.Vide;
begin
     BeforeVide.Publie;
     Vide_StringList( T);
end;

procedure ThRequete.Remplit;
var
   bl: TBatpro_Ligne;
   //OldFilter: String;
begin
     Vide;
     if Classe_Elements = nil then exit;
     if not q.Active          then exit;
     try
        if Assigned( ds) then ds.Enabled:= False;

        //if q.Filtered
        //then
        //    begin
        //    OldFilter:= q.Filter;
        //    q.Filter:= sys_Vide;
        //    q.Filtered:= False;
        //
        //    q.Filter:= OldFilter;
        //    q.Filtered:= True;
        //    end;

        q.First;
        while not q.EOF
        do
          begin
          bl:= Cree_Element;
          if Assigned( bl)
          then
              T.AddObject( bl.sCle, bl);
          q.Next;
          end;
     finally
            if Assigned( ds) then ds.Enabled:= True;
            end;

     AfterRemplit.Publie;
end;


function ThRequete.Cherche_L( L: TBatpro_StringList; sCle: String): TBatpro_Ligne;
var
   bl: TBatpro_Ligne;
begin
     Result:= nil;

     if L               = nil then exit;
     if Classe_Elements = nil then exit;

     // si introuvable, IndexOf renvoie -1 et
     // alors Batpro_Element_from_sl renvoie nil
     bl:= Batpro_Ligne_from_sl( L, L.IndexOf( sCle));
     if not (bl is Classe_Elements) then exit;


     Result:= bl;
end;

function ThRequete.Cherche( sCle: String): TBatpro_Ligne;
begin
     Result:= Cherche_L( T, sCle);
end;

function ThRequete.StringField_from_FieldName( FieldName: String): TStringField;
begin
     Result:= uDataUtilsU.StringField_from_FieldName( q, FieldName);
end;

function ThRequete.  DateField_from_FieldName( FieldName: String): TDateField;
begin
     Result:= uDataUtilsU.  DateField_from_FieldName( q, FieldName);
end;

function ThRequete. FloatField_from_FieldName( FieldName: String): TFloatField;
begin
     Result:= uDataUtilsU. FloatField_from_FieldName( q, FieldName);
end;

function ThRequete.StringField_Value( Field: String): String;
var
   F: TField;
   Defaut: String;
begin
     Defaut:= sys_Vide;

     F:= q.FindField( Field);
     if Assigned( F)
     then
         if F is TStringField
         then
             Result:= TStringField( F).Value
         else
             Result:= Defaut
     else
         Result:= Defaut;
end;

function ThRequete.DateField_Value( Field: String): TDateTime;
var
   F: TField;
   Defaut: TDateTime;
begin
     Defaut:= 0;

     F:= q.FindField( Field);
     if Assigned( F)
     then
         if F is TDateField
         then
             Result:= TDateField( F).Value
         else
             Result:= Defaut
     else
         Result:= Defaut;
end;

function ThRequete.Float_Value( Field: String): double;
var
   F: TField;
   Defaut: double;
begin
     Defaut:= 0;

     F:= q.FindField( Field);
     if Assigned( F)
     then
              if F is TFloatField  then Result:= TFloatField ( F).Value
         else if F is TBCDField    then Result:= TBCDField   ( F).AsFloat
         else if F is TFMTBCDField then Result:= TFMTBCDField( F).AsFloat
         else
             Result:= Defaut
     else
         Result:= Defaut;
end;

function ThRequete.IntegerField_Value( Field: String): Integer;
var
   F: TField;
   Defaut: Integer;
begin
     Defaut:= 0;

     F:= q.FindField( Field);
     if Assigned( F)
     then
         if F is TLongintField
         then
             Result:= TLongintField( F).Value
         else
             Result:= Defaut
     else
         Result:= Defaut;
end;

function ThRequete.Set_StringField ( Field: String;Value:String   ):Boolean;
var
   F: TField;
begin
     F:= q.FindField( Field);

     Result:= Assigned( F);
     if not Result then exit;

     Result:= F is TStringField;
     if not Result then exit;

     TStringField( F).Value:= Value;
end;

function ThRequete.Set_DateField   ( Field: String;Value:TDateTime):Boolean;
var
   F: TField;
begin
     F:= q.FindField( Field);

     Result:= Assigned( F);
     if not Result then exit;

     Result:= F is TDateField;
     if not Result then exit;

     TDateField( F).Value:= Value;
end;

function ThRequete.Set_Float  ( Field: String;Value:double   ):Boolean;
var
   F: TField;
begin
     F:= q.FindField( Field);

     Result:= Assigned( F);
     if not Result then exit;

          if F is TFloatField then TFloatField( F).Value  := Value
     else if F is TBCDField   then TBCDField  ( F).AsFloat:= Value
     else
         Result:= False;
end;

function ThRequete.Set_IntegerField( Field: String;Value:Integer  ):Boolean;
var
   F: TField;
begin
     F:= q.FindField( Field);

     Result:= Assigned( F);
     if not Result then exit;

     Result:= F is TLongintField;
     if not Result then exit;

     TLongintField( F).Value:= Value;
end;

function ThRequete.sfConcat(var S: String; FieldName, Separator: String; sFormat: String = ''): Integer;
begin
     Result:= uDataUtilsU.sfConcat( S, StringField_from_FieldName( FieldName), Separator,
                                    sFormat);
end;

function ThRequete.Assure_fkCalculated(Contexte: String; F: TField): Boolean;
begin
     Result:= uDataUtilsF.Assure_fkCalculated( Contexte, F);
end;

function ThRequete.AddDetail( D: TDataset): Integer;
begin
     Result:= Details.Add( D);
end;

function ThRequete.RemoveDetail(D: TDataset): Integer;
begin
     Result:= Details.Remove( D);
end;

function ThRequete.AddNid(hNid: ThRequete): Integer;
begin
     Result:= -1;
     if not (hNid is Classe_hNid) then exit;

     Result:= Nids.Add( hNid);
end;

function ThRequete.RemoveNid(hNid: ThRequete): Integer;
begin
     Result:= Nids.Remove( hNid);
end;

procedure ThRequete.dsDataChange( Sender: TObject; Field: TField);
var
   I: Integer;
   hr: ThRequete;
   hNid: ThRequete;
begin
     //Il faudra peut-être envisager de passer ce code dans le
     // ThRequete_Datalink
     for I:= 0 to Nids.Count -1
     do
       begin
       hr:= ThRequete( Nids.Items[I]);
       if Assigned( hr)
       then
           begin
           hNid:= hr;
           hNid.Ouvre_Nid;
           end;
       //il faudra peut-être peaufiner plus tard en gérant la réouverture de nid
       //uniquement si Field fait partie du nid.
       end;

     if Assigned(OnDataChange)
     then
         OnDataChange( Sender, Field);
end;

{ ThRequete.CalcFields_Map
 Renseigne hTriColonne sur les champs à trier pour un champ calculé donné
}
procedure ThRequete.CalcFields_Map( hTriColonne: ThTriColonne);
begin

end;

procedure ThRequete.   Add_hField( hField: ThField);
begin
     pBeforePost.Abonne( hField, hField.BeforePost);
end;

procedure ThRequete.Remove_hField( hField: ThField);
begin
     pBeforePost.Desabonne( hField, hField.BeforePost);
end;

procedure ThRequete.SetDetailsActifs( Value: Boolean);
begin
     FDetailsActifs:= Value;
     if FDetailsActifs
     then
         Update_Details;
end;

procedure ThRequete.Update_Details;
var
   D: TDataset;
   I: Integer;
   TitreProgression_et_Chrono: String;
begin
     if not DetailsActifs then exit;



     if AfficherProgressionDetails or AfficherChronoDetails
     then
         begin
         if Designation = sys_Vide
         then
             TitreProgression_et_Chrono:= Q.Name
         else
             TitreProgression_et_Chrono:= Designation;
         TitreProgression_et_Chrono
         :=
           TitreProgression_et_Chrono+
           ' - Exécution des requêtes SQL des détails';
         end;

     if AfficherChronoDetails
     then
         Chrono.Start;

     {$IFDEF MSWINDOWS}
     if AfficherProgressionDetails
     then
         fProgression.Demarre( TitreProgression_et_Chrono, 0, Details.Count -1);
     {$ENDIF}
     try
        for I:= 0 to Details.Count -1
        do
          begin
          D:= TDataset( Details.Items[I]);
          if Assigned( D)
          then
              if D.Active
              then
                  begin
                  Poste( D);
                  if D is TBufDataSet
                  then
                      begin
                      if TBufDataSet(D).ChangeCount > 0
                      then
                          {$IFDEF MSWINDOWS}
                          if fClientDataset_Delta.Execute( TBufDataSet(D), True)
                          {$ELSE}
                          if uForms_Message_Yes('Application des modifications',
                          'Voulez vous valider les modifications sur '+D.Name)
                          {$ENDIF}
                          then
                              TBufDataSet(D).ApplyUpdates(-1)
                          else
                              TBufDataSet(D).CancelUpdates;
                      end;
                  //RefreshQuery( D);
                  DatasetDetail_Update( D);
                  if AfficherChronoDetails
                  then
                      Chrono.Stop( Dataset_Owner_Name( D)+'.'+D.Name);
                  end;
          {$IFDEF MSWINDOWS}
          if AfficherProgressionDetails then fProgression.AddProgress( 1);
          {$ENDIF}
          end;

     finally
            {$IFDEF MSWINDOWS}
            if AfficherProgressionDetails then fProgression.Termine;
            {$ENDIF}
            end;
     if AfficherChronoDetails
     then
         fAccueil_Erreur( sys_N+sys_N+TitreProgression_et_Chrono+sys_N+
                          Chrono.Get_Liste);

     pAfter_Update_Details.Publie;
end;

procedure ThRequete.Ferme_Nid;
begin

end;

procedure ThRequete.Ouvre_Nid;
begin

end;

{ ThRequete_Datalink }

constructor ThRequete_Datalink.Create(un_hr: ThRequete);
begin
     inherited Create;

     hr:= un_hr;
     DataSource:= hr.ds;
end;

destructor ThRequete_Datalink.Destroy;
begin
     DataSource:= nil;
     inherited;
end;

procedure ThRequete_Datalink.DataSetChanged;
begin
     inherited;
end;

procedure ThRequete_Datalink.ActiveChanged;
begin
     inherited;
     //uForms_ShowMessage( 'ActiveChanged');
end;

procedure ThRequete_Datalink.DataSetScrolled(Distance: Integer);
begin
     inherited;
     if Assigned( hr.OnDatasetScrolled)
     then
         hr.OnDatasetScrolled( Distance);
     //uForms_ShowMessage( 'DataSetScrolled');
end;

procedure ThRequete_Datalink.UpdateData;
begin
     inherited;
     //uForms_ShowMessage( 'UpdateData');
     hr.Update_Details;
end;

procedure ThRequete_Datalink.RecordChanged(Field: TField);
begin
     inherited;
     //if Field = nil    est lancé lors de l'edit
     //then
     //    begin
     //    uForms_ShowMessage( 'RecordChanged, nil');
     //    end;
end;

procedure ThRequete_Datalink.CheckBrowseMode;
begin
     inherited;
     //uForms_ShowMessage( 'CheckBrowseMode');
end;

{$IFDEF MSWINDOWS}
procedure ThRequete_Datalink.DataEvent( Event: TDataEvent; Info: Integer);
begin
     inherited;
     //if Event = deUpdateState
     //then
     //    begin
     //    uForms_ShowMessage( 'DataEvent( deUpdateState,'+IntToStr(Info)+')');
     //    end
     //else
     //    uForms_ShowMessage( 'DataEvent('+IntToStr(Integer(Event))+','+IntToStr(Info)+')');
end;
{$ENDIF}

end.
