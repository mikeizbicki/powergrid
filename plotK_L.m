time=linspace(0,totalTime*stepsize,totalTime);
plotStartTime=1;
plotStopTime=totalTime;

attacks=[numgen*2+numload*attackGen+attackLoad];

Xhat_attacks=Xhat(attacks,:);
Xhat_safe=Xhat;
Xhat_safe([[1:numgen*2+numload]' ;attacks],:)=[];
Xhat_safe_max=max(Xhat_safe,[],1);

#semilogy(time,Xhat_safe_max'(plotStartTime:plotStopTime,:),"2"
        #,time,Xhat_attacks' (plotStartTime:plotStopTime,:),"1"
    #)

plot(time,Xhat_safe    '(plotStartTime:plotStopTime,:),"2"
    ,time,Xhat_attacks' (plotStartTime:plotStopTime,:),"1"
    )

#plot(time,Xhat_attacks' (plotStartTime:plotStopTime,:),"1"
    #)
