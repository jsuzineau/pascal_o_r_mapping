unit ucBatproVerifieur;
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
    u_sys_;

type
  TBatproVerifieur = class(TComponent)
  private
    { Déclarations privées }

    //fausses propriétés
    function  GetFalse: Boolean;
    procedure Setbv2_to_bv0(Value: Boolean);
    procedure Do_bv2_to_bv0;
  protected
    { Déclarations protégées }
    FsValeur: String;

    FPoubelle: TComponent;//variable "poubelle" pour propriétés en lecture seule
                          // notamment bv2_Valeur

    procedure Loaded; override;

    // la valeur stockée dans le composant à vérifier
    function  GetComponent_Valeur: TComponent; virtual;
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
    property Component_Valeur: TComponent read  GetComponent_Valeur;
  published
    { Déclarations publiées }
    property bv0sValeur: String read FsValeur write FsValeur;

    property bv2_Valeur:TComponent read GetComponent_Valeur write FPoubelle;

    //fausses propriétés servant à lancer une procédure dans l'EDI de Delphi

    //copie dans bv0sValeur le bvGetNamePath( Valeur)   (Valeur = bv2_Valeur)
    property bv2_to_bv0: Boolean read GetFalse write Setbv2_to_bv0;
  end;

function bvGetNamePath(C: TComponent): String;

implementation

function bvGetNamePath( C: TComponent): String;
var
   O: TComponent;
begin
     Result:= sys_Vide;

     if C= nil then exit;
     Result:= C.GetNamePath;

     O:= C.Owner;
     if O = nil then exit;

     Result:= O.GetNamePath+'.'+Result;
end;

constructor TBatproVerifieur.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);
     FsValeur:= sys_Vide;
end;

function TBatproVerifieur.GetComponent_Valeur: TComponent;
begin
     Result:= nil;          //méthode virtuelle pure
end;

procedure TBatproVerifieur.Loaded;
   procedure Erreur( S: String);
   begin
        S:= bvGetNamePath( Self)+':'+S;
        uForms_ShowMessage( S);
   end;
begin
     inherited;

     if bv0sValeur <> sys_Vide
     then
         if Component_Valeur = nil
         then
             Erreur( 'le composant est à nil alors qu''il devrait pointer sur '+
                     '>'+bv0sValeur+'<');
end;


function TBatproVerifieur.GetFalse: Boolean;
begin
     Result:= False;
end;

procedure TBatproVerifieur.Do_bv2_to_bv0;
begin
     if (bv0sValeur = sys_Vide) and Assigned( Component_Valeur)
     then
         bv0sValeur:= bvGetNamePath( Component_Valeur);
end;

procedure TBatproVerifieur.Setbv2_to_bv0(Value: Boolean);
begin
     if Value
     then
         Do_bv2_to_bv0;
end;

end.
