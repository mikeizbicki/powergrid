#
# Create a random powergrid
#

source("params.m");

########################################
# parameters

numgen=8;
numload=16;
B_density=0.25;

numattacks=2;
attackTime=100;
totalTime=1000;
stepsize=0.001;

powerIntensity=10;
noiseLength=10000;
smoothLength=250;

########################################
# generate grid parameters

M=0.3*diag(rand(numgen,1));
D=0.3*diag(rand(numgen,1));
K_I=-50*diag(rand(numgen,1));
K_P=-10*diag(rand(numgen,1));

#B_GG=50*(0.5-sprand(numgen ,numgen ,B_density));
#B_GL=-[B_GG,zeros(numgen,numload-numgen)];
##B_GL=50*(0.5-sprand(numgen ,numload,B_density));
#
#B_LG=50*(0.5-sprand(numload,numgen ,B_density));
#B_LL=50*(0.5-sprand(numload,numload,B_density));
#B_LL(1,1)=B_LL(1,1)-sum(sum(B_LL))-sum(sum(B_LG));
#B=[B_GG,B_GL;B_LG,B_LL];

B_GG=50*(abs(sprand(numgen ,numgen ,B_density)));
B_GL=-[B_GG,zeros(numgen,numload-numgen)];
#B_GL=50*(abs(sprand(numgen ,numload,B_density)));

B_LG=50*(abs(sprand(numload,numgen ,B_density)));
B_LL=50*(abs(sprand(numload,numload,B_density)));
B_LL(1,1)=B_LL(1,1)-sum(sum(B_LL))-sum(sum(B_LG));
B=[B_GG,B_GL;B_LG,B_LL];

########################################
# the attack

K_L=sprand(numload,numgen,numattacks/numload/numgen);

[attackLoad,attackGen]=find(K_L~=0);

P_attack=sparse([attackLoad],[1],[1e-1],numload,1);

########################################
# generate load inputs

P_L0=0*powerIntensity*rand(numload,1);
P_L = @(n) P_L0;

powerNoise=1e-10*randn(rows(P_L0),noiseLength+smoothLength);
for i=1:noiseLength
    powerNoise(:,i)=sum(powerNoise(:,i:i+smoothLength),2);
endfor
P_L = @(n) (powerNoise(:,1+mod(n,noiseLength))).*P_L0 + indicator(n>attackTime)*P_attack;

########################################
# create system

delta0=zeros(numgen,1);
omega0=zeros(numgen,1);
theta0=zeros(numload,1);

source("mkDynamics.m");
