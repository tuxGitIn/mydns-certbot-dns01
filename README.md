# mydns-certbot-dns01
Let's Encrypt で dns-01チャレンジを行うシェルスクリプト。

スクリプトの作成には以下のリポジトリを参考にしてあります。  
https://github.com/disco-v8/DirectEdit

# 動作環境
linux (debian-based distros)

また、以下のコマンドが使用可能であることが必要です。  
curl  
certbot

# 使用方法
certbot certonly --manual --preferred-challenge=dns --manual-auth-hook "[yourdirectory]/dns01-challenge-mydns.sh -r" --manual-cleanup-hook "[yourdirectory]/dns01-challenge-mydns.sh -d" -d [yourdomain] --server https://acme-v02.api.letsencrypt.org/directory --agree-tos

dns01-challenge-mydns.conf に MyDNS のユーザー名とパスワードを変更して実行してください。
