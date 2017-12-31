unit ucbvCustomConnection;
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
    uForms,
    SysUtils, Classes, 
    DB, DBTables, SQLExpr;

{ TbvCustomConnection
le préfixe bv est impropre car on ne descend pas de TBatproVerifieur.
Dans l'avenir, l'idéal serait de modifier TBatproVerifieur pour avoir
un ancêtre commun pour ce genre d'objet qui en vérifie un autre.
}

type
  TbvCustomConnection = class(TComponent)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    FCustomConnection: TCustomConnection;

    procedure Loaded; override;

  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
  published
    { Déclarations publiées }
    property bvcc0CustomConnection: TCustomConnection
             read  FCustomConnection
             write FCustomConnection;
  end;

procedure Register;

implementation

uses
    u_sys_,
    ucBatproVerifieur;

procedure Register;
begin
     RegisterComponents('Batpro', [TbvCustomConnection]);
end;

constructor TbvCustomConnection.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);
     FCustomConnection:= nil;
end;

procedure TbvCustomConnection.Loaded;
   procedure Erreur( S: String);
   begin
        S:= bvGetNamePath( Self)+':'+S;
        uForms_ShowMessage( S);
   end;
   procedure Traite_SQLConnection( sqlc: TSQLConnection);
   begin
        if sqlc.Connected
        then
            Erreur( bvGetNamePath( sqlc)+' est connecté dés la création. '+
                    'Ceci peut générer un plantage sur les machines n''ayant '+
                    'pas la même configuration que la machine de développement');
   end;
   procedure Traite_Database( db: TDatabase);
   begin
        if db.Connected
        then
            Erreur( bvGetNamePath( db)+' est connecté dés la création. '+
                    'Ceci peut générer un plantage sur les machines n''ayant '+
                    'pas la même configuration que la machine de développement');
        if db.AliasName <> sys_Vide
        then
            Erreur( bvGetNamePath( db)+' a une valeur d''alias dés la création. '+
                    'Ceci peut générer un plantage sur les machines n''ayant '+
                    'pas la même configuration que la machine de développement');
   end;
begin
     inherited;

     if FCustomConnection = nil
     then
         Erreur( 'la propriété CustomConnection est à nil.')
     else
         begin
              if FCustomConnection is TSQLConnection
         then
             Traite_SQLConnection( TSQLConnection(FCustomConnection))
         else if FCustomConnection is TDatabase
         then
             Traite_Database( TDatabase(FCustomConnection));

         end;
end;

end.
