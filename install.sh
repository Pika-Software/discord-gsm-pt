#!/bin/bash

git clone https://github.com/Pika-Software/discord-gsm-pt.git .

pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir -r requirements.txt

mkdir -p /home/container/data/logs
