%{
unit uCSS_Style_Parser_PYACC;

interface

uses
    uBatpro_StringList,
    SysUtils, Classes, yacclib, lexlib, uStreamLexer;



%}

%token <String>IDENT
%token <String>ATKEYWORD
%token <String>STRING_
%token <String>BAD_STRING
%token <String>BAD_URI
%token <String>BAD_COMMENT
%token <String>HASH
%token <String>NUMBER
%token <String>PERCENTAGE
%token <String>DIMENSION
%token <String>URI
%token <String>UNICODE_RANGE
%token <String>CDO
%token <String>CDC
%token <String>COMMENT
%token <String>FUNCTION_
%token <String>INCLUDES
%token <String>DASHMATCH
%token <String>DELIM

%%

declarationlist : declaration
                | declarationlist ';' declaration;

declaration     :   /*empty*/
                  | property ':' value { sl.Values[$<String>1]:= $<String>3; writecallback( $<String>1, $<String>3)};
property        : IDENT;
value           : any | ATKEYWORD;
any             :
                    IDENT
                  | NUMBER
                  | PERCENTAGE
                  | DIMENSION
                  | STRING_
                  | DELIM
                  | URI
                  | HASH
                  | UNICODE_RANGE
                  | INCLUDES
                  | DASHMATCH
                  | ':'
                  ;

%%

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
