unit uOOoDelphiReportEngineLog;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2005,2008,2011,2012,2014 Jean SUZINEAU - MARS42                   |
    Copyright 2005,2008,2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO           |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uOD_Temporaire,
  {$IFDEF LINUX}
  baseunix,
  {$ENDIF}
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
     {$IFDEF LINUX}
     FpChmod( NomFichier,    S_IRUSR
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
