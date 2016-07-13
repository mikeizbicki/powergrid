#
# This file creates the dynamic system based on the in-scope powergrid variables.
#

#KLsize = numgen*numload;
KLsize = numload;
modelsize = numgen+numgen+numload;

########################################
# dynamics functions

A = [ eye(numgen)                  , stepsize*eye(numgen)                   , zeros(numgen,numload)
    ; stepsize*inv(M)*(K_I-B_GG)   , eye(numgen)+stepsize*inv(M)*(K_P-D)    , -stepsize*inv(M)*B_GL
    ; -inv(B_LL)*B_LG              , zeros(numload,numgen)                  , zeros(numload,numload)
    ];

A = 0.999*A/max(abs(eig(A)));

invB_LL = full(inv(B_LL));

A_attack = @(K_L) [zeros(numgen,numgen)  , zeros(numgen,numgen)  , zeros(numgen,numload)
                  ;zeros(numgen,numgen)  , zeros(numgen,numgen)  , zeros(numgen,numload)
                  ;zeros(numload,numgen) , invB_LL*K_L           , zeros(numload,numload)
                  ];

A_attacked = @(K_L) @(n) A+A_attack(K_L)*attackMultiplier(n);

cureig=max(abs(eig(A+A_attack(K_L))));
curmul=1;
factor=0.01;
itr=0;
while itr<500 && (cureig<(1+factor/numload) || cureig>(1+2*factor/numload))
    itr+=1;
    cureig=max(abs(eig(A+A_attack(K_L*curmul))));
    printf("cureig=%f;curmul=%f\n",cureig,curmul);
    fflush(stdout);
    if cureig>1.01
        curmul/=1+1/itr;#**1.3;
    else
        curmul*=1+1/itr;
    endif
endwhile
K_L *= curmul;

#while max(abs(eig(A+A_attack(K_L))))<1.005
    #K_L *= 1.005;
#endwhile

dynamics = @(n) @(x) A_attacked(K_L)(n)*x - [zeros(numgen*2,1);invB_LL*P_L(n)];

extractDOT = @(x) x(1:numgen*2+numload);

########################################
# noise parameters

Qmodel  = 1e-3*eye(modelsize);      # process noise in model
Qkl     = 1e-3*eye(KLsize);         # process noise in parameters
Q       = [Qmodel,zeros(modelsize,KLsize);zeros(KLsize,modelsize),Qkl];
R       = 1e-3*eye(modelsize);      # measurement noise

########################################
# create system

delta0=zeros(numgen,1);
omega0=zeros(numgen,1);
theta0=zeros(numload,1);
