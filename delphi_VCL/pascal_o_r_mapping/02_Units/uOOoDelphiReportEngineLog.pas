unit uOOoDelphiReportEngineLog;
{                                                                             |
    Part of package pOOoDelphiReportEngine                                    |
                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                          |
            partly as freelance: http://www.mars42.com                        |
        and partly as employee : http://www.batpro.com                        |
    Contact: gilles.doutre@batpro.com                                         |
                                                                              |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                           |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                   |
                                                                              |
    See pOOoDelphiReportEngine.dpk.LICENSE for full copyright notice.         |
|                                                                             }

interface

uses
    uOD_Temporaire,
  SysUtils, Classes;

type
 TOOoDelphiReportEngineLog
 =
  class
  private
    sl: TStringList;
    NomFichier: String;
    procedure Sauve;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Entree( S: String);
  end;

var
   OOoDelphiReportEngineLog: TOOoDelphiReportEngineLog= nil;

implementation

{ TOOoDelphiReportEngineLog }

constructor TOOoDelphiReportEngineLog.Create;
begin
     inherited;
     sl:= TStringList.Create;

     NomFichier:= OD_Temporaire.RepertoireTemp+'pOOoDelphiReportEngine.log.txt';
     if FileExists( NomFichier) then sl.LoadFromFile( NomFichier);
     sl.Add( '##############################################################');
     sl.Add( 'Démarrage: '+FormatDateTime( 'dddddd", "tt', Now));
end;

destructor TOOoDelphiReportEngineLog.Destroy;
begin
     sl.Add( '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
     Sauve;
     FreeAndNil( sl);
     inherited;
end;

procedure TOOoDelphiReportEngineLog.Sauve;
begin
     sl.SaveToFile( NomFichier);
     {$IFDEF FPC}
     FpChmod( Result,    S_IRUSR
                      or S_IWUSR
                      or S_IRGRP
                      or S_IWGRP
                      or S_IROTH
                      or S_IWOTH);
     {$ENDIF}
end;

procedure TOOoDelphiReportEngineLog.Entree( S: String);
begin
     sl.Add( FormatDateTime( 'dddddd", "tt', Now));
     sl.Add( S);
     Sauve;
end;

initialization
              OOoDelphiReportEngineLog:= TOOoDelphiReportEngineLog.Create;
finalization
              FreeAndNil( OOoDelphiReportEngineLog);
end.
