#
# This file has global parameters for controlling the simulation
#

attackTime=2000;
totalTime=5000;
stepsize=0.001;

####################
# utilities

rand("seed",0);
randn('seed',0);

indicator = @(x) x>0;
