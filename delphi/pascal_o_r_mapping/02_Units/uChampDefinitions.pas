unit uChampDefinitions;
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
    SysUtils, Classes, DB,Types, 
    uBatpro_StringList,
    uClean,
    uDataUtilsU,
    u_sys_,
    uChampDefinition,
    ufAccueil_Erreur;

type
 TChampDefinitions
 =
  class
  private
    Fsl: TBatpro_StringList;
  public
    NomTable: String;
    constructor Create;
    destructor Destroy; override;

    property sl   : TBatpro_StringList read Fsl;

    function Ajoute( Field: String; _FieldType: TFieldType;
                     Persistant: Boolean; F: TField): TChampDefinition;
    function Ajoute_Lookup( Field: String;
                            _FieldType: TFieldType;
                            LookupKey: TChampDefinition): TChampDefinition;
  //persistance
  public
    function ComposeSQL: String;
    function ComposeSQLInsert: String;
    function ComposeSQLChercheSerial: String;
    function ComposeSQLDelete: String;
  // accés
  public
    function Definition( I: Integer): TChampDefinition;
    function Definition_from_Field( Field: String): TChampDefinition;
    function Count: Integer;
  //accés direct à des propriétés de définitions
  public
    procedure Definition_SetVisible( Field: String; Visible: Boolean);
    procedure Definition_SetLibelle( Field: String; Libelle: String);
  end;

 TIterateur_ChampDefinitions
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TChampDefinitions);
    function  not_Suivant( var _Resultat: TChampDefinitions): Boolean;
  end;

 TslChampDefinitions
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
    function Iterateur: TIterateur_ChampDefinitions;
    function Iterateur_Decroissant: TIterateur_ChampDefinitions;
  end;

var
   uChampDefinitions_ChampDefinitions: TslChampDefinitions= nil;

function ChampDefinitions_from_ClassName( _ClassName: String): TChampDefinitions;

implementation

function ChampDefinitions_from_ClassName_sans_creation( _ClassName: String): TChampDefinitions;
var
   I: Integer;
begin
     Result:= nil;

     I:= uChampDefinitions_ChampDefinitions.IndexOf( _ClassName);
     if I = -1 then exit;

     TObject(Result):= uChampDefinitions_ChampDefinitions.Objects[I];

     CheckClass( Result, TChampDefinitions);
end;


function ChampDefinitions_from_ClassName( _ClassName: String): TChampDefinitions;
begin
     Result:= ChampDefinitions_from_ClassName_sans_creation( _ClassName);

     if Assigned( Result) then exit;

     Result:= TChampDefinitions.Create;
     uChampDefinitions_ChampDefinitions.AddObject( _ClassName, Result);
end;

{ TIterateur_ChampDefinitions }

function TIterateur_ChampDefinitions.not_Suivant( var _Resultat: TChampDefinitions): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ChampDefinitions.Suivant( var _Resultat: TChampDefinitions);
begin
     Suivant_interne( _Resultat);
end;

{ TslChampDefinitions }

constructor TslChampDefinitions.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TChampDefinitions);
end;

destructor TslChampDefinitions.Destroy;
begin
     inherited;
end;

class function TslChampDefinitions.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_ChampDefinitions;
end;

function TslChampDefinitions.Iterateur: TIterateur_ChampDefinitions;
begin
     Result:= TIterateur_ChampDefinitions( Iterateur_interne);
end;

function TslChampDefinitions.Iterateur_Decroissant: TIterateur_ChampDefinitions;
begin
     Result:= TIterateur_ChampDefinitions( Iterateur_interne_Decroissant);
end;

{ TChampDefinitions }

constructor TChampDefinitions.Create;
begin
     Fsl:= TBatpro_StringList.Create;
end;

destructor TChampDefinitions.Destroy;
var
   Champ: TChampDefinition;
begin
     while sl.Count > 0
     do
       begin
       Champ:= ChampDefinition_from_sl( sl, 0);
       if Assigned( Champ)
       then
           Free_nil( Champ);
       sl.Delete( 0);
       end;
     Free_nil( Fsl   );
     inherited;
end;

function TChampDefinitions.Ajoute( Field: String;
                                   _FieldType: TFieldType;
                                   Persistant:Boolean;
                                   F: TField): TChampDefinition;
begin
     Result:= TChampDefinition.Create( Field, _FieldType, Persistant,F);
     sl.AddObject( Field, Result);
end;

function TChampDefinitions.Ajoute_Lookup( Field                : String;
                                          _FieldType           : TFieldType;
                                          LookupKey: TChampDefinition
                                          ): TChampDefinition;
begin
     Result:= TChampDefinition.Create_Lookup( Field, _FieldType, LookupKey);
     sl.AddObject( Field, Result);
end;

function TChampDefinitions.ComposeSQL: String;
var
   I: Integer;
   Premier_set  : Boolean;
   FieldName: String;
   Champ: TChampDefinition;
   sSet: String;
begin
     sSet  := sys_Vide;
     Premier_set  := True;
     for I:= 0 to sl.Count-1
     do
       begin
       Champ:= ChampDefinition_from_sl( sl, I);
       if Assigned( Champ)
       then
           if Champ.Persistant
           then
               begin
               FieldName:= Champ.Nom;
               if FieldName <> 'id'
               then
                   begin
                   if Premier_set
                   then
                       Premier_set:= False
                   else
                       sSet:= sSet + ','+sys_N;

                   sSet:= sSet + '   '+FieldName+'= :'+FieldName;
                   end;
               end;
       end;

     Result
     :=
         'update'+         sys_N
       + '      '+NomTable+sys_N
       + 'set'   +         sys_N
       + sSet    +         sys_N
       + 'where' +         sys_N
       + '         id = :id';
end;

function TChampDefinitions.ComposeSQLInsert: String;
var
   I: Integer;
   Premier_Columns: Boolean;
   FieldName: String;
   Champ: TChampDefinition;
   sColumns, sValues: String;
begin
     sColumns:= sys_Vide;
     sValues := sys_Vide;
     Premier_Columns:= True;
     for I:= 0 to sl.Count-1
     do
       begin
       Champ:= ChampDefinition_from_sl( sl, I);
       if Assigned( Champ)
       then
           if Champ.Persistant
           then
               begin
               if Premier_Columns
               then
                   Premier_Columns:= False
               else
                   begin
                   sColumns:= sColumns + ','+sys_N;
                   sValues := sValues  + ','+sys_N;
                   end;

               FieldName:= Champ.Nom;
               sColumns:= sColumns + '  '+FieldName;
               sValues := sValues  + ' :'+FieldName;
               end;
       end;

     Result
     :=
         'insert'+         sys_N
       + 'into'+sys_N
       + '    '+NomTable+sys_N
       + '       ('+sys_N
       + '       '+sColumns+sys_N
       + '       )'+sys_N
       + 'values '+sys_N
       + '       ('+sys_N
       + '       '+sValues+sys_N
       + '       )';
end;


function TChampDefinitions.ComposeSQLChercheSerial: String;
begin
     // le from et le where sont là juste pour qu informix accepte la requete
     Result
     :=
       'select                              '+#13#10+
       '      dbinfo(''sqlca.sqlerrd1'') as id'+#13#10+
       'from                                '+#13#10+
       '    systables                       '+#13#10+
       'where                               '+#13#10+
       '     tabid =1                       '+#13#10;

end;

function TChampDefinitions.ComposeSQLDelete: String;
begin
     Result:= 'delete from '+NomTable+' where id = :id';
end;

function TChampDefinitions.Definition(I: Integer): TChampDefinition;
begin
     Result:= ChampDefinition_from_sl( sl, I);
end;

function TChampDefinitions.Count: Integer;
begin
     Result:= sl.Count;
end;

function TChampDefinitions.Definition_from_Field( Field: String): TChampDefinition;
var
   I: Integer;
begin
     I:= sl.IndexOf( Field);
     Result:= Definition( I);
end;

procedure TChampDefinitions.Definition_SetVisible( Field: String; Visible: Boolean);
var
   cd: TChampDefinition;
begin
     cd:= Definition_from_Field( Field);
     if cd = nil
     then
         begin
         fAccueil_Erreur( Format( 'Erreur à signaler au développeur:'+sys_N+
                                  'TChampDefinitions.Definition_SetVisible'+sys_N+
                                  'Le champ %s sur %s n''a pas été trouvé.',
                                  [Field, NomTable]));
         exit;
         end;

     cd.Visible:= Visible;
end;

procedure TChampDefinitions.Definition_SetLibelle(Field, Libelle: String);
var
   cd: TChampDefinition;
begin
     cd:= Definition_from_Field( Field);
     if cd = nil
     then
         begin
         fAccueil_Erreur( Format( 'Erreur à signaler au développeur:'+sys_N+
                                  'TChampDefinitions.Definition_SetLibelle'+sys_N+
                                  'Le champ %s sur %s n''a pas été trouvé.',
                                  [Field, NomTable]));
         exit;
         end;

     cd.Libelle:= Libelle;
end;

initialization
              uChampDefinitions_ChampDefinitions
              :=
                TslChampDefinitions.Create( 'uChampDefinitions_ChampDefinitions');
finalization
              Free_nil( uChampDefinitions_ChampDefinitions);
end.
