function [mdlLeft, mdlRight, d]=modeltester(r,plotgsp)
if nargin<2
    plotgsp=1;
end
%if the input was a string, assume it was a filename for a .mat file
%will cause an error if it is not the right file format
if ischar(r)
    neuron=load(r);
    f=fields(neuron);
    r=neuron.(f{1});
end
spmaxfr=findmaxfr(r,4,100,500);
figure('name',r.trialnum{1}(1:end-3))
if ~plotgsp
    scatter(r.hpeak,spmaxfr)
else
    hold on
    for i =1:length(r.hpeak)
        gs=strcmp(r.ttype,'Adam_Delay01');
    end
    scatter(r.hpeak(gs),spmaxfr(gs),'displayname','Gaze Shifts')
    scatter(r.hpeak(~gs),spmaxfr(~gs),'displayname','Pursuit')
    legend toggle

d=dataset(r.hpeak',spmaxfr',gs');
d.Properties.VarNames={'HeadV','FR','GS'};
modelfit='FR ~ HeadV+GS';
mdlLeft=stepwiselm(d(d.HeadV<0,:),modelfit);
mdlRight=stepwiselm(d(d.HeadV>0,:),modelfit);
end