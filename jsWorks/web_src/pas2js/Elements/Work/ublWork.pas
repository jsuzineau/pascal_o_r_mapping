unit ublWork;

{$mode ObjFPC}

interface

uses
 Classes, SysUtils, JS, Web,
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
       procedure Append_to( _tbody: TJSHTMLElement; __from: T_from_Batpro_Ligne_procedure); override;
     //_End
     private
       function Get_End: String;
       procedure Set_End( _Value: String);
     public
       property _End: String(*TDateTime*) read Get_End write Set_End;
     end;


implementation

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

procedure TblWork.Append_to( _tbody: TJSHTMLElement;
                             __from: T_from_Batpro_Ligne_procedure);
var
   tr: TJSElement;
   td: TJSElement;
   a : TJSHTMLAnchorElement;
begin
     inherited;
     tr:=document.createElement('tr');
     _tbody.appendChild(tr);

     td:=document.createElement('td');
     td.Attrs['style']:= 'width: 100%; vertical-align: top;';
     tr.appendChild(td);

     a:=TJSHTMLAnchorElement( document.createElement('a'));
     //a.Attrs['href']:= '';
     td.appendChild(a);

     //a.append( DateTimeToStr( Beginning));
     a.append( Beginning);
     a.onclick:= @click;
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

