unit uhAutomatic_AUT;

{$mode delphi}

interface

uses
    uClean,
    u_sys_,
    uBatpro_StringList,
    uChampDefinition,
    uChampDefinitions,
    uChamp,
    uChamps,
    uuStrings,
    uTri_Ancetre,
    uhFiltre_Ancetre,
    uRequete,

    uHTTP_Interface,

    udmDatabase,

    uBatpro_Ligne,

    ublAutomatic,
    upoolAutomatic,

    uhAUT,

 Classes, SysUtils;

type

  { ThAutomatic_AUT }

  ThAutomatic_AUT
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //Liste de lignes
   public
      sl: TslAutomatic;
   //Execution du SQL
   public
     function Execute_SQL( _SQL: String): String;
   //AUT
   public
     hAUT: ThAUT;
   //Gestion HTTP
   public
     procedure Traite_HTTP;
   end;

function hAutomatic_AUT: ThAutomatic_AUT;

implementation

{ ThAutomatic_AUT }

var
   FhAutomatic_AUT: ThAutomatic_AUT= nil;

function hAutomatic_AUT: ThAutomatic_AUT;
begin
     if nil = FhAutomatic_AUT
     then
         FhAutomatic_AUT:= ThAutomatic_AUT.Create;
     Result:= FhAutomatic_AUT;
end;

constructor ThAutomatic_AUT.Create;
begin
     sl:= TslAutomatic.Create( ClassName+'.sl');

     hAUT:= ThAUT.Create( sl, poolAutomatic.Tri, poolAutomatic.hf);

     HTTP_Interface.slO.Ajoute( 'Automatic_AUT', Self, Traite_HTTP);
end;

destructor ThAutomatic_AUT.Destroy;
begin
     HTTP_Interface.slO.Enleve( 'Automatic_AUT');
     Free_nil( sl);
     inherited Destroy;
end;

function ThAutomatic_AUT.Execute_SQL( _SQL: String): String;
begin
     hAUT.Filtre.Clear;
     hAUT.Tri.Reset_ChampsTri;

     poolAutomatic.Charge( _SQL, sl);
     Result:= hAUT.JSON;
end;

procedure ThAutomatic_AUT.Traite_HTTP;
begin
     HTTP_Interface.Send_JSON( Execute_SQL( HTTP_Interface.uri));
end;

initialization

finalization
            Free_nil( FhAutomatic_AUT);
end.

