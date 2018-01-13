unit ufBitmaps;
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
  Windows, Messages, SysUtils, Variants, Classes,
  Vcl.ImgList, Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls, Vcl.StdCtrls,
  System.ImageList,
  FMX.Dialogs,FMX.Forms,
  FMX.ImgList, FMX.Controls, FMX.Graphics, FMX.ExtCtrls, FMX.StdCtrls, FMX.Objects;

type
  TfBitmaps = class(TForm)
    DOCSINGL: TImageList;
    LOCKSHUT_OPEN: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    iBrosse_Trame_50_pourcent: FMX.Objects.TImage;
    iBrosse_Trame_25_pourcent: FMX.Objects.TImage;
    iBrosse_Solide           : FMX.Objects.TImage;
    iBrosse_Vertical_50: FMX.Objects.TImage;
    iBrosse_Vertical_25: FMX.Objects.TImage;
    Label3: TLabel;
    LOSANGE: TImageList;
    DOSSIER_KDE_PAR_POSTE: TImageList;
    Label4: TLabel;
    LOGIN: TImageList;
    Label5: TLabel;
    MEN_AT_WORK: TImageList;
    Label6: TLabel;
  public
    { Déclarations publiques }
    function bBrosse_Solide           : TBitmap;
    function bBrosse_Trame_50_pourcent: TBitmap;
    function bBrosse_Trame_25_pourcent: TBitmap;
    function bBrosse_Vertical_50: TBitmap;
    function bBrosse_Vertical_25: TBitmap;

    function svgDOCSINGL: String;
    function svgDOCSINGL_id: String;
    function svgDOCSINGL_width: Integer;
    function svgDOCSINGL_height: Integer;

    function svgLOSANGE: String;
    function svgLOSANGE_id: String;
    function svgLOSANGE_width: Integer;
    function svgLOSANGE_height: Integer;

    function svgLOGIN: String;
    function svgLOGIN_id: String;
    function svgLOGIN_width: Integer;
    function svgLOGIN_height: Integer;

    function svgMEN_AT_WORK: String;
    function svgMEN_AT_WORK_id: String;
    function svgMEN_AT_WORK_width: Integer;
    function svgMEN_AT_WORK_height: Integer;

    function svgDOSSIER_KDE_PAR_POSTE: String;
    function svgDOSSIER_KDE_PAR_POSTE_id: String;
    function svgDOSSIER_KDE_PAR_POSTE_width: Integer;
    function svgDOSSIER_KDE_PAR_POSTE_height: Integer;
  end;

function fBitmaps: TfBitmaps;

implementation

uses
    uClean;

{$R *.dfm}

var
   FfBitmaps: TfBitmaps;

function fBitmaps: TfBitmaps;
begin
     Clean_Get( Result, FfBitmaps, TfBitmaps);
end;

{ TfBitmaps }

function TfBitmaps.bBrosse_Solide: TBitmap;
begin
     Result:= iBrosse_Solide.Bitmap;
end;

function TfBitmaps.bBrosse_Trame_50_pourcent: TBitmap;
begin
     Result:= iBrosse_Trame_50_pourcent.Bitmap;
end;

function TfBitmaps.bBrosse_Trame_25_pourcent: TBitmap;
begin
     Result:= iBrosse_Trame_25_pourcent.Bitmap;
end;

function TfBitmaps.bBrosse_Vertical_50: TBitmap;
begin
     Result:= iBrosse_Vertical_50.Bitmap;
end;

function TfBitmaps.bBrosse_Vertical_25: TBitmap;
begin
     Result:= iBrosse_Vertical_25.Bitmap;
end;

function TfBitmaps.svgDOCSINGL_id: String;
begin
     Result:= 'svgDOCSINGL';
end;

function TfBitmaps.svgDOCSINGL_width: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgDOCSINGL_height: Integer;
begin
     Result:= 12;
end;

function TfBitmaps.svgDOCSINGL: String;
begin
     Result
     :=
 '<svg                                                                                                                                '#13#10
+'   xmlns:svg="http://www.w3.org/2000/svg"                                                                                           '#13#10
+'   xmlns="http://www.w3.org/2000/svg"                                                                                               '#13#10
+'   version="1.1"                                                                                                                    '#13#10
+'   width="16"                                                                                                                       '#13#10
+'   height="12"                                                                                                                      '#13#10
+'   id="'+svgDOCSINGL_id+'">                                                                                                                '#13#10
+'<!-- Created with Inkscape (http://www.inkscape.org/) -->                                                                           '#13#10
+'  <g                                                                                                                                '#13#10
+'     transform="translate(-389.14285,-389.21933)"                                                                                   '#13#10
+'     >                                                                                                                              '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 3.5084781,0.4067812 5.9999965,0.050846 3.0508474,3.0508469 0.05085,7.0677969 -9.1525419,0.05085 0.050848,-10.22033976 z"'#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:#ffffff;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />           '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 5.0338983,2.4915254 1.6271186,0.050848 0.3050847,0"                                                                     '#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />              '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 5.0338983,4.4745763 3.2542378,5e-7"                                                                                     '#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />              '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 5.1355932,6.4576271 5.6440678,0 0.20339,0"                                                                              '#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />              '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 5.0338983,8.5423729 3.8135593,0 0.1016949,0"                                                                            '#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />              '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 9.5084746,0.45762712 0,3.25423728 0,0"                                                                                  '#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />              '#13#10
+'    <path                                                                                                                           '#13#10
+'       d="m 9,3.4067797 3.457627,-0.050848 0,0"                                                                                     '#13#10
+'       transform="translate(389.14285,389.21933)"                                                                                   '#13#10
+'       style="fill:none;stroke:#000000;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" />              '#13#10
+'  </g>                                                                                                                              '#13#10
+'</svg>                                                                                                                              '#13#10;
end;

function TfBitmaps.svgLOSANGE_width: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgLOSANGE_height: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgLOSANGE_id: String;
begin
     Result:= 'svgLOSANGE';
end;

function TfBitmaps.svgLOSANGE: String;
begin
     Result
     :=
 '<svg                                                                                                               '#13#10
+'   xmlns:svg="http://www.w3.org/2000/svg"                                                                          '#13#10
+'   xmlns="http://www.w3.org/2000/svg"                                                                              '#13#10
+'   version="1.1"                                                                                                   '#13#10
+'   width="16"                                                                                                      '#13#10
+'   height="16"                                                                                                     '#13#10
+'   id="'+svgLOSANGE_id+'">                                                                                         '#13#10
+'<!-- Created with Inkscape (http://www.inkscape.org/) -->                                                          '#13#10
+'  <g                                                                                                               '#13#10
+'     transform="translate(-363.42856,-501.50504)"                                                                  '#13#10
+'     >                                                                                                             '#13#10
+'    <path                                                                                                          '#13#10
+'       d="M 9.9638243,3.5968993 5.9121447,7.6485789 1.860465,3.5968993 5.9121447,-0.45478034 9.9638243,3.5968993 z"'#13#10
+'       transform="translate(364.99962,505.39134)"                                                                  '#13#10
+'       style="fill:#000000;stroke:#000000" />                                                                      '#13#10
+'  </g>                                                                                                             '#13#10
+'</svg>                                                                                                             '#13#10
     ;
end;

function TfBitmaps.svgLOGIN_width: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgLOGIN_height: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgLOGIN_id: String;
begin
     Result:= 'svgLOGIN';
end;

function TfBitmaps.svgLOGIN: String;
begin
     Result
     :=
 '<svg                                                                   '#13#10
+'   xmlns:svg="http://www.w3.org/2000/svg"                              '#13#10
+'   xmlns="http://www.w3.org/2000/svg"                                  '#13#10
+'   xmlns:xlink="http://www.w3.org/1999/xlink"                          '#13#10
+'   version="1.1"                                                       '#13#10
+'   width="30.305084"                                                   '#13#10
+'   height="47.389832"                                                  '#13#10
+'   id="'+svgLOGIN_id+'">                                               '#13#10
+'  <defs                                                                '#13#10
+'     id="defs3710">                                                    '#13#10
+'    <linearGradient                                                    '#13#10
+'       x1="65.491524"                                                  '#13#10
+'       y1="17.288136"                                                  '#13#10
+'       x2="57.254238"                                                  '#13#10
+'       y2="12.406779"                                                  '#13#10
+'       id="linearGradient3656"                                         '#13#10
+'       xlink:href="#linearGradient3650"                                '#13#10
+'       gradientUnits="userSpaceOnUse" />                               '#13#10
+'    <linearGradient                                                    '#13#10
+'       id="linearGradient3650">                                        '#13#10
+'      <stop                                                            '#13#10
+'         id="stop3652"                                                 '#13#10
+'         style="stop-color:#4d86cf;stop-opacity:1"                     '#13#10
+'         offset="0" />                                                 '#13#10
+'      <stop                                                            '#13#10
+'         id="stop3674"                                                 '#13#10
+'         style="stop-color:#bec8d3;stop-opacity:1"                     '#13#10
+'         offset="1" />                                                 '#13#10
+'    </linearGradient>                                                  '#13#10
+'    <linearGradient                                                    '#13#10
+'       x1="26.440678"                                                  '#13#10
+'       y1="42.508476"                                                  '#13#10
+'       x2="10.372881"                                                  '#13#10
+'       y2="29.288136"                                                  '#13#10
+'       id="linearGradient3664"                                         '#13#10
+'       xlink:href="#linearGradient3650"                                '#13#10
+'       gradientUnits="userSpaceOnUse"                                  '#13#10
+'       gradientTransform="translate(48.135593,0)" />                   '#13#10
+'    <linearGradient                                                    '#13#10
+'       id="linearGradient3697">                                        '#13#10
+'      <stop                                                            '#13#10
+'         id="stop3699"                                                 '#13#10
+'         style="stop-color:#4d86cf;stop-opacity:1"                     '#13#10
+'         offset="0" />                                                 '#13#10
+'      <stop                                                            '#13#10
+'         id="stop3701"                                                 '#13#10
+'         style="stop-color:#bec8d3;stop-opacity:1"                     '#13#10
+'         offset="1" />                                                 '#13#10
+'    </linearGradient>                                                  '#13#10
+'    <linearGradient                                                    '#13#10
+'       x1="26.440678"                                                  '#13#10
+'       y1="42.508476"                                                  '#13#10
+'       x2="10.372881"                                                  '#13#10
+'       y2="29.288136"                                                  '#13#10
+'       id="linearGradient3706"                                         '#13#10
+'       xlink:href="#linearGradient3650"                                '#13#10
+'       gradientUnits="userSpaceOnUse"                                  '#13#10
+'       gradientTransform="translate(48.135593,0)" />                   '#13#10
+'    <linearGradient                                                    '#13#10
+'       x1="65.491524"                                                  '#13#10
+'       y1="17.288136"                                                  '#13#10
+'       x2="57.254238"                                                  '#13#10
+'       y2="12.406779"                                                  '#13#10
+'       id="linearGradient3806"                                         '#13#10
+'       xlink:href="#linearGradient3650"                                '#13#10
+'       gradientUnits="userSpaceOnUse" />                               '#13#10
+'    <linearGradient                                                    '#13#10
+'       x1="26.440678"                                                  '#13#10
+'       y1="42.508476"                                                  '#13#10
+'       x2="10.372881"                                                  '#13#10
+'       y2="29.288136"                                                  '#13#10
+'       id="linearGradient3808"                                         '#13#10
+'       xlink:href="#linearGradient3650"                                '#13#10
+'       gradientUnits="userSpaceOnUse"                                  '#13#10
+'       gradientTransform="translate(48.135593,0)" />                   '#13#10
+'    <linearGradient                                                    '#13#10
+'       x1="26.440678"                                                  '#13#10
+'       y1="42.508476"                                                  '#13#10
+'       x2="10.372881"                                                  '#13#10
+'       y2="29.288136"                                                  '#13#10
+'       id="linearGradient3811"                                         '#13#10
+'       xlink:href="#linearGradient3650"                                '#13#10
+'       gradientUnits="userSpaceOnUse"                                  '#13#10
+'       gradientTransform="translate(305.05084,408.87066)" />           '#13#10
+'  </defs>                                                              '#13#10
+'  <g                                                                   '#13#10
+'     transform="translate(-304.84745,-408.66727)"                      '#13#10
+'     id="layer1">                                                      '#13#10
+'    <path                                                              '#13#10
+'       d="m 334.79443,447.19197 c -0.19493,5.7744 -9.92774,9.01691 '
            +'-14.8916,8.86995 -7.29336,-0.21594 -15.0815,-3.30276 '
            +'-15.05538,-9.15736 -0.0824,-5.57556 6.73947,-19.09481 '
            +'14.97554,-19.10533 11.06986,0.25833 15.27652,10.35544 '
            +'14.97144,19.39274 z"'#13#10
+'       id="path3648"                                                   '#13#10
+'       style="fill:url(#linearGradient3811);fill-opacity:1" />         '#13#10
+'    <path                                                              '#13#10
+'       d="m 67.728814,12.406779 a 10.474576,9.9661016 0 1 1 '
             +'-20.949152,0 10.474576,9.9661016 0 1 1 20.949152,0 z"     '#13#10
+'       transform="translate(262.94915,406.22659)"                      '#13#10
+'       id="path2818"                                                   '#13#10
+'       style="fill:url(#linearGradient3806);fill-opacity:1" />         '#13#10
+'    <path                                                              '#13#10
+'       d="m -284.60638,453.66971 a 1.5,1.5 0 1 1 -3,0 1.5,1.5 0 1 1 '
             +'3,0 z"                                                    '#13#10
+'       id="path3804"                                                   '#13#10
+'       style="fill:#000000;stroke:none" />                             '#13#10
+'  </g>                                                                 '#13#10
+'</svg>                                                                 '#13#10
     ;
end;

function TfBitmaps.svgMEN_AT_WORK_width: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgMEN_AT_WORK_height: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgMEN_AT_WORK_id: String;
begin
     Result:= 'svgMEN_AT_WORK';
end;

function TfBitmaps.svgMEN_AT_WORK: String;
begin
     Result
     :=
 '<?xml version="1.0"?>                                                                 '#13#10
+'<svg xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"                          '#13#10
+'xmlns="http://www.w3.org/2000/svg" xmlns:cc="http://creativecommons.org/ns#"          '#13#10
+'xmlns:dc="http://purl.org/dc/elements/1.1/"                                           '#13#10
+'id="'+svgMEN_AT_WORK_id+'" viewBox="0 0 298.09 264.13"                                '#13#10
+'version="1.1">                                                                        '#13#10
+'  <g id="layer1" transform="translate(-176.92 -379.31)">                              '#13#10
+'    <path id="path2996" d="m326.14 379.31'
      +'c-5.4219 0.0486-10.738 3.0802-15.906 9.4688l-133.22 228.56'
      +'c-1.0172 19.521 6.6617 23.412 15 26.094l268.22-0.71875'
      +'c17.814-7.2662 14.779-16.621 14.281-25.719l-131.78-229.28'
      +'c-5.6443-5.5115-11.172-8.4548-16.594-8.4062'
      +'zm-0.15625 34.969 118.19 202.53-235.38-0.5 117.19-202.03z"'
      +'fill="#ed171a"/>                                                                '#13#10
+'    <path id="path3769" d="m306.32 476.52'
      +'c-3.32-0.053-6.4976 1.3762-9.5 4.5-4.6653 5.1802-3.5947 10.891'
      +'-0.6875 16.781 5.36 4.1727 10.599 5.8788 15.688 2.875l1.0938 2.8438'
      +'c-3.0358 2.2218-5.8932 5.0668-8.2188 9.6562 0.63987 7.7865 1.4261 15.525 3.9375 22.844'
      +'-2.6582 3.3177-4.625 6.9253-6.0938 10.719-1.5083 4.2262-2.2826 8.4613'
      +'-2.125 12.688l-11.875 7.4062c0.25008-1.9703-0.0723-2.6342-1.7188'
      +'-3.6562-2.026-2.4913-4.6584-2.49-7.125-3.2188 0.41329-2.619-2.3244'
      +'-5.256-4.6562-7.875-1.5369-0.69951-3.1055-1.2806-5.3438-0.34375-2.8232'
      +'-2.2448-6.3622-2.3866-10.375-1.0625l-31.406 57.125 72.5-0.34375c-0.44668'
      +'-12.367-3.2297-24.397-10.094-35.812l10.094-5.9688 8.9062 0.34375 2.5'
      +'-7.5 11.438-6.0625-3.5625 8.2188-1.0625 40.344c-8.6504 1.6226-12.067 3.9696'
      +'-12.156 6.7812h24.656l7.6562-34.562-2.0312-0.25 0.4375-5.1875c5.5377'
      +'-5.2101 9.2877-12.724 13.219-20'
      +'-0.4256 8.8712 3.0393 16.163 7.125 23.562 8.1955 9.4039 17.951 17.635 28.031 25.625'
      +'-0.61213 4.7218-4.8452 7.8005-7.8438 11.438l9.7188-0.25 4.375-3.2188 10-17.5'
      +'-5.6875-1.4375-20.812-23.562-1 2.125c-4.8598-3.4937-4.9386-8.8139-5.6875'
      +'-13.906 0.67537-8.897-2.6595-15.594-6.1875-22.156l2.5938-2.1562'
      +'c0.31205 1.4159 0.89705 1.5386 1.4375 1.8125 3.748-1.1279 6.2644'
      +'-3.4103 7.1562-7.1562-0.67959-1.8713-1.7455-3.4818-4.3125-3.9375l'
      +'-1.4062-8.2188c-5.548-23.043-12.004-20.481-18.219-24.625-10.544 1.3429'
      +'-21.274 2.2009-29.281 10-0.9757-0.0957-2.0764-0.0709-1.4375'
      +'-1.7812 0.57498-7.437-1.962-10.452-4.6562-13.219-2.7517-1.7356'
      +'-5.4178-2.6776-8-2.7188zm43.969 21.375c5.597'
      +'-0.18822 8.5662 7.1834 12.281 23.5l-2.5 2.2812-15.156-23.875c2.0524'
      +'-1.207 3.8078-1.8536 5.375-1.9062'
      +'zm-31 25.656c2.3505 1.2926 4.5319 2.3149 11.469 12.125l-2.9062 7.0625'
      +'-17.781 11.094c0.93931-6.0193 5.2268-9.4967 8.6875-13.625 1.2329'
      +'-5.3784 1.3174-10.941 0.53125-16.656z"/>                                        '#13#10
+'  </g>                                                                                '#13#10
+'  <metadata>                                                                          '#13#10
+'    <rdf:RDF>                                                                         '#13#10
+'      <cc:Work>                                                                       '#13#10
+'        <dc:format>image/svg+xml</dc:format>                                          '#13#10
+'        <dc:type rdf:resource="http://purl.org/dc/dcmitype/StillImage"/>              '#13#10
+'        <cc:license rdf:resource="http://creativecommons.org/licenses/publicdomain/"/>'#13#10
+'        <dc:publisher>                                                                '#13#10
+'          <cc:Agent rdf:about="http://openclipart.org/">                              '#13#10
+'            <dc:title>Openclipart</dc:title>                                          '#13#10
+'          </cc:Agent>                                                                 '#13#10
+'        </dc:publisher>                                                               '#13#10
+'      </cc:Work>                                                                      '#13#10
+'      <cc:License rdf:about="http://creativecommons.org/licenses/publicdomain/">      '#13#10
+'        <cc:permits rdf:resource="http://creativecommons.org/ns#Reproduction"/>       '#13#10
+'        <cc:permits rdf:resource="http://creativecommons.org/ns#Distribution"/>       '#13#10
+'        <cc:permits rdf:resource="http://creativecommons.org/ns#DerivativeWorks"/>    '#13#10
+'      </cc:License>                                                                   '#13#10
+'    </rdf:RDF>                                                                        '#13#10
+'  </metadata>                                                                         '#13#10
+'</svg>                                                                                '#13#10
     ;
end;

function TfBitmaps.svgDOSSIER_KDE_PAR_POSTE_width: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgDOSSIER_KDE_PAR_POSTE_height: Integer;
begin
     Result:= 16;
end;

function TfBitmaps.svgDOSSIER_KDE_PAR_POSTE_id: String;
begin
     Result:= 'svgDOSSIER_KDE_PAR_POSTE';
end;

function TfBitmaps.svgDOSSIER_KDE_PAR_POSTE: String;
begin
     Result
     :=
 '<?xml version="1.0" encoding="UTF-8" standalone="no"?>                        '#13#10
+'<!-- Created with Inkscape (http://www.inkscape.org/) -->                     '#13#10
+'                                                                              '#13#10
+'<svg                                                                          '#13#10
+'   xmlns:svg="http://www.w3.org/2000/svg"                                     '#13#10
+'   xmlns="http://www.w3.org/2000/svg"                                         '#13#10
+'   version="1.1"                                                              '#13#10
+'   width="128"                                                                '#13#10
+'   height="128"                                                               '#13#10
+'   id="'+svgDOSSIER_KDE_PAR_POSTE_id+'">                                      '#13#10
+'  <defs                                                                       '#13#10
+'     id="defs6" />                                                            '#13#10
+'  <g                                                                          '#13#10
+'     transform="translate(0.54237508,0.54237303)"                             '#13#10
+'     id="g2818">                                                              '#13#10
+'    <path                                                                     '#13#10
+'       d="m 0,64 0,-64 64,0 64,0 0,64 0,64 -64,0 -64,0 0,-64 z"               '#13#10
+'       id="path2834"                                                          '#13#10
+'       style="fill:#f8f8f9" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 22.042854,111.61271 c -0.825715,-2.17179 -1.587838,-2.42163 -8.443057,-2.7678'
+'C 5.2217396,108.42183 3.7414404,107.5388 3.4149239,102.76937 1.9822955,81.842979 -'
+'0.18532385,30.925329 0.30234415,29.654487 0.76378622,28.451988 2.1751566,28 5.4686152,28'
+'L 10,28 10,19.2 C 10,13.688889 10.448485,9.9515152 11.2,9.2 12.006319,8.3936805 16.532678'
+',8 24.997052,8 l 12.597052,0 3.893912,3.987727 3.893911,3.987727 36.059037,0.262273 L 117'
+'.5,16.5 l 0.2999,5.75 0.29991,5.75 4.48148,0 c 3.19253,0 4.65873,0.461918 5.09777,1.'
+'606021 1.06513,2.775701 -2.97266,75.413239 -4.29242,77.218119 -0.86489,1.18281 -3.24'
+'199,1.73069 -8.70617,2.00661 -6.95095,0.35101 -7.56166,0.55974 -8.11751,2.77441 L 10'
+'5.9619,114 l -41.505703,0 -41.505699,0 -0.907644,-2.38729 z m 83.780466,-1.14876 C 1'
+'05.3874,108.39295 74.579748,87.88596 74.212771,89.422509 73.835555,91.001926 68.2038'
+'33,93 64.129342,93 60.821827,93 55.449285,90.761759 54.840347,89.130135 54.361118,87'
+'.846061 23.570825,108.59143 23.176676,110.46395 22.889991,111.82594 27.572721,112 64'
+'.5,112 c 36.92728,0 41.61001,-0.17406 41.32332,-1.53605 z M 23.739318,70.708412 C 23'
+'.544641,67.293785 23.386791,70.35 23.38854,77.5 c 0.0017,7.15 0.161031,9.943785 0.35'
+'3958,6.208412 0.192928,-3.735374 0.191497,-9.585374 -0.0032,-13 z m 45.35639,17.5759'
+'8 C 70.693069,87.340808 72,86.185166 72,85.716298 72,85.247431 70.693033,85.794454 6'
+'9.09563,86.931906 67.498226,88.069358 65.430192,89 64.5,89 63.569808,89 61.501774,88'
+'.069358 59.90437,86.931906 58.306967,85.794454 57,85.240226 57,85.700289 c 0,1.2213'
+'5 5.19278,4.242063 7.345708,4.273102 1.015139,0.01463 3.152639,-0.745414 4.75,-1.68'
+'8999 z M 78.5,81.898766 c 2.2,-1.562757 8.725,-6.225543 14.5,-10.361747 5.775,-4.13'
+'6204 11.0625,-7.524117 11.75,-7.528695 0.6875,-0.0046 1.25,-0.67361 1.25,-1.486738 0'
+',-1.276439 -5.66959,-1.515516 -41.500327,-1.75 -38.96102,-0.254968 -41.500307,-0.164'
+'508 -41.5,1.478414 1.8e-4,0.9625 0.589233,1.75 1.309007,1.75 1.156233,0 9.373713,5.6'
+'12889 25.130211,17.165006 4.90955,3.599512 4.998663,3.620888 15,3.59808 C 73.869732,'
+'84.741579 74.750576,84.562147 78.5,81.898766 z M 105.73221,69.75 c -0.21054,-2.3375 -'
+'0.3828,-0.425 -0.3828,4.25 0,4.675 0.17226,6.5875 0.3828,4.25 0.21053,-2.3375 0.21053'
+',-6.1625 0,-8.5 z"                                                            '#13#10
+'       id="path2832"                                                          '#13#10
+'       style="fill:#d0d0d0" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 23.5,113 c -0.408241,-0.66055 13.509288,-1 41,-1 27.490712,0 41.40824,0.3394'
+'5 41,1 -0.39551,0.63995 -15.157379,1 -41,1 -25.842621,0 -40.604486,-0.36005 -41,-1 z m -'
+'1.267959,-3.6407 C 22.09173,108.66954 19.041906,108.06922 14.517147,107.84073 9.209038,1'
+'07.57269 6.5429778,106.97155 5.3437731,105.77234 3.9111767,104.33975 3.3719683,99.15515'
+'8 1.8096317,71.790912 0.79564065,54.03091 0.08615902,37.025 0.23300582,34 L 0.5,28.5 5.'
+'25,28.195209 10,27.890418 10,19.145209 C 10,13.676713 10.449624,9.950376 11.2,9.2 12.00'
+'3488,8.3965121 16.471632,8 24.722343,8 l 12.322343,0 4.325606,3.987204 4.325605,3.98720'
+'4 35.902052,0.262796 L 117.5,16.5 l 0.2999,5.75 0.29991,5.75 4.48148,0 c 3.20816,0 4.65'
+'807,0.460183 5.10299,1.619626 0.63989,1.667524 -2.35955,66.347925 -3.34327,72.094744 -0'
+'.78269,4.57244 -2.47735,5.54143 -10.89552,6.22999 L 106,108.55336 106,84.276678 106,60 6'
+'4.517171,60 23.034342,60 22.749212,85.25 c -0.156821,13.8875 -0.389548,24.73668 -0.51717'
+'1,24.1093 z M 63.270833,91.395833 c 0.332292,-0.332291 1.194792,-0.367818 1.916667,-0.07'
+'895 0.797733,0.319226 0.560776,0.556183 -0.604167,0.604167 -1.054166,0.04342 -1.644791,-'
+'0.192928 -1.3125,-0.52522 z M 59,89.5 c -1.375,-0.786021 -2.023508,-1.445075 -1.44113,-1'
+'.464565 0.582379,-0.01949 1.932379,0.625253 3,1.432762 C 63.027847,91.335637 62.239254,9'
+'1.351725 59,89.5 z m 9.44113,0.05517 C 69.508751,88.699825 70.821251,88 71.357796,88 72.'
+'628339,88 72.061032,88.4619 69,89.919712 66.642732,91.042357 66.610824,91.021544 68.4411'
+'3,89.555166 z M 52.663051,87.435692 C 52.978664,86.613218 50.445601,84.105248 46.088233,'
+'80.926007 37.41843,74.600309 36.65507,73.277308 45.099692,79.212739 48.454522,81.570733 5'
+'2.278718,84.175 53.597905,85 c 2.902899,1.815431 3.01814,2.605638 0.476913,3.270184 -1.32'
+'28,0.34592 -1.764537,0.08481 -1.411767,-0.834492 z M 74.75,88.310674 c -0.9625,-0.251527 -'
+'1.722922,-0.761826 -1.689827,-1.133998 0.05219,-0.586868 20.099985,-15.154966 26.248086,-1'
+'9.07365 4.374051,-2.787937 -4.042653,4.088169 -13.590023,11.1025 -5.954536,4.374722 -9.585'
+'985,7.696731 -9.281385,8.490506 0.275209,0.717182 0.402003,1.251767 0.281764,1.187967 C 76'
+'.598377,88.820198 75.7125,88.562202 74.75,88.310674 z M 35.404988,72.75 33.5,70.5 35.75,72'
+'.404988 C 37.864445,74.195206 38.455241,75 37.654988,75 c -0.189757,0 -1.202257,-1.0125 -2'
+'.25,-2.25 z"                                                                  '#13#10
+'       id="path2830"                                                          '#13#10
+'       style="fill:#facf92" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 23.5,113 c -0.408241,-0.66055 13.509288,-1 41,-1 27.490712,0 41.40824,0.3394'
+'5 41,1 -0.39551,0.63995 -15.157379,1 -41,1 -25.842621,0 -40.604486,-0.36005 -41,-1 z m -'
+'1.267959,-3.6407 c -0.140311,-0.68976 -3.190135,-1.29008 -7.714894,-1.51857 -5.634123,-0'
+'.28451 -7.9194477,-0.83526 -9.2499998,-2.2292 -1.3103793,-1.3728 -1.4394346,-1.97265 -0.'
+'4992901,-2.32071 C 7.5087441,102.27608 9,99.68189 9,95.928571 9,92.430091 8.7327669,92 6'
+'.559017,92 5.2164763,92 3.905938,91.656822 3.6467096,91.237381 2.8510884,89.950039 -0.29'
+'824554,31.219599 0.33925859,29.55829 0.75899638,28.46447 2.2878742,28 5.4686152,28 L 10,'
+'28 10,19.2 C 10,13.688889 10.448485,9.9515152 11.2,9.2 12.003488,8.3965121 16.471632,8 2'
+'4.722343,8 l 12.322343,0 4.339488,4 4.339487,4 34.93817,0 c 25.840799,0 35.250629,0.3124'
+'62 36.138169,1.2 0.66,0.66 1.2,3.36 1.2,6 l 0,4.8 4.53138,0 c 3.24032,0 4.70716,0.45805'
+'9 5.14832,1.607698 0.64649,1.684731 -2.52397,60.331311 -3.33224,61.639119 C 124.09144,9'
+'1.661068 122.78352,92 121.44098,92 119.26723,92 119,92.430091 119,95.928571 c 0,3.75331'
+'9 1.49126,6.347509 4.23214,7.362249 0.94938,0.35148 0.84223,0.91616 -0.42653,2.24796 -1'
+'.19746,1.25695 -3.91028,1.95981 -9.25,2.39657 L 106,108.55336 106,84.276678 106,60 64.5'
+'17171,60 23.034342,60 22.749212,85.25 c -0.156821,13.8875 -0.389548,24.73668 -0.517171,'
+'24.1093 z M 95.25,29.250525 c -17.1875,-0.15346 -45.3125,-0.15346 -62.5,0 -17.1875,0.15'
+'346 -3.125,0.279019 31.25,0.279019 34.375,0 48.4375,-0.125559 31.25,-0.279019 z M 30.78'
+'9188,9.2621809 c -3.140947,-0.1978075 -8.540947,-0.1994253 -12,-0.0036 C 15.330134,9.45'
+'4416 17.9,9.6162585 24.5,9.6182359 c 6.6,0.00198 9.430134,-0.1582474 6.289188,-0.35605'
+'5 z M 63.270833,91.395833 c 0.332292,-0.332291 1.194792,-0.367818 1.916667,-0.07895 0.'
+'797733,0.319226 0.560776,0.556183 -0.604167,0.604167 -1.054166,0.04342 -1.644791,-0.19'
+'2928 -1.3125,-0.52522 z M 59,89.5 c -1.375,-0.786021 -2.023508,-1.445075 -1.44113,-1.4'
+'64565 0.582379,-0.01949 1.932379,0.625253 3,1.432762 C 63.027847,91.335637 62.239254,9'
+'1.351725 59,89.5 z m 9.44113,0.05517 C 69.508751,88.699825 70.821251,88 71.357796,88 7'
+'2.628339,88 72.061032,88.4619 69,89.919712 66.642732,91.042357 66.610824,91.021544 68.'
+'44113,89.555166 z M 52.663051,87.435692 C 52.978664,86.613218 50.445601,84.105248 46.0'
+'88233,80.926007 37.41843,74.600309 36.65507,73.277308 45.099692,79.212739 48.454522,81'
+'.570733 52.278718,84.175 53.597905,85 c 2.902899,1.815431 3.01814,2.605638 0.476913,3.'
+'270184 -1.3228,0.34592 -1.764537,0.08481 -1.411767,-0.834492 z M 74.75,88.310674 c -0.'
+'9625,-0.251527 -1.722922,-0.761826 -1.689827,-1.133998 0.05219,-0.586868 20.099985,-15'
+'.154966 26.248086,-19.07365 4.374051,-2.787937 -4.042653,4.088169 -13.590023,11.1025 -'
+'5.954536,4.374722 -9.585985,7.696731 -9.281385,8.490506 0.275209,0.717182 0.402003,1.2'
+'51767 0.281764,1.187967 C 76.598377,88.820198 75.7125,88.562202 74.75,88.310674 z M 35'
+'.404988,72.75 33.5,70.5 35.75,72.404988 C 37.864445,74.195206 38.455241,75 37.654988,7'
+'5 c -0.189757,0 -1.202257,-1.0125 -2.25,-2.25 z"                              '#13#10
+'       id="path2828"                                                          '#13#10
+'       style="fill:#fdc476" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 23.5,113 c -0.408241,-0.66055 13.509288,-1 41,-1 27.490712,0 41.40824,0.3394'
+'5 41,1 -0.39551,0.63995 -15.157379,1 -41,1 -25.842621,0 -40.604486,-0.36005 -41,-1 z m -'
+'1.267959,-3.75 c -0.155928,-0.83998 -2.282135,-1.25484 -6.482041,-1.26474 -6.2858589,-0.'
+'0148 -10.7509459,-1.45072 -11.4910465,-3.69531 -0.2873725,-0.87154 2.068323,-1.29115 8.4'
+'210315,-1.5 L 21.5,102.5 21.807964,97.672306 C 22.217045,91.259492 20.997263,90 14.37755'
+'5,90 9.6666667,90 9,89.752056 9,88 9,86.526721 8.3333333,86 6.4686152,86 5.0763536,86 3.'
+'7541024,85.4375 3.5302792,84.75 2.2838989,80.921592 -0.44377472,28.144482 0.67479943,29.'
+'5 1.2088675,30.147198 23.550134,30.5 64,30.5 c 40.44987,0 62.79113,-0.352802 63.3252,-1 1'
+'.11857,-1.355518 -1.6091,51.421592 -2.85548,55.25 C 124.2459,85.4375 122.92365,86 121.531'
+'38,86 119.68931,86 119,86.530378 119,87.94774 c 0,1.644607 -0.81708,1.994783 -5.25,2.2'
+'5 L 108.5,90.5 l -0.29772,6.25 -0.29771,6.25 8.04771,0 c 4.42625,0 8.04772,0.3949 8.04772'
+',0.87756 0,2.10282 -3.62638,3.50012 -10.55451,4.0668 L 106,108.55336 106,84.276678 106,6'
+'0 64.517171,60 23.034342,60 22.749212,85.25 c -0.156821,13.8875 -0.389548,24.6875 -0.517'
+'171,24 z M 63.270833,91.395833 c 0.332292,-0.332291 1.194792,-0.367818 1.916667,-0.0789'
+'5 0.797733,0.319226 0.560776,0.556183 -0.604167,0.604167 -1.054166,0.04342 -1.644791,-0.19'
+'2928 -1.3125,-0.52522 z M 59,89.5 c -1.375,-0.786021 -2.023508,-1.445075 -1.44113,-1.46456'
+'5 0.582379,-0.01949 1.932379,0.625253 3,1.432762 C 63.027847,91.335637 62.239254,91.35172'
+'5 59,89.5 z m 9.44113,0.05517 C 69.508751,88.699825 70.821251,88 71.357796,88 72.628339,8'
+'8 72.061032,88.4619 69,89.919712 66.642732,91.042357 66.610824,91.021544 68.44113,89.5551'
+'66 z M 52.663051,87.435692 C 52.978664,86.613218 50.445601,84.105248 46.088233,80.926007 3'
+'7.41843,74.600309 36.65507,73.277308 45.099692,79.212739 48.454522,81.570733 52.278718,84.'
+'175 53.597905,85 c 2.902899,1.815431 3.01814,2.605638 0.476913,3.270184 -1.3228,0.34592 -1'
+'.764537,0.08481 -1.411767,-0.834492 z M 74.75,88.310674 c -0.9625,-0.251527 -1.722922,-0.7'
+'61826 -1.689827,-1.133998 0.05219,-0.586868 20.099985,-15.154966 26.248086,-19.07365 4.374'
+'051,-2.787937 -4.042653,4.088169 -13.590023,11.1025 -5.954536,4.374722 -9.585985,7.696731 -'
+'9.281385,8.490506 0.275209,0.717182 0.402003,1.251767 0.281764,1.187967 C 76.598377,88.8201'
+'98 75.7125,88.562202 74.75,88.310674 z M 35.404988,72.75 33.5,70.5 35.75,72.404988 C 37.864'
+'445,74.195206 38.455241,75 37.654988,75 c -0.189757,0 -1.202257,-1.0125 -2.25,-2.25 z M 5.7'
+'5,28.267795 10,27.885004 10,19.142502 C 10,13.676112 10.449681,9.9503194 11.2,9.2 11.999006'
+',8.4009938 16.380271,8 24.31122,8 L 36.222439,8 41,12 l 4.777561,4 34.911219,0 c 25.81984,'
+'0 35.22372,0.312497 36.11122,1.2 0.66,0.66 1.2,3.334126 1.2,5.942502 l 0,4.742502 4.25,0.3'
+'82791 c 2.3375,0.210535 -23.875,0.382791 -58.25,0.382791 -34.375,0 -60.5875,-0.172256 -58.'
+'25,-0.382791 z M 116.8075,21.75 116.5,17.5 80.524733,17.237125 44.549465,16.974249 40.4540'
+'53,12.954907 36.358641,8.9355637 23.929321,9.2177819 11.5,9.5 11.209558,17.75 10.919115,2'
+'6 l 53.09794,0 53.097945,0 -0.3075,-4.25 z"                                   '#13#10
+'       id="path2826"                                                          '#13#10
+'       style="fill:#acabaa" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 43.683033,112.25141 c 11.100669,-0.16082 29.550669,-0.16103 41,-4.7e-4 11.44933'
+'2,0.16055 2.366967,0.29213 -20.183033,0.29239 -22.55,2.6e-4 -31.917635,-0.13111 -20.816967,'
+'-0.29192 z M 7.4455692,104.58386 c -1.7379092,-1.27079 -1.0901291,-1.45041 6.3112188,-1.75 7'
+'.316364,-0.29615 8.247644,-0.13621 8.245561,1.41614 -0.002,1.48149 -0.970333,1.75 -6.311219,'
+'1.75 -3.86346,0 -7.0595601,-0.54892 -8.2455608,-1.41614 z M 106.96383,105.25 C 106.4966,95.5'
+'62939 106.25947,86.747772 106.14308,74.739028 L 106,59.978057 64.25,60.239028 22.5,60.5 22,7'
+'6.5 C 21.725,85.3 21.135942,91.9375 20.690983,91.25 20.207052,90.502285 17.695627,90 14.4409'
+'83,90 9.6666667,90 9,89.754946 9,88 9,86.526721 8.3333333,86 6.4686152,86 5.0763536,86 3.754'
+'1024,85.4375 3.5302792,84.75 2.2838989,80.921592 -0.44377472,28.144482 0.67479943,29.5 1.208'
+'8675,30.147198 23.550134,30.5 64,30.5 c 40.44987,0 62.79113,-0.352802 63.3252,-1 1.11857,-1.'
+'355518 -1.6091,51.421592 -2.85548,55.25 C 124.2459,85.4375 122.92365,86 121.53138,86 119.689'
+'31,86 119,86.530378 119,87.94774 c 0,1.644607 -0.81708,1.994783 -5.25,2.25 L 108.5,90.5 l -0'
+'.29772,6.25 -0.29771,6.25 7.29771,0.0318 c 6.63475,0.0289 7.12137,0.16519 5.35659,1.5 -2.009'
+'67,1.52004 -13.52702,2.12848 -13.59504,0.7182 z M 5.75,28.267795 10,27.885004 10,19.142502 C 1'
+'0,13.676112 10.449681,9.9503194 11.2,9.2 11.999006,8.4009938 16.380271,8 24.31122,8 L 36.22243'
+'9,8 41,12 l 4.777561,4 34.911219,0 c 25.81984,0 35.22372,0.312497 36.11122,1.2 0.66,0.66 1.2,3'
+'.334126 1.2,5.942502 l 0,4.742502 4.25,0.382791 c 2.3375,0.210535 -23.875,0.382791 -58.25,0.38'
+'2791 -34.375,0 -60.5875,-0.172256 -58.25,-0.382791 z M 116.8075,21.75 116.5,17.5 80.524733,17.'
+'237125 44.549465,16.974249 40.454053,12.954907 36.358641,8.9355637 23.929321,9.2177819 11.5,9.'
+'5 11.209558,17.75 10.919115,26 l 53.09794,0 53.097945,0 -0.3075,-4.25 z"      '#13#10
+'       id="path2824"                                                          '#13#10
+'       style="fill:#eeae5f" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 43.683033,112.25141 c 11.100669,-0.16082 29.550669,-0.16103 41,-4.7e-4 11.449332,0'
+'.16055 2.366967,0.29213 -20.183033,0.29239 -22.55,2.6e-4 -31.917635,-0.13111 -20.816967,-0.291'
+'92 z M 8,105 c -1.0399349,-0.67206 0.8770033,-0.97407 6.25,-0.98469 4.510209,-0.009 7.75,0.402'
+'73 7.75,0.98469 0,1.28633 -12.0095479,1.28633 -14,0 z m 98.59565,-0.61134 c -0.45257,-1.17937 -'
+'0.19124,-1.44745 0.9748,-1 0.87622,0.33624 4.36882,0.61823 7.76134,0.62665 4.3515,0.0108 5.7264'
+'2,0.30082 4.66821,0.98469 -0.825,0.53316 -4.03936,0.97627 -7.14301,0.98469 -4.27654,0.0116 -5.7'
+'9274,-0.37488 -6.26134,-1.59603 z M 107.13618,74.25 107,60 64.531735,60 22.063471,60 21.781735,'
+'71.75 21.5,83.5 15.75,83.799904 10,84.099808 9.875,81.049904 C 9.80625,79.372457 9.6375,77.55 9'
+'.5,77 9.3625,76.45 9.19375,73.975 9.125,71.5 9.0055837,67.201013 8.8668422,67 6.019052,67 3.740'
+'9785,67 2.921431,66.469475 2.5432843,64.75 2.1139085,62.797581 0,35.420921 0,31.812609 0,30.742'
+'803 11.838564,30.5 64,30.5 c 52.16144,0 64,0.242803 64,1.312609 0,3.608312 -2.11391,30.984972 -'
+'2.54328,32.937391 -0.37815,1.719475 -1.1977,2.25 -3.47577,2.25 -2.84779,0 -2.98653,0.201013 -3.'
+'10595,4.5 -0.0687,2.475 -0.2375,4.95 -0.375,5.5 -0.1375,0.55 -0.30625,2.35 -0.375,4 -0.12128,2.'
+'910789 -0.27162,3 -5.05545,3 -4.31799,0 -4.98428,0.279496 -5.36382,2.25 -0.23835,1.2375 -0.4946'
+'5,-4.1625 -0.56955,-12 z m -96.968077,-49.5 0.168103,-4.25 0.392262,3.75 0.392263,3.75 52.87008'
+'3,0 52.870086,0 0.43337,-2.25 c 0.37157,-1.929146 0.45279,-1.857845 0.56955,0.5 L 118,29 64,29 1'
+'0,29 10.168103,24.75 z"                                                       '#13#10
+'       id="path2822"                                                          '#13#10
+'       style="fill:#f1991e" />                                                '#13#10
+'    <path                                                                     '#13#10
+'       d="m 43.683033,112.25141 c 11.100669,-0.16082 29.550669,-0.16103 41,-4.7e-4 11.449332,0.16'
+'055 2.366967,0.29213 -20.183033,0.29239 -22.55,2.6e-4 -31.917635,-0.13111 -20.816967,-0.29192 z M 8'
+',105 c -1.0399349,-0.67206 0.8770033,-0.97407 6.25,-0.98469 4.510209,-0.009 7.75,0.40273 7.75,0.984'
+'69 0,1.28633 -12.0095479,1.28633 -14,0 z m 98.59565,-0.61134 c -0.45257,-1.17937 -0.19124,-1.44745 0'
+'.9748,-1 0.87622,0.33624 4.36882,0.61823 7.76134,0.62665 4.3515,0.0108 5.72642,0.30082 4.66821,0.984'
+'69 -0.825,0.53316 -4.03936,0.97627 -7.14301,0.98469 -4.27654,0.0116 -5.79274,-0.37488 -6.26134,-1.59'
+'603 z"                                                                        '#13#10
+'       id="path2820"                                                          '#13#10
+'       style="fill:#636364" />                                                '#13#10
+'  </g>                                                                        '#13#10
+'</svg>                                                                        '#13#10
     ;
end;

initialization
              Clean_CreateD( FfBitmaps, TfBitmaps);
finalization
              Clean_Destroy( FfBitmaps);
end.

