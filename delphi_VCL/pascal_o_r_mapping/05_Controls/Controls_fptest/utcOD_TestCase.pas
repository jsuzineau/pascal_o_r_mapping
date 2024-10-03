unit utcOD_TestCase;
{                                                                             |
    Part of program OOoDelphiReportEngineTests                                |
                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                          |
            partly as freelance: http://www.mars42.com                        |
        and partly as employee : http://www.batpro.com                        |
    Contact: gilles.doutre@batpro.com                                         |
                                                                              |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                           |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                   |
                                                                              |
    See OD_DelphiReportEngineTests.dpr for full copyright notice.             |
|                                                                             }

interface

uses
  uOD_SurTitre,
  uOD_Merge,
  SysUtils, Classes, DB, DBClient,VCL.Forms,
  TestFrameWork;

type
 TtcOD_TestCase
 =
  class( TTestCase)
  protected
    cd: TClientDataset;
    OD_SurTitre: TOD_SurTitre;
    OD_Merge: TOD_Merge;
    procedure Cree_dataset_interne( _cd: TClientDataset; _cd_Name: String;
                                    LigneMax: Integer= 42);
    procedure Cree_dataset( LigneMax: Integer= 42);
    procedure Detruit_Dataset;
  end;

implementation

{ TtcOD_TestCase }

procedure TtcOD_TestCase.Cree_dataset_interne( _cd: TClientDataset; _cd_Name: String;
                                               LigneMax: Integer= 42);
var
   Numero,
   Code,
   Colonne3,
   Colonne4,
   Colonne5,
   Colonne6,
   Colonne7,
   Colonne8,
   Colonne5_CellStyle,
   NewPage,
   LineSize: TField;
   I: Integer;
   sI, Ligne_sI: String;
   Ligne_NewPage: Boolean;
   NomImage: String;
   procedure L( _sNumero, _Code, _3, _4, _5: String; _6: double; _7: TDateTime; _8: String; _NewPage: Boolean; _LineSize: Integer=0);
   begin
        Numero  .AsString  := _sNumero;
        Code    .AsString  := _Code;
        Colonne3.AsString  := _3;
        Colonne4.AsString  := _4;
        Colonne5.AsString  := _5;
        Colonne6.asFloat   := _6;
        Colonne7.AsDateTime:= _7;
        Colonne8.AsString  := _8;
        NewPage .AsBoolean := _NewPage;
        LineSize.AsInteger := _LineSize;
   end;
   procedure LT( _Code, _Libelle: String; _LineSize: Integer= 0);
   begin
        _cd.Append;
        L( '', _Libelle, _Code, _Libelle, _Libelle, 0, Now, '', False, _LineSize);
        _cd.Post;
   end;
begin
     _cd.Name:= _cd_Name;
     _cd.FieldDefs.Add( _cd_Name+'_Numero'  , ftAutoInc);
     _cd.FieldDefs.Add( _cd_Name+'_Code'    , ftString, 255);
     _cd.FieldDefs.Add( _cd_Name+'_Colonne3', ftString, 255);
     _cd.FieldDefs.Add( _cd_Name+'_Colonne4', ftString, 255);
     _cd.FieldDefs.Add( _cd_Name+'_Colonne5', ftString, 255);
     _cd.FieldDefs.Add( _cd_Name+'_ftFloat' , ftFloat );
     _cd.FieldDefs.Add( _cd_Name+'_ftDate'  , ftDate  );
     _cd.FieldDefs.Add( 'graphic'+_cd_Name+'_Test'  , ftString, 255);
     _cd.FieldDefs.Add( _cd_Name+'_Colonne5_Cellstyle', ftString, 255);
     _cd.FieldDefs.Add( 'NewPage' , ftBoolean);
     _cd.FieldDefs.Add( 'LineSize', ftInteger);

     _cd.CreateDataSet;
     Numero  := _cd.FieldByName(_cd_Name+'_Numero');
     Code    := _cd.FieldByName(_cd_Name+'_Code');
     Colonne3:= _cd.FieldByName(_cd_Name+'_Colonne3');
     Colonne4:= _cd.FieldByName(_cd_Name+'_Colonne4');
     Colonne5:= _cd.FieldByName(_cd_Name+'_Colonne5');
     Colonne6:= _cd.FieldByName(_cd_Name+'_ftFloat' );
     Colonne7:= _cd.FieldByName(_cd_Name+'_ftDate'  );
     Colonne8:= _cd.FieldByName('graphic'+_cd_Name+'_Test');
     Colonne5_CellStyle:= _cd.FieldByName(_cd_Name+'_Colonne5_Cellstyle');
     NewPage := _cd.FieldByName('NewPage' );
     LineSize:= _cd.FieldByName('LineSize');

     Numero  .DisplayLabel:= _cd_Name+' - Les numéros';
     Code    .DisplayLabel:= _cd_Name+' - Les codes'  ;
     Colonne3.DisplayLabel:= _cd_Name+' - La colonne 3';
     Colonne4.DisplayLabel:= _cd_Name+' - La colonne 4';
     Colonne5.DisplayLabel:= _cd_Name+' - La colonne 5';
     Colonne6.DisplayLabel:= _cd_Name+' - type ftFloat';
     Colonne7.DisplayLabel:= _cd_Name+' - type ftDate' ;
     Colonne8.DisplayLabel:= _cd_Name+' - graphisme'   ;
     NomImage:= ExtractFilePath( Application.ExeName)+'test.png';
     for I:= 0 to LigneMax
     do
       begin
       sI:= IntToStr(I);
       if I mod 10 = 0
       then
           Ligne_sI:= '' //pour déclencher la fusion (merge)
       else
           Ligne_sI:= 'Ligne '+sI;
       if (I mod 20 = 0) and (I <> 0)
       then
           begin
           Ligne_NewPage:= True;//pour déclencher le saut de page
           Ligne_sI:= 'Ligne '+sI+' - Saut de page';
           end
       else
           begin
           Ligne_NewPage:= False;
           end;

       _cd.Append;
       L( sI, Ligne_sI, Ligne_sI, Ligne_sI, Ligne_sI, I+I/10, Now+I, NomImage, Ligne_NewPage);
       if Odd(I)
       then
           Colonne5_CellStyle.AsString:= 'Table Contents'
       else
           Colonne5_CellStyle.AsString:= 'Heading';
       _cd.Post;
       end;

     LT( 'Test des espaces',
          '1> <,'
         +'2>  <,'
         +'3>   <,'
         +'4>    <,'
         +'5>     <,'
         +'6>      <,'
         +'7>       <,'
         +'Fin');
     LT( 'Test des espaces + SautLigne',
          '1> <,'#13#10
         +'2>  <,'#13#10
         +'3>   <,'#13#10
         +'4>    <,'#13#10
         +'5>     <,'#13#10
         +'6>      <,'#13#10
         +'7>       <,'#13#10
         +'Fin');
     LT( 'Test des saut de ligne',
          ' Windows 13,10>'#13#10
         +'<Linux      10>'#10
         +'>Mac     13   >'#13
         +'<Fin');
     LT( 'Test LineSize 20', 'Test LineSize 20', 20);
     LT( 'Test LineSize 40', 'Test LineSize 40', 40);
     LT( 'Test LineSize  7', 'Test LineSize  7',  7);
end;

procedure TtcOD_TestCase.Cree_dataset( LigneMax: Integer= 42);
begin
     Cree_dataset_interne( cd, 'cd', LigneMax);
     OD_SurTitre:= TOD_SurTitre.Create();
     OD_SurTitre.Init(['Les colonnes 3,4,5'], [2], [4]);
     OD_Merge
     :=
       TOD_Merge.Create( [0],
                         [1]);
end;

procedure TtcOD_TestCase.Detruit_Dataset;
begin
     FreeAndNil( OD_Merge);
     FreeAndNil( OD_SurTitre);
     FreeAndNil( cd);
end;

end.
