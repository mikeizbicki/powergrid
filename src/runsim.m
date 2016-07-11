#! /usr/bin/octave -qf

addpath "./ekfukf"

grid="models/complete.m";
gridsize=10;
numconn=1500;
attack="attacks/spike.m";
load="loads/gaussian.m";
filter="filters/ukf.m";

#grid=argv(){1};
#gridsize=str2double(argv(){2});
#numconn=str2double(argv(){3});
#attack=argv(){4};
#load=argv(){5};
#filter=argv(){6};

function ret=getFilename(a)
    splt=strsplit(a,"/.");
    ret=splt{length(splt)-1};
endfunction

source("params.m");
source(grid);
for i=[1:numconn]
    source("models/addLoadConnection.m")
endfor
source(attack);
source(load);
printf("attackTime=%d\n",attackTime);

source("mkDynamics.m");
source("sample.m");
basename=['results/',getFilename(grid),'-',num2str(gridsize),'-',num2str(numconn),'-',getFilename(attack),'-',getFilename(load)]
print('-color','-dpsc',[basename,'.eps']);
source(filter);
filename=[basename,'-',getFilename(filter),'.eps']
print('-color','-dpsc',filename);
