unit uContextes;
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

{ uContextes
• ct: constante de contexte
}
//Attention à ne pas changer les valeurs
//on ne peut pas utiliser de type énuméré ici car les valeurs sont utilisées
//dans la base de données pour stocker le paramétrage
const
     ct_Min= 1;
     ct_ETUDE_Periode_Date                   =  1;
     ct_ETUDE_Periode_Code                   =  2;
     //bouche trou                              3
     //bouche trou                              4
     //bouche trou                              5
     //bouche trou                              6
     ct_A_PLA_Periode_Equipe                 =  7;
     ct_A_PLA_Periode_Code                   =  8;
     ct_A_PLA_Hebdomadaire                   =  9;
     ct_A_PLA_Hebdomadaire_Liste             = 10;
     ct_A_PLA_Horaire                        = 11;
     ct_A_PLA_Horaire_Liste                  = 12;
     ct_P_PLP                                = 13;
     ct_P_PLP_Liste                          = 14;
     ct_P_PLP_Periode                        = 15;
     ct_CPERSO_PERIODE                       = 16;
     ct_PM_PLA                               = 17;
     ct_PM_PLA_Decalage                      = 18;
     ct_PL_MATIERES                          = 19;
     ct_PL_OUT                               = 20;
     ct_ETUDE_Carnet_de_piquetage            = 21;
     ct_Charge_d_affaire_Chantier_Salarie    = 22;
     ct_Charge_d_affaire_Salarie             = 23;
     ct_Salarie_Chantier                     = 24;
     ct_A_PLA_Financier_Equipe_Debourse      = 25;
     ct_A_PLA_Financier_Code_Debourse        = 26;
     ct_A_PLA_Financier_Equipe_Vente         = 27;
     ct_A_PLA_Financier_Code_Vente           = 28;
     ct_P_FTRV_Liste                         = 29;
     ct_P_FTRV_Masque_BP_SAL                 = 30;
     //bouche trou                             31;
     ct_P_PLP_Jour                           = 32;
     ct_P_PLC_Periode                        = 33;
     ct_A_CHT_PERIODE                        = 34;
     ct_P_FTRV_Masque_A_CHT                  = 35;
     //bouche trou                             36;
     ct_CPMR                                 = 37;
     ct_P_PLM_Periode                        = 38;
     //bouche trou                             39;
     ct_CPMR_Liste                           = 40;
     ct_PM_PLA_Zoom                          = 41;
     ct_P_PL_Maitre_Saisie_Evenement         = 42;
     ct_CPMR_Hebdomadaire_1_semaine          = 43;
     ct_Masque                               = 44;
     ct_CPMR_Hebdomadaire_x_semaines         = 45;
     ct_A_PLA_Periode_Tache                  = 46;
     ct_A_PLA_Financier_Tache_Debourse       = 47;
     ct_A_PLA_Financier_Tache_Vente          = 48;
     ct_CPMR_Chantier_Hebdomadaire_1_semaine = 49;
     ct_CPMR_Chantier_Hebdomadaire_x_semaines= 50;
     ct_P_PLA_Periode                        = 51;
     ct_P_PLP_Periode_Speciales              = 52;
     ct_PL_SAL                               = 53;
     ct_PL_SAL_Decalage                      = 54;
     ct_PL_SAL_Zoom                          = 55;
     ct_PL_STT                               = 56;
     ct_PL_STT_Decalage                      = 57;
     ct_PL_STT_Zoom                          = 58;
     ct_Max                                  = 58;

     ct_A_PLA_Periode
     :
      set of Byte
      =
       [
       ct_A_PLA_Periode_Code  ,
       ct_A_PLA_Periode_Equipe,
       ct_A_PLA_Periode_Tache
       ];
     ct_A_PLA_Financier
     :
      set of Byte
      =
       [
       ct_A_PLA_Financier_Equipe_Debourse,
       ct_A_PLA_Financier_Code_Debourse  ,
       ct_A_PLA_Financier_Equipe_Vente   ,
       ct_A_PLA_Financier_Code_Vente     ,
       ct_A_PLA_Financier_Tache_Debourse ,
       ct_A_PLA_Financier_Tache_Vente   
       ];

     ct_P_PL
     :
      set of Byte
      =
       [
        ct_P_PLP_Periode,
        ct_P_PLP_Periode_Speciales,
        ct_P_PLC_Periode,
        ct_P_PLM_Periode
        ];
const
     PL_OUT_OffsetCol= 1;//provisoire
     Rendement_par_defaut=8;

{ uContextes
• vct: variable de contexte
  solution provisoire, il faudra peut-être passer d'une constante de contexte
  à un objet de contexte, le cas échéant avec une classe de base et des classes
  dérivées pour implémenter ce genre de variable.
}
var
   { vct_Horaire_Affaire_Jour
   le jour courant dans le contexte ct_Horaire_Affaire
   }
   vct_Horaire_Affaire_Jour: TDateTime;

implementation

end.

