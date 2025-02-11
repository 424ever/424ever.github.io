#!/bin/sh
rm osu/refresh_token.gpg
rm osu/access_token.gpg

CLIENT_ID=$(gpg --quiet --batch --yes --decrypt --passphrase="$1" osu/client_id.gpg)
CLIENT_SECRET=$(gpg --quiet --batch --yes --decrypt --passphrase="$1" osu/client_secret.gpg)

echo "https://osu.ppy.sh/oauth/authorize?client_id=$CLIENT_ID&redirect_uri=http%3A%2F%2Flocalhost%3A4242&response_type=code&scope=identify+public"
echo 'close tab after accepting'

CODE=$(ncat -l -p 4242 | grep GET | awk '{print $2}' | awk 'BEGIN { FS="="; } { print $2 }')

curl --fail-with-body \
     --request POST \
     "https://osu.ppy.sh/oauth/token" \
     --header "Accept: application/json" \
     --header "Content-Type: application/x-www-form-urlencoded" \
     --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&code=$CODE&grant_type=authorization_code&redirect_uri=http%3A%2F%2Flocalhost%3A4242" \
     -o response.json

jq -r .access_token response.json | gpg --quiet --batch --yes --symmetric --cipher-algo AES256 --passphrase="$1" --output osu/access_token.gpg
jq -r .refresh_token response.json | gpg --quiet --batch --yes --symmetric --cipher-algo AES256 --passphrase="$1" --output osu/refresh_token.gpg
rm response.json
