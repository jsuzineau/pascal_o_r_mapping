unit ucFEdit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 1996,1997,2014 Jean SUZINEAU - MARS42                             |
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
{$IFNDEF WIN32}{$MACRO ON}{$DEFINE WINDOWS:=LCLLINUX}{$ENDIF}
//2003 10 29: suppression des références à uChain pour insertion
//            dans Batpro_Composants

interface
uses
    Windows,
    Messages, SysUtils, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls;

const
     ucFEdit_MaxExtended =  1.09E4932;

type
    TFloatEdit
    =
     class(TEdit)
     private
       { Déclarations privées }
     protected
       { Déclarations protégées }
       FValue: Extended;
       FMin: Extended;
       FMax: Extended;
       FFWidth, FDecimals: Integer;
       FLeadingChar: Char;
       FOnSuperieur, FOnInferieur: TNotifyEvent;
       procedure SetValue( AValue: Extended);
       procedure SetMin( AMin: Extended);
       procedure SetMax( AMax: Extended);
       procedure SetFWidth( AValue: Integer);
       procedure SetDecimals( AValue: Integer);
       procedure SetLeadingChar( AValue: Char);
       procedure Change; override;
       function RangeOK: Boolean;
       procedure RefreshText;
     public
       { Déclarations publiques }
       constructor Create(AOwner: TComponent); override;
//       procedure WndProc(var Message: TMessage); override;
     published
       { Déclarations publiées }
       property Value: Extended read FValue write SetValue;
       property Min  : Extended read FMin write SetMin;
       property Max  : Extended read FMax write SetMax;
       property NbChiffres: Integer read FFWidth write SetFWidth default 20;
       property Decimales: Integer read FDecimals write SetDecimals default 19;
       property LeadingChar: Char read FLeadingChar write SetLeadingChar default ' ';
       property OnSuperieur: TNotifyEvent read FOnSuperieur write FOnSuperieur;
       property OnInferieur: TNotifyEvent read FOnInferieur write FOnInferieur;
     end;

procedure Register;


implementation

uses
    u_sys_;

procedure Register;
begin
     RegisterComponents('Divers', [TFloatEdit]);
end;

(*
procedure TFloatEdit.WndProc(var Message: TMessage);
begin
     with Message
     do
       case Msg
       of
         WM_ERASEBKGND:
           begin
           end;
         else
           inherited WndProc( Message);
         end;
end;
*)

constructor TFloatEdit.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);
     FMin:= -ucFEdit_MaxExtended;
     FMax:= +ucFEdit_MaxExtended;
     FFWidth:= 20;
     FDecimals:= 19;
     FLeadingChar:= ' ';
     FOnInferieur:= NIL;
     FOnSuperieur:= NIL;
end;

procedure TFloatEdit.SetValue( AValue: Extended);
begin
     FValue:= AValue;
     if RangeOK then RefreshText;
end;

procedure TFloatEdit.SetMin( AMin: Extended);
begin
     FMin:= AMin;
     RangeOK;
end;
procedure TFloatEdit.SetMax( AMax: Extended);
begin
     FMax:= AMax;
     RangeOK;
end;

procedure TFloatEdit.RefreshText;
var
   S: String;
   i: Integer;
begin
     Str( FValue:FFWidth:FDecimals,S);
     for I:= 1 to Length(S) do if S[i]=' ' then S[I]:= LeadingChar;
     Text:= S;
end;

procedure MessageBeep_MB_ICONEXCLAMATION;
begin
     {$IFDEF WIN32}
     MessageBeep( MB_ICONEXCLAMATION);
     {$ELSE}
     WriteLn('ucFEdit.MessageBeep_MB_ICONEXCLAMATION: MessageBeep non implémenté');
     {$ENDIF}
end;

function TFloatEdit.RangeOK: Boolean;
begin
     Result:= False;
     if FValue < FMin
     then
         begin
         FValue:= FMin;
         RefreshText;
         MessageBeep_MB_ICONEXCLAMATION;
         if Assigned(FOnInferieur) then FOnInferieur(Self);
         end
     else
         if FValue > FMax
         then
             begin
             FValue:= FMax;
             RefreshText;
             MessageBeep_MB_ICONEXCLAMATION;
             if Assigned(FOnSuperieur) then FOnSuperieur(Self);
             end
         else
             Result:= True;
end;

procedure TFloatEdit.Change;
var
   Erreur: Integer;
begin
     if Parent <> NIL
     then
         if (Text= sys_Vide) or (Text= '+') or (Text='-')
         then
             FValue:= 0
         else
             begin
             try
                case Text[Length(Text)]
                of
                  '.','E','e': Val( Text+'0', FValue, Erreur);
                  else         Val( Text    , FValue, Erreur);
                  end;
                if Erreur = 0
                then
                    RangeOK
                else
                    begin
                    MessageBeep_MB_ICONEXCLAMATION;
                    {$IFDEF WIN32}
                    SelStart:= Erreur-1;
                    SelLength:= 1;
                    {$ELSE}
                    WriteLn( 'ucFEEdit.TFloatEdit.Change: TEdit.SelStart non implémenté dans Lazarus');
                    {$ENDIF}
                    end;
             except
                   on EOverflow
                   do
                     begin
                     FValue:= FMax;
                     RefreshText;
                     {$IFDEF WIN32}
                     SelStart:= Length(Text);
                     {$ELSE}
                     WriteLn( 'ucFEEdit.TFloatEdit.Change: TEdit.SelStart non implémenté dans Lazarus');
                     {$ENDIF}
                     end;
                   end;
             end;

     inherited Change;
end;

procedure TFloatEdit.SetFWidth( AValue: Integer);
begin
     FFWidth:= AValue;
     RefreshText;
end;

procedure TFloatEdit.SetDecimals( AValue: Integer);
begin
     FDecimals:= AValue;
     RefreshText;
end;

procedure TFloatEdit.SetLeadingChar( AValue: Char);
begin
     if AValue in [' ','0']
     then
         begin
         FLeadingChar:= AValue;
         RefreshText;
         end
     else
         LeadingChar:= '0';
end;

end.
