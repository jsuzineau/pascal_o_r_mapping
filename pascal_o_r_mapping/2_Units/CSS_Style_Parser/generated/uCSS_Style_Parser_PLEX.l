ident 	        [-]?({nmstart})({nmchar})*
name 	        ({nmchar})+
nmstart 	[_a-z]|({nonascii})|({escape})
nonascii	[^\0-\237]
unicode 	\\[0-9a-f]({1,6})(\r\n|[ \n\r\t\f])?
escape 	        ({unicode})|\\[^\n\r\f0-9a-f]
nmchar 	        [_a-z0-9-]|({nonascii})|({escape})
num 	        [0-9]+|[0-9]*\.[0-9]+
string 	        ({string1})|({string2})
string1 	\"([^\n\r\f\\"]|\\({nl})|({escape}))*\"
string2 	\'([^\n\r\f\\']|\\({nl})|({escape}))*\'
badstring 	({badstring1})|({badstring2})
badstring1 	\"([^\n\r\f\\"]|\\({nl})|({escape}))*\\?
badstring2 	\'([^\n\r\f\\']|\\({nl})|({escape}))*\\?
badcomment 	({badcomment1})|({badcomment2})
badcomment1 	\/\*[^*]*\*+([^/*][^*]*\*+)*
badcomment2 	\/\*[^*]*(\*+[^/*][^*]*)*
baduri 	        ({baduri1})|({baduri2})|({baduri3})
baduri1 	url\(({w})([!#$%&*-~]|({nonascii})|({escape}))*({w})
baduri2 	url\(({w})({string})({w})
baduri3 	url\(({w})({badstring})
nl 	        \n|\r\n|\r|\f
w 	        [ \t\r\n\f]*

%start

%%

({ident})                                                                                      begin  yylval.yyString:= yytext; return( IDENT        ); Writeln('IDENT        :',yytext); end;
@({ident})                                                                                     begin  yylval.yyString:= yytext; return( ATKEYWORD    ); Writeln('ATKEYWORD    :',yytext); end;
({string})                                                                                     begin  yylval.yyString:= yytext; return( STRING_      ); Writeln('STRING_      :',yytext); end;
({badstring})                                                                                  begin  yylval.yyString:= yytext; return( BAD_STRING   ); Writeln('BAD_STRING   :',yytext); end;
({baduri})                                                                                     begin  yylval.yyString:= yytext; return( BAD_URI      ); Writeln('BAD_URI      :',yytext); end;
({badcomment})                                                                                 begin  yylval.yyString:= yytext; return( BAD_COMMENT  ); Writeln('BAD_COMMENT  :',yytext); end;
#({name})                                                                                      begin  yylval.yyString:= yytext; return( HASH         ); Writeln('HASH         :',yytext); end;
({num})                                                                                        begin  yylval.yyString:= yytext; return( NUMBER       ); Writeln('NUMBER       :',yytext); end;
({num})%                                                                                       begin  yylval.yyString:= yytext; return( PERCENTAGE   ); Writeln('PERCENTAGE   :',yytext); end;
({num})({ident})                                                                               begin  yylval.yyString:= yytext; return( DIMENSION    ); Writeln('DIMENSION    :',yytext); end;
url\(({w})({string})({w})\)|url\(({w})([!#$%&*-\[\]-~]|({nonascii})|({escape}))*({w})\)        begin  yylval.yyString:= yytext; return( URI          ); Writeln('URI          :',yytext); end;
u\+[0-9a-f?]({1,6})(-[0-9a-f]({1,6}))?                                                         begin  yylval.yyString:= yytext; return( UNICODE_RANGE); Writeln('UNICODE_RANGE:',yytext); end;
\<\!\-\-                                                                                       begin  yylval.yyString:= yytext; return( CDO          ); Writeln('CDO          :',yytext); end;
\-\-\>                                                                                         begin  yylval.yyString:= yytext; return( CDC          ); Writeln('CDC          :',yytext); end;
\:                                                                                             returnc(yytext[1]);
\;                                                                                             returnc(yytext[1]);
\{                                                                                             returnc(yytext[1]);
\}                                                                                             returnc(yytext[1]);
\(                                                                                             returnc(yytext[1]);
\)                                                                                             returnc(yytext[1]);
\[                                                                                             returnc(yytext[1]);
\]                                                                                             returnc(yytext[1]);
[ \t\r\n\f]+                                                                                   ;
\/\*[^*]*\*+([^/*][^*]*\*+)*\/                                                                 begin  yylval.yyString:= yytext; return( COMMENT      ); Writeln('COMMENT      :',yytext); end;
({ident})\(                                                                                    begin  yylval.yyString:= yytext; return( FUNCTION_    ); Writeln('FUNCTION_    :',yytext); end;
~=                                                                                             begin  yylval.yyString:= yytext; return( INCLUDES     ); Writeln('INCLUDES     :',yytext); end;
|=                                                                                             begin  yylval.yyString:= yytext; return( DASHMATCH    ); Writeln('DASHMATCH    :',yytext); end;
