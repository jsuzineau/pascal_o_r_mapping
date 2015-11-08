unit uhAutomatic_ATB;

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

    uhATB,

 Classes, SysUtils;

type

  { ThAutomatic_ATB }

  ThAutomatic_ATB
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
   //ATB
   public
     hATB: ThATB;
   //Gestion HTTP
   public
     procedure Traite_HTTP;
   end;

function hAutomatic_ATB: ThAutomatic_ATB;

implementation

{ ThAutomatic_ATB }

var
   FhAutomatic_ATB: ThAutomatic_ATB= nil;

function hAutomatic_ATB: ThAutomatic_ATB;
begin
     if nil = FhAutomatic_ATB
     then
         FhAutomatic_ATB:= ThAutomatic_ATB.Create;
     Result:= FhAutomatic_ATB;
end;

constructor ThAutomatic_ATB.Create;
begin
     sl:= TslAutomatic.Create( ClassName+'.sl');

     hATB:= ThATB.Create( sl, poolAutomatic.Tri, poolAutomatic.hf);

     HTTP_Interface.slO.Ajoute( 'Automatic_ATB', Self, Traite_HTTP);
end;

destructor ThAutomatic_ATB.Destroy;
begin
     HTTP_Interface.slO.Enleve( 'Automatic_ATB');
     Free_nil( sl);
     inherited Destroy;
end;

function ThAutomatic_ATB.Execute_SQL( _SQL: String): String;
begin
     hATB.Filtre.Clear;
     hATB.Tri.Reset_ChampsTri;

     poolAutomatic.Charge( _SQL, sl);
     Result:= hATB.JSON;
end;

procedure ThAutomatic_ATB.Traite_HTTP;
begin
     HTTP_Interface.Send_JSON( Execute_SQL( HTTP_Interface.uri));
end;

initialization

finalization
            Free_nil( FhAutomatic_ATB);
end.

