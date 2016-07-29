#!/bin/bash

for i in {11..20}; do
    time ./src/runsim.m $i $@
done
