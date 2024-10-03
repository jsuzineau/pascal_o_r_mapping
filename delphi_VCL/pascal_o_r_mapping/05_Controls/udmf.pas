unit udmf;
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
  uLookupConnection_Ancetre,
    uBatpro_StringList,
  Windows, Messages, SysUtils, Variants, Classes, VCL.Graphics, VCL.Controls, VCL.Forms,
  VCL.StdCtrls, DB, DBClient;

type
 Tdmf
 =
  class(TForm)
    cd: TClientDataSet;
    m: TMemo;
    ds: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  //Gestions des lookups sur TChamp
  protected
    fCle, fLibelle: TField;
  public
    slCles, slLibelles: TBatpro_StringList;
    procedure GetLookupListItems( _Current_Key: String;
                                  _Keys, _Labels: TStrings;
                                  _Connection: TLookupConnection_Ancetre;
                                  _CodeId_: Boolean= False);
  end;

implementation

uses
    uClean;

{$R *.dfm}

procedure Tdmf.FormCreate(Sender: TObject);
var
   S: TMemoryStream;
begin
     S:= TMemoryStream.Create;
       M.Lines.  SaveToStream( S);
       S.Position:= 0;
       cd     .LoadFromStream( S);
     FreeAndNil( S);

     slCles    := TBatpro_StringList.Create;
     slLibelles:= TBatpro_StringList.Create;
     if     Assigned( fCle    )
        and Assigned( fLibelle)
     then
         begin
         cd.First;
         while not cd.Eof
         do
           begin
           slCles    .Add( fCle    .AsString);
           slLibelles.Add( fLibelle.AsString);
           cd.Next;
           end;
         end;
end;

procedure Tdmf.FormDestroy(Sender: TObject);
begin
     Free_nil( slCles    );
     Free_nil( slLibelles);
end;

procedure Tdmf.GetLookupListItems( _Current_Key: String;
                                   _Keys, _Labels: TStrings;
                                   _Connection: TLookupConnection_Ancetre;
                                   _CodeId_: Boolean= False);
begin
     _Keys  .Text:= slCles    .Text;
     _Labels.Text:= slLibelles.Text;
end;

end.
