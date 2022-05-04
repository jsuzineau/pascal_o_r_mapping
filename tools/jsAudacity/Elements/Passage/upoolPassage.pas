unit upoolPassage;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    uLog,
    uBatpro_StringList,
    uDataUtilsU,
    uSGBD,

    uBatpro_Element,

    ublPassage,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uhfPassage,

    uHTTP_Interface,

  SysUtils, Classes,
  DB, sqldb,fpspreadsheetgrid, Variants,Math,StrUtils,fpsTypes, fpspreadsheet, xlsxml, fpsutils,LazUTF8;

type

 { TpoolPassage }

 TpoolPassage
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfPassage: ThfPassage;
  //Accés général
  public
    function Get( _id: integer): TblPassage;
  //Méthode de création de test
  public
    function Test( _Page       : Integer;
                   _Debut      : TDateTime;
                   _Fin        : TDateTime;
                   _Pourcentage: Double;
                   _Texte      : String
                   ):Integer;
  //Début d'une nouvelle session
  public
    function Nouveau: TblPassage;
  //Import Excel
  public
    procedure _from_wg( _wg: TsWorksheetGrid;
                        _Row_Start: Integer;
                        _Row_Stop : Integer);
    procedure _from_xlsx( _xlsx_FileName: String;
                        _Row_Start: Integer;
                        _Row_Stop : Integer);
  end;

function poolPassage: TpoolPassage;

implementation

var
   FpoolPassage: TpoolPassage= nil;

function poolPassage: TpoolPassage;
begin
     TPool.class_Get( Result, FpoolPassage, TpoolPassage);
end;

function poolPassage_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
begin
     Result:= poolPassage;
end;
{ TpoolPassage }

procedure TpoolPassage.DataModuleCreate(Sender: TObject);
begin
     uLog.Log.PrintLn( ClassName+'.DataModuleCreate, début');
     NomTable:= 'Passage';
     Classe_Elements:= TblPassage;
     Classe_Filtre:= ThfPassage;

     inherited;

     hfPassage:= hf as ThfPassage;
     ChampTri['id']:= +1;
     //ChampTri['Debut']:= +1;
     //ChampTri['Page']:= +1;

     uLog.Log.PrintLn( ClassName+'.DataModuleCreate, fin');
end;

function TpoolPassage.Get( _id: integer): TblPassage;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolPassage.Test( _Page       : Integer;
                            _Debut      : TDateTime;
                            _Fin        : TDateTime;
                            _Pourcentage: Double;
                            _Texte      : String
                            ): Integer;
var
   bl: TblPassage;
begin
     Nouveau_Base( bl);
       bl.Page       := _Page                ;
       bl.Debut      := _Debut               ;
       bl.Fin        := _Fin                 ;
       bl.Pourcentage:= _Pourcentage;
       bl.Texte      := _Texte               ;
     bl.Save_to_database;
     Result:= bl.id;
end;

function TpoolPassage.Nouveau: TblPassage;
begin
     uLog.Log.PrintLn('TpoolPassage.Start: Nouveau_Base( Result): début');
     Nouveau_Base( Result);
     if Result = nil then uLog.Log.PrintLn('TpoolPassage.Start: Nouveau_Base( Result) -> nil');
     if Result = nil then exit;

     Result.Save_to_database;
end;

procedure TpoolPassage._from_wg( _wg: TsWorksheetGrid;
                                 _Row_Start: Integer;
                                 _Row_Stop: Integer);
var
   iRow: Integer;
   bl: TblPassage;
   function  Integer_from_Variant( _v: Variant): Integer  ; begin if VarIsNull( _v) then Result:= 0   else Result:= _v; end;
   function DateTime_from_Variant( _v: Variant): TDateTime; begin if VarIsNull( _v) then Result:= 0.0 else Result:= _v; end;
   function   String_from_Variant( _v: Variant): String   ; begin if VarIsNull( _v) then Result:= ''  else Result:= _v; end;
begin
     for iRow:= _Row_Start to _Row_Stop
     do
       begin
       bl:= Nouveau;
       if nil = bl then continue;

       bl.Page:= Integer_from_Variant( _wg.Cells[1,iRow]);
       try
          bl.Debut:= DateTime_from_Variant( _wg.Cells[2,iRow]);
          bl.Fin  := DateTime_from_Variant( _wg.Cells[3,iRow]);
          //bl.Pourcentage:= _wg.Cells[3,iRow];
       except
             on E: Exception
             do
               begin
               end;
             end;
       bl.Texte:= String_from_Variant( _wg.Cells[7,iRow]);
       bl.Save_to_database;
       end;
end;

procedure TpoolPassage._from_xlsx( _xlsx_FileName: String;
                                   _Row_Start: Integer;
                                   _Row_Stop: Integer);
var
   wb: TsWorkbook;
   ws: TsWorksheet;
   iRow: Integer;
   c: PCell;
   bl: TblPassage;
{
case ContentType: TCellContentType of  // variant part must be at the end
  cctEmpty      : ();      // has no data at all
//      cctFormula    : ();      // FormulaValue is outside the variant record
  cctNumber     : (Numbervalue: Double);
  cctUTF8String : ();      // UTF8StringValue is outside the variant record
  cctDateTime   : (DateTimeValue: TDateTime);
  cctBool       : (BoolValue: boolean);
  cctError      : (ErrorValue: TsErrorValue);
}
   function  Integer_from_Cell( _c: PCell): Integer  ; begin if (_c = nil)or(cctNumber     <> _c.ContentType) then Result:= 0   else Result:= Trunc(ws.ReadAsNumber  ( _c)); end;
   function DateTime_from_Cell( _c: PCell): TDateTime; begin if (_c = nil)or(cctDateTime   <> _c.ContentType) then Result:= 0.0 else ws.ReadAsDateTime( _c, Result);         end;
   function   String_from_Cell( _c: PCell): String   ; begin if (_c = nil)or(cctUTF8String <> _c.ContentType) then Result:= ''  else Result:=       ws.ReadAsText    ( _c) ; end;
begin
     wb:= TsWorkbook.Create;
     try

       wb.ReadFromFile( UTF8ToSys(_xlsx_FileName));

       ws:= wb.GetWorksheetByIndex(0);


       for iRow:= _Row_Start to _Row_Stop
       do
         begin
         c:= ws.Cells.FindCell( iRow, 1-1);
         if nil = c then continue;

         bl:= Nouveau;
         if nil = bl then continue;

         bl.Page:= Integer_from_Cell(c);
         bl.Debut:= DateTime_from_Cell( ws.Cells.FindCell( iRow, 2-1));
         bl.Fin  := DateTime_from_Cell( ws.Cells.FindCell( iRow, 3-1));
         //bl.Pourcentage:= _wg.Cells[3,iRow];
         bl.Texte:= String_from_Cell( ws.Cells.FindCell( iRow, 7-1));
         bl.Save_to_database;
         end;
     finally
            ws:= nil;
            FreeAndNil( wb);
     end;

end;

initialization
finalization
              TPool.class_Destroy( FpoolPassage);
end.
