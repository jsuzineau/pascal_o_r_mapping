<?php
/**                                                                           |
                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr> http://www.mars42.com    |
                                                                              |
    Copyright (C) 2017  Jean SUZINEAU - MARS42                                |
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
// uSession.php

// à implémenter dans chaque application
function not_Session_ok()
  {
  global $Session;
  return !($Session);
  }

function not_Session_admin()
  {
  global $Session;
  if (!$Session) return true;

  return ($Session->niveau < 4);
  }

function Calcule_json_Session()
  {
  global $Session;
  global $json_Session;
  $json_Session
  =
  $Session
    ?
      json_encode( $Session)
    :
      "";

  }

function Session_set( $_Session)
  {
  global $Session;
  $Session= $_Session;
  if ($Session)
    {
    $Session->SID= session_id();
    }
  $_SESSION['Session']= $_Session;
  Calcule_json_Session();
  error_log( "uSession.php::Session_set: \$Session=".json_encode( $Session));
  error_log( "uSession.php::Session_set: \$_SESSION['Session']=".json_encode( $_SESSION['Session']));
  }

function Log_Request()
  {
  global $_GET;
  global $_SERVER;
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  error_log( "                                                              ");
  /*
  foreach ($_SERVER as $name => $value)
    {
    error_log( "uSession.php: SERVER: $name: $value\n");
    }
  */
  /*
  error_log( $_SERVER["REQUEST_URI"]);
  */
  error_log( "uSession.php: REQUEST_URI: ".$_SERVER["REQUEST_URI"]);


  foreach ($_GET as $name => $value)
    {
    error_log( "uSession.php: GET: $name: $value\n");
    }

  foreach ($_POST as $name => $value)
    {
    error_log( "uSession.php: POST: $name: $value\n");
    }

  /*
  foreach (getallheaders() as $name => $value)
    {
    error_log( "uSession.php: header: $name: $value\n");
    }
  */
  }
function Log_SESSION()
  {
  global $_SESSION;
  foreach ($_SESSION as $name => $value)
    {
    error_log( "uSession.php: \$_SESSION['$name']: ".json_encode( $_SESSION['Session']));
    }
  }

header("Access-Control-Allow-Origin: *");
Log_Request();

if (array_key_exists("SID", $_GET))
  {
  $Request_SID= $_GET["SID"];
  if ("" != $Request_SID)
    {
    session_id($Request_SID);
    }
  }
session_start();

Log_SESSION();

if (!array_key_exists("Session", $_SESSION))
  {
  $Session= null;
  error_log( "uSession.php: session non ouverte");
  }
else
  {
  $Session= $_SESSION['Session'];
  }
Calcule_json_Session( );
?>
