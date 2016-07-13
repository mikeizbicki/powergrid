
extractKL = @(x) ones(numgen,1)*reshape(x(numgen*2+numload+1:numgen*2+numload+numload,1),numload,1)';

dynamicsKL = @(n) @(x) [A_attacked(extractKL(x))(n),zeros(numgen*2+numload,KLsize)
                       ;zeros(KLsize,numgen*2+numload),eye(KLsize)
                       ]*x - [zeros(numgen*2,1);invB_LL*P_L_obs(n);zeros(KLsize,1)];

