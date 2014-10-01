unit uContexteMembre;
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
    StarUML_TLB,
    uGlobal,
    uContexteClasse;

type
 TContexteMembre
 =
  class
  //Attributs
  public
    cc: TContexteClasse;
    Member: IUMLAttribute;
    Member_Name: String;
    CleEtrangere: Boolean;
    _sClasseMembre: String;
    sNomTableMembre: String;
    sNomChamp: String;
    sClasseMembreType: String;
    sTypChamp: String;
    sTyp: String;
    sDetail: String;
  //Gestion du cycle de vie
  public
    constructor Create( _cc: TContexteClasse; _Member: IUMLAttribute);
  //Méthodes
  private
  end;


implementation

{ TContexteMembre }

constructor TContexteMembre.Create( _cc: TContexteClasse; _Member: IUMLAttribute);
begin
     cc:= _cc;
     Member:= _Member;

     Member_Name  := Member.Name;
     //Delete( Member_Name, 1, 4); // _1__ jsPortage_de_repas
     //Delete( Member_Name, 1, 5); // _01__ jsComptaMatieres, LeLogisVarsois, These

     sDetail:= cc.NomTable+'_'+Member_Name;

     CleEtrangere:= Assigned( Member.Type_);

     if CleEtrangere
     then
         _sClasseMembre:= Member.Type_.Name
     else
         _sClasseMembre:= Member.TypeExpression;
     sNomTableMembre:= NomTable_from_ClassName( _sClasseMembre);

     if CleEtrangere
     then
         sNomChamp:= 'id'+Member_Name
     else
         sNomChamp:= Member_Name;

     if Premiere_Classe
     then
         begin
         if CleEtrangere
         then
             sClasseMembreType:= ', aggrégation faible / clé étrangère'
         else
             sClasseMembreType:= '';
         S:= S + _sClasseMembre+sClasseMembreType+#13#10;
         end;

     if CleEtrangere
     then
         sTypChamp:= 'CLE'
     else
         sTypChamp:= _sClasseMembre;

     sTyp:= sTypChamp;
          if UpperCase( sTyp) = 'DATE'    then sTyp:= 'TDateTime'
     else if UpperCase( sTyp) = 'FLOAT'   then sTyp:= 'Double'
     else if UpperCase( sTyp) = 'GRAPHIC' then sTyp:= 'String'
     else if UpperCase( sTyp) = 'MEMO'    then sTyp:= 'String';
end;

end.
