unit ufAttente_Demarrage;
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

interface

uses
    uForms,
    uClean,
    uParametres_Ligne_de_commande,

  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
 TfAttente_Demarrage
 =
  class( TForm)
    lTimer: TLabel;
    bStop: TButton;
    procedure bStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    FenetreCible: HWND;
    function Execute( _NomMailSlot, _Message: String; _wmPret: UINT): Boolean;
  private
    Stop: Boolean;
    wmPret: UINT;
    notPret: Boolean;
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

function fAttente_Demarrage: TfAttente_Demarrage;

implementation

{$R *.lfm}

var
   FfAttente_Demarrage: TfAttente_Demarrage= nil;

function fAttente_Demarrage: TfAttente_Demarrage;
begin
     Clean_Get( Result, FfAttente_Demarrage, TfAttente_Demarrage);
end;

{ TfAttente_Demarrage }

procedure TfAttente_Demarrage.FormCreate(Sender: TObject);
begin
     //FenetreCible:= HWND_BROADCAST;
end;

function TfAttente_Demarrage.Execute( _NomMailSlot, _Message: String; _wmPret: UINT): Boolean;
var
   Temps_en_secondes: Integer;
   procedure Affiche;
   begin
        lTimer.Caption:= IntToStr( Temps_en_secondes);
   end;
begin
     Caption:= _Message;
     Temps_en_secondes:= 0;
     wmPret:= _wmPret;
     Affiche;

     Stop:= False;
     notPret:= True;

     Show;
     Refresh;
     while     (
                   Parametres_Ligne_de_commande.not_MailSlot_existe( _NomMailSlot)
                or notPret
               )
           and (Temps_en_secondes < 30)
     do
       begin
       Sleep( 1000);
       Inc( Temps_en_secondes);
       Affiche;
       uForms_ProcessMessages;
       if Stop then break;
       end;

     Hide;
end;

procedure TfAttente_Demarrage.bStopClick(Sender: TObject);
begin
     Stop:= True;
end;

procedure TfAttente_Demarrage.WndProc(var Message: TMessage);
begin
     inherited;

     if Message.Msg = wmPret
     then
         begin
         notPret:= False;
         with Message
         do
           if WParam <> 0
           then
               FenetreCible:= WParam;
         end;
end;

initialization
              Clean_Create ( FfAttente_Demarrage, TfAttente_Demarrage);
finalization
              Clean_Destroy( FfAttente_Demarrage);
end.
