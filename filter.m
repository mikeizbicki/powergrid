#
# Generates the Xhat for the in-scope simulation
#

KLsize = numgen*numload;
modelsize = numgen+numgen+numload;

M = [delta0;omega0;theta0;zeros(KLsize,1)];
P = [1e-6*eye(modelsize), zeros(modelsize,KLsize); zeros(KLsize,modelsize), eye(KLsize)];
Xhat=zeros(modelsize+KLsize,totalTime);

#M = [delta0;omega0;theta0];
#P = [1*eye(modelsize)];
#Xhat=zeros(modelsize,totalTime);

for i=1:totalTime
    #if mod(i,10)==0
        printf("%d\n",i);
        fflush(stdout);
    #endif

    #if i>=attackTime
        #M(modelsize+4,1)=10;
    #endif

    #P=P+1-3*eye(modelsize+KLsize);
    P=eye(modelsize+KLsize);
    [M,P]=ukf_predict1(M,P,dynamicsKL(i));
    P=P+1*eye(modelsize+KLsize);
    #P=eye(modelsize+KLsize);
    [M,P,K,MU,S,LH]=ukf_update1(M,P,X(:,i),@(x,k) extractDOT(x),1e-1*eye(modelsize));
    softmax = @(alpha,M) max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen));
    #softmax = @(alpha,M) max(max(M))*(max(0,arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)))-ones(numload,numgen)/(numload*numgen)));
    #softmax = @(alpha,M) max(max(M))*arrayfun(@(x) exp(x*alpha),M)/sum(sum(arrayfun(@(x) exp(x*alpha),M)));
    #MKL=softmax(10,extractKL(M));
    #MKL=arrayfun (@(x) ifelse(x>1e-10,x,0), MKL);
    #M=[extractDOT(M);vec(MKL)];
    Xhat(:,i)=M;

    #P=P+1e-3*eye(modelsize);
    #[M,P]=ukf_predict1(M,P,dynamics(i));
    #Xhat(:,i)=M;
endfor
