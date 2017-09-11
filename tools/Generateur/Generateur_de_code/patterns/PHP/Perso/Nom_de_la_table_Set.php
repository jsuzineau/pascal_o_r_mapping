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
// Nom_de_la_table_Set.php
require_once "uSession.php";
if (not_Session_ok()) exit();

require_once "upoolNom_de_la_table.php";

$json_Parametre = file_get_contents('php://input');

$id=$_GET["id"];

$poolNom_de_la_table= new TpoolNom_de_la_table();

$poolNom_de_la_table->Ecrire_json( $id, $json_Parametre);

$json_Resultat= $poolNom_de_la_table->json_Charge_Ligne( $id);

echo $json_Resultat;
?>




