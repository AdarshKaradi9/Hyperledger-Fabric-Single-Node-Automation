#!/bin/bash

docker rm -f $(docker ps -a -q)
rm configtx.yaml
rm crypto-config.yaml
rm docker-compose.yml
rm launch.sh
rm -rf crypto-config/*
rm -rf channel-artifacts/*
