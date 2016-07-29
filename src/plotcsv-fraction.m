#! /usr/bin/octave -qf

filename=argv(){1};

seps=csvread(filename);
indicator = @(x) x>0;
acc=sum(indicator(seps),1)/rows(seps);
plot([1:2000],acc);
print('-color','-dpsc',[filename,'-fraction.eps']);

