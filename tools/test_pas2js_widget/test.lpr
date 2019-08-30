program test; 

{$mode delphi}{$H+}

uses
 Interfaces, Forms, ufTest, uJSChamps;

{$R *.res}

begin
 Application.Initialize;
 Application.CreateForm(TfTest, fTest);
 Application.Run;
end.


{@PAS2JS_BEGIN}
{
 "Compiler" : "/home/jean/01_Projets/17_sources_externes/Pas2JS_Widget/pas2js/linux/pas2js",
 "Output" : "",
 "Template" : "",
 "Browser" : "/usr/bin/firefox",
 "CustomOptions" : [
  "-Jirtl.js",
  "-Tbrowser",
  "-MDelphi",
  "-Jc",
  "-Jminclude",
  "-O1",
  "-l",
  "-vewnhibq",
  "-Fu../../pascal_o_r_mapping/10_Controls_pas2js/runtime",
  "-Fu../../../17_sources_externes/Pas2JS_Widget/pas2js/packages/widget",
  "-Fu../../../17_sources_externes/Pas2JS_Widget/pas2js/packages/rtl",
  "-Fu."
 ]
}
{@PAS2JS_END}

