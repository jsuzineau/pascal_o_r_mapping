docker compose exec wpcli wp core install \
  --url=http://localhost:8080 \
  --title="WP Local Test" \
  --admin_user=admin \
  --admin_password=admin123456 \
  --admin_email=test@example.local \
  --skip-email \
  --allow-root