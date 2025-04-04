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
class Development extends Doctrine_Record
{
    public function setTableDefinition()
    {
        $this->setTableName('development');

        $this->hasColumn('id', 'integer', 8, array('primary' => true,
						   'autoincrement' => true));
        $this->hasColumn('nProject', 'integer');

        $this->hasColumn('nState', 'integer');

        $this->hasColumn('nCreationWork', 'integer');

        $this->hasColumn('nSolutionWork', 'integer');

        $this->hasColumn('Description', 'string', 42);

        $this->hasColumn('Steps', 'string', 42);

        $this->hasColumn('Origin', 'string', 42);

        $this->hasColumn('Solution', 'string', 42);

        $this->hasColumn('nCategorie', 'integer');

        $this->hasColumn('isBug', 'integer');

        $this->hasColumn('nDemander', 'integer');

        $this->hasColumn('nSheetRef', 'integer');

    }
    public function setUp()
        {


        }

}
?>
