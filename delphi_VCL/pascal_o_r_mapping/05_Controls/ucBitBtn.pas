unit ucBitBtn;

interface

uses
  System.SysUtils, System.Classes,
  VCL.StdCtrls;

type
  TBitBtn
  =
   class(TButton)
   private
     { D�clarations priv�es }
   protected
     { D�clarations prot�g�es }
   public
     { D�clarations publiques }
   published
     { D�clarations publi�es }
   end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TBitBtn]);
end;

end.
