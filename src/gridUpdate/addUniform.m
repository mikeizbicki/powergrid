#
# Takes an existing powergrid, and adds a connection between two random loads
#

i=ceil(rand()*numload);
j=ceil(rand()*numload);

str=5;

B_LL(i,j)=str;
B_LL(j,i)=str;
B_LL(i,i)=B_LL(i,i)-str;
B_LL(j,j)=B_LL(j,j)-str;
