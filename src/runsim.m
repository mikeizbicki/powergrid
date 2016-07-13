#! /usr/bin/octave -qf

addpath "./src/ekfukf"

########################################

#grid="src/grid/ring.m";
#gridsize=20;
#gridUpdate="src/gridUpdate/addLaplace.m";
#numconn=100;
#attack="src/attacks/localSpike.m";
#load="src/loads/gaussian.m";
#powerObservations="src/powerObservations/Observed.m";
#kl="src/extractKL/localKL.m";
#seed=2;
#filter="src/filters/ukf.m";

########################################

grid=argv(){1};
gridsize=str2double(argv(){2});
numconn=str2double(argv(){3});
attack=argv(){4};
load=argv(){5};
powerObservations=argv(){6};
kl=argv(){7};
seed=str2num(argv(){8});
filter=argv(){9};

########################################

function ret=getFilename(a)
    splt=strsplit(a,"/.");
    ret=splt{length(splt)-1};
endfunction

########################################

rand("seed",seed);
randn('seed',seed);

source(grid);
for i=[1:numconn]
    source(gridUpdate)
endfor
source(attack);
source(load);
source(powerObservations);

source("src/mkDynamics.m");
source(kl);
source("src/sample.m");
basename=['results/',getFilename(grid),'-',num2str(gridsize),'-',num2str(numconn),'-',getFilename(attack),'-',getFilename(load),'-',getFilename(powerObservations),'-',getFilename(kl),'-',num2str(seed)]
print('-color','-dpsc',[basename,'.eps']);
source(filter);
filename=[basename,'-',getFilename(filter),'.eps']
print('-color','-dpsc',filename);
