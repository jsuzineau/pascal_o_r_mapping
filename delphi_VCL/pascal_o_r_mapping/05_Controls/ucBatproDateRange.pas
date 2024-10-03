unit ucBatproDateRange;
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
    u_sys_,
    uSGBD,
    uuStrings,
    uDataUtilsU,
  SysUtils, Classes, VCL.Controls, VCL.StdCtrls, VCL.Mask;

type
 TBatproDateRange
 =
  class(TMaskEdit)
  private
    { Déclarations privées }
    D1, D2: String;
    FFieldName: String;
    procedure Default_EditMask;

    procedure SetDateMin(Value: TDateTime);
    procedure SetDateMax(Value: TDateTime);
    function  GetDateMin: TDateTime;
    function  GetDateMax: TDateTime;
  protected
    { Déclarations protégées }
    procedure Loaded; override;
  public
    { Déclarations publiques }
    function SQLConstraint: String;
    function Critere: String;
    constructor Create(AOwner: TComponent); override;

    property DateMin: TDateTime read GetDateMin write SetDateMin;
    property DateMax: TDateTime read GetDateMax write SetDateMax;
    procedure Decompose;
    procedure Compose;

    function Has_DateMin: Boolean;
    function Has_DateMax: Boolean;
  published
    { Déclarations publiées }
    property FieldName: String read FFieldName write FFieldName;
  end;

procedure Register;

implementation

const
     sys_Milieu        = '<= X <=';
     sys_FormatDateTime= 'dd/mm/yyyy';

procedure Register;
begin
     RegisterComponents( 'Batpro', [TBatproDateRange]);
end;

procedure TBatproDateRange.Default_EditMask;
begin
     EditMask:= '99/99/9999\<\= X \<\=99/99/9999;1;_';
end;

constructor TBatproDateRange.Create( AOwner: TComponent);
begin
     inherited;
     Font.Name:= 'Courier New';
     Font.Size:= 8;
     Width:= 183;
     Default_EditMask;
end;

procedure TBatproDateRange.Loaded;
begin
     inherited;
     Default_EditMask;
end;

procedure TBatproDateRange.Decompose;
var
   S: String;
begin
     S:= Text;
     D1:= StrToK( sys_Milieu, S);
     D2:= S;
end;

procedure TBatproDateRange.Compose;
begin
     Text:= D1+ sys_Milieu + D2;
end;

procedure Date_to_sys_Vide( var D: String);
var
   I: Integer;
   Vide: Boolean;
begin
     Vide:= true;
     for I:= Length( D) downto 1
     do
       case D[I]
       of
         ' ': Delete( D, I, 1);
         '/': ;
         else Vide:= False;
         end;
     if Vide
     then
         D:= sys_Vide;
end;

function TBatproDateRange.SQLConstraint: String;
   procedure TraiteDate( Operateur, sD: String);
   var
      D: TDateTime;
      sqlD: String;
   begin
        if not TryStrToDate( sD, D) then exit;

        sqlD:= sgbd_DateSQL( D);
        SQL_AND( Result, SQL_OP( FieldName, Operateur, sqlD));
   end;
begin
     Decompose;

     Date_to_sys_Vide(D1);
     Date_to_sys_Vide(D2);

     Result:= sys_Vide;
     TraiteDate( '>=', D1);
     TraiteDate( '<=', D2);
end;

function TBatproDateRange.Critere: String;
begin
     Decompose;

     Date_to_sys_Vide(D1);
     Date_to_sys_Vide(D2);

     if D1 = sys_Vide
     then
         if D2 = sys_Vide
         then
             Result:= sys_Vide
         else
             Result:= 'jusqu''au '+D2
     else
         if D2 = sys_Vide
         then
             Result:= 'à partir du '+D1
         else
             Result:= 'du '+D1+'  au  '+D2;
end;

procedure TBatproDateRange.SetDateMin( Value: TDateTime);
begin
     Decompose;
     D1:= FormatDateTime( sys_FormatDateTime, Value);
     Compose;
end;

procedure TBatproDateRange.SetDateMax( Value: TDateTime);
begin
     Decompose;
     D2:= FormatDateTime( sys_FormatDateTime, Value);
     Compose;
end;

function TBatproDateRange.Has_DateMax: Boolean;
var
   Test: TDateTime;
begin
     Decompose;
     Date_to_sys_Vide(D2);
     Result:= TryStrToDate( D2, Test);
end;

function TBatproDateRange.Has_DateMin: Boolean;
var
   Test: TDateTime;
begin
     Decompose;
     Date_to_sys_Vide(D1);
     Result:= TryStrToDate( D1, Test);
end;

function TBatproDateRange.GetDateMax: TDateTime;
begin
     Decompose;
     Date_to_sys_Vide(D2);
     Result:= StrToDate( D2);
end;

function TBatproDateRange.GetDateMin: TDateTime;
begin
     Decompose;
     Date_to_sys_Vide(D1);
     Result:= StrToDate( D1);
end;

end.
