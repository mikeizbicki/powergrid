#! /usr/bin/octave -qf

filename=argv(){1};


graphics_toolkit gnuplot
figure('visible','off');

data=csvread(filename) ;
ave=sum(data,1)/rows(data);
stddev=sum(sqrt((data-ave).*(data-ave)/rows(data)),1);

Y=[0:0.01:1, 1:0.1:50];
Y(ave==2000)=max(Y(ave<2000));
plot(ave,Y,'1');
print('-color','-dpsc','-tight',[filename,'-thresholds.eps']);
#print('-color','-dpsc','-landscape','-tight',[filename,'-thresholds.eps']);
