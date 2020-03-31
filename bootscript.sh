#!/bin/bash
./init.sh
echo "Enter the network details"
python3 gen.py
sudo chmod 777 *.*
echo "------------Launching the Network---------------"
./launch.sh
