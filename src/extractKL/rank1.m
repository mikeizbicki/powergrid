
KLsize = numload+numgen;
modelsize = numgen+numgen+numload;

initM = [zeros(numload,1);ones(numgen,1)];

extractKL = @(x) x(modelsize+1:modelsize+numload,1)*x(modelsize+numload+1:modelsize+numload+numgen,1)';


