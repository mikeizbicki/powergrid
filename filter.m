#
# Generates the Xhat for the in-scope simulation
#

KLsize = numgen*numload;
modelsize = numgen+numgen+numload;

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);

# three different vairations on the softmax function
softmax = @(alpha,M) max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen));
#softmax = @(alpha,M) max(max(M))*(max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen)));
#softmax = @(alpha,M) max(max(M))*arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)));

zeroset=[];

for i=1:totalTime
    printf("iteration=%d\n",i);
    fflush(stdout);

    # predict
    [M,P]=ukf_predict1(M,P,dynamicsKL(i));
    P=P+1e-1*eye(modelsize+KLsize);
    P=P+[1e-3*eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), 1e1*eye(KLsize)];

    # update
    [M,P,K,MU,S,LH]=ukf_update1(M,P,X(:,i),@(x,k) extractDOT(x),1e-3*eye(modelsize));
    #MKL=softmax(10,extractKL(M));
    #MKL=extractKL(M);
    #MKL=arrayfun (@(x) ifelse(x>1e-10,x,0), MKL);
    #M=[extractDOT(M);vec(MKL)];
    M(zeroset)=zeros(size(zeroset));
    Xhat(:,i)=M;

endfor

kl=vec(extractKL(mean(Xhat,2)));
klsmall=kl;
klsmall(~any(klsmall,2),:)=[];
med=median(klsmall);
zeroset=[zeroset;find(max(0,med-kl))+numgen*2+numload];

source "plotK_L.m"
