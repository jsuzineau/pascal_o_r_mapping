unit ufjsConfigurateur;

{$mode objfpc}{$H+}

interface

uses
    uSGBD,
    ufBatpro_Informix,
    ufBatpro_MySQL,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfjsConfigurateur }

 TfjsConfigurateur
 =
  class(TForm)
   bSGBD: TButton;
   procedure bSGBDClick(Sender: TObject);
  private

  public

  end;

var
 fjsConfigurateur: TfjsConfigurateur;

implementation

{$R *.lfm}

{ TfjsConfigurateur }

procedure TfjsConfigurateur.bSGBDClick(Sender: TObject);
begin
     case SGBD
     of
       sgbd_Informix: fBatpro_Informix.Show;
       sgbd_MySQL   : fBatpro_MySQL   .Show;
       end;
end;

end.

