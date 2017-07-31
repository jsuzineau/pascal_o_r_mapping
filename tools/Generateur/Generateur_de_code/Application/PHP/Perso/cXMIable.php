<?php
/*                                                                            |
    Tool to produce XMI data from a set php classes.                          |
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

/*                                                                            |
CHANGES:                                                                      |
   0.1 : First version.                                                       |
|                                                                            */

//cXMIable.php
$xmiClasses= array();
$Generalizations= array();
$xmiCount= 1;

define( "tagXMI"                    , "XMI"                                   );
define( "tagContent"                , "XMI.content"                           );
define( "tagModel"                  , "Model_Management.Model"                );
define( "tagownedElement"           , "Foundation.Core.Namespace.ownedElement");
define( "tagClass"                  , "Foundation.Core.Class"                 );
define( "tagName"                   , "Foundation.Core.ModelElement.name"     );
define( "tagFeature"                , "Foundation.Core.Classifier.feature"    );
define( "tagAttribute"              , "Foundation.Core.Attribute"             );
define( "tagOperation"              , "Foundation.Core.Operation"             );
define( "tagGeneralization"         , "Foundation.Core.Generalization"        );
define( "tagGeneralizationReference",
                         "Foundation.Core.GeneralizableElement.generalization");
define( "tagSpecializationReference",
                         "Foundation.Core.GeneralizableElement.specialization");
define( "tagParent"                 , "Foundation.Core.Generalization.parent" );
define( "tagChild"                  , "Foundation.Core.Generalization.child"  );
define( "tagGeneralizable"          , "Foundation.Core.GeneralizableElement"  );
define( "tagNameSpaceReference"     , "Foundation.Core.ModelElement.namespace");
define( "tagNameSpace"              , "Foundation.Core.Namespace"             );

function MajPrem( $Chaine)
  {
  $Debut= strtoupper( substr( $Chaine, 0, 1));
  $Fin=  substr( $Chaine, 1);
  return $Debut.$Fin;
  }

class cXMIable
  {
  /* juste pour tests
  var $attribut1= "1";
  function Methode1()
    {
    echo $this->Truc;
    }
  */
  function cXMIable()
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->Truc= "l";
    $NomClasse= MajPrem( get_class( $this));
    $Ancetre  = MajPrem( get_parent_class($this));

    if (! array_key_exists( $NomClasse, $xmiClasses))
       $xmiClasses[$NomClasse]= new cClass( $NomClasse, $Ancetre);

    if ($Ancetre != "")
      if (!$xmiClasses[$NomClasse]->Ancetre)
         $xmiClasses[$NomClasse]->Set_Ancetre($Ancetre);
    }
  }

class cElement //extends cXMIable
  {
  var $Tag;
  var $Attributes;
  var $Text= "";
  var $Childs;
  var $Id;
  var $Indent= "  ";
  var $RetourLigne= "\n";
  function cElement( $Tag)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    //$this->cXMIable();
    $this->Tag       = $Tag;
    $this->Attributes= array();
    $this->Childs    = array();
    $this->Text      = ""     ;
    $this->Id        = ""     ;

    return $this;
    }
  function Add_Id()
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->Id= "xmi.$xmiCount";
    $this->Attributes["xmi.id"]= $this->Id;
    $xmiCount++;
    }

  function Add_Idref( $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->Attributes["xmi.idref"]= $idref;
    }

  function Add_Property( $Tag, $Value)
    {
    $this->Childs[]= new cPropertyElement( $Tag, $Value);
    }

  function XMI( $Indentation="")
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $Resultat= $Indentation."<".$this->Tag;
    foreach( $this->Attributes as $Nom => $Valeur)
      $Resultat.= " $Nom=\"$Valeur\"";

    if (($this->Text == "") && (count($this->Childs) == 0))
       {
       $Resultat.= "/>".$this->RetourLigne;
       return $Resultat;
       }

    $Resultat.= ">".$this->RetourLigne;

    if ($this->Text != "")
       {
       if ($this->RetourLigne!="")
          $Resultat.= $Indentation.$this->Indent;
       $Resultat.= $this->Text.$this->RetourLigne;
       }

    foreach($this->Childs as $Child)
      if ($Child)
         {
         if ($this->RetourLigne!="")
            $ChildIndentation= $Indentation.$this->Indent;

         $Resultat.= $Child->XMI($ChildIndentation);
         if ($Child->RetourLigne=="")
            $Resultat.= $this->RetourLigne;
         }

    if ($this->RetourLigne!="")
       $Resultat.= $Indentation;
    $Resultat.= "</".$this->Tag.">".$this->RetourLigne;
    return $Resultat;
    }
  }

class cTextElement extends cElement
  {
  function cTextElement( $Tag, $Name)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( $Tag);
    $this->Text= $Name;
    }
  }

class cNameElement extends cTextElement
  {
  var $Indent= "";
  var $RetourLigne= "";
  function cNameElement( $Name)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cTextElement( tagName, $Name);
    }
  }

class cNamedElement extends cElement
  {
  function cNamedElement( $Tag, $Name)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( $Tag);
    $this->Childs[]= new cNameElement( $Name);
    }
  }

class cNamedIdElement extends cNamedElement
  {
  function cNamedIdElement( $Tag, $Name)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cNamedElement( $Tag, $Name);
    $this->Add_Id();
    }
  }

class cIdElement extends cElement
  {
  function cIdElement( $Tag)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( $Tag);
    $this->Add_Id();
    }
  }

class cIdrefElement extends cElement
  {
  function cIdrefElement( $Tag, $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( $Tag);
    $this->Add_Idref( $idref);
    }
  }

class cIdReferenceElement extends cElement
  {
  function cIdReferenceElement( $Tag, $Tag_idref, $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( $Tag);
    $this->Childs[]= new cIdrefElement( $Tag_idref, $idref);
    }
  }

class cPropertyElement extends cElement
  {
  function cPropertyElement( $Tag, $Value)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( $Tag);
    $this->Attributes["xmi.value"]= $Value;
    }
  }

class cExpressionElement extends cIdElement
  {
  function cExpressionElement( $Value)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cIdElement( "Foundation.Data_Types.Expression");
    $this->Childs[]
    =
      new cTextElement( "Foundation.Data_Types.Expression.language", "Java");

    if (gettype( $Value) == "string")
       $Value= "&quot;$Value&quot;";

    $this->Childs[]
    =
      new cTextElement( "Foundation.Data_Types.Expression.body", "$Value");
    }
  }

class cInitialValueElement extends cElement
  {
  function cInitialValueElement( $Value)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( "Foundation.Core.Attribute.initialValue");
    $this->Childs[]= new cExpressionElement( $Value);
    }
  }

class cAttributeElement extends cNamedIdElement
  {
  function cAttributeElement( $Name, $idref, $InitialValue)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cNamedIdElement( tagAttribute, $Name);
 $this->Add_Property("Foundation.Core.ModelElement.visibility"     ,"public"  );
 $this->Add_Property("Foundation.Core.ModelElement.isSpecification","false"   );
 $this->Add_Property("Foundation.Core.Feature.ownerScope"          ,"instance");

    $this->Childs[]= new cInitialValueElement( $InitialValue);

    $this->Childs[]
    =
      new cIdReferenceElement( "Foundation.Core.Feature.owner",
                               "Foundation.Core.Classifier",
                               $idref);
    if ($idPHPVar != "")
      $this->Childs[]
      =
        new cIdReferenceElement( "Foundation.Core.StructuralFeature.type",
                                 "Foundation.Core.Classifier",
                                 $idPHPVar);
    }
  }

class cMethodElement extends cIdElement
  {
  function cMethodElement( $idref, $idrefclasse)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cIdElement( "Foundation.Core.Method");
    $this->Add_Property("Foundation.Core.ModelElement.isSpecification","false");
    $this->Add_Property("Foundation.Core.BehavioralFeature.isQuery"   ,"false");
    $this->Childs[]
    =
      new cIdReferenceElement( "Foundation.Core.Feature.owner",
                               "Foundation.Core.Classifier",
                               $idrefclasse);
    $this->Childs[]
    =
      new cIdReferenceElement( "Foundation.Core.Method.specification",
                               tagOperation,
                               $idref);
    }
  }

class cParameterElement extends cNamedIdElement
  {
  function cParameterElement( $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cNamedIdElement( "Foundation.Core.Parameter", "return");
    $this->Add_Property("Foundation.Core.ModelElement.isSpecification","false");
    $this->Add_Property("Foundation.Core.Parameter.kind","return");
    $this->Childs[]
    =
      new cIdReferenceElement( "Foundation.Core.Parameter.behavioralFeature",
                               "Foundation.Core.BehavioralFeature",
                               $idref);
    if ( $idPHPVar != "")
      $this->Childs[]
      =
        new cIdReferenceElement( "Foundation.Core.Parameter.type",
                                 "Foundation.Core.Classifier",
                                 $idPHPVar);
    }
  }

class cBehavioralFeatureElement extends cElement
  {
  function cBehavioralFeatureElement( $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( "Foundation.Core.BehavioralFeature.parameter");
    $this->Childs[]= new cParameterElement( $idref);
    }
  }

class cOperationElement extends cNamedIdElement
  {
  function cOperationElement( $Name, $idref, & $parent)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cNamedIdElement( tagOperation, $Name);

 $this->Add_Property("Foundation.Core.ModelElement.visibility"     ,"public" );
 $this->Add_Property("Foundation.Core.ModelElement.isSpecification","false"   );
 $this->Add_Property("Foundation.Core.Feature.ownerScope"          ,"instance");
 $this->Add_Property("Foundation.Core.BehavioralFeature.isQuery"   ,"false"   );
    $this->Add_Property( "Foundation.Core.Operation.isRoot","false");
    $this->Add_Property( "Foundation.Core.Operation.isLeaf","false");
    $this->Add_Property( "Foundation.Core.Operation.isAbstract","false");
    $this->Childs[]
    =
      new cIdReferenceElement( "Foundation.Core.Feature.owner",
                               "Foundation.Core.Classifier",
                               $idref);
    $Methode= new cMethodElement( $this->Id, $idref);
    $parent->Childs[]= $Methode;
    $this->Childs[]
    =
      new cIdReferenceElement( "Foundation.Core.Operation.method",
                               "Foundation.Core.Method",
                               $Methode->Id);
    $this->Childs[]
    =
      new cBehavioralFeatureElement( $this->Id);
    }
  }

class cGeneralization extends cIdElement
  {
  function cGeneralization( $parent, $child)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cIdElement( tagGeneralization);

    $this->Add_Property("Foundation.Core.ModelElement.isSpecification","false");

    $this->Childs[]= new cNameSpaceReferenceElement( $XMI->Model->Id);

    $this->Childs[]
    =
      new cIdReferenceElement( tagParent, tagGeneralizable, $parent);

    $this->Childs[]
    =
      new cIdReferenceElement( tagChild , tagGeneralizable, $child );
    }
  }

class cGeneralizationReferenceElement extends cIdReferenceElement
  {
  function cGeneralizationReferenceElement( $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cIdReferenceElement( tagGeneralizationReference,
                                tagGeneralization, $idref);
    }
  }

class cSpecializationReferenceElement extends cElement
  {
  function cSpecializationReferenceElement()
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cElement( tagSpecializationReference);
    }
  }

class cNameSpaceReferenceElement extends cIdReferenceElement
  {
  function cNameSpaceReferenceElement( $idref)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->cIdReferenceElement( tagNameSpaceReference, tagNameSpace, $idref);
    }
  }
class cClass extends cNamedIdElement
  {
  var $Ancetre;
  var $Specialization=0;
  function cClass( $NomClasse, $NomClasseParente)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->Ancetre= 0;

    $this->cNamedIdElement( tagClass, $NomClasse);
    $XMI->ownedElement->Childs[]= $this;

    $this->Add_Property( "Foundation.Core.ModelElement.isSpecification","false");
    $this->Add_Property( "Foundation.Core.GeneralizableElement.isRoot","false");
    $this->Add_Property( "Foundation.Core.GeneralizableElement.isLeaf","false");
    $this->Add_Property( "Foundation.Core.GeneralizableElement.isAbstract",
                         "false");

    $this->Add_Property( "Foundation.Core.Class.isActive", "false");

    $this->Childs[]= new cNameSpaceReferenceElement( $XMI->Model->Id);

    $this->AssureSpecialization();

    $feature= new cElement( tagFeature);
    $this->Childs[]= $feature;

    $ParentAttributes= get_class_vars( $NomClasseParente);
    if (!isset($ParentAttributes))
       $ParentAttributes= array();
    $Attributes = get_class_vars( $NomClasse);
    foreach( $Attributes as $Nom => $Valeur)
      {
      if (!isset($ParentAttributes[$Nom]))
         $Ajouter= 1;
      else
         $Ajouter= $ParentAttributes[$Nom] != $Valeur;

      if ($Ajouter)
         $feature->Childs[]= new cAttributeElement( $Nom, $this->Id, $Valeur);
      }

    $ParentOperations= get_class_methods( $NomClasseParente);
    if (!isset($ParentOperations))
       $ParentOperations= array();
    $Operations= get_class_methods( $NomClasse);
    foreach( $Operations as $Operation)
      if (!in_array( $Operation, $ParentOperations))
         $feature->Childs[]
         =
           new cOperationElement( $Operation, $this->Id, $feature);
    }
  function AssureSpecialization()
    {
    if ($this->Specialization == 0)
       {
       $this->Specialization= new cSpecializationReferenceElement();
       $this->Childs[]= $this->Specialization;
       }
    }
  function Set_Ancetre( $Ancetre)
    {
    global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

    $this->Ancetre= 1;
    //echo ">$Ancetre< <br>\n";
    $ClasseAncetre= $xmiClasses[$Ancetre];
    if (!is_object($ClasseAncetre)) return;
    $Generalization= new cGeneralization( $ClasseAncetre->Id, $this->Id);
    $XMI->ownedElement->Childs[]= $Generalization;

    $Generalizations[]= & $Generalization;

    $ClasseAncetre->AssureSpecialization();
    $ClasseAncetre->Specialization->Childs[]
    =
      new cIdrefElement( tagGeneralization, $Generalization->Id);

    $this->Childs[]= new cGeneralizationReferenceElement( $Generalization->Id);
    }
  }

class cXMI extends cElement
 {
 var $ownedElement=0;
 var $Model=0;
 function cXMI()
   {
   global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;

   $this->cElement( tagXMI);

   $this->Attributes["xmi.version"]="1.0";

   $Header= new cElement( "XMI.header");
   $this->Childs[]= $Header;

   $documentation= new cElement("XMI.documentation");
   $Header->Childs[]= $documentation;

   $exporter= new cElement("XMI.exporter");
   $exporter->Indent= "";
   $exporter->RetourLigne= "";
   $exporter->Text= "Novosoft UML Library";
   $documentation->Childs[]= $exporter;

   $exporterVersion= new cElement("XMI.exporterVersion");
   $documentation->Childs[]= $exporterVersion;
   $exporterVersion->Text= "0.4.19";
   $exporterVersion->Indent= "";
   $exporterVersion->RetourLigne= "";

   $metamodel= new cElement("XMI.metamodel");
   $Header->Childs[]= $metamodel;
   $metamodel->Attributes["xmi.name"]="UML";
   $metamodel->Attributes["xmi.version"]="1.3";

   $Content= new cElement( tagContent);
   $this->Childs[]= $Content;

   $this->Model= new cNamedIdElement( tagModel, "jswork");
   $Content->Childs[]= $this->Model;

   $this->Model->Add_Property( "Foundation.Core.ModelElement.isSpecification","false");
   $this->Model->Add_Property( "Foundation.Core.GeneralizableElement.isRoot","false");
   $this->Model->Add_Property( "Foundation.Core.GeneralizableElement.isLeaf","false");
   $this->Model->Add_Property( "Foundation.Core.GeneralizableElement.isAbstract",
                               "false");

   $this->ownedElement= new cElement( tagownedElement);
   $this->Model->Childs[]= $this->ownedElement;
   }
 }
$XMI= new cXMI();

class PHPVar
  {
  /* juste pour test
  var $attribut1= "1";
  function Methode1()
    {
    echo $this->Truc;
    }
  */
  }
$InstancePHPVar= new PHPVar();

$xmiClasses["PHPVar"]= new cClass( "PHPVar", "stdclass");

$idPHPVar= $xmiClasses["PHPVar"]->Id;

function Produit_XMI()
  {
  global $xmiClasses, $Generalizations, $xmiCount, $XMI, $idPHPVar;


  /*
  $NomClasses= get_declared_Classes();
  foreach ( $NomClasses as $NomClasse)
    if (!$xmiClasses[$NomClasse])
       $xmiClasses[$NomClasse]= new cClass( $NomClasse);
  */

  $Childs= & $XMI->ownedElement->Childs;

/*
  foreach ($xmiClasses as $Nom => $Valeur)
    {
    $Childs[]= & $xmiClasses[$Nom];
    //echo "\n Produit_XMI(), ajout de la classe $Nom \n".$Valeur->XMI();
    }
  foreach ($Generalizations as $Nom => $Valeur)
    {
    $Childs[]= & $Generalizations[ $Nom];
    //echo "\n Produit_XMI(), ajout de la Generalization $Nom \n".$Valeur->XMI();
    }
*/

  $Resultat= <<<EOT
<?xml version="1.0" encoding="UTF-8"?>\n
EOT;

  $Resultat.= $XMI->XMI();

  $NomFichier= dirname($PHP_SELF)."Output.xmi";
  $F= fopen( $NomFichier, "w");
    fputs( $F, $Resultat);
  fclose( $F);

  //echo "<HTML><BODY><br>\n";
  echo $Resultat;
  //echo "\n<br></BODY></HTML>";
  }

?>
