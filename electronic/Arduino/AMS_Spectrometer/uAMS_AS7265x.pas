unit uAMS_AS7265x;

{$mode objfpc}{$H+}

interface

uses
 uReels,
 uuStrings,
 uPublieur,
 Classes, SysUtils, LazSerial, stdctrls, Graphics;


//ordre  R, S, T, U, V, W, G, H, I, J, K, L, A, B, C, D, E, F
// longueurs d'ondes:
//	uint16_t wl[18]={410,435,460,485,510,535,560,585,610,645,680,705,730,760,810,860,900,940};
//                     // 0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17
//                        A   B   C   D   E   F   G   H   R   I   S   J   T   U   V   W   K   L
//    index alphabétique  0   1   2   3   4   5   6   7  12   8  13   9  14  15  16  17  10  11
//alphabétique
//  A B C D E F G H I J  K  L  R  S  T  U  V  W
//  0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17
const
     alphabetique: array[0..17] of Char = ('A','B','C','D','E','F','G','H','I','J','K','L','R','S','T','U','V','W');
//Data
// 12 13 14 15 16 17 6 7 8 9 10 11 0 1 2 3 4 5

//relation longueur d'onde / couleur: https://academo.org/demos/wavelength-to-colour-relationship/
const
     longueurs_onde                 : array[0..17] of integer= ( 410    ,435    ,460    ,485    ,510    ,535    ,560    ,585    ,610    ,645    ,680,705,730,760,810,860,900,940);
     Couleurs                       : array[0..17] of TColor = ( $DB007E,$FF0023,$FF7B00,$FFEA00,$00FF00,$00FF70,$00FFC3,$00EFFF,$009BFF,$0000FF,224,192,160,128, 96, 64, 32,  0);
     alphabetique_from_data         : array[0..17] of byte   = ( 12, 13, 14, 15, 16, 17, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5);
     alphabetique_from_longueur_onde: array[0..17] of byte   = ( 0, 1, 2, 3, 4, 5, 6, 7, 12, 8, 13, 9, 14, 15, 16, 17, 10, 11);
                                                               //0  1  2  3  4  5  6  7   8  9  10 11  12  13  14  15  16  17
     longueur_onde_from_alphabetique: array[0..17] of byte   = ( 0, 1, 2, 3, 4, 5, 6, 7, 9, 11, 16, 17, 8, 10, 12, 13, 14, 15);
                                                               //0  1  2  3  4  5  6  7  8   9  10 11  12  13  14  15  16  17

function longueur_onde_from_data( iData: Integer): Integer;
function uAMS_AS7265x_Verifie_constantes: String;

type
 TAS7265x_ATCDATA_Result= array[0..17] of double;

 TAS72651_Callback= procedure of object;

 { TAS72651 }

 TAS72651
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _ls: TLazSerial; _mLog: TMemo);
    destructor Destroy; override;
  //Connection série
  private
    ls: TLazSerial;
    procedure lsRxData(Sender: TObject);
  //Continuer
  public
    Continuer: Boolean;
  //Tampon
  public
    Tampon: String;
  // Log
  private
    mLog: TMemo;
  //Commande
  private
    Commande_CallBack: TAS72651_Callback;
  public
    Commande_Result: String;
    procedure Commande( _Commande: String; _CallBack: TAS72651_Callback);
  //ATCDATA
  public
    ATCDATA_Result_Invalid: Boolean;
    ATCDATA_Result: TAS7265x_ATCDATA_Result;
    PLU: TAS7265x_ATCDATA_Result;
    ATCDATA_Result_Corrige_PLU: TAS7265x_ATCDATA_Result;
    procedure ATCDATA( _CallBack: TAS72651_Callback);
    procedure ATDATA( _CallBack: TAS72651_Callback);
    procedure PLU_from_Courant;
    procedure Corrige;
  private
    ATCDATA_Callback: TAS72651_Callback;
    procedure ATCDATA_Complete;
    function Interprete_Valeur( _S: String): TAS7265x_ATCDATA_Result;
  end;


implementation

function longueur_onde_from_data( iData: Integer): Integer;
begin
     Result:= longueur_onde_from_alphabetique[ alphabetique_from_data[ iData]];
end;

function uAMS_AS7265x_Verifie_constantes: String;
var
   I: Integer;
   iAlphabetique: Integer;
   iLongueur_onde: Integer;
begin
     Result:= '';
     for I:= low( alphabetique_from_longueur_onde) to High( alphabetique_from_longueur_onde)
     do
       begin
       iAlphabetique :=  alphabetique_from_longueur_onde[ I            ];
       iLongueur_onde:= longueur_onde_from_alphabetique [ iAlphabetique];
       if I <> iLongueur_onde
       then
           Formate_Liste( Result, #13#10,
                           'incohérence longueur_onde_from_alphabetique '
                          +'pour '+alphabetique[iAlphabetique]+'('+IntToStr(iAlphabetique)+'), '
                          +'attendu '+IntToStr(I)+' '
                          +'obtenu '+IntToStr(iLongueur_onde));
       end;

end;

{ TAS72651 }

constructor TAS72651.Create(_ls: TLazSerial; _mLog: TMemo);
begin
     inherited Create;
     ls:= _ls;
     mLog:= _mLog;
     ls.OnRxData:= @lsRxData;
end;

destructor TAS72651.Destroy;
begin
     ls.OnRxData:= nil;
     inherited Destroy;
end;

procedure TAS72651.Commande(_Commande: String; _CallBack: TAS72651_Callback);
begin
     mLog.Lines.Add( _Commande);
     Tampon:= '';
     Commande_CallBack:= _Callback;
     ls.WriteData( _Commande+#13#10);
end;

procedure TAS72651.lsRxData(Sender: TObject);
var
   I: Integer;
  procedure delchar( _c: Char);
  var
     I: Integer;
  begin
       I:= Pos( _c, Commande_Result);
       if 0 = I then exit;
       Delete( Commande_Result, I, 1);
  end;
begin
     Tampon:= Tampon+ls.ReadData;
     if not Continuer then ls.Close;

     I:= Pos( #10, Tampon);
     if I = 0 then exit;

     Commande_Result:= StrToK( #10, Tampon);
     delchar(#13);
     Commande_CallBack;
end;

procedure TAS72651.ATCDATA( _CallBack: TAS72651_Callback);
begin
     ATCDATA_Callback:= _CallBack;
     Commande( 'ATCDATA', @ATCDATA_Complete);
end;

procedure TAS72651.ATDATA(_CallBack: TAS72651_Callback);
begin
     ATCDATA_Callback:= _CallBack;
     Commande( 'ATDATA', @ATCDATA_Complete);
end;

procedure TAS72651.ATCDATA_Complete;
begin
     ATCDATA_Result_Invalid:= '' = Commande_Result;
     if ATCDATA_Result_Invalid then exit;

     ATCDATA_Result:= Interprete_Valeur( Commande_Result);
     ATCDATA_Callback;
end;

function TAS72651.Interprete_Valeur(_S: String): TAS7265x_ATCDATA_Result;
//1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 OK
//123456789012345678901234567890123456789012345678901234567890123456789
//         1         2         3         4         5         6
var
   iData, iLongueur_Onde: Integer;
   sValeur: String;
   Valeur: Double;
begin
     mLog.Lines.Add( _S);

     FillChar( Result, SizeOf(Result), 0);
     iData:= 0;

     while _S <> ''
     do
       begin
       iLongueur_Onde:= longueur_onde_from_data( iData);
       sValeur:= StrToK( ',' , _S);

       if not TryStrToFloat( sValeur, Valeur, DefaultFormatSettings)
       then
           Valeur:= -1;
       Result[iLongueur_Onde]:= Valeur;
       Inc( iData);
       if iData > 17 then break;
       end;
end;

procedure TAS72651.PLU_from_Courant;
begin
     PLU:= ATCDATA_Result;
end;

procedure TAS72651.Corrige;
var
   I: Integer;
   PLU_i:double;
begin
     for I:= Low(ATCDATA_Result) to High(ATCDATA_Result)
     do
       begin
       PLU_i:= PLU[I];
       if Reel_Zero( PLU_i) then PLU_i:=0.1;
       ATCDATA_Result_Corrige_PLU[I]:= ATCDATA_Result[I]/PLU_i;
       end;

end;



end.

