unit uHorloge;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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

interface

uses
    uClean,
    uPublieur,
  SysUtils, Classes,VCL.ExtCtrls;


type
 THorloge
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //attributs
  public
    sHeure: String;
    HeureChange: TPublieur;
  //Timer
  private
    Timer: TTimer;
    procedure TimerTimer(Sender: TObject);
  end;

function Horloge: THorloge;

implementation

var
   FHorloge: THorloge= nil;

function Horloge: THorloge;
begin
     if FHorloge = nil
     then
         FHorloge:= THorloge.Create;
     Result:= FHorloge;
end;

{ THorloge }

constructor THorloge.Create;
begin
     inherited;
     HeureChange:= TPublieur.Create('fHorloge.HeureChange');
     Timer:= TTimer.Create( nil);
     Timer.OnTimer:= TimerTimer;
     Timer.Interval:= 1000;
     Timer.enabled:= True;
end;

destructor THorloge.Destroy;
begin
     Timer.Enabled:= False;
     Free_nil( Timer);
     Free_nil( HeureChange);
     inherited;
end;

procedure THorloge.TimerTimer(Sender: TObject);
var
   Old_uPublieur_Log_Publications: Boolean;
begin
     sHeure:= FormatDateTime( ' tt', Time);
     if Assigned( HeureChange) //Possibilité de passer ici aprés FormDestroy
     then
         begin
         Old_uPublieur_Log_Publications:= uPublieur_Log_Publications;
         try
            uPublieur_Log_Publications:= False;
            HeureChange.Publie;
         finally
                uPublieur_Log_Publications:= Old_uPublieur_Log_Publications;
                end;
         end;
end;

end.
