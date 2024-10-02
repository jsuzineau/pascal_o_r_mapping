{$DEFINE YYDEBUG}
{$DEFINE YYEXTRADEBUG}

unit uCSS_Style_Parser_PYACC;

interface

uses
    uLog,
    uBatpro_StringList,
    SysUtils, Classes, yacclib, lexlib, uStreamLexer;



const IDENT = 257;
const ATKEYWORD = 258;
const STRING_ = 259;
const BAD_STRING = 260;
const BAD_URI = 261;
const BAD_COMMENT = 262;
const HASH = 263;
const NUMBER = 264;
const PERCENTAGE = 265;
const DIMENSION = 266;
const URI = 267;
const UNICODE_RANGE = 268;
const CDO = 269;
const CDC = 270;
const COMMENT = 271;
const FUNCTION_ = 272;
const INCLUDES = 273;
const DASHMATCH = 274;
const DELIM = 275;

// If you have defined your own YYSType then put an empty  %union { } in
// your .y file. Or you can put your type definition within the curly braces.
type YYSType = record
                 yyString : String;
               end(*YYSType*);
// source: yyparse.cod line# 2
var yylval : YYSType;

type
 TCSS_Style_Parser_PLEX
 =
  class(TStreamLexer)
  public
    function Parse: integer; override;
  end;

 TWriteCallback = procedure( _Name, _Value: String) of object;
 ECSS_Style_Parser_PYACC_Exception = class(Exception);
 TCSS_Style_Parser_PYACC
 =
  class( TCustomParser)
  public
    sl: TBatpro_StringList;
    constructor Create;
    destructor Destroy; override;
    function Parse( _s: TStream) : integer; reintroduce;
  end;

implementation

constructor TCSS_Style_Parser_PYACC.Create;
begin
     inherited Create;
     sl:= TBatpro_StringList.Create( ClassName+'.sl');
end;

destructor TCSS_Style_Parser_PYACC.Destroy;
begin
     FreeAndNil( sl);
     inherited;
end;

function TCSS_Style_Parser_PYACC.Parse( _s: TStream) : integer;

var 
  lexer : TCSS_Style_Parser_PLEX;
  yystate, yysp, yyn : Integer;
  yys : array [1..yymaxdepth] of Integer;
  yyv : array [1..yymaxdepth] of YYSType;
  yyval : YYSType;

procedure yyaction ( yyruleno : Integer );
  (* local definitions: *)
// source: yyparse.cod line# 50
begin
  (* actions: *)
  case yyruleno of
1 : begin
         yyval := yyv[yysp-0];
       end;
2 : begin
         yyval := yyv[yysp-2];
       end;
3 : begin
       end;
4 : begin
         // source: uCSS_Style_Parser_PYACC.y line#41
         sl.Values[yyv[yysp-2].yyString]:= yyv[yysp-0].yyString;Log.PrintLn( 'declaration: Values['+yyv[yysp-2].yyString+']:= '+yyv[yysp-0].yyString)
       end;
5 : begin
         yyval := yyv[yysp-0];
       end;
6 : begin
         yyval := yyv[yysp-0];
       end;
7 : begin
         yyval := yyv[yysp-0];
       end;
8 : begin
         yyval := yyv[yysp-0];
       end;
9 : begin
         yyval := yyv[yysp-0];
       end;
10 : begin
         yyval := yyv[yysp-0];
       end;
11 : begin
         yyval := yyv[yysp-0];
       end;
12 : begin
         yyval := yyv[yysp-0];
       end;
13 : begin
         yyval := yyv[yysp-0];
       end;
14 : begin
         yyval := yyv[yysp-0];
       end;
15 : begin
         yyval := yyv[yysp-0];
       end;
16 : begin
         yyval := yyv[yysp-0];
       end;
17 : begin
         yyval := yyv[yysp-0];
       end;
18 : begin
         yyval := yyv[yysp-0];
       end;
19 : begin
         // source: uCSS_Style_Parser_PYACC.y line#56
         yyval.yyString:= yyv[yysp-2].yyString+yyv[yysp-1].yyString+')';Log.PrintLn( 'any: '+yyval.yyString);
       end;
20 : begin
         yyval := yyv[yysp-0];
       end;
21 : begin
       end;
22 : begin
         yyval := yyv[yysp-0];
       end;
23 : begin
         // source: uCSS_Style_Parser_PYACC.y line#61
         yyval.yyString:= yyv[yysp-2].yyString+','+yyv[yysp-0].yyString;Log.PrintLn( 'paramlist: '+yyval.yyString);
       end;
// source: yyparse.cod line# 54
  end;
end(*yyaction*);

(* parse table: *)

type YYARec = record
                sym, act : Integer;
              end;
     YYRRec = record
                len, sym : Integer;
                symname : String;
              end;
     YYTokenRec = record
                tokenname : String;
              end;

const

yynacts   = 53;
yyngotos  = 10;
yynstates = 29;
yynrules  = 23;
yymaxtoken = 275;

yya : array [1..yynacts] of YYARec = (
{ 0: }
  ( sym: 257; act: 4 ),
  ( sym: 0; act: -3 ),
  ( sym: 59; act: -3 ),
{ 1: }
  ( sym: 58; act: 5 ),
{ 2: }
{ 3: }
  ( sym: 0; act: 0 ),
  ( sym: 59; act: 6 ),
{ 4: }
{ 5: }
  ( sym: 58; act: 9 ),
  ( sym: 257; act: 10 ),
  ( sym: 258; act: 11 ),
  ( sym: 259; act: 12 ),
  ( sym: 263; act: 13 ),
  ( sym: 264; act: 14 ),
  ( sym: 265; act: 15 ),
  ( sym: 266; act: 16 ),
  ( sym: 267; act: 17 ),
  ( sym: 268; act: 18 ),
  ( sym: 272; act: 19 ),
  ( sym: 273; act: 20 ),
  ( sym: 274; act: 21 ),
  ( sym: 275; act: 22 ),
{ 6: }
  ( sym: 257; act: 4 ),
  ( sym: 0; act: -3 ),
  ( sym: 59; act: -3 ),
{ 7: }
{ 8: }
{ 9: }
{ 10: }
{ 11: }
{ 12: }
{ 13: }
{ 14: }
{ 15: }
{ 16: }
{ 17: }
{ 18: }
{ 19: }
  ( sym: 58; act: 9 ),
  ( sym: 257; act: 10 ),
  ( sym: 259; act: 12 ),
  ( sym: 263; act: 13 ),
  ( sym: 264; act: 14 ),
  ( sym: 265; act: 15 ),
  ( sym: 266; act: 16 ),
  ( sym: 267; act: 17 ),
  ( sym: 268; act: 18 ),
  ( sym: 272; act: 19 ),
  ( sym: 273; act: 20 ),
  ( sym: 274; act: 21 ),
  ( sym: 275; act: 22 ),
  ( sym: 41; act: -21 ),
  ( sym: 44; act: -21 ),
{ 20: }
{ 21: }
{ 22: }
{ 23: }
{ 24: }
  ( sym: 41; act: 26 ),
  ( sym: 44; act: 27 ),
{ 25: }
{ 26: }
{ 27: }
  ( sym: 58; act: 9 ),
  ( sym: 257; act: 10 ),
  ( sym: 259; act: 12 ),
  ( sym: 263; act: 13 ),
  ( sym: 264; act: 14 ),
  ( sym: 265; act: 15 ),
  ( sym: 266; act: 16 ),
  ( sym: 267; act: 17 ),
  ( sym: 268; act: 18 ),
  ( sym: 272; act: 19 ),
  ( sym: 273; act: 20 ),
  ( sym: 274; act: 21 ),
  ( sym: 275; act: 22 )
{ 28: }
);

yyg : array [1..yyngotos] of YYARec = (
{ 0: }
  ( sym: -4; act: 1 ),
  ( sym: -3; act: 2 ),
  ( sym: -2; act: 3 ),
{ 1: }
{ 2: }
{ 3: }
{ 4: }
{ 5: }
  ( sym: -6; act: 7 ),
  ( sym: -5; act: 8 ),
{ 6: }
  ( sym: -4; act: 1 ),
  ( sym: -3; act: 23 ),
{ 7: }
{ 8: }
{ 9: }
{ 10: }
{ 11: }
{ 12: }
{ 13: }
{ 14: }
{ 15: }
{ 16: }
{ 17: }
{ 18: }
{ 19: }
  ( sym: -7; act: 24 ),
  ( sym: -6; act: 25 ),
{ 20: }
{ 21: }
{ 22: }
{ 23: }
{ 24: }
{ 25: }
{ 26: }
{ 27: }
  ( sym: -6; act: 28 )
{ 28: }
);

yyd : array [0..yynstates-1] of Integer = (
{ 0: } 0,
{ 1: } 0,
{ 2: } -1,
{ 3: } 0,
{ 4: } -5,
{ 5: } 0,
{ 6: } 0,
{ 7: } -6,
{ 8: } -4,
{ 9: } -20,
{ 10: } -8,
{ 11: } -7,
{ 12: } -12,
{ 13: } -15,
{ 14: } -9,
{ 15: } -10,
{ 16: } -11,
{ 17: } -14,
{ 18: } -16,
{ 19: } 0,
{ 20: } -17,
{ 21: } -18,
{ 22: } -13,
{ 23: } -2,
{ 24: } 0,
{ 25: } -22,
{ 26: } -19,
{ 27: } 0,
{ 28: } -23
);

yyal : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 4,
{ 2: } 5,
{ 3: } 5,
{ 4: } 7,
{ 5: } 7,
{ 6: } 21,
{ 7: } 24,
{ 8: } 24,
{ 9: } 24,
{ 10: } 24,
{ 11: } 24,
{ 12: } 24,
{ 13: } 24,
{ 14: } 24,
{ 15: } 24,
{ 16: } 24,
{ 17: } 24,
{ 18: } 24,
{ 19: } 24,
{ 20: } 39,
{ 21: } 39,
{ 22: } 39,
{ 23: } 39,
{ 24: } 39,
{ 25: } 41,
{ 26: } 41,
{ 27: } 41,
{ 28: } 54
);

yyah : array [0..yynstates-1] of Integer = (
{ 0: } 3,
{ 1: } 4,
{ 2: } 4,
{ 3: } 6,
{ 4: } 6,
{ 5: } 20,
{ 6: } 23,
{ 7: } 23,
{ 8: } 23,
{ 9: } 23,
{ 10: } 23,
{ 11: } 23,
{ 12: } 23,
{ 13: } 23,
{ 14: } 23,
{ 15: } 23,
{ 16: } 23,
{ 17: } 23,
{ 18: } 23,
{ 19: } 38,
{ 20: } 38,
{ 21: } 38,
{ 22: } 38,
{ 23: } 38,
{ 24: } 40,
{ 25: } 40,
{ 26: } 40,
{ 27: } 53,
{ 28: } 53
);

yygl : array [0..yynstates-1] of Integer = (
{ 0: } 1,
{ 1: } 4,
{ 2: } 4,
{ 3: } 4,
{ 4: } 4,
{ 5: } 4,
{ 6: } 6,
{ 7: } 8,
{ 8: } 8,
{ 9: } 8,
{ 10: } 8,
{ 11: } 8,
{ 12: } 8,
{ 13: } 8,
{ 14: } 8,
{ 15: } 8,
{ 16: } 8,
{ 17: } 8,
{ 18: } 8,
{ 19: } 8,
{ 20: } 10,
{ 21: } 10,
{ 22: } 10,
{ 23: } 10,
{ 24: } 10,
{ 25: } 10,
{ 26: } 10,
{ 27: } 10,
{ 28: } 11
);

yygh : array [0..yynstates-1] of Integer = (
{ 0: } 3,
{ 1: } 3,
{ 2: } 3,
{ 3: } 3,
{ 4: } 3,
{ 5: } 5,
{ 6: } 7,
{ 7: } 7,
{ 8: } 7,
{ 9: } 7,
{ 10: } 7,
{ 11: } 7,
{ 12: } 7,
{ 13: } 7,
{ 14: } 7,
{ 15: } 7,
{ 16: } 7,
{ 17: } 7,
{ 18: } 7,
{ 19: } 9,
{ 20: } 9,
{ 21: } 9,
{ 22: } 9,
{ 23: } 9,
{ 24: } 9,
{ 25: } 9,
{ 26: } 9,
{ 27: } 10,
{ 28: } 10
);

yyr : array [1..yynrules] of YYRRec = (
{ 1: } ( len: 1; sym: -2; symname: 'declarationlist' ),
{ 2: } ( len: 3; sym: -2; symname: 'declarationlist' ),
{ 3: } ( len: 0; sym: -3; symname: 'declaration' ),
{ 4: } ( len: 3; sym: -3; symname: 'declaration' ),
{ 5: } ( len: 1; sym: -4; symname: 'property' ),
{ 6: } ( len: 1; sym: -5; symname: 'value' ),
{ 7: } ( len: 1; sym: -5; symname: 'value' ),
{ 8: } ( len: 1; sym: -6; symname: 'any' ),
{ 9: } ( len: 1; sym: -6; symname: 'any' ),
{ 10: } ( len: 1; sym: -6; symname: 'any' ),
{ 11: } ( len: 1; sym: -6; symname: 'any' ),
{ 12: } ( len: 1; sym: -6; symname: 'any' ),
{ 13: } ( len: 1; sym: -6; symname: 'any' ),
{ 14: } ( len: 1; sym: -6; symname: 'any' ),
{ 15: } ( len: 1; sym: -6; symname: 'any' ),
{ 16: } ( len: 1; sym: -6; symname: 'any' ),
{ 17: } ( len: 1; sym: -6; symname: 'any' ),
{ 18: } ( len: 1; sym: -6; symname: 'any' ),
{ 19: } ( len: 3; sym: -6; symname: 'any' ),
{ 20: } ( len: 1; sym: -6; symname: 'any' ),
{ 21: } ( len: 0; sym: -7; symname: 'paramlist' ),
{ 22: } ( len: 1; sym: -7; symname: 'paramlist' ),
{ 23: } ( len: 3; sym: -7; symname: 'paramlist' )
);

yytokens : array [256..yymaxtoken] of YYTokenRec = (
{ 256: } ( tokenname: 'error' ),
{ 257: } ( tokenname: 'IDENT' ),
{ 258: } ( tokenname: 'ATKEYWORD' ),
{ 259: } ( tokenname: 'STRING_' ),
{ 260: } ( tokenname: 'BAD_STRING' ),
{ 261: } ( tokenname: 'BAD_URI' ),
{ 262: } ( tokenname: 'BAD_COMMENT' ),
{ 263: } ( tokenname: 'HASH' ),
{ 264: } ( tokenname: 'NUMBER' ),
{ 265: } ( tokenname: 'PERCENTAGE' ),
{ 266: } ( tokenname: 'DIMENSION' ),
{ 267: } ( tokenname: 'URI' ),
{ 268: } ( tokenname: 'UNICODE_RANGE' ),
{ 269: } ( tokenname: 'CDO' ),
{ 270: } ( tokenname: 'CDC' ),
{ 271: } ( tokenname: 'COMMENT' ),
{ 272: } ( tokenname: 'FUNCTION_' ),
{ 273: } ( tokenname: 'INCLUDES' ),
{ 274: } ( tokenname: 'DASHMATCH' ),
{ 275: } ( tokenname: 'DELIM' )
);

// source: yyparse.cod line# 59

const _error = 256; (* error token *)

function yyact(state, sym : Integer; var act : Integer) : Boolean;
  (* search action table *)
  var k : Integer;
  begin
    k := yyal[state];
    while (k<=yyah[state]) and (yya[k].sym<>sym) do inc(k);
    if k>yyah[state] then
      yyact := false
    else
      begin
        act := yya[k].act;
        yyact := true;
      end;
  end(*yyact*);

function yygoto(state, sym : Integer; var nstate : Integer) : Boolean;
  (* search goto table *)
  var k : Integer;
  begin
    k := yygl[state];
    while (k<=yygh[state]) and (yyg[k].sym<>sym) do inc(k);
    if k>yygh[state] then
      yygoto := false
    else
      begin
        nstate := yyg[k].act;
        yygoto := true;
      end;
  end(*yygoto*);

function yycharsym(i : Integer) : String;
begin
  if (i >= 1) and (i <= 255) then
    begin
      if i < 32 then
        begin
          if i = 9 then
            Result := #39'\t'#39
          else if i = 10 then
            Result := #39'\f'#39
          else if i = 13 then
            Result := #39'\n'#39
          else
            Result := #39'\0x' + IntToHex(i,2) + #39;
        end
      else
        Result := #39 + Char(i) + #39;
      Result := ' literal ' + Result;
    end
  else
    begin
      if i < -1 then
        Result := ' unknown'
      else if i = -1 then
        Result := ' token $accept'
      else if i = 0 then
        Result := ' token $eof'
      else if i = 256 then
        Result := ' token $error'
{$ifdef yyextradebug}
      else if i <= yymaxtoken then
        Result := ' token ' + yytokens[yychar].tokenname
      else
        Result := ' unknown token';
{$else}
      else
        Result := ' token';
{$endif}
    end;
  Result := Result + ' ' + IntToStr(yychar);
end;

label parse, next, error, errlab, shift, reduce, accept, abort;

begin(*yyparse*)

  (* initialize: *)
  sl.Clear;
  lexer := TCSS_Style_Parser_PLEX.Create( _s, nil);
  try

  yystate := 0; yychar := -1; yynerrs := 0; yyerrflag := 0; yysp := 0;

parse:

  (* push state and value: *)

  inc(yysp);
  if yysp>yymaxdepth then
    begin
      raise ECSS_Style_Parser_PYACC_Exception.Create('yyparse stack overflow');
      goto abort;
    end;
  yys[yysp] := yystate; yyv[yysp] := yyval;

next:

  if (yyd[yystate]=0) and (yychar=-1) then
    (* get next symbol *)
    begin
      yychar := lexer.parse(); if yychar<0 then yychar := 0;
    end;

  {$IFDEF YYDEBUG}Log.PrintLn('state '+IntToStr( yystate)+ yycharsym(yychar));{$ENDIF}

  (* determine parse action: *)

  yyn := yyd[yystate];
  if yyn<>0 then goto reduce; (* simple state *)

  (* no default action; search parse table *)

  if not yyact(yystate, yychar, yyn) then goto error
  else if yyn>0 then                      goto shift
  else if yyn<0 then                      goto reduce
  else                                    goto accept;

error:

  (* error; start error recovery: *)

  if yyerrflag=0 then raise ECSS_Style_Parser_PYACC_Exception.Create('syntax error');

errlab:

  if yyerrflag=0 then inc(yynerrs);     (* new error *)

  if yyerrflag<=2 then                  (* incomplete recovery; try again *)
    begin
      yyerrflag := 3;
      (* uncover a state with shift action on error token *)
      while (yysp>0) and not ( yyact(yys[yysp], _error, yyn) and
                               (yyn>0) ) do
        begin
          {$IFDEF YYDEBUG}
            if yysp>1 then
              Log.PrintLn('error recovery pops state '+ IntToStr(yys[yysp])+ ', uncovers '+IntToStr(yys[yysp-1]))
            else
              Log.PrintLn('error recovery fails ... abort');
          {$ENDIF}
          dec(yysp);
        end;
      if yysp=0 then goto abort; (* parser has fallen from stack; abort *)
      yystate := yyn;            (* simulate shift on error *)
      goto parse;
    end
  else                                  (* no shift yet; discard symbol *)
    begin
      {$IFDEF YYDEBUG}Log.PrintLn('error recovery discards ' + yycharsym(yychar));{$ENDIF}
      if yychar=0 then goto abort; (* end of input; abort *)
      yychar := -1; goto next;     (* clear lookahead char and try again *)
    end;

shift:

  (* go to new state, clear lookahead character: *)

  yystate := yyn; yychar := -1; yyval := yylval;
  if yyerrflag>0 then dec(yyerrflag);

  goto parse;

reduce:

  (* execute action, pop rule from stack, and go to next state: *)

  {$IFDEF YYDEBUG}Log.PrintLn('reduce ' + IntToStr(-yyn) {$IFDEF YYEXTRADEBUG} + ' rule ' + yyr[-yyn].symname {$ENDIF});{$ENDIF}

  yyflag := yyfnone; yyaction(-yyn);
  dec(yysp, yyr[-yyn].len);
  if yygoto(yys[yysp], yyr[-yyn].sym, yyn) then yystate := yyn;

  (* handle action calls to yyaccept, yyabort and yyerror: *)

  case yyflag of
    yyfaccept : goto accept;
    yyfabort  : goto abort;
    yyferror  : goto errlab;
  end;

  goto parse;

accept:

  Result := 0; exit;

abort:

  Result := 1; exit;
finally
  lexer.Free;
end;
end(*yyparse*);


{$I uCSS_Style_Parser_PLEX.pas}
(*
block_element   : any | block | ATKEYWORD | ';'
block_element_list : /* empty */ | block_element | block_element block_element_list;
block           : '{' block_element_list '}';
value           : any | block | ATKEYWORD;
any             :
                  | FUNCTION_ any_or_unused_star ')'
                  | '(' any_or_unused_star ')'
                  | '[' any_or_unused_star ']'

any_or_unused_star: /* empty */ | any | unused | any_or_unused_star any_or_unused_star
unused          : block | ATKEYWORD | ';' | CDO | CDC;
*)

end.
