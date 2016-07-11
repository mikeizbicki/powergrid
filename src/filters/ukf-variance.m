#
# Generates the Xhat for the in-scope simulation
#

KLsize = numgen*numload;
modelsize = numgen+numgen+numload;

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);

for i=1:totalTime
    printf("iteration=%d\n",i);
    fflush(stdout);

    # predict
    [M,P]=ukf_predict1(M,P,dynamicsKL(i));
    P=P+[1e-5*eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), 1e-3*eye(KLsize)];

    # update
    [M,P,K,MU,S,LH]=ukf_update1(M,P,X(:,i),@(x,k) extractDOT(x),1e-3*eye(modelsize));
    MKL=extractKL(M);
    M=[extractDOT(M);vec(MKL)];
    Xhat(:,i)=M;

endfor

source "plotK_L.m"


