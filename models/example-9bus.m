#
# This file generates a powergrid corresponding to the case study in AMRPcISGT2015.pdf
#

source("params.m");

numgen=3;
numload=6;
M=diag([0.125,0.034,0.016]);
D=diag([0.125,0.068,0.032]);
K_P=diag([-2,-9,-3]);
K_I=diag([-35,-40,-35]);

B_GG=[-17.4,0,0;0,16,0;0,0,-17.1];
B_GL=[17.4,0,0,0,0,0;0,-16,0,0,0,0;0,0,17.1,0,0,0];
B_LG=[17.4,0 ,0
     ;0   ,16,0
     ;0   ,0 ,17.1
     ;0   ,0 ,0
     ;0   ,0 ,0
     ;0   ,0 ,0];
B_LL=[-24.3,0    ,0    ,3.5 ,3.4  ,0
     ;0    ,-46.3,0    ,16.4,0    ,13.9
     ;0    ,0    ,-53.8,0   ,16.7 ,20
     ;3.5  ,16.4 ,0   ,-19.9,0    ,0
     ;3.4  ,0    ,16.7 ,0   ,-20.1,0
     ;0    ,13.9 ,20   ,0   ,0    ,-33.9];
B=[B_GG,B_GL;B_LG,B_LL];

P_L0=[1;1;1;1;1;1];
P_L = @(n) P_L0+(indicator(n>attackTime)*[0;0;0.7;0;0;0]);

K_L = sparse([4],[1],[10],numload,numgen);

#delta0=zeros(numgen,1);
#omega0=zeros(numgen,1);
#theta0=zeros(numload,1);

delta0=[-0.034466; 0.020581;-0.051547];
omega0=[-0.165154; 0.102456;-0.248189];
theta0=[ 0.060740; 0.131104; 0.099074; 0.168979; 0.142341; 0.141706];

attackTime=100;
totalTime=1000;
stepsize=0.001;

source("mkDynamics.m");
