unit suPatterns_from_MCD_TLB;
{                                                                               |
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
|                                                                               }

// ************************************************************************ //
// AVERTISSEMENT                                                                 
// -------                                                                    
// Les types déclarés dans ce fichier ont été générés à partir de données lues 
// depuis la bibliothèque de types. Si cette dernière (via une autre bibliothèque de types 
// s'y référant) est explicitement ou indirectement ré-importée, ou la commande "Rafraîchir"  
// de l'éditeur de bibliothèque de types est activée lors de la modification de la bibliothèque 
// de types, le contenu de ce fichier sera régénéré et toutes les modifications      
// manuellement apportées seront perdues.                                     
// ************************************************************************ //

// PASTLWTR : 1.2
// Fichier généré le 09/05/2012 12:04:48 depuis la bibliothèque de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\2_source\40_PatternCreator\suPatterns_from_MCD\suPatterns_from_MCD.tlb (1)
// LIBID: {E993F67D-DD2E-4244-BE42-2863A11C7FD7}
// LCID: 0
// Fichier d'aide : 
// Chaîne d'aide : suPatterns_from_MCD (bibliothèque)
// DepndLst: 
//   (1) v1.0 StarUML, (C:\Program Files\StarUML\StarUML.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\STDOLE2.TLB)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // L'unité doit être compilée sans pointeur à type contrôlé. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StarUML_TLB, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS déclarés dans la bibliothèque de types. Préfixes utilisés :    
//   Bibliothèques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la bibliothèque de types
  suPatterns_from_MCDMajorVersion = 1;
  suPatterns_from_MCDMinorVersion = 0;

  LIBID_suPatterns_from_MCD: TGUID = '{E993F67D-DD2E-4244-BE42-2863A11C7FD7}';

  CLASS_Patterns_from_MCD: TGUID = '{777FCD85-C644-47CD-8784-F65954CE4E3D}';
type

// *********************************************************************//
// Déclaration de CoClasses définies dans la bibliothèque de types 
// (REMARQUE: On affecte chaque CoClasse à son Interface par défaut)              
// *********************************************************************//
  Patterns_from_MCD = IStarUMLAddIn;


// *********************************************************************//
// La classe CoPatterns_from_MCD fournit une méthode Create et CreateRemote pour          
// créer des instances de l'interface par défaut IStarUMLAddIn exposée             
// par la CoClasse Patterns_from_MCD. Les fonctions sont destinées à être utilisées par            
// les clients désirant automatiser les objets CoClasse exposés par       
// le serveur de cette bibliothèque de types.                                            
// *********************************************************************//
  CoPatterns_from_MCD = class
    class function Create: IStarUMLAddIn;
    class function CreateRemote(const MachineName: string): IStarUMLAddIn;
  end;

implementation

uses ComObj;

class function CoPatterns_from_MCD.Create: IStarUMLAddIn;
begin
  Result := CreateComObject(CLASS_Patterns_from_MCD) as IStarUMLAddIn;
end;

class function CoPatterns_from_MCD.CreateRemote(const MachineName: string): IStarUMLAddIn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Patterns_from_MCD) as IStarUMLAddIn;
end;

end.
