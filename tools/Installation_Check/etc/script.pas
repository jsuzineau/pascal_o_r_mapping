begin
     Verifie_Owner_Group( '/adibat/01_gre','adibat','adibat');
     Verifie_Owner_Group( '/adibat/01_fgl','adibat','adibat');
     Verifie_CHMOD_777  ( '/adibat/02_etc');
     Verifie_CHMOD_777  ( '/adibat/03_bin');
     Verifie_CHMOD_777  ( '/adibat/04_gdc');
     Verifie_Owner_Group( '/adibat/05_gas','adibat','adibat');
     Verifie_CHMOD_777  ( '/adibat/06_Editions');
     Verifie_CHMOD_777  ( '/adibat/07_Planning');
     Verifie_CHMOD_777  ( '/adibat/08_modeles_oo');
     Verifie_CHMOD_777  ( '/adibat/09_logos');
     Traite_Commande    ( '/adibat/01_fgl/bin/fglrun -v', 'Version fgl');
     Traite_Commande    ( '/adibat/05_gas/bin/fastcgidispatch -v', 'Version gas');
     Traite_Commande    ( 'll /adibat/10_sauvegardes_journalieres', 'Sauvegardes:');
     Traite_Commande    ( 'df -h ', 'Place disponible');
     Traite_Commande    ( 'sudo crontab -l'#10'azerty', 'Tâches planifiées');
end.
