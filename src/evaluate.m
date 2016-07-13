
function ret=mkThresholdCurve(X,Y)
    ret=ones(size(Y))*columns(X);
    j=1;
    for i=[1:columns(X)]
        x=max(abs(X(:,i)));
        if x>=Y(j)
            ret(j)=i;
            j+=1;
            if j>columns(Y)
                break;
            endif
        endif
    endfor
endfunction

Y=[0:0.01:1, 1:0.1:50];
deltaThresholds=mkThresholdCurve(Xhat(1:numgen,:),Y);
omegaThresholds=mkThresholdCurve(Xhat(numgen+1:2*numgen,:),Y);
thetaThresholds=mkThresholdCurve(Xhat(2*numgen:2*numgen+numload,:),Y);
attackThresholds=mkThresholdCurve(Xhat(2*numgen+numload+1:2*numgen+numload+KLsize,:),Y);

Xhat_loads=Xhat(numgen*2+numload+[1:numload],:);
Xhat_loads_safe=Xhat_loads;
Xhat_loads_safe(attackLoad,:)=[];
Xhat_loads_attacks=Xhat_loads(attackLoad,:);
separation=max(Xhat_loads_attacks,[],1)-max(Xhat_loads_safe,[],1);

plot(attackThresholds',Y,"1")
plot(time,separation,"1")
