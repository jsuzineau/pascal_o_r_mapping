library mmPatterns_from_MCD;
//Jean SUZINEAU
//Provient du générateur développé pour le logiciel de portage de repas

uses
  SysUtils,
  Windows,
  Controls,
  Forms,
  Dialogs,
  Classes,
  Menus,
  IniFiles,
  MMToolsApi in 'C:\Program Files\ModelMakerTools\ModelMaker\6.2\Experts\MMToolsApi.pas',
  MMEngineDefs in 'C:\Program Files\ModelMakerTools\ModelMaker\6.2\Experts\MMEngineDefs.pas',
  MMDiagramAPI in 'C:\Program Files\ModelMakerTools\ModelMaker\6.2\Experts\MMDiagramAPI.pas',
  uPatternHandler in 'uPatternHandler.pas',
  uMenuHandler in 'uMenuHandler.pas',
  uf_f_dbgKeyPress_Key_Pattern in 'uf_f_dbgKeyPress_Key_Pattern.pas' {f_f_dbgKeyPress_Key_Pattern},
  uBatpro_StringList,
  uuStrings;

type
  TmmPatterns_from_MCD = class(TInterfacedObject, IUnknown, IMMExpert)
    constructor Create;
    destructor Destroy; override;
    procedure Destroyed; safecall;
    procedure Execute(Index: Integer); safecall;
    function GetMenuPositions(Index: Integer): TMMMenuPosition; safecall;
    function GetMenuShortCuts(Index: Integer): TShortCut; safecall;
    function GetVerbCount: Integer; safecall;
    function GetVerbs(Index: Integer): WideString; safecall;
    property MenuPositions[Index: Integer]: TMMMenuPosition read GetMenuPositions;
    property MenuShortCuts[Index: Integer]: TShortCut read GetMenuShortCuts;
    property VerbCount: Integer read GetVerbCount;
    property Verbs[Index: Integer]: WideString read GetVerbs;
  public
    function ExpertID: WideString; safecall;
    procedure ExecuteAction(Index: Integer); safecall;
    function GetActionCount: Integer; safecall;
    function GetCustomImages(ImageIndexOffset: Integer; var Images: Cardinal): Boolean; safecall;
    function GetCustomMenuData: WideString; safecall;
    function GetCustomToolbarData: WideString; safecall;

  end;

function JustFileName(const FileName: string): string;
begin
  Result := ExtractFileName(FileName);
  Result := Copy(Result, 1, Length(Result) - Length(ExtractFileExt(Result)));
end;

const
   TailleMaximumIdentificateur = 15;

function Fixe_Min( S: String; L: Integer): String;
var
   Complement: Integer;
begin
     Result:= S;

     Complement:= L-Length(S);
     if Complement > 0
     then
         Result:= Result+StringOfChar( ' ', Complement);
end;

procedure CreateFiles;
const
     sys_Vide                 = '';
     s_Nom_de_la_classe       = 'Nom_de_la_classe';
     s_Nom_de_la_table        = 'Nom_de_la_table';
     s_Order_By_Key           = '      Order_By_Key';
     s_CREATE_TABLE           = 'CREATE_TABLE';
     s_SQL_saut               = ''''#13#10'      ''';
     s_QfieldsDFM             = '    inherited sqlqets: TStringField';
     s_QfieldsPAS             = '    {QfieldsPAS}'      ;
     s_QCalcFieldsKey         = '{qCalcFields_Key}';
     JoinPoint_uses_ubl       = '//JoinPoint_uses_ubl';
     JoinPoint_uses_upool     = '//JoinPoint_uses_upool';
     JoinPoint_LabelsDFM      = '    object lNomChamp: TLabel';
     JoinPoint_Champ_EditDFM  = '    object ceNomChamp: TChamp_Edit';
     JoinPoint_LabelsPAS      = '    {JoinPoint_LabelsPAS}';
     JoinPoint_Champ_EditPAS  = '    {JoinPoint_Champ_EditPAS}';
     JoinPoint_Affecte        = '                     {JoinPoint_Affecte}';

     s_Ouverture_key          = '{Ouverture_key}';
     s_Test_Declaration_Key   = '{Test_Declaration_Key}';
     s_Test_Implementation_Key= '{Test_Implementation_Key}';
     s_Test_Call_Key          = '{Test_Call_Key}';
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

     s_declaration_champs       = '//pattern_declaration_champs';
     s_creation_champs          = '//pattern_creation_champs';
     s_Get_by_Cle_Declaration   = '//pattern_Get_by_Cle_Declaration';
     s_Get_by_Cle_Implementation= '//pattern_Get_by_Cle_Implementation';
     s_sCle_from__Declaration   = '//pattern_sCle_from__Declaration';
     s_sCle_from__Implementation= '//pattern_sCle_from__Implementation';
     s_sCle_Implementation_Body = '//pattern_sCle_Implementation_Body';
     s_Declaration_cle          = '//pattern_Declaration_cle';
     s_To_SQLQuery_Params_Body  = '//pattern_To_SQLQuery_Params_Body';
     s_SQLWHERE_ContraintesChamps_Body='//pattern_SQLWHERE_ContraintesChamps_Body';

     s_aggregations_faibles_declaration='//pattern_aggregations_faibles_declaration';
     s_aggregations_faibles_pool_get   ='//pattern_aggregations_faibles_pool_get';
var
   CodeModel: IMMCodeModel;
   Classe: IMMClassBase;
   I, J, nClasseMembre: Integer;
   S: String;
   TaggedValue: String;

   sRepSource, sRepCible: String;

   Classe_Name: String;
   Nom_de_la_table: String;
   Order_By_Key: String;
   SQL_Create : String;
   QfieldsDFM,
   QfieldsPAS: String;
   QCalcFieldsKey: String;
   //jpv_ : Join Point Value
   jpv_uses_ubl,
   jpv_uses_upool,
   jpv_LabelsDFM,
   jpv_Champ_EditDFM,
   jpv_LabelsPAS,
   jpv_Champ_EditPAS,
   jpv_AffectePAS,
   Ouverture_key,
   Test_Declaration_Key    ,
   Test_Implementation_Key ,
   Test_Implementation_Body,
   Test_Call_Key           ,
   f_dbgCellClick_Key      ,
   f_dbgKeyPress_Key       ,
   f_dbgKeyPress_Key_Variables,
   f_implementation_uses_key,
   f_Execute_Before_Key    ,
   f_Execute_After_Key     ,

   dkd_dbgCellClick_Key      ,
   dkd_dbgKeyPress_Key       ,
   dkd_dbgKeyPress_Key_Variables,
   dkd_implementation_uses_key,

   Traite_Index_key          ,
   declaration_champs        ,
   creation_champs           ,
   Get_by_Cle_Declaration    ,
   Get_by_Cle_Implementation ,
   Get_by_Cle_Implementation_Body,
   sCle_Formule              ,
   sCle_from__Declaration    ,
   sCle_from__Implementation ,
   sCle_from__Implementation_Body,
   sCle_Implementation_Body  ,
   Declaration_cle           ,
   To_SQLQuery_Params_Body        ,
   SQLWHERE_ContraintesChamps_Body,
   aggregations_faibles_declaration,
   aggregations_faibles_pool_get: String;

   phPAS_DMCRE,
   phPAS_POOL ,
   phPAS_F    ,
   phPAS_FCB  ,
   phPAS_DKD  ,

   phDFM_DMCRE,
   phDFM_POOL ,
   phDFM_F    ,
   phDFM_FCB  ,
   phDFM_DKD  ,

   phDFM_FD   ,
   phPAS_FD   ,

   phPAS_BL   ,
   phPAS_HF   ,
   phPAS_TC   ,
   phDPK      : TPatternHandler;
   slParametres: TBatpro_StringList;

   MenuHandler: TMenuHandler;

   slLog: TStringList;
   INI: TIniFile;


   nfLibelle : String;
   nfOrder_By: String;
   nfIndex   : String;
   nfCle     : String;
   slLibelle :TStringList;
   slOrder_By:TStringList;
   slIndex   :TStringList;
   slCle     :TStringList;

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
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
        phDFM:= TPatternHandler.Create( sRepRacine+'.dfm',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_BL( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'ubl'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_HF( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'uhf'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_TC( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'utc'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible+'dunit\',slParametres);
   end;

   procedure CreePatternHandler_DPK( var phDPK: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'p'+s_Nom_de_la_classe;
        phDPK:= TPatternHandler.Create( sRepRacine+'.dpk',sRepCible,slParametres);
   end;

   function SQL_from_Type( Typ: String): String;
   begin
        Typ:= StrToK( ',', Typ);
        Typ:= TrimRight( Typ);
        Typ:= UpperCase( Typ);
             if'STRING'   =Typ then Result:='CHAR( 42)'
        else if'INTEGER'  =Typ then Result:='INTEGER  '
        else if'SMALLINT' =Typ then Result:='INTEGER  '
        else if'DATE'     =Typ then Result:='DATE     '
        else if'TDATETIME'=Typ then Result:='DATETIME '
        else if'CURRENCY' =Typ then Result:='DOUBLE   '
        else if'DOUBLE'   =Typ then Result:='DOUBLE   '
        else if'LONGBLOB' =Typ then Result:='LONGBLOB '
        else
            begin
            Result:= Typ;
            slLog.Add( 'Type non traduit en SQL: '+Typ);
            end;
   end;
   //function SQL_from_Batpro_Dico( Batpro_Dico: String): String;
   //var
   //   Typ: String;
   //   Taille, Precision: String;
   //begin
   //     Typ:= StrToK( ',', Batpro_Dico);
   //     Typ:= TrimRight( Typ);
   //     Typ:= UpperCase( Typ);
   //     Result:= Typ;
   //          if'NCHAR'   =Typ then Result:=Result+'('+ Batpro_Dico+')'
   //     else if'DECIMAL' =Typ
   //     then
   //         begin
   //         Taille   := StrToK( ' dont '    , Batpro_Dico);
   //         Precision:= StrToK( ' décimales', Batpro_Dico);
   //         Result:= Format( '%s(%s.%s)', [Result, Taille, Precision]);
   //         end;
   //end;

   function Declaration_from_Type( prefixe, NomChamp, Typ: String): String;
   begin
        Typ:= UpperCase( Typ);
             if'STRING'   =Typ then Result:=': TStringField'
        else if'SMALLINT' =Typ then Result:=': TIntegerField'
        else if'INTEGER'  =Typ then Result:=': TIntegerField'
        else if'DATE'     =Typ then Result:=': TDateField'
        else if'TDATETIME'=Typ then Result:=': TDateTimeField'
        else if'CURRENCY' =Typ then Result:=': TFloatField'
        else if'LONGBLOB' =Typ then Result:=': TStringField'
        else
            begin
            Result:= ': T'+Typ+'Field';
            slLog.Add( 'Declaration_from_Type(): Type non traduit en champ: '+Typ);
            end;
        Result:= prefixe + NomChamp + Result;
   end;
   function Default_from_Type( Typ: String): String;
   begin
        Typ:= UpperCase( Typ);
             if'STRING'    =Typ then Result:=''''''
        else if'SMALLINT'  =Typ then Result:='0'
        else if'INTEGER'   =Typ then Result:='0'
        else if'DATE'      =Typ then Result:='Date'
        else if'TDATETIME' =Typ then Result:='Date'
        else if'CURRENCY'  =Typ then Result:='0.0'
        else
            begin
            Result:= '''''';
            slLog.Add( 'Default_from_Type(): Type non géré '+Typ);
            end;
   end;
   function dbx_from_Type( Typ: String): String;
   begin
        Typ:= UpperCase( Typ);
             if'STRING'   =Typ then Result:='  String_from_String '
        else if'SMALLINT' =Typ then Result:=' Integer_from_Integer'
        else if'INTEGER'  =Typ then Result:=' Integer_from_Integer'
        else if'DATE'     =Typ then Result:='DateTime_from_Date   '
        else if'TDATETIME'=Typ then Result:='DateTime_from_       '
        else if'CURRENCY' =Typ then Result:='  Double_from_       '
        else if'DOUBLE'   =Typ then Result:='  Double_from_       '
        else if'LONGBLOB' =Typ then Result:='  String_from_Blob   '
        else
            begin
            Result:= '''''';
            slLog.Add( 'Default_from_Type(): Type non géré '+Typ);
            end;
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

   function Colonne2: Boolean;
   begin
        Result:= J > (Classe.MemberCount div 2);
   end;
   function GetLeft: Integer;
   begin
        if Colonne2
        then
            Result:= 200
        else
            Result:= 0;
   end;
   function GetTop: String;
   var
      jtop: Integer;
      top: Integer;
   begin
        if Colonne2
        then
            jtop:= J- (Classe.MemberCount div 2)
        else
            jtop:= J;
        top:= 4+22 * (1+jtop);
        Result:= IntToStr( top);
   end;
   function LabelDFM( NomChamp: String): String;
   begin
        Result
        :=
           '    object l'+UpperCase(NomChamp)+': TLabel'#13#10
          +'      Caption = '''+NomChamp+'''           '#13#10
          +'      Left = '+IntToStr(16+GetLeft)+'      '#13#10
          +'      Top = '+GetTop+'                     '#13#10
          +'      Height = 13                          '#13#10
          +'    end                                    '#13#10;
   end;

   function Champ_EditDFM( NomChamp: String): String;
   begin
        Result
        :=
           '    object ce'+UpperCase(NomChamp)+': TChamp_Edit'#13#10
          +'      Field = '''+NomChamp+'''                   '#13#10
          +'      Left = '+IntToStr(81+GetLeft)+'            '#13#10
          +'      Top = '+GetTop+'                           '#13#10
          +'      Height = 21                                '#13#10
          +'    end                                          '#13#10;
   end;

   function LabelPAS( NomChamp: String): String;
   begin
        Result:= '    l'+UpperCase(NomChamp)+': TLabel;'#13#10;
   end;

   function Champ_EditPAS( NomChamp: String): String;
   begin
        Result:= '    ce'+UpperCase(NomChamp)+': TChamp_Edit;'#13#10;
   end;

   function PAS_from_Type( prefixe, NomChamp, Typ: String): String;
   begin
        Result:='    ' + Declaration_from_Type(prefixe,NomChamp,Typ) + ';'#13#10;
   end;

   function DFM_Lookup( prefixe, Member_Name, ClasseLookup: String): String;
   begin
        Result
        :=
          '    object '+Declaration_from_Type(prefixe,Member_Name,'STRING')+#13#10+
          '      FieldName = '''+Member_Name+'''                           '#13#10+
          '      FieldKind = fkLookup                                      '#13#10+
          '      LookupDataSet = dmlk'+ClasseLookup+'.q                    '#13#10+
          '      LookupKeyFields = ''rowid''                              '#13#10+
          '      LookupResultField = ''Libelle''                           '#13#10+
          '      KeyFields = ''n'+Member_Name+'''                          '#13#10+
          '      Lookup = True                                             '#13#10+
          '      Size = 42                                                 '#13#10+
          '    end                                                         '#13#10;
   end;

   function TailleNom( S: String): String;
   begin
        Result:= Fixe_Min( S, TailleMaximumIdentificateur);
   end;
   function TailleNom_Quote( S: String): String;
   begin
        Result:= Fixe_Min( ''''+S+'''', TailleMaximumIdentificateur+2);
   end;
   procedure AjouteIndex( sNomChamp: String);
   begin
        Traite_Index_key:=  Traite_Index_key
                           +'     Traite_Index( '''+sNomChamp+''');'#13#10;
   end;

   procedure Traite_Member( Member: IMMMember);
   var
      Member_Name: String;
      SQL: String;
      sNomChamp: String;
      sClasseMembre: String;
      sClasseMembre_UPPERCASE: String;
      sClasseMembreType: String;
      CleEtrangere: Boolean;
      sTypChamp: String;
      sTyp: String;
      sParametre: String;
      sDeclarationParametre: String;
      s_bl: String;
      s_pool: String;
      s_fcb: String;
      s_NomAggregation: String;
      procedure pv( var S: String; Debut: String);
      begin
           if S = ''
           then
               S:= S + Debut
           else
               S:= S + ';';
      end;
      procedure v( var S: String; Debut: String);
      begin
           if S = ''
           then
               S:= S + Debut
           else
               S:= S + ','#13#10;
      end;
      procedure plus( var S: String; Debut: String);
      begin
           if S = ''
           then
               S:= S + Debut
           else
               S:= S + ' + ';
      end;
      procedure TraiteDebut( var S: String; Debut, Separateur: String);
      begin
           if S = ''
           then
               S:= S + Debut
           else
               S:= S + Separateur;
      end;
      procedure Ligne( var S: String; Delta: String);
      begin
           TraiteDebut( S, '', #13#10);
           S:= S + Delta;
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
              + 'if Column.Field = '+prefixe_dm+Classe_Name+'.q'+Member_Name+'      '#13#10
              + '     then                                                 '#13#10
              + '         begin                                            '#13#10
              + '         Deroule'+Member_Name+'( Column, '+
                              prefixe_dm+Classe_Name+'.qn'+Member_Name+'); '#13#10
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
              + '(F = '+prefixe_dm+Classe_Name+'.q'+Member_Name+')';
      end;

   begin
        SQL:= '  ';

        Member_Name  := Member.Name;
        Delete( Member_Name, 1, 5); // _01__

        sClasseMembre:= Member.DataName;
        sClasseMembre_UPPERCASE:= UpperCase( sClasseMembre);
             if'NCHAR'      =sClasseMembre_UPPERCASE then sClasseMembre:='String'
        else if'TEXT'       =sClasseMembre_UPPERCASE then sClasseMembre:='String'
        else if'SMALLINT'   =sClasseMembre_UPPERCASE then sClasseMembre:='Integer'
        else if'SERIAL'     =sClasseMembre_UPPERCASE then sClasseMembre:='Integer'
        else if'DECIMAL'    =sClasseMembre_UPPERCASE then sClasseMembre:='Double'
        else if'FLOAT'      =sClasseMembre_UPPERCASE then sClasseMembre:='Double'
        else if'LONGBLOB'   =sClasseMembre_UPPERCASE then sClasseMembre:='String'
        else if'NVARCHAR13' =sClasseMembre_UPPERCASE then sClasseMembre:='String';

        CleEtrangere:= CodeModel.FindClass( sClasseMembre_UPPERCASE, nClasseMembre);

        if CleEtrangere
        then
            begin
            sNomChamp:= 'n'+Member_Name;
            SQL:= SQL+TailleNom( sNomChamp)+' INTEGER UNSIGNED,'+s_SQL_saut;
            AjouteIndex( sNomChamp);
            end
        else
            begin
            sNomChamp:= Member_Name;
            SQL:= SQL+
                  TailleNom(sNomChamp)+' '+SQL_from_Type( sClasseMembre_UPPERCASE)+','+s_SQL_saut;
            end;

        if i = 0
        then
            begin
            if CleEtrangere
            then
                sClasseMembreType:= ', aggrégation faible / clé étrangère'
            else
                sClasseMembreType:= '';
            S:= S + sClasseMembre+sClasseMembreType+#13#10;
            end;

        if CleEtrangere
        then
            sTypChamp:= 'Integer'
        else
            sTypChamp:= sClasseMembre;

        sTyp:= sTypChamp;
        if UpperCase( sTyp) = 'DATE' then sTyp:= 'TDateTime';

        SQL_Create:= SQL_Create+SQL;
        QfieldsDFM:=QfieldsDFM+DFM_from_Type('q',sNomChamp,sTypChamp,CleEtrangere);
        QfieldsPAS:=QfieldsPAS+PAS_from_Type('q',sNomChamp,sTypChamp);

        jpv_LabelsDFM    := jpv_LabelsDFM     +      LabelDFM( sNomChamp);
        jpv_Champ_EditDFM:= jpv_Champ_EditDFM + Champ_EditDFM( sNomChamp);
        jpv_LabelsPAS    := jpv_LabelsPAS     +      LabelPAS( sNomChamp);
        jpv_Champ_EditPAS:= jpv_Champ_EditPAS + Champ_EditPAS( sNomChamp);

        v( jpv_AffectePAS,'');jpv_AffectePAS:= jpv_AffectePAS + 'ce'+UpperCase(sNomChamp);

        pv( Test_Declaration_Key   , '    function Test('         );
        pv( Test_Implementation_Key, 'function Tpool'+Classe_Name+'.Test(');

        sParametre:= ' _'+sNomChamp;
        sDeclarationParametre:= sParametre+': '+sTyp;
        Test_Declaration_Key    := Test_Declaration_Key   +sDeclarationParametre;
        Test_Implementation_Key := Test_Implementation_Key+sDeclarationParametre;
        Test_Implementation_Body
        :=
          Test_Implementation_Body+
          '       bl.'+TailleNom(sNomChamp)+':='+TailleNom(sParametre)+';'#13#10;

        v( Test_Call_Key, 'pool'+Classe_Name+'.Test('#13#10);
        Test_Call_Key:= Test_Call_Key + Default_from_Type(sTypChamp)+'{'+sDeclarationParametre+'}';
        declaration_champs:= declaration_champs+'    '+sNomChamp+': '+sTyp+';'#13#10;
        creation_champs:= creation_champs+'     Champs.'+dbx_from_Type(sTypChamp)+'( '+TailleNom(sNomChamp)+', '+TailleNom_Quote(sNomChamp)+');'#13#10;
        if -1 <> slCle.IndexOf( sNomChamp)
        then
            begin
            pv( Get_by_Cle_Declaration   , '    function Get_by_Cle('         );
            pv( Get_by_Cle_Implementation, 'function Tpool'+Classe_Name+'.Get_by_Cle(');
             v( sCle_Formule             , '     sCle:= Tbl'+Classe_Name+'.sCle_from_( ');
            pv( sCle_from__Declaration   , '    class function sCle_from_('         );
            pv( sCle_from__Implementation, 'class function Tbl'+Classe_Name+'.sCle_from_(');
            plus( sCle_from__Implementation_Body, '     Result:= ');
             v( sCle_Implementation_Body, '     Result:= sCle_from_( ');
            TraiteDebut( To_SQLQuery_Params_Body        ,
                         '       ParamByName( ''',
                         ';'#13#10'       ParamByName( ''');
            TraiteDebut( SQLWHERE_ContraintesChamps_Body,
                         '     Result                                    '#13#10+
                         '     :=                                        '#13#10+
                         '       ''where                        ''#13#10+'#13#10+
                         '       ''         ',
                         '''#13#10+'#13#10'       ''     and ');

            Get_by_Cle_Declaration   := Get_by_Cle_Declaration    + sDeclarationParametre;
            Get_by_Cle_Implementation:= Get_by_Cle_Implementation + sDeclarationParametre;
            sCle_from__Declaration   := sCle_from__Declaration    + sDeclarationParametre;
            sCle_from__Implementation:= sCle_from__Implementation + sDeclarationParametre;
            Get_by_Cle_Implementation_Body
            :=
                Get_by_Cle_Implementation_Body
              + '     '+sNomChamp+':= '+sParametre+';'#13#10;
            sCle_Formule:= sCle_Formule + sNomChamp;
            sCle_from__Implementation_Body
            :=
                sCle_from__Implementation_Body
              + sParametre;
            sCle_Implementation_Body:= sCle_Implementation_Body + sNomChamp;
            Declaration_cle:=Declaration_cle+'    '+sNomChamp+': '+sTyp+';'#13#10;
            To_SQLQuery_Params_Body
            :=
                To_SQLQuery_Params_Body
              + sNomChamp+'''    ).As'+sTyp+':= '+sNomChamp;
            SQLWHERE_ContraintesChamps_Body
            :=
                SQLWHERE_ContraintesChamps_Body
              + TailleNom(sNomChamp)+' = :'+TailleNom(sNomChamp);
            end;

        if CleEtrangere
        then
            begin //lookup pour récupération du libellé
            QfieldsDFM:=QfieldsDFM+DFM_Lookup   ('q',Member_Name,sClasseMembre_UPPERCASE);
            QfieldsPAS:=QfieldsPAS+PAS_from_Type('q',Member_Name,'STRING');

            s_bl  := 'bl' + TailleNom( sClasseMembre);
            s_pool:= 'pool' + TailleNom( sClasseMembre);
            s_fcb     := 'fcb'  + sClasseMembre;
            s_NomAggregation:= 'bl'+ TailleNom( Member_Name);

            f_implementation_uses_key
            :=
                f_implementation_uses_key
              + '    u'+s_fcb     +','#13#10;
            Ouverture_key
            :=
                Ouverture_key
              + Format( '     if not %0:s.Ouvert           '#13#10+
                        '     then                         '#13#10+
                        '         %0:s.Ouvrir_LectureSeule;'#13#10,
                        [s_bl]);

            //aggrégations faibles
            Ligne( jpv_uses_ubl  , '    u'+s_bl  +',');
            Ligne( jpv_uses_upool, '    u'+s_pool+',');
            Ligne( aggregations_faibles_declaration,
                   '     '+s_NomAggregation+': T'+s_bl+';' );
            Ligne( aggregations_faibles_pool_get,
                    '     '  + s_NomAggregation
                   +':= pool'+ TailleNom( sClasseMembre)
                   +'.Get( ' + TailleNom( sNomChamp)
                   +');');


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
               if -1 = slDetails.IndexOf( Classe_Name)
               then
                   slDetails.Add( Classe_Name);
            finally
                   slDetails.SaveToFile( nfDetails);
                   FreeAndNil( slDetails);
                   end;
            end;
   end;
   procedure Produit;
   var
      RepertoirePaquet: String;
   begin
        RepertoirePaquet:= 'p'+Classe_Name+'\';

        phPAS_DMCRE.Produit( '');
        phPAS_POOL .Produit( RepertoirePaquet);
        phPAS_F    .Produit( '');
        phPAS_FCB  .Produit( '');
        phPAS_DKD  .Produit( '');

        phDFM_DMCRE.Produit( '');
        phDFM_POOL .Produit( RepertoirePaquet);
        phDFM_F    .Produit( '');
        phDFM_FCB  .Produit( '');
        phDFM_DKD  .Produit( '');

        phDFM_FD   .Produit( RepertoirePaquet);
        phPAS_FD   .Produit( RepertoirePaquet);

        phPAS_BL   .Produit( RepertoirePaquet);
        phPAS_HF   .Produit( RepertoirePaquet);
        phPAS_TC   .Produit( '');
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
begin
     INI
     :=
       TIniFile.Create( ChangeFileExt(MMToolServices.ProjectManager.ProjectName,
                        '.ini'));
     try
        //sRepSource:= 'E:\delphi version 1\24_PatternCreator\Pattern\';
        //sRepCible := 'E:\delphi version 1\24_PatternCreator\Cible\';

        sRepSource:= INI.ReadString( 'Options', 'sRepSource', ExtractFilePath(MMToolServices.ProjectManager.ProjectName)+'Source\patterns\');
        sRepCible := INI.ReadString( 'Options', 'sRepCible' , ExtractFilePath(MMToolServices.ProjectManager.ProjectName)+'Source\');
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );
        //sRepSource:= 'E:\delphi version 1\25_These\02_Base\02_pPatterns_from_MCD\patterns\';
        //sRepCible := 'E:\delphi version 1\25_These\02_Base\02_pPatterns_from_MCD\';

        slParametres:= TBatpro_StringList.Create;
        slLog       := TStringList.Create;
        slCle       := TStringList.Create;
        try
           CreePatternHandler( phPAS_DMCRE, phDFM_DMCRE, 'dmxcre');
           CreePatternHandler( phPAS_POOL , phDFM_POOL , 'pool'  );
           CreePatternHandler( phPAS_F    , phDFM_F    , 'f'     );
           CreePatternHandler( phPAS_FCB  , phDFM_FCB  , 'fcb'   );
           CreePatternHandler( phPAS_DKD  , phDFM_DKD  , 'dkd'   );
           CreePatternHandler( phPAS_FD  , phDFM_FD  , 'fd'   );
           CreePatternHandler_BL( phPAS_BL);
           CreePatternHandler_HF( phPAS_HF);
           CreePatternHandler_TC( phPAS_TC);
           CreePatternHandler_DPK( phDPK);
           MenuHandler:= TMenuHandler.Create( sRepSource, sRepCible);
           slChamps_non_order_by:= TStringList.Create;
           try
              S:= '';
              CodeModel:= MMToolServices.CodeModel;
              if not Assigned(CodeModel) then Exit;
              for I:= 0 to CodeModel.ClassCount-1
              do
                begin
                slChamps_non_order_by.Clear;
                Classe:= CodeModel.Classes[ I];
                slParametres.Clear;
                Classe_Name:= Classe.Name;
                if    ('TObject'   <>Classe_Name)
                   and('IInterface'<>Classe_Name)
                   and('IUnknown'  <>Classe_Name)
                then
                    begin
                       slCle.Clear;
                       nfCle:= sRepSource+Classe_Name+'.Cle.txt';
                       if FileExists( nfCle)
                       then
                           slCle.LoadFromFile( nfCle)
                       else
                           slCle.SaveToFile( nfCle);

                    Nom_de_la_table:= LowerCase( Classe_Name);

                    slParametres.Values[s_Nom_de_la_classe]:= Classe_Name;
                    slParametres.Values[s_Nom_de_la_table ]:= Nom_de_la_table;

                    SQL_Create
                    :=
                      'CREATE TABLE '+Nom_de_la_table+s_SQL_saut+
                      '  ('+s_SQL_saut+
                      '  '+TailleNom('rowid')+
                           ' INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,'+s_SQL_saut;
                    QfieldsDFM  := '';
                    QfieldsPAS  := '';
                    jpv_LabelsDFM    := '';
                    jpv_Champ_EditDFM:= '';
                    jpv_LabelsPAS    := '';
                    jpv_Champ_EditPAS:= '';
                    jpv_AffectePAS:= '';
                    jpv_uses_ubl  := '';
                    jpv_uses_upool:= '';
                    Ouverture_key:= '';
                    Test_Declaration_Key    := '';
                    Test_Implementation_Key := '';
                    Test_Implementation_Body
                    :=
                      'var                                                 '#13#10+
                      '   bl: Tbl'+Classe_Name+';                          '#13#10+
                      'begin                                               '#13#10+
                      '          Nouveau_Base( bl);                        '#13#10;
                    Test_Call_Key:= '';
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
                    declaration_champs       := '';
                    creation_champs          := '';
                    Get_by_Cle_Declaration   := '';
                    Get_by_Cle_Implementation:= '';
                    Get_by_Cle_Implementation_Body:= '';
                    sCle_Formule             := '';
                    sCle_from__Declaration:= '';
                    sCle_from__Implementation:= '';
                    sCle_from__Implementation_Body:= '';
                    sCle_Implementation_Body:= '';
                    Declaration_cle:= '';
                    To_SQLQuery_Params_Body        := '';
                    SQLWHERE_ContraintesChamps_Body:= '';
                    aggregations_faibles_declaration:= '';
                    aggregations_faibles_pool_get:= '';

                    if Classe.TaggedValueCount > 0
                    then
                        begin
                        TaggedValue:= '';
                        for J:= 0 to Classe.TaggedValueCount-1
                        do
                          begin
                          TaggedValue
                          :=
                              TaggedValue
                            + Classe.TaggedValueNames[J]
                            + '='
                            + Classe.TaggedValues[ Classe.TaggedValueNames[J]];
                          end;
                        ShowMessage( TaggedValue);
                        end;

                    for J:= 0 to Classe.MemberCount-1
                    do
                      Traite_Member( Classe.Members[J]);

                    //Fermeture des chaines
                    SQL_Create:= SQL_Create + '  )'+s_SQL_saut;
                    QfieldsDFM:= QfieldsDFM +   s_QfieldsDFM;
                    QfieldsPAS:= QfieldsPAS +   s_QfieldsPAS;

                    jpv_LabelsDFM    := jpv_LabelsDFM     + JoinPoint_LabelsDFM    ;
                    jpv_Champ_EditDFM:= jpv_Champ_EditDFM + JoinPoint_Champ_EditDFM;
                    //jpv_LabelsPAS    
                    //jpv_Champ_EditPAS
                    //jpv_Affecte

                    Test_Declaration_Key:= Test_Declaration_Key+'):Integer;'#13#10;
                    Test_Implementation_Body
                    :=
                      Test_Implementation_Body+
                      '     bl.Save_to_database;                            '#13#10+
                      '     Result:= bl.id;                                 '#13#10+
                      'end;                                                 '#13#10;
                    Test_Implementation_Key
                    :=
                      Test_Implementation_Key+'):Integer;'#13#10+
                      Test_Implementation_Body
                      ;

                    Test_Call_Key:= Test_Call_Key+#13#10');';

                    Termine_CellClick_KeyPress( f_dbgCellClick_Key,
                                                f_dbgKeyPress_Key,
                                                f_dbgKeyPress_Key_Variables
                                                );
                    Termine_CellClick_KeyPress( dkd_dbgCellClick_Key,
                                                dkd_dbgKeyPress_Key,
                                                dkd_dbgKeyPress_Key_Variables
                                                );
                    Get_by_Cle_Declaration
                    :=
                      Get_by_Cle_Declaration+'): Tbl'+Classe_Name+';';
                    Get_by_Cle_Implementation_Body
                    :=
                        Get_by_Cle_Implementation_Body
                      + sCle_Formule+');'#13#10
                      + '     Get_Interne( Result);       '#13#10
                      + 'end;                             '#13#10;
                    Get_by_Cle_Implementation
                    :=
                      Get_by_Cle_Implementation+'): Tbl'+Classe_Name+';'#13#10
                      + 'begin                               '#13#10
                      + Get_by_Cle_Implementation_Body;
                    sCle_from__Declaration
                    :=
                        sCle_from__Declaration +'): String;'#13#10;
                    sCle_from__Implementation
                    :=
                        sCle_from__Implementation+'): String;'#13#10
                      + 'begin                               '#13#10
                      + sCle_from__Implementation_Body+';    '#13#10
                      + 'end;                                ';

                    sCle_Implementation_Body:= sCle_Implementation_Body+');';
                    To_SQLQuery_Params_Body
                    :=
                      To_SQLQuery_Params_Body+';';
                    SQLWHERE_ContraintesChamps_Body
                    :=
                      SQLWHERE_ContraintesChamps_Body+''';';

                    //Gestion du libellé
                    slLibelle:= TStringList.Create;
                    try
                       nfLibelle:= sRepSource+Classe_Name+'.libelle.txt';
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
                       nfOrder_By:= sRepSource+Classe_Name+'.order_by.txt';
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
                           Order_By_Key:= '      rowid';
                    finally
                           slOrder_by.SaveToFile( nfOrder_By);
                           FreeAndNil( slOrder_by);
                           end;

                    //Gestion des index suplémentaires
                    slIndex:= TStringList.Create;
                    try
                       nfIndex:= sRepSource+Classe_Name+'.Index.txt';
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
                       nfDetails:= sRepSource+Classe_Name+'.Details.txt';
                       if FileExists( nfDetails)
                       then
                           slDetails.LoadFromFile( nfDetails);
                       NbDetails:= slDetails.Count;
                       for J:= 0 to NbDetails-1
                       do
                         begin
                         s_dkd:= 'dkd'+slDetails[J];
                         f_implementation_uses_key
                         :=
                             f_implementation_uses_key
                           + '    u'+s_dkd     +','#13#10;
                         s_dkd_Accroche
                         :=
                           '               '+s_dkd+'.Accroche( dm'+Classe_Name+', pc);'#13#10;
                         s_dkd_Decroche:= '                   '+s_dkd+'.Decroche;'#13#10;

                         f_Execute_Before_Key:= f_Execute_Before_Key+ s_dkd_Accroche     ;
                         f_Execute_After_Key := s_dkd_Decroche      + f_Execute_After_Key;
                         end;
                    finally
                           slDetails.SaveToFile( nfDetails);
                           FreeAndNil( slDetails);
                           end;

                    dkd_implementation_uses_key  :=  f_implementation_uses_key;


                    slParametres.Values[s_Order_By_Key  ]:= Order_By_Key  ;
                    slParametres.Values[s_CREATE_TABLE  ]:= SQL_Create    ;
                    slParametres.Values[  s_QfieldsDFM  ]:= QfieldsDFM    ;
                    slParametres.Values[  s_QfieldsPAS  ]:= QfieldsPAS    ;
                    slParametres.Values[JoinPoint_LabelsDFM    ]:= jpv_LabelsDFM    ;
                    slParametres.Values[JoinPoint_Champ_EditDFM]:= jpv_Champ_EditDFM;
                    slParametres.Values[JoinPoint_LabelsPAS    ]:= jpv_LabelsPAS    ;
                    slParametres.Values[JoinPoint_Champ_EditPAS]:= jpv_Champ_EditPAS;
                    slParametres.Values[JoinPoint_Affecte]:= jpv_AffectePAS;
                    slParametres.Values[s_QCalcFieldsKey]:= QCalcFieldsKey;
                    slParametres.Values[JoinPoint_uses_ubl  ]:= jpv_uses_ubl;
                    slParametres.Values[JoinPoint_uses_upool]:= jpv_uses_upool;
                    slParametres.Values[s_Ouverture_key          ]:= Ouverture_key          ;
                    slParametres.Values[s_Test_Declaration_Key   ]:= Test_Declaration_Key   ;
                    slParametres.Values[s_Test_Implementation_Key]:= Test_Implementation_Key;
                    slParametres.Values[s_Test_Call_Key          ]:= Test_Call_Key;
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
                    slParametres.Values[s_declaration_champs     ]:= declaration_champs;
                    slParametres.Values[s_creation_champs        ]:= creation_champs;
                    slParametres.Values[s_Get_by_Cle_Declaration   ]:= Get_by_Cle_Declaration   ;
                    slParametres.Values[s_Get_by_Cle_Implementation]:= Get_by_Cle_Implementation;
                    slParametres.Values[s_sCle_from__Declaration   ]:= sCle_from__Declaration   ;
                    slParametres.Values[s_sCle_from__Implementation]:= sCle_from__Implementation;
                    slParametres.Values[s_sCle_Implementation_Body ]:= sCle_Implementation_Body;
                    slParametres.Values[s_Declaration_cle          ]:= Declaration_cle;
                    slParametres.Values[s_To_SQLQuery_Params_Body        ]:= To_SQLQuery_Params_Body        ;
                    slParametres.Values[s_SQLWHERE_ContraintesChamps_Body]:= SQLWHERE_ContraintesChamps_Body;
                    slParametres.Values[s_aggregations_faibles_declaration]:= aggregations_faibles_declaration;
                    slParametres.Values[s_aggregations_faibles_pool_get]:= aggregations_faibles_pool_get;
                    slLog.Add( SQL_Create);
                    slLog.Add( 'Paramètres');
                    slLog.Add( slParametres.Text);

                    Produit;
                    MenuHandler.Add( Classe_Name, NbDetails = 0);
                    end;
                end;
              MenuHandler.Produit('');
              slLog.Add( S);
           finally
                  FreeAndNil( slChamps_non_order_by);
                  FreeAndNil( MenuHandler);
                  FreeAndNil( phPAS_DMCRE);
                  FreeAndNil( phPAS_POOL );
                  FreeAndNil( phPAS_F    );
                  FreeAndNil( phPAS_FCB  );
                  FreeAndNil( phPAS_DKD  );

                  FreeAndNil( phDFM_DMCRE);
                  FreeAndNil( phDFM_POOL );
                  FreeAndNil( phDFM_F    );
                  FreeAndNil( phDFM_FCB  );
                  FreeAndNil( phDFM_DKD  );

                  FreeAndNil( phDFM_FD  );
                  FreeAndNil( phPAS_FD  );

                  FreeAndNil( phPAS_BL   );
                  FreeAndNil( phPAS_HF   );
                  FreeAndNil( phPAS_TC   );
                  end;
        finally
               slLog.SaveToFile( sRepCible+'mmPatterns_from_MCD.log');
               FreeAndNil( slCle       );
               FreeAndNil( slLog       );
               FreeAndNil( slParametres);
               end;

        ShowMessage( 'mmPatterns_from_MCD exécuté avec succés');
     finally
            FreeAndNil( INI);
            end;
end;

{ TmmPatterns_from_MCD }

constructor TmmPatterns_from_MCD.Create;
begin
  inherited Create;
end;

destructor TmmPatterns_from_MCD.Destroy;
begin
  inherited Destroy;
end;

procedure TmmPatterns_from_MCD.Destroyed;
begin
  // just before ModelMaker releases the expert the Destroyed method is called.
  // Drop all references to the expert here.
end;

procedure TmmPatterns_from_MCD.Execute(Index: Integer);
begin
  // the Index-th menu-item was clicked: create report
  if Index = 0 then CreateFiles;
end;

function TmmPatterns_from_MCD.GetMenuPositions(Index: Integer): TMMMenuPosition;
begin
  // to which ModelMaker sub-menu should each verb be added
  // Since mpDocMenu is currently not supported we insert in the default ToolsMenu
  Result := mpToolsMenu;
end;

function TmmPatterns_from_MCD.GetMenuShortCuts(Index: Integer): TShortCut;
begin
  Result := ShortCut(Ord('P'), [ssCtrl, ssShift]);
end;

function TmmPatterns_from_MCD.GetVerbCount: Integer;
begin
  // just one menu item to be inserted
  Result := 1;
end;

function TmmPatterns_from_MCD.GetVerbs(Index: Integer): WideString;
begin
  // return menu items Captions here
  Result := '&Patterns from MCD';
end;

function TmmPatterns_from_MCD.ExpertID: WideString;
begin
  Result := 'MARS42.mmPatterns_from_MCD';
end;

procedure TmmPatterns_from_MCD.ExecuteAction(Index: Integer);
begin

end;

function TmmPatterns_from_MCD.GetActionCount: Integer;
begin
    Result:= 0;
end;

function TmmPatterns_from_MCD.GetCustomImages(ImageIndexOffset: Integer;
  var Images: Cardinal): Boolean;
begin
     Result:= False;
end;

function TmmPatterns_from_MCD.GetCustomMenuData: WideString;
begin
     Result:= '';
end;

function TmmPatterns_from_MCD.GetCustomToolbarData: WideString;
begin
     Result:= '';
end;

procedure InitializeExpert(const Srv: IMMToolServices); stdcall;
begin
  // Copy interface pointer to initialize global var in MMToolsApi.pas
  // Older versions of MM the V8 typecast can be omitted
  MMToolServices := Srv as IMMToolServices;
  // Register the expert
  Srv.AddExpert(TmmPatterns_from_MCD.Create);
  // now sync with parent window, if we omit this, modal dialogs won't be really modal and
  // modeless forms will behave even worse.
  Application.Handle := Srv.GetParentHandle;
end;

procedure FinalizeExpert; stdcall;
begin
  // there's no need to export this function is there's nothing to clean up
  // In this expert all the cleaning-up is done by the Expert.Destroyed
end;

function ExpertVersion: LongInt; stdcall;
begin
  // This funciton and it's implementation are mandatory, if this function is not
  // exported or the version mismatches the version in ModelMaker, the expert is not
  // loaded
  Result := MMToolsApiVersion;
end;

exports
  InitializeExpert name MMExpertEntryProcName,
  FinalizeExpert name MMExpertExitProcName,
  ExpertVersion name MMExpertVersionProcName;

end.