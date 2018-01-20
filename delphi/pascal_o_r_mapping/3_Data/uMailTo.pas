unit uMailTo;
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
    uuStrings,
    uEXE_INI,
    uLog,
    uBatpro_StringList,
    uVersion,
    uNetwork,
    udmSMTP,

    udmDatabase,

    ufAccueil_Erreur,
  FMX.Forms,FMX.Types,
  SysUtils, Classes, ShellAPI, Windows, MAPI, FMX.Dialogs, uOD_Forms,
  {$IFDEF MSWINDOWS}
  JclMapi,
  {$ENDIF}
  IdMessage, IdMessageClient, IdAttachmentFile, IdMessageCoder,
  IdMessageCoderUUE, IdMessageCoderMIME, IdEMailAddress;

function MailTo( _From, _To  , _Subject, _Body: String; _PiecesJointes: array of String): Boolean; overload;
function MailTo( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean; overload;
function MailTo_ADINFO( _Subject, _Body: String; _PiecesJointes: array of String): Boolean;

type
    TaMapiRecipDesc= array[0..0] of TMapiRecipDesc;
    PaMapiRecipDesc= ^TaMapiRecipDesc;

    TaMapiFileDesc= array[0..0] of TMapiFileDesc;
    PaMapiFileDesc= ^TaMapiFileDesc;

var
   uMailTo_utiliser_SMTP: Boolean = False;
// uMailTo_MAPI_Afficher_dialogue
const
     inik_uMailTo_MAPI_Afficher_dialogue= 'Afficher la fenêtre du client de messagerie';
var
   uMailTo_MAPI_Afficher_dialogue: Boolean = False;

// Envoi_Destinataires
type
  TuMailTo_Envoi_Destinataires
  =
   (
   ed_Groupe_en_un_Libelle_Destinataires,
   ed_un_par_ligne_Libelle_vide,
   ed_un_par_ligne_Libelle_adresse
   );
const
   uMailTo_Envoi_Destinataires_Libelles
   :
    array[TuMailTo_Envoi_Destinataires] of String
    =
     (
     'Groupé en un avec libellé Destinataires',
     'Un par ligne avec libellé vide',
     'Un par ligne avec l''adresse e-mail comme libellé'
     );
var
   uMailTo_Envoi_Destinataires
   :
    TuMailTo_Envoi_Destinataires
    =
     ed_un_par_ligne_Libelle_adresse;

implementation

uses IniFiles;

function Escape_HTML( S: String): String;
begin
     Result:= S;

     //conversion des %
     //Result:= StringReplace( Result, '%', '%25', [rfReplaceAll]);

     //conversion des <
     //Result:= StringReplace( Result, '<', '%3C', [rfReplaceAll]);

     //conversion des >
     //Result:= StringReplace( Result, '>', '%3E', [rfReplaceAll]);

     //conversion des sauts de ligne
     // <br> marche avec Netscape
     // (%0D%0A marche avec Outlook en mailto:)
     // on met les 2 pour que çà marche partout
     Result:= StringReplace( Result, #13#10, '<BR>'#13#10, [rfReplaceAll]);

     //conversion des espaces
     //Result:= StringReplace( Result, ' ', '%20', [rfReplaceAll]);

     //conversion des &
     //Result:= StringReplace( Result, '&', '%26', [rfReplaceAll]);

     //conversion des \
     //Result:= StringReplace( Result, '\', '%5C', [rfReplaceAll]);

     //conversion des "
     //Result:= StringReplace( Result, '"', '%22', [rfReplaceAll]);
end;

function LogString_from_RecipClass( _rc: Cardinal): String;
begin
     case _rc
     of
       MAPI_TO  : Result:= 'MAPI_TO  ';
       MAPI_CC  : Result:= 'MAPI_CC  ';
       MAPI_BCC : Result:= 'MAPI_BCC ';
       MAPI_ORIG: Result:= 'MAPI_ORIG';
       else      Result:= 'RecipClass inconnu: $'+IntToHex( _rc,8);
       end;
end;

function LogString_from_MapiRecipDesc( _mrd: TMapiRecipDesc): String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, '      ulReserved  : Cardinal=$'+IntToHex( _mrd.ulReserved, 8)  +' { Reserved for future use                  }'              );
     Formate_Liste( Result, #13#10, '      ulRecipClass: Cardinal='+LogString_from_RecipClass(_mrd.ulRecipClass)+' { Recipient class: MAPI_TO, MAPI_CC, MAPI_BCC, MAPI_ORIG }');
     Formate_Liste( Result, #13#10, '      lpszName    : LPSTR   ='+  StrPas( _mrd.lpszName   )+' { Recipient name                           }'              );
     Formate_Liste( Result, #13#10, '      lpszAddress : LPSTR   ='+  StrPas( _mrd.lpszAddress)+' { Recipient address (optional)             }'              );
     Formate_Liste( Result, #13#10, '      ulEIDSize   : Cardinal='+IntToStr( _mrd.ulEIDSize  )+' { Count in bytes of size of pEntryID       }'              );
     Formate_Liste( Result, #13#10, '      lpEntryID   : Pointer =Pointeur($'+IntToHex( Integer(Pointer(_mrd.lpEntryID)),8)   +') { System-specific recipient reference      }'              );
end;

function LogString_from_MapiFileDesc( _mfd: TMapiFileDesc): String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, '      ulReserved  : Cardinal=$'+IntToHex( _mfd.ulReserved,8)+'        { Reserved for future use (must be 0)     }');
     Formate_Liste( Result, #13#10, '      flFlags     : Cardinal=$'+IntToHex( _mfd.flFlags   ,8)+'           { Flags                                   }');
     Formate_Liste( Result, #13#10, '      nPosition   : Cardinal='+IntToStr( _mfd.nPosition    )+'         { character in text to be replaced by attachment }');
     Formate_Liste( Result, #13#10, '      lpszPathName: LPSTR   ='+  StrPas( _mfd.lpszPathName )+'         { Full path name of attachment file       }');
     Formate_Liste( Result, #13#10, '      lpszFileName: LPSTR   ='+  StrPas( _mfd.lpszFileName )+'         { Original file name (optional)           }');
     Formate_Liste( Result, #13#10, '      lpFileType  : Pointer =Pointeur($'+IntToHex( Integer(Pointer(_mfd.lpFileType  )),8)+')         { Attachment file type (can be lpMapiFileTagExt) }');
end;

function LogString_from_MapiMessage( _mm: TMapiMessage): String;
var
   I: Integer;
   mrd: PaMapiRecipDesc;
   mfd: PaMapiFileDesc;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, '    ulReserved        : Cardinal      = $'+IntToHex( _mm.ulReserved       , 8)+' { Reserved for future use (M.B. 0)       }');
     Formate_Liste( Result, #13#10, '    lpszSubject       : LPSTR         = '+  StrPas( _mm.lpszSubject          )+' { Message Subject                        }');
     Formate_Liste( Result, #13#10, '    lpszNoteText      : LPSTR         = { Message Text }'#13#10+  StrPas( _mm.lpszNoteText         ));
     Formate_Liste( Result, #13#10, '    lpszMessageType   : LPSTR         = '+  StrPas( _mm.lpszMessageType      )+' { Message Class                          }');
     Formate_Liste( Result, #13#10, '    lpszDateReceived  : LPSTR         = '+  StrPas( _mm.lpszDateReceived     )+' { in YYYY/MM/DD HH:MM format             }');
     Formate_Liste( Result, #13#10, '    lpszConversationID: LPSTR         = '+  StrPas( _mm.lpszConversationID   )+' { conversation thread ID                 }');
     Formate_Liste( Result, #13#10, '    flFlags           : FLAGS         = $'+IntToHex( _mm.flFlags          , 8)+' { unread,return receipt                  }');
     Formate_Liste( Result, #13#10, '    lpOriginator      : PMapiRecipDesc= Pointeur($'+IntToHex( Integer(Pointer(_mm.lpOriginator)),8)+') { Originator descriptor                  }');
     if Assigned( _mm.lpOriginator)
     then
         Formate_Liste( Result, #13#10, LogString_from_MapiRecipDesc( _mm.lpOriginator^));
     Formate_Liste( Result, #13#10, '    nRecipCount       : Cardinal      = '+IntToStr( _mm.nRecipCount          )+' { Number of recipients                   }');
     Formate_Liste( Result, #13#10, '    lpRecips          : PMapiRecipDesc= Pointeur($'+IntToHex( Integer(Pointer(_mm.lpRecips    )),8)+') { Recipient descriptors                  }');
     mrd:= PaMapiRecipDesc(_mm.lpRecips);
     if Assigned( mrd)
     then
         for I:= 0 to _mm.nRecipCount-1
         do
           Formate_Liste( Result, #13#10, LogString_from_MapiRecipDesc( mrd[I]));
     Formate_Liste( Result, #13#10, '    nFileCount        : Cardinal      = '+IntToStr( _mm.nFileCount            )+' { # of file attachments                  }');
     Formate_Liste( Result, #13#10, '    lpFiles           : PMapiFileDesc = Pointeur($'+IntToHex( Integer(Pointer(_mm.lpFiles     )),8)+') { Attachment descriptors                 }');
     mfd:= PaMapiFileDesc( _mm.lpFiles);
     if Assigned( mfd)
     then
         for I:= 0 to _mm.nFileCount-1
         do
           Formate_Liste( Result, #13#10, LogString_from_MapiFileDesc( mfd[I]));
end;

function LogString_from_Resultat_MAPISendMail( _r: Cardinal): String;
begin
     case _r
     of
       SUCCESS_SUCCESS                 : Result:= 'SUCCESS_SUCCESS                ';
       MAPI_USER_ABORT                 : Result:= 'MAPI_USER_ABORT / MAPI_E_USER_ABORT';
       MAPI_E_FAILURE                  : Result:= 'MAPI_E_FAILURE                 ';
       MAPI_E_LOGON_FAILURE            : Result:= 'MAPI_E_LOGON_FAILURE / MAPI_E_LOGIN_FAILURE';
       MAPI_E_DISK_FULL                : Result:= 'MAPI_E_DISK_FULL               ';
       MAPI_E_INSUFFICIENT_MEMORY      : Result:= 'MAPI_E_INSUFFICIENT_MEMORY     ';
       MAPI_E_ACCESS_DENIED            : Result:= 'MAPI_E_ACCESS_DENIED           ';
       MAPI_E_TOO_MANY_SESSIONS        : Result:= 'MAPI_E_TOO_MANY_SESSIONS       ';
       MAPI_E_TOO_MANY_FILES           : Result:= 'MAPI_E_TOO_MANY_FILES          ';
       MAPI_E_TOO_MANY_RECIPIENTS      : Result:= 'MAPI_E_TOO_MANY_RECIPIENTS     ';
       MAPI_E_ATTACHMENT_NOT_FOUND     : Result:= 'MAPI_E_ATTACHMENT_NOT_FOUND    ';
       MAPI_E_ATTACHMENT_OPEN_FAILURE  : Result:= 'MAPI_E_ATTACHMENT_OPEN_FAILURE ';
       MAPI_E_ATTACHMENT_WRITE_FAILURE : Result:= 'MAPI_E_ATTACHMENT_WRITE_FAILURE';
       MAPI_E_UNKNOWN_RECIPIENT        : Result:= 'MAPI_E_UNKNOWN_RECIPIENT       ';
       MAPI_E_BAD_RECIPTYPE            : Result:= 'MAPI_E_BAD_RECIPTYPE           ';
       MAPI_E_NO_MESSAGES              : Result:= 'MAPI_E_NO_MESSAGES             ';
       MAPI_E_INVALID_MESSAGE          : Result:= 'MAPI_E_INVALID_MESSAGE         ';
       MAPI_E_TEXT_TOO_LARGE           : Result:= 'MAPI_E_TEXT_TOO_LARGE          ';
       MAPI_E_INVALID_SESSION          : Result:= 'MAPI_E_INVALID_SESSION         ';
       MAPI_E_TYPE_NOT_SUPPORTED       : Result:= 'MAPI_E_TYPE_NOT_SUPPORTED      ';
       MAPI_E_AMBIGUOUS_RECIPIENT      : Result:= 'MAPI_E_AMBIGUOUS_RECIPIENT / MAPI_E_AMBIG_RECIP';
       MAPI_E_MESSAGE_IN_USE           : Result:= 'MAPI_E_MESSAGE_IN_USE          ';
       MAPI_E_NETWORK_FAILURE          : Result:= 'MAPI_E_NETWORK_FAILURE         ';
       MAPI_E_INVALID_EDITFIELDS       : Result:= 'MAPI_E_INVALID_EDITFIELDS      ';
       MAPI_E_INVALID_RECIPS           : Result:= 'MAPI_E_INVALID_RECIPS          ';
       MAPI_E_NOT_SUPPORTED            : Result:= 'MAPI_E_NOT_SUPPORTED           ';
       else                              Result:= 'Resultat_MAPISendMail inconnu: $'+IntToHex( _r,8);
       end;
end;

function uMailTo_MAPISendMail( lhSession: LHANDLE; ulUIParam: Cardinal;
  var lpMessage: TMapiMessage; flFlags: FLAGS; ulReserved: Cardinal): Cardinal;
var
   S: String;
begin
     Result:= MapiSendMail( lhSession, ulUIParam, lpMessage, flFlags, ulReserved);

     S:='';
     Formate_Liste( S, #13#10, 'Appel de MAPISendMail');
     Formate_Liste( S, #13#10, '  lhSession: LHANDLE = $'+IntToHex( lhSession, 8));
     Formate_Liste( S, #13#10, '  ulUIParam: Cardinal= $'+IntToHex( ulUIParam, 8));
     Formate_Liste( S, #13#10, '  lpMessage: TMapiMessage= Pointeur($'+IntToHex( Integer(Pointer(@lpMessage)),8)+')');
     Formate_Liste( S, #13#10, LogString_from_MapiMessage( lpMessage));
     Formate_Liste( S, #13#10, '  flFlags: FLAGS= $'+IntToHex( flFlags, 8));
     Formate_Liste( S, #13#10, '  ulReserved: Cardinal= $'+IntToHex( ulReserved, 8));
     Formate_Liste( S, #13#10, 'Résultat de l''appel à MAPISendMail: '+LogString_from_Resultat_MAPISendMail( Result));

     uLog.Log.Print( S);
     if Result <> SUCCESS_SUCCESS
     then
         begin
         fAccueil_Erreur( 'Echec MapiSendMail:'#13#10+LogString_from_Resultat_MAPISendMail( Result))
         end;
end;


function MailTo_Direct( _From, _To, _Subject, _Body: String; _PiecesJointes: array of String): Boolean; overload;
var
   mrd, mrdFrom: TMapiRecipDesc;
   pFrom: PMapiRecipDesc;
   mm: TMapiMessage;

   NbPiecesJointes: Integer;
   mfd: PaMapiFileDesc;
   iMFD: Integer;
   Mainform_handle: TWindowHandle;
begin
     uLog.Log.Print( 'MailTo; début');

     _Body:= Escape_HTML( _Body);

     NbPiecesJointes:= Length( _PiecesJointes);
     GetMem( mfd, NbPiecesJointes*SizeOf(TMapiFileDesc));
     for iMFD:= Low(_PiecesJointes) to High(_PiecesJointes)
     do
       with mfd^[iMFD]
       do
         begin
         ulReserved:= 0;
         flFlags   := 0;
         nPosition := 0;
         lpszPathName:= PAnsiChar( _PiecesJointes[iMFD]);
         lpszFileName:= nil;
         lpFileType  := nil;
         end;

     if     (_From = '')
        and ('EMFA' = UpperCase( dmDatabase.Database))
     then
         _From:= 'FDENIAUD@emfa.fr';

     uLog.Log.Print( 'MailTo; _From = >'+_From+'<');
     if _From = ''
     then
         pFrom:= nil
     else
         begin
         pFrom:= @mrdFrom;

         mrdFrom.ulReserved  := 0;
         mrdFrom.ulRecipClass:= MAPI_ORIG;
         mrdFrom.lpszName    := PAnsiChar( _From);
         mrdFrom.lpszAddress := PAnsiChar( 'SMTP:'+_From);
         mrdFrom.ulEIDSize   := 0;
         mrdFrom.lpEntryID   := nil;
         end;


     mrd.ulReserved  := 0;
     mrd.ulRecipClass:= MAPI_TO;
     mrd.lpszName    := PAnsiChar( _To);
     mrd.lpszAddress := PAnsiChar( 'SMTP:'+_To);
     mrd.ulEIDSize   := 0;
     mrd.lpEntryID   := nil;


     mm.ulReserved        := 0;
     mm.lpszSubject       := PAnsiChar( _Subject);
     mm.lpszNoteText      := PAnsiChar( _Body   );
     mm.lpszMessageType   := nil;
     mm.lpszDateReceived  := nil;
     mm.lpszConversationID:= nil;
     mm.flFlags           := 0;
     mm.lpOriginator      := pFrom;
     mm.nRecipCount       := 1;
     mm.lpRecips          := @mrd;
     mm.nFileCount        := NbPiecesJointes;
     if NbPiecesJointes = 0
     then
         mm.lpFiles       := nil
     else
         mm.lpFiles       := PMapiFileDesc(mfd);

     uLog.Log.Print( 'MailTo; avant MapiSendMail ');

     Mainform_handle:= nil;
     if Assigned(Application.MainForm)then Mainform_handle:= Application.MainForm.Handle;

     Result
     :=
       SUCCESS_SUCCESS
       =
       uMailTo_MAPISendMail( 0, Trunc(Mainform_handle.Scale), mm, 0, 0);

     uLog.Log.Print( 'MailTo; fin');
end;

function MailTo_Direct( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean; overload;
var
   I: Integer;
   Destinataires: String;
   mrd: array of TMapiRecipDesc;
   mrdFrom: TMapiRecipDesc;
   pFrom: PMapiRecipDesc;
   mm: TMapiMessage;

   NbPiecesJointes: Integer;
   mfd: PaMapiFileDesc;
   iMFD: Integer;

   Mainform_handle: TWindowHandle;
begin
     uLog.Log.Print( 'MailTo; début');

     _Body:= Escape_HTML( _Body);

     NbPiecesJointes:= Length( _PiecesJointes);
     GetMem( mfd, NbPiecesJointes*SizeOf(TMapiFileDesc));
     for iMFD:= Low(_PiecesJointes) to High(_PiecesJointes)
     do
       with mfd^[iMFD]
       do
         begin
         ulReserved:= 0;
         flFlags   := 0;
         nPosition := 0;
         lpszPathName:= PAnsiChar( _PiecesJointes[iMFD]);
         lpszFileName:= nil;
         lpFileType  := nil;
         end;

     if     (_From = '')
        and ('EMFA' = UpperCase( dmDatabase.Database))
     then
         _From:= 'FDENIAUD@emfa.fr';

     uLog.Log.Print( 'MailTo; _From = >'+_From+'<');
     if _From = ''
     then
         pFrom:= nil
     else
         begin
         pFrom:= @mrdFrom;

         mrdFrom.ulReserved  := 0;
         mrdFrom.ulRecipClass:= MAPI_ORIG;
         mrdFrom.lpszName    := PAnsiChar( _From);
         mrdFrom.lpszAddress := PAnsiChar( 'SMTP:'+_From);
         mrdFrom.ulEIDSize   := 0;
         mrdFrom.lpEntryID   := nil;
         end;

     for I:= _To.Count-1 downto 0
     do
       begin
       if Trim(_To[I]) = '' then _To.Delete(I);
       end;
     //SetLength( mrd, _To.Count);
     //for I:= 0 to _To.Count-1
     //do
     //  begin
     //  mrd[I].ulReserved  := 0;
     //  mrd[I].ulRecipClass:= MAPI_TO;
     //  mrd[I].lpszName    := '';//PAnsiChar( _To[I]);
     //  mrd[I].lpszAddress := PAnsiChar( 'SMTP:'+_To[I]+';');
     //  mrd[I].ulEIDSize   := 0;
     //  mrd[I].lpEntryID   := nil;
     //  end;
     Destinataires:= '';
     for I:= 0 to _To.Count-1
     do
       Formate_Liste( Destinataires, ',', _To[I]);

     SetLength( mrd, 1);
     mrd[0].ulReserved  := 0;
     mrd[0].ulRecipClass:= MAPI_TO;
     mrd[0].lpszName    := 'Plusieurs destinataires';//PAnsiChar( _To[I]);
     mrd[0].lpszAddress := PAnsiChar( 'SMTP:'+Destinataires);
     mrd[0].ulEIDSize   := 0;
     mrd[0].lpEntryID   := nil;


     mm.ulReserved        := 0;
     mm.lpszSubject       := PAnsiChar( _Subject);
     mm.lpszNoteText      := PAnsiChar( _Body   );
     mm.lpszMessageType   := nil;
     mm.lpszDateReceived  := nil;
     mm.lpszConversationID:= nil;
     mm.flFlags           := 0;//MAPI_DIALOG;
     mm.lpOriginator      := pFrom;
     mm.nRecipCount       := _To.Count;
     mm.lpRecips          := @mrd[0];
     mm.nFileCount        := NbPiecesJointes;
     if NbPiecesJointes = 0
     then
         mm.lpFiles       := nil
     else
         mm.lpFiles       := PMapiFileDesc(mfd);

     uLog.Log.Print( 'MailTo; avant MapiSendMail ');
     Mainform_handle:= nil;
     if Assigned(Application.MainForm)then Mainform_handle:= Application.MainForm.Handle;

     Result
     :=
       SUCCESS_SUCCESS
       =
       uMailTo_MAPISendMail( 0, Trunc(Mainform_handle.Scale), mm, 0, 0);
     uLog.Log.Print( 'MailTo; fin');
end;

function MailTo_SMTP( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
var
   Repertoire, Repertoire_Temp: String;
   Modele, Mail: String;
   I: Integer;
   Message   : TIdMessage;
   Attachment: TIdAttachmentFile;
   Recipient: TIdEMailAddressItem;
   sErreur: String;
   sRecipient: String;
begin
     Repertoire:= IncludeTrailingPathDelimiter( ExtractFilePath( uOD_Forms_EXE_Name));
     Repertoire_Temp:= Repertoire +'temp\';
     ForceDirectories( Repertoire_Temp);
     Modele:= Repertoire +'etc\Modele_MEL.eml';
     Mail
     :=
        Repertoire_Temp
       +'MEL_'
       +Network.Nom_Hote+'_'
       +FormatDateTime('yyyymmdd"_"hh"h"nn',Now)+'.eml';

     Message:= TIdMessage.Create( nil);

     //if FileExists( Modele)
     //then
     //    begin
     //    Message.LoadFromFile( Modele);
     //    Message.ContentType:= '';
     //    end
     //else
     //    begin
     //    Message.Sender.Name   := 'Batpro_Editions';
     //    Message.Sender.Address:= 'gilles.doutre@batpro.com';
     //    Message.From.Name   := 'Batpro_Editions';
     //    Message.From.Address:= 'gilles.doutre@batpro.com';
     //    Message.Body.Text:= 'Test envoi MEL';
     //    Message.Recipients.EMailAddresses:= 'support@batpro.com';
     //    Message.SaveToFile( Modele);
     //    end;

     Message.From.Address:= _From;

     uLog.Log.Print( 'MailTo, ajout destinataires');
     case uMailTo_Envoi_Destinataires
     of
       ed_Groupe_en_un_Libelle_Destinataires,
       ed_un_par_ligne_Libelle_vide,
       ed_un_par_ligne_Libelle_adresse:
         for I:= 0 to _To.Count-1
         do
           begin
           sRecipient:= _To.Strings[I];
           uLog.Log.Print( sRecipient);
           Recipient:= Message.Recipients.Add;
           Recipient.Address:= sRecipient;
           end;
       end;
     uLog.Log.Print( 'MailTo, fin ajout destinataires');

     Message.ContentType:= '';
     Message.Subject  := _Subject;
     Message.Body.Text:= _Body;

     for I:= Low(_PiecesJointes) to High( _PiecesJointes)
     do
       begin
       Attachment:= TIdAttachmentFile.Create( Message.MessageParts, _PiecesJointes[I]);
       end;

     Message.SaveToFile( Mail);

     try
        dmSMTP.EnvoiMail( Message);
     except
           on E: Exception
           do
             begin
             fAccueil_Erreur( 'uMailTo.MailTo_SMTP:'#13#10+E.Message, 'Echec de l''envoi du mail');
             end;
           end;
end;

{$IFDEF MSWINDOWS}
var
   FJclEmail: TJclEmail= nil;

function JclEmail: TJclEmail;
begin
     if FJclEmail = nil
     then
         FJclEmail:= TJclEmail.Create;
     Result:= FJclEmail;
end;

function MailTo_MAPI( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
var
   I: Integer;
   sErreur: String;
   sRecipient: String;
begin
     with JclEmail
     do
       begin
       Clear;

       if     (_From = '')
          and ('EMFA' = UpperCase( dmDatabase.Database))
       then
           _From:= 'FDENIAUD@emfa.fr';

       //pas de champ où mettre le _From ?

       uLog.Log.Print( 'MailTo, ajout destinataires');
       case uMailTo_Envoi_Destinataires
       of
         ed_Groupe_en_un_Libelle_Destinataires:
           Recipients.Add(AnsiString(_To.Text),AnsiString('Destinataires'));
         ed_un_par_ligne_Libelle_vide:
           for I:= 0 to _To.Count-1
           do
             begin
             sRecipient:= _To.Strings[I];
             uLog.Log.Print( sRecipient);
             Recipients.Add( sRecipient);
             end;
         ed_un_par_ligne_Libelle_adresse:
           for I:= 0 to _To.Count-1
           do
             begin
             sRecipient:= _To.Strings[I];
             uLog.Log.Print( sRecipient);
             Recipients.Add( sRecipient, sRecipient);
             end;
         end;
       uLog.Log.Print( 'MailTo, fin ajout destinataires');

       Subject := AnsiString(_Subject);
       Body := AnsiString(_Body);
       HtmlBody := False;
       for I:= Low(_PiecesJointes) to High( _PiecesJointes)
       do
         Attachments.Add(AnsiString(_PiecesJointes[I]));
       try
          Send(uMailTo_MAPI_Afficher_dialogue{=afficher dialogue});
       except
             on E: EJclMapiError
             do
               begin
               sErreur
               :=
                  'L''envoi du mail a échoué.'#13#10
                 +'Windows a retourné l''erreur suivante '#13#10
                 +E.Message;
               fAccueil_Erreur( 'uMailTo.MailTo:'#13#10+sErreur, sErreur);
               end;
             end;
       end;
end;
{$ENDIF}
function MailTo( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
begin
     {$IFDEF MSWINDOWS}
     if uMailTo_utiliser_SMTP
     then
     {$ENDIF}
         Result:= MailTo_SMTP( _From, _To, _Subject, _Body, _PiecesJointes)
     {$IFDEF MSWINDOWS}
     else
         Result:= MailTo_MAPI( _From, _To, _Subject, _Body, _PiecesJointes)
     {$ENDIF}
         ;
end;


function MailTo( _From, _To  , _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
var
   sl: TStringList;
begin
     Result:= False;
     sl:= TStringList.Create;
     try
        sl.Text:= _To;
        Result:= MailTo( _From, sl, _Subject, _Body, _PiecesJointes);
     finally
            Free_nil( sl);
            end;
end;

function MailTo_ADINFO( _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
begin
     Result:= MailTo( '','assistance.gas@groupeadinfo.com', _Subject, _Body, _PiecesJointes);
end;

initialization
              uMailTo_utiliser_SMTP:= EXE_INI.ReadBool( 'smtp', 'Utiliser pour l''envoi de tous les mails', uMailTo_utiliser_SMTP);
              uMailTo_MAPI_Afficher_dialogue:= EXE_INI_Poste.ReadBool( 'mapi', inik_uMailTo_MAPI_Afficher_dialogue, uMailTo_MAPI_Afficher_dialogue);
finalization
            EXE_INI_Poste.WriteBool( 'mapi', inik_uMailTo_MAPI_Afficher_dialogue, uMailTo_MAPI_Afficher_dialogue);
            EXE_INI.WriteBool( 'smtp', 'Utiliser pour l''envoi de tous les mails', uMailTo_utiliser_SMTP);
            {$IFDEF MSWINDOWS}
            Free_nil( FJclEmail);
            {$ENDIF}
end.



