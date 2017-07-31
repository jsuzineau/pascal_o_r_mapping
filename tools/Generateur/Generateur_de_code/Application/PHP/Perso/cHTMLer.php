<?php
/*                                                                            |
                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr> http://www.mars42.com    |
                                                                              |
    Copyright (C) 2002  Jean SUZINEAU - MARS42                                |
                                                                              |
    This program is free software; you can redistribute it and/or modify      |
    it under the terms of the GNU General Public License as published by      |
    the Free Software Foundation; either version 2 of the License, or         |
    (at your option) any later version.                                       |
                                                                              |
    This program is distributed in the hope that it will be useful,           |
    but WITHOUT ANY WARRANTY; without even the implied warranty of            |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             |
    GNU General Public License for more details.                              |
                                                                              |
    You should have received a copy of the GNU General Public License         |
    along with this program; if not, write to the Free Software               |
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA |
|                                                                            */
include_once  "cXMIable.php";

class cHTMLer extends cXMIable
  {
  var $Entete_sorti= 0;
  function Entete()
    {
    $this->Entete_sorti= 1;
    return "";
    }
  function ListeDebut_virtuel()
    {
    return "<pre><table border=\"1\" width=\"50%\">";
    }
  function ListeDebut()
    {
    if (!$this->Entete_sorti)
       $Resultat= $this->Entete();
    else
       $Resultat= "";
    $Resultat.= $this->ListeDebut_virtuel();
    return $Resultat;
    }
  function ListeFin()
    {
    return "</table></pre>";
    }
  function LigneDebut()
    {
    return "<tr>";
    }
  function LigneFin()
    {
    return "</tr>\n";
    }
  function ChampDebut()
    {
    return "<td>";
    }
  function ChampFin()
    {
    return "</td>\n";
    }
  function Lien( $Target, $Lien, $Libelle)
    {
    $Resultat= "<A HREF=\"$Lien\"";
    if ($Target && ($Target <> ""))
       $Resultat.= " TARGET=\"$Target\"";
    $Resultat.= ">$Libelle</A>";
    return $Resultat;
    }
  }
?>
