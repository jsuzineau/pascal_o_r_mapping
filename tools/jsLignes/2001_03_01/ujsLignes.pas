unit ujsLignes;

interface

uses
    Classes, SysUtils;

type
    TjsLignes
    =
     class
     public
       Filename: String;
       NnLignes: Integer;
       constructor Create( AFilename: String);
       procedure Traite;
     end;

var
   FinLigne: String= #13#10;

implementation

procedure TjsLignes.Traite;
var
   F: File;
   TailleF: Integer;
   S: String;
   SP: PChar;
   I, LongueurFinLigne: Integer;
begin
     AssignFile( F, FileName);
     FileMode:= 0;
     Reset( F, 1);
     TailleF:= FileSize(F);
     SetLength( S, TailleF+1);
     BlockRead( F, S[1], TailleF);
     CloseFile( F);
     S[ Length(S)]:= #0;
     SP:= @S[1];

     LongueurFinLigne:= Length( FinLigne);
     NnLignes:= 1;
     repeat
           SP:= StrPos( S, FinLigne);
           if Assigned( SP)
           then
               begin
               Inc( NnLignes);
               Inc( SP, LongueurFinLigne);
               end;
     until SP =  nil;
end;

constructor TjsLignes.Create(AFilename: String);
begin
     Filename:= AFilename;
end;

end.
