unit uMailTo;
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
    uuStrings,
    uEXE_INI,
    uLog,
    uBatpro_StringList,
    uVersion,
    uNetwork,
    {$IFNDEF FPC}udmSMTP,{$ENDIF}

    udmDatabase,

    ufAccueil_Erreur,
  SysUtils, Classes, uOD_Forms;

function MailTo( _From, _To  , _Subject, _Body: String; _PiecesJointes: array of String): Boolean; overload;
function MailTo( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean; overload;
function MailTo_Batpro( _Subject, _Body: String; _PiecesJointes: array of String): Boolean;

var
   uMailTo_utiliser_SMTP: Boolean = False;

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

function MailTo_SMTP( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
var
   Repertoire, Repertoire_Temp: String;
   Modele, Mail: String;
   I: Integer;
   (*Message   : TIdMessage;
   Attachment: TIdAttachmentFile;
   Recipient: TIdEMailAddressItem;
   *)
   sErreur: String;
   sRecipient: String;
begin
     Repertoire:= IncludeTrailingPathDelimiter( ExtractFilePath( uOD_Forms_EXE_Name));
     Repertoire_Temp:= Repertoire +'temp\';
     ForceDirectories( Repertoire_Temp);
     Modele:= Repertoire +'etc\Modele_MEL.eml';
     (*
     Mail
     :=
        Repertoire_Temp
       +'MEL_'
       +Network.Nom_Hote+'_'
       +FormatDateTime('yyyymmdd"_"hh"h"nn',Now)+'_'
       +dmxG3_UTI_soc+'_'+dmxG3_UTI_ets+'_'+dmxG3_UTI_code_util+'.eml';

     Message:= TIdMessage.Create( nil);


     if     (_From = '')
        and ('EMFA' = UpperCase( dmDatabase.Database))
     then
         _From:= 'FDENIAUD@emfa.fr';

     Message.From.Address:= _From;

     Log.Print( 'MailTo, ajout destinataires');
     case uMailTo_Envoi_Destinataires
     of
       ed_Groupe_en_un_Libelle_Destinataires,
       ed_un_par_ligne_Libelle_vide,
       ed_un_par_ligne_Libelle_adresse:
         for I:= 0 to _To.Count-1
         do
           begin
           sRecipient:= _To.Strings[I];
           Log.Print( sRecipient);
           Recipient:= Message.Recipients.Add;
           Recipient.Address:= sRecipient;
           end;
       end;
     Log.Print( 'MailTo, fin ajout destinataires');

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
        {$IFNDEF FPC}dmSMTP.EnvoiMail( Message);{$ENDIF}
        poolG_TRC.Trace( 'BED', 'Mail envoyé avec succés')
     except
           on E: Exception
           do
             begin
             poolG_TRC.Trace( 'BED', 'Echec Mail, '+E.Message);
             fAccueil_Erreur( 'uMailTo.MailTo_SMTP:'#13#10+E.Message, 'Echec de l''envoi du mail');
             end;
           end;
           *)
end;
(*
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

       Log.Print( 'MailTo, ajout destinataires');
       case uMailTo_Envoi_Destinataires
       of
         ed_Groupe_en_un_Libelle_Destinataires:
           Recipients.Add(AnsiString(_To.Text),AnsiString('Destinataires'));
         ed_un_par_ligne_Libelle_vide:
           for I:= 0 to _To.Count-1
           do
             begin
             sRecipient:= _To.Strings[I];
             Log.Print( sRecipient);
             Recipients.Add( sRecipient);
             end;
         ed_un_par_ligne_Libelle_adresse:
           for I:= 0 to _To.Count-1
           do
             begin
             sRecipient:= _To.Strings[I];
             Log.Print( sRecipient);
             Recipients.Add( sRecipient, sRecipient);
             end;
         end;
       Log.Print( 'MailTo, fin ajout destinataires');

       Subject := AnsiString(_Subject);
       Body := AnsiString(_Body);
       HtmlBody := False;
       for I:= Low(_PiecesJointes) to High( _PiecesJointes)
       do
         Attachments.Add(AnsiString(_PiecesJointes[I]));
       try
          Send(uMailTo_MAPI_Afficher_dialogue{=afficher dialogue});
          poolG_TRC.Trace( 'BED', 'Mail envoyé avec succés');
       except
             on E: EJclMapiError
             do
               begin
               sErreur
               :=
                  'L''envoi du mail a échoué.'#13#10
                 +'Windows a retourné l''erreur suivante '#13#10
                 +E.Message;
               poolG_TRC.Trace( 'BED', 'Echec Mail, '+E.Message);
               fAccueil_Erreur( 'uMailTo.MailTo:'#13#10+sErreur, sErreur);
               end;
             end;
       end;
end;
*)
function MailTo( _From: String; _To: TStrings; _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
begin
(*
if uMailTo_utiliser_SMTP
     then
         Result:= MailTo_SMTP( _From, _To, _Subject, _Body, _PiecesJointes)
     else
         Result:= MailTo_MAPI( _From, _To, _Subject, _Body, _PiecesJointes);
*)
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

function MailTo_Batpro( _Subject, _Body: String; _PiecesJointes: array of String): Boolean;
begin
     Result:= MailTo( '','support@batpro.com', _Subject, _Body, _PiecesJointes);
end;

initialization
              //uMailTo_utiliser_SMTP:= EXE_INI.ReadBool( 'smtp', 'Utiliser pour l''envoi de tous les mails', uMailTo_utiliser_SMTP);
              //uMailTo_MAPI_Afficher_dialogue:= EXE_INI_Poste.ReadBool( 'mapi', inik_uMailTo_MAPI_Afficher_dialogue, uMailTo_MAPI_Afficher_dialogue);
finalization
            //EXE_INI_Poste.WriteBool( 'mapi', inik_uMailTo_MAPI_Afficher_dialogue, uMailTo_MAPI_Afficher_dialogue);
            //EXE_INI.WriteBool( 'smtp', 'Utiliser pour l''envoi de tous les mails', uMailTo_utiliser_SMTP);
            //Free_nil( FJclEmail);
end.



