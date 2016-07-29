#
# This file creates the dynamic system based on the in-scope powergrid variables.
#

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

########################################
# binary search for setting the K_L

maxmul=2;
minmul=0.5;
factor=0.01;
itr=0;

while max(abs(eig(A+A_attack(maxmul*K_L)))) < 1+factor/numload
    maxmul*=2;
    printf("maxmul=%d\n",maxmul);
    fflush(stdout);
endwhile

while max(abs(eig(A+A_attack(minmul*K_L)))) > 1+2*factor/numload
    minmul*=2;
    printf("minmul=%d\n",minmul);
    fflush(stdout);
endwhile

while true
    curmul=(maxmul+minmul)/2;
    cureig=max(abs(eig(A+A_attack(curmul*K_L))));
    if maxmul==minmul
        break
    elseif cureig<(1+factor/numload)
        minmul=curmul;
    elseif cureig>(1+2*factor/numload)
        maxmul=curmul;
    else
        break;
    endif
    itr+=1;
    printf("cureig=%f;curmul=%f\n",cureig,curmul);
    fflush(stdout);
endwhile
K_L *= curmul;

########################################

dynamics = @(n) @(x) A_attacked(K_L)(n)*x - [zeros(numgen*2,1);invB_LL*P_L(n)];

dynamicsKL = @(n) @(x) [A_attacked(extractKL(x))(n),zeros(numgen*2+numload,KLsize)
                       ;zeros(KLsize,numgen*2+numload),eye(KLsize)
                       ]*x - [zeros(numgen*2,1);invB_LL*P_L_obs(n);zeros(KLsize,1)];

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
