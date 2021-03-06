#
# Create a random ring shaped powergrid
#

########################################
# parameters

global numgen=gridsize;
global numload=gridsize;

########################################
# generate grid parameters

M=0.125*eye(gridsize);
D=0.2*eye(gridsize);
K_I=-40*eye(gridsize);
K_P=-5*eye(gridsize);

B_GG=-10*eye(gridsize);
B_GL=10*eye(gridsize);
B_LG=B_GL';
B_LL=-20*eye(gridsize);
for i=[1:gridsize]
    i1=i;
    i2=mod(i-2,gridsize)+1;
    B_LL(i1,i2)=5;
    B_LL(i2,i1)=5;
endfor

B=[B_GG,B_GL;B_LG,B_LL];
