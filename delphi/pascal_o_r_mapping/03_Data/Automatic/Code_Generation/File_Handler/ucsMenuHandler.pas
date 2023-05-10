unit ucsMenuHandler;
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
    uBatpro_StringList,
    uGenerateur_de_code_Ancetre,
    uTemplateHandler,
    SysUtils, Classes;

type

 { TcsMenuHandler }

 TcsMenuHandler
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _g: TGenerateur_de_code_Ancetre);
    destructor Destroy; override;
  //Attributs
  private
    g: TGenerateur_de_code_Ancetre;
    phCS, phDesigner: TTemplateHandler;
  public
    sCreation,
    sAddRange_Base,
    sAddRange_Relation,
    sAddRange_Base_Calcule,
    sAddRange_Relation_Calcule,
    sItem, sDeclaration,
    sConstructor,
    sClick: String;
    slParametres: TBatpro_StringList;
    procedure Init;
    procedure Add( NomClasse: String; IsRelation, CalculeSaisi_: Boolean);
    procedure Produit;
  end;

implementation

const
     sk_Creation                 = '//Point d''insertion TfMainMenuStrip Creation';
     sk_AddRange_Base            = '/*Point d''insertion TfMainMenuStrip AddRange_Base*/';
     sk_AddRange_Relation        = '/*Point d''insertion TfMainMenuStrip AddRange_Relation*/';
     sk_AddRange_Base_Calcule    = '/*Point d''insertion TfMainMenuStrip AddRange_BaseCalcule*/';
     sk_AddRange_Relation_Calcule= '/*Point d''insertion TfMainMenuStrip AddRange_RelationCalcule*/';
     sk_Item                     = '//Point d''insertion TfMainMenuStrip Item';
     sk_Declaration              = '//Point d''insertion TfMainMenuStrip Declaration';
     sk_Constructor              = '//Point d''insertion TfMainMenuStrip constructor';
     sk_Click                    = '//Point d''insertion TfMainMenuStrip Click';

     s_MenuHandler_Form_Name= 'TfMainMenuStrip';

{ TMenuHandler }

constructor TcsMenuHandler.Create( _g: TGenerateur_de_code_Ancetre);
begin
     g:= _g;

     slParametres:= TBatpro_StringList.Create(ClassName+'.slParametres');
     phCS      :=TTemplateHandler.Create(g,s_RepertoireCSharp+s_MenuHandler_Form_Name+         '.cs',slParametres);
     phDesigner:=TTemplateHandler.Create(g,s_RepertoireCSharp+s_MenuHandler_Form_Name+'.Designer.cs',slParametres);

     Init;
end;

destructor TcsMenuHandler.Destroy;
begin
     FreeAndNil( phCS      );
     FreeAndNil( phDesigner);
     FreeAndNil( slParametres);
     inherited;
end;

procedure TcsMenuHandler.Init;
begin
     sCreation   := '';
     sAddRange_Base            := '';
     sAddRange_Relation        := '';
     sAddRange_Base_Calcule    := '';
     sAddRange_Relation_Calcule:= '';
     sItem       := '';
     sDeclaration:= '';
     sClick      := '';
     sConstructor:= '';
end;

procedure TcsMenuHandler.Add( NomClasse: String; IsRelation, CalculeSaisi_: Boolean);
    procedure TraiteAddRange( var sAddRange: String);
    begin
         //if sAddRange <> ''
         //then
             sAddRange:= sAddRange+', ';
         sAddRange
         :=
             sAddRange
           + 'this.mi'+NomClasse;
    end;
begin
     sCreation
     :=
         sCreation
       + 'this.mi'+NomClasse+' = new System.Windows.Forms.ToolStripMenuItem();'#13#10;

     if IsRelation
     then
         if CalculeSaisi_
         then
             TraiteAddRange( sAddRange_Relation_Calcule)
         else
             TraiteAddRange( sAddRange_Relation        )
     else
         if CalculeSaisi_
         then
             TraiteAddRange( sAddRange_Base_Calcule)
         else
             TraiteAddRange( sAddRange_Base        );

     sItem
     :=
         sItem
       + '       // '#13#10
       + '       // mi'+NomClasse+#13#10
       + '       // '#13#10
       + '       this.mi'+NomClasse+'.Name = "mi'+NomClasse+'";'#13#10
       + '       this.mi'+NomClasse+'.Size = new System.Drawing.Size(152, 22);'#13#10
       + '       this.mi'+NomClasse+'.Text = "'+NomClasse+'";'#13#10
       + '       this.mi'+NomClasse+'.Click += new System.EventHandler(this.mi'+NomClasse+'Click);';
     sDeclaration
     :=
         sDeclaration
       + 'private System.Windows.Forms.ToolStripMenuItem mi'+NomClasse+';';

     sConstructor
     :=
         sConstructor
       + 'Tml'+NomClasse+'.Initialise();'#13#10;

     sClick
     :=
         sClick
       + '       		void mi'+NomClasse+'Click(object sender, System.EventArgs e)'#13#10
       + '       		{                                                   '#13#10
       + '       		 	Tml'+NomClasse+'.fm.Execute();                    '#13#10
       + '    			}                                                   '#13#10;
end;

procedure TcsMenuHandler.Produit;
begin
     slParametres.Clear;
     slParametres.Values[sk_Creation                 ]:= sCreation     ;
     slParametres.Values[sk_AddRange_Base            ]:= sAddRange_Base;
     slParametres.Values[sk_AddRange_Relation        ]:= sAddRange_Relation  ;
     slParametres.Values[sk_AddRange_Base_Calcule    ]:= sAddRange_Base_Calcule;
     slParametres.Values[sk_AddRange_Relation_Calcule]:= sAddRange_Relation_Calcule;
     slParametres.Values[sk_Item                     ]:= sItem         ;
     slParametres.Values[sk_Declaration              ]:= sDeclaration  ;
     slParametres.Values[sk_Constructor              ]:= sConstructor  ;
     slParametres.Values[sk_Click                    ]:= sClick;

     phCS      .Produit;
     phDesigner.Produit;
end;

end.
