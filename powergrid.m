################################################################################
# Given the system parameters and the system state,
# returns the updated system state at the next time step

function [delta1,omega1,theta1] = propogate(M,D,K_I,K_P,B_GG,B_GL,B_LG,B_LL,P_L,delta,omega,theta,K_L)
    F=0.01*[zeros(rows(K_I),columns(K_I)), eye(rows(K_P)), zeros(rows(B_GL),columns(B_GL));
       inv(M)*(K_I-B_GG)            , inv(M)*(K_P-D), -inv(M)*B_GL                   ;
       B_LG                         , -K_L          , B_LL                           ];
    G=eye(rows(delta)+rows(omega)+rows(theta))+F;
    H=[zeros(rows(delta),1);zeros(rows(omega),1);P_L];

    ret=G*[delta;omega;theta]+H;

    delta1=ret(1:rows(delta),1);
    omega1=ret(rows(delta)+1:rows(delta)+rows(omega),1);
    theta1=ret(rows(delta)+rows(omega)+1:rows(ret),1);
endfunction

########################################
# repeats the above construction for N timesteps

function [deltaN,omegaN,thetaN] = propogateN(M,D,K_I,K_P,B_GG,B_GL,B_LG,B_LL,P_L,delta,omega,theta,K_L,N)
    deltaN=zeros(rows(delta),0);
    omegaN=zeros(rows(omega),0);
    thetaN=zeros(rows(theta),0);
    for i=1:N
        [delta1,omega1,theta1]=propogate(M,D,K_I,K_P,B_GG,B_GL,B_LG,B_LL,P_L,delta,omega,theta,K_L,N);
        delta=delta1;
        omega=omega1;
        theta=theta1;
        deltaN=[deltaN,delta1];
        omegaN=[omegaN,omega1];
        thetaN=[thetaN,theta1];
    endfor
endfunction

################################################################################
# This function estimates the K_L parameter at a given iteration

function f = mkDynamics(M,D,K_I,K_P,B,P_L,delta0,omega0,theta0,K_L0)
    F=[zeros(rows(K_I),columns(K_I)), eye(rows(K_P)), zeros(rows(B_GL),columns(B_GL));
       inv(M)*(K_I-B_GG)            , inv(M)*(K_P-D), -inv(M)*B_GL                   ;
       B_LG                         , -K_L          , B_LL                           ];
    G=eye(rows(delta)+rows(omega)+rows(theta))+F;
    H=[zeros(rows(delta),1);zeros(rows(omega),1);P_L];

    ret=G*[delta;omega;theta]+H;

    delta1=ret(1:rows(delta),1);
    omega1=ret(rows(delta)+1:rows(delta)+rows(omega),1);
    theta1=ret(rows(delta)+rows(omega)+1:rows(ret),1);
    #f = @(state)
endfunction

########################################
#
# Returns:
#   x1      = estimated state parameters at time 1
#
# Given:
#   y1      = observations at time 1
#   f       = system dynamics
#   lambda1 = weight of the predicted values based on system dynamics
#   lambda2 = weight of the regularization term
#   reg     = regularization function (should be convex)
#
########################################

function x1hat=filterUpdate(y1, x0hat, P0, Q, f, lambda, reg)
    g = @(x) norm(y1-x) + norm(f(x0hat)-x) + lambda*reg(x);
    x1hat = fminunc(g,x0hat);
endfunction

