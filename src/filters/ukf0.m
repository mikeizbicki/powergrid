#
# Generates the Xhat for the in-scope simulation
#

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);
KLindices=[modelsize+1:modelsize+KLsize];

for i=1:totalTime
    if i>attackTime && X(1:modelsize,i-1)==zeros(modelsize,1)
        break;
    endif

    printf("iteration=%d\n",i);
    fflush(stdout);

    # predict
    [M,P]=ukf_predict1(M,P,dynamicsKL(i));
    P=P+Q;

    # update
    [M,P,K,MU,S,LH]=ukf_update1(M,P,X(:,i),@(x,k) extractDOT(x),R);
    M([KLindices])=max(0,M([KLindices]));
    Xhat(:,i)=M;
endfor

source "src/plotK_L.m"


