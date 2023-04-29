unit uOD_Styles;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    uOOoStrings,
  SysUtils;

type
 TOD_Style_Alignment
 =
  (
  osa_Left  ,
  osa_Center,
  osa_Right
  );
 TOD_Styles
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Styles: String);
    destructor Destroy; override;
  //Attributs
  public
    Styles: array of String;
    Alignments: array of TOD_Style_Alignment;
  //Initialisation
  public
    procedure Init( _Styles: String);
  end;

implementation

{ TOD_Styles }

constructor TOD_Styles.Create( _Styles: String);
begin
     inherited Create;
     Init( _Styles);
end;

destructor TOD_Styles.Destroy;
begin

     inherited;
end;

procedure TOD_Styles.Init( _Styles: String);
begin
     SetLength( Styles, 0);
     while Length( _Styles) > 0
     do
       begin
       SetLength( Styles, Length( Styles)+1);
       Styles[ High( Styles)]:= Trim( StrTok( ',', _Styles));
       end;
     SetLength( Alignments, Length( Styles));
end;

end.
