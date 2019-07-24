unit uChamp;
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
    uuStrings,
    uBatpro_StringList,
    uLookupConnection_Ancetre,
    u_sys_,
    uPublieur,
    ujsDataContexte,
    uChampDefinition,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    udmf,
    ufChamp_Date  ,
    ufChamp_Lookup,
    {$IFEND}
  {$IFNDEF FPC}
  Windows,
  Grids,
  {$ENDIF}
  SysUtils, Classes,DB;

type
 TOnGetLookupListItems= procedure ( _Current_Key: String;
                                    _Keys, _Labels: TStrings;
                                    _Connection_Ancetre: TLookupConnection_Ancetre;
                                    _CodeId_: Boolean= False) of object;
 TChamp_OnGetChaine= procedure ( var _Chaine: String) of object;

 { TChamp }

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
    property Chaine  : String read GetChaine write SetChaine;
    property asString: String read GetChaine write SetChaine;
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
    procedure Recharge( _jsdc: TjsDataContexte);
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
    procedure Suivant( out _Resultat: TChamp);
    function  not_Suivant( out _Resultat: TChamp): Boolean;
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

function TIterateur_Champ.not_Suivant( out _Resultat: TChamp): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Champ.Suivant( out _Resultat: TChamp);
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
        Result:= Definition.Formate_DateTime( D);
   end;
begin
     if Self = nil
     then
         begin
         Result:= '';
         exit;
         end;

     case Definition.Info.jsDataType
     of
       jsdt_String     : Result:= PString  ( Valeur)^;
       jsdt_Date       : Traite_Date;
       jsdt_DateTime   : Traite_DateTime;
       jsdt_Integer    : Result:= IntToStr  ( PInteger ( Valeur)^);
       jsdt_Currency   : Result:= Definition.Format_Float( PCurrency( Valeur)^);
       jsdt_Double     : Result:= Definition.Format_Float( PDouble  ( Valeur)^);
       jsdt_Boolean    : Result:=     BoolToStr( PtrBoolean( Valeur)^);
       jsdt_ShortString: Result:= PShortString( Valeur)^;
       jsdt_Unknown    : Result:= sys_Vide;
       else              Result:= sys_Vide;
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
      procedure Convertit;
      var
         Format_DateTime: String;
         procedure Traite_Format;
         var
            F: TFormatSettings;
         begin
              F:= DefaultFormatSettings;
              F.ShortDateFormat:= Format_DateTime;
              TryStrToDateTime( Value, D, F);
         end;
      begin
           Format_DateTime:= Definition.Format_DateTime;
           if '' = Format_DateTime
           then
               TryStrToDateTime( Value, D)
           else
               Traite_Format;
      end;
   begin
        if Value = ''
        then
            D:= 0
        else
            Convertit;
        PDateTime( Valeur)^:= D;
   end;
begin
     if Self = nil then exit;

     if not ReadOnly
     then
         case Definition.Info.jsDataType
         of
           jsdt_String     : PString  ( Valeur)^:= Value;
           jsdt_Date       : TraiteDate;
           jsdt_DateTime   : TraiteDateTime;
           jsdt_Integer    : TryStrToInt ( Value, PLongint  ( Valeur)^);
           jsdt_Currency   : TryStrToCurr( Value, PCurrency ( Valeur)^);
           jsdt_Double     : TraiteDouble;
           jsdt_Boolean    : TryStrToBool( Value, PtrBoolean( Valeur)^);
           jsdt_ShortString: PShortString( Valeur)^:= Value;
           jsdt_Unknown    : begin end;
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

procedure TChamp.Recharge(_jsdc: TjsDataContexte);
begin
     _jsdc.Charge( Definition.Nom, Definition.Info.jsDataType, Valeur);
end;

function TChamp.GetasDatetime: TDatetime;
begin
     case Definition.Info.jsDataType
     of
       jsdt_String     : Result:= StrToDateTime( PString  ( Valeur)^);
       jsdt_Date       : Result:= PDateTime( Valeur)^;
       jsdt_DateTime   : Result:= PDateTime( Valeur)^;
       jsdt_Integer    : Result:= PInteger ( Valeur)^;
       jsdt_Currency   : Result:= PCurrency( Valeur)^;
       jsdt_Double     : Result:= PDouble  ( Valeur)^;
       jsdt_Boolean    : Result:= Integer  ( PtrBoolean ( Valeur)^);//peu utile
       jsdt_ShortString: Result:= StrToDateTime( PShortString  ( Valeur)^);
       jsdt_Unknown    : Result:= 0;
       else              Result:= 0;
       end;
end;

procedure TChamp.SetasDatetime(const Value: TDatetime);
begin
     if not ReadOnly
     then
         case Definition.Info.jsDataType
         of
           jsdt_String     : PString  ( Valeur)^:= DateTimeToStr( Value);
           jsdt_Date       : PDateTime( Valeur)^:= Value;
           jsdt_DateTime   : PDateTime( Valeur)^:= Value;
           jsdt_Integer    : PInteger ( Valeur)^:= Trunc( Value);
           jsdt_Currency   : PCurrency( Valeur)^:= Value;
           jsdt_Double     : PDouble  ( Valeur)^:= Value;
           jsdt_Boolean    : PtrBoolean ( Valeur)^:= Boolean( Trunc(Value));//peu utile
           jsdt_ShortString: PShortString( Valeur)^:= DateTimeToStr( Value);
           jsdt_Unknown    : begin end;
           else              begin end;
           end;
           
     Publie_Modifications;
end;

function TChamp.GetasDouble: Double;
begin
     case Definition.Info.jsDataType
     of
       jsdt_String     : Result:= StrToFloat( PString  ( Valeur)^);
       jsdt_Date       : Result:= PDateTime( Valeur)^;
       jsdt_DateTime   : Result:= PDateTime( Valeur)^;
       jsdt_Integer    : Result:= PInteger ( Valeur)^;
       jsdt_Currency   : Result:= PCurrency( Valeur)^;
       jsdt_Double     : Result:= PDouble  ( Valeur)^;
       jsdt_Boolean    : Result:= Integer  ( PtrBoolean ( Valeur)^);//peu utile
       jsdt_ShortString: Result:= StrToFloat( PShortString  ( Valeur)^);
       jsdt_Unknown    : Result:= 0;
       else              Result:= 0;
       end;
end;

procedure TChamp.SetasDouble(const Value: Double);
begin
     if not ReadOnly
     then
         case Definition.Info.jsDataType
         of
           jsdt_String     : PString  ( Valeur)^:= FloatToStr( Value);
           jsdt_Date       : PDateTime( Valeur)^:= Value;
           jsdt_DateTime   : PDateTime( Valeur)^:= Value;
           jsdt_Integer    : PInteger ( Valeur)^:= Trunc( Value);
           jsdt_Currency   : PCurrency( Valeur)^:= Value;
           jsdt_Double     : PDouble  ( Valeur)^:= Value;
           jsdt_Boolean    : PtrBoolean ( Valeur)^:= Boolean( Trunc(Value));//peu utile
           jsdt_ShortString: PShortString( Valeur)^:= FloatToStr( Value);
           jsdt_Unknown    : begin end;
           else              begin end;
           end;
     Publie_Modifications;
end;

function TChamp.GetasBoolean: Boolean;
begin
     case Definition.Info.jsDataType
     of
       jsdt_String     : Result:= StrToBool( PString  ( Valeur)^);
       jsdt_Date       : Result:= Boolean( Trunc( PDateTime( Valeur)^));
       jsdt_DateTime   : Result:= Boolean( Trunc( PDateTime( Valeur)^));
       jsdt_Integer    : Result:= Boolean( Trunc( PInteger ( Valeur)^));
       jsdt_Currency   : Result:= Boolean( Trunc( PCurrency( Valeur)^));
       jsdt_Double     : Result:= Boolean( Trunc( PDouble  ( Valeur)^));
       jsdt_Boolean    : Result:= PtrBoolean ( Valeur)^;
       jsdt_ShortString: Result:= StrToBool( PShortString  ( Valeur)^);
       jsdt_Unknown    : Result:= False;
       else              Result:= False;
       end;
end;

procedure TChamp.SetasBoolean(const Value: Boolean);
begin
     if not ReadOnly
     then
         case Definition.Info.jsDataType
         of
           jsdt_String     : PString  ( Valeur)^:= BoolToStr( Value);
           jsdt_Date       : PDateTime( Valeur)^:= Integer( Value);
           jsdt_DateTime   : PDateTime( Valeur)^:= Integer( Value);
           jsdt_Integer    : PInteger ( Valeur)^:= Integer( Value);
           jsdt_Currency   : PCurrency( Valeur)^:= Integer( Value);
           jsdt_Double     : PDouble  ( Valeur)^:= Integer( Value);
           jsdt_Boolean    : PtrBoolean( Valeur)^:= Value;
           jsdt_ShortString: PShortString( Valeur)^:= BoolToStr( Value);
           jsdt_Unknown    : begin end;
           else              begin end;
           end;
     Publie_Modifications;
end;

function TChamp.GetasInteger: Integer;
begin
     case Definition.Info.jsDataType
     of
       jsdt_String     : Result:= StrToInt( PString  ( Valeur)^);
       jsdt_Date       : Result:= Trunc( PDateTime( Valeur)^);
       jsdt_DateTime   : Result:= Trunc( PDateTime( Valeur)^);
       jsdt_Integer    : Result:= PInteger ( Valeur)^;
       jsdt_Currency   : Result:= Trunc( PCurrency( Valeur)^);
       jsdt_Double     : Result:= Trunc( PDouble  ( Valeur)^);
       jsdt_Boolean    : Result:= Integer( PtrBoolean( Valeur)^);
       jsdt_ShortString: Result:= StrToInt( PShortString  ( Valeur)^);
       jsdt_Unknown    : Result:= 0;
       else              Result:= 0;
       end;
end;

procedure TChamp.SetasInteger(const Value: Integer);
begin
     if not ReadOnly
     then
         case Definition.Info.jsDataType
         of
           jsdt_String     : PString  ( Valeur)^:= IntToStr( Value);
           jsdt_Date       : PDateTime( Valeur)^:= Value;
           jsdt_DateTime   : PDateTime( Valeur)^:= Value;
           jsdt_Integer    : PInteger ( Valeur)^:= Value;
           jsdt_Currency   : PCurrency( Valeur)^:= Value;
           jsdt_Double     : PDouble  ( Valeur)^:= Value;
           jsdt_Boolean    : PtrBoolean(Valeur)^:= Boolean( Value);
           jsdt_ShortString: PShortString  ( Valeur)^:= IntToStr( Value);
           jsdt_Unknown    : begin end;
           else              begin end;
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
     case Definition.Info.jsDataType
     of
       jsdt_String     : Traite_String;
       jsdt_Date       : S.Write( Valeur, SizeOf( TDateTime));
       jsdt_DateTime   : S.Write( Valeur, SizeOf( TDateTime));
       jsdt_Integer    : S.Write( Valeur, SizeOf( Integer  ));
       jsdt_Currency   : S.Write( Valeur, SizeOf( Currency ));
       jsdt_Double     : S.Write( Valeur, SizeOf( Double   ));
       jsdt_Boolean    : S.Write( Valeur, SizeOf( Boolean  ));
       jsdt_ShortString: Traite_ShortString;
       jsdt_Unknown    : begin end;
       else              begin end;
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
     case Definition.Info.jsDataType
     of
       jsdt_String     : Traite_String;
       jsdt_Date       : S.Read( Valeur, SizeOf( TDateTime));
       jsdt_DateTime   : S.Read( Valeur, SizeOf( TDateTime));
       jsdt_Integer    : S.Read( Valeur, SizeOf( Integer  ));
       jsdt_Currency   : S.Read( Valeur, SizeOf( Currency ));
       jsdt_Double     : S.Read( Valeur, SizeOf( Double   ));
       jsdt_Boolean    : S.Read( Valeur, SizeOf( Boolean  ));
       jsdt_ShortString: Traite_ShortString;
       jsdt_Unknown    : begin end;
       else              begin end;
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

     case Definition.Info.jsDataType
     of
       jsdt_String     : begin end;
       jsdt_Date       : if PDateTime( Valeur)^ < Definition.MinValue then PDateTime( Valeur)^:=       Definition.MinValue ;
       jsdt_DateTime   : if PDateTime( Valeur)^ < Definition.MinValue then PDateTime( Valeur)^:=       Definition.MinValue ;
       jsdt_Integer    : if PInteger ( Valeur)^ < Definition.MinValue then PInteger ( Valeur)^:= Trunc(Definition.MinValue);
       jsdt_Currency   : if PCurrency( Valeur)^ < Definition.MinValue then PCurrency( Valeur)^:=       Definition.MinValue ;
       jsdt_Double     : if PDouble  ( Valeur)^ < Definition.MinValue then PDouble  ( Valeur)^:=       Definition.MinValue ;
       jsdt_Boolean    : begin end;
       jsdt_ShortString: begin end;
       jsdt_Unknown    : begin end;
       else              begin end;
       end;
end;

initialization
              Derniere_Modification:= TModification.Create;
finalization
              Free_nil( Derniere_Modification);
end.
