docker compose exec wordpress sh -lc 'mkdir -p /var/www/html/wp-content/mu-plugins && cat > /var/www/html/wp-content/mu-plugins/force-app-passwords.php <<'\''PHP'\''
<?php
add_filter("wp_is_application_passwords_available", "__return_true");
add_filter("wp_is_application_passwords_available_for_user", "__return_true");
PHP'