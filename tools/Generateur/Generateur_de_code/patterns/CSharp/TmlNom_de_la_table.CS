/*                                                                              |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright © 2004-2006, 2014, Jean SUZINEAU - MARS42                         |
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
/*
 * umlNom_de_la_table
 * Copyright © 2004-2006, 2014, Jean SUZINEAU
 * 
 */

using System; 
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using jsDatabase;
using jsFormes;

namespace Patterns_from_MCD_StarUML_CSharp
{
	/// <summary>
	/// Description of umlNom_de_la_table.
	/// </summary>
	public class TmlNom_de_la_table : TMars42_Ligne
	{
	  #region logique de classe
	  static public TMars42_Pool pool= new TMars42_Pool( "Nom_de_la_table", typeof(TmlNom_de_la_table));
	  static public TfMaitre     fm  = new TfMaitre( pool);
	  static public TdkDetail    dkd = new TdkDetail();
		public static TmlNom_de_la_table Get( UInt32 _Numero)
		  {                
		  return pool.mlGet( _Numero) as TmlNom_de_la_table;
		  }
	  #endregion    
	  
		#region logique d'instance
//Point d'insertion champs persistants		
//Point d'insertion aggrégations faibles, pointeurs vers conteneurs
//Point d'insertion aggrégations faibles, listes de contenus
		
		public TmlNom_de_la_table( UInt32 _Numero)
		  :base( _Numero)
			{                                    
//Point d'insertion Chargement des conteneurs		  
			}
		#endregion
	}
}