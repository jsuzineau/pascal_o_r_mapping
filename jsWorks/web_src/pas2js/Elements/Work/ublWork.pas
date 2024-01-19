unit ublWork;

{$mode ObjFPC}

interface

uses
 Classes, SysUtils, JS, Web,
 uPAS2JS_utils,
 uBatpro_Ligne;

type
    { TblWork }
    TblWork
    =
     class(TBatpro_Ligne)
       id: Integer;
       Selected: Boolean;
       nUser: Integer;
       nProject: Integer;
       Beginning: String;//TDateTime;
       Description: String;
       Duree: String;//TDateTime;
       Session_Titre: String;
       sSession: String;

       constructor Create( _data: JSValue); override;
       procedure Ecrire; override;
       procedure Append_to( _root: TJSHTMLElement;
                            __from: T_from_Batpro_Ligne_procedure;
                            _blrk: TBatpro_Ligne_root_kind);override;
     //Description_courte
     public
       function Description_courte: String;
     //_End
     private
       function Get_End: String;
       procedure Set_End( _Value: String);
     public
       property _End: String(*TDateTime*) read Get_End write Set_End;
     end;

procedure Work_from_Periode( _sDebut, _sFin: String; _idTag: Integer;
                             _tbody_id:String;
                             __from: T_from_Batpro_Ligne_procedure;
                             _blrk: TBatpro_Ligne_root_kind);

implementation

procedure Work_from_Periode( _sDebut, _sFin: String; _idTag: Integer;
                             _tbody_id:String;
                             __from: T_from_Batpro_Ligne_procedure;
                             _blrk: TBatpro_Ligne_root_kind);
var
   jo: TJSObject;
   Request_Body: String;
begin
     jo:= TJSObject.new;
     jo.Properties['Debut']:= _sDebut;
     jo.Properties['Fin'  ]:= _sFin  ;
     jo.Properties['idTag']:= _idTag ;

     Request_Body:= TJSJSON.stringify( jo);

     //Writeln( 'Work_from_Periode: Request_Body');
     //Writeln( Request_Body);
     Requete( 'Work_from_Periode', _tbody_id, TblWork, __from, _blrk, Request_Body);
end;

{ TblWork }

constructor TblWork.Create(_data: JSValue);
    procedure init_object;
    var
       O: TJSObject;
       procedure Decode_DateTime_as_DateTime;
       var
          v: JSValue;
          typ: String;
       begin
            v:= O.Properties['Beginning'    ];
            asm
               typ= typeof(v);
            end;
            WriteLn( typ,':',v);

            //Beginning    := Decode_Date( String(O.Properties['Beginning'    ]));
            //_End         := Decode_Date( String(O.Properties['End'          ]));
            //Duree        := TDateTime(O.Properties['Duree'        ]);
       end;
       procedure Decode_DateTime_as_String;
       begin
            Beginning    := String(O.Properties['Beginning'    ]);
            _End         := String(O.Properties['End'          ]);
            Duree        := String(O.Properties['Duree'        ]);
       end;
    begin
         O:= TJSObject( _data);

         id           := Integer  (O.Properties['id'           ]);
         Selected     := Boolean  (O.Properties['Selected'     ]);
         nUser        := Integer  (O.Properties['nUser'        ]);
         nProject     := Integer  (O.Properties['nProject'     ]);
         Description  := String   (O.Properties['Description'  ]);
         Session_Titre:= String   (O.Properties['Session_Titre']);
         sSession     := String   (O.Properties['sSession'     ]);
         //Decode_DateTime_as_DateTime;
         Decode_DateTime_as_String;
    end;
 begin
      inherited Create( _data);
      //init_object;
 end;

procedure TblWork.Ecrire;
begin
     Writeln( '  id           : ', id           );
     Writeln( '  Selected     : ', Selected     );
     Writeln( '  nUser        : ', nUser        );
     Writeln( '  nProject     : ', nProject     );
     Writeln( '  Beginning    : ', Beginning    );
     Writeln( '  _End         : ', _End         );
     Writeln( '  Description  : ', Description  );
     Writeln( '  Duree        : ', Duree        );
     Writeln( '  Session_Titre: ', Session_Titre);
     Writeln( '  sSession     : ', sSession     );

end;

procedure TblWork.Append_to( _root: TJSHTMLElement;
                             __from: T_from_Batpro_Ligne_procedure;
                             _blrk: TBatpro_Ligne_root_kind);
   procedure Traite_Table;
   var
      tr: TJSElement;
      td: TJSElement;
      a : TJSHTMLAnchorElement;
   begin
        tr:=document.createElement('tr');
        _root.appendChild(tr);

        td:=document.createElement('td');
        td.Attrs['style']:= 'width: 100%; vertical-align: top;';
        tr.appendChild(td);

        a:=TJSHTMLAnchorElement( document.createElement('a'));
        //a.Attrs['href']:= '';
        td.appendChild(a);

        //a.append( DateTimeToStr( Beginning));
        a.append( Beginning+' '+Description_courte);
        a.onclick:= @click;
   end;
   procedure Traite_Bootstrap;
   var
      row: TJSElement;
      b : TJSHTMLButtonElement;
   begin
        row:=document.createElement('div');
        _root.appendChild(row);
        row.Attrs['class']:= 'row mb-3';

        b:= TJSHTMLButtonElement(document.createElement('button'));
        b.Attrs['class']:= 'btn';//btn-primary
        row.appendChild(b);

        b.append( Beginning+' '+Description_courte);
        b.onclick:= @click;
   end;
begin
     inherited;
     case _blrk
     of
       blrk_table            : Traite_Table;
       blrk_bootstrap_div_col: Traite_Bootstrap;
       end;
end;

function TblWork.Description_courte: String;
const Taille_max=20;
begin
     if Length( Description) <= Taille_max
     then
         Result:= Description
     else
         Result:= Copy( Description, 1, Taille_max)+'...';
end;

function TblWork.Get_End: String;
begin
     asm
        Result=this['End'];
     end;
end;

procedure TblWork.Set_End(_Value: String);
begin
     asm
        this['End']=_Value;
     end;
end;


end.

