unit ucIEdit;
{                 Copyright (c) 1996,1997  Jean SUZINEAU                       }
{$IFNDEF WIN32}{$MACRO ON}{$DEFINE WINDOWS:=LCLLINUX}{$ENDIF}
//2003 10 29: suppression des références à uChain pour insertion
//            dans Batpro_Composants

interface

uses
    Windows,
    Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
    FMX.Dialogs, FMX.StdCtrls;
const
     ucIEdit_MaxInteger=  2147483647;
     ucIEdit_MinInteger= -2147483647;
type
    TIntegerEdit
    =
     class(TEdit)
     private
       { Déclarations privées }
     protected
       { Déclarations protégées }
       FValue: Integer;
       FMin: Integer;
       FMax: Integer;
       FFWidth: Integer;
       FLeadingChar: Char;
       FOnSuperieur, FOnInferieur: TNotifyEvent;
       procedure SetValue( AValue: Integer);
       procedure SetMin( AMin: Integer);
       procedure SetMax( AMax: Integer);
       procedure SetFWidth( AValue: Integer);
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
       property Value: Integer read FValue write SetValue;
       property Min  : Integer read FMin write SetMin default ucIEdit_MinInteger;
       property Max  : Integer read FMax write SetMax default ucIEdit_MaxInteger;
       property NbChiffres : Integer read FFWidth write SetFWidth default 11;
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
     RegisterComponents('Divers', [TIntegerEdit]);
end;

(*
procedure TIntegerEdit.WndProc(var Message: TMessage);
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

constructor TIntegerEdit.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);
     FMin:= ucIEdit_MinInteger;
     FMax:= ucIEdit_MaxInteger;
     FFWidth:= 11;
     FLeadingChar:= ' ';
     FOnInferieur:= NIL;
     FOnSuperieur:= NIL;
end;

procedure TIntegerEdit.SetValue( AValue: Integer);
begin
     FValue:= AValue;
     if RangeOK then RefreshText;
end;

procedure TIntegerEdit.SetMin( AMin: Integer);
begin
     FMin:= AMin;
     RangeOK;
end;
procedure TIntegerEdit.SetMax( AMax: Integer);
begin
     FMax:= AMax;
     RangeOK;
end;

procedure TIntegerEdit.RefreshText;
var
   S: String;
   i: Integer;
begin
     Str( FValue:FFWidth,S);
     for I:= 1 to Length(S) do if S[i]=' ' then S[I]:= LeadingChar;
     Text:= S;
end;

procedure MessageBeep_MB_ICONEXCLAMATION;
begin
     {$IFDEF WIN32}
     MessageBeep( MB_ICONEXCLAMATION);
     {$ELSE}
     WriteLn('ucIEdit.MessageBeep_MB_ICONEXCLAMATION: MessageBeep non implémenté');
     {$ENDIF}
end;

function TIntegerEdit.RangeOK: Boolean;
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

procedure TIntegerEdit.Change;
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
             Val( Text, FValue, Erreur);
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
                 WriteLn( 'ucIEdit.TIntegerEdit.Change: TEdit.SelStart non implémenté dans Lazarus');
                 {$ENDIF}
                 end;
             end;
     inherited Change;
end;

procedure TIntegerEdit.SetFWidth( AValue: Integer);
begin
     FFWidth:= AValue;
     RefreshText;
end;

procedure TIntegerEdit.SetLeadingChar( AValue: Char);
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
