#! /bin/bash

source ./cliHelpers.sh

instanceName=`grep instanceName ./settings.conf | awk -F: '{print $2}'` 
if [[ "$instanceName" != "" ]]; then
    echo "Retrieved Instance Name from ./settings.conf: $instanceName"
else
    printf "MIC Instance Name (excluding .mic.telenorconnection.com; for example, demonorway/demo/<customer name>): "
    read instanceName
fi
instanceURL="$instanceName"".mic.telenorconnexion.com"
echo "    Instance URL: $instanceURL"

# convert instance to API URL
printf "         API URL: "
URL="https://wrd4rfaqo1.execute-api.eu-west-1.amazonaws.com/Prod/manifest/?hostname=""$instanceURL"
curlCMD=(-X GET "$URL")
curlOutput=`curl --silent "${curlCMD[@]}"`
if [[ "$curlOutput" == "{}" ]]; then
    echo "ERROR: Could not retrieve API URL. Ensure the Instance Name is correct. Exitiing"
    exit 1
fi
baseURL=`echo $curlOutput | sed 's/,/\'$'\n''/g' | grep "ApiGatewayRootUrl" | awk -F: '{print $2":"$3}' | sed 's/\"//g'`
baseURL="$baseURL/prod"
echo "$baseURL"

# fetch API Key
printf "   Fetch API Key: "
URL="$baseURL/metadata/manifest"
curlCMD=(-X GET "$URL")
curlOutput=`curl --silent "${curlCMD[@]}"`
header_xapikey=`echo $curlOutput | sed 's/,/\'$'\n''/g' | grep "ApiKey" | awk -F: '{print $2}' | sed 's/\"//g'`
if [[ ${#header_xapikey} < 40 ]]; then
    echo "ERROR: Unable to retrieve a valid API Key. Exiting"
    exit 1
fi
echo "OK"
header_xapikey="x-api-key: $header_xapikey"

username=`grep username ./settings.conf | awk -F: '{print $2}'`
if [[ "$username" != "" ]]; then
    echo "Retrieved Username from ./settings.conf: $username"
else
    printf "username: "
    read username
fi
password=`grep password ./settings.conf | awk -F: '{print $2}'`
if [[ "$password" != "" ]]; then
    echo "Retrieved Password from ./settings.conf: ********"
    echo ""
    echo "**************************************************************************************************************************"
    echo "* NOTE: it is NOT recommended to store the password in the settings file. Please remove this at the end of thie session! *"
    echo "**************************************************************************************************************************"
    echo ""
else
    printf "password: "
    read -s password
    echo ""
fi

### Get an AUTH Token
printf "Authenticating $username: "
URL="$baseURL/auth/login"
payload='{"userName":"'"$username"'","password":"'"$password"'"}'
curlCMD=(-X POST "$URL" -H "$header_xapikey" -H "content-type: application/json" --data-raw "$payload")
curlOutput=`curl --silent "${curlCMD[@]}"`
result=`echo "$curlOutput" | sed 's/,/\'$'\n''/g' | grep "message" | awk -F: '{print $2}' | sed 's/\"//g' | sed 's/}//g'`
if [[ "$result" == "Forbidden" ]]; then
    echo "ERROR: An unknown error has ocurred communicating with the API Gateway. Check that each parameter is correct. Exiting"
    exit 1
fi
result=`echo "$curlOutput" | sed 's/,/\'$'\n''/g' | grep "messageKey" | awk -F: '{print $2}' | sed 's/\"//g' | sed 's/}//g'`
if [[ "$result" == "INVALID_LOGIN" ]]; then
    errorMessage=`echo "$curlOutput" | sed 's/,/\'$'\n''/g' | grep "message" | tail -1 | awk -F: '{print $2}' | sed 's/\"//g' | sed 's/}//g'`
    echo "ERROR: $errorMessage."
    echo "    - Ensure you have the correct username ($username) and password."
    echo "    - Ensure $username has the correct permissions to $instanceName"
    echo "Exiting"
    exit 1
else
    echo "OK"
    echo ""
fi
token=`echo "$curlOutput" | sed 's/,/\'$'\n''/g' | grep "token" | awk -F: '{print $2}' | sed 's/\"//g'`
if [[ ${#token} < 1386 ]]; then
    echo "ERROR: Unable to retrive a valid token. Exiting"
    exit 1
fi

choice=0
while [[ $choice == 0 ]]; do
    echo "------------ MIC CLI -----------"
    echo ""
    echo "    [ 1 ] List ThingTypes"
    echo "    [ 2 ] List Things"
    echo "    [ 3 ] List Domains"
    echo "    [ 4 ] Describe ThingType"
    echo "    [ 5 ] Describe Thing"
    echo "    [ 6 ] Create ThingType"
    echo "    [ 7 ] Create Thing"
    echo "    [ 8 ] Upload File"
    echo "    [ 9 ] Exit"
    echo ""
    printf "[1-9] > "
    read choice
    if [[ $choice =~ ^[1-8] || $choice == 9 ]]; then
        case $choice in 
            1)
                choice=0
                echo "List ThingTypes is not implemented at this time"
                echo ""
                ;;
            2)
                choice=0
                listThings
                echo ""
                ;;
            3)
                choice=0
                echo "List Domains is not implemented at this time"
                echo ""
                ;;
            4)
                choice=0
                echo "Describe ThingType is not implemented at this time"
                echo ""
                ;;
            5)
                choice=0
                echo "Describe Thing is not implemented at this time"
                echo ""
                ;;
            6)
                choice=0
                echo "Create ThingType is not implemented at this time"
                echo ""
                ;;
            7)
                choice=0
                createThing
                ;;
            8)
                choice=0
                uploadFile
                ;;
            9)
                echo "Exiting."
                exit
                ;;
        esac
    else
        echo "ERROR: Invalid option. Select [ 1 -> 9 ]"
        echo ""
        choice=0
    fi
done

exit
