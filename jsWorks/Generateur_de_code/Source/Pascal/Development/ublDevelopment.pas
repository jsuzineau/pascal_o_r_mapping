unit ublDevelopment;
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
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type
  { ThaDevelopment__Tag }    
  ThaDevelopment__Tag        
  =                                                   
   class( ThAggregation)                              
   //Gestion du cycle de vie                                                      
   public                                                                         
     constructor Create( _Parent: TBatpro_Element;                                
                         _Classe_Elements: TBatpro_Element_Class;                 
                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override; 
     destructor  Destroy; override;                                               
   //Chargement de tous les détails                   
   public                                             
     procedure Charge; override;                      
   //Création d'itérateur                                             
   protected                                                           
     class function Classe_Iterateur: TIterateur_Class; override;      
   public                                                              
     function Iterateur: TIterateur_Tag;               
     function Iterateur_Decroissant: TIterateur_Tag;   
   end;                                                               


 TblDevelopment
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    nProject: Integer;
    nState: Integer;
    nCreationWork: Integer;
    nSolutionWork: Integer;
    Description: String;
    Steps: String;
    Origin: String;
    Solution: String;
    nCategorie: Integer;
    isBug: Integer;
    nDemander: Integer;
    nSheetRef: Integer;
  //Gestion de la clé
  public
  
    function sCle: String; override;
  //Aggrégations                                                                          
  protected                                                                               
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Tag correspondants                                                   
  private                                                                                                   
    FhaTag: ThaDevelopment__Tag;                                     
    function GethaTag: ThaDevelopment__Tag;                          
  public                                                                                                    
    property haTag: ThaDevelopment__Tag read GethaTag; 

  end;

 TIterateur_Development
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblDevelopment);
    function  not_Suivant( var _Resultat: TblDevelopment): Boolean;
  end;

 TslDevelopment
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
    function Iterateur: TIterateur_Development;
    function Iterateur_Decroissant: TIterateur_Development;
  end;

function blDevelopment_from_sl( sl: TBatpro_StringList; Index: Integer): TblDevelopment;
function blDevelopment_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblDevelopment;

implementation

function blDevelopment_from_sl( sl: TBatpro_StringList; Index: Integer): TblDevelopment;
begin
     _Classe_from_sl( Result, TblDevelopment, sl, Index);
end;

function blDevelopment_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblDevelopment;
begin
     _Classe_from_sl_sCle( Result, TblDevelopment, sl, sCle);
end;

{ TIterateur_Development }

function TIterateur_Development.not_Suivant( var _Resultat: TblDevelopment): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Development.Suivant( var _Resultat: TblDevelopment);
begin
     Suivant_interne( _Resultat);
end;

{ TslDevelopment }

constructor TslDevelopment.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblDevelopment);
end;

destructor TslDevelopment.Destroy;
begin
     inherited;
end;

class function TslDevelopment.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Development;
end;

function TslDevelopment.Iterateur: TIterateur_Development;
begin
     Result:= TIterateur_Development( Iterateur_interne);
end;

function TslDevelopment.Iterateur_Decroissant: TIterateur_Development;
begin
     Result:= TIterateur_Development( Iterateur_interne_Decroissant);
end;

{ ThaDevelopment__Tag }                                            
                                                                                            
constructor ThaDevelopment__Tag.Create( _Parent: TBatpro_Element;  
                               _Classe_Elements: TBatpro_Element_Class;                     
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);               
begin                                                                                       
     inherited;                                                                             
     if Classe_Elements <> _Classe_Elements                                                 
     then                                                                                   
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10                       
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10               
                          +'_Classe_Elements='+_Classe_Elements.ClassName                      
                          );                                                                   
end;                                                                                           
                                                                                               
destructor ThaDevelopment__Tag.Destroy;                               
begin                                                                                          
     inherited;                                                                                
end;                                                                                           
                                                                                               
class function ThaDevelopment__Tag.Classe_Iterateur: TIterateur_Class;
begin                                                                                          
     Result:= TIterateur_Tag;                                                  
end;                                                                                           
                                                                                               
function ThaDevelopment__Tag.Iterateur: TIterateur_Tag;
begin                                                                                           
     Result:= TIterateur_Tag( Iterateur_interne);                               
end;                                                                                            
                                                                                                
function ThaDevelopment__Tag.Iterateur_Decroissant: TIterateur_Tag;
begin                                                                                           
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);                   
end;                                                                                            


{ TblDevelopment }

constructor TblDevelopment.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Development';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Development';

     //champs persistants
     Champs. Integer_from_Integer( nProject       , 'nProject'       );
     Champs. Integer_from_Integer( nState         , 'nState'         );
     Champs. Integer_from_Integer( nCreationWork  , 'nCreationWork'  );
     Champs. Integer_from_Integer( nSolutionWork  , 'nSolutionWork'  );
     Champs.  String_from_String ( Description    , 'Description'    );
     Champs.  String_from_String ( Steps          , 'Steps'          );
     Champs.  String_from_String ( Origin         , 'Origin'         );
     Champs.  String_from_String ( Solution       , 'Solution'       );
     Champs. Integer_from_Integer( nCategorie     , 'nCategorie'     );
     Champs. Integer_from_Integer( isBug          , 'isBug'          );
     Champs. Integer_from_Integer( nDemander      , 'nDemander'      );
     Champs. Integer_from_Integer( nSheetRef      , 'nSheetRef'      );

end;

destructor TblDevelopment.Destroy;
begin

     inherited;
end;



function TblDevelopment.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblDevelopment.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Tag' = Name then P.Faible( ThaDevelopment__Tag, TblTag, poolTag)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblDevelopment.GethaTag: ThaDevelopment__Tag;
begin                                                        
     if FhaTag = nil                           
     then                                                    
         FhaTag:= Aggregations['Tag'] as ThaDevelopment__Tag;
                                                             
     Result:= FhaTag;                          
end;                                                         


end.


