#
# Sample a trajectory from the in-scope simulation
#

source("params.m");
source("filter.m");

x0 = [delta0;omega0;theta0];
P0 = 0.00*eye(numgen+numgen+numload);

loadVariance=0;
Q  = [ zeros(numgen*2,numgen*2), zeros(numgen*2,numload)
     ; zeros(numload, numgen*2), loadVariance*eye(numload)
     ];

noreg = @(x) norm(x,1);

X=sample(x0,Q,dynamics,totalTime);
plotStartTime=1;
plotStopTime=totalTime;
plot(X'(plotStartTime:plotStopTime,1:numgen)                     ,"1" # delta0
    ,X'(plotStartTime:plotStopTime,numgen+1:numgen*2)            ,"2" # omega0
    ,X'(plotStartTime:plotStopTime,numgen*2+1:numgen*2+numload)  ,"3" # theta0
    )
#plotStartTime=attackTime-500;
#plot(X'(plotStartTime:plotStopTime,numgen+1:numgen*2)            ,"2") # omega0

