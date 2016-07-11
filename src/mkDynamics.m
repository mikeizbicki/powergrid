#
# This file creates the dynamic system based on the in-scope powergrid variables.
#

source("params.m");

A = [ eye(numgen)                  , stepsize*eye(numgen)                   , zeros(numgen,numload)
    ; stepsize*inv(M)*(K_I-B_GG)   , eye(numgen)+stepsize*inv(M)*(K_P-D)    , -stepsize*inv(M)*B_GL
    ; -inv(B_LL)*B_LG              , zeros(numload,numgen)                  , zeros(numload,numload)
    ];

A = 0.999*A/max(abs(eig(A)));

A_attack = @(K_L) [zeros(numgen,numgen)  , zeros(numgen,numgen)  , zeros(numgen,numload)
                  ;zeros(numgen,numgen)  , zeros(numgen,numgen)  , zeros(numgen,numload)
                  ;zeros(numload,numgen) , inv(B_LL)*K_L         , zeros(numload,numload)
                  ];

A_attacked = @(K_L) @(n) A+A_attack(K_L)*attackMultiplier(n);

while max(abs(eig(A+A_attack(K_L))))<1.005
    K_L *= 1.01;
endwhile

dynamics = @(n) @(x) A_attacked(K_L)(n)*x - [zeros(numgen*2,1);inv(B_LL)*P_L(n)];

extractDOT = @(x) x(1:numgen*2+numload);
extractKL = @(x) reshape(x(numgen*2+numload+1:numgen*2+numload+numgen*numload,1),numload,numgen);

#dynamicsKL = @(n) @(x) [A_attacked(K_L)(n),zeros(numgen*2+numload,numgen*numload)
dynamicsKL = @(n) @(x) [A_attacked(sparse(extractKL(x)))(n),zeros(numgen*2+numload,numgen*numload)
                       ;zeros(numgen*numload,numgen*2+numload),eye(numgen*numload)
                       ]*x - [zeros(numgen*2,1);inv(B_LL)*P_L(n);zeros(numgen*numload,1)];

########################################
# create system

delta0=zeros(numgen,1);
omega0=zeros(numgen,1);
theta0=zeros(numload,1);
