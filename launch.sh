#!/bin/bash

function gen_needed(){
mkdir channel-artifacts
export CHANNEL_NAME=ch
export FABRIC_CFG_PATH=$PWD
./cryptogen generate --config=./crypto-config.yaml
./configtxgen -profile ProfileTest -outputBlock ./channel-artifacts/genesis.block
./configtxgen -profile ChannelTest -outputCreateChannelTx ./channel-artifacts/channel.tx   -channelID ch
./configtxgen -profile ChannelTest -outputAnchorPeersUpdate ./channel-artifacts/org1MSPanchors.tx -channelID ch -asOrg org1
}


function join_channel() {
docker exec -e CORE_PEER_LOCALMSPID=org1MSP -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.fabric.com/msp peer0.org1.fabric.com peer channel create -o orderer.fabric.com:7050 -c ch -f /etc/hyperledger/configtx/channel.tx --tls true --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.fabric.com-cert.pem
docker exec peer0.org1.fabric.com cp ch.block /etc/hyperledger/configtx
docker exec peer0.org1.fabric.com peer channel join -b /etc/hyperledger/configtx/ch.block
docker exec peer1.org1.fabric.com peer channel join -b /etc/hyperledger/configtx/ch.block
docker exec -e CORE_PEER_LOCALMSPID=org1MSP -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.fabric.com/msp peer0.org1.fabric.com peer channel update -o orderer.fabric.com:7050 -c ch -f /etc/hyperledger/configtx/org1MSPanchors.tx --tls true --cafile /etc/hyperledger/msp/orderer/msp/tlscacerts/tlsca.fabric.com-cert.pem
}

function clean_it() {
docker rm -f $(docker ps -a -q)
rm -rf crypto-config/*
rm -rf channel-artifacts/*
}

function start_network() {
docker-compose -f docker-compose.yml up -d && docker ps
}

clean_it
gen_needed
start_network
sleep 20
join_channel