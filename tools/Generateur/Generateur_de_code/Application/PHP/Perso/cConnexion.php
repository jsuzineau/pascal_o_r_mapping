<?php
/**                                                                           |
                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr> http://www.mars42.com    |
                                                                              |
    Copyright (C) 2002-2017  Jean SUZINEAU - MARS42                           |
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
|                                                                           **/
//nom original cMySQL_Link.php
//require_once  "cXMIable.php";

class cConnexion //extends cXMIable
  {
  var $NomServeur= "localhost";
  var $UserName="root";
  var $Password="";
  var $NomDatabase= "jean-suzineau-agenda-fbu";
  var $pdo=0;
  var $NomTable="";
  var $ResultatRequete= 0;
  function __construct()
    {
    //parent::__construct();
    }
  function Erreur( $Message)
    {
    $s=$Message;
    if ($this->pdo) $s.=$this->pdo->errorInfo();
    return die( $s);
    }
  function Ouverture()
    {
    //si la connexion est d�j� ouverte, on sort
    if ($this->pdo)
       return;

    try
      {
      $this->pdo
      =
          new PDO(  "mysql:"
                   ."host=$this->NomServeur;dbname=$this->NomDatabase",
                   $this->UserName,$this->Password);
       $this->pdo->exec("set names utf8");
       $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      }
    catch (PDOException $e)
      {
      echo "Echec de la connexion: ".$e.getMessage();
      }
    }
  function Fermeture()
    {
    $this->pdo= null;
    }
  function Requete( $sql)
    {
    //echo "<br>cConnexion.Requete('$sql')<br>";
    if (!$this->pdo)
       $this->Erreur( "cConnexion::Requete : connection non ouverte");

    $this->ResultatRequete= $this->pdo->query($sql)
                            or $this->Erreur( "Echec de pdo_query");

    return $this->ResultatRequete;
    }
  }

//convertit une chaine en
function Echappe_HTML( $Chaine)
 {
 $Resultat= "";
 for ($I= 0; $I < strlen( $Chaine); $I++)
     $Resultat.= "%".dechex(ord($Chaine[$I]));
 return $Resultat;
 }

function Date_SQL( $D)
  {
  /* doc getdate()
  � "seconds" - seconds
  � "minutes" - minutes
  � "hours" - hours
  � "mday" - day of the month
  � "wday" - day of the week, numeric
  � "mon" - month, numeric
  � "year" - year, numeric
  � "yday" - day of the year, numeric; i.e. "299"
  � "weekday" - day of the week, textual, full; i.e. "Friday"
  � "month" - month, textual, full; i.e. "January"
  "01/01/2002 00:00:00",
  */
  $Resultat= $D["year"]."-".$D["mon"]."-".$D["mday"]." ".
             $D["hours"].":".$D["minutes"].":".$D["seconds"];
  return $Resultat;
  }

?>
