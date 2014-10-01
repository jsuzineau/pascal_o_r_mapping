unit uMenuHandler;
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
    uPatternHandler;

type
 TMenuHandler
 =
  class
  private
    PAS, DFM: TPatternHandler;
  public
    sRepSource, sRepCible: String;
    sMenu_Base_DFM,
    sMenu_Relation_DFM,
    sMenu_Base_Calcule_DFM,
    sMenu_Relation_Calcule_DFM,
    sMenu_Uses,
    sMenu_Declaration,
    sMenu_Implementation: String;
    slParametres: TStringList;
    constructor Create( _sRepSource, _sRepCible: String);
    destructor Destroy; override;
    procedure Init;
    procedure Add( NomClasse: String; IsRelation, CalculeSaisi_: Boolean);
    procedure Produit;
  end;

implementation

const
           s_DFM_Base_Key= 'object miVide: TMenuItem';
       s_DFM_Relation_Key= 'object miRelationVide: TMenuItem';
           s_DFM_BaseCalcule_Key= 'object miBaseCalculeVide: TMenuItem';
       s_DFM_RelationCalcule_Key= 'object miRelationsCalculeVide: TMenuItem';
               s_Uses_Key= '{Uses_Key}';
        s_Declaration_Key='{Declaration_Key}';
     s_Implementation_Key='{Implementation_Key}';

     s_MenuHandler_Form_Name= 'fPatternMainMenu';

{ TMenuHandler }

constructor TMenuHandler.Create( _sRepSource, _sRepCible: String);
begin
     slParametres:= TStringList.Create;
     PAS:=TPatternHandler.Create(_sRepSource+'u'+s_MenuHandler_Form_Name+'.pas',_sRepCible,slParametres);
     DFM:=TPatternHandler.Create(_sRepSource+'u'+s_MenuHandler_Form_Name+'.dfm',_sRepCible,slParametres);
     Init;
     sRepSource:= _sRepSource;
     sRepCible := _sRepCible ;
end;

destructor TMenuHandler.Destroy;
begin
     FreeAndNil( PAS);
     FreeAndNil( DFM);
     FreeAndNil( slParametres);
     inherited;
end;

procedure TMenuHandler.Init;
begin
     sMenu_Base_DFM      := '';
     sMenu_Relation_DFM  := '';
     sMenu_Base_Calcule_DFM    := '';
     sMenu_Relation_Calcule_DFM:= '';
     sMenu_Uses          := '';
     sMenu_Declaration   := '';
     sMenu_Implementation:= '';
end;

procedure TMenuHandler.Add( NomClasse: String; IsRelation, CalculeSaisi_: Boolean);
    procedure TraiteDFM( var sDFM: String);
    begin
         sDFM
         :=
             sDFM
           + '      object '+NomClasse+': TMenuItem'#13#10
           + '        Caption = '''+NomClasse+'''  '#13#10
           + '        OnClick = '+NomClasse+'Click '#13#10
           + '      end                            '#13#10;
    end;
begin
     if IsRelation
     then
         if CalculeSaisi_
         then
             TraiteDFM( sMenu_Relation_Calcule_DFM)
         else
             TraiteDFM( sMenu_Relation_DFM        )
     else
         if CalculeSaisi_
         then
             TraiteDFM( sMenu_Base_Calcule_DFM)
         else
             TraiteDFM( sMenu_Base_DFM        );

     if sMenu_Uses <> '' then sMenu_Uses:= sMenu_Uses+','#13#10'  ';
     sMenu_Uses:= sMenu_Uses + 'uf'+NomClasse;

     sMenu_Declaration
     :=
         sMenu_Declaration
       + '    procedure '+NomClasse+'Click(Sender: TObject);'#13#10;

     sMenu_Implementation
     :=
         sMenu_Implementation
       +'procedure T'+s_MenuHandler_Form_Name+'.'+
                                       NomClasse+'Click(Sender: TObject);'#13#10
       +'begin                                                           '#13#10
       +'     f'+NomClasse+'.Execute;                                    '#13#10
       +'end;                                                            '#13#10#13#10;
end;

procedure TMenuHandler.Produit;
begin
     //fermeture des chaines de remplacement
     //on rajoute le bout qu'on va supprimer
     sMenu_Base_DFM    := sMenu_Base_DFM     + s_DFM_Base_Key    ;
     sMenu_Relation_DFM:= sMenu_Relation_DFM + s_DFM_Relation_Key;
     sMenu_Base_Calcule_DFM    := sMenu_Base_Calcule_DFM     +     s_DFM_BaseCalcule_Key;
     sMenu_Relation_Calcule_DFM:= sMenu_Relation_Calcule_DFM + s_DFM_RelationCalcule_Key;

     if sMenu_Uses <> '' then sMenu_Uses:= sMenu_Uses+','#13#10'  ';

     slParametres.Clear;
     slParametres.Values[       s_DFM_Base_Key]:= sMenu_Base_DFM      ;
     slParametres.Values[   s_DFM_Relation_Key]:= sMenu_Relation_DFM  ;
     slParametres.Values[     s_DFM_BaseCalcule_Key]:= sMenu_Base_Calcule_DFM    ;
     slParametres.Values[ s_DFM_RelationCalcule_Key]:= sMenu_Relation_Calcule_DFM;
     slParametres.Values[           s_Uses_Key]:= sMenu_Uses          ;
     slParametres.Values[    s_Declaration_Key]:= sMenu_Declaration   ;
     slParametres.Values[ s_Implementation_Key]:= sMenu_Implementation;

     DFM.Produit('');
     PAS.Produit('');
end;

end.
