unit ublWork;
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
  { ThaWork__Tag }    
  ThaWork__Tag        
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


 TblWork
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    id: Integer;
    nProject: Integer;
    Beginning: TDateTime;
    End: TDateTime;
    Description: String;
    nUser: Integer;
  //Gestion de la clé
  public
  
    function sCle: String; override;
  //Aggrégations                                                                          
  protected                                                                               
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Tag correspondants                                                   
  private                                                                                                   
    FhaTag: ThaWork__Tag;                                     
    function GethaTag: ThaWork__Tag;                          
  public                                                                                                    
    property haTag: ThaWork__Tag read GethaTag; 

  end;

 TIterateur_Work
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblWork);
    function  not_Suivant( var _Resultat: TblWork): Boolean;
  end;

 TslWork
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
    function Iterateur: TIterateur_Work;
    function Iterateur_Decroissant: TIterateur_Work;
  end;

function blWork_from_sl( sl: TBatpro_StringList; Index: Integer): TblWork;
function blWork_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblWork;

implementation

function blWork_from_sl( sl: TBatpro_StringList; Index: Integer): TblWork;
begin
     _Classe_from_sl( Result, TblWork, sl, Index);
end;

function blWork_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblWork;
begin
     _Classe_from_sl_sCle( Result, TblWork, sl, sCle);
end;

{ TIterateur_Work }

function TIterateur_Work.not_Suivant( var _Resultat: TblWork): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Work.Suivant( var _Resultat: TblWork);
begin
     Suivant_interne( _Resultat);
end;

{ TslWork }

constructor TslWork.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblWork);
end;

destructor TslWork.Destroy;
begin
     inherited;
end;

class function TslWork.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Work;
end;

function TslWork.Iterateur: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne);
end;

function TslWork.Iterateur_Decroissant: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne_Decroissant);
end;

{ ThaWork__Tag }                                            
                                                                                            
constructor ThaWork__Tag.Create( _Parent: TBatpro_Element;  
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
                                                                                               
destructor ThaWork__Tag.Destroy;                               
begin                                                                                          
     inherited;                                                                                
end;                                                                                           
                                                                                               
class function ThaWork__Tag.Classe_Iterateur: TIterateur_Class;
begin                                                                                          
     Result:= TIterateur_Tag;                                                  
end;                                                                                           
                                                                                               
function ThaWork__Tag.Iterateur: TIterateur_Tag;
begin                                                                                           
     Result:= TIterateur_Tag( Iterateur_interne);                               
end;                                                                                            
                                                                                                
function ThaWork__Tag.Iterateur_Decroissant: TIterateur_Tag;
begin                                                                                           
     Result:= TIterateur_Tag( Iterateur_interne_Decroissant);                   
end;                                                                                            


{ TblWork }

constructor TblWork.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Work';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Work';

     //champs persistants
     Champs. Integer_from_Integer( id             , 'id'             );
     Champs. Integer_from_Integer( nProject       , 'nProject'       );
     Champs.DateTime_from_       ( Beginning      , 'Beginning'      );
     Champs.DateTime_from_       ( End            , 'End'            );
     Champs.  String_from_String ( Description    , 'Description'    );
     Champs. Integer_from_Integer( nUser          , 'nUser'          );

end;

destructor TblWork.Destroy;
begin

     inherited;
end;



function TblWork.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblWork.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Tag' = Name then P.Faible( ThaWork__Tag, TblTag, poolTag)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblWork.GethaTag: ThaWork__Tag;
begin                                                        
     if FhaTag = nil                           
     then                                                    
         FhaTag:= Aggregations['Tag'] as ThaWork__Tag;
                                                             
     Result:= FhaTag;                          
end;                                                         


end.


