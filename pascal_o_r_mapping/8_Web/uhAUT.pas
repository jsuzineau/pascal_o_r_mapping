unit uhAUT;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uClean,
    uuStrings,
    u_sys_,
    uBatpro_StringList,
    uChampDefinition,
    uChampDefinitions,
    uChamp,
    uChamps,
    uTri_Ancetre,
    uhFiltre_Ancetre,

    uBatpro_Ligne,

    uHTTP_Interface,
    uLog,

  Classes, SysUtils, Controls,strutils,fpjson;

type

 { ThAUT }
 // Gestionnaire pour angular-ui-tree
 //https://github.com/angular-ui-tree/angular-ui-tree
 //http://angular-ui-tree.github.io/angular-ui-tree/#/basic-example

 ThAUT
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _sl : TBatpro_StringList;
                        _Tri   : TTri_Ancetre     = nil;
                        _Filtre: ThFiltre_Ancetre = nil);
    destructor Destroy; override;
  //Répertoire des fichiers
  public
    Repertoire: String;
    function SF( _NomFichier: String): String;
  //Génération des modèles
  private
    function HTML_Header: String;
    function HTML_Node  : String;
  //Données au format JSON
  public
    function Definitions_JSON: String;
    function JSON: String;
  //Réaction au clic sur un titre de colonne
  private
    function Tri_Click( _Reset: Boolean; _NomChamp: String): String;
    function Filtre_Click( _Reset: Boolean; _Champ_Nom, _Champ_Valeur: String): String;
  //Gestion HTTP
  public
    procedure Traite_HTTP;
  //Liste de lignes
  public
    sl: TBatpro_StringList;
  //Gestion du tri
  public
    Tri: TTri_Ancetre;
  //Gestion du filtre
  public
    Filtre: ThFiltre_Ancetre;
  end;

implementation

{ ThAUT }

constructor ThAUT.Create( _sl: TBatpro_StringList;
                          _Tri: TTri_Ancetre;
                          _Filtre: ThFiltre_Ancetre);
begin
     sl    := _sl;
     Tri   := _Tri;
     Filtre:= _Filtre;

     Repertoire
     :=
        IncludeTrailingPathDelimiter( uClean_HTML_Repertoire)
       +ClassName+PathDelim;

     HTTP_Interface.slO.Ajoute( 'AUT/', Self, Traite_HTTP);
end;

destructor ThAUT.Destroy;
begin
     HTTP_Interface.slO.Enleve( 'AUT/');
     inherited Destroy;
end;

function ThAUT.SF( _NomFichier: String): String;
begin
     Result:= String_from_File( Repertoire+_NomFichier);
end;

function ThAUT.HTML_Header: String;
   function Traite_Liste( _sl: TBatpro_StringList): String;
   var
      bl: TBatpro_Ligne;
      I: TIterateur_Champ;
      c: TChamp;
      cd: TChampDefinition;
      Nom: String;
      sTri: String;
      ValeurFiltreChamp: String;
      procedure Calcule_ValeurFiltreChamp;
      var
         iValeur: Integer;
      begin
           iValeur:= Filtre.slCONTIENT.IndexOfName( Nom);
           if -1 = iValeur
           then
               ValeurFiltreChamp:= ''
           else
               ValeurFiltreChamp:= Filtre.slCONTIENT.ValueFromIndex[iValeur];
      end;
      procedure Traite_Chercher_Remplacer;
      var
         S: String;
      begin
           S:= SF( 'treeHeader.Champ.html');

           S:= StringReplace( S, 'NomChamp'              , cd.Nom           , [rfReplaceAll]);
           S:= StringReplace( S, 'LibelleChamp'          , cd.Libelle + sTri, [rfReplaceAll]);
           S:= StringReplace( S, 'ValeurFiltreChamp'     , ValeurFiltreChamp, [rfReplaceAll]);

           Result:= Result + S;
      end;

   begin
        Result:= SF( 'treeHeader.prefixe.html');
        try
           bl:= Batpro_Ligne_from_sl( _sl, 0);
           if nil = bl then exit;

           I:= bl.Champs.sl.Iterateur;
           while I.Continuer
           do
             begin
             if I.not_Suivant( c) then continue;

             cd:= c.Definition;
             Nom:= cd.Nom;

             if Tri = nil
             then
                 sTri:= sys_Vide
             else
                 case Tri.ChampTri[ Nom]
                 of
                   -1:  sTri:= ' \';
                    0:  sTri:= sys_Vide;
                   +1:  sTri:= ' /';
                   else sTri:= sys_Vide;
                   end;

             Calcule_ValeurFiltreChamp;

             Traite_Chercher_Remplacer;
             //vtc.MinWidth:= cd.Longueur*10;
             end;
        finally
               Result:= Result + SF( 'treeHeader.suffixe.html');
               end;
   end;
begin
     Result:= Traite_Liste( sl);
end;

function ThAUT.HTML_Node: String;
   function Traite_Liste( _sl: TBatpro_StringList): String;
   var
      bl: TBatpro_Ligne;
      I: TIterateur_Champ;
      c: TChamp;
      cd: TChampDefinition;
      Nom: String;
   begin
        Result:= SF( 'treeNode.prefixe.html');

        try
           bl:= Batpro_Ligne_from_sl( _sl, 0);
           if nil = bl then exit;

           I:= bl.Champs.sl.Iterateur;
           while I.Continuer
           do
             begin
             if I.not_Suivant( c) then continue;

             cd:= c.Definition;
             Nom:= cd.Nom;

             Result
             :=
                 Result
               + StringReplace(
                   SF( 'treeNode.Champ.html'),
                   'NomChamp',
                   Nom,
                   [rfReplaceAll]
                   );
             end;
        finally
               Result:= Result + SF( 'treeNode.suffixe.html');
               end;
   end;
begin
     Result:= Traite_Liste( sl);
end;

function ThAUT.Definitions_JSON: String;
   function Traite_Liste( _sl: TBatpro_StringList): String;
   var
      bl: TBatpro_Ligne;
      I: TIterateur_Champ;
      c: TChamp;
      cd: TChampDefinition;
      Nom: String;
      sTri: String;
      ValeurFiltreChamp: String;
      Somme_Longueur: Integer;
      Longueur_Arbre: Integer;
      sPourcentageLongueur_Arbre: String;
      PourcentRestant: double;
      procedure Calcule_ValeurFiltreChamp;
      var
         iValeur: Integer;
      begin
           iValeur:= Filtre.slCONTIENT.IndexOfName( Nom);
           if -1 = iValeur
           then
               ValeurFiltreChamp:= ''
           else
               ValeurFiltreChamp:= Filtre.slCONTIENT.ValueFromIndex[iValeur];
      end;
      function sPourcentage_from_Pourcentage( _Pourcentage: double): String;
      begin
           Str( _Pourcentage:5:2,Result);
           Result
           :=
              '"'
             +StringToJSONString(Trim( Result)+'%')
             +'"';
      end;
      function sPourcentage_from_Longueur( _Longueur: Integer): String;
      var
         Pourcentage_Longueur: double;
      begin
           Pourcentage_Longueur:= Trunc( (_Longueur/Somme_Longueur)*100);
           Result:= sPourcentage_from_Pourcentage( Pourcentage_Longueur);
           PourcentRestant:= PourcentRestant - Pourcentage_Longueur;
      end;
      procedure Traite_Champ;
      var
         S: String;
         sPourcentage_Longueur: String;
      begin
           sPourcentage_Longueur:= sPourcentage_from_Longueur( cd.Longueur);

           S:= '';
           Formate_Liste( S, ',', '"NomChamp":"'          + StringToJSONString(cd.Nom               )+'"');
           Formate_Liste( S, ',', '"LibelleChamp":"'      + StringToJSONString(cd.Libelle + sTri    )+'"');
           Formate_Liste( S, ',', '"ValeurFiltreChamp":"' + StringToJSONString(ValeurFiltreChamp    )+'"');
           Formate_Liste( S, ',', '"PourcentageLongueur":'+ sPourcentage_Longueur                        );
           Formate_Liste( S, ',', '"Longueur":'           + IntToStr(cd.Longueur)                        );
           S:= '{' + S + '}';

           Formate_Liste( Result, ',', S);
      end;
      procedure Traite_Longueurs_fixes;
      begin
           sPourcentageLongueur_Arbre    := sPourcentage_from_Pourcentage( PourcentRestant);
      end;
      procedure Calcul_Somme_Longueur;
      const
           Ajustement=1;
      begin
           Somme_Longueur:= Longueur_Arbre;
           I:= bl.Champs.sl.Iterateur;
           while I.Continuer
           do
             begin
             if I.not_Suivant( c) then continue;

             cd:= c.Definition;
             if not cd.Persistant then continue;

             Inc( Somme_Longueur, cd.Longueur);
             end;
           //ajustement empirique
           Inc(Somme_Longueur,Ajustement+Tri.NbChampsTri*1);
      end;
      procedure Formate_Resultat;
      var
         S: String;
      begin
           S:= '';

           Formate_Liste( S, ',', '"Tri_slSousDetails_Count":'  + IntToStr( Tri.slSousDetails.Count)+'' );
           Formate_Liste( S, ',', '"PourcentageLongueur_Arbre":'+ sPourcentageLongueur_Arbre        +'' );
           Formate_Liste( S, ',', '"Longueur_Arbre":'           + IntToStr(Longueur_Arbre      )    +'' );
           Formate_Liste( S, ',', '"Somme_Longueur":'           + IntToStr(Somme_Longueur)          +'' );
           Formate_Liste( S, ',', '"Champs":'                   + '[' + Result + ']'                +'' );
           S:= '{' + S + '}';
           Result:= S;
      end;
   begin
        Result:= '';
        try
           bl:= Batpro_Ligne_from_sl( _sl, 0);
           if nil = bl then exit;

           PourcentRestant:= 100;
           Longueur_Arbre:= Tri.Longueur_Arbre( bl.Champs);
           Calcul_Somme_Longueur;

           I:= bl.Champs.sl.Iterateur;
           while I.Continuer
           do
             begin
             if I.not_Suivant( c) then continue;

             cd:= c.Definition;
             if not cd.Persistant then continue;

             Nom:= cd.Nom;

             if Tri = nil
             then
                 sTri:= sys_Vide
             else
                 case Tri.ChampTri[ Nom]
                 of
                   -1:  sTri:= ' \';
                    0:  sTri:= sys_Vide;
                   +1:  sTri:= ' /';
                   else sTri:= sys_Vide;
                   end;

             Calcule_ValeurFiltreChamp;

             Traite_Champ;
             //vtc.MinWidth:= cd.Longueur*10;
             end;
           Traite_Longueurs_fixes;
        finally
               Formate_Resultat;
               end;
   end;
begin
  Result:= Traite_Liste( sl);
end;

function ThAUT.JSON: String;
var
   Batpro_StringList: TBatpro_StringList;
begin
     if False//Tri.slSousDetails.Count > 0
     then
         Batpro_StringList:= Tri.slSousDetails
     else
         Batpro_StringList:= sl;
     Result:= Batpro_StringList.JSON_Persistants;
end;

function ThAUT.Tri_Click( _Reset: Boolean; _NomChamp: String): String;
var
   NewChampTri: Integer;
   procedure Traite_NomChamp;
   begin
        case Tri.ChampTri[ _NomChamp]
        of
          -1:  NewChampTri:=  0;
           0:  NewChampTri:= +1;
          +1:  NewChampTri:= -1;
          else NewChampTri:=  0;
          end;
        Tri.ChampTri[ _NomChamp]:= NewChampTri;
   end;
begin
     if _Reset
     then
         Tri.Reset_ChampsTri;

     if '' <> _NomChamp
     then
         Traite_NomChamp;

     Tri.Execute_et_Cree_SousDetails( sl);

     Result:= JSON;
end;

function ThAUT.Filtre_Click( _Reset: Boolean; _Champ_Nom, _Champ_Valeur: String): String;
begin
     if _Reset then Filtre.Clear;

     Filtre.CritereCONTIENT( _Champ_Nom, _Champ_Valeur);
     Filtre.Execute;
     Tri.Execute_et_Cree_SousDetails( sl);//pas sûr que ce soit nécessaire
     Result:= JSON;
end;

procedure ThAUT.Traite_HTTP;
var
   uri: String;
  procedure Traite_Racine;
  var
     NomFichier: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( 'index.html');
       if FileExists( NomFichier)
       then
           begin
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_HTML( S);
           Log.PrintLn( 'Envoi racine ');
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
  procedure Traite_Tri;
  var
     Reset: Boolean;
     NomChamp: String;
     S: String;
  begin
       Reset:= HTTP_Interface.Prefixe('0');
       NomChamp:= HTTP_Interface.uri;
       S:= Tri_Click( Reset, NomChamp);
       HTTP_Interface.Send_JSON( S);
       Log.PrintLn( 'Tri_Click:'#13#10+S);
  end;
  procedure Traite_Filtre;
  var
     Reset: Boolean;
     NomChamp: String;
     ValeurFiltre: String;
     S: String;
  begin
       Reset:= HTTP_Interface.Prefixe('0');
       NomChamp:= StrTok( ',',HTTP_Interface.uri);
       ValeurFiltre:= HTTP_Interface.uri;
       S:= Filtre_Click( Reset, NomChamp, ValeurFiltre);
       HTTP_Interface.Send_JSON( S);
       Log.PrintLn( 'Filtre_Click:'#13#10+S);
  end;
  procedure Traite_Header;
  var
     S: String;
  begin
       S:= HTML_Header;
       HTTP_Interface.Send_HTML( S);
       Log.PrintLn( 'HTML_Header:'#13#10+S);
  end;
  procedure Traite_Node;
  var
     S: String;
  begin
       S:= HTML_Node;
       HTTP_Interface.Send_HTML( S);
       Log.PrintLn( 'Envoi HTML_Node:'#13#10+S);
  end;
  procedure Traite_Definitions_JSON;
  var
     S: String;
  begin
       S:= Definitions_JSON;
       HTTP_Interface.Send_JSON( S);
       Log.PrintLn( 'Envoi Definitions_JSON:'#13#10+S);
  end;
  procedure Traite_JSON;
  var
     S: String;
  begin
       S:= JSON;
       HTTP_Interface.Send_JSON( S);
       Log.PrintLn( 'Envoi JSON:'#13#10+S);
  end;
  procedure Traite_Page_precedente;
  var
     S: String;
  begin
       sl.JSON_Page_precedente;
       S:= JSON;
       HTTP_Interface.Send_JSON( S);
       Log.PrintLn( 'Envoi JSON:'#13#10+S);
  end;
  procedure Traite_Page_suivante;
  var
     S: String;
  begin
       sl.JSON_Page_suivante;
       S:= JSON;
       HTTP_Interface.Send_JSON( S);
       Log.PrintLn( 'Envoi JSON:'#13#10+S);
  end;
  procedure Traite_Fichier;
  var
     NomFichier: String;
     Extension: String;
     S: String;
  begin
       NomFichier:= Repertoire+SetDirSeparators( uri);
       if FileExists( NomFichier)
       then
           begin
           Log.PrintLn( 'Envoi fichier '#13#10+uri);
           Extension:= LowerCase(ExtractFileExt(uri));
           S:= String_from_File( NomFichier);
           HTTP_Interface.Send_MIME_from_Extension( S, Extension);
           end
       else
           begin
           HTTP_Interface.Send_Not_found;
           Log.PrintLn( '#### Fichier non trouvé :'#13#10+uri);
           end;
  end;
begin
     uri:= HTTP_Interface.uri;
          if '' = uri                                       then Traite_Racine
     else if HTTP_Interface.Prefixe( 'Tri/')                then Traite_Tri
     else if HTTP_Interface.Prefixe( 'Filtre/')             then Traite_Filtre
     else if HTTP_Interface.Prefixe( 'AUT_Definitions.json')then Traite_Definitions_JSON
     else if HTTP_Interface.Prefixe( 'AUT.json')            then Traite_JSON
     else if HTTP_Interface.Prefixe( 'Page_precedente')     then Traite_Page_precedente
     else if HTTP_Interface.Prefixe( 'Page_suivante')       then Traite_Page_suivante
     else if HTTP_Interface.Prefixe( 'treeHeader.html')     then Traite_Header
     else if HTTP_Interface.Prefixe( 'treeNode.html')       then Traite_Node
     else                                                        Traite_Fichier;
end;

end.

