#
# Defines the attack parameters
#

numattacks=1;
attackTime=100;
totalTime=2000;
stepsize=0.001;

########################################
# the attack

attackLoad=ceil(numload*rand(numattacks,1));
attackGen=mod(attackLoad+ceil(3*laplace_rnd(1,1)),numgen)+1;
K_L=sparse(attackLoad,attackGen,ones(numattacks,1),numload,numgen);

P_attack=sparse([attackLoad],[1],[1e-1],numload,1);

attackMultiplier = @(n) indicator(n>attackTime);
#A_attacked = @(K_L) @(n) A+A_attack(K_L)*indicator(n>attackTime);
#A_attacked = @(K_L) @(n) A+A_attack(K_L)*min(1,max(0,(n-attackTime)/1000));

