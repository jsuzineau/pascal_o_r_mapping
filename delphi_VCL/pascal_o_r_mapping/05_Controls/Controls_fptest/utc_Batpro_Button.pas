unit utc_Batpro_Button;
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
  uClean,
  ucBatpro_Button,
  TestFrameWork,
  SysUtils, Classes, VCL.Forms, VCL.Controls, VCL.Dialogs;

type
 Ttc_Batpro_Button
 =
  class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;
    procedure bbClick( Sender:TObject);
    procedure bbNext( Sender:TObject);
    procedure bbPrevious( Sender:TObject);
  published

    // Test methods
    procedure Test;
  end;

implementation

{ Ttc_Batpro_Button }

procedure Ttc_Batpro_Button.bbClick(Sender: TObject);
begin
     uForms_ShowMessage( 'bbClick');
end;

procedure Ttc_Batpro_Button.bbNext(Sender: TObject);
begin
     uForms_ShowMessage( 'bbNext');
end;

procedure Ttc_Batpro_Button.bbPrevious(Sender: TObject);
begin
     uForms_ShowMessage( 'bbPrevious');
end;

procedure Ttc_Batpro_Button.Test;
var
   F: TForm;
   bb1, bb2, bb3: TBatpro_Button;
   procedure Cree_bb( var bb:TBatpro_Button;
                      _Top, _Width, _Height: Integer;
                      _OnClick     ,
                      _OnGoNext    ,
                      _OnGoPrevious: TNotifyEvent;
                      _wcPrevious,
                      _wcNext    : TWinControl);
   begin
        bb:= TBatpro_Button.Create( F);
        bb.Parent:= F;
        //bb.Name:= 'bb';
        bb.Top   := _Top   ;
        bb.Width := _Width ;
        bb.Height:= _Height;
        bb.OnClick := _OnClick     ;
        bb.OnGoNext    := _OnGoNext    ;
        bb.OnGoPrevious:= _OnGoPrevious;
        bb.wcNext    := _wcNext    ;
        bb.wcPrevious:= _wcPrevious;
        bb.Apres_Chargement;
   end;
   procedure Connecte_bb( bb:TBatpro_Button;
                          _wcPrevious,
                          _wcNext    : TWinControl);
   begin
        bb.wcNext    := _wcNext    ;
        bb.wcPrevious:= _wcPrevious;
   end;
begin
     F:= TForm.Create( nil);
     try
        F.Name:= 'f_tc_Batpro_Button';
        F.Width:= 300;

        Cree_bb( bb1,  5, 60, 20, bbClick, bbNext, bbPrevious, nil, bb2);
        Cree_bb( bb2, 30, 60, 20, bbClick, bbNext, bbPrevious, bb1, bb3);
        Cree_bb( bb3, 60, 60, 20, bbClick, bbNext, bbPrevious, bb2, nil);
        Connecte_bb( bb1, nil, bb2);
        Connecte_bb( bb2, bb1, bb3);
        Connecte_bb( bb3, bb2, nil);

        F.ShowModal;
     finally
            Free_nil( F);
            end;
end;

initialization

  TestFramework.RegisterTest('utc_Batpro_Button Suite',Ttc_Batpro_Button.Suite);

end.
 
