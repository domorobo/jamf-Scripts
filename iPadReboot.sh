#jamf api call to restart Envoy iPads by Darrell Wallace

url="<your JSS url>"
client_id="<jamf API client ID>"
client_secret="<jamf API client Sectret"
id_list=<list od mobile device ID numbers, seperated by comma>

getAccessToken() {
	response=$(curl --location --request POST "${url}/api/oauth/token" \
		--header "Content-Type: application/x-www-form-urlencoded" \
		--data-urlencode "client_id=${client_id}" \
		--data-urlencode "grant_type=client_credentials" \
		--data-urlencode "client_secret=${client_secret}")
	access_token=$(echo "$response" | plutil -extract access_token raw -)
	token_expires_in=$(echo "$response" | plutil -extract expires_in raw -)
	token_expiration_epoch=$(($current_epoch + $token_expires_in - 1))
}
restartDevice() {
	response2=$(curl --request POST \
		--url $url/JSSResource/mobiledevicecommands/command/RestartDevice/id/$id_list \
		--header "Authorization: Bearer $access_token" \
		--header "Accept: application/json")
}

getAccessToken
restartDevice
