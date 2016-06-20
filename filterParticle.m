#
# Generates the Xhat for the in-scope simulation using particle method
#

KLsize = numgen*numload;
modelsize = numgen+numgen+numload;

res_mse=zeros(KLsize,1);


start=200;
stop=800;

for particle=1:KLsize
    M = [delta0;omega0;theta0];
    P = [1e-5*eye(modelsize)];
    Xhat=zeros(modelsize,totalTime);


    K_Lparticle=zeros(KLsize);
    K_Lparticle(particle)=9;
    K_Lparticle=resize(K_Lparticle,numload,numgen);

    printf("particle=%d\n",particle);
    fflush(stdout);

    for i=start:stop
        [Mp,Pp]=kf_predict(M,P,A_attacked(K_Lparticle)(i),[],[],-[zeros(numgen*2,1);inv(B_LL)*P_L(i)]);
        [M,P,K,IM,IS,IH]=kf_update(Mp,Pp,X(:,i),eye(modelsize),1e-5*eye(modelsize));
        Xhat(:,i)=M;
    endfor

    res_mse(i,1)=norm(X(:,start:stop)-Xhat(:,start:stop),"fro");
    norm(X(:,start:stop)-Xhat(:,start:stop),"fro")
endfor
