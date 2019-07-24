unit u_db_Formes;
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

interface

{ u_db_Formes
avant: constantes relatives à la base de donnée préfixées par db_
Nouvelle norme de nommage: distinction entre
nom de table   : dbt_
nom de champ   : dbf_
valeur de champ: dbv_
}
const
     db_secteur      = 'secteur';
     db_chantier     = 'chantier';
     db_phase        = 'phase';
     db_tache        = 'tache';
     db_NIVEAU       = 'niveau';
     db_NO_OUVRAGE   = 'no_ouvrage';
     db_equipe       = 'equipe';
     db_nb_heures    = 'nb_heures';

     db_G_POLICES= 'g_polices';
     db_BIB_Achats          = '-A';
     db_BIB_Demandes_de_prix= '-AZ';
     db_BIB_Bons_de_retour  = '-AR'; //provisoire mais plausible, pour permettre codage des bons de retours
     db_BIB_Note_de_Credit  = '-A#'; //provisoire mais plausible, pour permettre codage des notes de crédit
     db_BIB_Ventes          = '-V';
     db_BIB_Devis_simplifie = '-VD';
     db_BIB_Accuse_reception= '-VR';
     db_BIB_Avoirs          = '-VA';
     db_BIB_Litiges_sur_bon_de_livraison = '-ALL';
     db_BIB_Litiges_sur_facture          = '-ALF';

     dbt_G_BECP     = 'g_becp';
     dbt_G_CTX      = 'g_ctx';
     dbt_G_CTXTYPE  = 'g_ctxtype';
     dbt_G_BECPCTX  = 'g_becpctx';

     dbf_nomclasse    = 'nomclasse';
     dbf_contexte     = 'contexte' ;
     dbf_contextetype = 'contextetype';
     dbf_libelle      = 'libelle'  ;
     dbf_logfont      = 'logfont'  ;
     dbf_stringlist   = 'stringlist';

     dbf_ci1 = 'ci1' ;
     dbf_ci2 = 'ci2' ;
     dbf_ci3 = 'ci3' ;
     dbf_ci4 = 'ci4' ;
     dbf_ci5 = 'ci5' ;
     dbf_ci6 = 'ci6' ;
     dbf_ci7 = 'ci7' ;
     dbf_ci8 = 'ci8' ;
     dbf_ci9 = 'ci9' ;
     dbf_ci10= 'ci10';
     dbf_ci11= 'ci11';
     dbf_ci12= 'ci12';
     dbf_ci13= 'ci13';
     dbf_ci14= 'ci14';
     dbf_ci15= 'ci15';
     dbf_ci16= 'ci16';
     dbf_ci17= 'ci17';
     dbf_ci18= 'ci18';
     dbf_ci19= 'ci19';
     dbf_ci20= 'ci20';

const
     dbt_B_TDSC= 'b_tdsc';
     dbf_NbExemplaires= 'nbexemplaires';
     dbf_HauteurEnteteP2= 'hauteurentetep2';
     dbf_LogoP2= 'logop2';
     dbf_LogoP1= 'logop1';


//G_BATPRODBGRID
const
     dbt_G_BATPRODBGRID= 'g_batprodbgrid';

//G_COLONNE
const
     dbt_G_COLONNE= 'g_colonne';

implementation

end.
