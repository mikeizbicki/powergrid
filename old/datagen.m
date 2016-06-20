#
# This file generates some sample data for simulating power grids
#

source ("filter.m")

####################
# these parameters control the "shape" of the data

# simulation parameters
attackTime=10;
totalTime=50;
stepsize=0.001;

# random power grid parameters
numgen=6;
numload=4;
B_density=0.5;
numattacks=1;

####################
# utilities

rand("seed",0);
randn('seed',0);

indicator = @(x) x>0;

####################
# generate the data

# initial data from Figure 1
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

P_L0=[0;0;0;0;0;0];
P_L = @(n) P_L0+(indicator(n>attackTime)*[0;0.7;0;0;0;0]);
#P_L = @(n) P_L0+(indicator(n>attackTime)*[0;0;0;0.7;0;0]);

K_L = sparse([4],[1],[5],numload,numgen);

# random initial data
#M=diag(rand(numgen,1));
#D=diag(rand(numgen,1));
#K_I=diag(rand(numgen,1));
#K_P=diag(rand(numgen,1));
#
#B_GG=sprand(numgen ,numgen ,B_density);
#B_GL=sprand(numgen ,numload,B_density);
#B_LG=sprand(numload,numgen ,B_density);
#B_LL=sprand(numload,numload,B_density);
#B=[B_GG,B_GL;B_LG,B_LL];

#P_L0=1e6*rand(numload,1);
##P_L = @(n) P_L0;
#P_L = @(n) (eye(rows(P_L0))+10*randn(rows(P_L0)))*P_L0;

# initial system states
delta=zeros(numgen,1);
omega=zeros(numgen,1);
theta=zeros(numload,1);

# generate attacks that destabilize the system
# FIXME: this attack formula isn't guaranteed to destabilize
#K_L=1e2*sprand(numload,numgen,numattacks/numload/numgen);

# generate a stable system dynamics based on the above data
dyn=[eye(numgen)               , stepsize*eye(numgen)
    ;stepsize*inv(M)*(K_I-B_GG), eye(numgen)+stepsize*inv(M)*(K_P-D)];

origdyn=[ eye(numgen),eye(numgen),zeros(numgen,numload)
        ; inv(M)*(K_I-B_GG), eye(numgen)+inv(M)*(K_P-D), -inv(M)*B_GL
        ; B_LG, -K_L, B_LL ]/max(abs(eig(dyn)));

#dyn=dyn/max(abs(eig(dyn)));

f = @(x) dyn*x;

# generate the system constraints
cnst = @(n) @(x) [B_LG, -K_L*0 ] * x + P_L(n);
#cnst = @(n) @(x) [B_LG, -K_L*indicator(n>attackTime) ] * x + P_L(n);

####################
# construct modified dynamics for interpolating the K_L values

moddyn=[eye(numgen*numload),zeros(numgen*numload,columns(dyn))
       ;zeros(rows(dyn),numgen*numload),dyn];

modf = @(x) moddyn*x;

modcnst= @(n) @(x) cnst(n)(x(numgen*numload+1:numgen*numload+rows(dyn)));

#modl1 = @(x) norm(x,1);
modl1 = @(x) norm(x(1:numgen*numload),1);

################################################################################

x0 = [delta;omega];
P0 = 0.00*eye(numgen+numgen);
Q  = 0.00*eye(numgen+numgen);

noreg = @(x) norm(x,1);

X=sample(x0,Q,f,cnst,totalTime);
plot(X'(:,1:3),"1",X'(:,4:6),"2")

#Xhat=[];
#x0hat=[zeros(numgen*numload,1);x0];
#for i=1:totalTime
    #y1=[zeros(numgen*numload,1);X(:,i)];
    #x1hat=filterUpdate(y1, x0hat, eye(rows(moddyn)), eye(rows(moddyn)), modf, modcnst(i), 1e71, modl1);
    #Xhat=[Xhat,x1hat];
    #x0hat=x1hat;
#endfor
