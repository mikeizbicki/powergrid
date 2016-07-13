#
# Create a powergrid where all loads are fully connected
#

########################################
# parameters

numgen=gridsize;
numload=gridsize;

########################################
# generate grid parameters

M=0.125*eye(gridsize);
D=0.2*eye(gridsize);
K_I=-40*eye(gridsize);
K_P=-5*eye(gridsize);

M=0.05*eye(gridsize)+0.1*diag(rand(numgen,1));
D=0.05*eye(gridsize)+0.1*diag(rand(numgen,1));
K_I=-20*eye(gridsize)-30*diag(rand(numgen,1));
K_P=-5*eye(gridsize)-5*diag(rand(numgen,1));

B_GG=-10*speye(gridsize);
B_GL=10*speye(gridsize);
B_LG=B_GL';
B_LL=5*ones(gridsize,gridsize)-5*gridsize*eye(gridsize)+B_GG;

B=[B_GG,B_GL;B_LG,B_LL];
