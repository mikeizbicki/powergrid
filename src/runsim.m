#! /usr/bin/octave -qf
##! /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/octave/4.0.0/bin/octave -qf

addpath "./src/ekfukf"

########################################
# process commandline args

function ret=localargv()
    ret=cell(10);
    ret{1}='2';
    ret{2}='src/grid/clusterSmallWorld.m';
    ret{3}='5';
    ret{4}='src/gridUpdate/addLaplace.m';
    ret{5}='10';
    ret{6}='src/attacks/localSpike.m';
    ret{7}='src/loads/gaussian.m';
    ret{8}='src/powerObservations/Observed.m';
    ret{9}='src/extractKL/localKL.m';
    ret{10}='src/filters/ukfSM.m';
endfunction

if exist('argv')==5
    if length(argv())==0
        argv=localargv;
    elseif length(argv())!=10
        printf("ERROR: length of argv()=%d is incorrect\n",length(argv()));
        exit();
    endif
else
    argv=localargv;
endif

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
# helper functions

function ret=getFilename(a)
    splt=strsplit(a,"/.");
    ret=splt{max(1,length(splt)-1)};
endfunction

indicator = @(x) x>0;

figure('visible','off');

########################################
# run simulation

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
filtername=[basename,'-',getFilename(filter)]
print('-color','-dpsc',[filename,'.eps']);

########################################
# output results

source('src/evaluate.m');
csvwrite([filtername,'-deltaThresholds.csv'],deltaThresholds);
csvwrite([filtername,'-omegaThresholds.csv'],omegaThresholds);
csvwrite([filtername,'-thetaThresholds.csv'],thetaThresholds);
csvwrite([filtername,'-attackThresholds.csv'],attackThresholds);
csvwrite([filtername,'-separation.csv'],separation);
