#!/bin/bash

for i in {1..20}; do
    ./src/runsim.m $i $@
done
