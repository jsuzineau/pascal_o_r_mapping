program jsWorks;

{$mode objfpc}

uses
 browserconsole, browserapp, JS, Classes, SysUtils, Web;

type
 TMyApplication = class(TBrowserApplication)
  procedure doRun; override;
 end;

{ TblProject }

TblProject
=
 class
   id: Integer;
   Selected: Boolean;
   Name: String;
   constructor Create( _data: JSValue);
   procedure Ecrire;
 end;

{ TslProject }

TslProject
=
 class
   Nom: String;
   JSON_Debut: Integer;
   JSON_Fin  : Integer;
   Count: Integer;
   Elements: array of TblProject;
   constructor Create( _data: JSValue);
   procedure Ecrire;

 end;

{ TblProject }

constructor TblProject.Create( _data: JSValue);
   procedure init_object;
   var
      O: TJSObject;
   begin
        O:= TJSObject( _data);
        id        := Integer(O.Properties['id'      ]);
        Selected  := Boolean(O.Properties['Selected']);
        Name      := String (O.Properties['Name'    ]);
   end;
begin
     init_object;
end;

procedure TblProject.Ecrire;
begin
     Writeln( '  id: ', id);
     Writeln( '  Selected: ', Selected);
     Writeln( '  Name: ', Name);
end;

{ TslProject }

constructor TslProject.Create( _data: JSValue);
   procedure init_asm;
   begin
        asm
           this.Nom= _data.Nom;
           this.JSON_Debut=_data.JSON_Debut;
           this.JSON_Fin=_data.JSON_Fin;
           this.Count=_data.Count;
        end;
   end;
   procedure init_object;
   var
      O: TJSObject;
      A: TJSArray;
      i: Integer;
   begin
        O:= TJSObject( _data);
        Nom       := String  (O.Properties['Nom'       ]);
        JSON_Debut:= Integer (O.Properties['JSON_Debut']);
        JSON_Fin  := Integer (O.Properties['JSON_Fin'  ]);
        Count     := Integer (O.Properties['Count'     ]);
        A         := TJSArray(O.Properties['Elements'  ]);
        SetLength( Elements, A.Length);
        for i:= Low(Elements) to High(Elements)
        do
          Elements[i]:= TblProject.Create( A.Elements[i]);
   end;
begin
     //init_asm;
     init_object;
end;

procedure TslProject.Ecrire;
var
   i: Integer;
begin
     Writeln( 'Nom: ', Nom);
     Writeln( 'JSON_Debut: ', JSON_Debut);
     Writeln( 'JSON_Fin: ', JSON_Fin);
     Writeln( 'Count: ', Count);
     for i:= 0 to Count -1
     do
       begin
       Writeln( 'i=',i);
       Elements[i].Ecrire;
       WriteLn;
       end;
end;

procedure TMyApplication.doRun;
var
   hr:TJSXMLHttpRequest;
begin
     hr:= TJSXMLHttpRequest.new;
     hr.Open('GET', 'Project');
     hr.addEventListener
       (
       'load',
       procedure
       var
          json: String;
          data: JSValue;
          sl: TslProject;
          s: string;
       begin
            //window.fetch();

            json:= hr.responseText;
            data:= TJSJSON.parse( json);
            Writeln( 'data:');
            Writeln( data);
            sl:= TslProject.Create(data);
            sl.Ecrire;
       end
       );
     hr.send;
 Terminate;
end;

var
 Application : TMyApplication;

begin
 Application:=TMyApplication.Create(nil);
 Application.Initialize;
 Application.Run;
 Application.Free;
end.
