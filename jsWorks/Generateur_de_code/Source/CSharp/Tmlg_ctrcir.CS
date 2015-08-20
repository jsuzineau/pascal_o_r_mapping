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
 * umlg_ctrcir
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
	/// Description of umlg_ctrcir.
	/// </summary>
	public class Tmlg_ctrcir : TMars42_Ligne
	{
	  #region logique de classe
	  static public TMars42_Pool pool= new TMars42_Pool( "g_ctrcir", typeof(Tmlg_ctrcir));
	  static public TfMaitre     fm  = new TfMaitre( pool);
	  static public TdkDetail    dkd = new TdkDetail();
		public static Tmlg_ctrcir Get( UInt32 _Numero)
		  {                
		  return pool.mlGet( _Numero) as Tmlg_ctrcir;
		  }
	  #endregion    
	  
		#region logique d'instance
		#region Champs persistants

		public string  soc;
		public string _soc {get{return soc;} set{soc= value;}}

		public string  ets;
		public string _ets {get{return ets;} set{ets= value;}}

		public string  type;
		public string _type {get{return type;} set{type= value;}}

		public string  circuit;
		public string _circuit {get{return circuit;} set{circuit= value;}}

		public string  no_reference;
		public string _no_reference {get{return no_reference;} set{no_reference= value;}}

		public string  d1;
		public string _d1 {get{return d1;} set{d1= value;}}

		public string  d2;
		public string _d2 {get{return d2;} set{d2= value;}}

		public string  d3;
		public string _d3 {get{return d3;} set{d3= value;}}

		public string  ok_d1;
		public string _ok_d1 {get{return ok_d1;} set{ok_d1= value;}}

		public string  ok_d2;
		public string _ok_d2 {get{return ok_d2;} set{ok_d2= value;}}

		public string  ok_d3;
		public string _ok_d3 {get{return ok_d3;} set{ok_d3= value;}}

		public DateTime  date_ok1;
		public DateTime _date_ok1 {get{return date_ok1;} set{date_ok1= value;}}

		public DateTime  date_ok2;
		public DateTime _date_ok2 {get{return date_ok2;} set{date_ok2= value;}}

		public DateTime  date_ok3;
		public DateTime _date_ok3 {get{return date_ok3;} set{date_ok3= value;}}


		#endregion
		


		
		public Tmlg_ctrcir( UInt32 _Numero)
		  :base( _Numero)
			{                                    
		  
			}
		#endregion
	}
}
