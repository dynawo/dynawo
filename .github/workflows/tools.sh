wait_for_http_code()
{
    local WAIT_URL=$1
    local WAIT_CODE=$2
    local TOKEN=$3
    echo "wait_for_http_code($WAIT_URL, $WAIT_CODE)"

    local CODE=""
    local MAX_RETRIES=20
    local RETRIES=0
    while [[ (-z "$CODE" || "$CODE" -ne "$WAIT_CODE") && ("$RETRIES" -lt "$MAX_RETRIES") ]]
    do
      sleep 1
      CODE=$(curl --silent --header "authorization: Bearer $TOKEN" --head "$WAIT_URL" | grep ^HTTP | tr -s ' ' | cut -f 2 -d' ')
      RETRIES=`expr $RETRIES + 1`
      echo "DEBUG. Waiting for $WAIT_URL = $WAIT_CODE. Retries $RETRIES, code $CODE"
    done
    echo "DEBUG. Waiting finished. Retries $RETRIES, code $CODE"
}

upload_zip_file()
{
  local UPLOAD_URL=$1
  local FILE=$2
  local TOKEN=$3
  echo "upload_zip_file($UPLOAD_URL, $FILE)"

  # Limit rate is used to ensure uploads finish
  # When not used, systematic errors for TCP connection reset are received
  curl \
      --retry 20 --retry-delay 0 --retry-max-time 40 --max-time 180 --limit-rate 5M \
      --request POST \
      --url $UPLOAD_URL?name=$FILE \
      --header "authorization: Bearer $TOKEN" \
      --header "Content-Type: application/zip" \
      --data-binary @$FILE
}
