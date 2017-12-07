unit ufOpenSCAD_Box_Generator;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type
 TfOpenSCAD_Box_Generator
 =
  class(TForm)
  private

  public

  end;

var
   fOpenSCAD_Box_Generator: TfOpenSCAD_Box_Generator;

implementation

{$R *.lfm}

end.

holes x,y array
plots x,y array
BoardShape x,y array

components
  position   x,y,z
  dimensions x,y,z
  direction  x,y,z
  type
  color




