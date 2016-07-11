
time=linspace(0,totalTime*stepsize,totalTime);
plotStartTime=1;
plotStopTime=totalTime;
plot(time,X'(plotStartTime:plotStopTime,1:numgen)                     ,"1" # delta0
    ,time,X'(plotStartTime:plotStopTime,numgen+1:numgen*2)            ,"2" # omega0
    ,time,X'(plotStartTime:plotStopTime,numgen*2+1:numgen*2+numload)  ,"3" # theta0
    )
drawnow();
