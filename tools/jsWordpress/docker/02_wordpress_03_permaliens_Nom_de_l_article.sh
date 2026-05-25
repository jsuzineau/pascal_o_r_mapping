docker compose exec wpcli wp rewrite structure '/%postname%/' --allow-root
docker compose exec wpcli wp rewrite flush --allow-root