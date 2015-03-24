function demofig()
try
[filename, filepath]=uigetfile({'vertical\*.mat'},'Select Files to Analyze',...
    'multiselect','off');
catch
    [filename, filepath]=uigetfile({'*.mat'},'Select Files to Analyze',...
    'multiselect','off');
end

%if the user did not select anything (hit cancel), just exit the function
%with no further messaging.
if filename==0
    return
end

b=load([filepath filename]);
    fn=fields(b);
    fn=fn{1};
rr=addPrediction(b.(fn));
plotneuron(rr(~rr.ispursuittrial&rr.hlaser==7&rr.hpeak>0,:))
plotneuron(rr(~rr.ispursuittrial&rr.hlaser==6&rr.hpeak>0,:))
plotneuron(rr(~rr.ispursuittrial&rr.hlaser==7&rr.hpeak<0,:))
plotneuron(rr(~rr.ispursuittrial&rr.hlaser==6&rr.hpeak<0,:))