unit uDataUtilsU;
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
    uReels,
    uReal_Formatter,
    u_sys_,
    uuStrings,
    ufAccueil_Erreur,
  SysUtils, Classes, DB, TypInfo,
  FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.Controls,FMX.StdCtrls,
  FMX.ListBox,
  DBClient,Math, Types, DateUtils, Variants;

function Lettre_from_NumeroJour( I: Integer): String;
function Lettre_from_DateTime  ( D: TDateTime): String;

function DateSQL( D: TDateTime): String;
function DateSQL_sans_quotes( D: TDateTime): String;
function DateSQL_DMY4_Slash( D: TDateTime): String;
function DateSQL_DMY2_Slash( D: TDateTime): String;
function DateSQL_DMY4_Point( D: TDateTime): String;
function DateSQL_DMY2_Point( D: TDateTime): String;
function DateSQL_Y4MD_Tiret( D: TDateTime): String;
function DateSQL_ISO8601( D: TDateTime): String;

function DateSQL_Y4MD_To_Date( S: String): TDateTime;
function DateSQL_DMY4_sans_separateur( D: TDateTime): String;

function Annee_Semaine( D: TDateTime): String;
function Annee_Mois   ( D: TDateTime): String;

function Annee4_from_Annee2( Y2: Integer): Integer;
function TryDMY4ToDate( DMY4: String; out DT: TDateTime): Boolean;
function TryDMY2ToDate( DMY2: String; out DT: TDateTime): Boolean;
function TryDMYToDate( DMY: String; out DT: TDateTime): Boolean;

function DateTimeSQL( D: TDateTime): String;
function DateTimeSQL_sans_quotes( D: TDateTime): String;
function DateTime_ISO8601_sans_quotes( D: TDateTime): String;

function DateTimeSQL_sans_quotes_DMY2( D: TDateTime): String;
function DateTimeSQL_MySQL( D: TDateTime): String;

function IntervalSQL( Intervalle: TDateTime): String;
function IntervalSQL_sans_quotes( Intervalle: TDateTime): String;

function Edite( D: TDataSet): Boolean;

procedure Poste( D: TDataSet);

procedure Format_FloatField_0_0000( Sender: TField; var Text: String);
procedure Format_FloatField_0_000( Sender: TField; var Text: String);
procedure Format_FloatField_0_00 ( Sender: TField; var Text: String);
procedure Format_FloatField_0    ( Sender: TField; var Text: String);
procedure Format_FloatField_4_decimales( Sender: TField; var Text: String);
procedure Format_FloatField_Entier(Sender: TField; var Text: String);
procedure Format_FloatField      ( Sender: TField; var Text: String;
                                   Tronque: Boolean;
                                   Precision_par_defaut: Integer= 2;
                                   Aligner: Boolean = True);

procedure EditInsert( Dataset: TDataset; Fields: String; const Values: Variant);

procedure DateField_SetText( Sender: TField; const Text: String);

function Dataset_Owner_Name( D: TDataset): String;

procedure Set_F_OnChange( F: TField; OnChange: TFieldNotifyEvent);

procedure Set_D_AfterScroll( D: TDataset; AfterScroll: TDataSetNotifyEvent);

function Lundi_Precedent_ou_egal( uneDate: TDateTime): TDateTime;

function Lundi_Suivant_ou_egal( uneDate: TDateTime): TDateTime;

function DebutMois( uneDate: TDateTime): TDateTime;

function DebutMois_Suivant( uneDate: TDateTime): TDateTime;

function Year_from_Date( D: TDateTime): Word;

function Date_from_Year( Year: Word): TDateTime;

procedure Assure_DataSource( NomForme: String; C: TComponent; Defaut: TObject);
procedure Assure_Valeur_DataSource( NomForme: String; C: TComponent; Valeur: TObject);

procedure Assure_BeforeScroll( NomForme: String; C: TComponent);
procedure Assure_AfterScroll( NomForme: String; C: TComponent);

procedure Assure_Existence_Champs_Identiques( NomForme: String; DS1, DS2: TDataSet);


function Indente( _Texte: String; _Indentation: String; _Indenter_Debut: Boolean): String;
function IndenteWhere( _Texte: String): String;

//sans parentheses: ...Separateur...Separateur...
function SQL_Formate_Liste( S: array of String; Separateur: String): String;
function SQL_Formate_Liste_Sans_Blancs( S: array of String; Separateur: String): String;

function SQL_Virgule( S: array of String): String;
function SQL_IndexFieldNames( S: array of String): String;

//avec parentheses: (...)Separateur(...)Separateur(...)
function SQL_P_Formate_Liste( S: array of String; Separateur: String): String; overload;
procedure SQL_P_Formate_Liste( var SQL: String; Separateur, Element: String); overload;

function SQL_AND( S: array of String): String; overload;
procedure SQL_AND( var SQL: String; Element: String); overload;

function SQL_OR( S: array of String): String; overload;
procedure SQL_OR( var SQL: String; Element: String); overload;

function SQL_NOT( SQL: String): String;

//retourne vide si NomChamp ou Valeur vide
function SQL_MATCHES( NomChamp, Valeur:String):String;
//rajoute une étoile à la fin de Valeur
function SQL_MATCHES_Etoile( NomChamp, Valeur:String):String;

function SQL_Racine( NomChamp, Valeur:String):String;
procedure Value_to_Racine( var S: String; sNomChamp: String);

function SQL_Contient( NomChamp, Valeur:String):String;

//retourne vide si NomChamp ou Valeur vide
function SQL_OP( NomChamp, OP, Valeur:String):String;

//retourne vide si NomChamp ou Valeur vide
function SQL_EGAL( NomChamp, Valeur:String):String;
procedure Value_to_Constraint( var S: String; sNomChamp: String);

//retourne vide si NomChamp vide
function SQL_BETWEEN( NomChamp, Valeur1, Valeur2:String):String;

function SQL_REGEXP( NomChamp, Valeur:String):String;

function SQL_SIMILAR_TO( NomChamp, Valeur:String):String;

function SQL_BELONGS( NomChamp: String; _To: TStringDynArray): String;

//retourne vide si NomChamp ou Valeur vide
//spécial pour TDataset.Filter, comparaison partielle du type: State = 'M*'
function SQL_EGAL_DEBUT( NomChamp, Valeur:String):String;

function sConcat( var S: String; _Chaine: String; Separator: String;
                    sFormat: String=  ''): Integer;
function sfConcat( var S: String; sf: TStringField; Separator: String;
                    sFormat: String=  ''): Integer;

procedure TraiteParametre( var Parametres: String; Nom, Contrainte: String);
procedure TraiteParametreCI( var Tri, Parametres: String;
                             CI, LCI, NCI, O: String);

function StringField_from_FieldName( Query: TDataset; FieldName: String): TStringField;
function   DateField_from_FieldName( Query: TDataset; FieldName: String): TDateField;
function  FloatField_from_FieldName( Query: TDataset; FieldName: String): TFloatField;

//codé car TComponent.GetNamePath ne convient pas pour localiser dans le source
function NamePath( C: TComponent): String;

function MySQL_DateTime( F: TField; Defaut: TDateTime): TDateTime;

procedure Edit_Begin( D: TDataset; out EditStatus: Boolean);
procedure Edit_End  ( D: TDataset;     EditStatus: Boolean);

function Echappe_SQL( S: String): String;

procedure CopyLine( Source, Cible: TClientDataset);

{$IFNDEF FPC}
procedure ComboBox_from_Dataset( cb: TComboBox; ds: TDataset;
                                 FieldNames: array of String; Separator: String = '');
{$ENDIF}

function FormateChamp( Champ: TField; Longueur: Integer): String; overload;
function FormateChamp( Champ: TField): String; overload;

type
    TBlocTotalLibelle     = ( btl_Sans, btl_Court, btl_Long);
    TBlocTotalTailleValeur= ( bttv_20, bttv_DisplayFormat, bttv_Valeur);
function sBlocTotal_Commande( TypeLibelle: TBlocTotalLibelle;
                              TailleValeur: TBlocTotalTailleValeur;
                              HT: double;
                              TVA, TTC: double;
                              RTFascii_: Boolean;
                              Afficher_TVA_TTC: Boolean= True;
                              AutoLiquidationTVA: String= ''): String;
function BlocTotal_Commande( TypeLibelle: TBlocTotalLibelle;
                    TailleValeur: TBlocTotalTailleValeur;
                    HT: TField;
                    TVA, TTC: TNumericField;
                    RTFascii_: Boolean;
                    Afficher_TVA_TTC: Boolean= True;
                    AutoLiquidationTVA: String= ''): String;
function BlocTotal_Devis( TypeLibelle: TBlocTotalLibelle;
                    valeurHT_avant_multiplicateur,
                    valeurHT, valeurTVA, valeurTTC: String;
                    RTFascii_: Boolean;
                    Afficher_TVA_TTC: Boolean= True): String; overload;

function PourCent( Partie, Total: Double): Double;
function Partie( PourCent, Total: Double): Double;

function Arrondi_Arithmetique_   ( E: Double): Double;
function Arrondi_Arithmetique_0  ( E: Double): Double;
function Arrondi_Arithmetique_00 ( E: Double): Double;
function Arrondi_Arithmetique_000( E: Double): Double;

function Arrondi_quart_d_heure_inferieur( _NBHeures: double):double;
function Test_Arrondi_quart_d_heure_inferieur:String;

//créé pour récupérer la valeur des TAggregateField
//élargi à tous les TField "au cas où"
function FloatValue_from_Field( f: TField): Double;


function code_from_sexagesimal( n: Integer): Char;
// utilisé dans les générations de clés à partir de la date pour les tests
//retourne le caractère ascii 48+n
//pour n variant de 0 à 60 on tombe sur des caractère ne risquant pas trop
//d'interférer avec SQL

function Genere_Cle_11: String;
// utilisé pour les tests, génère une clé sur 11 caractères
// unique pour la milliseconde courante

function Genere_Cle_8: String;
// utilisé pour les tests, génère une clé sur 8 caractères
// unique pour la seconde courante

function Genere_Cle_6: String;
// utilisé pour les tests, génère une clé sur 6 caractères
// unique pour la seconde courante, pour l'année en cours

function sHeure( _NbHeures: double; ValeurZero: String= ''): String;
//retourne une chaine d'heure à partir d'une heure au format décimal

function sHeure_Secondes( _NbHeures: double; ValeurZero: String= ''): String;
//retourne une chaine d'heure à partir d'une heure au format décimal

function CreeParam( _Params: TParams; _ParamName: String): TParam;

implementation

function DateSQL_sans_quotes( D: TDateTime): String;
begin
     Result:= DateSQL_DMY2_Point( D);
end;

function DateTimeSQL_sans_quotes( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'yyyy-mm-dd hh:nn:ss', D);
end;

function DateTime_ISO8601_sans_quotes( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'yyyy"-"mm"-"dd"T"hh":"nn":"ss', D);
end;

function DateTimeSQL_sans_quotes_DMY2( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'dd-mm-yy hh:nn:ss', D);
end;

function IntervalSQL_sans_quotes( Intervalle: TDateTime): String;
var
   sJour: String;
   sHeure: String;
begin
     sJour := IntToStr      (             Trunc( Intervalle));
     sHeure:= FormatDateTime( 'hh:nn:ss', Frac ( Intervalle));
     Result:= Format( 'INTERVAL(%s %s) DAY TO SECOND',
                      [sJour, sHeure]);
end;

function DateSQL( D: TDateTime): String;
begin
     Result:= '"'+DateSQL_sans_quotes( D)+'"';
end;

function DateTimeSQL( D: TDateTime): String;
begin
     Result:= QuotedStr( DateTimeSQL_sans_quotes( D));
end;

function IntervalSQL( Intervalle: TDateTime): String;
begin
     Result:= QuotedStr( IntervalSQL_sans_quotes( Intervalle));
end;

function DateSQL_DMY2_Slash( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'dd"/"mm"/"yy', D)
end;

function DateSQL_DMY4_Slash( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'dd"/"mm"/"yyyy', D)
end;

function DateSQL_DMY4_Point( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'dd"."mm"."yyyy', D)
end;

function DateSQL_Y4MD_Tiret( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'yyyy"-"mm"-"dd', D)
end;

function DateSQL_ISO8601( D: TDateTime): String;
begin
     Result:= DateTime_ISO8601_sans_quotes( Int(D));
end;

function DateSQL_Y4MD_To_Date( S: String): TDateTime;
var
   sAnnee, sMois, sJour: String;
   Annee, Mois, Jour: Integer;
begin
     sAnnee:= StrReadString( S, 4);
              StrReadString( S, 1);//séparateur
     sMois:=  StrReadString( S, 2);
              StrReadString( S, 1);//séparateur
     sJour:=  StrReadString( S, 2);

     if not TryStrToInt( sAnnee, Annee) then Annee:= 0;
     if not TryStrToInt( sMois , Mois ) then Mois := 0;
     if not TryStrToInt( sJour , Jour ) then Jour := 0;

     try
        Result:= EncodeDate( Annee, Mois, Jour);
     except
           on EConvertError do Result:= 0;
           end;
end;

function DateSQL_DMY2_Point( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'dd"."mm"."yy', D)
end;

function DateSQL_DMY4_sans_separateur( D: TDateTime): String;
begin
     Result:= FormatDateTime( 'ddmmyyyy', D)
end;

function DateTimeSQL_MySQL( D: TDateTime): String;
begin
     Result:= DateTimeSQL_sans_quotes( D);
end;

function Lettre_from_NumeroJour( I: Integer): String;
begin
     case I mod 7
     of
       0: Result:= 'L';
       1: Result:= 'M';
       2: Result:= 'M';
       3: Result:= 'J';
       4: Result:= 'V';
       5: Result:= 'S';
       6: Result:= 'D';
       end;
end;

function Lettre_from_DateTime( D: TDateTime): String;
var
   I: Integer;
begin
     I:= DayOfWeek( D);
     case I
     of
       1: Result:= 'D';
       2: Result:= 'L';
       3: Result:= 'M';
       4: Result:= 'M';
       5: Result:= 'J';
       6: Result:= 'V';
       7: Result:= 'S';
       end;
end;

function Edite( D: TDataSet): Boolean;
begin
     Result:= not (D.State in [dsEdit, dsInsert]);
     if Result
     then
         D.Edit;
end;

procedure Poste( D: TDataSet);
begin
     if D.State in [dsEdit, dsInsert]
     then
         D.Post;
end;

procedure Edit_Begin( D: TDataset; out EditStatus: Boolean);
begin
     EditStatus:= Edite( D);
end;

procedure Edit_End  ( D: TDataset;     EditStatus: Boolean);
begin
     if EditStatus
     then
         Poste( D);
end;

procedure Format_FloatField( Sender: TField; var Text: String; Tronque: Boolean;
                             Precision_par_defaut: Integer= 2;
                             Aligner: Boolean = True);
var
   FF_DisplayFormat: String;
   FF_Value        : Double;
   FF_Currency     : Boolean;
   I: Integer;
   DisplayFormat: String;
   sPrecisionChar: Char;
   sPrecision: String;
   v: Variant;
   function Zero: Boolean;
   begin
        Result:= I > 0;
        if Result
        then
            Result:= Text[I] = '0';
   end;
   function Virgule: Boolean;
   begin
        Result:= I > 0;
        if Result
        then
            Result:= Text[I] = FormatSettings.DecimalSeparator;
   end;
   function Valeur_Zero: Boolean; //'  0   '
   begin
        Result:= I > 0;
        if Result
        then
            begin
            if I > 1
            then  // cas '+0', '-0', ' 0'
                Result:= Text[I-1] in ['+','-',' '];

            if Result
            then
                Result:= Text[I] = '0';
            end;
   end;
begin
     if Aligner
     then
         sPrecisionChar:= '0'
     else
         sPrecisionChar:= '#';

     sPrecision:= StringOfChar(sPrecisionChar,Precision_par_defaut);

          if Sender is TFloatField
     then
         begin
         FF_DisplayFormat:= TFloatField(Sender).DisplayFormat;
         FF_Value        := TFloatField(Sender).Value        ;
         FF_Currency     := TFloatField(Sender).Currency     ;
         end
     {$IFNDEF FPC}
     else if Sender is TAggregateField
     then
         begin
         FF_DisplayFormat:= TAggregateField(Sender).DisplayFormat;

         //2004 07 20 Delphi 7.0 build 4.453
         // TAggregateField(Sender).IsNull est bogué, il retourne null
         // systématiquement à la 2ème ligne même si l'on a une valeur
         v:= TAggregateField(Sender).Value;
         if VarIsNull( v)
         then
             FF_Value:= 0
         else
             FF_Value:= v;

         FF_Currency     := TAggregateField(Sender).Currency     ;
         end
	 {$ENDIF}
     else if Sender is TBCDField
     then
         begin
         FF_DisplayFormat:= TBCDField(Sender).DisplayFormat;
         FF_Value        := TBCDField(Sender).Value        ;
         FF_Currency     := TBCDField(Sender).Currency     ;
         end
     else if Sender is TFMTBCDField
     then
         begin
         FF_DisplayFormat:= TFMTBCDField(Sender).DisplayFormat;
         FF_Value        := TFMTBCDField(Sender).AsFloat      ;
         FF_Currency     := TFMTBCDField(Sender).Currency     ;
         end
     else
         begin
         uForms_ShowMessage( 'Erreur à signaler au développeur:                  '+sys_N+
                      'Appel de Format_FloatField sur un champ qui n''est '+sys_N+
                      'ni un TFloatField,                                 '+sys_N+
                      'ni un TAggregateField,                             '+sys_N+
                      'ni un TBCDField,                                   '+sys_N+
                      'ni un TFMTBCDField                                 '
                      );
         exit;
         end;

     DisplayFormat:= FF_DisplayFormat;
     if DisplayFormat = sys_Vide
     then
         DisplayFormat:= '###,###,###,##0.'+sPrecision;
     Text:= FormatFloat( DisplayFormat, FF_Value);
     I:= Length(Text);

     if Tronque //fait rapidement, redondant avec (not FF.currency)
     then
         if    (not FF_currency)     //On garde les 0 sur les valeurs monétaires
            or (Pos( FormatSettings.DecimalSeparator+sPrecision, Text) > 0)
         then
             if Pos( FormatSettings.DecimalSeparator, Text) > 0 //pas de tronquage
             then                                //si pas de virgule
                 begin
                 //Suppression des 0
                 while Zero
                 do
                   begin
                   Text[I]:= ' ';
                   Dec( I);
                   end;

                 // Suppression de la virgule orpheline, le cas échéant
                 if Virgule
                 then
                     begin
                     Text[I]:= ' ';
                     Dec( I);
                     end;
                 end;

     // Remplacement d'une valeur 0 par un vide
     if    Valeur_Zero
     then
         begin
         Text[I]:= ' ';
         //Dec( I);
         end;
     if FF_Value = 0
     then
         Text:= ' ';

end;

procedure Format_FloatField_0_000( Sender: TField; var Text: String);
begin
     Format_FloatField( Sender, Text, False, 3);
end;

procedure Format_FloatField_0_00( Sender: TField; var Text: String);
begin
     Format_FloatField( Sender, Text, False);
end;

procedure Format_FloatField_0   ( Sender: TField; var Text: String);
begin
     Format_FloatField( Sender, Text, True);
end;

procedure Format_FloatField_4_decimales( Sender: TField; var Text: String);
begin
     Format_FloatField( Sender, Text, True,4);
end;

procedure Format_FloatField_0_0000( Sender: TField; var Text: String);
begin
     Format_FloatField( Sender, Text, False,4);
end;

procedure Format_FloatField_Entier( Sender: TField; var Text: String);
begin
     Format_FloatField( Sender, Text, True, 0);
end;

procedure EditInsert( Dataset: TDataset; Fields: String; const Values: Variant);
begin
     if Dataset.Locate( Fields, Values, [])
     then
         Dataset.Edit
     else
         Dataset.Insert;
end;

procedure DateField_SetText( Sender: TField; const Text: String);
var
   DF: TDateField;
   S: String;
   I: Integer;
   function Point_Present: Boolean;
   begin
        I:= Pos( '.', S);
        Result:= I > 0;
   end;
begin
     DF:= Sender as TDateField;
     S:= Text;

          if Pos('.', S) > 0
     then//format xx.xx.xxxx
         begin
         while Point_Present
         do
           S[I]:= FormatSettings.DateSeparator
         end
     else if (Pos(FormatSettings.DateSeparator, S) = 0) and (Length( S) = 6)
     then//format ddmmyy
         begin
         Insert( FormatSettings.DateSeparator, S, 5);
         Insert( FormatSettings.DateSeparator, S, 3);
         end;

     DF.AsString:= S;
end;

function Dataset_Owner_Name( D: TDataset): String;
var
   Owner: TComponent;
begin
     Owner:= D.Owner;
     if Assigned( Owner)
     then
         Result:= Owner.Name
     else
         Result:= '';
end;

procedure Set_F_OnChange( F: TField; OnChange: TFieldNotifyEvent);
var
   D: TDataset;
begin
     if Assigned( F.OnChange)
     then
         begin
         D:= F.DataSet;
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '#13#10+
                              '  %s::%s'#13#10+
                              '  dataset %s'#13#10+
                              '    %s.OnChange <> nil',
                              [ ParamStr(0), Dataset_Owner_Name( D),
                                D.Name,
                                F.Name]));
         end
     else
         F.OnChange:= OnChange;

end;

procedure Set_D_AfterScroll( D: TDataset; AfterScroll: TDataSetNotifyEvent);
begin
     if Assigned( D.AfterScroll)
     then
         begin
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '#13#10+
                              '  %s::%s'#13#10+
                              '  dataset %s.AfterScroll <> nil',
                              [ ParamStr(0), Dataset_Owner_Name( D),
                                D.Name]));
         end
     else
         D.AfterScroll:= AfterScroll;

end;

function Lundi_Precedent_ou_egal( uneDate: TDateTime): TDateTime;
var
   DW: Integer;
begin
     // On ramène Date0 au lundi précédent (si ce n'est pas déjà un lundi)
     DW:= DayOfWeek( uneDate);

     DW:= DW - 2; //DayOfWeek: Lundi=2 , ici on veut Lundi = 0

     DW:= DW + 7; //préparation modulo
     DW:= DW mod 7;

     Result:= uneDate - DW;
end;

function Lundi_Suivant_ou_egal( uneDate: TDateTime): TDateTime;
begin
     Result:= Lundi_Precedent_ou_egal( uneDate);
     if Result <> uneDate
     then
         Result:= Result + 7;
end;

function DebutMois( uneDate: TDateTime): TDateTime;
var
   Year, Month, Day: Word;
begin
     DecodeDate( uneDate, Year, Month, Day);
     Day:= 1;
     Result:= EncodeDate( Year, Month, Day);
end;

function DebutMois_Suivant( uneDate: TDateTime): TDateTime;
var
   Year, Month, Day: Word;
begin
     DecodeDate( uneDate, Year, Month, Day);
     if Month = 12
     then
         begin
         Inc( Year);
         Month:= 1;
         end
     else
         Inc( Month);

     Day:= 1;
     Result:= EncodeDate( Year, Month, Day);
end;

function Year_from_Date( D: TDateTime): Word;
var
   Month, Day: Word;
begin
     DecodeDate( D, Result, Month, Day);
end;

function Date_from_Year( Year: Word): TDateTime;
begin
     Result:= EncodeDate( Year, 1, 1);
end;

function Assure_PropInfo(NomForme:String;C:TComponent;NomChamp:String):PPropInfo;
begin
     Result:= GetPropInfo( C.ClassInfo, NomChamp);
     if Result = nil
     then
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '#13#10+
                              '%s::%s'#13#10+
                              '%s.%s introuvable',
                              [ParamStr(0), NomForme, C.Name, NomChamp]));
end;

procedure Assure_TObject( NomForme: String; C: TComponent; NomChamp: String;
                          Defaut: TObject);
var
   PropInfo: PPropInfo;
   O: TObject;
begin
     PropInfo:= Assure_PropInfo( NomForme, C, NomChamp);
     if PropInfo = nil then exit;

     O:= GetObjectProp( C, PropInfo);

     if O = nil
     then
         begin
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '+sys_N+
                              '%s::%s'+sys_N+
                              '%s.%s = nil',
                              [ParamStr(0), NomForme, C.Name, NomChamp]));
         if Assigned( Defaut) //juste pour la sémantique
         then                 //SetObjectProp fonctionnerait même avec nil
             SetObjectProp( C, PropInfo, Defaut);
         end;
end;

procedure Assure_Valeur_TObject( NomForme: String; C: TComponent; NomChamp: String;
                                 Valeur: TObject);
var
   PropInfo: PPropInfo;
   O: TObject;
begin
     PropInfo:= Assure_PropInfo( NomForme, C, NomChamp);
     if PropInfo = nil then exit;

     O:= GetObjectProp( C, PropInfo);

     if O <> Valeur
     then
         begin
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '+sys_N+
                              '%s::%s'+sys_N+
                              '%s.%s n''a pas la bonne valeur',
                              [ParamStr(0), NomForme, C.Name, NomChamp]));
         SetObjectProp( C, PropInfo, Valeur);
         end;
end;

procedure Assure_TMethod( NomForme: String; C: TComponent; NomChamp: String);
var
   PropInfo: PPropInfo;
   M: TMethod;
   sNil: String;
begin
     PropInfo:= Assure_PropInfo( NomForme, C, NomChamp);
     if PropInfo = nil then exit;

     M:= GetMethodProp( C, PropInfo);

     sNil:= sys_Vide;
     if M.Code = nil
     then
         sNil:= Format( '%s.%s.Code = nil', [C.Name, NomChamp]);
     if M.Data= nil
     then
         begin
         if sNil <> sys_Vide then sNil:= sNil + sys_N;
         sNil:= sNil + Format( '%s.%s.Data = nil', [C.Name, NomChamp]);
         end;
     if sNil <> sys_Vide
     then
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '+sys_N+
                              '%s::%s'+sys_N+
                              '%s',
                              [ParamStr(0), NomForme, sNil]));
end;

procedure Assure_DataSource( NomForme: String; C: TComponent; Defaut: TObject);
begin
     Assure_TObject( NomForme, C, 'DataSource', Defaut);
end;

procedure Assure_Valeur_DataSource( NomForme: String; C: TComponent; Valeur: TObject);
begin
     Assure_Valeur_TObject( NomForme, C, 'DataSource', Valeur);
end;

procedure Assure_BeforeScroll( NomForme: String; C: TComponent);
begin
     Assure_TMethod( NomForme, C, 'BeforeScroll');
end;

procedure Assure_AfterScroll( NomForme: String; C: TComponent);
begin
     Assure_TMethod( NomForme, C, 'AfterScroll');
end;

procedure Assure_Existence_Champs_Identiques( NomForme: String; DS1, DS2: TDataSet);
var
   I, FieldCount1, FieldCount2: Integer;
   FieldName1, FieldName2: String;
begin
     FieldCount1:= DS1.FieldCount;
     FieldCount2:= DS2.FieldCount;

     if FieldCount1 <> FieldCount2
     then
         begin
         uForms_ShowMessage( Format( 'Problème à signaler au développeur: '#13#10+
                              '%s::%s'#13#10+
                              '%s et %s n''ont pas le même nombre de champs',
                              [ParamStr(0), NomForme, DS1.Name, DS2.Name]));
         exit;
         end;

     for I:= 0 to FieldCount1 - 1
     do
       begin
       FieldName1:= DS1.Fields[ I].FieldName;
       FieldName2:= DS2.Fields[ I].FieldName;
       if FieldName1 <> FieldName2
       then
           begin
           uForms_ShowMessage( Format( 'Problème à signaler au développeur: '#13#10+
                                '%s::%s'#13#10+
                                '%s et %s n''ont pas les mêmes champs:'#13#10+
                                '%d: %s <> %s',
                                [ ParamStr(0), NomForme,
                                  DS1.Name, DS2.Name,
                                  I, FieldName1, FieldName2]));
           exit;
           end;
       end;
end;

function Indente( _Texte: String; _Indentation: String; _Indenter_Debut: Boolean): String;
var
   I: Integer;
   iFin: Integer;
begin
     iFin:= Length( _Texte)-2; //minimum #13#10 + un caractère
     if iFin <= 0 then exit; //rien à indenter

     for I:= iFin downto 1
     do
       begin
       if    (_Texte[I  ]=#13)
          and(_Texte[I+1]=#10)
       then
           Insert( _Indentation, _Texte, I+2);
       end;
     if _Indenter_Debut
     then
         Insert( _Indentation, _Texte, 1);
     Result:= _Texte;
end;

function IndenteWhere( _Texte: String): String;
begin
     Result:= Indente( _Texte, Espaces(Length('where')), True);
end;

procedure SQL_Formate_Liste_Interne( var SQL: String;
                                     Separateur, Element: String;
                                     bParentheses: Boolean;
                                     bSans_Blancs: Boolean = False); overload;
var
   Indentation_Separateur: String;
begin
     if bSans_Blancs
     then
         Element:= TrimRight( Element);
     if Element <> sys_Vide
     then
         begin
         Indentation_Separateur:= Espaces(Length( Separateur));
         if SQL = sys_Vide
         then
             SQL:= Indentation_Separateur
         else
             begin
             SQL:= SQL + #13#10 + Separateur;
             end;
         if bParentheses
         then
             Element:= Parentheses( Element);
         if Pos(#10, Element) <> 0
         then
             begin
             SQL:= SQL + #13#10;
             Element:= Indente( Element, Indentation_Separateur, True);
             end;
         SQL:= SQL + Element;
         end;
end;

function SQL_Formate_Liste_Interne( S: array of String;
                                    Separateur: String;
                                    bParentheses: Boolean;
                                    bSans_Blancs: Boolean = False): String; overload;
var
   I: Integer;
begin
     Result:= sys_Vide;
     if Length( S) = 0 then exit;

     for I:= Low(S) to High( S)
     do
       SQL_Formate_Liste_Interne( Result, Separateur, S[I], bParentheses, bSans_Blancs);
end;

function SQL_Formate_Liste( S: array of String; Separateur: String): String;
begin
     Result:= SQL_Formate_Liste_Interne( S, Separateur, False);
end;

function SQL_Formate_Liste_Sans_Blancs( S: array of String; Separateur: String): String;
begin
     Result:= SQL_Formate_Liste_Interne( S, Separateur, False, True);
end;

function SQL_Virgule( S: array of String): String;
begin
     Result:= SQL_Formate_Liste( S, ', ');
end;

function SQL_IndexFieldNames( S: array of String): String;
begin
     Result:= SQL_Formate_Liste( S, ';');
end;

function SQL_P_Formate_Liste( S: array of String; Separateur: String): String;
begin
     Result:= SQL_Formate_Liste_Interne( S, Separateur, True);
end;

procedure SQL_P_Formate_Liste( var SQL: String; Separateur, Element: String);
begin
     SQL_Formate_Liste_Interne( SQL, Separateur, Element, True);
end;

function SQL_AND( S: array of String): String;
begin
     Result:= SQL_P_Formate_Liste( S, ' AND ');
end;

procedure SQL_AND( var SQL: String; Element: String);
begin
     SQL_P_Formate_Liste( SQL, ' AND ', Element);
end;

function SQL_OR( S: array of String): String;
begin
     Result:= SQL_P_Formate_Liste( S, ' OR ');
end;

procedure SQL_OR( var SQL: String; Element: String);
begin
     SQL_P_Formate_Liste( SQL, ' OR ', Element);
end;

function SQL_NOT( SQL: String): String;
const
     sDebut= 'NOT ( ';
     sFin  = ')';
begin
     Result:= '';
     if SQL = '' then exit;

     if Pos( #10, SQL) = 0
     then
         Result:= sDebut+ SQL+sFin
     else
         begin
         Result:= SQL+#13#10+sFin;
         Result:= Indente( Result, Espaces(Length(sDebut)), True);
         Result:= sDebut+#13#10+Result;
         end;
end;

function SQL_MATCHES( NomChamp, Valeur:String):String;
begin
     Result:= sys_Vide;

     if NomChamp = sys_Vide then exit;
     if   Valeur = sys_Vide then exit;

     Result:= Format( '(%s MATCHES %s)',
                      [ NomChamp, QuotedStr(Valeur)]);
end;

function SQL_MATCHES_Etoile( NomChamp, Valeur:String):String;
begin
     Result:= sys_Vide;
     if NomChamp = sys_Vide then exit;
     if   Valeur = sys_Vide then exit;

     Result:= SQL_MATCHES( NomChamp, Valeur+'*');
end;

function SQL_OP( NomChamp, OP, Valeur:String):String;
begin
     Result:= sys_Vide;

     if NomChamp = sys_Vide then exit;
     if OP       = sys_Vide then exit;
     if Valeur   = sys_Vide then exit;

     Result:= Format( '(%s %s %s)', [ NomChamp, OP, QuotedStr(Valeur)]);
end;

function SQL_Racine( NomChamp, Valeur:String):String;
begin
     if '' = Valeur
     then
         Result:= ''   // sinon en mysql, si le champ est à null la ligne n'est pas retournée
     else
         Result:= SQL_OP( NomChamp, 'LIKE', Echappe_SQL( Valeur)+'%');
end;

function SQL_Contient( NomChamp, Valeur:String):String;
begin
     if '' = Valeur
     then
         Result:= ''   // sinon en mysql, si le champ est à null la ligne n'est pas retournée
     else
         Result:= SQL_OP( NomChamp, 'LIKE', '%'+Echappe_SQL( Valeur)+'%');
end;

procedure Value_to_Racine( var S: String; sNomChamp: String);
begin
     S:= SQL_Racine( sNomChamp, S);
end;

function SQL_REGEXP( NomChamp, Valeur:String):String;
begin
     Result:= SQL_OP( NomChamp, 'REGEXP', Valeur);
end;

function SQL_SIMILAR_TO( NomChamp, Valeur:String):String;
begin
     Result:= SQL_OP( NomChamp, 'SIMILAR TO', Valeur);
end;

function SQL_EGAL( NomChamp, Valeur:String):String;
begin
     Result:= SQL_OP( NomChamp, '=', Valeur);
end;

procedure Value_to_Constraint( var S: String; sNomChamp: String);
begin
     S:= SQL_EGAL( sNomChamp, S);
end;

function SQL_EGAL_DEBUT( NomChamp, Valeur:String):String;
begin
     if Valeur = sys_Vide
     then
         Result:= sys_Vide
     else
         Result:= SQL_EGAL( NomChamp, Valeur+'*');
end;

function SQL_BETWEEN( NomChamp, Valeur1, Valeur2:String):String;
begin
     Result:= sys_Vide;

     if NomChamp = sys_Vide then exit;

     Result:= Format( '(%s BETWEEN %s AND %s)',
                      [ NomChamp, QuotedStr(Valeur1), QuotedStr(Valeur2)]);
end;

function SQL_BELONGS( NomChamp: String; _To: TStringDynArray): String;
var
   I: Integer;
begin
     Result:= sys_Vide;
     if NomChamp = sys_Vide then exit;

     for I:= Low( _To) to High( _To)
     do
       begin
       if Result <> sys_Vide
       then
           Result:= Result + ' OR ';
       Result:= Result + SQL_EGAL( NomChamp, _To[ I]);
       end;
end;

function sConcat( var S: String; _Chaine: String; Separator: String;
                    sFormat: String=  ''): Integer;
var
   Value: String;
   S_pas_vide: Boolean;
begin
     Result:= 0;
     Value:= TrimRight( _Chaine);

     if Value <> sys_Vide
     then
         begin
         S_pas_vide:= S <> sys_Vide;
         if Value = '.'
         then
             begin
             Value:= ' ';// à surveiller
                         // ajouté pour gérer le code '.' sur F5_TEXTE
                         // mais peut potentiellement poser
                         // des problèmes ailleurs.
             if Separator = sys_Vide
             then
                 Separator:= sys_N;
             end;

         if Separator = sys_Vide
         then
             begin
             Separator:= ' ';
             if S_pas_vide
             then
                 Result:= 0
             else
                 Result:= 1;
             end
         else
             Result:= 1;

         if S_pas_vide
         then
             S:= S + Separator;

         if sFormat <> sys_Vide
         then
             Value:= Format( sFormat, [ Value]);

         S:= S + Value;
         end;
end;

{ sfConcat
Ajoute à la chaine S, la valeur de sf formatée par sFormat et
préfixée du séparateur.
Retourne le nombre d'éléments ajoutés.
}
function sfConcat( var S: String; sf: TStringField; Separator: String;
                    sFormat: String=  ''): Integer;
begin
     Result:= 0;
     if sf = nil then exit;

     Result:= sConcat( S, sf.Value, Separator, sFormat);
end;

procedure TraiteParametre( var Parametres: String; Nom, Contrainte: String);
begin
     if Contrainte <> sys_Vide
     then
         begin
         if Parametres <> sys_Vide
         then
             Parametres:= Parametres + sys_N;
         Parametres:= Parametres+ Nom + ' : '+ Contrainte;
         end;
end;

procedure TraiteParametreCI( var Tri, Parametres: String;
                             CI, LCI, NCI, O: String);
begin
     if O <> sys_Vide
     then
         begin
         if Tri <> sys_Vide then Tri:= Tri + ', ';
         Tri:= Tri + LCI;
         end;
     if CI <> sys_Vide
     then
         begin
         if Parametres <> sys_Vide
         then
             Parametres:= Parametres + sys_N;
         Parametres:= Parametres+ LCI;
         end;
end;

function StringField_from_FieldName( Query: TDataset; FieldName: String): TStringField;
var
   f: TField;
begin
     Result:= nil;

     f:= Query.FindField( FieldName);
     if f = nil then exit;

     Result:= f as TStringField;//génère une exception si pas StringField
end;

function   DateField_from_FieldName( Query: TDataset; FieldName: String): TDateField;
var
   f: TField;
begin
     Result:= nil;

     f:= Query.FindField( FieldName);
     if f = nil then exit;

     Result:= f as TDateField;
end;

function   FloatField_from_FieldName( Query: TDataset; FieldName: String): TFloatField;
var
   f: TField;
begin
     Result:= nil;

     f:= Query.FindField( FieldName);
     if f = nil then exit;

     Result:= f as TFloatField;
end;

function NamePath( C: TComponent): String;
begin
     Result:= sys_Vide;

     while Assigned( C)
     do
       begin
       if Result <> sys_Vide
       then
           Result:= '.' + Result;

       Result:= C.Name+Result;

       C:= C.Owner;
       end;
end;

function MySQL_DateTime( F: TField; Defaut: TDateTime): TDateTime;
var
   Data: Cardinal;
   Zero: Boolean;

   sD: String;
   D: TDateTime;
begin
     Zero:= False;
          if F is TStringField
     then
         begin
         sD:= F.AsString;
         Zero:= sD = sys_Vide;
         if not Zero
         then
             Zero:= TryStrToDateTime( sD, D);
         end
     else if F is TDateField
     then
         if SizeOf(Data) = F.Datasize
         then
             if F.GetData( @Data)
             then
                 if Data = 0
                 then
                     Zero:= True;
     if Zero
     then
         Result:= Defaut
     else
         Result:= F.AsDateTime;
end;

function Echappe_SQL( S: String): String;
var
   I: Integer;
   procedure c( Traduction: String);
   begin
        Result:= Result + Traduction;
   end;
begin    // d'aprés doc de MySQL 4.0
     Result:= sys_Vide;
     for I:= 1 to Length( S)
     do
       case S[I]
       of
         //\0 An ASCII 0 (NUL) character.
         #0: c( '\0');

         //\' A single quote (') character.
         '''': c('\''');

         //\" A double quote (") character.
         '"': c('\"');

         //\b A backspace character.
         //\n A newline character.
         //\r A carriage return character.
         //\t A tab character.
         //\z ASCII(26) (Control-Z).  This character can be encoded to allow
         //   you to go around the problem that ASCII(26) stands for
         //   END-OF-FILE on Windows.  (ASCII(26) will cause problems if you
         //   try to use mysql database < filename.)

         //\\ A backslash (\) character.
         '\': c('\\');

         //\% A % character. This is used to search for literal instances
         //   of % in contexts where % would otherwise be interpreted as a
         //   wild-card character. See String comparison functions.
         '%': c('\%');

         //\_ A _ character. This is used to search for literal instances
         //   of _ in contexts where _ would otherwise be interpreted as
         //   a wild-card character. See String comparison functions.
         '_': c('\_');

         '*': c('\*');// rajouté pour le MATCHES d'Informix

         else c( S[I]);
         end;
end;

procedure CopyLine( Source, Cible: TClientDataset);
var
   I: Integer;
   FSource, FCible: TField;
   V: Variant;
   S: String;
begin
     for I:= 0 to Source.FieldCount-1
     do
       begin
       FSource:= Source.Fields[ I];
       FCible := Cible .FieldByName( FSource.FieldName);

       if FCible.DataType = FSource.DataType
       then
           begin
           V:= FSource.Value;
           if FCible.Value <> V
           then
               FCible.Value:= V;
           end
       else
           begin
           S:= FSource.AsString;
           if FCible.AsString <> S
           then
               FCible.AsString:= S;
           end;
       end;
end;

{$IFNDEF FPC}
procedure ComboBox_from_Dataset( cb: TComboBox; ds: TDataset;
                                 FieldNames: array of String; Separator: String = '');
var
   I: Integer;
   FieldName: String;
   Value: String;
begin
     cb.Clear;
     ds.First;
     while not ds.Eof
     do
       begin
       Value:= sys_Vide;
       for I:= Low( FieldNames) to High( FieldNames)
       do
         begin
         FieldName:= FieldNames[ I];

         if Value <> sys_Vide then Value:= Value + Separator;
         Value:= Value + ds.FieldByName( FieldName).AsString;
         end;
       if Value = sys_Vide then Value:= ' ';

       cb.Items.Add( Value);

       ds.Next;
       end;
end;
{$ENDIF}

function FormateChaine( S: String; Longueur: Integer): String;
var
   sLongueur: String;
begin
     Result:= '';
     if S = '' then exit;

     sLongueur:= IntToStr( Longueur);
     Result:= Format( '%'+sLongueur+'s', [ S]);
end;

function FormateChamp( Champ: TField; Longueur: Integer): String; overload;
begin
     FormateChaine( Champ.DisplayText, Longueur);
end;

function FormateChamp( Champ: TField): String; overload;
var
   L: Integer;
begin
{$IFNDEF FPC}
     if Champ is TAggregateField then L:=Length(TAggregateField(Champ).DisplayFormat)
else
{$ENDIF}
     if Champ is TNumericField   then L:=Length(TNumericField  (Champ).DisplayFormat)
else                                  L:=0;

     if L = 0 then L:= 20;

     Result:= FormateChamp( Champ, L);
end;

function sBlocTotal_Commande( TypeLibelle: TBlocTotalLibelle;
                              TailleValeur: TBlocTotalTailleValeur;
                              HT: double;
                              TVA, TTC: double;
                              RTFascii_: Boolean;
                              Afficher_TVA_TTC: Boolean= True;
                              AutoLiquidationTVA: String= ''): String;
var
   libelleHT, libelleTVA, libelleTTC: String;
   valeurHT, valeurTVA, valeurTTC: String;
   ligneHT, ligneTVA, ligneTTC: String;
   Separateur: String;
   L: Integer;
   procedure Formate_valeurs;
   begin
        valeurHT := FormateChaine( valeurHT , L);
        valeurTVA:= FormateChaine( valeurTVA, L);
        valeurTTC:= FormateChaine( valeurTTC, L);
   end;
begin
     if RTFascii_
     then
         Separateur:= '\par ' //\par = saut de ligne en RTF pour TRichEdit
     else
         Separateur:= sys_CR_NL;//convient pour les paramètres OpenOffice
                                // mais pas dans les tableaux

     case TypeLibelle
     of
       btl_Sans :
         begin
         libelleHT := sys_Vide;
         libelleTVA:= sys_Vide;
         libelleTTC:= sys_Vide;
         end;
       btl_Court:
         begin
         libelleHT := 'HT ';
         libelleTVA:= 'TVA';
         libelleTTC:= 'TTC';
         end;
       btl_Long :
         begin
         libelleHT := 'TOTAL HT   ';
         libelleTVA:= 'MONTANT TVA';
         libelleTTC:= 'TOTAL TTC  ';
         end;
       else
         begin
         libelleHT := sys_Vide;
         libelleTVA:= sys_Vide;
         libelleTTC:= sys_Vide;
         end;
       end;

     if btl_Sans = TypeLibelle
     then
         begin
         ligneHT := Format_Float( HT );
         ligneTVA:= Format_Float( TVA);
         ligneTTC:= Format_Float( TTC);
         end
     else
         begin
         case TailleValeur
         of
           bttv_20:
             begin
             valeurHT := Trim( Format_Float( HT ));
             valeurTVA:= Trim( Format_Float( TVA));
             valeurTTC:= Trim( Format_Float( TTC));
             L:= 20;
             Formate_valeurs;
             end;
           bttv_DisplayFormat:
             begin
             valeurHT := FormateChaine( Format_Float( HT ),20);
             valeurTVA:= FormateChaine( Format_Float( TVA),20);
             valeurTTC:= FormateChaine( Format_Float( TTC),20);
             end;
           bttv_Valeur:
             begin
             valeurHT := Trim( Format_Float( HT ));
             valeurTVA:= Trim( Format_Float( TVA));
             valeurTTC:= Trim( Format_Float( TTC));
             L:= Max(Max(Length(valeurHT),Length(valeurTVA)),Length(valeurTTC));
             Formate_valeurs;
             end;
           else
             begin
             valeurHT := Format_Float( HT );
             valeurTVA:= Format_Float( TVA);
             valeurTTC:= Format_Float( TTC);
             end;
           end;

         ligneHT := Formate_Affichage( libelleHT , valeurHT );
         if AutoLiquidationTVA = ''
         then
             ligneTVA:= Formate_Affichage( libelleTVA, valeurTVA)
         else
             ligneTVA:= AutoLiquidationTVA;
         ligneTTC:= Formate_Affichage( libelleTTC, valeurTTC);
         end;

     if Afficher_TVA_TTC
     then
         Result:= Formate_Liste( [ ligneHT, ligneTVA, ligneTTC], Separateur)
     else
         Result:= Formate_Liste( [ ligneHT], Separateur)
end;

function BlocTotal_Commande( TypeLibelle: TBlocTotalLibelle;
                             TailleValeur: TBlocTotalTailleValeur;
                             HT: TField;
                             TVA, TTC: TNumericField;
                             RTFascii_: Boolean;
                             Afficher_TVA_TTC: Boolean= True;
                             AutoLiquidationTVA: String= ''): String;
var
   libelleHT, libelleTVA, libelleTTC: String;
   valeurHT, valeurTVA, valeurTTC: String;
   ligneHT, ligneTVA, ligneTTC: String;
   Separateur: String;
   L: Integer;
   procedure Formate_valeurs;
   begin
        valeurHT := FormateChaine( valeurHT , L);
        valeurTVA:= FormateChaine( valeurTVA, L);
        valeurTTC:= FormateChaine( valeurTTC, L);
   end;
begin
     if RTFascii_
     then
         Separateur:= '\par ' //\par = saut de ligne en RTF pour TRichEdit
     else
         Separateur:= sys_CR_NL;//convient pour les paramètres OpenOffice
                                // mais pas dans les tableaux

     case TypeLibelle
     of
       btl_Sans :
         begin
         libelleHT := sys_Vide;
         libelleTVA:= sys_Vide;
         libelleTTC:= sys_Vide;
         end;
       btl_Court:
         begin
         libelleHT := 'HT ';
         libelleTVA:= 'TVA';
         libelleTTC:= 'TTC';
         end;
       btl_Long :
         begin
         libelleHT := 'TOTAL HT   ';
         libelleTVA:= 'MONTANT TVA';
         libelleTTC:= 'TOTAL TTC  ';
         end;
       else
         begin
         libelleHT := sys_Vide;
         libelleTVA:= sys_Vide;
         libelleTTC:= sys_Vide;
         end;
       end;

     if btl_Sans = TypeLibelle
     then
         begin
         ligneHT := HT .DisplayText;
         ligneTVA:= TVA.DisplayText;
         ligneTTC:= TTC.DisplayText;
         end
     else
         begin
         case TailleValeur
         of
           bttv_20:
             begin
             valeurHT := Trim( HT .DisplayText);
             valeurTVA:= Trim( TVA.DisplayText);
             valeurTTC:= Trim( TTC.DisplayText);
             L:= 20;
             Formate_valeurs;
             end;
           bttv_DisplayFormat:
             begin
             valeurHT := FormateChamp( HT );
             valeurTVA:= FormateChamp( TVA);
             valeurTTC:= FormateChamp( TTC);
             end;
           bttv_Valeur:
             begin
             valeurHT := Trim( HT .DisplayText);
             valeurTVA:= Trim( TVA.DisplayText);
             valeurTTC:= Trim( TTC.DisplayText);
             L:= Max(Max(Length(valeurHT),Length(valeurTVA)),Length(valeurTTC));
             Formate_valeurs;
             end;
           else
             begin
             valeurHT := HT .DisplayText;
             valeurTVA:= TVA.DisplayText;
             valeurTTC:= TTC.DisplayText;
             end;
           end;

         ligneHT := Formate_Affichage( libelleHT , valeurHT );
         if AutoLiquidationTVA = ''
         then
             ligneTVA:= Formate_Affichage( libelleTVA, valeurTVA)
         else
             ligneTVA:= AutoLiquidationTVA;
         ligneTTC:= Formate_Affichage( libelleTTC, valeurTTC);
         end;

     if Afficher_TVA_TTC
     then
         Result:= Formate_Liste( [ ligneHT, ligneTVA, ligneTTC], Separateur)
     else
         Result:= Formate_Liste( [ ligneHT], Separateur)
end;

function BlocTotal_Devis( TypeLibelle: TBlocTotalLibelle;
                          valeurHT_avant_multiplicateur,
                          valeurHT, valeurTVA, valeurTTC: String;
                          RTFascii_: Boolean;
                          Afficher_TVA_TTC: Boolean= True): String; 
var
   libelleHT, libelleTVA, libelleTTC: String;
   ligneHT_avant_multiplicateur, ligneHT, ligneTVA, ligneTTC: String;
   Separateur: String;
   L: Integer;
   procedure Formate_valeurs;
   begin
        valeurHT_avant_multiplicateur:= FormateChaine( valeurHT_avant_multiplicateur, L);
        valeurHT := FormateChaine( valeurHT , L);
        valeurTVA:= FormateChaine( valeurTVA, L);
        valeurTTC:= FormateChaine( valeurTTC, L);
   end;
begin
     if RTFascii_
     then
         Separateur:= '\par ' //\par = saut de ligne en RTF pour TRichEdit
     else
         Separateur:= #13;//2012 05 16 modifié pour les blocs totaux
                          //dans la tranche conditionnelle du devis
                          //convient dans les tableaux
                          //mais pas pour les paramètres OpenOffice

     case TypeLibelle
     of
       btl_Sans :
         begin
         libelleHT := sys_Vide;
         libelleTVA:= sys_Vide;
         libelleTTC:= sys_Vide;
         end;
       btl_Court:
         begin
         libelleHT := 'HT ';
         libelleTVA:= 'TVA';
         libelleTTC:= 'TTC';
         end;
       btl_Long :
         begin
         libelleHT := 'TOTAL HT   ';
         libelleTVA:= 'MONTANT TVA';
         libelleTTC:= 'TOTAL TTC  ';
         end;
       else
         begin
         libelleHT := sys_Vide;
         libelleTVA:= sys_Vide;
         libelleTTC:= sys_Vide;
         end;
       end;

     if btl_Sans = TypeLibelle
     then
         begin
         ligneHT_avant_multiplicateur:= valeurHT_avant_multiplicateur;
         ligneHT := valeurHT ;
         ligneTVA:= valeurTVA;
         ligneTTC:= valeurTTC;
         end
     else
         begin
         L
         :=
           Max(
               Max(
                   Max(
                       Length(valeurHT_avant_multiplicateur),
                       Length(valeurHT)
                       ),
                   Length(valeurTVA)
                   ),
               Length(valeurTTC)
               );
         if Afficher_TVA_TTC
         then
             Formate_valeurs;

         ligneHT_avant_multiplicateur:= Formate_Affichage( libelleHT , valeurHT_avant_multiplicateur );
         ligneHT := Formate_Affichage( libelleHT , valeurHT );
         ligneTVA:= Formate_Affichage( libelleTVA, valeurTVA);
         ligneTTC:= Formate_Affichage( libelleTTC, valeurTTC);
         end;

     if Afficher_TVA_TTC
     then
         Result:= Formate_Liste( [ ligneHT_avant_multiplicateur, ligneHT, ligneTVA, ligneTTC], Separateur)
     else
         Result:= Formate_Liste( [ ligneHT_avant_multiplicateur, ligneHT], Separateur)
end;

function PourCent( Partie, Total: Double): Double;
begin
     if Total = 0
     then
         Result:= 0
     else
         Result:= (Partie / Total) * 100;
end;

function Partie( PourCent, Total: Double): Double;
begin
     if Total = 0
     then
         Result:= 0
     else
         Result:= (PourCent/100) * Total;
end;

function Arrondi_Arithmetique_( E: Double): Double;
var
   Frac_E, Int_E: Double;
   Frac_E_10: Int64;
begin
      Int_E:=  Int(E);
     Frac_E:= Frac(E);
     Frac_E_10:= Frac_E * 10;
          if Frac_E_10 < -5 then Result:= Int_E - 1
     else if Frac_E_10 < +5 then Result:= Int_E
     else                        Result:= Int_E + 1;
end;

function Arrondi_Arithmetique_0  ( E: Double): Double;
begin
     Result:= Arrondi_Arithmetique_( E * 10  ) / 10  ;
end;

function Arrondi_Arithmetique_00 ( E: Double): Double;
begin
     Result:= Arrondi_Arithmetique_( E * 100 ) / 100 ;
end;

function Arrondi_Arithmetique_000( E: Double): Double;
begin
     Result:= Arrondi_Arithmetique_( E * 1000) / 1000;
end;

function Arrondi_quart_d_heure_inferieur( _NBHeures: double):double;
begin
     Result:= Trunc( _NBHeures*4)/4;
end;

function Test_Arrondi_quart_d_heure_inferieur:String;
var
   I: Integer;
   NbHeures, Arrondi: double;

begin
     //123456789012345678901234567890123456789012345678901234567890
     //         1         2         3         4         5         6
     Result
     :=
        'Cribble de test de l''arrondi au quart d''heure inférieur'#13#10
       +' de -3h à +3h par pas de 1/10 d''heure'#13#10#13#10
       +'           Arrondi'#13#10;
     for I:= -30 to 30
     do
       begin
       NbHeures:= I/10;
       Arrondi:= Arrondi_quart_d_heure_inferieur( NbHeures);
       Result
       :=
          Result
         +sHeure( NbHeures)+' -> '+sHeure( Arrondi)+#13#10;
       end;
end;

function FloatValue_from_Field( f: TField): Double;
var
   v: Variant;
begin
     Result:= 0;
     if f = nil then exit;

     // Delphi 7: TAggregateField.IsNull est bogué, il retourne null
     // systématiquement à la 2ème ligne même si l'on a une valeur
     if (f.IsNull)
        {$IFNDEF FPC}
        and not (f is TAggregateField)
        {$ENDIF}
     then exit;

     v:= f.Value;
     if VarIsNull( v) then exit;

     Result:= v;
end;

function code_from_sexagesimal( n: Integer): Char;
//retourne le caractère ascii 48+n
//pour n variant de 0 à 60 on tombe sur des caractère ne risquant pas trop
//d'interférer avec SQL
begin
     Result:= Chr( 48+n);
end;

function Genere_Cle_11: String;
var
   D: TDateTime;
begin
     D:= Now;
     Result:=  'É'
             + FormatDateTime( 'yy', D)
             + code_from_sexagesimal( MonthOfTheYear        (D))
             + code_from_sexagesimal( DayOfTheMonth         (D))
             + code_from_sexagesimal( HourOfTheDay          (D))
             + code_from_sexagesimal( MinuteOfTheHour       (D))
             + code_from_sexagesimal( SecondOfTheMinute     (D))
             + Format( '%.3d',      [ MilliSecondOfTheMinute(D)])
             ;
end;

function Genere_Cle_8: String;
var
   D: TDateTime;
begin
     D:= Now;
     Result:=  'É'
             + FormatDateTime( 'yy', D)
             + code_from_sexagesimal( MonthOfTheYear   (D))
             + code_from_sexagesimal( DayOfTheMonth    (D))
             + code_from_sexagesimal( HourOfTheDay     (D))
             + code_from_sexagesimal( MinuteOfTheHour  (D))
             + code_from_sexagesimal( SecondOfTheMinute(D))
             ;
end;

function Genere_Cle_6: String;
var
   D: TDateTime;
begin
     D:= Now;
     Result:=  'É'
             + code_from_sexagesimal( MonthOfTheYear   (D))
             + code_from_sexagesimal( DayOfTheMonth    (D))
             + code_from_sexagesimal( HourOfTheDay     (D))
             + code_from_sexagesimal( MinuteOfTheHour  (D))
             + code_from_sexagesimal( SecondOfTheMinute(D))
             ;
end;

function TryDMY4ToDate( DMY4: String; out DT: TDateTime): Boolean;
var
   sD, sM, sY: String;
   D, M, Y: Integer;
begin
     sD:= StrReadString( DMY4, 2);
          StrReadString( DMY4, 1);
     sM:= StrReadString( DMY4, 2);
          StrReadString( DMY4, 1);
     sY:= StrReadString( DMY4, 4);

     Result:= TryStrToInt( sD, D); if not Result then exit;
     Result:= TryStrToInt( sM, M); if not Result then exit;
     Result:= TryStrToInt( sY, Y); if not Result then exit;

     DT:= EncodeDate( Y, M, D);
end;

function Annee4_from_Annee2( Y2: Integer): Integer;
begin
     if Y2 < 30
     then
         Result:= 2000+Y2
     else
         Result:= 1900+Y2;
end;


function TryDMY2ToDate( DMY2: String; out DT: TDateTime): Boolean;
var
   sD, sM, sY: String;
   D, M, Y: Integer;
begin
     sD:= StrReadString( DMY2, 2);
          StrReadString( DMY2, 1);
     sM:= StrReadString( DMY2, 2);
          StrReadString( DMY2, 1);
     sY:= StrReadString( DMY2, 2);

     Result:= TryStrToInt( sD, D); if not Result then exit;
     Result:= TryStrToInt( sM, M); if not Result then exit;
     Result:= TryStrToInt( sY, Y); if not Result then exit;

     Y:= Annee4_from_Annee2( Y);

     DT:= EncodeDate( Y, M, D);
end;

function TryDMYToDate( DMY: String; out DT: TDateTime): Boolean;
begin
     if Length( DMY) = 2+1+2+1+4
     then
         Result:= TryDMY4ToDate( DMY, DT)
     else
         Result:= TryDMY2ToDate( DMY, DT)
end;

function sHeure( _NbHeures: double; ValeurZero: String= ''): String;
var
   fHeures, fMinutes: double;
   Heures, Minutes: Integer;
begin
     Result:= ValeurZero;
     if Reel_Zero( _NbHeures) then exit;

     fHeures  := Abs( _NbHeures)      ; Heures  := Trunc( fHeures  );
     fMinutes := (fHeures -Heures )*60; Minutes := Trunc( fMinutes );
     if (Heures = 0) and (Minutes = 0) then exit;

     if _NbHeures < 0
     then
         Result:= '- '
     else
         Result:= '  ';
     Result:= Result + Format( '%.2d:%.2d', [Heures, Minutes]);
end;

function sHeure_Secondes( _NbHeures: double; ValeurZero: String= ''): String;
var
   fHeures, fMinutes, fSecondes: double;
   Heures, Minutes, Secondes: Integer;
begin
     Result:= ValeurZero;
     if Reel_Zero( _NbHeures) then exit;

     fHeures  := Abs( _NbHeures)      ; Heures  := Trunc( fHeures  );
     fMinutes := (fHeures -Heures )*60; Minutes := Trunc( fMinutes );
     fSecondes:= (fMinutes-Minutes)*60; Secondes:= Trunc( fSecondes);
     if (Heures = 0) and (Minutes = 0) and (Secondes = 0) then exit;

     if _NbHeures < 0
     then
         Result:= '- '
     else
         Result:= '  ';

     Result:= Result + Format( '%.2d:%.2d:%.2d', [Heures, Minutes, Secondes]);
end;

function CreeParam( _Params: TParams; _ParamName: String): TParam;
begin
     Result:= _Params.CreateParam( ftUnknown, _ParamName, ptInput);
end;

function Annee_Semaine( D: TDateTime): String;
var
   Annee, Semaine: Word;
begin
     Annee  := Year_from_Date( D);
     Semaine:= WeekOfTheYear ( D);
     Result := Format('%.4d-%.2d', [Annee, Semaine]);
end;

function Annee_Mois   ( D: TDateTime): String;
var
   Annee, Mois: Word;
begin
     Annee := Year_from_Date( D);
     Mois  := MonthOfTheYear( D);
     Result:= Format('%.4d-%.2d', [Annee, Mois]);
end;

initialization
              SetRoundMode( rmNearest);
finalization
end.
