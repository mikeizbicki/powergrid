time=linspace(0,totalTime*stepsize,totalTime);
plotStartTime=1;
plotStopTime=totalTime;


########################################
# plot loads and generators

#attacks=[numgen*2+numload*attackGen+attackLoad];
attacks=[numgen*2+numload+attackLoad];

Xhat_attacks=Xhat(attacks,:);
Xhat_safe=Xhat;
Xhat_safe([[1:numgen*2+numload]' ;attacks],:)=[];
Xhat_safe_max=max(Xhat_safe,[],1);

#semilogy(time,Xhat_safe_max'(plotStartTime:plotStopTime,:),"2"
        #,time,Xhat_attacks' (plotStartTime:plotStopTime,:),"1"
    #)

#plot(time,Xhat_safe    '(plotStartTime:plotStopTime,:),"2"
    #,time,Xhat_attacks' (plotStartTime:plotStopTime,:),"1"
    #)

########################################
# plot loads only

#Xhat_loads=Xhat(numgen*2+numload+[1:numload:numgen*numload],:);
Xhat_loads=Xhat(numgen*2+numload+[1:numload],:);
Xhat_loads_safe=Xhat_loads;
Xhat_loads_safe(attackLoad,:)=[];
Xhat_loads_attacks=Xhat_loads(attackLoad,:);
#for i=[1:numgen-1]
    #Xhat_loads2=Xhat(numgen*2+numload+numgen*i+[1:numload],:);
    #Xhat_loads_safe2=Xhat_loads2;
    #Xhat_loads_safe2(attackLoad,:)=[];
    #Xhat_loads_safe+=Xhat_loads_safe2;
    #Xhat_loads_attacks2=Xhat_loads2(attackLoad,:);
    #Xhat_loads_attacks+=Xhat_loads_attacks2;
#endfor

plot(time,Xhat_loads_safe'    (plotStartTime:plotStopTime,:),"2"
    ,time,Xhat_loads_attacks' (plotStartTime:plotStopTime,:),"1"
    );
drawnow();
