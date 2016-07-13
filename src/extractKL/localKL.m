
KLmat=eye(numload);
for i=[1,2,3,4,numload-1,numload-2,numload-3,numload-4]
    KLmat+=circshift(eye(numload),i);
endfor
extractKL = @(x) KLmat.*repmat(reshape(x(numgen*2+numload+1:numgen*2+numload+numload,1),numload,1),1,numload);

dynamicsKL = @(n) @(x) [A_attacked(extractKL(x))(n),zeros(numgen*2+numload,KLsize)
                       ;zeros(KLsize,numgen*2+numload),eye(KLsize)
                       ]*x - [zeros(numgen*2,1);invB_LL*P_L_obs(n);zeros(KLsize,1)];

