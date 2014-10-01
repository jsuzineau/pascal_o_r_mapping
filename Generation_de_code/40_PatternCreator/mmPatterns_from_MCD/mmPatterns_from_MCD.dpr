library mmPatterns_from_MCD;


uses
  SysUtils,
  Windows,
  Controls,
  Forms,
  Dialogs,
  Classes,
  Menus,
  IniFiles,
  MMToolsApi in 'MMToolsApi.PAS',
  MMEngineDefs in 'MMEngineDefs.PAS',
  MMDiagramAPI in 'MMDiagramAPI.PAS',
  uPatternHandler in 'uPatternHandler.pas',
  uMenuHandler in 'uMenuHandler.pas',
  uf_f_dbgKeyPress_Key_Pattern in 'uf_f_dbgKeyPress_Key_Pattern.pas' {f_f_dbgKeyPress_Key_Pattern};

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
    procedure GetActionData(Index: Integer; var Data: TMMActionData);safecall;
    function GetCustomImages(ImageIndexOffset: Integer; var Images: Cardinal): Boolean; safecall;
    function GetCustomMenuData: WideString; safecall;
    function GetCustomToolbarData: WideString; safecall;

  end;

function JustFileName(const FileName: string): string;
begin
  Result := ExtractFileName(FileName);
  Result := Copy(Result, 1, Length(Result) - Length(ExtractFileExt(Result)));
end;

function CalculeSaisi_from_ClassName( ClassName: String): Boolean;
begin
     Result:= False;
     if ClassName = '' then exit;

     Result:= ClassName[1] = 'c';
end;

function NomTable_from_ClassName( ClassName: String): String;
begin
     Result:= ClassName;
     if CalculeSaisi_from_ClassName( ClassName)
     then
         Delete( Result, 1, 1);
end;

procedure AjouteUnite( ClasseMembre: String; var ClauseUses: String);
var
   NomUniteVirgule: String;
begin
     NomUniteVirgule:= 'u'+ClasseMembre+',';
     if 0 = Pos( NomUniteVirgule, ClauseUses)
     then
         ClauseUses:= ClauseUses+ '    '+NomUniteVirgule+#13#10;
end;

procedure CreateFiles;
const
     sys_Vide                 = '';
     s_NomTable               = 'NomTable';
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
var
   CodeModel: IMMCodeModel;
   Classe: IMMClassBase;
   I, J, nClasseMembre: Integer;
   S: String;
   TaggedValue: String;

   sRepSource, sRepCible: String;

   _Classe_Name: String;
   NomTable: String;
   Order_By_Key: String;
   SQL_Create : String;
   QfieldsDFM,
   QfieldsPAS: String;
   QCalcFieldsKey: String;
   implementation_uses_key: String;
   Ouverture_key,
   Test_Declaration_Key    ,
   Test_Implementation_Key: String;
   Test_Implementation_Body,
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

   Traite_Index_key,
   QFields_hr_init
                             :String;

   phPAS_DMCRE,
   phPAS_DMLK ,
   phPAS_DMA  ,
   phPAS_DM   ,
   phPAS_F    ,
   phPAS_FCB  ,
   phPAS_DMD  ,
   phPAS_DKD  ,

   phDFM_DMCRE,
   phDFM_DMLK ,
   phDFM_DMA  ,
   phDFM_DM   ,
   phDFM_F    ,
   phDFM_FCB  ,
   phDFM_DMD  ,
   phDFM_DKD  ,

   phPAS_HR   ,
   phPAS_TC   : TPatternHandler;
   slParametres: TStringList;

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
        sRepRacine:= sRepSource+'u'+Racine+s_NomTable;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCible,slParametres);
        phDFM:= TPatternHandler.Create( sRepRacine+'.DFM',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_HR( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'uhr'+s_NomTable;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_TC( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'utc'+s_NomTable;
        phPAS:= TPatternHandler.Create( sRepRacine+'.PAS',sRepCible+'dunit\',slParametres);
   end;

   function SQL_from_Type( Typ: String): String;
   begin
        Typ:= UpperCase( Typ);
             if'STRING'    =Typ then Result:='CHAR( 42) '
        else if'BYTE'      =Typ then Result:='TINYINT UNSIGNED'
        else if'INTEGER'   =Typ then Result:='INTEGER   '
        else if'DATE'      =Typ then Result:='DATE      '
        else if'TDATETIME' =Typ then Result:='DATETIME  '
        else if'CURRENCY'  =Typ then Result:='DOUBLE    '
        else if'FLOAT'     =Typ then Result:='DOUBLE    '
        else if'GRAPHIC'   =Typ then Result:='MEDIUMBLOB'
        else if'MEMO'      =Typ then Result:='TEXT      '
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
        else if'BYTE'      =Typ then Result:='TIntegerField'
        else if'INTEGER'   =Typ then Result:='TIntegerField'
        else if'DATE'      =Typ then Result:='TDateField'
        else if'TDATETIME' =Typ then Result:='TDateTimeField'
        else if'CURRENCY'  =Typ then Result:='TCurrencyField'
        else if'FLOAT'     =Typ then Result:='TFloatField'
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

   procedure Traite_Member( Member: IMMMember);
   var
      Member_Name: String;
      SQL: String;
      sNomChamp: String;
      _sClasseMembre: String;
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
               S:= S + Debut
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
              + 'if Column.Field = '+prefixe_dm+NomTable+'.q'+Member_Name+'      '#13#10
              + '     then                                                 '#13#10
              + '         begin                                            '#13#10
              + '         Deroule'+sNomTableMembre+'( Column, '+
                              prefixe_dm+NomTable+'.qn'+Member_Name+'); '#13#10
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
              + '(F = '+prefixe_dm+NomTable+'.q'+Member_Name+')';
      end;

   begin
        SQL:= '  ';

        Member_Name  := Member.Name;
        Delete( Member_Name, 1, 4); // _1__ jsPortage_de_repas
        //Delete( Member_Name, 1, 5); // _01__ jsComptaMatieres, LeLogisVarsois, These

        _sClasseMembre:= Member.DataName;
        sNomTableMembre:= NomTable_from_ClassName( _sClasseMembre);
        CleEtrangere:= CodeModel.FindClass( _sClasseMembre, nClasseMembre);

        if CleEtrangere
        then
            begin
            sNomChamp:= 'n'+Member_Name;
            SQL:= SQL+TailleNom( sNomChamp)+' INTEGER UNSIGNED';
            AjouteIndex( sNomChamp);
            end
        else
            begin
            sNomChamp:= Member_Name;
            SQL:= SQL+
                  TailleNom(sNomChamp)+' '+SQL_from_Type( _sClasseMembre);
            end;

        if i = 0
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

        SQL_Create:= SQL_Create+','+s_SQL_saut+SQL;
        QfieldsDFM     :=QfieldsDFM     +    DFM_from_Type('q',sNomChamp,sTypChamp,CleEtrangere);
        QfieldsPAS     :=QfieldsPAS     +    PAS_from_Type('q',sNomChamp,sTypChamp);
        QFields_hr_init:=QFields_hr_init+hr_init_from_Type('q',sNomChamp,sTypChamp);


        pv( Test_Declaration_Key   , '    function Test('         );
        pv( Test_Implementation_Key, 'function Tdm'+NomTable+'.Test(');
        sParametre:= ' _'+sNomChamp;
        sDeclarationParametre:= sParametre+': '+sTyp;
        Test_Declaration_Key    := Test_Declaration_Key   +sDeclarationParametre;
        Test_Implementation_Key := Test_Implementation_Key+sDeclarationParametre;
        Test_Implementation_Body
        :=
          Test_Implementation_Body+
          '       q'+TailleNom(sNomChamp)+'.Value:='+TailleNom(sParametre)+';'#13#10;

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
               if -1 = slDetails.IndexOf( NomTable)
               then
                   slDetails.Add( NomTable);
            finally
                   slDetails.SaveToFile( nfDetails);
                   FreeAndNil( slDetails);
                   end;
            end;
   end;
   procedure Produit;
   begin                     slLog.Add( 'avant phPAS_DMCRE.Produit');
        phPAS_DMCRE.Produit; slLog.Add( 'avant phPAS_DMLK .Produit');
        phPAS_DMLK .Produit; slLog.Add( 'avant phPAS_DMA  .Produit');
        phPAS_DMA  .Produit; slLog.Add( 'avant phPAS_DM   .Produit');
        phPAS_DM   .Produit; slLog.Add( 'avant phPAS_F    .Produit');
        phPAS_F    .Produit; slLog.Add( 'avant phPAS_FCB  .Produit');
        phPAS_FCB  .Produit; slLog.Add( 'avant phPAS_DMD  .Produit');
        phPAS_DMD  .Produit; slLog.Add( 'avant phPAS_DKD  .Produit');
        phPAS_DKD  .Produit; slLog.Add( 'avant phDFM_DMCRE.Produit');
        phDFM_DMCRE.Produit; slLog.Add( 'avant phDFM_DMLK .Produit'); //
        phDFM_DMLK .Produit; slLog.Add( 'avant phDFM_DMA  .Produit');
        phDFM_DMA  .Produit; slLog.Add( 'avant phDFM_DM   .Produit');
        phDFM_DM   .Produit; slLog.Add( 'avant phDFM_F    .Produit');
        phDFM_F    .Produit; slLog.Add( 'avant phDFM_FCB  .Produit');
        phDFM_FCB  .Produit; slLog.Add( 'avant phDFM_DMD  .Produit');
        phDFM_DMD  .Produit; slLog.Add( 'avant phDFM_DKD  .Produit');
        phDFM_DKD  .Produit; slLog.Add( 'avant phPAS_HR   .Produit');
        phPAS_HR   .Produit; slLog.Add( 'avant phPAS_TC   .Produit');//
        phPAS_TC   .Produit;
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
        sRepSource:= INI.ReadString( 'Options', 'sRepSource', ExtractFilePath(MMToolServices.ProjectManager.ProjectName)+'Source\patterns\');
        sRepCible := INI.ReadString( 'Options', 'sRepCible' , ExtractFilePath(MMToolServices.ProjectManager.ProjectName)+'Source\');
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );

        slParametres:= TStringList.Create;
        slLog       := TStringList.Create;
        try
           CreePatternHandler( phPAS_DMCRE, phDFM_DMCRE, 'dmcre');
           CreePatternHandler( phPAS_DMLK , phDFM_DMLK , 'dmlk' );
           CreePatternHandler( phPAS_DMA  , phDFM_DMA  , 'dma'  );
           CreePatternHandler( phPAS_DM   , phDFM_DM   , 'dm'   );
           CreePatternHandler( phPAS_F    , phDFM_F    , 'f'    );
           CreePatternHandler( phPAS_FCB  , phDFM_FCB  , 'fcb'  );
           CreePatternHandler( phPAS_DMD  , phDFM_DMD  , 'dmd'  );
           CreePatternHandler( phPAS_DKD  , phDFM_DKD  , 'dkd'  );
           CreePatternHandler_HR( phPAS_HR);
           CreePatternHandler_TC( phPAS_TC);
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
                _Classe_Name:= Classe.Name;
                CalculeSaisi_:= CalculeSaisi_from_ClassName( _Classe_Name);
                NomTable:= NomTable_from_ClassName( _Classe_Name);
                if    ('TObject'   <>_Classe_Name)
                   and('IInterface'<>_Classe_Name)
                   and('IUnknown'  <>_Classe_Name)
                then
                    begin
                    slParametres.Values[s_NomTable]:= NomTable;

                    SQL_Create
                    :=
                      'CREATE TABLE '+NomTable+s_SQL_saut+
                      '  ('+s_SQL_saut+
                      '  '+TailleNom('Numero')+
                           ' INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY';
                    QfieldsDFM  := '';
                    QfieldsPAS  := '';
                    implementation_uses_key:= '';
                    Ouverture_key:= '';
                    Test_Declaration_Key    := '';
                    Test_Implementation_Key := '';
                    Test_Implementation_Body
                    :=
                      'begin                                               '#13#10+
                      '     t.Insert;                                      '#13#10;
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
                    //QFields_hr_init:= QFields_hr_init + #13#10+s_QFields_hr_init;
                    Test_Declaration_Key:= Test_Declaration_Key+'):Integer;'#13#10;
                    Test_Implementation_Body
                    :=
                      Test_Implementation_Body+
                      '     t.Post;                                        '#13#10+
                      '     Result:= qNumero.Value;                        '#13#10+
                      'end;                                                '#13#10;
                    Test_Implementation_Key
                    :=
                      Test_Implementation_Key+'):Integer;'#13#10+
                      Test_Implementation_Body
                      ;

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
                       nfLibelle:= sRepSource+NomTable+'.libelle.txt';
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
                       nfOrder_By:= sRepSource+NomTable+'.order_by.txt';
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
                       nfIndex:= sRepSource+NomTable+'.Index.txt';
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
                       nfDetails:= sRepSource+NomTable+'.Details.txt';
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
                           '               '+s_dkd+'.Accroche( dm'+NomTable+', pc);'#13#10;
                         s_dkd_Decroche
                         :=
                           '                   '+s_dkd+'.Decroche( dm'+NomTable+', pc);'#13#10;

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
                    slLog.Add( SQL_Create);
                    slLog.Add( QFields_hr_init);

                    Produit;
                    //slLog.Add( 'aprés Produit');
                    MenuHandler.Add( NomTable, NbDetails = 0, CalculeSaisi_);
                    //slLog.Add( 'MenuHandler.Add');
                    end;
                end;
              MenuHandler.Produit;
              slLog.Add( S);
           finally
                  FreeAndNil( slChamps_non_order_by);
                  FreeAndNil( MenuHandler);
                  FreeAndNil( phPAS_DMCRE);
                  FreeAndNil( phPAS_DMLK );
                  FreeAndNil( phPAS_DMA  );
                  FreeAndNil( phPAS_DM   );
                  FreeAndNil( phPAS_F    );
                  FreeAndNil( phPAS_FCB  );
                  FreeAndNil( phPAS_DMD  );
                  FreeAndNil( phPAS_DKD  );

                  FreeAndNil( phDFM_DMCRE);
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
               slLog.SaveToFile( sRepCible+'mmPatterns_from_MCD.log');
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

procedure TmmPatterns_from_MCD.GetActionData(Index: Integer;
  var Data: TMMActionData);
begin

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
