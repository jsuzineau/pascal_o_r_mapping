unit uParametres_Ligne_de_commande;
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
    uuStrings,
    uBatpro_StringList,
    {$IFNDEF FPC}
    uWinUtils,
    {$ENDIF}
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  SysUtils, Classes;

var
   Linux: Boolean= False;
var
   ModeDEBUG: Integer= 0;
   ModeDEBUG_1:Boolean = False;
   ModeDEBUG_2:Boolean = False;
   ModeDEBUG_3:Boolean = False;
var
   ModeAUTOEXEC: Boolean = False;
   autoexec_SGBD     : String= '';
   autoexec_Database : String= '';
   autoexec_SOC      : String= '';
   autoexec_ETS      : String= '';
   autoexec_SOCETS   : String= '';
   autoexec_CODE_UTIL: String= '';
   autoexec_Fonction : String= '';
   Parametre1        : String= '';
   Parametre2        : String= '';
   Parametre3        : String= '';
   Parametre4        : String= '';
   Parametre5        : String= '';
   Parametre6        : String= '';
	 Parametre7        : String= '';
var
   ModeHELP_CREATOR: Boolean = False;

type
 TParametres_Ligne_de_commande
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Gestion de l'initialisation
  private
    function Decode_Parametres( code: String): String;
  public
    procedure Initialize;
  //Méthodes
  private
    procedure To_StringList;
    procedure From_StringList;
  {$IFNDEF FPC}
  public
    function To_Atom: ATOM;
    procedure From_Atom( _Atom: ATOM);
  {$ENDIF}
  //Nom utilisateur
  public
    function NomUtilisateur: String;
  //MailSlot server
  private
    hMailSlot: THandle;
    procedure Cree_MailSlot;
    procedure Ferme_MailSlot;
  public
    Actif: Boolean;
    NomMailSlot: String;
    function From_MailSlot: Boolean;
  //MailSlot Client
  public
    function not_MailSlot_existe( _NomMailSlot: String): Boolean;
    procedure To_MailSlot( _NomMailSlot: String);
  //Pour gestion du FrontCall depuis le GDC
  public
    procedure From_Chaine( _Parametres: String);
  //Affichage des paramètres sur une ligne
  public
    function Ligne: String;
  end;

var
   Parametres_Ligne_de_commande: TParametres_Ligne_de_commande= nil;

implementation

{ TParametres_Ligne_de_commande }

constructor TParametres_Ligne_de_commande.Create( _Nom: String= '');
begin
     inherited;
     Actif:= False;
     Cree_MailSlot;
end;

destructor TParametres_Ligne_de_commande.Destroy;
begin
     Ferme_MailSlot;
     inherited;
end;

procedure TParametres_Ligne_de_commande.To_StringList;
begin
     Values['autoexec_SGBD'     ]:= autoexec_SGBD     ;
     Values['autoexec_Database' ]:= autoexec_Database ;
     Values['autoexec_SOC'      ]:= autoexec_SOC      ;
     Values['autoexec_ETS'      ]:= autoexec_ETS      ;
     Values['autoexec_SOCETS'   ]:= autoexec_SOCETS   ;
     Values['autoexec_CODE_UTIL']:= autoexec_CODE_UTIL;
     Values['autoexec_Fonction' ]:= autoexec_Fonction ;
     Values['Parametre1'        ]:= Parametre1        ;
     Values['Parametre2'        ]:= Parametre2        ;
     Values['Parametre3'        ]:= Parametre3        ;
     Values['Parametre4'        ]:= Parametre4        ;
     Values['Parametre5'        ]:= Parametre5        ;
     Values['Parametre6'        ]:= Parametre6        ;
     Values['Parametre7'        ]:= Parametre7        ;
end;

procedure TParametres_Ligne_de_commande.From_StringList;
begin
     ModeAUTOEXEC      := True;
     autoexec_SGBD     := Values['autoexec_SGBD'     ];
     autoexec_Database := Values['autoexec_Database' ];
     autoexec_SOC      := Values['autoexec_SOC'      ];
     autoexec_ETS      := Values['autoexec_ETS'      ];
     autoexec_SOCETS   := Values['autoexec_SOCETS'   ];
     autoexec_CODE_UTIL:= Values['autoexec_CODE_UTIL'];
     autoexec_Fonction := Values['autoexec_Fonction' ];
     Parametre1        := Values['Parametre1'        ];
     Parametre2        := Values['Parametre2'        ];
     Parametre3        := Values['Parametre3'        ];
     Parametre4        := Values['Parametre4'        ];
     Parametre5        := Values['Parametre5'        ];
     Parametre6        := Values['Parametre6'        ];
     Parametre7        := Values['Parametre7'        ];
end;

{$IFNDEF FPC}
function TParametres_Ligne_de_commande.To_Atom: ATOM;
begin
     To_StringList;
     Result:= GlobalAddAtom( PChar( Text))
end;

procedure TParametres_Ligne_de_commande.From_Atom( _Atom: ATOM);
var
   Buffer: array[0..4096] of AnsiChar;
begin
     GlobalGetAtomName( _Atom, Buffer, SizeOf( Buffer));
     Text:= StrPas( Buffer);
     From_StringList;
end;
{$ENDIF}

function TParametres_Ligne_de_commande.NomUtilisateur: String;
{$IFNDEF FPC}
var
   cNomUtilisateur: array[0..1024] of Char;
   cNomUtilisateur_Length: Cardinal;
begin
     cNomUtilisateur_Length:= SizeOf( cNomUtilisateur);
     if not GetUserName( cNomUtilisateur, cNomUtilisateur_Length)
     then
         Result:= ''
     else
         Result:= StrPas( cNomUtilisateur);
end;
{$ELSE}
begin
     Result:= GetEnvironmentVariable('USER');
end;
{$ENDIF}

procedure TParametres_Ligne_de_commande.Cree_MailSlot;
{$IFNDEF FPC}
var
   NomExe: String;
   RacineNomMailSlot: String;
   function not_T( _NomApplication: String): Boolean;
   begin
        //uClean_Log(  'Parametres_Ligne_de_commande.Cree_MailSlot, test >'
        //            +_NomApplication
        //            +'<, NomExe: >'+NomExe+'<' );
        Result:= True;
        if 1 <> Pos( UpperCase( _NomApplication), NomExe) then exit;

        RacineNomMailSlot:= '\\.\mailslot\'+_NomApplication+'.';
        Actif:= True;
        Result:= False;
   end;
begin
     if Actif then exit;

     NomExe:= UpperCase( ExtractFileName( uForms_EXE_Name));
          if not_T( 'Batpro_Editions_Application')
     then    not_T( 'Batpro_Planning_Application');

     if not Actif then exit;

     NomMailSlot:= RacineNomMailSlot+NomUtilisateur;
     //uClean_Log(  'Parametres_Ligne_de_commande.Cree_MailSlot, Création >'
     //            +NomMailSlot+'<');

     hMailSlot
     :=
       CreateMailslot( PChar( NomMailSlot),
                       0,
                       MAILSLOT_WAIT_FOREVER,   //MAILSLOT_WAIT_FOREVER ou 0
                       nil);
     if INVALID_HANDLE_VALUE = hMailSlot
     then
         begin
         Actif:= False;
         if ERROR_ALREADY_EXISTS <> GetLastError
         then
             TraiteLastError( 'Echec à la création du MailSlot: ');
         end;
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TParametres_Ligne_de_commande.Ferme_MailSlot;
{$IFNDEF FPC}
begin
     CloseHandle( hMailSlot);
end;
{$ELSE}
begin
end;
{$ENDIF}

function TParametres_Ligne_de_commande.From_MailSlot: Boolean;
{$IFNDEF FPC}
var
   NextSize: DWORD;
   Lus: DWORD;
   Buffer: String;
begin
     Result:= False;
     try
        Clear;

        if not Actif then exit;

        if not GetMailslotInfo( hMailSlot, nil, NextSize, nil, nil)
        then
            begin
            TraiteLastError( 'Echec de GetMailslotInfo : ');
            exit;
            end;

        if MAILSLOT_NO_MESSAGE = NextSize then exit;

        Result:= True;
        SetLength( Buffer, NextSize);
        ReadFile( hMailSlot, Buffer[1], NextSize, Lus, nil);
        Text:= Buffer;
     finally
            From_StringList;
            end;
end;
{$ELSE}
begin
end;
{$ENDIF}


procedure TParametres_Ligne_de_commande.To_MailSlot( _NomMailSlot: String);
{$IFNDEF FPC}
var
   NomMailSlot_Client: String;
   hMailSlot_Client: THandle;
   Buffer: String;
   Ecrits: DWORD;
begin
     To_StringList;

     Buffer:= Text;

     NomMailSlot_Client:= {'\\.\mailslot\'+}_NomMailSlot;
     hMailSlot_Client
     :=
       CreateFile( PChar( NomMailSlot_Client),
                   GENERIC_WRITE,
                   FILE_SHARE_READ,
                   nil,
                   OPEN_EXISTING,
                   FILE_ATTRIBUTE_NORMAL,
                   0);
     if INVALID_HANDLE_VALUE = hMailSlot_Client
     then
         TraiteLastError( 'Echec à l''ouverture du MailSlot '+NomMailSlot_Client+': ');

     WriteFile( hMailSlot_Client, Buffer[1], Length(Buffer), Ecrits, nil);

     CloseHandle( hMailSlot_Client);
end;
{$ELSE}
begin
end;
{$ENDIF}


function TParametres_Ligne_de_commande.not_MailSlot_existe( _NomMailSlot: String): Boolean;
{$IFNDEF FPC}
var
   NomMailSlot_Client: String;
   hMailSlot_Client: THandle;
begin
     Result:= False;
     NomMailSlot_Client:= {'\\.\mailslot\'+}_NomMailSlot;
     hMailSlot_Client
     :=
       CreateFile( PChar( NomMailSlot_Client),
                   GENERIC_WRITE,
                   FILE_SHARE_READ,
                   nil,
                   OPEN_EXISTING,
                   FILE_ATTRIBUTE_NORMAL,
                   0);
     if INVALID_HANDLE_VALUE = hMailSlot_Client
     then
         begin
         if ERROR_FILE_NOT_FOUND = GetLastError
         then
             Result:= True
         else
             TraiteLastError( 'Echec à l''ouverture du MailSlot '+NomMailSlot_Client+'- '+IntToStr(GetLastError)+': ');
         end;

     CloseHandle( hMailSlot_Client);
end;
{$ELSE}
begin
end;
{$ENDIF}

function TParametres_Ligne_de_commande.Ligne: String;
begin
     Result
     :=
        Formate_Liste( [
                       'Appel par Batpro6:',
                       autoexec_SGBD       ,
                       autoexec_Database   ,
                       autoexec_CODE_UTIL  ,
                       autoexec_SOCETS     ,
                       autoexec_Fonction   ,
                       Parametre1          ,
                       Parametre2          ,
                       Parametre3          ,
                       Parametre4          ,
                       Parametre5          ,
                       Parametre6          ,
                       Parametre7          ], ' ');
end;

procedure TParametres_Ligne_de_commande.From_Chaine( _Parametres: String);
var
   sAUTOEXEC: String;
begin
     sAUTOEXEC:= StrToK( ' ', _Parametres);
     Linux:= sAUTOEXEC = 'AUTOEXECL';

     _Parametres:= TrimLeft( _Parametres);
     autoexec_SGBD      := StrToK( ' ', _Parametres);
     _Parametres:= TrimLeft( _Parametres);
     autoexec_Database  := StrToK( ' ', _Parametres);
     _Parametres:= TrimLeft( _Parametres);
     autoexec_CODE_UTIL:= StrToK( ' ', _Parametres);
     _Parametres:= TrimLeft( _Parametres);
     autoexec_SOCETS   := StrToK( ' ', _Parametres);
     _Parametres:= TrimLeft( _Parametres);
     autoexec_Fonction := StrToK( ' ', _Parametres);
     _Parametres:= TrimLeft( _Parametres);
     Parametre1:= Decode_Parametres( StrToK( ' ', _Parametres)); _Parametres:= TrimLeft( _Parametres);
     Parametre2:= Decode_Parametres( StrToK( ' ', _Parametres)); _Parametres:= TrimLeft( _Parametres);
     Parametre3:= Decode_Parametres( StrToK( ' ', _Parametres)); _Parametres:= TrimLeft( _Parametres);
     Parametre4:= Decode_Parametres( StrToK( ' ', _Parametres)); _Parametres:= TrimLeft( _Parametres);
     Parametre5:= Decode_Parametres( StrToK( ' ', _Parametres)); _Parametres:= TrimLeft( _Parametres);
     Parametre6:= Decode_Parametres( StrToK( ' ', _Parametres));
     Parametre7:= Decode_Parametres( StrToK( ' ', _Parametres));

     autoexec_SOC      := Copy( autoexec_SOCETS, 1, 3);
     autoexec_ETS      := Copy( autoexec_SOCETS, 4, 3);
end;

function TParametres_Ligne_de_commande.Decode_Parametres( code: String): String;
//var
//   I: Integer;
begin
     //Désactivé 2014/02/18
     //for I:= 1 to Length( code)
     //do
     //  if code[I] = '-'
     //  then
     //      Code[I]:= ' ';
     Result:= Code;
end;

procedure TParametres_Ligne_de_commande.Initialize;
var
   TypeExecution: String;
   Bug_Genero: Boolean;
begin
     TypeExecution:= UpperCase( ParamStr(1));

     Bug_Genero:=     ('AUTOEXEC' = Copy( TypeExecution, 1, 8))
                  and (ParamCount = 1);

          if TypeExecution = 'DEBUG'
     then
         begin
         ModeDEBUG:= StrToInt( ParamStr(2));
         ModeDEBUG_1:= ModeDEBUG >= 1;
         ModeDEBUG_2:= ModeDEBUG >= 2;
         ModeDEBUG_3:= ModeDEBUG >= 3;
         end
     else if    (TypeExecution = 'AUTOEXEC')
             or (TypeExecution = 'AUTOEXECL')
             or Bug_Genero
     then //AUTOEXEC OPE DEM001 B307 "GO  031500 00 00"
         begin
         ModeAUTOEXEC:= True;

         if Bug_Genero
         then
             From_Chaine( TypeExecution)
         else
             begin
             Linux             := TypeExecution = 'AUTOEXECL';
             autoexec_SGBD     :=                    ParamStr( 2);
             autoexec_Database :=                    ParamStr( 3);
             autoexec_CODE_UTIL:=                    ParamStr( 4);
             autoexec_SOCETS   :=                    ParamStr( 5);
             autoexec_Fonction :=                    ParamStr( 6);
             Parametre1        := Decode_Parametres( ParamStr( 7));
             Parametre2        := Decode_Parametres( ParamStr( 8));
             Parametre3        := Decode_Parametres( ParamStr( 9));
             Parametre4        := Decode_Parametres( ParamStr(10));
             Parametre5        := Decode_Parametres( ParamStr(11));
             Parametre6        := Decode_Parametres( ParamStr(12));
             Parametre7        := Decode_Parametres( ParamStr(13));
             autoexec_SOC      := Copy( autoexec_SOCETS, 1, 3);
             autoexec_ETS      := Copy( autoexec_SOCETS, 4, 3);
             end;
         end
     else if TypeExecution = 'HELP_CREATOR'
     then
         ModeHELP_CREATOR:= True
     else
         Linux:= TypeExecution = 'L';

end;

initialization
              Parametres_Ligne_de_commande:= TParametres_Ligne_de_commande.Create;
              Parametres_Ligne_de_commande.Initialize;
finalization
              Free_nil( Parametres_Ligne_de_commande);
end.

