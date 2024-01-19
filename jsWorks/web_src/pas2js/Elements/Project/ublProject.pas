unit ublProject;

{$mode ObjFPC}

interface

uses
 Classes, SysUtils, JS, Web,
 uBatpro_Ligne;

type
    { TblProject }
    TblProject
    =
     class(TBatpro_Ligne)
       id: Integer;
       Selected: Boolean;
       Name: String;
       procedure Ecrire;override;
       procedure Append_to( _root: TJSHTMLElement;
                            __from: T_from_Batpro_Ligne_procedure;
                            _blrk: TBatpro_Ligne_root_kind);override;
     end;


implementation

{ TblProject }

procedure TblProject.Ecrire;
begin
     inherited;
     Writeln( '  id: ', id);
     Writeln( '  Selected: ', Selected);
     Writeln( '  Name: ', Name);
end;

procedure TblProject.Append_to( _root: TJSHTMLElement;
                                __from: T_from_Batpro_Ligne_procedure;
                                _blrk: TBatpro_Ligne_root_kind);

var
   tr: TJSElement;
   td: TJSElement;
   a : TJSHTMLAnchorElement;
begin
     inherited;

     if  _blrk <> blrk_table then exit;

     tr:=document.createElement('tr');
     _root.appendChild(tr);

     td:=document.createElement('td');
     td.Attrs['style']:= 'width: 100%; vertical-align: top;';
     tr.appendChild(td);

     a:=TJSHTMLAnchorElement( document.createElement('a'));
     //a.Attrs['href']:= '';
     td.appendChild(a);

     a.append( Name);
     a.onclick:= @click;
end;


end.

