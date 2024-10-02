unit uParametres_Ancetre;
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
    uChampDefinition,
    uChamp,
    uChampDefinitions,
    uChamps,
    u_sys_,
    uPublieur,

    uBatpro_Ligne,

    ufAccueil_Erreur,
    SysUtils, Classes, DB(*,DBTables*);

const
     sys_Parametre_Debut= '%';
     sys_Parametre_Fin  = '%';

type
 TParametres_Ancetre
 =
  class
  public
    Liste: TBatpro_StringList;
    { TParametres.OnCharge
       "On" en anglais "Charge" en français ...
    }
    OnCharge: TPublieur;
    constructor Create;
    destructor Destroy; override;
    procedure Charge;
    function Traite( S: String): String;
    procedure Ajoute_Dataset(Prefixe: String; D: TDataset);
    procedure Ajoute_Ligne( _Prefixe: String; _bl: TBatpro_Ligne; _Classe: TBatpro_Ligne_Class);
    procedure AjouteValeur(NomValeur: String; Nul: Boolean;Valeur: String = '');
    procedure Vide;
    function Valeur_from_Cle(Cle: String): String;
    procedure AjouteValeurs_D_INF( Prefixe: String; Query: TDataset;
                                   fCHAP, fCGP: TStringField;
                                   fD1: TDateField); overload;
  end;

var
   Parametres_Ancetre: TParametres_Ancetre= nil;

implementation

constructor TParametres_Ancetre.Create;
begin
     inherited;
     Liste:= TBatpro_StringList.Create;
     Liste.Sorted:= True;
     OnCharge:= TPublieur.Create('Parametres.OnCharge');
end;

destructor TParametres_Ancetre.Destroy;
begin
     Vide;
     Free_nil( OnCharge);
     Free_nil( Liste   );
     inherited;
end;

procedure TParametres_Ancetre.AjouteValeur( NomValeur: String; Nul: Boolean;
                                    Valeur: String = '');
var
   I: Integer;
   P: PChar;
   procedure P_from_Valeur;
   begin
        if not Nul
        then
            P:= StrNew( PChar(Valeur))
        else
            P:= nil;
   end;
begin
     I:= Liste.IndexOf( NomValeur);
     if I = -1
     then
         begin
         P_from_Valeur;
         Liste.AddObject( NomValeur, TObject(P));
         end
     else
         begin
         P:= PChar(Liste.Objects[ I]);
         if P = nil
         then
             begin
             P_from_Valeur;
             Liste.Objects[ I]:= TObject(P);
             end
         else if Valeur <> sys_Vide
         then
             fAccueil_Erreur( 'Erreur à signaler au développeur'+sys_N+
                              '   TParametres.AjouteValeur('+NomValeur+','+Valeur+'): '+
                              NomValeur+' est déjà défini.');
         end;
end;

procedure TParametres_Ancetre.Ajoute_Dataset(Prefixe: String; D: TDataset);
var
   I: Integer;
   F: TField;
   DActive: Boolean;
   NomCle: String;
   Valeur: String;
begin
     DActive:= D.Active;
     with D.FieldList
     do
       for I:= 0 to Count - 1
       do
         begin
         F:= Fields[ I];
         NomCle:= Prefixe+'.'+F.FieldName;

         if DActive
         then
             begin
             if F is TMemoField
             then
                 Valeur:= F.AsString
             else
                 Valeur:= F.DisplayText;
             AjouteValeur( NomCle, False, Valeur);
             end
         else
             AjouteValeur( NomCle, True);
         end;
end;

procedure TParametres_Ancetre.Charge;
begin
     Vide;
     AjouteValeur( 'DATE', False, FormatDateTime( 'dddddd', Date));
     OnCharge.Publie;
end;

function TParametres_Ancetre.Valeur_from_Cle( Cle: String): String;
var
   I: Integer;
   O: TObject;
   P: PChar;
   procedure Enleve_Balises_RTF;
   var
      S, Balise: String;
   begin
        S:= sys_Vide;
        while Cle <> sys_Vide
        do
          begin
          S:= S + StrToK( '\', Cle);
          Balise:= StrToK( ' ', Cle);
          end;
        Cle:= S;
   end;
begin
     Enleve_Balises_RTF;
     I:= Liste.IndexOf( Cle);
     if I = -1
     then
         Result:= '>%'+Cle+'% non trouvé<'
     else
         begin
         O:= Liste.Objects[ I];
         P:= PChar(O);
         Result:= StrPas( P);
         end;
end;

function TParametres_Ancetre.Traite( S: String): String;
var
   Cle, Valeur: String;
begin
     Result:= sys_Vide;

     while S <> sys_Vide
     do
       begin
       Result:= Result + StrTok( sys_Parametre_Debut, S);
       Cle   :=          StrTok( sys_Parametre_Fin  , S);
       if Cle = sys_Vide
       then
           Valeur:= sys_Parametre_Debut
       else
           Valeur:= Valeur_from_Cle( Cle);
       Result:= Result + Valeur;
       end;
end;

procedure TParametres_Ancetre.Vide;
var
   I: Integer;
   O: TObject;
   P: PChar;
begin
     for I:= 0 to Liste.Count - 1
     do
       begin
       O:= Liste.Objects[ I];
       if Assigned( O)
       then
           begin
           Liste.Objects[ I]:= nil;
           P:= PChar(O);
           StrDispose( P);
           end;
       end;
     Liste.Clear;
end;

procedure TParametres_Ancetre.AjouteValeurs_D_INF( Prefixe: String; Query: TDataset;
                                           fCHAP, fCGP: TStringField;
                                           fD1: TDateField);

   function NomValeur( CHAP, CGP: String): String;
   begin
        Result:= Format( '%sD_INF(%s,%s).d1', [ Prefixe, CHAP, CGP]);
   end;
begin
     if not Query.Active
     then
         AjouteValeur( NomValeur( sys_Vide, sys_Vide), True)
     else
         begin
         Query.First;
         while not Query.EOF
         do
           begin
           AjouteValeur( NomValeur( fCHAP.Value, fCGP .Value), False,
                         FormatDateTime( 'ddddd', fD1.Value));
           Query.Next;
           end;
         end;
end;

procedure TParametres_Ancetre.Ajoute_Ligne( _Prefixe: String;
                                            _bl: TBatpro_Ligne;
                                            _Classe: TBatpro_Ligne_Class);
var
   ChampDefinitions: TChampDefinitions;
   Champs: TChamps;
   I: Integer;
   C: TChamp;
   D: TChampDefinition;
   NomCle: String;
   Valeur: String;
begin
     if Assigned( _bl)
     then
         begin
         Champs:= _bl.Champs;
         for I:= 0 to Champs.Count - 1
         do
           begin
           C:= Champs.Champ_from_Index( I);
           if C = nil then continue;

           D:= C.Definition;

           NomCle:= _Prefixe+'.'+D.Nom;

           Valeur:= C.Chaine;

           AjouteValeur( NomCle, False, Valeur);
           end;
         end
     else
         begin
         ChampDefinitions:= ChampDefinitions_from_ClassName( _Classe.ClassName);
         if Assigned( ChampDefinitions)
         then
             begin
             for I:= 0 to ChampDefinitions.Count - 1
             do
               begin
               D:= ChampDefinitions.Definition( I);
               if D = nil then continue;

               NomCle:= _Prefixe+'.'+D.Nom;
               AjouteValeur( NomCle, True);
               end;
             end;
         end;
end;

end.

