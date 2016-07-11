#
# Defines the non-attack loads being supplied by a powergrid
#

########################################
# params

powerIntensity=1;
noiseLength=1000;
smoothLength=1000;

########################################
# define loads

P_L0=powerIntensity*rand(numload,1);
P_L = @(n) P_L0;

powerNoise=stepsize*randn(rows(P_L0),noiseLength+smoothLength);
for i=1:noiseLength
    powerNoise(:,i)=sum(powerNoise(:,i:i+smoothLength),2);
endfor
P_L = @(n) (powerNoise(:,1+mod(n,noiseLength))).*P_L0 + attackMultiplier(n>attackTime)*P_attack;

