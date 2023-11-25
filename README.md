# mydns-certbot-dns01
Certbotを使ってMyDNSにdns-01チャレンジを行うシェルスクリプト

# 使用方法
sudo certbot certonly --manual --preferred-challenge=dns --manual-auth-hook "[yourdirectory]/dns01-challenge-mydns.sh -r" --manual-cleanup-hook "[yourdirectory]/dns01-challenge-mydns.sh -d" -d [yourdomain] --server https://acme-v02.api.letsencrypt.org/directory --agree-tos

dns01-challenge-mydns.conf に MyDNS のユーザー名とパスワードを変更して実行してください。
