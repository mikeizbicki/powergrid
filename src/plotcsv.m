hold off
seps=csvread('results/clusterSmallWorld-10-addUniform-5-spike-gaussian-Unobserved-fullKL-separation.csv' );
indicator = @(x) x<0;
acc=sum(indicator(seps),1)/rows(seps);
plot([1:2000],acc);

hold on
function csv2roc(file)
    data=csvread(file) ;
    ave=sum(data,1)/rows(data);
    stddev=sum(sqrt((data-ave).*(data-ave)/rows(data)),1);

    Y=[0:0.01:1, 1:0.1:50];
    Y(ave==2000)=max(Y(ave<2000));
    plot(ave,Y,'1');
endfunction
csv2roc ('results/clusterSmallWorld-10-addUniform-5-spike-gaussian-Unobserved-fullKL-attackThresholds.csv');
