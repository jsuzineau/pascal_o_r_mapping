program OpenDocument_DelphiReportEngine;
{                                                                             |
    Utility for displaying the text fields of an Open Document text document  |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                          |
            partly as freelance: http://www.mars42.com                        |
        and partly as employee : http://www.batpro.com                        |
    Contact: gilles.doutre@batpro.com                                         |
                                                                              |
    Copyright (C) 2004-2008  Jean SUZINEAU - MARS42                           |
    Copyright (C) 2004-2008  Cabinet Gilles DOUTRE - BATPRO                   |
                                                                              |
    This program is free software; you can redistribute it and/or             |
    modify it under the terms of the GNU Lesser General Public                |
    License as published by the Free Software Foundation; either              |
    version 2 of the License, or (at your option) any later version.          |
                                                                              |
    This program is distributed in the hope that it will be useful,           |
    but WITHOUT ANY WARRANTY; without even the implied warranty of            |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU         |
    Lesser General Public License for more details.                           |
                                                                              |
    You should have received a copy of the GNU Lesser General Public          |
    License along with this library; if not, write to the Free Software       |
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA |
|                                                                             }

uses
  Forms,
  ufOpenDocument_DelphiReportEngine;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfOpenDocument_DelphiReportEngine, fOpenDocument_DelphiReportEngine);
  Application.Run;
end.
