<?php
/*                                                                            |
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
|                                                                            */
//nom original cDataset.php
include_once( "cConnexion.php");
//include_once( "cHTMLer.php");

class cPool extends cConnexion
  {
  var $ClasseLigne= "";
  var $Lignes="";
  var $Noms="";
  var $Types="";
  var $Longueurs="";
  var $Flags="";
  function __construct()
    {
    parent::__construct();
    }
  function Recherche( $SQL="")
    {
    //echo "<br>cPool.Recherche( $SQL)<br>";

    $this->Lignes= array();
    unset( $this->Noms     );
    unset( $this->Types    );
    unset( $this->Longueurs);
    unset( $this->Flags    );


    $this->Ouverture();
    $this->Requete( $SQL);
    while ($ligne = $this->ResultatRequete->fetchObject())
      {
      $truc= &$this->Lignes[$ligne->id];
      if (! isset($truc))
        {
        $this->Lignes[$ligne->id]= new stdClass();
        $truc= &$this->Lignes[$ligne->id];
        }
      foreach (get_object_vars($ligne) as $prop => $val)
              $truc->$prop= $val;
      //$this->Lignes[]=& $ligne;
//echo "cPool dump 0 dans boucle";
//debug_zval_dump(&$this->Lignes[$ligne->id]);
      }
//echo "cPool dump 0 aprés affectation";
//debug_zval_dump(&$this->Lignes[0]);
    if (isset($this->Lignes))
       {
       $NbChamps= $this->ResultatRequete->columnCount();
       for ($I=0; $I < $NbChamps; $I++ )
           {
           $Champ=$this->ResultatRequete->getColumnMeta( $I);
           $Nom=$Champ->name;
           $this->Noms     []= $Nom;
           $this->Types    [$Nom]= $Champ->type;
           $this->Longueurs[$Nom]= $Champ->len;
           $this->Flags    [$Nom]= $Champ->flags;
           }
       }
    //echo "<br>cPool.Recherche( $SQL): ".$this->Lignes[0]."<br>";
    $this->Fermeture();
//echo "cPool dump 0";
//debug_zval_dump(&$this->Lignes[0]);
    //echo "<br>cPool.cPool end \$this= $this<br>";
    }

  function Charge_Table()
    {
    $this->Recherche( "select * from $this->NomTable ");
    }

  function &Charge_Ligne( $id)
    {
    global $Sauve;
    if ($id)
       $this->Recherche( "select * from $this->NomTable where id = $id");
    else
       {
       $this->Ouverture();
       $this->Requete( "insert into $this->NomTable () values ()");
       $id= $this->pdo->lastInsertId();
       $this->Fermeture();
       //echo "<br>$this->NomTable: ligne n°$id créée<br>" ;
       if ($id)
         $this->Recherche( "select * from $this->NomTable where id = $id");
       }
    if (isset( $this->Lignes))
       {
       if (isset( $Sauve))
          {
          echo $_POST."<BR>";
          foreach( get_object_vars( $this->Lignes[$id]) as $NomChamp => $Champ)
            {
            $Valeur= $GLOBALS["$NomChamp"];
            if ( isset( $Valeur))
              $this->Lignes[$id]->$NomChamp = $Valeur;
            }
          $this->Ecrire( $id);
          }
       return $this->Lignes[$id];
       }
    }

  function json_Charge_Ligne( $id)
    {
    return json_encode( Charge_Ligne( $id));
    }

  function &Nouveau()
    {
    return $this->Charge_Ligne( 0);
    }

  function Ecrire_interne( $id, &$Ligne)
    {
    $this->Ouverture();
    $SQL= "update $this->NomTable set ";
    $premier= 1;
    foreach( get_object_vars( $Ligne) as $NomChamp => $Champ)
      {
      if (    ($NomChamp!= "Aggregations")
          and (isset($Champ)             ))
         {
         if ($premier)
            $premier= 0;
         else
            $SQL.= ",";
         $SQL.= " $NomChamp = ";
         if (is_string($Champ))
            $SQL.= "'$Champ'";
         else
            $SQL.= "$Champ";
         }
      }
    $SQL.= " where id = $id ";

    $this->Requete( $SQL);
    $this->Fermeture();
    }
  function Ecrire( $id)
    {
    Ecrire_interne( $id, $this->Lignes[$id]);
    }
  function Ecrire_json( $id, $json)
    {
    $Ligne= json_decode( $json);
    Ecrire_interne( $id, $Ligne);
    }

  function Supprimer( $id)
   {
   $this->Ouverture();
   $this->Requete( "delete from $this->NomTable where id = $id");
   $this->Fermeture();
   }
  }
?>
