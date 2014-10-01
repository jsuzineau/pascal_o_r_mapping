unit uPatterns_from_MCD;
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

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  uBatpro_StringList,
  StarUML_TLB,
  suPatterns_from_MCD_TLB,
  uGenerateur_CSharp,
  uGenerateur_PHP_Doctrine,
  uPatternHandler,
  uMenuHandler,

  uf_f_dbgKeyPress_Key_Pattern,

  Windows, SysUtils, Classes, ComObj, ActiveX, StdVcl, Dialogs, Forms,Inifiles,
  ComServ;

type
 TPatterns_from_MCD
 =
  class( TAutoObject, IStarUMLAddIn)
  //Gestion du cycle de vie
  public
    procedure Initialize; override;
    destructor Destroy; override;
  // Interface avec StarUML, IStarUMLAddIn

  protected
    function InitializeAddIn: HResult; stdcall;
    function FinalizeAddIn: HResult; stdcall;
    function DoMenuAction(ActionID: Integer): HResult; stdcall;
  //Attributs
  private
    StarUMLApp: IStarUMLApplication;
  //Méthodes
  private
    function JustFileName(const FileName: string): string;
    function CalculeSaisi_from_ClassName( ClassName: String): Boolean;
    function NomTable_from_ClassName( ClassName: String): String;
    procedure AjouteUnite( ClasseMembre: String; var ClauseUses: String);
    procedure CreateFiles_Delphi;
  end;

implementation

{ TPatterns_from_MCD }

procedure TPatterns_from_MCD.Initialize;
begin
     inherited;
     StarUMLApp:= CoStarUMLApplication.Create;
     Application.Handle := StarUMLApp.Handle;

     Generateur_CSharp.StarUMLApp:= StarUMLApp;
end;

destructor TPatterns_from_MCD.Destroy;
begin
     Generateur_CSharp.StarUMLApp:= nil;
     StarUMLApp:= nil;
     inherited;
end;

function TPatterns_from_MCD.InitializeAddIn: HResult;
begin
     Result := S_OK;
end;

function TPatterns_from_MCD.FinalizeAddIn: HResult;
begin
     Result := S_OK;
end;

function TPatterns_from_MCD.DoMenuAction(ActionID: Integer): HResult;
begin
     Result := S_OK;
     case ActionID
     of
       1: CreateFiles_Delphi;
       2: Generateur_CSharp.CreateFiles_CSharp;
       3: Generateur_PHP_Doctrine.CreateFiles_PHP;
       end;
end;

function TPatterns_from_MCD.JustFileName(const FileName: string): string;
begin
  Result := ExtractFileName(FileName);
  Result := Copy(Result, 1, Length(Result) - Length(ExtractFileExt(Result)));
end;

function TPatterns_from_MCD.CalculeSaisi_from_ClassName( ClassName: String): Boolean;
begin
     Result:= False;
     //inutile ici, autrefois codé pour jsPortage_de_repas et jsWork
     //if ClassName = '' then exit;

     //Result:= ClassName[1] = 'c';
end;

function TPatterns_from_MCD.NomTable_from_ClassName( ClassName: String): String;
begin
     Result:= ClassName;
     if CalculeSaisi_from_ClassName( ClassName)
     then
         Delete( Result, 1, 1);
end;

procedure TPatterns_from_MCD.AjouteUnite( ClasseMembre: String; var ClauseUses: String);
var
   NomUniteVirgule: String;
begin
     NomUniteVirgule:= 'u'+ClasseMembre+',';
     if 0 = Pos( NomUniteVirgule, ClauseUses)
     then
         ClauseUses:= ClauseUses+ '    '+NomUniteVirgule+#13#10;
end;

procedure TPatterns_from_MCD.CreateFiles_Delphi;
const
     sys_Vide                 = '';
     s_Nom_de_la_table        = 'Nom_de_la_table';
     s_Nom_de_la_classe       = 'Nom_de_la_classe';
     s_Order_By_Key           = '      Order_By_Key';
     s_CREATE_TABLE           = 'CREATE_TABLE';
     s_SQL_saut               = ''''#13#10'      ''';
     s_QfieldsDFM             = '    object qNumero: TIntegerField';
     s_QfieldsPAS             = '    qNumero: TIntegerField;'      ;
     s_QCalcFieldsKey         = '{qCalcFields_Key}';
     s_implementation_uses_key= '{implementation_uses_key}';
     s_Ouverture_key          = '{Ouverture_key}';
     s_Test_Declaration_Key   = '{Test_Declaration_Key}';
     s_Test_Implementation_Key= '{Test_Implementation_Key}';
     s_Test_Call_Key          = '{Test_Call_Key}';
     s_Nouveau_Declaration_Key   = '{Nouveau_Declaration_Key}';
     s_Nouveau_Implementation_Key= '{Nouveau_Implementation_Key}';
     s_f_dbgCellClick_Key     = '     //f_dbgCellClick_Key';
     s_f_dbgKeyPress_Key      = '     //f_dbgKeyPress_Key';
     s_f_dbgKeyPress_Key_Variables='//f_dbgKeyPress_Key_Variables';
     s_f_implementation_uses_key='{f_implementation_uses_key}';
     s_f_Execute_Before_Key   = '               //f_Execute_Before_Key';
     s_f_Execute_After_Key    = '                   //f_Execute_After_Key';

     s_dkd_dbgCellClick_Key   = '     //dkd_dbgCellClick_Key';
     s_dkd_dbgKeyPress_Key    = '     //dkd_dbgKeyPress_Key';
     s_dkd_dbgKeyPress_Key_Variables='//dkd_dbgKeyPress_Key_Variables';
     s_dkd_implementation_uses_key  ='{dkd_implementation_uses_key}';

     s_Traite_Index_key       ='{Traite_Index_key}';
     s_QFields_hr_init        ='//QFields_hr_init';

     s_pattern_declaration_champs = '//pattern_declaration_champs';
var
   NomFichierProjet: String;
   Project: IUMLProject;
   ModelElement: IUMLModelElement;
   Classe: IUMLClass;
   TaggedValue: ITaggedValue;
   Premiere_Classe: Boolean;
   S: String;
   sTaggedValues: String;

   sRepSource, sRepCible,sRepCiblePaquet: String;

   _Classe_Name: String;
   Nom_de_la_table: String;
   Order_By_Key: String;
   SQL_Create : String;
   QfieldsDFM,
   QfieldsPAS: String;
   QCalcFieldsKey: String;
   implementation_uses_key: String;
   Ouverture_key,
   Test_Declaration_Key    ,
   Test_Implementation_Key    : String;
   Test_Implementation_Body   ,
   Nouveau_Declaration_Key    ,
   Nouveau_Implementation_Key ,
   Nouveau_Implementation_Body,
   pattern_declaration_champs ,
   Test_Call_Key              ,
   f_dbgCellClick_Key         ,
   f_dbgKeyPress_Key          ,
   f_dbgKeyPress_Key_Variables,
   f_implementation_uses_key ,
   f_Execute_Before_Key      ,
   f_Execute_After_Key       ,

   dkd_dbgCellClick_Key      ,
   dkd_dbgKeyPress_Key       ,
   dkd_dbgKeyPress_Key_Variables,
   dkd_implementation_uses_key,

   Traite_Index_key,
   QFields_hr_init
                             :String;

   phPAS_DMXCRE,
   phPAS_POOL ,
   phPAS_DMLK ,
   phPAS_DMA  ,
   phPAS_DM   ,
   phPAS_F    ,
   phPAS_FCB  ,
   phPAS_DMD  ,
   phPAS_DKD  ,

   phDFM_DMXCRE,
   phDFM_POOL ,
   phDFM_DMLK ,
   phDFM_DMA  ,
   phDFM_DM   ,
   phDFM_F    ,
   phDFM_FCB  ,
   phDFM_DMD  ,
   phDFM_DKD  ,

   phPAS_BL   ,
   phPAS_HR   ,
   phPAS_HF   ,
   phDPK      ,
   phPAS_TC   : TPatternHandler;
   slParametres: TBatpro_StringList;

   MenuHandler: TMenuHandler;

   slLog: TStringList;
   CalculeSaisi_: Boolean;

   INI: TIniFile;


   nfLibelle : String;
   nfOrder_By: String;
   nfIndex   : String;
   slLibelle :TStringList;
   slOrder_By:TStringList;
   slIndex   :TStringList;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;
   s_dkd: String;
   s_dkd_Accroche,
   s_dkd_Decroche: String;

   slChamps_non_order_by: TStringList;

   procedure CreePatternHandler( var phPAS, phDFM: TPatternHandler; Racine: String);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'u'+Racine+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCiblePaquet,slParametres);
        phDFM:= TPatternHandler.Create( sRepRacine+'.DFM',sRepCiblePaquet,slParametres);
   end;

   procedure CreePatternHandler_PAS( var phPAS: TPatternHandler; Racine: String);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'u'+Racine+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCiblePaquet,slParametres);
   end;

   procedure CreePatternHandler_DPK( var phDPK: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'p'+s_Nom_de_la_classe;
        phDPK:= TPatternHandler.Create( sRepRacine+'.DPK',sRepCiblePaquet,slParametres);
   end;

   procedure CreePatternHandler_HR( var phPAS: TPatternHandler);
   begin
        CreePatternHandler_PAS( phPAS, 'hr');
   end;

   procedure CreePatternHandler_TC( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'utc'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCiblePaquet,slParametres);
   end;

   function SQL_from_Type( Typ: String): String;
   begin
        Typ:= UpperCase( Typ);
             if'STRING'    =Typ then Result:='CHAR(42)'
        else if'INTEGER'   =Typ then Result:='INTEGER'
        else if'DATE'      =Typ then Result:='DATE'
        else if'TDATETIME' =Typ then Result:='DATETIME'
        else if'CURRENCY'  =Typ then Result:='DOUBLE'
        else if'FLOAT'     =Typ then Result:='DOUBLE'
        else if'GRAPHIC'   =Typ then Result:='MEDIUMBLOB'
        else if'MEMO'      =Typ then Result:='TEXT'
        else if'LONGBLOB'  =Typ then Result:='LONGBLOB'
        else
            begin
            Result:= Typ;
            slLog.Add( 'Type non traduit en SQL: '+Typ);
            end;
   end;

   function TypeField_from_Type( Typ: String): String;
   begin
        Typ:= UpperCase( Typ);
             if'STRING'    =Typ then Result:='TStringField'
        else if'INTEGER'   =Typ then Result:='TIntegerField'
        else if'DATE'      =Typ then Result:='TDateField'
        else if'TDATETIME' =Typ then Result:='TDateTimeField'
        else if'CURRENCY'  =Typ then Result:='TCurrencyField'
        else if'FLOAT'     =Typ then Result:='TFloatField'
        else if'LONGBLOB'  =Typ then Result:='TStringField'
        else
            begin
            Result:= 'T'+Typ+'Field';
            slLog.Add( 'Type non traduit en champ: '+Typ);
            end;
   end;

   function Declaration_from_Type( prefixe, NomChamp, Typ: String): String;
   begin
        Result:= prefixe + NomChamp + ': '+ TypeField_from_Type( Typ);
   end;

   function DFM_from_Type( prefixe, NomChamp, Typ: String; notVisible: Boolean): String;
   begin
        Result
        :=
          '    object '+Declaration_from_Type( prefixe, NomChamp, Typ)+#13#10+
          '      FieldName = '''+NomChamp+''''#13#10;
        if notVisible
        then
            Result
            :=
                Result
              + '      Visible = False'#13#10;

        Typ:= UpperCase( Typ);
             if 'STRING'  =Typ then Result:= Result+'      Size = 42'#13#10
        else if 'CURRENCY'=Typ then Result:= Result+'      currency= true'#13#10;

        Result
        :=
          Result +
          '    end'#13#10;
   end;

   function PAS_from_Type( prefixe, NomChamp, Typ: String): String;
   begin
        Result:='    ' + Declaration_from_Type(prefixe,NomChamp,Typ) + ';'#13#10;
   end;

   function hr_init_from_Type( prefixe, NomChamp, Typ: String): String;
   begin
        Result
        :=
            '     '+prefixe+NomChamp
          + ':= '  +prefixe+'.FieldByName('''+ NomChamp+''') as '
          + TypeField_from_Type( Typ)+ ';'#13#10;
   end;

   function DFM_Lookup( prefixe, Member_Name, ClasseLookup: String): String;
   begin
        Result
        :=
          '    object '+Declaration_from_Type(prefixe,Member_Name,'STRING')+#13#10+
          '      FieldName = '''+Member_Name+'''                           '#13#10+
          '      FieldKind = fkLookup                                      '#13#10+
          '      LookupDataSet = dmlk'+ClasseLookup+'.q                    '#13#10+
          '      LookupKeyFields = ''Numero''                              '#13#10+
          '      LookupResultField = ''Libelle''                           '#13#10+
          '      KeyFields = ''n'+Member_Name+'''                          '#13#10+
          '      Lookup = True                                             '#13#10+
          '      Size = 42                                                 '#13#10+
          '    end                                                         '#13#10;
   end;

   function TailleNom( S: String): String;
   begin
        Result:= S;
        while Length( Result) < 15 do Result:= Result + ' ';
   end;
   procedure AjouteIndex( sNomChamp: String);
   begin
        Traite_Index_key:=  Traite_Index_key
                           +'     Traite_Index( '''+sNomChamp+''');'#13#10;
   end;

   procedure Traite_Member( Member: IUMLAttribute);
   var
      Member_Name: String;
      SQL: String;
      sNomChamp: String;
      _sClasseMembre: String;
      sClasseMembre_UPPERCASE: String;
      sNomTableMembre: String;
      sClasseMembreType: String;
      CleEtrangere: Boolean;
      sTypChamp: String;
      sTyp: String;
      sParametre: String;
      sDeclarationParametre: String;
      s_dmLookup: String;
      s_fcb: String;
      procedure pv( var S: String; Debut: String);
      begin
           if S = ''
           then
               S:= Debut
           else
               S:= S + ';';
      end;
      procedure CellClick_KeyPress( prefixe_dm: String;
                                    var CellClick, KeyPress: String);
      begin
            if CellClick = sys_Vide
            then
                CellClick:= '          '
            else
                CellClick:= CellClick + #13#10'     else ';
            CellClick
            :=
                CellClick
              + 'if Column.Field = '+prefixe_dm+Nom_de_la_table+'.q'+Member_Name+'      '#13#10
              + '     then                                                 '#13#10
              + '         begin                                            '#13#10
              + '         Deroule'+sNomTableMembre+'( Column, '+
                              prefixe_dm+Nom_de_la_table+'.qn'+Member_Name+'); '#13#10
              + '         dbg.SelectedIndex:= dbg.SelectedIndex +1;        '#13#10
              + '         end';

            if KeyPress <> sys_Vide
            then
                KeyPress
                :=
                    KeyPress
                  + #13#10'                or ';
            KeyPress
            :=
                KeyPress
              + '(F = '+prefixe_dm+Nom_de_la_table+'.q'+Member_Name+')';
      end;

   begin
        SQL:= '  ';

        Member_Name  := Member.Name;
        //Delete( Member_Name, 1, 4); // _1__ jsPortage_de_repas
        //Delete( Member_Name, 1, 5); // _01__ jsComptaMatieres, LeLogisVarsois, These

        CleEtrangere:= Assigned( Member.Type_);

        if CleEtrangere
        then
            _sClasseMembre:= Member.Type_.Name
        else
            _sClasseMembre:= Member.TypeExpression;

        sClasseMembre_UPPERCASE:= UpperCase( _sClasseMembre);
             if'NCHAR'      =sClasseMembre_UPPERCASE then _sClasseMembre:='String'
        else if'TEXT'       =sClasseMembre_UPPERCASE then _sClasseMembre:='String'
        else if'LONGBLOB'   =sClasseMembre_UPPERCASE then _sClasseMembre:='String'
        else if'SMALLINT'   =sClasseMembre_UPPERCASE then _sClasseMembre:='Integer'
        else if'SERIAL'     =sClasseMembre_UPPERCASE then _sClasseMembre:='Integer'
        else if'DECIMAL'    =sClasseMembre_UPPERCASE then _sClasseMembre:='Double'
        else if'FLOAT'      =sClasseMembre_UPPERCASE then _sClasseMembre:='Double'
        else if'NVARCHAR13' =sClasseMembre_UPPERCASE then _sClasseMembre:='String';

        sNomTableMembre:= NomTable_from_ClassName( _sClasseMembre);

        if CleEtrangere
        then
            begin
            sNomChamp:= 'n'+Member_Name;
            SQL:= SQL+TailleNom( sNomChamp)+' INTEGER';
            AjouteIndex( sNomChamp);
            end
        else
            begin
            sNomChamp:= Member_Name;
            SQL:= SQL+
                  TailleNom(sNomChamp)+' '+SQL_from_Type( _sClasseMembre);
            end;

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
            sTypChamp:= 'INTEGER'
        else
            sTypChamp:= _sClasseMembre;

        sTyp:= sTypChamp;
             if UpperCase( sTyp) = 'DATE'    then sTyp:= 'TDateTime'
        else if UpperCase( sTyp) = 'FLOAT'   then sTyp:= 'Double'
        else if UpperCase( sTyp) = 'GRAPHIC' then sTyp:= 'String'
        else if UpperCase( sTyp) = 'MEMO'    then sTyp:= 'String';

        if UpperCase(sNomChamp) <> 'ID' then
        begin
                SQL_Create:= SQL_Create+','+s_SQL_saut+SQL;
                QfieldsDFM     :=QfieldsDFM     +    DFM_from_Type('q',sNomChamp,sTypChamp,CleEtrangere);
                QfieldsPAS     :=QfieldsPAS     +    PAS_from_Type('q',sNomChamp,sTypChamp);
                QFields_hr_init:=QFields_hr_init+hr_init_from_Type('q',sNomChamp,sTypChamp);
        end;


        pv( Test_Declaration_Key   , '    function Test('         );
        pv( Test_Implementation_Key, 'function Tpool'+_Classe_Name+'.Test(');

        sParametre:= ' _'+sNomChamp;
        sDeclarationParametre:= sParametre+': '+sTyp;
        Test_Declaration_Key    := Test_Declaration_Key   +sDeclarationParametre;
        Test_Implementation_Key := Test_Implementation_Key+sDeclarationParametre;
        Test_Implementation_Body
        :=
          Test_Implementation_Body+
          '       bl.'+TailleNom(sNomChamp)+':='+TailleNom(sParametre)+';'#13#10;


        Nouveau_Declaration_Key   := 'function Nouveau :Tbl'+_Classe_Name+';';
        Nouveau_Implementation_Key:= 'function Tpool'+_Classe_Name+'.Nouveau :Tbl'+_Classe_Name+';';

        pattern_declaration_champs
        :=
           pattern_declaration_champs
           +#13#10'         '
           +sNomChamp
           +': '
           +sTyp
           +';';

        if CleEtrangere
        then
            begin //lookup pour récupération du libellé
            QfieldsDFM:=QfieldsDFM+DFM_Lookup   ('q',Member_Name,sNomTableMembre);
            QfieldsPAS:=QfieldsPAS+PAS_from_Type('q',Member_Name,'STRING');
            QFields_hr_init:=QFields_hr_init+hr_init_from_Type('q',Member_Name,'STRING');

            s_dmLookup:= 'dmlk' + sNomTableMembre;
            s_fcb     := 'fcb'  + sNomTableMembre;
            AjouteUnite( s_dmLookup, implementation_uses_key);
            AjouteUnite( s_fcb     , f_implementation_uses_key);

            Ouverture_key
            :=
                Ouverture_key
              + Format( '     if not %0:s.Ouvert           '#13#10+
                        '     then                         '#13#10+
                        '         %0:s.Ouvrir_LectureSeule;'#13#10,
                        [s_dmLookup]);
            slChamps_non_order_by.Add( Member_Name);

            CellClick_KeyPress( 'dm' ,   f_dbgCellClick_Key,   f_dbgKeyPress_Key);
            CellClick_KeyPress( 'dmd', dkd_dbgCellClick_Key, dkd_dbgKeyPress_Key);

            //Ajout comme détail
            slDetails:= TStringList.Create;
            try
               nfDetails:= sRepSource+Member_Name+'.Details.txt';
               if FileExists( nfDetails)
               then
                   slDetails.LoadFromFile( nfDetails);
               if -1 = slDetails.IndexOf( Nom_de_la_table)
               then
                   slDetails.Add( Nom_de_la_table);
            finally
                   slDetails.SaveToFile( nfDetails);
                   FreeAndNil( slDetails);
                   end;
            end;
   end;
   procedure Produit;
   var
      RepertoirePaquet: string;
   begin
        RepertoirePaquet:= 'p'+_Classe_Name+'\';

        phPAS_DMXCRE.Produit( RepertoirePaquet);
        phPAS_POOL .Produit( RepertoirePaquet);
        phPAS_F    .Produit( RepertoirePaquet);
        phPAS_FCB  .Produit( RepertoirePaquet);
        phPAS_DKD  .Produit( RepertoirePaquet);

        phDFM_DMXCRE.Produit( RepertoirePaquet);
        phDFM_POOL .Produit( RepertoirePaquet);
        phDFM_F    .Produit( RepertoirePaquet);
        phDFM_FCB  .Produit( RepertoirePaquet);
        phDFM_DKD  .Produit( RepertoirePaquet);

        phPAS_BL   .Produit( RepertoirePaquet);
        phPAS_HF   .Produit( RepertoirePaquet);
        phPAS_TC   .Produit( RepertoirePaquet+'dunit\');
        phDPK      .Produit( RepertoirePaquet);
   end;
   function Allowed_in_order_by( NomChamp: String): Boolean;
   begin
        Result:= -1 = slChamps_non_order_by.IndexOf( NomChamp);
   end;
   procedure Termine_CellClick_KeyPress( var CellClick,
                                             KeyPress,KeyPressVariables:String);
   begin
        if CellClick <> sys_Vide
        then
            CellClick:= CellClick + ';'#13#10;

        f_f_dbgKeyPress_Key_Pattern.Traite(KeyPress,KeyPress,KeyPressVariables);
   end;
   procedure Visite_NameSpace( NameSpace: IUMLNameSpace);
   var
      I, J: Integer;
   begin
        for I:= 0 to NameSpace.GetOwnedElementCount-1
        do
          begin
          ModelElement:= NameSpace.GetOwnedElementAt( I);
               if    ModelElement.IsKindOf( 'UMLNameSpace')
                  or ModelElement.IsKindOf( 'UMLModel')
          then
              Visite_NameSpace( ModelElement as IUMLNameSpace)
          else if ModelElement.IsKindOf( 'UMLClass')
          then
              begin
              Classe:= ModelElement as IUMLClass;
              slChamps_non_order_by.Clear;
              slParametres.Clear;
              _Classe_Name:= Classe.Name;
              CalculeSaisi_:= CalculeSaisi_from_ClassName( _Classe_Name);
              Nom_de_la_table:= NomTable_from_ClassName( _Classe_Name);
              if    ('TObject'   <>_Classe_Name)
                 and('IInterface'<>_Classe_Name)
                 and('IUnknown'  <>_Classe_Name)
              then
                  begin
                  slParametres.Values[s_Nom_de_la_table]:= Nom_de_la_table;

                  SQL_Create
                  :=
                    'CREATE TABLE '+Nom_de_la_table+s_SQL_saut+
                    '  ('+s_SQL_saut+
                    '  '+TailleNom('id')+
                         ' INTEGER AUTO_INCREMENT PRIMARY KEY';
                  QfieldsDFM  := '';
                  QfieldsPAS  := '';
                  implementation_uses_key:= '';
                  Ouverture_key:= '';
                  Test_Declaration_Key    := '';
                  Test_Implementation_Key := '';
                  Test_Implementation_Body
                    :=
                      'var                                                 '#13#10+
                      '   bl: Tbl'+_Classe_Name+';                          '#13#10+
                      'begin                                               '#13#10+
                      '     bl:= Nouveau;                                  '#13#10;
                  Test_Call_Key:= '';

                  Nouveau_Declaration_Key    := '';
                  Nouveau_Implementation_Key := '';
                  Nouveau_Implementation_Body
                    :=
                      'begin'
                      +#13#10
                      +'     Nouveau_Base(Result);'
                      +#13#10;

                  pattern_declaration_champs :=#13#10;

                  f_dbgCellClick_Key       := '';
                  f_dbgKeyPress_Key        := '';
                  f_dbgKeyPress_Key_Variables:= '';
                  f_implementation_uses_key:= '';
                  f_Execute_Before_Key     := '';
                  f_Execute_After_Key      := '';

                  dkd_dbgCellClick_Key         := '';
                  dkd_dbgKeyPress_Key          := '';
                  dkd_dbgKeyPress_Key_Variables:= '';

                  Traite_Index_key         := '';
                  QFields_hr_init:= '';

                  if Classe.getTaggedValueCount > 0
                  then
                      begin
                      sTaggedValues:= '';
                      for J:= 0 to Classe.GetTaggedValueCount-1
                      do
                        begin
                        TaggedValue:= Classe.GetTaggedValueAt(J);
                        sTaggedValues
                        :=
                            sTaggedValues
                          + TaggedValue.Name
                          + '='
                          + TaggedValue.DataValue;
                        end;
                      ShowMessage( sTaggedValues);
                      end;


                  for J:= 0 to Classe.GetAttributeCount-1
                  do
                    Traite_Member( Classe.GetAttributeAt(J));

                  //Fermeture des chaines
                  SQL_Create:= SQL_Create + '  )'+s_SQL_saut;
                  QfieldsDFM:= QfieldsDFM +   s_QfieldsDFM;
                  QfieldsPAS:= QfieldsPAS +   s_QfieldsPAS;
                  //QFields_hr_init:= QFields_hr_init + #13#10+s_QFields_hr_init;
                  Test_Declaration_Key:= Test_Declaration_Key+'):Integer;'#13#10;
                  Test_Implementation_Body
                    :=
                      Test_Implementation_Body+
                      '     bl.Save_to_database;                            '#13#10+
                      '     Result:= 0;                                     '#13#10+
                      'end;';
                  Test_Implementation_Key
                  :=
                      Test_Implementation_Key+'):Integer;'#13#10+
                      Test_Implementation_Body
                      ;


                  Test_Call_Key:= Test_Call_Key+#13#10');';

                  Nouveau_Implementation_Body
                    :=
                      Nouveau_Implementation_Body+
                      'end;';
                  Nouveau_Implementation_Key
                  :=
                      Nouveau_Implementation_Key+#13#10+
                      Nouveau_Implementation_Body
                      ;

                  pattern_declaration_champs := pattern_declaration_champs + #13#10;



                  Termine_CellClick_KeyPress( f_dbgCellClick_Key,
                                              f_dbgKeyPress_Key,
                                              f_dbgKeyPress_Key_Variables
                                              );
                  Termine_CellClick_KeyPress( dkd_dbgCellClick_Key,
                                              dkd_dbgKeyPress_Key,
                                              dkd_dbgKeyPress_Key_Variables
                                              );

                  //Gestion du libellé
                  slLibelle:= TStringList.Create;
                  try
                     nfLibelle:= sRepSource+Nom_de_la_table+'.libelle.txt';
                     if FileExists( nfLibelle)
                     then
                         slLibelle.LoadFromFile( nfLibelle);
                     QCalcFieldsKey:=  '     qLibelle.Value'#13#10
                                      +'     :='#13#10;
                     for J:= 0 to slLibelle.Count-1
                     do
                       begin
                       if J = 0
                       then QCalcFieldsKey:= QCalcFieldsKey+ '                '
                       else QCalcFieldsKey:= QCalcFieldsKey+ '       + '',''+ ';
                       QCalcFieldsKey
                       :=
                           QCalcFieldsKey
                         + 'q'+slLibelle.Strings[J]+'.AsString'#13#10;
                       end;
                     QCalcFieldsKey:= QCalcFieldsKey + ';';
                  finally
                         slLibelle.SaveToFile( nfLibelle);
                         FreeAndNil( slLibelle);
                         end;

                  //Gestion de l'order by
                  slOrder_by:= TStringList.Create;
                  try
                     nfOrder_By:= sRepSource+Nom_de_la_table+'.order_by.txt';
                          if FileExists( nfOrder_By)
                     then
                         slOrder_by.LoadFromFile( nfOrder_By)
                     else if FileExists( nfLibelle)
                     then
                         slOrder_by.LoadFromFile( nfLibelle);

                     Order_By_Key:= '';
                     for J:= 0 to slOrder_by.Count-1
                     do
                       begin
                       if Allowed_in_order_by( slOrder_by.Strings[J])
                       then
                           begin
                           if Order_By_Key = sys_Vide
                           then Order_By_Key:= Order_By_Key+ '      '
                           else Order_By_Key:= Order_By_Key+ ','+s_SQL_saut+'      ';
                           Order_By_Key:= Order_By_Key + slOrder_by.Strings[J];
                           end;
                       end;
                     if Order_By_Key = sys_Vide
                     then
                         Order_By_Key:= '      Numero';
                  finally
                         slOrder_by.SaveToFile( nfOrder_By);
                         FreeAndNil( slOrder_by);
                         end;

                  //Gestion des index suplémentaires
                  slIndex:= TStringList.Create;
                  try
                     nfIndex:= sRepSource+Nom_de_la_table+'.Index.txt';
                          if FileExists( nfIndex)
                     then
                         slIndex.LoadFromFile( nfIndex);
                     for J:= 0 to slIndex.Count-1
                     do
                       AjouteIndex( slIndex.Strings[J]);
                  finally
                         slIndex.SaveToFile( nfIndex);
                         FreeAndNil( slIndex);
                         end;

                  //Gestion des détails
                  slDetails:= TStringList.Create;
                  try
                     nfDetails:= sRepSource+Nom_de_la_table+'.Details.txt';
                     if FileExists( nfDetails)
                     then
                         slDetails.LoadFromFile( nfDetails);
                     NbDetails:= slDetails.Count;
                     for J:= 0 to NbDetails-1
                     do
                       begin
                       s_dkd:= 'dkd'+slDetails[J];
                       AjouteUnite( s_dkd     , f_implementation_uses_key);

                       s_dkd_Accroche
                       :=
                         '               '+s_dkd+'.Accroche( dm'+Nom_de_la_table+', pc);'#13#10;
                       s_dkd_Decroche
                       :=
                         '                   '+s_dkd+'.Decroche( dm'+Nom_de_la_table+', pc);'#13#10;

                       f_Execute_Before_Key:= f_Execute_Before_Key+ s_dkd_Accroche     ;
                       f_Execute_After_Key := s_dkd_Decroche      + f_Execute_After_Key;
                       end;
                  finally
                         slDetails.SaveToFile( nfDetails);
                         FreeAndNil( slDetails);
                         end;

                  dkd_implementation_uses_key  :=   implementation_uses_key
                                                  + f_implementation_uses_key;


                  slParametres.Values[s_Order_By_Key  ]:= Order_By_Key  ;
                  slParametres.Values[s_CREATE_TABLE  ]:= SQL_Create    ;
                  slParametres.Values[  s_QfieldsDFM  ]:= QfieldsDFM    ;
                  slParametres.Values[  s_QfieldsPAS  ]:= QfieldsPAS    ;
                  slParametres.Values[s_QCalcFieldsKey]:= QCalcFieldsKey;
                  slParametres.Values[s_implementation_uses_key]:= implementation_uses_key;
                  slParametres.Values[s_Ouverture_key          ]:= Ouverture_key          ;
                  slParametres.Values[s_Test_Declaration_Key   ]:= Test_Declaration_Key   ;
                  slParametres.Values[s_Test_Implementation_Key]:= Test_Implementation_Key;
                  slParametres.Values[s_Test_Call_Key          ]:= Test_Call_Key;
                  slParametres.Values[s_Nouveau_Declaration_Key   ]:= Nouveau_Declaration_Key   ;
                  slParametres.Values[s_Nouveau_Implementation_Key]:= Nouveau_Implementation_Key;
                  slParametres.Values[s_pattern_declaration_champs]:= pattern_declaration_champs;
                  slParametres.Values[s_f_dbgCellClick_Key     ]:= f_dbgCellClick_Key;
                  slParametres.Values[s_f_dbgKeyPress_Key      ]:= f_dbgKeyPress_Key;
                  slParametres.Values[s_f_dbgKeyPress_Key_Variables]:= f_dbgKeyPress_Key_Variables;
                  slParametres.Values[s_f_implementation_uses_key]:= f_implementation_uses_key;
                  slParametres.Values[s_f_Execute_Before_Key   ]:= f_Execute_Before_Key;
                  slParametres.Values[s_f_Execute_After_Key    ]:= f_Execute_After_Key ;
                  slParametres.Values[s_dkd_dbgCellClick_Key         ]:= dkd_dbgCellClick_Key;
                  slParametres.Values[s_dkd_dbgKeyPress_Key          ]:= dkd_dbgKeyPress_Key;
                  slParametres.Values[s_dkd_dbgKeyPress_Key_Variables]:= dkd_dbgKeyPress_Key_Variables;
                  slParametres.Values[s_dkd_implementation_uses_key  ]:= dkd_implementation_uses_key;
                  slParametres.Values[s_Traite_Index_key       ]:= Traite_Index_key;
                  slParametres.Values[s_QFields_hr_init        ]:= QFields_hr_init;
                  slParametres.Values[s_Nom_de_la_classe       ]:= _Classe_Name;
                  slParametres.Values[s_Nom_de_la_table        ]:= Nom_de_la_table;
                  slLog.Add( SQL_Create);
                  slLog.Add( QFields_hr_init);

                  Produit;
                  //slLog.Add( 'aprés Produit');
                  MenuHandler.Add( Nom_de_la_table, NbDetails = 0, CalculeSaisi_);
                  //slLog.Add( 'MenuHandler.Add');
                  end;
              Premiere_Classe:= False;
              end;
          end;
   end;
begin
     NomFichierProjet:= StarUMLApp.ProjectManager.FileName;
     INI
     :=
       TIniFile.Create( ChangeFileExt(NomFichierProjet,'_StarUML.ini'));
     try
        sRepSource:= INI.ReadString( 'Options', 'sRepSource', ExtractFilePath(NomFichierProjet)+'Source\patterns\');
        sRepCible := INI.ReadString( 'Options', 'sRepCible' , ExtractFilePath(NomFichierProjet)+'Source\');
        sRepCiblePaquet:= INI.ReadString( 'Options', 'sRepCiblePaquet' , ExtractFilePath(NomFichierProjet)+'Source\');
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );
        INI.WriteString( 'Options', 'sRepCiblePaquet' , sRepCiblePaquet);

        slParametres:= TBatpro_StringList.Create;
        slLog       := TStringList.Create;
        try
           CreePatternHandler( phPAS_DMXCRE, phDFM_DMXCRE, 'dmxcre');
           CreePatternHandler( phPAS_POOL  , phDFM_POOL  , 'pool'  );
           CreePatternHandler( phPAS_DMLK  , phDFM_DMLK  , 'dmlk'  );
           CreePatternHandler( phPAS_DMA   , phDFM_DMA   , 'dma'   );
           CreePatternHandler( phPAS_DM    , phDFM_DM    , 'dm'    );
           CreePatternHandler( phPAS_F     , phDFM_F     , 'f'     );
           CreePatternHandler( phPAS_FCB   , phDFM_FCB   , 'fcb'   );
           CreePatternHandler( phPAS_DMD   , phDFM_DMD   , 'dmd'   );
           CreePatternHandler( phPAS_DKD   , phDFM_DKD   , 'dkd'   );
           CreePatternHandler_PAS( phPAS_BL, 'bl');
           CreePatternHandler_PAS( phPAS_HF, 'hf');
           CreePatternHandler_DPK( phDPK);
           CreePatternHandler_HR( phPAS_HR);
           CreePatternHandler_TC( phPAS_TC);
           MenuHandler:= TMenuHandler.Create( sRepSource, sRepCible);
           slChamps_non_order_by:= TStringList.Create;
           try
              S:= '';
              Premiere_Classe:= True;
              Project:= StarUMLApp.ProjectManager.Project;

              Visite_NameSpace( Project);

              MenuHandler.Produit;
              slLog.Add( S);
           finally
                  FreeAndNil( slChamps_non_order_by);
                  FreeAndNil( MenuHandler);
                  FreeAndNil( phPAS_DMXCRE);
                  FreeAndNil( phPAS_DMLK );
                  FreeAndNil( phPAS_DMA  );
                  FreeAndNil( phPAS_DM   );
                  FreeAndNil( phPAS_F    );
                  FreeAndNil( phPAS_FCB  );
                  FreeAndNil( phPAS_DMD  );
                  FreeAndNil( phPAS_DKD  );

                  FreeAndNil( phDFM_DMXCRE);
                  FreeAndNil( phDFM_DMLK );
                  FreeAndNil( phDFM_DMA  );
                  FreeAndNil( phDFM_DM   );
                  FreeAndNil( phDFM_F    );
                  FreeAndNil( phDFM_FCB  );
                  FreeAndNil( phDFM_DMD  );
                  FreeAndNil( phDFM_DKD  );

                  FreeAndNil( phPAS_HR   );
                  FreeAndNil( phPAS_TC   );
                  end;
        finally
               slLog.SaveToFile( sRepCible+'suPatterns_from_MCD.log');
               FreeAndNil( slLog       );
               FreeAndNil( slParametres);
               end;

        ShowMessage( 'suPatterns_from_MCD exécuté avec succés');
     finally
            FreeAndNil( INI);
            end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPatterns_from_MCD, Class_Patterns_from_MCD,
    ciMultiInstance, tmApartment);
end.
