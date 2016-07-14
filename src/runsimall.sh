#!/bin/bash

for i in {1..10}; do
    time ./src/runsim.m $i $@
done
