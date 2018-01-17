unit ucBitBtn;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TBitBtn
  =
   class(TButton)
   private
     { Déclarations privées }
   protected
     { Déclarations protégées }
   public
     { Déclarations publiques }
   published
     { Déclarations publiées }
   end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TBitBtn]);
end;

end.
