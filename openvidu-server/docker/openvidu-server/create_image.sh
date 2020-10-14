IMAGE=$1
if [[ ! -z $IMAGE ]]; then
    cp -f ../../target/openvidu-server-*.jar ./openvidu-server.jar
    cp -f ../utils/discover_my_public_ip.sh ./discover_my_public_ip.sh

    docker build --network=host --force-rm -t $IMAGE .

    rm ./openvidu-server.jar
    rm ./discover_my_public_ip.sh
else 
    echo "Error: You need to specify a version as first argument"
fi
