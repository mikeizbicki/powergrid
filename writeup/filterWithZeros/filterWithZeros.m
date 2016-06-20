#
# Generates the Xhat for the in-scope simulation
#

KLsize = numgen*numload;
modelsize = numgen+numgen+numload;


# three different vairations on the softmax function
softmax = @(alpha,M) max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen));
#softmax = @(alpha,M) max(max(M))*(max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen)));
#softmax = @(alpha,M) max(max(M))*arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)));

zeroset=[];

for j=1:numgen*numload

    # reset all simulation parameters
    M = [delta0;omega0;theta0;zeros(KLsize,1)];
    P = [1e-6*eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
    Xhat=zeros(modelsize+KLsize,totalTime);

    # simulate
    for i=1:totalTime
        printf("j=%d; zeroset=[%s ]; iteration=%d\n",j,sprintf("%d",zeroset),i);
        fflush(stdout);

        # predict
        [M,P]=ukf_predict1(M,P,dynamicsKL(i));
        P=P+1e-3*eye(modelsize+KLsize);

        # update
        [M,P,K,MU,S,LH]=ukf_update1(M,P,X(:,i),@(x,k) extractDOT(x),1e-1*eye(modelsize));
        #MKL=softmax(10,extractKL(M));
        #MKL=extractKL(M);
        #MKL=arrayfun (@(x) ifelse(x>1e-10,x,0), MKL);
        #M=[extractDOT(M);vec(MKL)];
        M(zeroset)=zeros(size(zeroset));
        Xhat(:,i)=M;
    endfor

    #update zeroset

    kl=vec(extractKL(mean(Xhat,2)));
    klsmall=kl;
    klsmall(~any(klsmall,2),:)=[];
    zeroset=[zeroset;find(kl==min(klsmall))+numgen*2+numload];

    # generate plot
    source "plotK_L.m"
    print(sprintf("filterWithZeros-%04d.eps",j),"-color");
endfor

