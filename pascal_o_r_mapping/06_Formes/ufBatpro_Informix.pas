unit ufBatpro_Informix;
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
    uClean,
    uSGBD,
    uInformix,
    udmDatabase,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
 TfBatpro_Informix
 =
  class(TForm)
    Label1: TLabel;
    eHostName: TEdit;
    eDatabase: TEdit;
    Label2: TLabel;
    eUser_Name: TEdit;
    Label3: TLabel;
    ePassWord: TEdit;
    Label4: TLabel;
    bCancel: TBitBtn;
    bOK: TBitBtn;
    Label5: TLabel;
    bDBPing: TButton;
    bSetNet32: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure bDBPingClick(Sender: TObject);
    procedure bSetNet32Click(Sender: TObject);
  private
    { Déclarations privées }
    Informix: TInformix;
    procedure Lire;
    procedure Ecrire;
  public
    { Déclarations publiques }
  end;

function fBatpro_Informix: TfBatpro_Informix;

implementation

{$R *.dfm}

var
   FfBatpro_Informix: TfBatpro_Informix;

function fBatpro_Informix: TfBatpro_Informix;
begin
     Clean_Get( Result, FfBatpro_Informix, TfBatpro_Informix);
end;

procedure TfBatpro_Informix.FormCreate(Sender: TObject);
begin
     inherited;
     if sgbdINFORMIX
     then
         Informix:= dmDatabase.jsDataConnexion as TInformix
     else
         Informix:= nil;
     Lire;
end;

procedure TfBatpro_Informix.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

procedure TfBatpro_Informix.Lire;
begin
     eHostName .Text:= Informix.HostName ;
     eDatabase .Text:= Informix.DataBase ;
     eUser_Name.Text:= Informix.User_Name;
     ePassWord .Text:= Informix.PassWord ;
end;

procedure TfBatpro_Informix.Ecrire;
begin
     Informix.HostName := eHostName .Text;
     Informix.DataBase := eDatabase .Text;
     Informix.User_Name:= eUser_Name.Text;
     Informix.PassWord := ePassWord .Text;
     Informix.Ecrire;
end;

procedure TfBatpro_Informix.bOKClick(Sender: TObject);
begin
     Ecrire;
end;

procedure TfBatpro_Informix.bCancelClick(Sender: TObject);
begin
     Lire;
end;

procedure TfBatpro_Informix.bSetNet32Click(Sender: TObject);
begin
     Informix.SetNet32;
end;

procedure TfBatpro_Informix.bDBPingClick(Sender: TObject);
begin
     Informix.DBPing;
end;

initialization
              Clean_CreateD( FfBatpro_Informix, TfBatpro_Informix);
finalization
              Clean_Destroy( FfBatpro_Informix);
end.
