unit uDataUtilsF;
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
    uForms,
    uClean,
    uNetwork,
    uLog,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    uAide,
    {$ENDIF}
    uDataUtilsU,
    uuStrings,
    uParametres_Ligne_de_commande,
    uBatpro_StringList,
    u_sys_,
    uVide,

    ufAccueil_Erreur,

  {$IFDEF MSWINDOWS}
  Graphics, Forms, Dialogs,
  {$ENDIF}
  SysUtils, Classes, DB, DBTables,
  SimpleDS, BufDataset, TypInfo, SQLDB;

function RefreshQuery( Q   : TQuery        ;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
function RefreshQuery( SQLQ: TSQLQuery     ;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
function RefreshQuery( SD  : TSimpleDataset;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
function RefreshQuery( CD: TBufDataSet;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
function RefreshQuery( D: TDataset;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;

function DatasetDetail_Update( D: TDataset): Boolean;

function ExecSQLQuery( Q   : TQuery                   ): Boolean; overload;
function ExecSQLQuery( SQLQ: TSQLQuery                ): Boolean; overload;
function ExecSQLQuery( Q   : TQuery; QueryText: String): Boolean; overload;
function ExecSQLQuery( SQLQ: TSQLQuery; QueryText: String): Boolean; overload;
function ExecSQLQuery_db( Q: TQuery; DB: TDatabase): Boolean;
function ExecSQLQuery_sqlc( SQLQ: TSQLQuery; sqlc: TSQLConnection): Boolean;
function ExecQuery( sqlc: TSQLConnection; SQL: String): Boolean;

function SetQuery( Q: TQuery   ; QueryText: String): Boolean; overload;
function SetQuery( sqlq: TSQLQuery; cd: TBufDataSet ;QueryText: String): Boolean; overload;

function SetSQLQuery( Q: TSQLQuery; QueryText: String): Boolean;

function Ouvre_Database( db: TDatabase): Boolean;
function Ouvre_SQLConnection( sqlc: TDatabase;
                              _Afficher_Erreur: Boolean= True): Boolean;

function Ouvre( Dataset: TDataset): Boolean;

function NamePath_from_Q( Q: TQuery): String;
function NamePath_from_C( C: TComponent): String;
function Requete_Log( Q: TDataset): String;
function AfficheRequete( Q: TDataset): Boolean;
function LogRequete( Q: TDataset): Boolean;
function QueryText( D: TDataset): String;
function ConnectionText( D: TDataset): String;
function Dataset_from_ClientDataset( CD: TBufDataSet ): TDataset;
function SQLQuery_from_ClientDataset( CD: TBufDataSet ): TSQLQuery;

procedure Assure_D_is_TQuery( Contexte: String; D: TDataSet);
procedure Assure_D_is_TQuery_TBufDataSet ( Contexte: String; D: TDataSet);
procedure Assure_D_is_TQuery_TBufDataSetTSQLQuery( Contexte: String; D: TDataSet);

function Copie_Champs( Source, Cible: TDataSet): Boolean;
function Copie_Champs_sans_controle_type( Source, Cible: TDataSet): Boolean;

function Assure_fkCalculated( Contexte: String; F: TField): Boolean;

function Create_ParamList_from_Query( D: TDataset): TBatpro_StringList;overload;

function IsPassword_Field( NomChamp: String): Boolean;

procedure Params_from_Strings( Ps: TParams; S:TStrings);


//Log SQL
type
 TRequete_Log_Entry
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  //Attributs
  private
    Nom: String;
    Debut: TDateTime;
    Fin  : TDateTime;
    Total: TDateTime;
  //Méthodes
  public
    NbAppels: Integer;
    procedure Start;
    procedure Stop;
    function  Log: String;
  end;
 TLog_SQL
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
    sl: TBatpro_StringList;
    slRequetes: TBatpro_StringList;
    NomFichier: String;
  //Méthodes
  public
    Actif: Boolean;
    procedure Log( S: String);
    function  LogQ( Q: TDataset): TRequete_Log_Entry;
  //Manipulation
  private
    procedure Vider;
    procedure Log_Statistiques;
  public
    procedure Start;
    procedure Stop;

    procedure Afficher;
  end;

var
   Log_SQL: TLog_SQL= nil;


function Table_exists( _sqlc: TDatabase; _NomTable: String): Boolean;

implementation

const
     s_Message_Echec_Requete
     =
      'L''exécution de la requête %s a échoué. '#13#10+
      'Classe de l''exception :'#13#10+
      '%s'#13#10+
      'Message de l''exception:'#13#10+
      '%s'#13#10+
      'Code de la requête :'#13#10+
      '%s'#13#10+
      'Paramètres :'#13#10;
     s_Message_Affichage_Requete
     =
      'Affichage de la requête %s : '#13#10+
      'Code de la requête :'#13#10+
      '%s'#13#10+
      'Source pour les paramètres :'#13#10+
      '%s'#13#10+
      'Paramètres :'#13#10+
      '%s'+
      'Champs:'#13#10+
      '%s';
     s_Indentation= '    ';

function IsPassword_Field( NomChamp: String): Boolean;
begin
     // G3_UTI mdp
     // G_PPL  mdp1, mdp2

     NomChamp:= UpperCase( NomChamp);
     Result:= Pos( 'MDP', NomChamp) = 1;
end;

function sRequestFailed( E: Exception; sRequete_NamePath, sSQL: String;
                         slParams: TBatpro_StringList=nil): String;
var
   smessage  ,
   sclassname: String;
   I: Integer;
begin

     if Assigned( E)
     then
         begin
         sclassname:= E.ClassName;
         smessage  := E.Message  ;
         end
     else
         begin
         sclassname:= sys_Vide;
         smessage  := sys_Vide;
         end;
     Result
     :=
       Format( s_Message_Echec_Requete,
               [ sRequete_NamePath,
                 Indente( s_Indentation, sclassname),
                 Indente( s_Indentation, smessage  ),
                 Indente( s_Indentation, sSQL)]);
     if Assigned( slParams)
     then
         for I:= 0 to slParams.Count - 1
         do
           Result:= Result+ Indente( s_Indentation, slParams[I])+#13#10;
end;

function String_from_FieldKind( fk: TFieldKind): String;
begin
     case fk
     of
       fkData        : Result:= 'Champ de données(fkData)';
       fkCalculated  : Result:= 'Champ calculé(fkCalculated)';
       fkLookup      : Result:= 'Champ obtenu par référence(fkLookup)';
       fkInternalCalc: Result:= 'Champ calculé interne(fkInternalCalc)';
       (*fkAggregate   : Result:= 'Champ composé(fkAggregate)';*)
       else
           Result:= Format('Champ TFieldKind(%d)', [Integer(fk)]);
       end;
end;

function String_from_FieldType( ft: TFieldType): String;
begin
     case ft
     of
       ftUnknown    : Result:= 'ftUnknown    ';
       ftString     : Result:= 'ftString     ';
       ftSmallint   : Result:= 'ftSmallint   ';
       ftInteger    : Result:= 'ftInteger    ';
       ftWord       : Result:= 'ftWord       ';
       ftBoolean    : Result:= 'ftBoolean    ';
       ftFloat      : Result:= 'ftFloat      ';
       ftCurrency   : Result:= 'ftCurrency   ';
       ftBCD        : Result:= 'ftBCD        ';
       ftDate       : Result:= 'ftDate       ';
       ftTime       : Result:= 'ftTime       ';
       ftDateTime   : Result:= 'ftDateTime   ';
       ftBytes      : Result:= 'ftBytes      ';
       ftVarBytes   : Result:= 'ftVarBytes   ';
       ftAutoInc    : Result:= 'ftAutoInc    ';
       ftBlob       : Result:= 'ftBlob       ';
       ftMemo       : Result:= 'ftMemo       ';
       ftGraphic    : Result:= 'ftGraphic    ';
       ftFmtMemo    : Result:= 'ftFmtMemo    ';
       ftParadoxOle : Result:= 'ftParadoxOle ';
       ftDBaseOle   : Result:= 'ftDBaseOle   ';
       ftTypedBinary: Result:= 'ftTypedBinary';
       ftCursor     : Result:= 'ftCursor     ';
       ftFixedChar  : Result:= 'ftFixedChar  ';
       ftWideString : Result:= 'ftWideString ';
       ftLargeint   : Result:= 'ftLargeint   ';
       ftADT        : Result:= 'ftADT        ';
       ftArray      : Result:= 'ftArray      ';
       ftReference  : Result:= 'ftReference  ';
       ftDataSet    : Result:= 'ftDataSet    ';
       ftOraBlob    : Result:= 'ftOraBlob    ';
       ftOraClob    : Result:= 'ftOraClob    ';
       ftVariant    : Result:= 'ftVariant    ';
       ftInterface  : Result:= 'ftInterface  ';
       ftIDispatch  : Result:= 'ftIDispatch  ';
       ftGuid       : Result:= 'ftGuid       ';
       ftTimeStamp  : Result:= 'ftTimeStamp  ';
       ftFMTBcd     : Result:= 'ftFMTBcd     ';
       else
           Result:= Format('FieldType(%d)', [Integer(ft)]);
       end;
end;

function sRequestDisplayStr( sRequete_NamePath, sSQL: String;
                             slParams: TBatpro_StringList;
                             D: TDataset;
                             MasterSource: String): String;
var
   I: Integer;
   sFieldKind, sDataType: String;
   sField: String;
   sParams, sFields: String;
begin
     sParams:= sys_Vide;
     for I:= 0 to slParams.Count - 1
     do
       sParams:= sParams+ Indente( s_Indentation, slParams[I])+#13#10;
     sFields:= sys_Vide;
     for I:= 0 to D.FieldCount - 1
     do
       begin
       sFieldKind:= String_from_FieldKind( D.Fields[I].FieldKind);
       sDataType := String_from_FieldType( D.Fields[I].DataType );

       sField:= D.Fields[I].FieldName+': '+sDataType+', '+sFieldKind;
       sFields:= sFields+ Indente( s_Indentation, sField)+#13#10;
       end;
     Result
     :=
       Format( s_Message_Affichage_Requete,
               [ sRequete_NamePath,
                 Indente( s_Indentation, sSQL),
                 MasterSource,
                 sParams,
                 sFields]);
end;

function sdm_from_Owner( C: TComponent): String;
var
   Owner: TComponent;
begin
     Owner:= C.Owner;
     if Assigned( Owner)
     then
         Result:= Owner.Name
     else
         Result:= sys_Vide;
end;

function NamePath_from_C( C: TComponent): String;
begin
     Result:= sdm_from_Owner( C) +'.'+ C.Name;
end;

function NamePath_from_Q( Q: TQuery): String;
begin
     Result:= NamePath_from_C( Q);
end;

procedure FormatParams( sl: TBatpro_StringList; p: TParams);
var
   I: Integer;
   pI_Name,
   pI_AsString: String;
begin
     for I:= 0 to p.Count-1
     do
       with p[I]
       do
         begin
         pI_Name:= Name;
         if IsPassword_Field( pI_Name)
         then
             pI_AsString:= '(mot de passe)'
         else
             pI_AsString:= AsString;
         sl.Add( pI_Name+'='+pI_AsString);
         end;
end;

function Create_ParamList_from_Query( Q: TQuery): TBatpro_StringList;overload;
begin
     Result:= TBatpro_StringList.Create;
     FormatParams( Result, Q.Params);
end;

function Create_ParamList_from_Query( SQLQ: TSQLQuery): TBatpro_StringList;overload;
begin
     Result:= TBatpro_StringList.Create;
     FormatParams( Result, SQLQ.Params);
end;

function Create_ParamList_from_Query( SD: TSimpleDataset): TBatpro_StringList;overload;
begin
     Result:= TBatpro_StringList.Create;
     FormatParams( Result, SD.Params);
end;

function Create_ParamList_from_Query( CD: TBufDataSet ): TBatpro_StringList;overload;
var
   D: TDataset;
   sl: TBatpro_StringList;
begin
     Result:= TBatpro_StringList.Create;
     (*FormatParams( Result, CD.Params);*)

     D:= Dataset_from_ClientDataset( CD);
     if Assigned( D)
     then
         begin
         Result.Add( '->provider->dataset "'+D.Name+'".Params:');
         sl:= Create_ParamList_from_Query( D);
         try
            Result.AddStrings( sl);
         finally
                Free_nil( sl);
                end;
         end;
end;

function Create_ParamList_from_Query( D: TDataset): TBatpro_StringList;overload;
begin
     if D is TQuery         then Result:=Create_ParamList_from_Query(TQuery        (D))
else if D is TSQLQuery      then Result:=Create_ParamList_from_Query(TSQLQuery     (D))
else if D is TSimpleDataset then Result:=Create_ParamList_from_Query(TSimpleDataset(D))
else if D is TBufDataSet  then Result:=Create_ParamList_from_Query(TBufDataSet (D))
else                             Result:=TBatpro_StringList.Create;
end;

procedure TraiteExceptionRequete( Q: TQuery; E: Exception; var Resultat: Boolean;
                                 _Afficher_Erreur: Boolean= True);overload;
var
   sdm: String;
   slParam: TBatpro_StringList;
begin
     sdm:= sdm_from_Owner( q);

     slParam:= Create_ParamList_from_Query( Q);
       if _Afficher_Erreur
       then
           fAccueil_Erreur( sRequestFailed(E,NamePath_from_Q(Q),QueryText( q),slParam),
                        'Erreur SGBD')
       else
           fAccueil_Log( sRequestFailed(E,NamePath_from_Q(Q),QueryText( q),slParam),
                        'Erreur SGBD');
     Free_nil( slParam);

     Resultat:= False;
end;

function sParametres_Connection( _d: TDatabase): String;
var
   sqlc: TSQLConnection;
begin
     if Affecte( sqlc, TSQLConnection, _d)
     then
         Result
         :=
            'Paramètres de connection:'#13#10
           +'HostName='+sqlc.HostName+#13#10
           +'DatabaseName='+sqlc.DatabaseName+#13#10
           +'UserName='+sqlc.UserName+#13#10
           +'Password='+sqlc.Password+#13#10
     else if Assigned(_d)
     then
         Result
         :=
            'Paramètres de connection:'#13#10
           +'DatabaseName='+_d.DatabaseName+#13#10
           +_d.Params.Text
     else 
         Result
         :=
            'Paramètres de connection:'#13#10
           +'  connection non affectée';
end;

procedure TraiteExceptionRequete( SQLQ: TSQLQuery; E: Exception; var Resultat: Boolean; sqlc: TDatabase=nil;
                                 _Afficher_Erreur: Boolean= True);overload;
var
   sdm: String;
   slParam: TBatpro_StringList;
   sqlc_Params_Text: String;
begin
     if sqlc = nil
     then
         sqlc:= SQLQ.DataBase;

     if sqlc = nil
     then
         sqlc_Params_Text:= '  connection non affectée, sqlc = nil'
     else
         sqlc_Params_Text:= sqlc.Params.Text;
     sdm:= sdm_from_Owner( SQLQ);

     slParam:= Create_ParamList_from_Query( SQLQ);
     if _Afficher_Erreur
     then
         fAccueil_Erreur(  sRequestFailed(E,NamePath_from_C(SQLQ),QueryText( SQLQ),slParam)+#13#10
                          +'Paramètres de connection:'#13#10
                          +sqlc_Params_Text,
                          'Erreur SGBD')
     else
         fAccueil_Log(  sRequestFailed(E,NamePath_from_C(SQLQ),QueryText( SQLQ),slParam)+#13#10
                        +'Paramètres de connection:'#13#10
                        +sqlc_Params_Text,
                        'Erreur SGBD');
     Free_nil( slParam);

     Resultat:= False;
end;

procedure TraiteExceptionRequete( sqlc: TDatabase; SQL: String; E: Exception; var Resultat: Boolean;
                                 _Afficher_Erreur: Boolean= True);overload;
var
   sdm: String;
begin
     sdm:= sdm_from_Owner( sqlc);

     if _Afficher_Erreur
     then
         fAccueil_Erreur(  sRequestFailed(E,NamePath_from_C(sqlc),SQL)+#13#10
                           +'Paramètres de connection:'#13#10
                           +sqlc.Params.Text,
                           'Erreur SGBD')
     else
         fAccueil_Log(  sRequestFailed(E,NamePath_from_C(sqlc),SQL)+#13#10
                       +'Paramètres de connection:'#13#10
                       +sqlc.Params.Text,
                       'Erreur SGBD');

     Resultat:= False;
end;

procedure TraiteExceptionRequete( SD: TSimpleDataset; E: Exception; var Resultat: Boolean;
                                 _Afficher_Erreur: Boolean= True);overload;
var
   sdm: String;
   slParam: TBatpro_StringList;
begin
     sdm:= sdm_from_Owner( SD);

     slParam:= Create_ParamList_from_Query( SD);
     if _Afficher_Erreur
     then
         fAccueil_Erreur( sRequestFailed(E,NamePath_from_C(SD),QueryText( SD),slParam),
                          'Erreur SGBD')
     else
         fAccueil_Log( sRequestFailed(E,NamePath_from_C(SD),QueryText( SD),slParam),
                          'Erreur SGBD');
     Free_nil( slParam);

     Resultat:= False;
end;

procedure TraiteExceptionRequete( CD: TBufDataSet; E: Exception; var Resultat: Boolean;
                                  _Afficher_Erreur: Boolean= True);overload;
var
   sdm: String;
   slParam: TBatpro_StringList;
   Message_Developpeur, Messag: String;
begin
     sdm:= sdm_from_Owner( CD);

     slParam:= Create_ParamList_from_Query( CD);
       Message_Developpeur
       :=
         sRequestFailed( E,NamePath_from_C(CD),
                                        QueryText( CD),
                                        slParam)+#13#10
         +'Paramètres de connection:'#13#10
         +ConnectionText( CD);
       Messag:= 'Erreur SGBD';
     Free_nil( slParam);

     if _Afficher_Erreur
     then
         fAccueil_Erreur( Message_Developpeur, Messag)
     else
         fAccueil_Log   ( Message_Developpeur, Messag);

     Resultat:= False;
end;

function TraiteExceptionRequete( D: TDataset; E: Exception; var Resultat: Boolean;
                                 _Afficher_Erreur: Boolean= True): Boolean;overload;
begin
     Result:= True;
     if D is TQuery         then TraiteExceptionRequete(TQuery        (D),E,Resultat,_Afficher_Erreur)
else if D is TSQLQuery      then TraiteExceptionRequete(TSQLQuery     (D),E,Resultat, nil, _Afficher_Erreur)
else if D is TSimpleDataset then TraiteExceptionRequete(TSimpleDataset(D),E,Resultat,_Afficher_Erreur)
else if D is TBufDataSet then TraiteExceptionRequete(TBufDataSet(D),E,Resultat,_Afficher_Erreur)
else                             Result:= False;
end;

function ChildByName( Owner: TComponent; Name: String): TComponent;
var
   I: Integer;
   C: TComponent;
begin
     Result:= nil;
     if Owner = nil then exit;
     for I:= 0 to Owner.ComponentCount-1
     do
       begin
       C:= Owner.Components[I];
       if Assigned( C)
       then
           if Name = C.Name
           then
               begin
               Result:= C;
               break;
               end;
       end;
end;

function Dataset_from_ClientDataset( CD: TBufDataSet ): TDataset;
var
   c: TComponent;
   (*p: TDatasetProvider;*)
begin
     Result:= nil;
     exit;
     (*c:= ChildByName( cd.Owner, cd.ProviderName);
     if not (c is TDataSetProvider) then exit;

     p:= TDataSetProvider( c);
     if p = nil then exit;

     Result:= p.DataSet;*)
end;

function SQLQuery_from_ClientDataset( CD: TBufDataSet ): TSQLQuery;
var
   D: TDataset;
begin
     Result:= nil;

     D:= Dataset_from_ClientDataset( CD);
     if D = nil            then exit;
     if not (D is TSQLQuery) then exit;

     Result:= TSQLQuery( D);
end;

function ClientDataset_QueryText( CD: TBufDataSet ): String;
var
   d: TDataset;
begin
     Result:= sys_Vide;

     d:= Dataset_from_ClientDataset( CD);
     if d = nil then exit;

     Result:= QueryText( D);
end;

function ClientDataset_ConnectionText( CD: TBufDataSet ): String;
var
   d: TDataset;
begin
     Result:= sys_Vide;

     d:= Dataset_from_ClientDataset( CD);
     if d = nil then exit;

     Result:= ConnectionText( D);
end;

function QueryText( D: TDataset): String;
begin
     if D is TQuery         then Result:=TQuery        (D).SQL.Text
else if D is TSQLQuery      then Result:=TSQLQuery     (D).SQL.Text
else if D is TSimpleDataset then Result:=TSimpleDataset(D).DataSet.CommandText
else if D is TBufDataSet  then Result:=ClientDataset_QueryText( TBufDataSet (D))
else                             Result:=sys_Vide;
end;

function ConnectionText( D: TDataset): String;
begin
     if D is TQuery         then Result:=sParametres_Connection(TQuery        (D).Database)
else if D is TSQLQuery      then Result:=sParametres_Connection(TSQLQuery     (D).DataBase)
else if D is TSimpleDataset then Result:=sParametres_Connection(TSimpleDataset(D).Connection)
else if D is TBufDataSet  then Result:=ClientDataset_ConnectionText( TBufDataSet (D))
else                             Result:=sys_Vide;
end;

function Requete_Log( Q: TDataset): String;
var
   sdm: String;
   slParam: TBatpro_StringList;
   Master_DataSource: TDataSource;
   Master_DataSet: TDataSet;
   sMasterSource: String;
begin
     sdm:= sdm_from_Owner( q);

     sMasterSource:= sys_Vide;
     Master_DataSource:= q.DataSource;
     if Assigned( Master_DataSource)
     then
         begin
         Master_DataSet:= Master_DataSource.DataSet;
         if Assigned( Master_DataSet)
         then
             sMasterSource:= NamePath_from_C( Master_DataSet);
         end;

     slParam:= Create_ParamList_from_Query( Q);
     try
        Result:= sRequestDisplayStr( NamePath_from_C(Q),
                                      QueryText( q),
                                      slParam,
                                      q,
                                      sMasterSource);
     finally
            Free_nil( slParam);
            end;
end;



{{ AfficheRequete_Interne
Affiche le contenu de la requete dans fAccueil avec les paramètres et
les champs
ErreurLog_ à True : on affiche comme message d'erreur
ErreurLog_ à False: on écrit juste dans fAccueil sans s'arrêter
}
function AfficheRequete_Interne( Q: TDataset; ErreurLog_: Boolean): Boolean;
var
   sMessage: String;
begin
     sMessage:= Requete_Log( Q);
     if ErreurLog_
     then
         fAccueil_Erreur( sMessage)
     else
         fAccueil_Log   ( sMessage);

     Result:= False;
end;

{{ AfficheRequete
Envoie le texte de la requête dans fAccueil en s'arrêtant
Appelle AfficheRequete_Interne.
}
function AfficheRequete( Q: TDataset): Boolean;
begin
     Result:= AfficheRequete_Interne( q, True);
end;

{{ LogRequete
Envoie le texte de la requête dans fAccueil sans s'arrêter
Appelle AfficheRequete_Interne.
}
function LogRequete( Q: TDataset): Boolean;
begin
     Result:= AfficheRequete_Interne( q, False);
end;

function SetQuery( Q: TQuery; QueryText: String): Boolean; overload;
begin
     Result:= False;
     with Q
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Close;
          SQL.Text:= QueryText;
          try
             Open;
             Result:= True;
          except
                on E: Exception
                do
                  TraiteExceptionRequete( Q, E, Result);
                end;
       finally
              //EnableControls;
              end;
end;

function SetSQLQuery( Q: TSQLQuery; QueryText: String): Boolean;
begin
     Result:= False;
     with Q
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Close;
          SQL.Text:= QueryText;
          try
             Open;
             Result:= True;
          except
                on E: Exception
                do
                  TraiteExceptionRequete( Q, E, Result);
                end;
       finally
              //EnableControls;
              end;
end;

function SetQuery( sqlq: TSQLQuery; cd: TBufDataSet ;QueryText: String): Boolean; overload;
begin
     Result:= False;
     with cd
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Close;
          sqlq.SQL.Text:= QueryText;
          try
             Open;
             Result:= True;
          except
                on E: Exception
                do
                  TraiteExceptionRequete( sqlQ, E, Result);
                end;
       finally
              //EnableControls;
              end;
end;

function RefreshQuery( Q: TQuery;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( Q);
         fAccueil_Log(
             Format( 'Appel de la procédure uDataUtils.RefreshQuery sur %s.%s',
                     [sdm, q.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( Q);

     with Q
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Close;
          try
             Open;
             if Assigned( rle) then rle.Stop;
             Result:= True;
          except
                on E: Exception//EDBEngineError
                do
                  begin
                  TraiteExceptionRequete( Q, E, Result, _Afficher_Erreur);
                  Close;
                  end;
                end;
       finally
              //EnableControls;
              end;
end;

function RefreshQuery( SQLQ: TSQLQuery;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( SQLQ);
         fAccueil_Log(
             Format( 'Appel de la procédure uDataUtils.RefreshQuery sur %s.%s',
                     [sdm, SQLQ.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( SQLQ);

     with SQLQ
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Close;
          try
             Open;
             if Assigned( rle) then rle.Stop;
             Result:= True;
          except
                on E: Exception//EDBEngineError
                do
                  begin
                  TraiteExceptionRequete( SQLQ, E, Result);
                  Close;
                  end;
                end;
       finally
              //EnableControls;
              end;
end;

function RefreshQuery( SD: TSimpleDataset;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( SD);
         fAccueil_Log(
             Format( 'Appel de la procédure uDataUtils.RefreshQuery sur %s.%s',
                     [sdm, SD.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( SD);

     with SD
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Close;
          try
             Open;
             if Assigned( rle) then rle.Stop;
             Result:= True;
          except
                on E: Exception//EDBEngineError
                do
                  begin
                  TraiteExceptionRequete( SD, E, Result);
                  Close;
                  end;
                end;
       finally
              //EnableControls;
              end;
end;

function RefreshQuery( CD: TBufDataSet;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( CD);
         fAccueil_Log(
             Format( 'Appel de la procédure uDataUtils.RefreshQuery sur %s.%s',
                     [sdm, CD.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( CD);

     with CD
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          Result:= False;
          try
             Poste( CD);
             if CD.ChangeCount > 0
             then
                 CD.ApplyUpdates( 0);
             if Assigned( rle) then rle.Stop;
          except
                on E: Exception//EDBEngineError
                do
                  begin
                  TraiteExceptionRequete( CD, E, Result, _Afficher_Erreur);
                  Close;
                  end;
                end;
          Close;
          try
             Open;
             Result:= True;
          except
                on E: Exception//EDBEngineError
                do
                  begin
                  TraiteExceptionRequete( CD, E, Result, _Afficher_Erreur);
                  Close;
                  end;
                end;
       finally
              //EnableControls;
              end;
end;

function RefreshQuery( D: TDataset;
                       _Afficher_Erreur: Boolean= True): Boolean; overload;
begin
          if D is TQuery         then Result:= RefreshQuery( TQuery        (D),_Afficher_Erreur)
     else if D is TSQLQuery      then Result:= RefreshQuery( TSQLQuery     (D),_Afficher_Erreur)
     else if D is TSimpleDataset then Result:= RefreshQuery( TSimpleDataset(D),_Afficher_Erreur)
     else if D is TBufDataSet then Result:= RefreshQuery( TBufDataSet(D),_Afficher_Erreur)
     else
         begin
         D.Close;
         Result:= Ouvre( D);
         end;
end;

function DatasetDetail_Update( D: TDataset): Boolean;
var
   sdm: String;
   Dsource: TDataset;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( D);
         fAccueil_Log(
             Format( 'Appel de la procédure uDataUtilsF.DatasetDetail_Update'+
                     ' sur %s.%s',
                     [sdm, D.Name])
                     );
         end;

     with D
     do
       try
          //DisableControls;// ok pour DisableControls / Evenements
          try
             if D is TBufDataSet 
             then
                 begin
                 Dsource:= Dataset_from_ClientDataset( TBufDataSet (D));
                 (*if Dsource is TSQLQuery
                 then
                     TSQLQuery( Dsource).Prepared:= False;*)
                 end;

             rle:= Log_SQL.LogQ( D);

             Close;
             Open;
             if Assigned( rle) then rle.Stop;
             Result:= True;
          except
                on E: Exception//EDBEngineError
                do
                  TraiteExceptionRequete( D, E, Result);
                end;
       finally
              //EnableControls;
              end;
end;

function ExecSQLQuery( Q: TQuery): Boolean; overload;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( Q);
         fAccueil_Log(
             Format( 'Appel de la procédure ExecSQLQuery sur %s.%s',
                     [sdm, q.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( Q);
     with Q
     do
       try
          ExecSQL;
          if Assigned( rle) then rle.Stop;
          Result:= True;
       except
             on E: Exception//EDBEngineError
             do
               TraiteExceptionRequete( Q, E, Result);
             end;
end;

function ExecSQLQuery( SQLQ: TSQLQuery): Boolean; overload;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( SQLQ);
         fAccueil_Log(
             Format( 'Appel de la procédure ExecSQLQuery sur %s.%s',
                     [sdm, SQLQ.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( SQLQ);

     with SQLQ
     do
       try
          ExecSQL;
          if Assigned( rle) then rle.Stop;
          Result:= True;
       except
             on E: Exception//EDBEngineError
             do
               TraiteExceptionRequete( SQLQ, E, Result);
             end;
end;

function ExecSQLQuery( Q: TQuery; QueryText: String): Boolean;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( Q);
         fAccueil_Log(
             Format( 'Appel de la procédure ExecSQLQuery sur %s.%s',
                     [sdm, q.Name])
                     );
         end;

     with Q
     do
       try
          Close;
          SQL.Text:= QueryText;
          rle:= Log_SQL.LogQ( Q);
          ExecSQL;
          if Assigned( rle) then rle.Stop;
          Result:= True;
       except
             on E: Exception//EDBEngineError
             do
               TraiteExceptionRequete( Q, E, Result);
             end;
end;

function ExecSQLQuery( SQLQ: TSQLQuery; QueryText: String): Boolean;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( SQLQ);
         fAccueil_Log(
             Format( 'Appel de la procédure ExecSQLQuery sur %s.%s',
                     [sdm, SQLQ.Name])
                     );
         end;

     with SQLQ
     do
       try
          Close;
          SQL.Text:= QueryText;
          rle:= Log_SQL.LogQ( SQLQ);
          ExecSQL;
          if Assigned( rle) then rle.Stop;
          Result:= True;
       except
             on E: Exception//EDBEngineError
             do
               TraiteExceptionRequete( SQLQ, E, Result);
             end;
end;

function ExecSQLQuery_db( Q: TQuery; DB: TDatabase): Boolean;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( Q);
         fAccueil_Log(
             Format( 'Appel de la procédure TDatabase.Execute sur %s.%s',
                     [sdm, q.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( Q);

     with Q
     do
       try
          (*DB.Execute( Q.SQL.Text);*)
          if Assigned( rle) then rle.Stop;
          Result:= True;
       except
             on E: Exception//EDBEngineError
             do
               TraiteExceptionRequete( Q, E, Result);
             end;
end;

function ExecSQLQuery_sqlc( SQLQ: TSQLQuery; sqlc: TSQLConnection): Boolean;
var
   sdm: String;
   rle: TRequete_Log_Entry;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( SQLQ);
         fAccueil_Log(
             Format( 'Appel de la procédure TSQLConnection.ExecuteDirect sur %s.%s',
                     [sdm, SQLQ.Name])
                     );
         end;

     rle:= Log_SQL.LogQ( SQLQ);
     with SQLQ
     do
       try
          sqlc.ExecuteDirect( SQLQ.SQL.Text);
          if Assigned( rle) then rle.Stop;
          Result:= True;
       except
             on E: Exception//EDBEngineError
             do
               TraiteExceptionRequete( SQLQ, E, Result, sqlc);
             end;
end;

function ExecQuery( sqlc: TSQLConnection; SQL: String): Boolean;
var
   sdm: String;
   FL: String;
   FinCommande: String;
   procedure ExecCommande( _Commande: String);
   begin
        with sqlc
        do
          try
             sqlc.ExecuteDirect( _Commande);
          except
                on E: Exception//EDBEngineError
                do
                  TraiteExceptionRequete( sqlc, _Commande, E, Result);
                end;
   end;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( sqlc);
         fAccueil_Log(
             Format( 'Appel de la procédure TDatabase.ExecuteDirect sur %s.%s',
                     [sdm, sqlc.Name])
                     );
         end;

     Log_SQL.Log( SQL);

     Result:= True;
     FL:= FinLigne( SQL);
     if FL = ''
     then
         ExecCommande( SQL)
     else
         begin
         FinCommande:= FL+';'+FL;
         repeat
               ExecCommande( StrToK( FinCommande, SQL));
         until SQL = '';
         end;
end;

function Ouvre_Database( db: TDatabase): Boolean;
var
   S, sdm: String;
begin
     sdm:= sdm_from_Owner( db);

     Result:= False;
     try
        if ModeDEBUG_1
        then
            begin
            fAccueil_Log( Format( 'Ouverture de la database %s.%s',
                                            [sdm, db.Name])
                                 );
            end;

        db.Connected:= True;
        Result:= True;
     except
           on E: Exception
           do
             begin

             S
             :=
               Format( 'L''ouverture de la database %s.%s à échoué'#13#10+
                       'Classe de l''exception :'#13#10+
                       s_Indentation+'%s'#13#10+
                       'Message de l''exception:'#13#10+
                       '%s'#13#10+
                       'Paramètres de la database:'#13#10+
                       'AliasName   : %s'#13#10+
                       'DatabaseName: %s (interne au source Delphi)'#13#10+
                       'DriverName  : %s'#13#10,
                       [ sdm, db.Name,
                         E.ClassName, Indente( s_Indentation, E.Message),
                         ''(*db.AliasName*), db.DatabaseName,''(*db.DriverName*)]
                      );


             fAccueil_Erreur( S, 'Echec de la connection au SGBD');
             end;
           end;
end;

function Ouvre_SQLConnection( sqlc: TDatabase;
                              _Afficher_Erreur: Boolean= True): Boolean;
var
   S, sdm: String;
begin
     sdm:= sdm_from_Owner( sqlc);

     Result:= False;
     try
        if ModeDEBUG_1
        then
            begin
            fAccueil_Log( Format( 'Ouverture de la SQLConnection %s.%s',
                                            [sdm, sqlc.Name])
                                 );
            end;
        sqlc.Connected:= True;
        Result:= True;
     except
           on E: Exception
           do
             begin

             S
             :=
               Format( 'L''ouverture de la SQLConnection %s.%s à échoué'#13#10+
                       'Classe de l''exception :'#13#10+
                       s_Indentation+'%s'#13#10+
                       'Message de l''exception:'#13#10+
                       '%s'#13#10+
                       'Paramètres de la SQLConnection:'#13#10+
                       'ConnectionName   : %s'#13#10+
                       'DriverName  : %s'#13#10+
                       'Paramètres  : '#13#10+
                       '%s',
                       [ sdm, sqlc.Name,
                         E.ClassName, Indente( s_Indentation, E.Message),
                         ''(*sqlc.ConnectionName*),
                         ''(*sqlc.DriverName*),
                         sqlc.Params.Text
                         ]
                      );

             if _Afficher_Erreur
             then
                 fAccueil_Erreur( S, 'Echec de la connection au SGBD')
             else
                 fAccueil_Log( S, 'Echec de la connection au SGBD');
             end;
           end;
end;

const
     s_Message_Echec_Ouverture
     =
      #13#10+
      'L''ouverture du DataSet %s a échoué. '#13#10+
      '%s';

function sOuvreFailed( E: Exception; sDataset: String): String;
var
   smessage: String;
begin
     if Assigned( E)
     then
         smessage:= E.Message
     else
         smessage:= '';
     Result
     :=
       Format( s_Message_Echec_Ouverture,
               [ sDataset, smessage]);
end;

function Ouvre( Dataset: TDataset): Boolean;
var
   sdm: String;
   DataSource: TDataSource;
   SourceDataset: TDataset;
begin
     if ModeDEBUG_1
     then
         begin
         sdm:= sdm_from_Owner( Dataset);
         fAccueil_Log(
             Format( 'Appel de la procédure uDataUtils.Ouvre sur %s.%s',
                     [sdm, Dataset.Name])
                     );
         end;

     DataSource:= Dataset.DataSource;

     if Assigned( DataSource)
     then
         begin
         SourceDataset:= DataSource.DataSet;
         if     Assigned( SourceDataset)
            and not SourceDataset.Active
         then
             begin
             Result:= Ouvre( SourceDataset);
             if not Result then exit;
             end;
         end;

     Result:= True;
     try
         //fAccueil_Log(
         //    Format( 'uDataUtils.Ouvre sur %s.%s',
         //            [sdm_from_Owner( Dataset), Dataset.Name])
         //            );
        Dataset.Active:= True;
     except
           on E: Exception
           do
             if not TraiteExceptionRequete( Dataset,E,Result)
             then
                 begin
                 fAccueil_Erreur( sOuvreFailed( E, Dataset.Name), 'Erreur SGBD');
                 Result:= False;
                 end;
           end;
end;

procedure Assure_D_is_TQuery( Contexte: String; D: TDataSet);
begin
     if not (D is TQuery)
     then
         uForms_ShowMessage( Format( 'Problème à signaler au développeur'#13#10+
                              '%s.%s est utilisé dans %s alors '#13#10+
                              'qu''il n''est pas de type TQuery.',
                              [ sdm_from_Owner(D),D.Name,Contexte]));
end;

procedure Assure_D_is_TQuery_TBufDataSet ( Contexte: String; D: TDataSet);
begin
     if D is TQuery then exit;

     if D is TBufDataSet 
     then
         if SQLQuery_from_ClientDataset( TBufDataSet (D)) <> nil
         then
             exit;

     uForms_ShowMessage( Format( 'Problème à signaler au développeur'#13#10+
                          '%s.%s est utilisé dans %s alors '#13#10+
                          'qu''il n''est pas de type TQuery.',
                          [ sdm_from_Owner(D),D.Name,Contexte]));
end;

procedure Assure_D_is_TQuery_TBufDataSetTSQLQuery( Contexte: String; D: TDataSet);
begin
     Assure_D_is_TQuery_TBufDataSet( Contexte, D);
end;

function Copie_Champs( Source, Cible: TDataSet): Boolean;
var
   I: Integer;
   FSource, FCible: TField;
   FieldName: String;
   TypeSource, TypeCible: String;
   TailleSource, TailleCible: Integer;
begin
     Result:= False;
     for I:= 0 to Source.FieldCount-1
     do
       begin
       FSource:= Source.Fields[I];
       FieldName:= FSource.FieldName;
       FCible := Cible.FindField( FieldName);
       if FCible = nil
       then
           begin
           fAccueil_Erreur( 'Erreur à signaler au développeur:'+sys_N+
                            'uDataUtilsF.Copie_Champs: le champ '+FieldName+
                            ' de la source n''a pas été trouvé dans la cible.',
                            'Erreur système');
           exit;
           end;

       TypeSource:= FSource.ClassName;
       TypeCible := FCible .ClassName;
       if TypeSource <> TypeCible
       then
           begin
           fAccueil_Erreur( 'Erreur à signaler au développeur:'+sys_N+
                            'uDataUtilsF.Copie_Champs: le champ '+FieldName+
                            ' est de type '+TypeSource+' dans la source et '+
                            'de type '+TypeCible+' dans la cible.',
                            'Erreur système');
           exit;
           end;

       TailleSource:= FSource.Size;
       TailleCible := FCible .Size;
       if TailleSource <> TailleCible
       then
           begin
           fAccueil_Erreur( 'Erreur à signaler au développeur'+sys_N+
                            'uDataUtilsF.Copie_Champs: le champ '+FieldName+
                            ' est de taille '+IntToStr(TailleSource)+' dans la source et '+
                            'de taille '+IntToStr(TailleCible)+' dans la cible.',
                            'Erreur système');
           exit;
           end;

       FCible.Value:= FSource.Value;
       end;
     Result:= True;
end;

function Copie_Champs_sans_controle_type( Source, Cible: TDataSet): Boolean;
var
   I: Integer;
   FSource, FCible: TField;
   FieldName: String;
   TypeSource, TypeCible: String;
   TailleSource, TailleCible: Integer;
begin
     Result:= False;
     for I:= 0 to Source.FieldCount-1
     do
       begin
       FSource:= Source.Fields[I];
       FieldName:= FSource.FieldName;

       FCible := Cible.FindField( FieldName);
       if FCible = nil
       then
           begin
           fAccueil_Erreur( 'Erreur à signaler au développeur:'+sys_N+
                            'uDataUtilsF.Copie_Champs_sans_controle_type: le champ '+FieldName+
                            ' de la source n''a pas été trouvé dans la cible.',
                            'Erreur système');
           exit;
           end;

       TypeSource:= FSource.ClassName;
       TypeCible := FCible .ClassName;
       if (TypeSource <> TypeCible)
          //and (not ((TypeSource = 'TBCDField'   )and(TypeCible= 'TFloatField')))
          and (not ((TypeSource = 'TBCDField'    )and(TypeCible = 'TFMTBCDField')))
          and (not ((TypeSource = 'TStringField' )and(TypeCible= 'TMemoField'   )))
          and (not ((TypeSource = 'TLongintField')and(TypeCible= 'TAutoIncField')))
          //and (not ((TypeSource = 'TFMTBCDField')and(TypeCible= 'TFloatField' )))
       then
           begin
           fAccueil_Erreur( 'Erreur à signaler au développeur:'+sys_N+
                            'uDataUtilsF.Copie_Champs_sans_controle_type: le champ '+FieldName+
                            ' est de type '+TypeSource+' dans la source et '+
                            'de type '+TypeCible+' dans la cible.',
                            'Erreur système');
           exit;
           end;


       if     (TypeCible <> 'TMemoField')
          and (TypeCible <> 'TBlobField')
       then
           begin
           TailleSource:= FSource.Size;
           TailleCible := FCible .Size;
           if     (TailleSource > TailleCible)
              //and (not ((TypeSource = 'TBCDField'   )and(TypeCible= 'TFloatField')))
              //and (not ((TypeSource = 'TFMTBCDField')and(TypeCible= 'TFloatField' )))
           then
               begin
               fAccueil_Erreur( 'Erreur à signaler au développeur'+sys_N+
                                'uDataUtilsF.Copie_Champs_sans_controle_type: le champ '+FieldName+
                                ' est de taille '+IntToStr(TailleSource)+' dans la source et '+
                                'de taille '+IntToStr(TailleCible)+' dans la cible.',
                                'Erreur système');
               exit;
               end;
           end;

       FCible.Value:= FSource.Value;
       end;
     Result:= True;
end;

function Assure_fkCalculated( Contexte: String; F: TField): Boolean;
begin
     Result:= False;

     if F = nil then exit;

     if F.FieldKind = fkCalculated
     then
         Result:= True
     else
         fAccueil_Erreur(  'Erreur à signaler au développeur au niveau de '
                          +Contexte+sys_N
                          +'   Le champ '+F.Name+','+F.FieldName+' de '+
                           NamePath_from_C(F.DataSet)+
                           ' n''est pas de type fkCalculated',
                           'Erreur système');
end;

procedure Params_from_Strings( Ps: TParams; S:TStrings);
var
   I: Integer;
   P: TParam;
   Key: String;
   J: Integer;
   procedure TraiteIndefini;
   begin
        P.AsString:= '';
   end;
   procedure TraiteChaine( _Value: String);
   begin
        P.AsString:= _Value;
   end;
   procedure TraiteDateTime( _Value: String);
   var
      D: TDateTime;
   begin
        D:= StrToDateTime( _Value);
        P.AsDateTime:= D;
   end;
   procedure TraiteDate( _Value: String);
   var
      D: TDateTime;
   begin
        D:= StrToDate( _Value);
        P.AsDate:= D;
   end;
   procedure TraiteType;
   var
      KeyType, ValueType, Typ: String;
   begin
        TraiteIndefini;

        KeyType:= ':'+Key;
        J:= s.IndexOfName( KeyType);
        if J = -1 then exit;

        ValueType:= S.ValueFromIndex[J];

        Typ:= LowerCase(StrToK(':', ValueType));
             if 'datetime' = Typ then TraiteDateTime( ValueType)
        else if 'date'     = Typ then TraiteDate    ( ValueType)
        else                          TraiteChaine  ( ValueType);
   end;
begin
     for I:= 0 to S.Count-1
     do
       S[I]:= TrimLeft( S[I]);

     for I:= 0 to Ps.Count-1
     do
       begin
       P:= Ps.Items[I];

       Key:= P.Name;
       J:= s.IndexOfName( Key);
       if J = -1
       then
           TraiteType
       else
           TraiteChaine( S.ValueFromIndex[J]);
       end;
end;

{ TLog_SQL }

constructor TLog_SQL.Create;
begin
     sl:= TBatpro_StringList.Create;
     slRequetes:= TBatpro_StringList.Create;
     Actif:= False;
     NomFichier
     :=
         uLog.Log.Repertoire
       + ChangeFileExt( ExtractFileName(ParamStr(0)),
                        '.'+NetWork.Nom_Hote+'.Log_SQL.txt');
end;

destructor TLog_SQL.Destroy;
begin
     Free_nil( sl);
     Free_nil( slRequetes);
     inherited;
end;

procedure TLog_SQL.Start;
begin
     Actif:= True;
     Vider;
end;

procedure TLog_SQL.Log_Statistiques;
var
   slStatistiques: TBatpro_StringList;
   I: Integer;
   rle: TRequete_Log_Entry;
begin
     slStatistiques:= TBatpro_StringList.Create;
     try
        for I:= 0 to slRequetes.Count-1
        do
          begin
          rle:= TRequete_Log_Entry( slRequetes.Objects[I]);
          if rle = nil then continue;

          slStatistiques.Add( rle.Log);
          end;

        slStatistiques.Sort;
        Log( 'Statistiques:'#13#10+slStatistiques.Text);
     finally
            Free_nil( slStatistiques);
            end;
end;

procedure TLog_SQL.Stop;
begin
     Log_Statistiques;
     Actif:= False;
end;

procedure TLog_SQL.Log( S: String);
begin
     if not Actif then exit;
     sl.Add( S);
     sl.SaveToFile( NomFichier);
end;

function TLog_SQL.LogQ( Q: TDataset): TRequete_Log_Entry;
var
   Nom: String;
   iNom: Integer;
begin
     Result:= nil;

     // 2011 06 01: en principe c'est impossible d'avoir Self = nil ici
     // mais le compilateur semble ne pas avoir lié dans le bon ordre
     // la partie initialization de cette unité, on y passe aprés être
     // passé une fois ici, lors d'un appel de dmDatabase pour ouvrir la connection.
     // Pile d'appels:
     //    TLog_SQL.LogQ
     //    RefreshQuery( CD: TBufDataSet )
     //    TdmDatabase.Ouvre_db
     //    TdmDatabase.DataModuleCreate
     //    Clean_Create
     //    udmDatabase initialization
     // Se produit même aprés plusieurs compilations complètes
     if Self = nil then exit;

     if not Actif then exit;

     Nom:= sdm_from_Owner( Q)+'.'+Q.Name;
     iNom:= slRequetes.IndexOf( Nom);
     if iNom = -1
     then
         begin
         Result:= TRequete_Log_Entry.Create( Nom);
         slRequetes.AddObject( Nom, Result);
         end
     else
         Result:= TRequete_Log_Entry( slRequetes.Objects[ iNom]);

     Result.Start;

     Log( Requete_Log( Q));
end;

procedure TLog_SQL.Vider;
begin
     sl.Clear;
     Vide_StringList( slRequetes);
     sl.SaveToFile( NomFichier);
end;

procedure TLog_SQL.Afficher;
begin
     Log_Statistiques;
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     ShowURL( Nomfichier);
     {$ENDIF}
end;

{ TRequete_Log_Entry }

constructor TRequete_Log_Entry.Create( _Nom: String);
begin
     Nom:= _Nom;
     Debut:= 0;
     Fin:= 0;
     Total:= 0;
     NbAppels:= 0;
end;

destructor TRequete_Log_Entry.Destroy;
begin

  inherited;
end;

procedure TRequete_Log_Entry.Start;
begin
     Debut:= Now;
     Fin:= Debut;
     Inc( NbAppels);
end;

procedure TRequete_Log_Entry.Stop;
begin
     Fin:= Now;
     Total:= Total + (Fin - Debut);
end;

function TRequete_Log_Entry.Log: String;
begin
     Result
     :=
        FormatDateTime( 'hh:nn:ss"."zzz", "', Total)
       +IntToStr( NbAppels)+' appels, '
       +Nom;
end;

function Table_exists( _sqlc: TDatabase; _NomTable: String): Boolean;
var
   sl: TStringList;
begin
     Result:= False;//################## A RECODER ###########################
     sl:= TStringList.Create;
     try

        //_sqlc.GetTableNames( sl);
        //Result:= -1 <> sl.IndexOf( _NomTable);
     finally
            Free_nil( sl);
            end;
end;

initialization
              Log_SQL:= TLog_SQL.Create;
finalization
              Free_nil( Log_SQL);
end.
