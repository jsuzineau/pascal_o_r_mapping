unit ufBatpro_MySQL;
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
    uMySQL,
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Controls;

type
  TfBatpro_MySQL = class(TForm)
    Label1: TLabel;
    eHostName: TEdit;
    eDatabase: TEdit;
    Label2: TLabel;
    eUser_Name: TEdit;
    Label3: TLabel;
    ePassWord: TEdit;
    Label4: TLabel;
    bOK: TBitBtn;
    bCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure Lire;
    procedure Ecrire;
  public
    { Déclarations publiques }
  end;

function fBatpro_MySQL: TfBatpro_MySQL;

implementation

{$R *.dfm}

var
   FfBatpro_MySQL: TfBatpro_MySQL;

function fBatpro_MySQL: TfBatpro_MySQL;
begin
     Clean_Get( Result, FfBatpro_MySQL, TfBatpro_MySQL);
end;

procedure TfBatpro_MySQL.FormCreate(Sender: TObject);
begin
     inherited;
     Lire;
end;

procedure TfBatpro_MySQL.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

procedure TfBatpro_MySQL.FormShow(Sender: TObject);
begin
     Lire;
end;

procedure TfBatpro_MySQL.Lire;
begin
     eHostName .Text:= MySQL.HostName ;
     eDatabase .Text:= MySQL.DataBase ;
     eUser_Name.Text:= MySQL.User_Name;
     ePassWord .Text:= MySQL.PassWord ;
end;

procedure TfBatpro_MySQL.Ecrire;
begin
     MySQL.HostName := eHostName .Text;
     MySQL.DataBase := eDatabase .Text;
     MySQL.User_Name:= eUser_Name.Text;
     MySQL.PassWord := ePassWord .Text;
end;

procedure TfBatpro_MySQL.bOKClick(Sender: TObject);
begin
     Ecrire;
end;

procedure TfBatpro_MySQL.bCancelClick(Sender: TObject);
begin
     Lire;
end;

initialization
              Clean_CreateD( FfBatpro_MySQL, TfBatpro_MySQL);
finalization
              Clean_Destroy( FfBatpro_MySQL);
end.
