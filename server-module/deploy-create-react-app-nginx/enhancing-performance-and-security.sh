sudo nano /etc/nginx/nginx.conf
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d risingsegun.xyz -d www.risingsegun.xyz
sudo certbot renew --dry-run
sudo systemctl restart nginx