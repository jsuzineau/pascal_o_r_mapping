unit ublIP;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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
    ufAccueil_Erreur,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,
    uPublieur,
    uacCloud_Filter,

    uBatpro_Element,
    uBatpro_Ligne,
    ublReputation,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

    upoolReputation,
//Aggregations_Pascal_ubl_uses_details_pas

    SysUtils, Classes,
    {$IFDEF WINDOWS}
    Forms,
    {$ENDIF}
    SqlDB, DB, StrUtils;

type
 TblIP= class;
//pattern_aggregation_classe_declaration

 TIP_Reputation= ( ir_Inconnue, ir_Good, ir_Bad);
 { TblIP }

 TblIP
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    ip_address: Integer;
    nb: Integer;
    debut: String;
    fin: String;
    ip: String;
    Reputation_field: Integer;
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  //champ ip_address
  public
    function sIP_ADDRESS: String;
  //création de requêtes delete
  public
    function Compose_Delete_4_requests: String;
    function Compose_Delete: String;
  //Réputation
  private
    FReputation: TIP_Reputation;
    procedure SetReputation( _Value: TIP_Reputation);
  public
    pReputation: TPublieur;
    property Reputation: TIP_Reputation read FReputation write SetReputation;
  end;

 TIterateur_IP
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblIP);
    function  not_Suivant( out _Resultat: TblIP): Boolean;
  end;

 { TslIP }

 TslIP
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
    function Iterateur: TIterateur_IP;
    function Iterateur_Decroissant: TIterateur_IP;
  //Qualification
  public
    procedure Qualification;
    procedure Qualification_bad;
  end;

function blIP_from_sl( sl: TBatpro_StringList; Index: Integer): TblIP;
function blIP_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblIP;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blIP_from_sl( sl: TBatpro_StringList; Index: Integer): TblIP;
begin
     _Classe_from_sl( Result, TblIP, sl, Index);
end;

function blIP_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblIP;
begin
     _Classe_from_sl_sCle( Result, TblIP, sl, sCle);
end;

{ TIterateur_IP }

function TIterateur_IP.not_Suivant( out _Resultat: TblIP): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_IP.Suivant( out _Resultat: TblIP);
begin
     Suivant_interne( _Resultat);
end;

{ TslIP }

constructor TslIP.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblIP);
end;

destructor TslIP.Destroy;
begin
     inherited;
end;

class function TslIP.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_IP;
end;

function TslIP.Iterateur: TIterateur_IP;
begin
     Result:= TIterateur_IP( Iterateur_interne);
end;

function TslIP.Iterateur_Decroissant: TIterateur_IP;
begin
     Result:= TIterateur_IP( Iterateur_interne_Decroissant);
end;

procedure TslIP.Qualification;
var
   acCloud_Filter: TacCloud_Filter;
   I: TIterateur_IP;
   bl: TblIP;
   blReputation: TblReputation;
   Bad_reputation: Boolean;
begin
     acCloud_Filter:= TacCloud_Filter.Create;
     try
        I:= Iterateur;
        try
           while I.Continuer
           do
             begin
             if I.not_Suivant( bl)           then continue;
             if bl.Reputation <> ir_Inconnue then continue;
             if acCloud_Filter.Max_reached   then exit;

             Bad_reputation:= acCloud_Filter.Bad_reputation( bl.ip);
             blReputation:= poolReputation.Assure( bl.ip_address);
             blReputation.Is_Bad:= Bad_reputation;
             if Bad_reputation
             then
                 bl.Reputation:= ir_Bad
             else
                 bl.Reputation:= ir_Good;

             {$IFDEF WINDOWS}
             Application.ProcessMessages;
             {$ENDIF}
             end;
        finally
               FreeAndNil( I);
               end;
     finally
            FreeAndNil( acCloud_Filter);
            end;
end;

procedure TslIP.Qualification_bad;
var
   I: TIterateur_IP;
   bl: TblIP;
   blReputation: TblReputation;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;

          bl.Reputation:= ir_Bad;
          blReputation:= poolReputation.Assure( bl.ip_address);
          blReputation.Is_Bad:= False;
          {$IFDEF WINDOWS}
          Application.ProcessMessages;
          {$ENDIF}
          end;
     finally
            FreeAndNil( I);
            end;
end;

//pattern_aggregation_classe_implementation

{ TblIP }

constructor TblIP.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'IP';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'IP';

     //champs persistants
     Champs. Integer_from_Integer( ip_address     , 'ip_address'     );
     Champs. Integer_from_Integer( nb             , 'nb'             );
     Champs.  String_from_String ( debut          , 'debut'          );
     Champs.  String_from_String ( fin            , 'fin'            );
     Champs.  String_from_String ( ip             , 'ip'             );
     Champs. Integer_from_Integer( Reputation_field,'Reputation'     );

     if '' = ip
     then
         begin
         ip:= Format( '%d.%d.%d.%d',
                      [
                      Hi(Hi(Longint(ip_address))),
                      Lo(Hi(Longint(ip_address))),
                      Hi(Lo(Longint(ip_address))),
                      Lo(Lo(Longint(ip_address)))
                      ]);
         Save_to_database;
         end;
     FReputation:= ir_Inconnue;
     pReputation:= TPublieur.Create(ClassName+'.pReputation');
//Pascal_ubl_constructor_pas_detail
end;

destructor TblIP.Destroy;
begin
     FreeAndNil( pReputation);
     inherited;
end;

//pattern_sCle_from__Implementation

function TblIP.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblIP.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

function TblIP.sIP_ADDRESS: String;
begin
     Result:= IntToStr( LongWord(Longint( ip_address)));
end;

function TblIP.Compose_Delete_4_requests: String;
begin
     Result
     :=
        '#'+#13#10
       +'# '+IntToStr(id)+' '+ip+' '+debut+' '+fin+' nb:'+IntToStr(nb)+#13#10
       +'#'+#13#10

       +'delete                                                           '#13#10
       +'      g                                                          '#13#10
       +'from                                                             '#13#10
       +'              pslx_connections        as c                       '#13#10
       +'    left join pslx_guest              as g using( id_guest      )'#13#10
       +'where                                                            '#13#10
       +'         c.ip_address = '+sIP_ADDRESS+';                         '#13#10

       +'delete                                                           '#13#10
       +'      p                                                          '#13#10
       +'from                                                             '#13#10
       +'              pslx_connections        as c                       '#13#10
       +'    left join pslx_connections_page   as p using( id_connections)'#13#10
       +'where                                                            '#13#10
       +'         c.ip_address = '+sIP_ADDRESS+';                         '#13#10

       +'delete                                                           '#13#10
       +'from                                                             '#13#10
       +'    pslx_connections_source                                      '#13#10
       +'where                                                            '#13#10
       +'     id_connections                                              '#13#10
       +'     in                                                           '#13#10
       +'           (                                                     '#13#10
       +'           select                                                '#13#10
       +'                 id_connections                                  '#13#10
       +'           from                                                  '#13#10
       +'               pslx_connections        as c                      '#13#10
       +'           where                                                 '#13#10
       +'                c.ip_address = '+sIP_ADDRESS+'                   '#13#10
       +'           )                                                     '#13#10
       +IfThen( nb < 50000,
                ';                                                        '#13#10,
                'limit 50000;                                             '#13#10
                )

       +'delete                                                           '#13#10
       +'      c                                                          '#13#10
       +'from                                                             '#13#10
       +'              pslx_connections        as c                       '#13#10
       +'where                                                            '#13#10
       +'         c.ip_address = '+sIP_ADDRESS+';                '#13#10#13#10;

end;

function TblIP.Compose_Delete: String;
begin
     Result
     :=
        '# '+IntToStr(id)+' '+ip+' '+debut+' '+fin+' nb:'+IntToStr(nb)+#13#10
       +'delete                                                           '#13#10
       +'      c, s, p, g                                                 '#13#10
       +'from                                                             '#13#10
       +'              pslx_connections        as c                       '#13#10
       +'    left join pslx_connections_source as s using( id_connections)'#13#10
       +'    left join pslx_connections_page   as p using( id_connections)'#13#10
       +'    left join pslx_guest              as g using( id_guest      )'#13#10
       +'where                                                            '#13#10
       +'         c.ip_address = '+sIP_ADDRESS+';                         '#13#10#13#10
end;

procedure TblIP.SetReputation(_Value: TIP_Reputation);
var
   nReputation: Integer;
begin
     FReputation:= _Value;
     pReputation.Publie;

     nReputation:= Integer(FReputation);
     if Reputation_field <> nReputation
     then
         begin
         Reputation_field:= nReputation;
         Save_to_database;
         end;
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


