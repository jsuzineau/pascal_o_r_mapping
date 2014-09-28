unit uf_Valeur_monetaire_en_lettres;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ufpBas, StdCtrls, ActnList, ComCtrls, Buttons, ExtCtrls;

type
 Tf_Valeur_monetaire_en_lettres
 =
  class(TfpBas)
    Panel1: TPanel;
    l: TLabel;
    e: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    m: TMemo;
    mSources: TMemo;
    procedure eChange(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute: Boolean; override;

  end;

function f_Valeur_monetaire_en_lettres: Tf_Valeur_monetaire_en_lettres;

implementation

uses
    uClean,
    uuStrings,
    U_BTP;

{$R *.dfm}

var
   Ff_Valeur_monetaire_en_lettres: Tf_Valeur_monetaire_en_lettres;

function f_Valeur_monetaire_en_lettres: Tf_Valeur_monetaire_en_lettres;
begin
     Clean_Get( Result, Ff_Valeur_monetaire_en_lettres, Tf_Valeur_monetaire_en_lettres);
end;

{ Tf_Valeur_monetaire_en_lettres }

procedure Tf_Valeur_monetaire_en_lettres.eChange(Sender: TObject);
var
   V: Extended;
   Code: Integer;
begin
     Val( e.Text, V, Code);
     if Code = 0
     then
         l.Caption:= Traduction( V, '');
end;

function Tf_Valeur_monetaire_en_lettres.Execute: Boolean;
var
   I: Integer;
   sSource: String;
   S: String;
   sValeur: String;
   sCDDEV: String;
   Valeur: Extended;
   Erreur: Integer;
   Msg: String;
begin
     m.Clear;
     for I:= 0 to mSources.Lines.Count
     do
       begin
       sSource:= mSources.Lines[ I];
       S:= sSource;
       sValeur:= StrToK( ' ', S);
       sCDDEV:= S;

       Val( sValeur, Valeur, Erreur);
       if Erreur = 0
       then
           Msg:=Format('%15s -> %s',[sSource, Traduction( Valeur, sCDDEV)])
       else
           Msg:=Format('Erreur dans la source au caractère %d >%s<',[Erreur,sValeur]);
       m.Lines.Add( Msg);
       end;


     Result:= inherited Execute;
end;

initialization
              Clean_CreateD( Ff_Valeur_monetaire_en_lettres, Tf_Valeur_monetaire_en_lettres);
finalization
              Clean_Destroy( Ff_Valeur_monetaire_en_lettres);
end.
