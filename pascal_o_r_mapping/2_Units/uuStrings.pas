unit uuStrings;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    uClean,
    uReels,
    uBatpro_StringList,
    u_sys_,

  {$IFDEF MSWINDOWS}Windows, {$ENDIF}
  SysUtils, Classes, Types;

const
     NbCaracteres_StatusBar= 110; //mesuré en police Courier New taille 8
                                  // sur une fenêtre de 800 pixels de large
     //NbCaracteres_Caption= 101; //mesuré avec des chiffres 1234567890
                                  // sur une fenêtre de 800 pixels de large
     NbCaracteres_Caption  =  64; //mesuré avec des W: WWWWWWWWWW
                                  // sur une fenêtre de 800 pixels de large


function StringDynArray( S: array of String): TStringDynArray;

function Indente( Indentation, S: String): String;

function ChaineDe( N: Integer; C: Char): String;

function Banner( C: Char; S: String; N: Integer): String;

function Espaces( N: Integer): String;

function Justifie( S: array of String; TailleLigne: Integer): String;

procedure Formate_Liste( var S: String; Separateur, Element: String); overload;
function  Formate_Liste( S: array of String    ; Separateur: String                       ): String; overload;
function  Formate_Liste( sl: TBatpro_StringList; Separateur: String; DoubleQuotes: Boolean): String; overload;

function Formate_Hint( S: array of String): String;

function Formate_Caption( S: array of String): String;

function Fixe_Min( S: String; L: Integer): String;

function Fixe_MinE( S: String; L: Integer): String;

function Fixe_Min0( S: String; L: Integer): String;

function Fixe_Min0V( S: String; L: Integer): String;

function Fixe_Min_etoiles( S: String; L: Integer): String;

function Fixe_Length( S: String; L: Integer): String;

function StrToC  ( aC: array of Char; var S: String): String;
function StrToK  ( Key: String; var S: String): String;
function StrSplit( Key: String; var S: String): String;

//Comme StrToK mais prend les NbCaracteres premiers caractères
function StrReadString( var S: String; NbCaracteres: Integer): String;

//Comme StrToK mais prend les NbCaracteres premiers caractères
//et recule à l'espace précédent si cela tombe dans un mot
function StrReadString_Cesure( var S: String; NbCaracteres: Integer): String;

function Is_Blank( C: Char): Boolean;

// provient du code source de Delphi, unité DBTables
function StrToOem(const AnsiStr: string): string;
function OEMToStr(const OEMStr: string): string;

function Parentheses( S: String): String;

function Formate_Affichage( Titre, Valeur: String;
                            Separateur: String = ': '): String;

function Echappe_Apostrophes(const S: string): string;

procedure Add_array_to_sl( a: array of String; sl: TBatpro_StringList);

function Majuscule_minuscules( S: String): String;

function IsDigit( S: String): Boolean;

function Entoure_Chaine( Chaine: String; Motif: Char; LargeurLigne: Integer): String;

function Enleve_Final( S, Final: String): String;

function Copy_from_to( S: String; Debut, Fin: Integer): String;

function Nb_saut_de_ligne( S: String): Integer;

function Ajuste_fins_de_ligne_CRLF( S: String): String;
function Ajuste_fins_de_ligne( S: String): String;

function Dedouble_fins_de_ligne_CRLF( S: String): String;

function Supprime_LF_finaux( S: String): String;

function NonTrouve( table: String; id: Integer): String;

function Remplace( S: String; Old, New: Char): String;
function Enleve( S: String; C: Char): String;

function Integer_At( _S: String; _Debut, _Longeur: Integer): Integer;

procedure Ajoute_Separateur_interne( var _S: String; _Separateur: String= #13#10);
procedure Ajoute_Separateur( var _S: String; _Ajout     : String; _Separateur: String= #13#10);

//récupère le type de fin de ligne
// '' si pas de saut, sinon #13#10, #13 ou #10
function FinLigne( S: String): String;

function sDate( _d: TDatetime): String;

function FirstChar( S: String): Char;

function Wordbreak( var Ligne, LigneSuivante: String): Boolean;

function Largeur_Maxi_Ligne( _S: String): Integer;

function Match_Root( _Root, _S: String):Boolean;

function JSArray_from_StringList( _sl: TStringList): String;

implementation

{ Indente
Retourne la chaine S en ajoutant la chaine Indentation
au début de chaque ligne de S
}
function Indente( Indentation, S: String): String;
var
   I: Integer;
begin
     Result:= S;
     {$IFDEF LINUX}
     //Writeln( 'uuStrings.Indente, début');
     {$ENDIF}
     for I:= Length(Result)-1 downto 0
     do
       if (I<=0) or (Result[I] = #10)
       then
           Insert( Indentation, Result, I+1);
     {$IFDEF LINUX}
     //Writeln( 'uuStrings.Indente, fin');
     {$ENDIF}
end;

{ ChaineDe
Retourne une chaine de N caractères C
}
function ChaineDe( N: Integer; C: Char): String;
begin
     if N = 0
     then
         Result:= sys_Vide
     else
         begin
         SetLength( Result, N);
         FillChar( Result[1], N, Ord(C));
         end;
end;

function Banner( C: Char; S: String; N: Integer): String;
var
   TotalPadding, Debut, Fin: Integer;
begin
     Result:= S;

     TotalPadding:= N - Length( S);
     if TotalPadding <= 0 then exit;

     Debut:= TotalPadding div 2;
     Fin:= TotalPadding - Debut;

     Result:= ChaineDe( Debut, C)+Result + ChaineDe( Fin, C);
end;

{ Espaces
Retourne une chaine de N espaces
}
function Espaces( N: Integer): String;
begin
     Result:= ChaineDe( N, ' ');
end;

{ Justifie
Retourne une chaine avec les éléments de S en ajoutant
des espaces pour atteindre la taille TailleLigne
}
function Justifie( S: array of String; TailleLigne: Integer): String;
var
   I, IGroupe: Integer;
   Taille, SL: Integer;
   TailleJustification: Integer;
   TailleVide: Integer;
   Justification_par_defaut: String;
   Chaines, Justification: array of String;
   NbGroupes, NbInterGroupes: Integer;
   TailleReste: Integer;
begin
     Taille:= 0;
     NbGroupes:= 0;

     for I:= Low(S) to High( S)
     do
       begin
       SL:= Length(S[I]);
       if SL <> 0
       then
           begin
           Inc( Taille, SL);
           Inc( NbGroupes);
           end;
       end;

     SetLength( Chaines, NbGroupes);
     IGroupe:= 0;
     for I:= Low( S) to High( S)
     do
       begin
       if S[I] <> sys_Vide
       then
           begin
           Chaines[IGroupe]:= S[I];
           Inc( IGroupe);
           end;
       end;

     if NbGroupes = 0 then begin Result:= sys_Vide  ; exit; end;
     if NbGroupes = 1 then begin Result:= Chaines[0]; exit; end;

     NbInterGroupes:= NbGroupes-1;
     SetLength( Justification, NbInterGroupes);

     TailleVide:= TailleLigne-Taille;

     if TailleVide <= 0
     then
         begin
         TailleJustification:= 0;
         TailleReste        := 0;
         end
     else
         begin
         TailleJustification:= TailleVide div NbInterGroupes;
         TailleReste        := TailleVide mod NbInterGroupes;
         end;


     Justification_par_defaut:= Espaces( TailleJustification);
     for I:= Low(Justification) to High( Justification)
     do
       Justification[I]:= Justification_par_defaut;

     for I:= High(Justification) to Low( Justification)
     do
       if TailleReste > 0
       then
           begin
           Justification[I]:= Justification[I]+' ';
           Dec( TailleReste);
           end;

     Result:= Chaines[Low(Chaines)];

     for I:= Low(Chaines)+1 to High( Chaines)
     do
       Result:= Result + Justification[I-1]+Chaines[I];
end;

{ Parentheses
Retourne la chaine S entourée par des parenthèses: 'a' --> '(a)'
}
function Parentheses( S: String): String;
begin
     Result:= Format( '(%s)', [S]);
end;

{ Formate_Liste
Concatène les éléments de S en les séparant par la chaine Separateur
et retourne le résultat.
}
procedure Formate_Liste( var S: String; Separateur, Element: String); overload;
begin
     if Element = sys_Vide then exit;

     if S <> sys_Vide
     then
         S:= S + Separateur;
         
     S:= S + Element;
end;

function Formate_Liste( S: array of String; Separateur: String): String; overload;
var
   I: Integer;
   Si: String;
begin
     Result:= sys_Vide;
     if Length( S) = 0 then exit;

     Result:= S[Low(S)];
     for I:= Low(S)+1 to High( S)
     do
       begin
       Si:= S[I];
       if Si <> sys_Vide
       then
           begin
           if Result <> sys_Vide
           then
               Result:= Result + Separateur;
           Result:= Result + Si;
           end;
       end;
end;

function Formate_Liste( sl: TBatpro_StringList; Separateur: String; DoubleQuotes: Boolean): String;
var
   I: Integer;
   Si: String;
   procedure T( _Valeur: String);
   begin
        if DoubleQuotes
        then
            Result:= Result + ''''+_Valeur+''''
        else
            Result:= Result + _Valeur;
   end;
begin
     Result:= sys_Vide;
     if sl.Count = 0 then exit;

     T( sl[0]);
     for I:= 1 to sl.Count-1
     do
       begin
       Si:= sl[I];
       if Si <> sys_Vide
       then
           begin
           if Result <> sys_Vide
           then
               Result:= Result + Separateur;
           T( Si);
           end;
       end;
end;

function Formate_Hint( S: array of String): String;
begin
     Result:=   Formate_Liste( S, sys_N)
              + sys_Pipe
              + Justifie( S, NbCaracteres_StatusBar);
end;

function Formate_Caption( S: array of String): String;
begin
     Result:= Justifie( S, NbCaracteres_Caption);
end;

{ Fixe_Min
Retourne une chaine de longueur minimum L en rajoutant des espaces à la fin si
nécessaire.
}
function Fixe_Min( S: String; L: Integer): String;
var
   LS, Complement, I: Integer;
begin
     LS:= Length(S);
     Complement:= L-LS;
     if Complement > 0
     then
         begin
         SetLength( Result, L);
         for I:= 1 to L
         do
           if I <= LS
           then
               Result[I]:= S[I]
           else
               Result[I]:= ' ';
         end
     else
         Result:= S;
end;

{ Fixe_Min0
Retourne une chaine de longueur minimum L en insérant des 0 au début si
nécessaire.
}
function Fixe_Min0( S: String; L: Integer): String;
var
   Complement: Integer;
begin
     Result:= S;

     Complement:= L-Length(S);
     if Complement > 0
     then
         Result:= StringOfChar( '0', Complement)+Result;
end;

function Fixe_MinE( S: String; L: Integer): String;
var
   Complement: Integer;
begin
     Result:= S;

     Complement:= L-Length(S);
     if Complement > 0
     then
         Result:= StringOfChar( ' ', Complement)+Result;
end;

function Fixe_Min_etoiles( S: String; L: Integer): String;
var
   Complement: Integer;
begin
     Result:= S;

     Complement:= L-Length(S);
     if Complement > 0
     then
         Result:= StringOfChar( '*', Complement)+Result;
end;

{ Fixe_Min0V
Retourne une chaine de longueur minimum L en insérant des 0 au début si
nécessaire. Mais contrairement à Fixe_Min0, si la chaine est vide, on renvoie
une chaine vide.
}
function Fixe_Min0V( S: String; L: Integer): String;
begin
     if S = sys_Vide
     then
         Result:= sys_Vide
     else
         Result:= Fixe_Min0( S, L);
end;

{ Fixe_Length
Retourne une chaine de longueur L en rajoutant des espaces à la fin si
nécessaire ou en la tronquant si elle est trop longue.
}
function Fixe_Length( S: String; L: Integer): String;
begin
     Result:= Copy( Fixe_Min( S, L), 1, L);
end;

function StrToC( aC: array of Char; var S: String): String;
var
   I: Integer;
   C: Char;
   iaC: Integer;
   Trouve: Boolean;
begin
     Result:= '';
     if S = '' then exit;

     for I:= 1 to Length(S)
     do
       begin
       Trouve:= False;
       C:= S[I];
       for iaC:= Low( aC) to High( aC)
       do
         begin
         Trouve:= C = aC[iaC];
         if Trouve then break;
         end;
       if Trouve then break;
       end;

     if I <> 0
     then
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, I);
         end;
end;

function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

{ StrSplit
idem StrToK mais ne consomme pas la clé
}
function StrSplit( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, I-1);
         end;
end;

//Comme StrToK mais prend les NbCaracteres premiers caractères
function StrReadString( var S: String; NbCaracteres: Integer): String;
begin
     Result:= Copy( S, 1, NbCaracteres);
     Delete( S, 1, NbCaracteres);
end;

function Is_Blank( C: Char): Boolean;
begin
     Result:= (C in [#32{espace}, #9{tabulation}])
end;

//Comme StrToK mais prend les NbCaracteres premiers caractères
//et recule à l'espace précédent si cela tombe dans un mot
function StrReadString_Cesure( var S: String; NbCaracteres: Integer): String;
var
   Cesure: Integer;
begin

     if         (NbCaracteres < Length( S))
        and not Is_Blank( S[NbCaracteres+1])
     then
         begin
         Cesure:= NbCaracteres;
         while     not Is_Blank( S[Cesure])
               and (Cesure > 1)
         do
           Dec( Cesure);
         if Cesure > 1
         then
             NbCaracteres:= Cesure;
         end;
     Result:= StrReadString( S, NbCaracteres)
end;

{ StrToOem
 provient du code source de Delphi, unité DBTables
}
function StrToOem(const AnsiStr: string): string;
begin
	 {$IFDEF MSWINDOWS}
     SetLength(Result, Length(AnsiStr));
     if Length(Result) > 0 
     then
         CharToOem(PChar(AnsiStr), PChar(Result));
     {$ELSE}
	 Result:= AnsiStr;
     {$ENDIF}
end;

{ OEMToStr
 provient du code source de Delphi, unité DBTables
}
function OEMToStr(const OEMStr: string): string;
begin
     {$IFDEF MSWINDOWS}
     SetLength(Result, Length(OEMStr));
     if Length(Result) > 0
     then
         OEMToChar(PChar(OEMStr), PChar(Result));
     {$ELSE}
     Result:= OEMStr;
     {$ENDIF}
end;

function Formate_Affichage( Titre, Valeur: String;
                            Separateur: String = ': '): String;
begin
     if Valeur = sys_Vide
     then
         Result:= sys_Vide
     else
         Result:= Titre + Separateur + Valeur;
end;

{ Echappe_Apostrophes
idem QuotedStr mais n'entoure pas la chaine avec des apostrophes
 QuotedStr          :   l'exemple ==>  'l''exemple'
 Echappe_Apostrophes:   l'exemple ==>   l''exemple
}
function Echappe_Apostrophes(const S: string): string;
var
  I: Integer;
begin
     Result := S;
     for I := Length(Result) downto 1
     do
       if Result[I] = '''' then Insert('''', Result, I);
end;

{ Add_array_to_sl
Ajoute un tableau de chaines à un TBatpro_StringList
}
procedure Add_array_to_sl( a: array of String; sl: TBatpro_StringList);
var
   I: Integer;
begin
     for I:= Low( a) to High( a)
     do
       sl.Add( a[I]);
end;

function Majuscule_minuscules( S: String): String;
var
   Debut, Fin: String;
begin
     Debut:= Copy( S, 1,1);
     Fin  := Copy( S, 2,Length(S));
     Result:= UpperCase( Debut)+ LowerCase( Fin);
end;

function IsDigit( S: String): Boolean;
var
   I: Integer;
begin
     Result:= S <> sys_Vide;
     if not Result then exit;

     for I:= 1 to Length( S)
     do
       begin
       Result:= S[I] in ['0'..'9'];
       if not Result then break;
       end;
end;

function Entoure_Chaine( Chaine: String;
                         Motif: Char; LargeurLigne: Integer): String;
var
   LChaine: Integer;
   L, L2: Integer;
   sL2: String;
begin
     LChaine:= Length( Chaine);
     L:= LargeurLigne - LChaine;
     L2:= L div 2;
     sL2:= ChaineDe( L2, Motif);

     Result:= sL2+Chaine+sL2;
     while Length( Result) < LargeurLigne do Result:= Result + Motif;
end;

function Enleve_Final( S, Final: String): String;
var
   lResult, lFinal: Integer;
begin
     Result:= S;
     lFinal := Length( Final );

     lResult:= Length( Result);
     while Final = Copy( Result, lResult-lFinal+1, lFinal)
     do
       begin
       Result:= Copy( Result, 1, lResult-lFinal);
       lResult:= Length( Result);
       end;
end;

function Copy_from_to( S: String; Debut, Fin: Integer): String;
begin
     Result:= Copy( S, Debut, Fin-Debut+1);
end;

function Nb_saut_de_ligne( S: String): Integer;
var
   I, LS: Integer;
   C, C1: Char;
begin
     Result:= 0;
     I:= 1;
     LS:= Length( S);
     while I <= LS
     do
       begin
       C:= S[I];
       if I < LS
       then
           C1:= S[I+1]
       else
           C1:= #0;

       case C
       of
         #13:
           begin
           Inc( Result);
           if C1 = #10 then Inc(I);
           end;
         #10: Inc( Result);
         end;

       Inc( I);
       end;
end;

function Ajuste_fins_de_ligne_interne( S, FinLigne: String): String;
var
   I, LS: Integer;
   C, C1: Char;
begin
     Result:= sys_Vide;
     I:= 1;
     LS:= Length( S);
     while I <= LS
     do
       begin
       C:= S[I];
       if I < LS
       then
           C1:= S[I+1]
       else
           C1:= #0;

       case C
       of
         #13:
           begin
           Result:= Result + FinLigne;
           if C1 = #10 then Inc(I);
           end;
         #10: Result:= Result + FinLigne;
         else Result:= Result + C;
         end;

       Inc( I);
       end;
end;

function Ajuste_fins_de_ligne( S: String): String;
const
     sys_Fin_Ligne= #13;
begin
     Result:= Ajuste_fins_de_ligne_interne( S, sys_Fin_Ligne);
end;

function Ajuste_fins_de_ligne_CRLF( S: String): String;
begin
     Result:= Ajuste_fins_de_ligne_interne( S, #13#10);
end;

function Dedouble_fins_de_ligne_CRLF( S: String): String;
var
   I, LS: Integer;
   C: Char;
begin
     Result:= sys_Vide;
     I:= 1;
     LS:= Length( S);
     while I <= LS
     do
       begin
       C:= S[I];
       if     (C      = #13)
          and (S[I+1] = #10)
          and (S[I+2] = #13)
          and (S[I+3] = #10)
       then
           Inc( I, 2);
       Result:= Result + C;

       Inc( I);
       end;
end;

function Supprime_LF_finaux( S: String): String;
var
   I: Integer;
begin
     Result:= sys_Vide;
     I:= Length( S);
     while     (I > 0)
           and (S[I] = #10)
     do
       Dec( I);// on ignore le caractère
     while I > 0
     do
       begin
       Result:= S[I] + Result;

       Dec( I);
       end;
end;

function NonTrouve( table: String; id: Integer): String;
begin
     Result:= Format('<%s id : %d > non trouvé', [table,id]);
end;

function Enleve( S: String; C: Char): String;
var
   iC: Integer;
   function C_Trouve: Boolean;
   begin
        iC:= Pos( C, S);
        Result:= iC > 0;
   end;
begin
     while C_Trouve
     do
       Delete( S, iC, 1);
     Result:= S;
end;

function Remplace( S: String; Old, New: Char): String;
var
   I: Integer;
   procedure R( var C: Char);
   begin
        if C = Old then C:= New;
   end;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       R( Result[I])
end;

function Integer_At( _S: String; _Debut, _Longeur: Integer): Integer;
var
   sResult: String;
begin
     sResult:= Copy( _S, _Debut, _Longeur);
     Result:= StrToInt( sResult); 
end;

procedure Ajoute_Separateur_interne( var _S: String; _Separateur: String= #13#10);
begin
     if _S = '' then exit;
     _S:= _S + _Separateur;
end;

procedure Ajoute_Separateur( var _S: String; _Ajout: String; _Separateur: String= #13#10);
begin
     if _Ajout = '' then exit;
     Ajoute_Separateur_interne( _S, _Separateur);
     _S:= _S + _Ajout;
end;

function FinLigne( S: String): String;
begin
          if Pos( #13#10, S) > 0 then Result:= #13#10
     else if Pos( #13   , S) > 0 then Result:= #13
     else if Pos( #10   , S) > 0 then Result:= #10
     else                             Result:= ''    ;
end;

function sDate( _d: TDatetime): String;
begin
     if Reel_Zero( _d)
     then
         Result:= ''
     else
         Result:= FormatDateTime( 'ddddd', _d);
end;

function FirstChar( S: String): Char;
begin
     if S = ''
     then
         Result:= #0
     else
         Result:= S[1];
end;

function StringDynArray( S: array of String): TStringDynArray;
var
   I: Integer;
begin
     SetLength( Result, Length(S));
     for I:= Low( S) to High( S)
     do
       Result[I]:= S[I];
end;

function Wordbreak( var Ligne, LigneSuivante: String): Boolean;
var
   I: Integer;
begin
     Result:= False;
     for I:= Length( Ligne) downto 1
     do
       begin
       if Ligne[I] in [' ', #9]
       then
           begin
           LigneSuivante:= Copy( Ligne, I+1, Length( Ligne))+LigneSuivante;
           Delete(Ligne, I+1, Length( Ligne));
           Result:= True;
           break;
           end;
       end;
end;

function Largeur_Maxi_Ligne( _S: String): Integer;
var
   sl: TStringList;
   I: Integer;
   Longueur: Integer;
begin
     Result:= 0;
     sl:= TStringList.Create;
     try
        sl.Text:= _S;
        for I:= 0 to sl.Count-1
        do
          begin
          Longueur:= Length( sl.Strings[I]);
          if Result < Longueur then Result:= Longueur;
          end;
     finally
            Free_nil( sl);
            end;
end;

function Match_Root( _Root, _S: String):Boolean;
begin
     Result:= True;
     if _Root = '' then exit;

     Result:= 1 = Pos( _Root, _S);
end;

function JSArray_from_StringList( _sl: TStringList): String;
var
   I: Integer;
begin
     Result:= '';
     for I:= 0 to _sl.Count-1
     do
       Formate_Liste( Result, ', ', '"'+_sl[I]+'"');
end;


end.
