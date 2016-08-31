#! /usr/bin/octave -qf

filename=argv(){1};

graphics_toolkit gnuplot
figure('visible','off');

seps=csvread(filename);
indicator = @(x) x>0;
acc=sum(indicator(seps),1)/rows(seps);
plot([1:2000]/1000,acc);
print('-color','-dpsc','-tight',[filename,'-fraction.eps']);
#print('-color','-dpsc','-landscape','-tight',[filename,'-fraction.eps']);

