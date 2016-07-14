#
# Defines the attack parameters
#

numattacks=1;
attackTime=100;
totalTime=2000;
stepsize=0.001;

########################################
# the attack

K_L=sprand(numload,numgen,numattacks/numload/numgen);
[attackLoad,attackGen]=find(K_L~=0);

P_attack=sparse([attackLoad],[1],[1e-1],numload,1);

attackMultiplier = @(n) indicator(n>attackTime);
#A_attacked = @(K_L) @(n) A+A_attack(K_L)*indicator(n>attackTime);
#A_attacked = @(K_L) @(n) A+A_attack(K_L)*min(1,max(0,(n-attackTime)/1000));
