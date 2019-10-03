unit uAMS_AS7265x;

{$mode objfpc}{$H+}

interface

uses
 uuStrings,
 Classes, SysUtils;


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

const
     longueurs_onde                 : array[0..17] of integer= ( 410,435,460,485,510,535,560,585,610,645,680,705,730,760,810,860,900,940);
     alphabetique_from_data         : array[0..17] of byte   = ( 12, 13, 14, 15, 16, 17, 6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5);
     alphabetique_from_longueur_onde: array[0..17] of byte   = ( 0, 1, 2, 3, 4, 5, 6, 7, 12, 8, 13, 9, 14, 15, 16, 17, 10, 11);
                                                               //0  1  2  3  4  5  6  7   8  9  10 11  12  13  14  15  16  17
     longueur_onde_from_alphabetique: array[0..17] of byte   = ( 0, 1, 2, 3, 4, 5, 6, 7, 9, 11, 16, 17, 8, 10, 12, 13, 14, 15);
                                                               //0  1  2  3  4  5  6  7  8   9  10 11  12  13  14  15  16  17

function longueur_onde_from_data( iData: Integer): Integer;
function uAMS_AS7265x_Verifie_constantes: String;

type
    TAS7265x_Data= array[0..17] of double;

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

end.

