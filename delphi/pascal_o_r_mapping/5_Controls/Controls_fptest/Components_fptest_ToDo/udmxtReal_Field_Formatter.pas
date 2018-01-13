unit udmxtReal_Field_Formatter;
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
    uForms,
  SysUtils, Variants, Classes, 
  DB, DBClient,
  TestFrameWork,
  uReal_Field_Formatter;

type
 TdmxtReal_Field_Formatter
 =
  class(TDataModule)
    cd: TClientDataSet;
    cdFloat: TFloatField;
    cdBCD: TBCDField;
    cdFMTBCD: TFMTBCDField;
    cdAggregate: TAggregateField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
    tc: TTestCase;
    rffFloat    : TrffFloat    ;
    rffAggregate: TrffAggregate;
    rffBCD      : TrffBCD      ;
    rffFMTBCD   : TrffFMTBCD   ;
    Value: Extended;
    sValue: String;
    rff_Format: Trff_Format;
    srff_Format: String;
    procedure SetValue( _Value: Extended);
    procedure Setrff_Format( Value: Trff_Format);
    procedure CheckText( F: TField; Text: String); overload;
    procedure CheckText( Text: String); overload;
    procedure TestValue( _Value: Extended; see, seee, s00, s000, s00ee: String);
    procedure Dot_to_DecimalSeparator( var S: String);
  public
    { Déclarations publiques }
    procedure Execute( _tc: TTestCase);
  end;

function dmxtReal_Field_Formatter: TdmxtReal_Field_Formatter;

implementation

uses
    uClean;

{$R *.dfm}

var
   FdmxtReal_Field_Formatter: TdmxtReal_Field_Formatter;

function dmxtReal_Field_Formatter: TdmxtReal_Field_Formatter;
begin
     Clean_Get( Result, FdmxtReal_Field_Formatter, TdmxtReal_Field_Formatter);
end;

procedure TdmxtReal_Field_Formatter.DataModuleCreate(Sender: TObject);
begin
     rffFloat    := TrffFloat    .Create( cdFloat    , rff_ee);
     rffAggregate:= TrffAggregate.Create( cdAggregate, rff_ee);
     rffBCD      := TrffBCD      .Create( cdBCD      , rff_ee);
     rffFMTBCD   := TrffFMTBCD   .Create( cdFMTBCD   , rff_ee);
     tc:= nil;
end;

procedure TdmxtReal_Field_Formatter.DataModuleDestroy(Sender: TObject);
begin
     Free_nil( rffFloat    );
     Free_nil( rffAggregate);
     Free_nil( rffBCD      );
     Free_nil( rffFMTBCD   );
end;

procedure TdmxtReal_Field_Formatter.SetValue( _Value: Extended);
begin
     Value:= _Value;
     sValue:= Format( '%f', [Value]);

     cd.Edit;
     cdFloat .Value  := Value;
     cdBCD   .Value  := Value;
     cdFMTBCD.AsFloat:= Value;
     cd.Post;

end;

procedure TdmxtReal_Field_Formatter.Setrff_Format( Value: Trff_Format);
begin
     rff_Format:= Value;
     case rff_Format
     of
       rff_ee  : srff_Format:= 'rff_ee  ';
       rff_eee : srff_Format:= 'rff_eee ';
       rff_00  : srff_Format:= 'rff_00  ';
       rff_000 : srff_Format:= 'rff_000 ';
       rff_00ee: srff_Format:= 'rff_00ee';
       else
           srff_Format:= 'Format inconnu';
       end;
     rffFloat    .rff_Format:= rff_Format;
     rffAggregate.rff_Format:= rff_Format;
     rffBCD      .rff_Format:= rff_Format;
     rffFMTBCD   .rff_Format:= rff_Format;
end;

procedure TdmxtReal_Field_Formatter.CheckText( F: TField; Text: String);
var
   DisplayText: String;
   Messag: String;
begin
     DisplayText:= F.DisplayText;
     Messag:= Format( ' %s, %s, %s => %s, attendu: %s',
                      [sValue, F.ClassName, srff_Format, DisplayText, Text]);
     tc.Check( DisplayText = Text, Messag);
end;

procedure TdmxtReal_Field_Formatter.CheckText( Text: String);
begin
     CheckText( cdFloat    , Text);
     CheckText( cdAggregate, Text);
     CheckText( cdBCD      , Text);
     //CheckText( cdFMTBCD   , Text);
end;

procedure TdmxtReal_Field_Formatter.Dot_to_DecimalSeparator( var S: String);
var
   I: Integer;
begin
     for I:= 1 to Length( S) do if S[I]= '.' then S[I]:= FormatSettings.DecimalSeparator;
end;

procedure TdmxtReal_Field_Formatter.TestValue( _Value: Extended;
                                               see  ,
                                               seee ,
                                               s00  ,
                                               s000 ,
                                               s00ee: String);
begin
     SetValue( _Value);
     Dot_to_DecimalSeparator( see  );
     Dot_to_DecimalSeparator( seee );
     Dot_to_DecimalSeparator( s00  );
     Dot_to_DecimalSeparator( s000 );
     Dot_to_DecimalSeparator( s00ee);

     Setrff_Format( rff_ee  ); CheckText( see  );
     Setrff_Format( rff_eee ); CheckText( seee );
     Setrff_Format( rff_00  ); CheckText( s00  );
     Setrff_Format( rff_000 ); CheckText( s000 );
     Setrff_Format( rff_00ee); CheckText( s00ee);
end;

procedure TdmxtReal_Field_Formatter.Execute( _tc: TTestCase);
begin
     cd.CreateDataSet;
     try
        tc:= _tc;

        TestValue( 0      , ' '   , ' '    , ' '   , ' '    , ' '     );
        TestValue( 0.00001, ' '   , ' '    , ' '   , ' '    , ' '     );
        TestValue( 1      , '1   ', '1    ', '1.00', '1.000', '1.00  ');
        TestValue( 1.2    , '1.2 ', '1.2  ', '1.20', '1.200', '1.20  ');
        TestValue( 1.25   , '1.25', '1.25 ', '1.25', '1.250', '1.25  ');
        TestValue( 1.256  , '1.26', '1.256', '1.26', '1.256', '1.256 ');
        TestValue( 1.2567 , '1.26', '1.257', '1.26', '1.257', '1.2567');
     finally
            tc:= nil;
            cd.Close;
            end;
     uForms_ShowMessage( 'Ce test ne porte pas sur les TFMTBCDField. '+
                  '(bug à l''affectation: 1,2 => tronqué à 1 sans raison)');
end;

initialization
              Clean_Create ( FdmxtReal_Field_Formatter, TdmxtReal_Field_Formatter);
finalization
              Clean_Destroy( FdmxtReal_Field_Formatter);
end.
