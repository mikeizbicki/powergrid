#
# Generates the Xhat for the in-scope simulation using a particle method
#

KLsize = numgen*numload;
modelsize = numgen+numgen+numload;

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);

mse=zeros(modelsize+numload*numgen,totalTime);

for particle=0:numload*numgen
    for i=1:totalTime
        printf("particle=%d; iteration=%d\n",particle,i);
        fflush(stdout);

        # predict
        [M,P]=ukf_predict1(M,P,dynamicsKL(i));
        P=P+1e-6*eye(modelsize+KLsize);
        #loc=numgen*2+numload*attackGen+attackLoad+1;
        loc=numgen*2+numload+particle;
        P(loc,loc)=1e3;

        # update
        [M,P,K,MU,S,LH]=ukf_update1(M,P,X(:,i),@(x,k) extractDOT(x),1e-3*eye(modelsize));
        MKL=extractKL(M);
        M=[extractDOT(M);vec(MKL)];
        Xhat(:,i)=M;

        # bookkeeping
        mse(loc,i)=norm(extractDOT(Xhat(:,i))-X(:,i));
    endfor
endfor

source "plotK_L.m"

