#!/bin/bash

part1=$(openssl rand -hex 3)
part2=$(openssl rand -hex 3)
part3=$(openssl rand -hex 3)

echo "${part1}-${part2}-${part3}"
