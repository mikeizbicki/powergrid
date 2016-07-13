#
# Generates the Xhat for the in-scope simulation
#

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);

for i=1:totalTime
    printf("iteration=%d\n",i);
    fflush(stdout);

    # predict
    P=P+Q;
    #[M,P,sigma,sigmaw]=ukf_predict3(M,P,dynamicsKL(i),Q,R);
    dyn = @(x) [dynamicsKL(i)(x(1:modelsize+KLsize));x];#max(-0.1,x(modelsize+KLsize+1:rows(x)))];
    [M,P,sigma,sigmaw]=ukf_predict3(M,P,dyn,Q,R);

    # update
    [M2,P2,K,MU,S,LH]=ukf_update3(M,P,X(:,i),@(x,k) extractDOT(x),R,sigma,sigmaw);
    M=M2(1:modelsize+KLsize);
    P=P(1:modelsize+KLsize,1:modelsize+KLsize);
    Xhat(:,i)=M;
endfor

source "src/plotK_L.m"


