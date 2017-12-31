unit uVide;
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
    uBatpro_StringList,
    u_sys_,
    SysUtils, Classes;

procedure Vide_StringList( SL: TBatpro_StringList);

procedure Detruit_StringList( var _sl);

procedure StringList_EnleveObject( sl: TBatpro_StringList; O: TObject);

type
    TuVide_bl_nil= procedure( var bl);
var
   uVide_bl_nil: TuVide_bl_nil= nil;

implementation

procedure Vide_StringList( sl: TBatpro_StringList);
var
   Trash: TObject;
begin
     if sl = nil then exit;

     while sl.Count > 0
     do
       begin
       Trash:= sl.Objects[0];
       sl.Objects[0]:= nil;
       if Assigned( Trash)
       then
           begin
           if Trash is TBatpro_StringList
           then
               Vide_StringList( TBatpro_StringList(Trash));
           //uClean_Log( 'Vide_StringList, sl.count= '+IntToStr( sl.Count));

           if Assigned( uVide_bl_nil)
           then
               uVide_bl_nil( Trash);
           //Free_nil( Trash);
           end;

       sl.Delete( 0);
       end;
end;

procedure Detruit_StringList( var _sl);
var
   sl: TBatpro_StringList;
begin
     if Affecte_( sl, TBatpro_StringList, TObject(_sl)) then exit;

     Vide_StringList( sl);

     Free_nil( sl);
end;

procedure StringList_EnleveObject( sl: TBatpro_StringList; O: TObject);
var
   I: Integer;
begin
     if sl = nil then exit;

     I:= sl.IndexOfObject( O);
     if I <> -1
     then
         sl.Delete( I);
end;

end.
