#! /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/octave/4.0.0/bin/octave -qf

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
gridUpdate=argv(){3};
numconn=str2double(argv(){4});
attack=argv(){5};
load=argv(){6};
powerObservations=argv(){7};
kl=argv(){8};
seed=str2num(argv(){9});
filter=argv(){10};

########################################

function ret=getFilename(a)
    splt=strsplit(a,"/.");
    ret=splt{max(1,length(splt)-1)};
endfunction

########################################

indicator = @(x) x>0;

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
