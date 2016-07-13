
samplesPerSecond=10;
sampleDistance=(1/timestep)/samplesPerSecond;

P_L_obs = @(n) P_L (n-mod(n,sampleDistance));

