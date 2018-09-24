unit utcDataUtilsU;

{$mode objfpc}{$H+}

interface

uses
    uLog,
    uDataUtilsU,
    uReels,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcDataUtilsU }

 TtcDataUtilsU
 =
  class(TTestCase)
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure Test_Arrondi_;
   procedure Test_Arrondi_00;
   procedure Test_with_Round;
   procedure Test_with_Corrige_Arrondi_;
  end;

implementation

function Round_00( _D: Double): Double;
begin
     Result:= Round( _D*100)/100;
end;

function Corrige_Arrondi_( E: Double): Double;
var
   Frac_E, Int_E: Double;
   Frac_E_10: double;
begin
      Int_E:=  Int(E);
     Frac_E:= Frac(E);
     Frac_E_10:= Frac_E * 10;
          if Frac_E_10 < -5 then Result:= Int_E - 1
     else if Frac_E_10 < +5 then Result:= Int_E
     else                        Result:= Int_E + 1;
end;

function Corrige_Arrondi_00 ( E: Double): Double;
begin
     Result:= Corrige_Arrondi_( E * 100 ) / 100 ;
end;

procedure TtcDataUtilsU.Test_Arrondi_;
   procedure T( _Valeur: Double; _Attendu: Double);
   var
      Obtenu: Double;
      procedure F;
      var
         sValeur ,
         sAttendu,
         sObtenu : String;
      begin
           sValeur :=FloatToStr( _Valeur );
           sAttendu:=FloatToStr( _Attendu);
           sObtenu :=FloatToStr(  Obtenu );
           Fail(  'Valeur : '+sValeur +#13#10
                 +'Attendu: '+sAttendu+#13#10
                 +'Obtenu : '+sObtenu +#13#10);
      end;
   begin
        Obtenu:= Arrondi_( _Valeur);
        if Obtenu <> _Attendu then F;
   end;
begin
     T( 0.48, 0);
end;

procedure TtcDataUtilsU.Test_Arrondi_00;
   procedure T( _Valeur: Double; _Attendu: Double);
   var
      Obtenu: Double;
      procedure F;
      var
         sValeur ,
         sAttendu,
         sObtenu : String;
      begin
           sValeur :=FloatToStr( _Valeur );
           sAttendu:=FloatToStr( _Attendu);
           sObtenu :=FloatToStr(  Obtenu );
           Fail(  'Valeur : '+sValeur +#13#10
                 +'Attendu: '+sAttendu+#13#10
                 +'Obtenu : '+sObtenu +#13#10);
      end;
   begin
        Obtenu:= Arrondi_00( _Valeur);
        if Obtenu <> _Attendu then F;
   end;
begin
     T(  100.9248,  100.92);
     T( -100.9248, -100.92);
end;

procedure TtcDataUtilsU.Test_with_Round;
   procedure T( _Valeur: Double; _Attendu: Double);
    var
       Obtenu: Double;
       procedure F;
       var
          sValeur ,
          sAttendu,
          sObtenu : String;
       begin
            sValeur :=FloatToStr( _Valeur );
            sAttendu:=FloatToStr( _Attendu);
            sObtenu :=FloatToStr(  Obtenu );
            Fail(  'Valeur : '+sValeur +#13#10
                  +'Attendu: '+sAttendu+#13#10
                  +'Obtenu : '+sObtenu +#13#10);
       end;
   begin
        Obtenu:= Round_00( _Valeur);
        if Obtenu <> _Attendu then F;
   end;
   procedure Compare;
   var
      I: Integer;
      D  ,
      D_A,
      D_R, Delta: Double;
      procedure F;
      var
         sD  ,
         sD_A,
         sD_R,
         S: String;

      begin
           sD  :=FloatToStr( D  );
           sD_A:=FloatToStr( D_A);
           sD_R:=FloatToStr( D_R);
           S:=  'D  : '+sD  +#13#10
               +'D_A: '+sD_A+#13#10
               +'D_R: '+sD_R+#13#10;
           Log.PrintLn( S);
           //Fail( S);
      end;
   begin
        for I:= -10000 to 10000
        do
          begin
          D:= I/1000;
          D_A:= Arrondi_00( D);
          D_R:=   Round_00( D);
          Delta:= D_A - D_R;
          if Reel_Zero( Delta) then continue;
          F;
          end;
   end;
begin
     T(  100.9248,  100.92);
     T( -100.9248, -100.92);
     Compare;
end;

procedure TtcDataUtilsU.Test_with_Corrige_Arrondi_;
   procedure T( _Valeur: Double; _Attendu: Double);
    var
       Obtenu: Double;
       procedure F;
       var
          sValeur ,
          sAttendu,
          sObtenu : String;
       begin
            sValeur :=FloatToStr( _Valeur );
            sAttendu:=FloatToStr( _Attendu);
            sObtenu :=FloatToStr(  Obtenu );
            Fail(  'Valeur : '+sValeur +#13#10
                  +'Attendu: '+sAttendu+#13#10
                  +'Obtenu : '+sObtenu +#13#10);
       end;
   begin
        Obtenu:= Corrige_Arrondi_00( _Valeur);
        if Obtenu <> _Attendu then F;
   end;
   procedure Compare;
   var
      I: Integer;
      D  ,
      D_A,
      D_CA,
      D_R: Double;
      procedure F;
      var
         sD  ,
         sD_A,
         sD_CA,
         sD_R,
         S: String;

      begin
           sD  :=FloatToStr( D  );
           sD_A:=FloatToStr( D_A);
           sD_CA:=FloatToStr( D_CA);
           sD_R:=FloatToStr( D_R);
           S:=  'D  : '+sD  +' D_A: '+sD_A+' D_CA: '+sD_CA+' D_R: '+sD_R;
           Log.PrintLn( S);
           //Fail( S);
      end;
   begin
        for I:= -10000 to 10000
        do
          begin
          D:= I/1000;
          D_A:= Arrondi_00( D);
          D_CA:= Corrige_Arrondi_00( D);
          D_R:=   Round_00( D);
          if     Reel_Zero( D_A  - D_R)
             and Reel_Zero( D_CA - D_R) then continue;
          F;
          end;
   end;
begin
     T(  100.9248,  100.92);
     T( -100.9248, -100.92);
     Compare;
end;

procedure TtcDataUtilsU.SetUp;
begin

end;

procedure TtcDataUtilsU.TearDown;
begin

end;

initialization

 RegisterTest(TtcDataUtilsU);
end.

