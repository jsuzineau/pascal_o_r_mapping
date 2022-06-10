unit uhFiltre;
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
    uBatpro_StringList,
    uLog,
    uContrainte,
    u_sys_,
    uuStrings,
    ubtString,
    uChamp,
    uChamps,
    uPublieur,
    uDataUtilsU,
    uDataUtilsF,

    uBatpro_Element,
    uBatpro_Ligne,

    ufAccueil_Erreur,

    uTri,
    uhFiltre_Ancetre,


    SysUtils, Classes;

{ ThFiltre
Ancêtre pour les classe "handler" de filtre (propriétés Filter/Filtered
d'un TDataset)
La méthode Execute sert à mettre à jour la valeur du filtre
}

type
 ThFiltre
 =
  class( ThFiltre_Ancetre)
  //Cycle de vie
  public
    constructor Create( _btsCle: TbtString; _slFiltre: TBatpro_StringList; _Tri: TTri = nil); virtual;
    destructor Destroy; override;
  //Général
  private
    btsCle: TbtString;
    slFiltre: TBatpro_StringList;
    procedure Extraction;
  public
    AfterExecute: TAbonnement_Objet_Proc;
    Filtre_actif: Boolean;
    function Initialise( _Contraintes: array of TContrainte): Boolean;
    function Execute: Boolean;override;
    procedure AjouteCritereLIKE     (NomChamp, ValeurChamp: String);override;
    procedure AjouteCritereLIKE_ou_VIDE(NomChamp, ValeurChamp: String);override;
    procedure AjouteCritereOR_LIKE  (NomChamp, ValeurChamp: String);override;//non géré en dataset
    procedure AjouteCritereDIFFERENT(NomChamp, ValeurChamp: String);override;
    procedure AjouteCritereEGAL     (NomChamp, ValeurChamp: String);override;
    procedure AjouteCritereCONTIENT (NomChamp, ValeurChamp: String);override;

    procedure CritereCONTIENT( _NomChamp, _ValeurChamp: String);override;
    function Actif: Boolean;
  //Travail avec une StringList comme source
  //initialisation non mise dans le constructeur pour ne pas changer les appels
  //et surcharges
  private
    procedure Traite_slsCle;
  public
    slsCle: TBatpro_StringList;
  //Gestion Batpro_Ligne
  protected
    function Execute_bl_interne( bl: TBatpro_Ligne): Boolean; virtual;
  public
    function Execute_bl( bl: TBatpro_Ligne): Boolean;
  //Gestion du tri
  private
    Detruire_Tri: Boolean;
  public
    Tri: TTri;
  //Remise à zéro
  public
    procedure Clear; override;
  //Affichage
  public
    function Contenu: String;
  end;

 ThFiltre_Class= class of ThFiltre;

implementation

constructor ThFiltre.Create( _btsCle: TbtString; _slFiltre: TBatpro_StringList; _Tri: TTri= nil);
begin
     inherited Create;
     btsCle:= _btsCle;
     slsCle:= nil;

     slFiltre   := _slFiltre   ;

     //si l'on ne passe pas d'objet Tri en paramètre, on en créée un en local
     Tri:= _Tri;
     Detruire_Tri:= Tri = nil;
     if Detruire_Tri
     then
         Tri:= TTri.Create;

     slLIKE     := TBatpro_StringList.Create;
     slOR_LIKE  := TBatpro_StringList.Create;
     slLIKE_ou_VIDE:= TBatpro_StringList.Create;
     slDIFFERENT:= TBatpro_StringList.Create;
     slEGAL     := TBatpro_StringList.Create;
     slCONTIENT := TBatpro_StringList.Create;

     AfterExecute:= nil;
     Filtre_actif:= false;
     Clear;
end;

destructor ThFiltre.Destroy;
begin
     Free_nil( slLIKE     );
     Free_nil( slOR_LIKE  );
     Free_nil( slLIKE_ou_VIDE);
     Free_nil( slDIFFERENT);
     Free_nil( slEGAL     );
     Free_nil( slCONTIENT );

     if Detruire_Tri
     then
         Free_nil( Tri)
     else
         Tri:= nil;

     inherited;
end;

function ThFiltre.Initialise( _Contraintes: array of TContrainte): Boolean;
var
   I:Integer;

begin
     Clear;

     SetLength( Contraintes, Length( _Contraintes));
     for I:= Low( Contraintes) to High( Contraintes)
     do
       Contraintes[I]:= _Contraintes[I];

     Result:= True;
end;

procedure ThFiltre.Extraction;
var
   bl: TBatpro_Ligne;
begin
     if btsCle   = nil then exit;
     if slFiltre = nil then exit;

     slFiltre.Clear;
     try
        btsCle.Iterateur_Start;
        while not btsCle.Iterateur_EOF
        do
          begin
          btsCle.Iterateur_Suivant( bl);
          if Assigned( bl)
          then
              if bl.Passe_le_filtre
              then
                  slFiltre.AddObject( bl.sCle, bl);
          end;
     finally
            btsCle.Iterateur_Stop;
            end;

     Tri.Execute( slFiltre);
end;

procedure ThFiltre.Traite_slsCle;
var
   I: TIterateur;
   bl: TBatpro_Ligne;
begin
     if slsCle   = nil then exit;
     if slFiltre = nil then exit;

     slFiltre.Clear;

     I:= slsCle.Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;
       Execute_bl_interne( bl);
       if bl.Passe_le_filtre
       then
           slFiltre.AddObject( bl.sCle, bl);
       end;

     Tri.Execute( slFiltre);
end;

function ThFiltre.Execute:Boolean;
var
   bl: TBatpro_Ligne;
begin
     try
        if Assigned( btsCle)
        then
            begin
            try
               btsCle.Iterateur_Start;
               while not btsCle.Iterateur_EOF
               do
                 begin
                 btsCle.Iterateur_Suivant( bl);
                 Execute_bl_interne( bl);
                 end;
            finally
                   btsCle.Iterateur_Stop;
                   end;
            end;
        Traite_slsCle;
     finally
            Filtre_actif:= Has_Critere;
            Result:= True;
            end;

     Extraction;

     if Assigned( AfterExecute)
     then
         AfterExecute;
end;

function ThFiltre.Execute_bl_interne( bl: TBatpro_Ligne): Boolean;
begin
     Result:= Assigned( bl);
     if Result
     then
         Result:= bl.Calcule_Passe_le_filtre( Self);
end;

function ThFiltre.Execute_bl( bl: TBatpro_Ligne): Boolean;
begin
     Result:= Execute_bl_interne( bl);
     //if Result
     //then
     //    if Assigned( AfterExecute)
     //    then
     //        AfterExecute;
end;

procedure ThFiltre.AjouteCritereLIKE     ( NomChamp, ValeurChamp: String);
begin
     if ValeurChamp <> sys_Vide
     then
         begin

         if -1 <> slLIKE.IndexOfName( NomChamp)
         then
             fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                              +'  ThFiltre.AjouteCritereLIKE: le champ '
                              +    NomChamp+ ' est déjà dans la liste' );
         slLIKE.Values[ NomChamp]:= ValeurChamp;
         end;
end;

procedure ThFiltre.AjouteCritereOR_LIKE( NomChamp, ValeurChamp: String);
begin
     if ValeurChamp <> sys_Vide
     then
         slOR_LIKE.Add( NomChamp+'='+ ValeurChamp);
end;

procedure ThFiltre.AjouteCritereLIKE_ou_VIDE( NomChamp, ValeurChamp: String);
begin
     if ValeurChamp <> sys_Vide
     then
         begin

         if -1 <> slLIKE_ou_VIDE.IndexOfName( NomChamp)
         then
             fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                              +'  ThFiltre.AjouteCritereLIKE_ou_VIDE: le champ '
                              +    NomChamp+ ' est déjà dans la liste' );
         slLIKE_ou_VIDE.Values[ NomChamp]:= ValeurChamp;
         end;
end;

procedure ThFiltre.AjouteCritereDIFFERENT( NomChamp, ValeurChamp: String);
begin
     if -1 <> slDIFFERENT.IndexOfName( NomChamp)
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'  ThFiltre.AjouteCritereDIFFERENT: le champ '
                          +    NomChamp+ ' est déjà dans la liste' );
     if ValeurChamp = sys_Vide
     then
         slDIFFERENT.Values[ NomChamp]:= uhFiltre_Ancetre_Code_pour_Vide
     else
         slDIFFERENT.Values[ NomChamp]:= ValeurChamp;
end;

procedure ThFiltre.AjouteCritereEGAL( NomChamp, ValeurChamp: String);
begin
     if -1 <> slEGAL.IndexOfName( NomChamp)
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'  ThFiltre.AjouteCritereEGAL: le champ '
                          +    NomChamp+ ' est déjà dans la liste' );
     if ValeurChamp = sys_Vide
     then
         slEGAL.Values[ NomChamp]:= uhFiltre_Ancetre_Code_pour_Vide
     else
         slEGAL.Values[ NomChamp]:= ValeurChamp;
end;

procedure ThFiltre.AjouteCritereCONTIENT( NomChamp, ValeurChamp: String);
begin
     if -1 <> slCONTIENT.IndexOfName( NomChamp)
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'  ThFiltre.AjouteCritereCONTIENT: le champ '
                          +    NomChamp+ ' est déjà dans la liste' );
     if ValeurChamp = sys_Vide
     then
         slCONTIENT.Values[ NomChamp]:= uhFiltre_Ancetre_Code_pour_Vide
     else
         slCONTIENT.Values[ NomChamp]:= ValeurChamp;
end;

procedure ThFiltre.CritereCONTIENT( _NomChamp, _ValeurChamp: String);
    procedure Enleve;
    var
       I: Integer;
    begin
         I:= slCONTIENT.IndexOfName( _NomChamp);
         if -1 = I
         then
             begin
//             Log.PrintLn( 'ThFiltre.CritereCONTIENT, Enleve :'#13#10+slCONTIENT.Text);
             exit;
             end;
         slCONTIENT.Delete( I);
    end;
    procedure Affecte;
    begin
         slCONTIENT.Values[ _NomChamp]:= _ValeurChamp;
    end;
begin
     //Attention sFiltre non mis à jour

     if _ValeurChamp = sys_Vide
     then
         Enleve
     else
         Affecte;

end;

function ThFiltre.Actif: Boolean;
begin
     Result:= Has_Critere;
end;

procedure ThFiltre.Clear;
begin
     slLIKE        .Clear;
     slOR_LIKE     .Clear;
     slLIKE_ou_VIDE.Clear;
     slDIFFERENT   .Clear;
     slEGAL        .Clear;
     slCONTIENT    .Clear;
end;

function ThFiltre.Contenu: String;
var
   J: Integer;
   NomChamp, ValeurCritere: String;
   Contrainte: TContrainte;
   procedure CC( _sl: TBatpro_StringList; _Index: Integer);
   var
      Ligne: String;
   begin
       Ligne:= _sl.Strings[ _Index];
       NomChamp:= StrTok( '=', Ligne);
       ValeurCritere:= Ligne;
   end;
begin
     Result:= 'slLIKE:';
     for J:= 0 to slLIKE.Count -1
     do
       begin
       cc( slLIKE, J);
       Formate_Liste( Result, #13#10'  ', SQL_Racine( NomChamp, ValeurCritere));
       end;

     Formate_Liste( Result, #13#10, 'slOR_LIKE:');
     for J:= 0 to slOR_LIKE.Count -1
     do
       begin
       cc( slOR_LIKE, J);
       Formate_Liste( Result, #13#10'  ', SQL_Racine( NomChamp, ValeurCritere));
       end;

     Formate_Liste( Result, #13#10, 'slLIKE_ou_VIDE:');
     for J:= 0 to slLIKE_ou_VIDE.Count -1
     do
       begin
       cc( slLIKE_ou_VIDE, J);
       Formate_Liste( Result, #13#10'  ', SQL_Racine( NomChamp, ValeurCritere));
       end;

     Formate_Liste( Result, #13#10, 'slDIFFERENT:');
     for J:= 0 to slDIFFERENT.Count -1
     do
       begin
       cc( slDIFFERENT, J);
       if ValeurCritere = uhFiltre_Ancetre_Code_pour_Vide
       then
           ValeurCritere:= sys_Vide;

       Formate_Liste( Result, #13#10'  ', SQL_OP( NomChamp, '<>', ValeurCritere));
       end;

     Formate_Liste( Result, #13#10, 'slEGAL:');
     for J:= 0 to slEGAL.Count -1
     do
       begin
       cc( slEGAL, J);
       if ValeurCritere = uhFiltre_Ancetre_Code_pour_Vide
       then
           ValeurCritere:= sys_Vide;
       Formate_Liste( Result, #13#10'  ', SQL_EGAL( NomChamp, ValeurCritere));
       end;

     Formate_Liste( Result, #13#10, 'Contraintes:');
     for J:= Low(Contraintes) to High(Contraintes)
     do
       begin
       Contrainte:= Contraintes[ J];
       Formate_Liste( Result, #13#10'  ', Contrainte.Contenu);
       end;
end;

end.


