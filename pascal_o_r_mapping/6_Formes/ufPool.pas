unit ufPool;
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

    uPool,

    ufpBas,
    
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, CheckLst, Menus;

type
  TfPool = class(TfpBas)
    clb: TCheckListBox;
    bRecharger: TButton;
    procedure bRechargerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fPool: TfPool;

implementation

{$R *.dfm}

var
   FfPool: TfPool;

function fPool: TfPool;
begin
     Clean_Get( Result, FfPool, TfPool);
end;

{ TfPool }

function TfPool.Execute: Boolean;
var
   I: Integer;
   pool: TPool;
begin
     clb.Clear;
     for I:= 0 to slPool.Count - 1
     do
       begin
       pool:= pool_from_sl( slPool, I);
       if Assigned( pool)
       then
           clb.AddItem( pool.Titre, pool);
       end;

     Result:= inherited Execute;
end;

procedure TfPool.bRechargerClick(Sender: TObject);
var
   I: Integer;
   O: TObject;
   pool: TPool;
begin
     for I:= 0 to clb.Count - 1
     do
       begin
       if clb.Checked[ I]
       then
           begin
           O:= clb.Items.Objects[ I];
           if Assigned( O)
           then
               begin
               pool:= O as TPool;
               pool.Recharger;
               end;
           end;
       end;
end;

initialization
              Clean_Create ( FfPool, TfPool);
finalization
              Clean_Destroy( FfPool);
end.
