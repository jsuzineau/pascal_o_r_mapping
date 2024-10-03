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
// uStrings.php
function pstrtok( $key, &$string)
  {
  $iPos= strpos( $string, $key);
  $Len
  = 
   ($iPos === FALSE) 
   ?
    strlen( $string)
   :
    $iPos;
  $Result= substr( $string, 0, $Len);   
  $string
  = 
   ($iPos === FALSE) 
   ?
    ""
   :
    substr( $string, $iPos+strlen($key));  
   return $Result;  
  }


function test_pstrtok_start()
  {
  echo "<table>";
  }


function test_pstrtok_stop()
  {
  echo "</table>";
  }


function test_pstrtok( $key, $string)
  {
  $string_initial= $string;  
  $Result= pstrtok( $key, $string);
  echo <<<"EOT"
  <tr>
    <td>
    pstrtok( $key, $string_initial)
    </td>
    <td>
    \$Result=$Result
    </td>
    <td>
    \$string=$string
    </td>
  </tr>
EOT;
  }

?>