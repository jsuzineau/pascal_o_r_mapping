program jsWorks;

{$mode objfpc}

uses
    browserconsole, browserapp, JS, Classes, SysUtils, Web,
    uPAS2JS_utils,
    uBatpro_Ligne,
    ublProject,
    ublWork;

type
    { TMyApplication }

    TMyApplication
    =
     class(TBrowserApplication)
       procedure doRun; override;
     //Project
     private
       blProject: TblProject;
       procedure _from_Project( _bl: TBatpro_Ligne);
     //Work
     private
       blWork: TblWork;
       procedure _from_Work( _bl: TBatpro_Ligne);
       function Work_Change(Event: TEventListenerEvent): boolean;
     end;

procedure TMyApplication.doRun;
begin
     Requete( 'Project', 'tbody_Project', TblProject,@_from_Project);
     Terminate;
end;

procedure TMyApplication._from_Project(_bl: TBatpro_Ligne);
begin
     blProject:= _bl as TblProject;
     //WriteLn( 'Project ', blProject.Name, ' clicked');
     Set_inner_HTML( 'span_Project_Name', blProject.Name);
     Requete( 'Work_from_Project'+IntToStr(blProject.id), 'tbody_Work', TblWork,@_from_Work);
end;

procedure TMyApplication._from_Work(_bl: TBatpro_Ligne);
begin
     blWork:= _bl as TblWork;
     //WriteLn( 'Work ', blWork.id, ' clicked');
     Set_input_value( 'Work_Beginning'  , blWork.Beginning  , @Work_Change);
     Set_input_value( 'Work_End'        , blWork._End       , @Work_Change);
     Set_input_value( 'Work_Description', blWork.Description, @Work_Change);
end;

function TMyApplication.Work_Change(Event: TEventListenerEvent): boolean;
var
   json: String;
begin
     Result:= True;
     if nil = blWork then exit;

     Get_input_value( 'Work_Beginning'  , blWork.Beginning  );
     Get_input_value( 'Work_End'        , blWork._End       );
     Get_input_value( 'Work_Description', blWork.Description);

     json:= TJSJSON.stringify( blWork);
     //WriteLn( 'Work_Change');
     //WriteLn(json);
     Poste( 'Work_Set'+IntToStr( blWork.id), json, TblWork, @_from_Work);
end;

var
   Application : TMyApplication;
begin
     Application:= TMyApplication.Create( nil);
     Application.Initialize;
     Application.Run;
     Application.Free;
end.

TpoolWork.Traite_HTTP: http_Set:
>JSON:
>{"id":1,"Selected":false,"nUser":0,"nProject":1,"Beginning":"2014/09/16 23:44","_End":"2014/09/17 01:00","Description":"test modifiÃ©","Duree":"01:16","Session_Titre":"01:16:","sSession":"01:16:\r\n  test","$events":{}}
>{"id":"1","Selected":"0","nUser":"0","nProject":"1","Beginning":"2014/09/16 23:44","End":"2014/09/17 01:00","Description":"test modifiÃ©","Duree":"01:16","Session_Titre":"01:16:","sSession":"01:16:\r\n  test modifÃ©","Tag_from_Description":{"Nom":"Tag_from_Description","JSON_Debut":-1,"JSON_Fin":-1,"Count":0,"Elements":[]},"Tag":{"Nom":"Tag","JSON_Debut":-1,"JSON_Fin":-1,"Count":0,"Elements":[]}}

