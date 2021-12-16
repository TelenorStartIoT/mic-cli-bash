function listThings {
    echo ""
    
    echo "List Things"
    echo "***********"

    URL="$baseURL/things/find"
    authHeader='Authorization:'"$token"
    payload='{"query": {"size": 1}},"type": "thing,sub_thing"}'
    curlCMD=(-X POST "$URL" -H "$authHeader" -H "$header_xapikey" -H "content-type: application/json" --data "$payload")
    curlOutput=`curl --silent "${curlCMD[@]}"`
    totalThingsFound=`echo $curlOutput | sed 's/,/\'$'\n''/g' | grep "total" | grep "hits" | awk -F: '{print $3}'`
    echo "Total Things Found: $totalThingsFound"
    echo ""
}

function createThing {
    echo ""
    
    echo "Create Thing"
    echo "************"

    # get thing types
    printf "domain: "
    read domain
    printf "Thing Name: "
    read thingName 
    printf "Thing Type: "
    read thingType

    ### Create the Thing
    URL="$baseURL/things"
    authHeader='Authorization:'"$token"
    thingName='"thingName":"'"$thingName"'"'
    thingType='"thingType":"'$thingType'"'
    domain='"domain":"'$domain'"'
    protocol='"protocol":"mqtt"'
    payload='{'$thingName', '$thingType', '$domain', '$protocol'}'
    curlCMD=(-X POST "$URL" -H "$authHeader" -H "$header_xapikey" -H "content-type: application/json" --data-raw "$payload")
    curl --silent "${curlCMD[@]}"
}
