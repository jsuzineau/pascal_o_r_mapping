unit uChamp;
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
    uClean,
    uuStrings,
    uBatpro_StringList,
    uLookupConnection_Ancetre,
    u_sys_,
    uPublieur,
    uChampDefinition,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    udmf,
    ufChamp_Date  ,
    ufChamp_Lookup,
    {$IFEND}
  {$IFDEF MSWINDOWS}
  Windows,
  Grids,
  {$ENDIF}
  SysUtils, Classes,DB;

type
 PtrBoolean= ^Boolean;
 TOnGetLookupListItems= procedure ( _Current_Key: String;
                                    _Keys, _Labels: TStrings;
                                    _Connection_Ancetre: TLookupConnection_Ancetre;
                                    _CodeId_: Boolean= False) of object;
 TChamp_OnGetChaine= procedure ( var _Chaine: String) of object;
 TChamp
 =
  class
  public
    Owner: TObject;
    Definition: TChampDefinition;
    Valeur    : Pointer;
    constructor Create( _Owner: TObject;
                        _Definition: TChampDefinition;
                        _Valeur    : Pointer;
                        _Save_to_database: TAbonnement_Objet_Proc
                       );
    destructor Destroy; override;
  //Gestion du format chaine
  public
    function GetChaine_interne: String;
  private
    procedure SetChaine( Value: String);
    function  GetChaine: String;
  public
    OnGetChaine: TChamp_OnGetChaine;
    property Chaine: String read GetChaine write SetChaine;
  //Gestion de la publication des modifications
  private
    FOnChange: TPublieur;
    function GetOnChange: TPublieur;
    procedure Do_OnChange;
  public
    property OnChange: TPublieur read GetOnChange;
    procedure Publie_Modifications( Sauver: Boolean = True);// à appeler aprés une modif de Valeur^
  //Gestion des modifications dans TChampsGrid
  public
    function Edite( Position: TPoint): Boolean;
  //Gestion des lookups
  public
    LookupKey: TChamp;
    OnGetLookupListItems: TOnGetLookupListItems;
    LookupConnection: TLookupConnection_Ancetre;
  private
    procedure LookupKey_Change;
    procedure Init_Lookup_Common( _LookupKey: TChamp;
                                  _OnGetLookupListItems: TOnGetLookupListItems);
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    procedure Init_dmf_Lookup( dmf: Tdmf; _LookupKey: TChamp);
    {$IFEND}
    procedure Init_Lookup( _LookupKey: TChamp;
                           _OnGetLookupListItems: TOnGetLookupListItems;
                           _Valeur_courante: String);
  public
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    constructor Create_dmf_Lookup( _Owner: TObject;
                                   _Definition: TChampDefinition;
                                   _Valeur    : Pointer;
                                   dmf: Tdmf;
                                   _LookupKey: TChamp;
                                   _Save_to_database: TAbonnement_Objet_Proc);
    {$IFEND}
    constructor Create_Lookup( _Owner: TObject;
                               _Definition: TChampDefinition;
                               _Valeur    : Pointer;
                               _LookupKey: TChamp;
                               _OnGetLookupListItems: TOnGetLookupListItems;
                               _Valeur_courante: String;
                               _Save_to_database: TAbonnement_Objet_Proc);
  //Gestion de la persistance
  private
    Save_to_database: TAbonnement_Objet_Proc;
  //Rechargement
  public
    procedure Recharge( _q: TDataset);
  // asInteger
  private
    function GetasInteger: Integer;
    procedure SetasInteger(const Value: Integer);
  public
    property asInteger: Integer read GetasInteger write SetasInteger;
  // asBoolean
  private
    function GetasBoolean: Boolean;
    procedure SetasBoolean(const Value: Boolean);
  public
    property asBoolean: Boolean read GetasBoolean write SetasBoolean;
  // asDouble
  private
    function GetasDouble: Double;
    procedure SetasDouble(const Value: Double);
  public
    property asDouble: Double read GetasDouble write SetasDouble;
  // asDatetime
  private
    function GetasDatetime: TDatetime;
    procedure SetasDatetime(const Value: TDatetime);
  public
    property asDatetime: TDatetime read GetasDatetime write SetasDatetime;
  //Sérialisation
  public
    procedure Serialise  ( S: TStream);
    procedure DeSerialise( S: TStream);
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  //Edition in situ dans un TChampsGrid
  public
    procedure InplaceEditUpdateContents( iel: TInplaceEditList);
    procedure InplaceEditChange        ;
    procedure InplaceEditKeyDown       ( var Key: Word; Shift: TShiftState);
    procedure InplaceEditDecroche      ;
  {$IFEND}
  //Valeur minimale
  private
    procedure Applique_MinValue;
  //Gestion du rebond / bounce
  //l'utilisateur a saisi une valeur et un contrôle de
  //de cohérence la refuse, l'interface doit se remettre à jour
  public
    Bounce: Boolean;
  //ReadOnly
  public
    ReadOnly: Boolean;
  end;

 TIterateur_Champ
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TChamp);
    function  not_Suivant( var _Resultat: TChamp): Boolean;
  end;

 TslChamp
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Champ;
    function Iterateur_Decroissant: TIterateur_Champ;
  end;

 TModification
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Champ_Nom: String;
    Champ_Libelle:String;
    Champ_Valeur: String;
  //Méthode
  public
    procedure _from_Champ( _c: TChamp);
    function Description: String;
  //Publication des modifications
  public
    pOnchange: TPublieur;
  end;

function Champ_from_sl( sl: TBatpro_StringList; I: Integer): TChamp;

var
   uChamp_Publier_Modifications: Boolean = True;
   Derniere_Modification: TModification= nil;

implementation

function Champ_from_sl( sl: TBatpro_StringList; I: Integer): TChamp;
begin
     _Classe_from_sl( Result, TChamp, sl, I);
end;

{ TIterateur_Champ }

function TIterateur_Champ.not_Suivant( var _Resultat: TChamp): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Champ.Suivant( var _Resultat: TChamp);
begin
     Suivant_interne( _Resultat);
end;

{ TslChamp }

constructor TslChamp.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TChamp);
end;

destructor TslChamp.Destroy;
begin
     inherited;
end;

class function TslChamp.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Champ;
end;

function TslChamp.Iterateur: TIterateur_Champ;
begin
     Result:= TIterateur_Champ( Iterateur_interne);
end;

function TslChamp.Iterateur_Decroissant: TIterateur_Champ;
begin
     Result:= TIterateur_Champ( Iterateur_interne_Decroissant);
end;

{ TModification }

constructor TModification.Create;
begin
     pOnchange:= TPublieur.Create( ClassName+'.pOnchange');
     Champ_Nom:= '';
end;

destructor TModification.Destroy;
begin
     Free_nil( pOnchange);
     inherited;
end;

procedure TModification._from_Champ( _c: TChamp);
begin
     if _c = nil then exit;
     if Champ_Nom    <> _c.Definition.Nom then exit;//permet de fixer le genre de modif que l'on veut suivre

     Champ_Libelle:= _c.Definition.Libelle;
     Champ_Valeur := _c.Chaine;
     pOnchange.Publie;
end;

function TModification.Description: String;
begin
     Result:= Champ_Nom;
     if Champ_Libelle <> Champ_Nom then Formate_Liste( Result, '/', Champ_Libelle);
     Formate_Liste( Result, ':', Champ_Valeur);
end;

{ TChamp }

constructor TChamp.Create( _Owner: TObject;
                           _Definition: TChampDefinition;
                           _Valeur    : Pointer;
                           _Save_to_database: TAbonnement_Objet_Proc
                           );
begin
     Owner     := _Owner;
     Definition:= _Definition;
     Valeur    := _Valeur    ;
     FOnChange:= nil;
     LookupKey:= nil;
     OnGetLookupListItems:= nil;
     LookupConnection:= nil;
     Save_to_database:= _Save_to_database;
     OnGetChaine:= nil;
     Bounce:= False;
     ReadOnly:= False;
end;

destructor TChamp.Destroy;
begin
     Free_nil( LookupConnection);
     Free_nil( FOnChange);
     inherited;
end;

procedure TChamp.Do_OnChange;
begin
     Applique_MinValue;

     if Assigned( FOnChange)
     then
         FOnChange.Publie;
end;

procedure TChamp.Publie_Modifications( Sauver: Boolean = True);
begin
     Bounce:= False;

     Derniere_Modification._from_Champ( Self);

     if not uChamp_Publier_Modifications then exit;

     if     Definition.Persistant
        and Sauver
     then
         Save_to_database;

     Do_OnChange;
end;

function TChamp.GetChaine_interne: String;
   procedure Traite_Date;
   var
      D: TDateTime;
   begin
        D:= PDateTime(Valeur)^;
        if D = 0
        then
            Result:= ''
        else
            Result:= DateToStr( D);
   end;
   procedure Traite_DateTime;
   var
      D: TDateTime;
   begin
        D:= PDateTime(Valeur)^;
        if D = 0
        then
            Result:= ''
        else
            Result:= DateTimeToStr( D);
   end;
begin
     if Self = nil
     then
         begin
         Result:= '';
         exit;
         end;

     case Definition.Typ
     of
       ftFixedChar: Result:= PShortString( Valeur)^;
       ftString  : Result:= PString  ( Valeur)^;
       ftMemo    : Result:= PString  ( Valeur)^;
       ftBlob    : Result:= PString  ( Valeur)^;
       //ftDate    : Result:= FormatDateTime( 'ddddd', PDateTime(Valeur)^);
       ftDate    : Traite_Date;
       ftInteger : Result:= IntToStr  ( PInteger ( Valeur)^);
       ftSmallint: Result:= IntToStr  ( PInteger ( Valeur)^);
       ftBCD     : Result:= Definition.Format_Float( PCurrency( Valeur)^);
       //ftDateTime: Result:= FormatDateTime( 'ddddd","t', PDateTime(Valeur)^);
       ftDateTime: Traite_DateTime;
       ftTimeStamp:Traite_DateTime;
       ftFloat   : Result:= Definition.Format_Float( PDouble  ( Valeur)^);
       ftBoolean : Result:=     BoolToStr( PtrBoolean( Valeur)^);
       else        Result:= sys_Vide;
       end;
end;

function TChamp.GetChaine: String;
begin
     if Self = nil
     then
         begin
         Result:= '';
         exit;
         end;
     Result:= GetChaine_interne;
     if Assigned( OnGetChaine)
     then
         OnGetChaine( Result);
end;

procedure TChamp.SetChaine(Value: String);
     procedure TraiteDouble;
          procedure Enleve( C: Char);
          var
             iC: Integer;
             function C_Trouve: Boolean;
             begin
                  iC:= Pos( C, Value);
                  Result:= iC > 0;
             end;
          begin
               while C_Trouve
               do
                 Delete( Value, iC, 1);
          end;
          procedure Remplace( Old, New: Char);
          var
             I: Integer;
             procedure R( var C: Char);
             begin
                  if C = Old then C:= New;
             end;
          begin
               for I:= 1 to Length( Value)
               do
                 R( Value[I])
          end;
     begin
          Enleve(  #32);//l'espace standard
          Enleve( #160);//l'espace insécable
          case DecimalSeparator
          of
            '.': Remplace( ',', '.');
            ',': Remplace( '.', ',');
            end;
          TryStrToFloat( Value, PDouble  ( Valeur)^);
     end;
   procedure TraiteDate;
   var
      D: TDateTime;
   begin
        if Value = ''
        then
            D:= 0
        else
            TryStrToDate    ( Value, D);
        PDateTime( Valeur)^:= D;
   end;
   procedure TraiteDateTime;
   var
      D: TDateTime;
   begin
        if Value = ''
        then
            D:= 0
        else
            TryStrToDateTime( Value, D);
        PDateTime( Valeur)^:= D;
   end;
begin
     if Self = nil then exit;

     if not ReadOnly
     then
         case Definition.Typ
         of
           ftFixedChar: PShortString( Valeur)^:= Value;
           ftString  : PString  ( Valeur)^:= Value;
           ftMemo    : PString  ( Valeur)^:= Value;
           ftBlob    : PString  ( Valeur)^:= Value;
           ftDate    : TraiteDate;
           ftInteger : TryStrToInt     ( Value, PInteger ( Valeur)^);
           ftSmallint: TryStrToInt     ( Value, PInteger ( Valeur)^);
           ftBCD     : TryStrToCurr    ( Value, PCurrency( Valeur)^);
           ftDateTime: TraiteDateTime;
           ftTimeStamp:TraiteDateTime;
           ftFloat   : TraiteDouble;
           ftBoolean : TryStrToBool    ( Value, PtrBoolean ( Valeur)^);
           end;

     Publie_Modifications;
end;

function TChamp.Edite( Position: TPoint): Boolean;
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   sCle, sLibelle: String;
{$IFEND}
begin
     Result:= False;
     if ReadOnly then exit;

     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     if Definition.Is_Lookup
     then
         begin
         sCle    := LookupKey.Chaine;
         sLibelle:=           Chaine;
         OnGetLookupListItems( sCle, fChamp_Lookup.Keys, fChamp_Lookup.Labels,LookupConnection);
         Result:= fChamp_Lookup.Execute( Position, sCle, sLibelle);
         if Result
         then
             begin
             LookupKey.Chaine:= sCle    ;
                       Chaine:= sLibelle;
             end;
         end
     else
         begin
         case Definition.Typ
         of
           ftFixedChar: Result:=False;
           ftString   : Result:=False;
           ftMemo     : Result:=False;
           ftBlob     : Result:=False;
           ftDate     : Result:=fChamp_Date.Execute(Position,PDateTime(Valeur)^);
           ftInteger  : Result:=False;
           ftSmallint : Result:=False;
           ftBCD      : Result:=False;
           ftDateTime : Result:=fChamp_Date.Execute(Position,PDateTime(Valeur)^);
           ftTimeStamp: Result:=fChamp_Date.Execute(Position,PDateTime(Valeur)^);
           ftFloat    : Result:=False;
           ftBoolean  : Result:=False;
           else         Result:=False;
           end;
         Publie_Modifications;
         end;
     {$IFEND}
end;

procedure TChamp.LookupKey_Change;
var
   Current_Key: String;
   slKeys, slLabels: TBatpro_StringList;
   iKey: Integer;
begin
     if ReadOnly then exit;
     if not Assigned( OnGetLookupListItems) then exit;

     slKeys  := TBatpro_StringList.Create;
     slLabels:= TBatpro_StringList.Create;
     try
        Current_Key:= LookupKey.Chaine;
        OnGetLookupListItems( Current_Key, slKeys, slLabels,LookupConnection);
        iKey:= slKeys.IndexOf( Current_Key);
        if iKey = -1
        then
            Chaine:= '<non trouvé>'
        else
            Chaine:= slLabels.Strings[ iKey];
     finally
            Free_nil( slKeys  );
            Free_nil( slLabels);
            end;
end;

procedure TChamp.Init_Lookup_Common( _LookupKey: TChamp;
                                     _OnGetLookupListItems: TOnGetLookupListItems);
begin
     LookupKey           := _LookupKey;
     OnGetLookupListItems:= _OnGetLookupListItems;

     if Assigned( LookupKey)
     then
         LookupKey.OnChange.Abonne( Self, LookupKey_Change);
end;

{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
procedure TChamp.Init_dmf_Lookup( dmf: Tdmf; _LookupKey: TChamp);
var
   I: Integer;
begin
     Init_Lookup_Common( _LookupKey, dmf.GetLookupListItems);

     if not Definition.Is_Lookup then exit;

     I:= dmf.slCles.IndexOf( LookupKey.Chaine);
     if -1 = I then exit;

     Chaine:= dmf.slLibelles[I];

     LookupKey.Definition.Visible:= False;
               Definition.Visible:= True;
end;

constructor TChamp.Create_dmf_Lookup( _Owner: TObject;
                                      _Definition: TChampDefinition;
                                      _Valeur   : Pointer;
                                      dmf       : Tdmf;
                                      _LookupKey: TChamp;
                                      _Save_to_database: TAbonnement_Objet_Proc
                                      );
begin
     Create( _Owner, _Definition, _Valeur, _Save_to_database);
     Init_dmf_Lookup( dmf, _LookupKey);
end;
{$IFEND}

procedure TChamp.Init_Lookup( _LookupKey: TChamp;
                              _OnGetLookupListItems: TOnGetLookupListItems;
                              _Valeur_courante: String);
begin
     Init_Lookup_Common( _LookupKey, _OnGetLookupListItems);
     Chaine:= _Valeur_courante;
end;

constructor TChamp.Create_Lookup( _Owner: TObject;
                                  _Definition: TChampDefinition;
                                  _Valeur: Pointer;
                                  _LookupKey: TChamp;
                                  _OnGetLookupListItems: TOnGetLookupListItems;
                                  _Valeur_courante: String;
                                  _Save_to_database: TAbonnement_Objet_Proc);
begin
     Create( _Owner, _Definition, _Valeur, _Save_to_database);
     Init_Lookup( _LookupKey, _OnGetLookupListItems, _Valeur_courante);
end;

function TChamp.GetOnChange: TPublieur;
   procedure Cree_OnChange;
   var
      sNomChamp: String;
   begin
        sNomChamp:= '';

        if Assigned( Definition)
        then
            try
               sNomChamp:= Definition.Nom;
            except
                  on E: Exception do begin end;
                  end;

        FOnChange:= TPublieur.Create('TChamp(nomchamp= '+sNomChamp+').OnChange');
   end;
begin
     Result:= nil;
     if Self = nil then exit;

     if FOnChange = nil
     then
         Cree_OnChange;

     Result:= FOnChange;

end;

procedure TChamp.Recharge( _q: TDataset);
var
   F: TField;
begin
     F:= _q.FindField( Definition.Nom);
     if F = nil then exit;

     case Definition.Typ
     of
       ftFixedChar: PShortString( Valeur)^:= F.AsString;
       ftString  : PString  ( Valeur)^:= F.AsString;
       ftMemo    : PString  ( Valeur)^:= F.AsString;
       ftBlob    : PString  ( Valeur)^:= F.AsString;
       ftDate    : TryStrToDate    ( F.AsString, PDateTime( Valeur)^);
       ftInteger : TryStrToInt     ( F.AsString, PInteger ( Valeur)^);
       ftSmallint: TryStrToInt     ( F.AsString, PInteger ( Valeur)^);
       ftBCD     : TryStrToCurr    ( F.AsString, PCurrency( Valeur)^);
       ftDateTime: TryStrToDateTime( F.AsString, PDateTime( Valeur)^);
       ftTimeStamp:TryStrToDateTime( F.AsString, PDateTime( Valeur)^);
       ftFloat   : TryStrToFloat   ( F.AsString, PDouble  ( Valeur)^);
       ftBoolean : TryStrToBool    ( F.AsString, PtrBoolean ( Valeur)^);
       end;
end;

function TChamp.GetasDatetime: TDatetime;
begin
     case Definition.Typ
     of
       ftFixedChar: Result:= StrToDateTime( PShortString  ( Valeur)^);
       ftString  : Result:= StrToDateTime( PString  ( Valeur)^);
       ftMemo    : Result:= StrToDateTime( PString  ( Valeur)^);
       ftBlob    : Result:= StrToDateTime( PString  ( Valeur)^);
       ftDate    : Result:= PDateTime( Valeur)^;
       ftInteger : Result:= PInteger ( Valeur)^;
       ftSmallint: Result:= PInteger ( Valeur)^;
       ftBCD     : Result:= PCurrency( Valeur)^;
       ftDateTime: Result:= PDateTime( Valeur)^;
       ftTimeStamp:Result:= PDateTime( Valeur)^;
       ftFloat   : Result:= PDouble  ( Valeur)^;
       ftBoolean : Result:= Integer  ( PtrBoolean ( Valeur)^);//peu utile
       else        Result:= 0;
       end;
end;

procedure TChamp.SetasDatetime(const Value: TDatetime);
begin
     if not ReadOnly
     then
         case Definition.Typ
         of
           ftFixedChar: PShortString( Valeur)^:= DateTimeToStr( Value);
           ftString  : PString  ( Valeur)^:= DateTimeToStr( Value);
           ftMemo    : PString  ( Valeur)^:= DateTimeToStr( Value);
           ftBlob    : PString  ( Valeur)^:= DateTimeToStr( Value);
           ftDate    : PDateTime( Valeur)^:= Value;
           ftInteger : PInteger ( Valeur)^:= Trunc( Value);
           ftSmallint: PInteger ( Valeur)^:= Trunc( Value);
           ftBCD     : PCurrency( Valeur)^:= Value;
           ftDateTime: PDateTime( Valeur)^:= Value;
           ftTimeStamp:PDateTime( Valeur)^:= Value;
           ftFloat   : PDouble  ( Valeur)^:= Value;
           ftBoolean : PtrBoolean ( Valeur)^:= Boolean( Trunc(Value));//peu utile
           else        begin end;
           end;
           
     Publie_Modifications;
end;

function TChamp.GetasDouble: Double;
begin
     case Definition.Typ
     of
       ftFixedChar: Result:= StrToFloat( PShortString  ( Valeur)^);
       ftString  : Result:= StrToFloat( PString  ( Valeur)^);
       ftMemo    : Result:= StrToFloat( PString  ( Valeur)^);
       ftBlob    : Result:= StrToFloat( PString  ( Valeur)^);
       ftDate    : Result:= PDateTime( Valeur)^;
       ftInteger : Result:= PInteger ( Valeur)^;
       ftSmallint: Result:= PInteger ( Valeur)^;
       ftBCD     : Result:= PCurrency( Valeur)^;
       ftDateTime: Result:= PDateTime( Valeur)^;
       ftTimeStamp:Result:= PDateTime( Valeur)^;
       ftFloat   : Result:= PDouble  ( Valeur)^;
       ftBoolean : Result:= Integer  ( PtrBoolean ( Valeur)^);//peu utile
       else        Result:= 0;
       end;
end;

procedure TChamp.SetasDouble(const Value: Double);
begin
     if not ReadOnly
     then
         case Definition.Typ
         of
           ftFixedChar: PShortString( Valeur)^:= FloatToStr( Value);
           ftString  : PString  ( Valeur)^:= FloatToStr( Value);
           ftMemo    : PString  ( Valeur)^:= FloatToStr( Value);
           ftBlob    : PString  ( Valeur)^:= FloatToStr( Value);
           ftDate    : PDateTime( Valeur)^:= Value;
           ftInteger : PInteger ( Valeur)^:= Trunc( Value);
           ftSmallint: PInteger ( Valeur)^:= Trunc( Value);
           ftBCD     : PCurrency( Valeur)^:= Value;
           ftDateTime: PDateTime( Valeur)^:= Value;
           ftTimeStamp:PDateTime( Valeur)^:= Value;
           ftFloat   : PDouble  ( Valeur)^:= Value;
           ftBoolean : PtrBoolean ( Valeur)^:= Boolean( Trunc(Value));//peu utile
           else        begin end;
           end;
     Publie_Modifications;
end;

function TChamp.GetasBoolean: Boolean;
begin
     case Definition.Typ
     of
       ftFixedChar: Result:= StrToBool( PShortString  ( Valeur)^);
       ftString  : Result:= StrToBool( PString  ( Valeur)^);
       ftMemo    : Result:= StrToBool( PString  ( Valeur)^);
       ftBlob    : Result:= StrToBool( PString  ( Valeur)^);
       ftDate    : Result:= Boolean( Trunc( PDateTime( Valeur)^));
       ftInteger : Result:= Boolean( Trunc( PInteger ( Valeur)^));
       ftSmallint: Result:= Boolean( PInteger ( Valeur)^);
       ftBCD     : Result:= Boolean( Trunc( PCurrency( Valeur)^));
       ftDateTime: Result:= Boolean( Trunc( PDateTime( Valeur)^));
       ftTimeStamp:Result:= Boolean( Trunc( PDateTime( Valeur)^));
       ftFloat   : Result:= Boolean( Trunc( PDouble  ( Valeur)^));
       ftBoolean : Result:= PtrBoolean ( Valeur)^;
       else        Result:= False;
       end;
end;

procedure TChamp.SetasBoolean(const Value: Boolean);
begin
     if not ReadOnly
     then
         case Definition.Typ
         of
           ftFixedChar:PShortString( Valeur)^:= BoolToStr( Value);
           ftString  : PString  ( Valeur)^:= BoolToStr( Value);
           ftMemo    : PString  ( Valeur)^:= BoolToStr( Value);
           ftBlob    : PString  ( Valeur)^:= BoolToStr( Value);
           ftDate    : PDateTime( Valeur)^:= Integer( Value);
           ftInteger : PInteger ( Valeur)^:= Integer( Value);
           ftSmallint: PInteger ( Valeur)^:= Integer( Value);
           ftBCD     : PCurrency( Valeur)^:= Integer( Value);
           ftDateTime: PDateTime( Valeur)^:= Integer( Value);
           ftTimeStamp:PDateTime( Valeur)^:= Integer( Value);
           ftFloat   : PDouble  ( Valeur)^:= Integer( Value);
           ftBoolean : PtrBoolean( Valeur)^:= Value;
           else        begin end;
           end;
     Publie_Modifications;
end;

function TChamp.GetasInteger: Integer;
begin
     case Definition.Typ
     of
       ftFixedChar:Result:= StrToInt( PShortString  ( Valeur)^);
       ftString  : Result:= StrToInt( PString  ( Valeur)^);
       ftMemo    : Result:= StrToInt( PString  ( Valeur)^);
       ftBlob    : Result:= StrToInt( PString  ( Valeur)^);
       ftDate    : Result:= Trunc( PDateTime( Valeur)^);
       ftInteger : Result:= PInteger ( Valeur)^;
       ftSmallint: Result:= PInteger ( Valeur)^;
       ftBCD     : Result:= Trunc( PCurrency( Valeur)^);
       ftDateTime: Result:= Trunc( PDateTime( Valeur)^);
       ftTimeStamp:Result:= Trunc( PDateTime( Valeur)^);
       ftFloat   : Result:= Trunc( PDouble  ( Valeur)^);
       ftBoolean : Result:= Integer( PtrBoolean( Valeur)^);
       else        Result:= 0;
       end;
end;

procedure TChamp.SetasInteger(const Value: Integer);
begin
     if not ReadOnly
     then
         case Definition.Typ
         of
           ftFixedChar:PShortString  ( Valeur)^:= IntToStr( Value);
           ftString  : PString  ( Valeur)^:= IntToStr( Value);
           ftMemo    : PString  ( Valeur)^:= IntToStr( Value);
           ftBlob    : PString  ( Valeur)^:= IntToStr( Value);
           ftDate    : PDateTime( Valeur)^:= Value;
           ftInteger : PInteger ( Valeur)^:= Value;
           ftSmallint: PInteger ( Valeur)^:= Value;
           ftBCD     : PCurrency( Valeur)^:= Value;
           ftDateTime: PDateTime( Valeur)^:= Value;
           ftTimeStamp:PDateTime( Valeur)^:= Value;
           ftFloat   : PDouble  ( Valeur)^:= Value;
           ftBoolean : PtrBoolean( Valeur)^:= Boolean( Value);
           else        begin end;
           end;
     Publie_Modifications;
end;

procedure TChamp.Serialise(S: TStream);
    procedure Traite_ShortString;
    begin
         S.Write( PShortString( Valeur)^[0], 1+Length( PShortString( Valeur)^));
    end;
    procedure Traite_String;
    var
       Longueur: Cardinal;
    begin
         Longueur:= Length( PString  ( Valeur)^);
         S.Write( Longueur, SizeOf(Longueur));
         if Longueur = 0 then exit;
         S.Write( PString( Valeur)^[1], Longueur);
    end;
begin
     case Definition.Typ
     of
       ftFixedChar: Traite_ShortString;
       ftString  : Traite_String;
       ftMemo    : Traite_String;
       ftBlob    : Traite_String;
       ftDate    : S.Write( Valeur, SizeOf( TDateTime));
       ftInteger : S.Write( Valeur, SizeOf( Integer  ));
       ftSmallint: S.Write( Valeur, SizeOf( Integer  ));
       ftBCD     : S.Write( Valeur, SizeOf( Currency ));
       ftDateTime: S.Write( Valeur, SizeOf( TDateTime));
       ftTimeStamp:S.Write( Valeur, SizeOf( TDateTime));
       ftFloat   : S.Write( Valeur, SizeOf( Double   ));
       ftBoolean : S.Write( Valeur, SizeOf( Boolean  ));
       else        begin end;
       end;
end;

procedure TChamp.DeSerialise(S: TStream);
    procedure Traite_ShortString;
    var
       Longueur: Byte;
    begin
         S.Read( Longueur, SizeOf( Longueur));
         SetLength( PShortString( Valeur)^, Longueur);
         S.Read( PShortString( Valeur)^[1], Longueur);
    end;
    procedure Traite_String;
    var
       Longueur: Cardinal;
    begin
         S.Read( Longueur, SizeOf(Longueur));
         SetLength( PString( Valeur)^, Longueur);
         if Longueur = 0 then exit;
         S.Read( PString( Valeur)^[1], Longueur);
    end;
begin
     case Definition.Typ
     of
       ftFixedChar: Traite_ShortString;
       ftString  : Traite_String;
       ftMemo    : Traite_String;
       ftBlob    : Traite_String;
       ftDate    : S.Read( Valeur, SizeOf( TDateTime));
       ftInteger : S.Read( Valeur, SizeOf( Integer  ));
       ftSmallint: S.Read( Valeur, SizeOf( Integer  ));
       ftBCD     : S.Read( Valeur, SizeOf( Currency ));
       ftDateTime: S.Read( Valeur, SizeOf( TDateTime));
       ftTimeStamp:S.Read( Valeur, SizeOf( TDateTime));
       ftFloat   : S.Read( Valeur, SizeOf( Double   ));
       ftBoolean : S.Read( Valeur, SizeOf( Boolean  ));
       else        begin end;
       end;
end;

{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
procedure TChamp.InplaceEditUpdateContents( iel: TInplaceEditList);
begin
     Definition.fcbChamp_InplaceEditUpdateContents( iel, Self);
end;

procedure TChamp.InplaceEditChange;
begin
     Definition.fcbChamp_InplaceEditChange;
end;

procedure TChamp.InplaceEditKeyDown( var Key: Word; Shift: TShiftState);
begin
     Definition.fcbChamp_InplaceEditKeyDown( Key, Shift);
end;

procedure TChamp.InplaceEditDecroche;
begin
     Definition.fcbChamp_InplaceEditDecroche;
end;
{$IFEND}

procedure TChamp.Applique_MinValue;
begin
     if not Definition.HasMinValue then exit;

     case Definition.Typ
     of
       ftDate    : if PDateTime( Valeur)^ < Definition.MinValue then PDateTime( Valeur)^:=       Definition.MinValue ;
       ftInteger : if PInteger ( Valeur)^ < Definition.MinValue then PInteger ( Valeur)^:= Trunc(Definition.MinValue);
       ftSmallint: if PInteger ( Valeur)^ < Definition.MinValue then PInteger ( Valeur)^:= Trunc(Definition.MinValue);
       ftBCD     : if PCurrency( Valeur)^ < Definition.MinValue then PCurrency( Valeur)^:=       Definition.MinValue ;
       ftDateTime: if PDateTime( Valeur)^ < Definition.MinValue then PDateTime( Valeur)^:=       Definition.MinValue ;
       ftTimeStamp:if PDateTime( Valeur)^ < Definition.MinValue then PDateTime( Valeur)^:=       Definition.MinValue ;
       ftFloat   : if PDouble  ( Valeur)^ < Definition.MinValue then PDouble  ( Valeur)^:=       Definition.MinValue ;
       else        begin end;
       end;
end;

initialization
              Derniere_Modification:= TModification.Create;
finalization
              Free_nil( Derniere_Modification);
end.
