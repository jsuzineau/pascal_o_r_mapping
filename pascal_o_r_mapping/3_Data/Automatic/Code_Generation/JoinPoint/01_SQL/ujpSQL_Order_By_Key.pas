unit ujpSQL_Order_By_Key;
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
    SysUtils, Classes,
    uGenerateur_Delphi_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type

 { TjpSQL_Order_By_Key }

 TjpSQL_Order_By_Key
 =
  class( TJoinPoint)
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    nfOrder_By: String;
    slOrder_By: TStringList;
  //Gestion de la visite d'une classe
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure VisiteMembre(_cm: TContexteMembre); override;
    procedure Finalise; override;
  end;

var
   jpSQL_Order_By_Key: TjpSQL_Order_By_Key;

implementation

{ TjpSQL_Order_By_Key }

constructor TjpSQL_Order_By_Key.Create;
begin
     Cle:= '      Order_By_Key';
     slOrder_by:= TStringList.Create;
end;

destructor TjpSQL_Order_By_Key.Destroy;
begin
     FreeAndNil( slOrder_by);
     inherited Destroy;
end;

procedure TjpSQL_Order_By_Key.Initialise(_cc: TContexteClasse);
begin
     inherited;
     //Gestion de l'order by
     nfOrder_By:= cc.g.sRepParametres+cc.Nom_de_la_classe+'.order_by.txt';
          if FileExists(   nfOrder_By) then slOrder_by.LoadFromFile( nfOrder_By)
     else if FileExists( cc.nfLibelle) then slOrder_by.LoadFromFile( cc.nfLibelle );
end;

procedure TjpSQL_Order_By_Key.VisiteMembre(_cm: TContexteMembre);
begin
     inherited VisiteMembre(_cm);

     if cm.CleEtrangere then exit;
     if -1 = slOrder_By.IndexOf( cm.sNomChamp) then exit;

     if '' = Valeur
     then
         Valeur:= Valeur+ '      '
     else
         Valeur:= Valeur+ ','+s_SQL_saut+'      ';

     Valeur:= Valeur + cm.sNomChamp;

end;

procedure TjpSQL_Order_By_Key.Finalise;
begin
     inherited Finalise;
     if Valeur = ''
     then
         Valeur:= '      Numero';
     slOrder_by.SaveToFile( nfOrder_By);
end;

initialization
              jpSQL_Order_By_Key:= TjpSQL_Order_By_Key.Create;
finalization
              FreeAndNil( jpSQL_Order_By_Key);
end.
