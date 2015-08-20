<?php
/*                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
|                                                                              */
class g_ctrcir extends Doctrine_Record
{
    public function setTableDefinition()
    {
        $this->setTableName('g_ctrcir');

        $this->hasColumn('id', 'integer', 8, array('primary' => true,
						   'autoincrement' => true));
        $this->hasColumn('soc', 'string', 42);

        $this->hasColumn('ets', 'string', 42);

        $this->hasColumn('type', 'string', 42);

        $this->hasColumn('circuit', 'string', 42);

        $this->hasColumn('no_reference', 'string', 42);

        $this->hasColumn('d1', 'string', 42);

        $this->hasColumn('d2', 'string', 42);

        $this->hasColumn('d3', 'string', 42);

        $this->hasColumn('ok_d1', 'string', 42);

        $this->hasColumn('ok_d2', 'string', 42);

        $this->hasColumn('ok_d3', 'string', 42);

        $this->hasColumn('date_ok1', 'float');

        $this->hasColumn('date_ok2', 'float');

        $this->hasColumn('date_ok3', 'float');

    }
    public function setUp()
        {


        }

}
?>
