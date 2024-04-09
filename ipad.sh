#jamf api call to restart Envoy iPads by Darrell Wallace

url="https://vai.jamfcloud.com"
client_id="60a91eb0-a34d-46bc-95de-27d0d7594cd6"
client_secret="ICxEHJ41w-wLPYbFmdJzvvddkFnErXzZHq8jEnI0JxYekUPWc3J3QaMmQFi-Ylm1"
id_list=25,26,27,28,29,30

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
