#
# Create a random powergrid similar to the clusterSmallWorld model
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

j1=1;
while j1<numload
    j2=min(numload,j1+2+ceil(5*abs(laplace_rnd(1,1))));
    for i=[j1:j2]
        i1=i;
        i2=mod(i-2,j2-j1+1)+j1
        B_LL(i1,i2)=5;
        B_LL(i2,i1)=5;
    endfor
    j1=j2+1;
endwhile

B=[B_GG,B_GL;B_LG,B_LL];

