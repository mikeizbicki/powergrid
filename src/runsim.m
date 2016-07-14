#! /usr/bin/octave -qf
##! /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/octave/4.0.0/bin/octave -qf

addpath "./src/ekfukf"

########################################

function ret=argv2()
    ret=cell(10);
    ret{1}='2';
    #ret{2}='src/grid/ring.m';
    ret{2}='src/grid/clusterSmallWorld.m';
    ret{3}='10';
    ret{4}='src/gridUpdate/addLaplace.m';
    ret{5}='10';
    ret{6}='src/attacks/localSpike.m';
    ret{7}='src/loads/gaussian.m';
    ret{8}='src/powerObservations/Observed.m';
    ret{9}='src/extractKL/localKL.m';
    ret{10}='src/filters/ukf.m';
endfunction

########################################

seed=str2num(argv(){1});
grid=argv(){2};
gridsize=str2double(argv(){3});
gridUpdate=argv(){4};
numconn=str2double(argv(){5});
attack=argv(){6};
load=argv(){7};
powerObservations=argv(){8};
kl=argv(){9};
filter=argv(){10};

########################################

function ret=getFilename(a)
    splt=strsplit(a,"/.");
    ret=splt{max(1,length(splt)-1)};
endfunction

########################################
# run simulation

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
basename=['results/',num2str(seed),'-',getFilename(grid),'-',num2str(gridsize),'-',getFilename(gridUpdate),'-',num2str(numconn),'-',getFilename(attack),'-',getFilename(load),'-',getFilename(powerObservations),'-',getFilename(kl),]
print('-color','-dpsc',[basename,'.eps']);
source(filter);
filename=[basename,'-',getFilename(filter),'.eps']
print('-color','-dpsc',filename);

########################################
# output results

source('src/evaluate.m');
csvwrite([basename,'-deltaThresholds.csv'],deltaThresholds);
csvwrite([basename,'-omegaThresholds.csv'],omegaThresholds);
csvwrite([basename,'-thetaThresholds.csv'],thetaThresholds);
csvwrite([basename,'-attackThresholds.csv'],attackThresholds);
csvwrite([basename,'-separation.csv'],separation);
