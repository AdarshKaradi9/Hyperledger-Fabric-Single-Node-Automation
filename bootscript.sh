#!/bin/bash
cd /var/run
sudo chmod 777 docker.sock
cd -
chmod 777 -R *
./init.sh
echo "Enter the network details"
python3 gen.py
chmod 777 -R *
echo "------------Launching the Network---------------"
./launch.sh