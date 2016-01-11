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
 * umlTULEAP_Project
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
	/// Description of umlTULEAP_Project.
	/// </summary>
	public class TmlTULEAP_Project : TMars42_Ligne
	{
	  #region logique de classe
	  static public TMars42_Pool pool= new TMars42_Pool( "TULEAP_Project", typeof(TmlTULEAP_Project));
	  static public TfMaitre     fm  = new TfMaitre( pool);
	  static public TdkDetail    dkd = new TdkDetail();
		public static TmlTULEAP_Project Get( UInt32 _Numero)
		  {                
		  return pool.mlGet( _Numero) as TmlTULEAP_Project;
		  }
	  #endregion    
	  
		#region logique d'instance
		#region Champs persistants

		public string  uri;
		public string _uri {get{return uri;} set{uri= value;}}

		public string  label;
		public string _label {get{return label;} set{label= value;}}

		public string  shortname;
		public string _shortname {get{return shortname;} set{shortname= value;}}

		public string  resources;
		public string _resources {get{return resources;} set{resources= value;}}

		public string  additional_informations;
		public string _additional_informations {get{return additional_informations;} set{additional_informations= value;}}


		#endregion
		


		
		public TmlTULEAP_Project( UInt32 _Numero)
		  :base( _Numero)
			{                                    
		  
			}
		#endregion
	}
}
