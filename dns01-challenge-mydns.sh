#!/bin/bash

# certbot Command
# -- dry-run --
# sudo certbot certonly --manual --preferred-challenge=dns --manual-auth-hook "/usr/local/script/mydns/dns01-challenge-mydns.sh -r" --manual-cleanup-hook "/usr/local/script/mydns/dns01-challenge-mydns.sh -d" -d [yourdomain] --server https://acme-v02.api.letsencrypt.org/directory --agree-tos --dry-run
# -- production --
# sudo certbot certonly --manual --preferred-challenge=dns --manual-auth-hook "/usr/local/script/mydns/dns01-challenge-mydns.sh -r" --manual-cleanup-hook "/usr/local/script/mydns/dns01-challenge-mydns.sh -d" -d [yourdomain] --server https://acme-v02.api.letsencrypt.org/directory --agree-tos

declare -r LOG="./mydns.log"
echo $(date '+%Y/%m/%d %H:%M:%S') >> $LOG

if [ $# -ne 1 ]; then
    echo "usage: $0 regist or delete" >> $LOG
    echo "Argument count: $#" >> $LOG
    exit 1
fi

case $1 in
    -r) 
        declare -r EDIT_CMD="REGIST"
        ;;
    -d)
        declare -r EDIT_CMD="DELETE"
        ;;
    *) 
        echo "only -r or -d option" >> $LOG
        echo "Argument $1" >> $LOG
        exit 2
        ;;
esac

# Certbot から渡される変数
# $CERTBOT_DOMAIN                   ドメイン名
# $CERTBOT_VALIDATION               dns-01 challenge で txt レコードに登録するキー
# $CERTBOT_TOKEN                    リソース名 (HTTP-01 認証のみ)
# $CERTBOT_REMAINING_CHALLENGES     certbot の試行回数 (最初は 0) 
# $CERTBOT_ALL_DOMAINS              -d で渡されたすべてのドメイン名
# $CERTBOT_AUTH_OUTPUT              cleanup の際に標準出力したメッセージ
{
    echo "CERTBOT_DOMAIN: $CERTBOT_DOMAIN"
    echo "CERTBOT_VALIDATION: $CERTBOT_VALIDATION"
    echo "CERTBOT_TOKEN: $CERTBOT_TOKEN"
    echo "CERTBOT_REMAINING_CHALLENGES: $CERTBOT_REMAINING_CHALLENGES"
    echo "CERTBOT_ALL_DOMAINS: $CERTBOT_ALL_DOMAINS"
    echo "CERTBOT_AUTH_OUTPUT: $CERTBOT_AUTH_OUTPUT"
} >> $LOG

# -u オプションを指定するとヘッダーに Ahthentication: Basic [user](base64 encode) が追加される
# このスクリプトでは一つのドメインのみ対応する (certbot に複数のドメインを渡すと CERTBOT_ALL_DOMAIN に全てのドメイン名が格納される)
# --data* 関連のオプションを指定すると暗黙的に POST リクエストと判断してくれる (明示的に POST を指定すると POST リクエストは不要という文字列が標準出力に出てしまう)
# 標準出力に出す必要が無いので進捗バーの表示は無くして結果は /dev/null に投げることにした
source ./dns01-challenge-mydns.conf
declare -r HTTP_HEADER="Content-Type: application/x-www-form-urlencoded"
curl \
    -s \
    --data-urlencode "CERTBOT_DOMAIN=${CERTBOT_DOMAIN}" \
    --data-urlencode "CERTBOT_VALIDATION=${CERTBOT_VALIDATION}" \
    --data-urlencode "EDIT_CMD=${EDIT_CMD}" \
    -H "${HTTP_HEADER}" \
    -u "${MYDNS_ID}:${MYDNS_PASS}" \
    --basic \
    $MYDNS_URL \
    >> /dev/null
