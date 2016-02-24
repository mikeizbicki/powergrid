#
# This file creates the dynamical system based on the in-scope powergrid variables.
#

source("params.m");

A = [ eye(numgen)                  , stepsize*eye(numgen)                   , zeros(numgen,numload)
    ; stepsize*inv(M)*(K_I-B_GG)   , eye(numgen)+stepsize*inv(M)*(K_P-D)    , -stepsize*inv(M)*B_GL
    ; -inv(B_LL)*B_LG              , zeros(numload,numgen)                  , zeros(numload,numload)
    ];

A_attacked = [zeros(numgen,numgen)  , zeros(numgen,numgen)  , zeros(numgen,numload)
             ;zeros(numgen,numgen)  , zeros(numgen,numgen)  , zeros(numgen,numload)
             ;zeros(numload,numgen) , inv(B_LL)*K_L         , zeros(numload,numload)
             ];

dynamics = @(n) @(x) (A+A_attacked*indicator(n>attackTime))*x - [zeros(numgen*2,1);P_L(n)];

