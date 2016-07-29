#! /usr/bin/octave -qf
##! /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/octave/4.0.0/bin/octave -qf

addpath "./src/ekfukf"

########################################
# process commandline args

function ret=localargv()
    ret=cell(10);
    ret{1}='2';
    ret{2}='src/grid/clusterSmallWorld.m';
    ret{3}='30';
    ret{4}='src/gridUpdate/addUniform.m';
    ret{5}='30';
    ret{6}='src/attacks/spike.m';
    ret{7}='src/loads/gaussian.m';
    ret{8}='src/powerObservations/Unobserved.m';
    #ret{9}='src/extractKL/localKL.m';
    ret{9}='src/extractKL/rank1.m';
    ret{10}='src/filters/ukf.m';
endfunction

graphics_toolkit gnuplot
figure('visible','off');
if exist('argv')==5
    if length(argv())==0
        argv=localargv;
        figure('visible','on');
    elseif length(argv())!=10
        printf("ERROR: length of argv()=%d is incorrect\n",length(argv()));
        exit();
    endif
else
    figure('visible','on');
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
    splt1=strsplit(a,'/');
    splt2=strsplit(splt1{length(splt1)},'.');
    ret=splt2{length(splt2)-1};
endfunction

indicator = @(x) x>0;

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

source(kl);
source("src/mkDynamics.m");
source("src/sample.m");
basename=['results/',num2str(seed),'-',getFilename(grid),'-',num2str(gridsize),'-',getFilename(gridUpdate),'-',num2str(numconn),'-',getFilename(attack),'-',getFilename(load),'-',getFilename(powerObservations),'-',getFilename(kl),]
source('src/plotX.m');
orient('tall');
print('-color','-dpsc','-landscape','-tight',[basename,'.eps']);
source(filter);
source('src/plotK_L.m');
filtername=[basename,'-',getFilename(filter)]
print('-color','-dpsc','-landscape','-tight',[filtername,'.eps']);

########################################
# output results

source('src/evaluate.m');
csvwrite([filtername,'-deltaThresholds.csv'],deltaThresholds);
csvwrite([filtername,'-omegaThresholds.csv'],omegaThresholds);
csvwrite([filtername,'-thetaThresholds.csv'],thetaThresholds);
csvwrite([filtername,'-attackThresholds.csv'],attackThresholds);
csvwrite([filtername,'-separation.csv'],separation);
