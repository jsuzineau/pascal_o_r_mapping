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
 * umlg_ctx
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
	/// Description of umlg_ctx.
	/// </summary>
	public class Tmlg_ctx : TMars42_Ligne
	{
	  #region logique de classe
	  static public TMars42_Pool pool= new TMars42_Pool( "g_ctx", typeof(Tmlg_ctx));
	  static public TfMaitre     fm  = new TfMaitre( pool);
	  static public TdkDetail    dkd = new TdkDetail();
		public static Tmlg_ctx Get( UInt32 _Numero)
		  {                
		  return pool.mlGet( _Numero) as Tmlg_ctx;
		  }
	  #endregion    
	  
		#region logique d'instance
		#region Champs persistants

		public Int32  contexte;
		public Int32 _contexte {get{return contexte;} set{contexte= value;}}

		public string  contextetype;
		public string _contextetype {get{return contextetype;} set{contextetype= value;}}

		public string  libelle;
		public string _libelle {get{return libelle;} set{libelle= value;}}


		#endregion
		


		
		public Tmlg_ctx( UInt32 _Numero)
		  :base( _Numero)
			{                                    
		  
			}
		#endregion
	}
}
