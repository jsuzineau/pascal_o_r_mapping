<?php
/**                                                                             |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
    Contact: Jean.Suzineau@wanadoo.fr                                           |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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
|                                                                             **/
//upoolNom_de_la_table.php
require_once  "uPool.php";

class TpoolNom_de_la_table extends TPool
  {
  var $ClasseLigne= "TNom_de_la_table";
  var $NomTable="Nom_de_la_table";
/** exemple 
  function Get_by_Cle( $_Nom)
    {
    $this->Recherche( "select * from $this->NomTable where nom = '$_Nom'");
    return reset( $this->Lignes);
    }
**/
  }
?>

