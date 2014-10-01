unit uBatpro_Dico;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, Classes, ComObj, ActiveX, StdVcl, ComServ, Forms,
  uClean,
  StarUML_TLB,
  suBatpro_Dico_TLB,
  uBatpro_Ligne,
  ublSYSDICO_ENT,
  ublSYSDICO_LIG,
  ublSYSDICO_REL,
  uDataUtilsU,
  uDataUtilsF,
  uWinUtils,
  uVersion,
  ufVersions,
  ufLogin,
  udmDatabase,
  udmxG3_UTI,
  udmBatpro_DataModule,
  uPool,
  udmxEXPORT,
  udmTables,
  upoolSYSDICO_ENT,

  urepTables,
  ufpBas,
  uOOo_SYSDICO_ENT,
  uOOo_SYSDICO_ENT_liste,
  ufDico;

type
 TBatpro_Dico
 =
  class(TAutoObject, IStarUMLAddIn)
  //Gestion du cycle de vie
  public
    procedure Initialize; override;
    destructor Destroy; override;
  // Interface avec StarUML, IStarUMLAddIn
  protected
    function InitializeAddIn: HResult; stdcall;
    function FinalizeAddIn: HResult; stdcall;
    function DoMenuAction(ActionID: Integer): HResult; stdcall;
  //Attributs
  private
  //Méthodes
  public
    procedure Cree;
  end;

implementation

procedure TBatpro_Dico.Initialize;
begin
     inherited;
     fDico.StarUMLApp:= CoStarUMLApplication.Create;
     Application.Handle := fDico.StarUMLApp.Handle;
end;

destructor TBatpro_Dico.Destroy;
begin
     StarUMLApp:= nil;
     inherited;
end;


function TBatpro_Dico.InitializeAddIn: HResult;
begin
     Result := S_OK;
end;

function TBatpro_Dico.FinalizeAddIn: HResult;
begin
     Result := S_OK;
end;

function TBatpro_Dico.DoMenuAction(ActionID: Integer): HResult;
begin
     Result := S_OK;
     case ActionID
     of
       1: fDico.Show;
       2: fDico.bStarUMLClick(nil);
       end;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TBatpro_Dico, Class_Batpro_Dico,
    ciMultiInstance, tmApartment);
  //Clean_Create( fDico, TfDico);
finalization
  //Clean_Destroy( fDico);
end.
