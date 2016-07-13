#
# Generates the Xhat for the in-scope simulation
#

numstates=numload+1;

M = [delta0;omega0;theta0];
X_p = cell(numstates);
for i=[1:numstates]
    X_p{i}=M;
endfor

P = eye(modelsize);
P_p = cell(numstates);
for i=[1:numstates]
    P_p{i}=P;
endfor

prob=0.999;
mu=[(1-prob)*ones(1,numload)/numload,prob];

p_ij=0.9*eye(numstates)+0.01*ones(numstates)/numstates;
#p_ij=0.9*eye(numstates);
for i=[1:numstates-1]
    P_ij(i,j)=0.25;
    P_ij(j,i)=0.25;
endfor

dims=modelsize;

Acell=cell(numstates);
Qcell=cell(numstates);
Hcell=cell(numstates);
Rcell=cell(numstates);
ind=cell(numstates);
for i=[1:numload]
    attackKL=zeros(numgen,numload);
    attackKL(i,:)=1;
    Acell{i}=A+A_attack(attackKL);
    Qcell{i}=Qmodel;
    Hcell{i}=eye(modelsize);
    Rcell{i}=R;
    ind{i}=[1:modelsize];
endfor
Acell{numload+1}=A;
Qcell{numload+1}=Qmodel;
Hcell{numload+1}=eye(modelsize);
Rcell{numload+1}=R;
ind{numload+1}=[1:modelsize];

Xhat=zeros(modelsize+numstates,totalTime);

for i=1:totalTime
    printf("iteration=%d\n",i);
    fflush(stdout);

    # predict
    for j=[1:numload]
        P_p{j}+=Qmodel;
    endfor
    [X_p,P_p,mu,X2,P2]=imm_filter(X_p,P_p,mu,p_ij,ind,dims,Acell,Qcell,X(:,i),Hcell,Rcell);
    #Xhat(1:modelsize,i)=X2;
    Xhat(modelsize+1:modelsize+numstates,i)=mu';
endfor

source "src/plotK_L.m"


