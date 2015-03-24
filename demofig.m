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
% rr=addPrediction(b.(fn));
rr=b.(fn);

f=figure;
t=uicontrol('style','text','string',['Neuron: ',fn],'fontsize',18);
t.Units='normalized';
t.Position=[0.1 0.75 0.75 0.1];

isgs=uicontrol('style','popupmenu','string',{'Gaze Shift Trials','Pursuit Trials'});
isgs.Units='normalized';
isgs.Position=[0.1 0.45 0.45 0.1];

hlaser=uicontrol('style','popupmenu','string',{'Laser 5','Laser 6','Laser 7'});
hlaser.Units='normalized';
hlaser.Position=[0.1 0.35 0.45 0.1];


b1=uicontrol(f,'string','Plot','units','normalized',...
    'position',[0.2 0.2 0.1 0.1],...
    'callback',{@plotn,rr,isgs,hlaser});
b2=uicontrol(f,'string','Plot Peak','units','normalized',...
    'position',[0.3 0.2 0.1 0.1],...
    'callback',{@plotpeak,rr});

ns=uicontrol(f,'string','Load New Cell','units','normalized',...
    'position',[0.5 0.2 0.2 0.1],...
    'callback',@newcell);
end

function newcell(~,~)
demofig
end

function plotpeak(~,~,rr)
rr.maxpredict=cellfun(@maxabsDC,rr.prediction,num2cell(rr.dchange),num2cell(rr.gosig));
figure
hold on
title([rr.Neuron{1},': SDF'])
rg=rr(rr.isgs,:);
rp=rr(~rr.isgs,:);
scatter(rg.head_peak,rg.maxsdf*1400)
scatter(rp.head_peak,rp.maxsdf*1400)
legend({'Gaze Shift','Pursuit Trials'})
figure
hold on
title([rr.Neuron{1},': Prediction -- ',rr.formula{1}])
rg=rr(rr.isgs,:);
rp=rr(~rr.isgs,:);
scatter(rg.head_peak,rg.maxpredict)
scatter(rp.head_peak,rp.maxpredict)
legend({'Gaze Shift','Pursuit Trials'})
end

function plotn(~,~,rr,isgs,hlaser)
isgs=isgs.Value;
hlaser=hlaser.Value+4;

if isgs==1
plotneuron(rr(rr.isgs&rr.hlaser==7&rr.head_peak>0,:))
plotneuron(rr(rr.isgs&rr.hlaser==6&rr.head_peak>0,:))
plotneuron(rr(rr.isgs&rr.hlaser==7&rr.head_peak<0,:))
plotneuron(rr(rr.isgs&rr.hlaser==6&rr.head_peak<0,:))
else
    
plotneuron(rr(~rr.isgs&rr.hlaser==7&rr.head_peak>0,:))
plotneuron(rr(~rr.isgs&rr.hlaser==6&rr.head_peak>0,:))
plotneuron(rr(~rr.isgs&rr.hlaser==7&rr.head_peak<0,:))
plotneuron(rr(~rr.isgs&rr.hlaser==6&rr.head_peak<0,:))
end
end

function o=maxabsDC(a,directionChange,goSignal)
    if ~isnan(directionChange)
        try
            a=a(goSignal:directionChange);
        catch
            a=a(goSignal:end);
        end
    end
    o=maxabs(a);
end
