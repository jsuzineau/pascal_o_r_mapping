unit utcDataUtilsU;

{$mode objfpc}{$H+}

interface

uses
    uLog,
    uDataUtilsU,
    uReels,
    uuStrings,
    uftcDataUtilsU,
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
   procedure Test_Arrondi_Arithmetique_;
   procedure Test_Arrondi_Arithmetique_00;
   procedure Test_with_Round;
  end;

implementation

function Round_00( _D: Double): Double;
begin
     Result:= Round( _D*100)/100;
end;

function Bug_Arrondi_( E: Double): Double; // ancienne version boguée
var
   Frac_E, Int_E: Double;
   Frac_E_10: Int64;
begin
      Int_E:=  Int(E);
     Frac_E:= Frac(E);
     Frac_E_10:= Round( Frac_E * 10); //SetRoundMode( rmNearest) effectué en initialisation
          if Frac_E_10 < -5 then Result:= Int_E - 1
     else if Frac_E_10 < +5 then Result:= Int_E
     else                        Result:= Int_E + 1;
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

procedure TtcDataUtilsU.Test_Arrondi_Arithmetique_;
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
        Obtenu:= Arrondi_Arithmetique_( _Valeur);
        if Obtenu <> _Attendu then F;
   end;
begin
     T( 0.48, 0);
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
          D_A:= Arrondi_Arithmetique_00( D);
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

procedure TtcDataUtilsU.Test_Arrondi_Arithmetique_00;
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
        Obtenu:= Arrondi_Arithmetique_00( _Valeur);
        if Obtenu <> _Attendu then F;
   end;
   procedure Compare;
   const
        Start= -10000;
        Range= 100;
   var
      I: Integer;
      D  ,
      D_A,
      D_R: Double;
      sCSV: String;
      procedure F;
      var
         sD  ,
         sD_A,
         sD_R,
         S: String;

      begin
           sD   :=FloatToStr( D   );
           sD_A :=FloatToStr( D_A );
           sD_R :=FloatToStr( D_R );
           S:=  'D  : '+sD  +' D_A: '+sD_A+' D_R: '+sD_R;
           Log.PrintLn( S);
           sCSV:= sCSV+sD+';'+sD_A+' ;'+sD_R+#13#10;
           ftcDataUtilsU.cls.AddXY( D, D_A);
           //Fail( S);
      end;
   begin
        sCSV:= 'D;D_A;D_R'#13#10;
        ftcDataUtilsU.cls.Clear;

        //for I:= -10000 to 10000
        for I:= Start to Start+Range
        do
          begin
          D:= I/10000;
          D_A:= Arrondi_Arithmetique_00( D);
          D_R:=   Round_00( D);
          F;
          end;
        String_to_File( Log.Repertoire+ChangeFileExt(Log.Nom, '.csv'), sCSV);
        ftcDataUtilsU.Show;
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

