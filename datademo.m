addpath(genpath('NeurophysNRG'))
addpath(genpath('NRGStimAnalysis'))
addpath('C:\Users\adam2\Documents\GitHub\2dmd')
%%
EHAnalysis;
%%
t=readtable('peakAnalysis.csv');
height(t)
length(unique(t.Neuron))

%%
tic
load('./Resort/SE17Oct11Sorted.mat')
r=recalculatevels(SE17Oct11);
% viewspikes(r);
r=mystruct2table(r);
showmodelLR(r,150)
toc

%%
browseStim