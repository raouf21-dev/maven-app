#!/usr/bin/env bash

export IMAGEw=$1
docker-compose -f docker-compose.yaml up --detach

echo "success"