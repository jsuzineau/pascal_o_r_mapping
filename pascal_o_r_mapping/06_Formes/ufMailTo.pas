unit ufMailTo;
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
    uAide,
    uLog,
    uMailTo,
    ufAccueil_Erreur,
    ufpBas,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Menus, Types;

type
 TfMailTo
 =
  class( TfpBas)
    Panel1: TPanel;
    Label3: TLabel;
    mBody: TMemo;
    tShow: TTimer;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    eTo: TEdit;
    eSubject: TEdit;
    Label4: TLabel;
    mPiecesJointes: TMemo;
    bPieceJointe_Ajouter: TButton;
    odPieceJointe: TOpenDialog;
    bPieceJointe_Afficher: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
    procedure bPieceJointe_AjouterClick(Sender: TObject);
    procedure bPieceJointe_AfficherClick(Sender: TObject);
  public
    function Execute( _To, _Subject, _Body: String; _PiecesJointes: TStringDynArray;
                      _Previsualiser: Boolean): Boolean; reintroduce;
  end;

function fMailTo: TfMailTo;

implementation

{$R *.dfm}

var
   FfMailTo: TfMailTo= nil;

function fMailTo: TfMailTo;
begin
     Clean_Get( Result, FfMailTo, TfMailTo);
end;

{ TfMailTo }

procedure TfMailTo.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
end;

function TfMailTo.Execute( _To, _Subject, _Body: String;
                           _PiecesJointes: TStringDynArray;
                           _Previsualiser: Boolean): Boolean;
var
   I: Integer;
   PJ: array of String;
begin
     Log.Print( 'TfMailTo.Execute; début');
     eTo        .Text:= _To     ;
     eSubject   .Text:= _Subject;
     mBody.Lines.Text:= _Body   ;
     mPiecesJointes.Clear;
     if Assigned( _PiecesJointes)
     then
         for I:= Low( _PiecesJointes) to High( _PiecesJointes)
         do
           mPiecesJointes.Lines.Add( _PiecesJointes[I]);

     if _Previsualiser
     then
         Result:= inherited Execute
     else
         Result:= True;

     if Result
     then
         begin
         if '' = eTo.Text
         then
             fAccueil_Erreur( 'Pas de destinataire fourni pour le mail, l''envoi va échouer.');
         SetLength( PJ, mPiecesJointes.Lines.Count);
         for I:= Low( PJ) to High( PJ)
         do
           PJ[I]:= mPiecesJointes.Lines.Strings[I];

         MailTo( '', eTo.Text, eSubject.Text, mBody.Lines.Text, PJ);
         end;
     Log.Print( 'TfMailTo.Execute; fin');
end;

procedure TfMailTo.FormShow(Sender: TObject);
begin
     inherited;
     tShow.Enabled:= True;
end;

procedure TfMailTo.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     eTo.SetFocus;
     eTo.SelectAll;
end;

procedure TfMailTo.bPieceJointe_AjouterClick(Sender: TObject);
begin
     if odPieceJointe.Execute
     then
         mPiecesJointes.Lines.Add( odPieceJointe.FileName);
end;

procedure TfMailTo.bPieceJointe_AfficherClick(Sender: TObject);
var
   I: Integer;
   NomFichier: String;
begin
     for I:= 0 to mPiecesJointes.Lines.Count - 1
     do
       begin
       NomFichier:= mPiecesJointes.Lines.Strings[I];
       ShowURL( NomFichier);
       end;
end;

initialization
finalization
              Clean_Destroy( FfMailTo);
end.
