unit utcOD_Printer;
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
    See OOoDelphiReportEngineTests.dpr for full copyright notice.             |
|                                                                             }
interface

uses
    utcOD_TestCase,
    uOpenDocument,
    uOD_Dataset_Columns,
    uODRE_Table,
    uOD_Printer,
  SysUtils, Classes, DB, DBClient,
  TestFrameWork;

type
 TtcOD_Printer
 =
  class( TtcOD_TestCase)
  private
    cd2: TClientDataset;
  // Test methods
  published
    procedure TestAssureModele;
    procedure TestExecute;
  end;

implementation

{ TtcOD_Printer }

procedure TtcOD_Printer.TestAssureModele;
var
   cd1: TClientDataset;
   ODRE_Table: TODRE_Table;
   OD_Dataset_Columns
   , OD_Dataset_Columns1
   : TOD_Dataset_Columns;
   NomFichier: String;
begin
     NomFichier:= ExtractFilePath( ParamStr(0))+'OD_AssureModele.ott';
     cd := TClientDataset.Create( nil);
     cd1:= TClientDataset.Create( nil);
     cd2:= TClientDataset.Create( nil);
     ODRE_Table:= TODRE_Table.Create( 'table');
     OD_Dataset_Columns := ODRE_Table.AddDataset( cd );
     OD_Dataset_Columns1:= ODRE_Table.AddDataset( cd1);
     ODRE_Table.OD_SurTitre.Init(['Les colonnes 3,4,5'], [2], [4]);
     //ODRE_Table.OD_Merge   := OD_Merge;
     try
        ODRE_Table.AddColumn( 1, 'Column 0');
        ODRE_Table.AddColumn( 1, 'Column 1');
        ODRE_Table.AddColumn( 1, 'Column 2');
        ODRE_Table.AddColumn( 1, 'Column 3');
        ODRE_Table.AddColumn( 1, 'Column 4');
        ODRE_Table.AddColumn( 2, 'Column 8');
        Cree_dataset( 5);
        Cree_dataset_interne( cd1, 'cd1', 5);
        OD_Dataset_Columns .Ajoute_Column_Avant( 0, 0, 0);
        OD_Dataset_Columns .Ajoute_Column_Avant( 1, 1, 1);
        OD_Dataset_Columns .Ajoute_Column_Avant( 2, 2, 2);
        OD_Dataset_Columns .Ajoute_Column_Avant( 3, 3, 3);
        OD_Dataset_Columns .Ajoute_Column_Avant( 4, 4, 4);
        OD_Dataset_Columns .Ajoute_Column_Avant( 7, 5, 5);
        OD_Dataset_Columns1.Ajoute_Column_Avant( 0, 2, 2);
        OD_Dataset_Columns1.Ajoute_Column_Avant( 1, 3, 3);
        OD_Dataset_Columns1.Ajoute_Column_Avant( 2, 4, 4);
        OD_Dataset_Columns1.Ajoute_Column_Avant( 7, 5, 5);
        Cree_dataset_interne( cd2, 'cd2');
        OD_Printer.AssureModele( NomFichier, ['truc'], [cd], [ODRE_Table]);
     finally
            Detruit_Dataset;
            FreeAndNil( cd2);
            end;
end;

procedure TtcOD_Printer.TestExecute;
var
   cd1: TClientDataset;
   ODRE_Table: TODRE_Table;
   OD_Dataset_Columns
//   , OD_Dataset_Columns1
   : TOD_Dataset_Columns;
   NomFichier: String;
begin
     NomFichier:= ExtractFilePath( ParamStr(0))+'OD.ott';
     cd := TClientDataset.Create( nil);
     cd1:= TClientDataset.Create( nil);
     cd2:= TClientDataset.Create( nil);
     ODRE_Table:= TODRE_Table.Create( 'table');
     ODRE_Table.Pas_de_persistance:= True;
     OD_Dataset_Columns := ODRE_Table.AddDataset( cd );
     //OD_Dataset_Columns1:= ODRE_Table.AddDataset( cd1);
     //ODRE_Table.OD_SurTitre.Init(['Les colonnes 3,4,5'], [2], [4]);
     //ODRE_Table.OD_Merge   := OD_Merge;
     try
        ODRE_Table.AddColumn( 1, 'Column 0');
        ODRE_Table.AddColumn( 4, 'Column 1');
        ODRE_Table.AddColumn( 1, 'Column 2');
        ODRE_Table.AddColumn( 1, 'Column 3');
        ODRE_Table.AddColumn( 1, 'Column 4');
        Cree_dataset( 50);
        Cree_dataset_interne( cd1, 'cd1', 50);
        OD_Dataset_Columns .Ajoute_Column_Avant( 0, 0, 0);
        OD_Dataset_Columns .Ajoute_Column_Avant( 1, 1, 1);
        OD_Dataset_Columns .Ajoute_Column_Avant( 2, 2, 2);
        OD_Dataset_Columns .Ajoute_Column_Avant( 3, 3, 3);
        OD_Dataset_Columns .Ajoute_Column_Avant( 4, 4, 4);
        //OD_Dataset_Columns1.Ajoute_Column_Avant( 0, 2, 2);
        //OD_Dataset_Columns1.Ajoute_Column_Avant( 1, 3, 3);
        //OD_Dataset_Columns1.Ajoute_Column_Avant( 2, 4, 4);
        Cree_dataset_interne( cd2, 'cd2');
        OD_Printer.Execute( NomFichier,
                            'TtcOD_MultiDetail.Test_avec_SousDetails_Execute;',
                            ['truc'],['troc'], [cd], [ODRE_Table]);
     finally
            Detruit_Dataset;
            FreeAndNil( cd2);
            end;
end;

initialization

  TestFramework.RegisterTest('utcOD_Printer Suite',
    TtcOD_Printer.Suite);

end.
