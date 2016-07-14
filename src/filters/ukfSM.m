#
# Generates the Xhat for the in-scope simulation
#

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);
KLindices=[modelsize+1:modelsize+KLsize];

# three different vairations on the softmax function
#softmax = @(alpha,M) max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen));
#softmax = @(alpha,M) max(max(M))*(max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen)));
#softmax = @(alpha,M) max(max(M))*arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)));

softmax = @(alpha,M) max(0,exp(M)/sum(exp(M))-ones(size(M))/length(M));

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
    MKL=softmax(1/stepsize,M(modelsize+1:modelsize+KLsize,1));
    #window=10;
    #MKL=max([MKL,Xhat(modelsize+1:modelsize+KLsize,max(1,i-window):i)],[],2);
    M=[M(1:modelsize,1);MKL]

    #M(modelsize+1,modelsize+KLsize)=max(max([M(modelsize+1:modelsize+KLsize),
    Xhat(:,i)=M;
endfor

source "src/plotK_L.m"


