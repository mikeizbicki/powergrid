#
# Sample a trajectory from the in-scope simulation
#

source("params.m")

################################################################################
#
# Samples a trajectory from a (possibly) nonlinear system
#
################################################################################
function X=sample(x0, Q, f, n)
    X=zeros(rows(x0),n);
    for i=1:n
        fx0=f(i)(x0);
        x1=fx0;
        #x1=fx0+mvnrnd(zeros(rows(x0),1),Q)';
        X(:,i)=x1;
        x0=x1;

        if max(abs(x0))>100
            break;
        endif
    endfor
endfunction

################################################################################

x0 = [delta0;omega0;theta0];
#P0 = 0.00*eye(numgen+numgen+numload);

loadVariance=0;
Q  = [ zeros(numgen*2,numgen*2), zeros(numgen*2,numload)
     ; zeros(numload, numgen*2), loadVariance*eye(numload)
     ];

X=sample(x0,Q,dynamics,totalTime);
source "plotX.m"
