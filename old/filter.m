################################################################################ #
# This function updates a Kalman filter subject to an arbitrary constraint
#
# Input:
#  y1       = observed variables for the current iteration
#  x0hat    = estimated state of the previous iteration
#  P0       =
#  Q        =
#  f        = (possibly non-linear) system dynamics given as an arbitrary function
#  cnst     = equality constraints that the system must satisfy
#  lambda   = regularization amount
#  reg      = regularization function
#
# Output:
#  x1hat    = estimated state of the current iteration
#  P1       =
#
################################################################################
function [x1hat,P1]=filterUpdate(y1, x0hat, P0, Q, f, cnst, lambda, reg)
    g = @(x) (y1-x)'*P0*(y1-x) + (f(x0hat)-x)'*Q*(f(x0hat)-x) + lambda*reg(x) ;
    #g = @(x) (y1-x)'*P0*(y1-x) + (f(x0hat)-x)'*Q*(f(x0hat)-x) ;
    x1hat = fmincnst(g,x0hat,cnst);
    P1=P0;
endfunction

################################################################################
#
# Samples a trajectory from a (possibly) nonlinear system
#
################################################################################
function X=sample(x0, Q, f, n)
    X=zeros(rows(x0),n);
    for i=1:n
        fx0=f(i)(x0);
        #x1=fx0;
        x1=fx0+mvnrnd(zeros(rows(x0),1),Q)';
        X(:,i)=x1;
        x0=x1;

        if max(abs(x0))>100
            break;
        endif
    endfor
endfunction

################################################################################
#
# This function is like the built-in "fminunc", but allows equality constraints.
# The built-in "sqp" function didn't work for me.
#
# Input:
#  f    = function to minimuze
#  x0   = initial guess
#  cnst = this function should equal zero
#
# Output:
#  x1   = the x value that minimizes the function
#
# FIXME:
# This function doesn't properly use lagrangian multipliers.
#
################################################################################
function x1=fmincnst(f,x0,cnst)
    #for i=[1,10,100,1000,10000]
    for i=1:20
        x1=fminunc(@(x) f(x) + (2^i)*norm(cnst(x)),x0);
        x0=x1;
    endfor
    #x1=fminunc(@(x) f(x) + 10*norm(cnst(x)),x0);
    #x1=sqp(x0,f,cnst);
endfunction

