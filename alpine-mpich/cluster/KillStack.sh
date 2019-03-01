#!/bin/sh

docker stack rm test

docker-compose -f launch-registry.yml down