function viewmodel(s,formula)

%heavily trimmed down version of EHanalysis that takes the output of
%EHanalysis and just lets you view them
if nargin<1
    display('This function requires a structure input - run EHAnalysis to load an H5 file')
    return
end
if nargin < 2
    formula=0;
end
if ~isfield(s,'realspiketimes')
%     errordlg('These spiketimes have not been spikesorted','Not Updated')
    display('Update structure with field ''realspiketimes''')
    return
end

%create or fix velocities and accelerations
for i =1:length(s.headpositions)
    s.headvelocities{i}=parabolicdiff(s.headpositions{i},7);
    s.headaccelerations{i}=parabolicdiff(s.headvelocities{i},7);
    s.eyevelocities{i}=parabolicdiff(s.eyepositions{i},7);
    s.eyeaccelerations{i}=parabolicdiff(s.eyevelocities{i},7);
end

[s.mLeft,s.mRight,s.leftShift,s.rightShift,s.leftShiftEye,s.rightShiftEye]=bestFit(s,0);
if formula
    [s.mLeft2,s.mRight2,s.leftShift2,s.leftShiftEye2,s.rightShiftEye2]=bestFit(s,0,formula);
else
    [s.mLeft2,s.mRight2,s.leftShift2,s.leftShiftEye2,s.rightShiftEye2]=bestFit(s,1);
end

%fit a really complex model instead
% [s.mLeft2,s.mRight2,s.leftShift2,s.rightShift2]=bestFitpval(s,1);


s.CurrentTrial=1;
s.spikeMaxFr=300;

s.MainFigure = figure('name', 'Data Viewer', 'numbertitle', 'off');
set(gcf,'CloseRequestFcn',@my_closefcn)
s.listbox = uicontrol('Style', 'listbox',...
    'Position', [8,67,120,320]);

set(s.listbox,'string',[s.trialnum]);
set(s.MainFigure,'toolbar','figure')
s.maxFrBox=uicontrol('style','edit','string','300');
s.maxFrBox.TooltipString='Ylim for Spike Window (0-1000)';
set(s.maxFrBox,'callback',{@frCallback s});
set(s.listbox,'Callback', {@ListCallback s});
PlotTrial(s)


end
function frCallback(cbo,varargin)
s=varargin{2};
x=str2num(cbo.String);
if x < 2000 && x > 0
    s.spikeMaxFr=x;
else
    cbo.String=300;
end
s.CurrentTrial=s.listbox.Value;
PlotTrial(s)
end

function my_closefcn(cbo,~)
% User-defined close request function 
% to display a question dialog box 
%    selection = questdlg('Close This Figure?',...
%       'Close Request Function',...
%       'Yes','No','Yes'); 
%    switch selection, 
%       case 'Yes',
%          delete(gcf)
%       case 'No'
%       return 
%    end
whitebg('w')
delete(cbo)
end

function ListCallback(cbo,varargin)

s=varargin{2};
s.CurrentTrial=get(cbo,'Value');
s.spikeMaxFr=str2num(s.maxFrBox.String);
PlotTrial(s)
end

function PlotTrial(s)

plotVertical=0;
SelectedTrial=s.CurrentTrial;
triallength=s.triallength(SelectedTrial);


%***************
%horizontal positions
%****************
hp=subplot(3,1,1);

whitebg('k')
hold off
plot(s.gazepositions{SelectedTrial},'g')
hold on
plot(s.headpositions{SelectedTrial},'c')
plot(s.stagepositions{SelectedTrial},'r')
plot(s.stagepositions2{SelectedTrial},'b')
plot(s.eyepositions{SelectedTrial},'y')
xlim([0,triallength])
%eye limits%%%%%%%%%%
plot(ones(1,triallength)*20,':w')
plot(ones(1,triallength)*-20,':w')


%horizontal velocities
%horizontal velocities
%horizontal velocities

subplot(3,1,2)
hold off
plot(s.gazevelocities{SelectedTrial},'g')
hold on
plot(s.stagevelocities{SelectedTrial},'r')
plot(s.stagevelocities2{SelectedTrial},'b')
plot(s.headvelocities{SelectedTrial},'c')
plot(s.eyevelocities{SelectedTrial},'y')
plot(zeros(1,triallength),'w')
xlim([0,triallength])

try
    plot([s.pursuitstart(SelectedTrial),s.pursuitstart(SelectedTrial)],[-70,70], 'LineStyle', ':','LineWidth', 1, 'Color', 'g');
end
try
    plot([s.hstart(SelectedTrial),s.hstart(SelectedTrial)],[-70,70], 'LineStyle', ':','LineWidth', 1, 'Color', 'c');
end
try
    plot([s.goSignal(SelectedTrial),s.goSignal(SelectedTrial)],[-150,150], 'LineStyle', ':','LineWidth', 2, 'Color', 'r');
end

%%%%spikes

spikewindowsize=s.spikeMaxFr;
subplot(3,1,3)
hold off
plot(0:1/25:length(s.wf{SelectedTrial})/25-1/25,s.wf{SelectedTrial}/10,'b')


hold on


    if isfield(s,'realspiketimes')
        spiketimes=s.realspiketimes{SelectedTrial};
        scolor=[1 1 0];
    else
        spiketimes=s.offlinespikes{SelectedTrial};
        scolor=[0 1 0];
    end
    
    if ~isempty(spiketimes)
       
        plot(spiketimes, 200,'Markersize',4,'Marker','v','Linestyle','none','color',scolor);
        if length(spiketimes)>3
            smoothSize=1;
            spiketimes=smooth(spiketimes,smoothSize); %smooth for histogram
            histo=spiketimes(2:end)-spiketimes(1:end-1);
            histo=1./histo*1000;
            b=bar(spiketimes(2:end),histo,'hist');
            set(b,'facecolor','none')
            %%%%%%%%%%
            %%Plot Model Predictions
            %%%%%%%%%%
            tType=ones(size(s.headpositions{SelectedTrial}'))*strcmp(s.ttype{SelectedTrial},'Adam_Delay01');
            d=dataset(s.headpositions{SelectedTrial}',s.headvelocities{SelectedTrial}',s.headaccelerations{SelectedTrial}',...
                s.eyepositions{SelectedTrial}',s.eyevelocities{SelectedTrial}',s.eyeaccelerations{SelectedTrial}',tType,'varnames',...
                {'hp','hv','ha','ep','ev','ea','tType'});
            if s.hpeak(SelectedTrial)<0
                m=s.mLeft;
                shift=s.leftShift;
                shifteye=s.leftShiftEye;
                m2=s.mLeft2;
            else
                m=s.mRight;
                shift=s.rightShift;
                shifteye=s.rightShiftEye;
                m2=s.mRight2;
            end
            p=predict(m,d);
            p2=predict(m2,d);
            if shift > 0
                plot(p(shift:end),'w','linewidth',1.5)
                plot(p2(shift:end),'r','linewidth',1.5)
            else
                shift=abs(shift);
                if shift==0;shift=1;end
                plot(shift:length(p),p(1:end-shift+1),'w','linewidth',1.5)
                plot(shift:length(p2),p2(1:end-shift+1),'r','linewidth',1.5)
            end
            title(sprintf(['(white)Model1 = ',m.Formula.char,...
                           '  |   R^2 = %.2f, Hshift=%d Eshift=%d\n (red)Model2 = ',...
                m2.Formula.char,'   |   R^2 = %.2f'],...
                m.Rsquared.Ordinary,shift,shifteye,m2.Rsquared.Ordinary))
            
        end

    end


ylim([max(-100,spikewindowsize/2*-1),spikewindowsize])
%ylim([-800,800])
xlim([0,triallength])
hold off
set(gcf,'name', ['Data Viewer: ', s.trialnum{SelectedTrial}, ' ', s.ttype{SelectedTrial}]);
end

function [mLeft, mRight,bestLeft,bestRight,bestLeftEP,bestRightEP]= bestFit(r,fitTtype,formula)
if nargin<2
    %useTType indicates that the model should be fit using trial type (gaze
    %shift or pursuit task) as an option. Trial type is a factor (0 for
    %pursuit or 1 for gaze shift)
    fitTtype=1;
end
if nargin<3
    formula=0;
end

count=0;
%find the best shift for the largest possible model
progressbar=waitbar(0,'Finding Best Shift');
% for i =-200:10:200
for i =0:10:200
    count=count+1;
    waitbar(count/length(0:10:200),progressbar)
    dLeft=makeSpikeDataset(r,i,'left');
    dRight=makeSpikeDataset(r,i,'right');
    
    %     mdl=fitlm(dLeft,'fr~hp+hv+ha+ep+ev+ea+tType');
    mdl=fitlm(dLeft,'fr~hv');
    shiftLeft(count)=i;
    rsquareLeft(count)=mdl.Rsquared.Ordinary;
    
    mdl=fitlm(dLeft,'fr~ep');
    epshiftLeft(count)=i;
    eprsquareLeft(count)=mdl.Rsquared.Ordinary;
    
    %     mdl=fitlm(dRight,'fr~hp+hv+ha+ep+ev+ea+tType');
    mdl=fitlm(dRight,'fr~hv');
    shiftRight(count)=i;
    rsquareRight(count)=mdl.Rsquared.Ordinary;
    
    
    mdl=fitlm(dRight,'fr~ep');
    epshiftRight(count)=i;
    eprsquareRight(count)=mdl.Rsquared.Ordinary;
end
close(progressbar)
bestLeft=shiftLeft(rsquareLeft==max(rsquareLeft));
bestRight=shiftRight(rsquareRight==max(rsquareRight));

bestLeftEP=epshiftLeft(eprsquareLeft==max(eprsquareLeft));
bestRightEP=epshiftRight(eprsquareRight==max(eprsquareRight));

%return the stepwise model for the left and right
dLeft=makeSpikeDataset(r,bestLeft,'left');
dRight=makeSpikeDataset(r,bestRight,'right');

dLeftEP=makeSpikeDataset(r,bestLeftEP,'left');
dRightEP=makeSpikeDataset(r,bestRightEP,'right');

dLeft(:,5:7)=dLeftEP(:,5:7);
dRight(:,5:7)=dRightEP(:,5:7);

% mLeft=stepwiselm(dLeft,'fr~hv','criterion','rsquared','verbose',0);
% mRight=stepwiselm(dRight,'fr~hv','criterion','rsquared','verbose',0);

%Omit trial type as an option for the fit
if ~fitTtype
    %omit the 8th column: trial type from the datasets
    dLeft=dLeft(:,1:7);
    dRight=dRight(:,1:7);
end

if ~formula
    mLeft=stepwiselm(dLeft,'fr~1','criterion','rsquared','verbose',0,...
        'penter',0.05,'premove',0.025);
    mRight=stepwiselm(dRight,'fr~1','criterion','rsquared','verbose',0,...
        'penter',0.05,'premove',0.025);
else
    mLeft=fitlm(dLeft,formula);
    mRight=fitlm(dRight,formula);
end
end

function vels=parabolicdiff(pos,n)
if nargin<2
    n=9;
end

q = sum(2*((1:n).^2));

vels=zeros(size(pos));
c=-conv(pos,[-n:-1 1:n],'valid');
vels(1:n)=ones(n,1)*c(1);
vels(end-n+1:end)=ones(n,1)*c(end);
vels(n:end-n)=c;
vels=vels/q*1000;

end
function d=makeSpikeDataset(celldata,shift,leftorright)
if nargin<2
    shift=0;
end
if nargin<3
    leftorright='both';
end

    n=length(celldata.realspiketimes);
    shift=num2cell(repmat(shift,[1 n]));    
    switch(leftorright)
        case {'left'}
            slice=celldata.hpeak<0;
        case{'right'}
            slice=celldata.hpeak>0;
        otherwise
            slice=ones(1,length(celldata.hpeak));
    end
    %just extract the behavior parameters at each spike time from the data
    %stored in cell arrays
    isgs=strcmp(celldata.ttype,'Adam_Delay01');
    isgs=num2cell(isgs);
    
    headpositions=celldata.headpositions(slice);
    eyepositions=celldata.eyepositions(slice);
    sm=7; %size of parabolic smoothing
    
    headvelocities=cellfun(@(a) parabolicdiff(a,sm),headpositions,'uniformoutput',false);
    headaccelerations=cellfun(@(a) parabolicdiff(a,sm),headvelocities,'uniformoutput',false);
    
    eyevelocities=cellfun(@(a) parabolicdiff(a,sm),eyepositions,'uniformoutput',false);
    eyeaccelerations=cellfun(@(a) parabolicdiff(a,sm),eyevelocities,'uniformoutput',false);
    

    
    [hp,hv,ha,ep,ev,ea,isgs,fr]=cellfun(@docalc,celldata.realspiketimes(slice),...
                              headpositions,...
                              headvelocities,...
                              headaccelerations,...
                              eyepositions,...
                              eyevelocities,...
                              eyeaccelerations,...
                              isgs(slice),...                              
                              shift(slice),...
                              'uniformoutput',false);
     %it comes out with each trial's data in a cell. 
     %Put all of that together into one array since we don't care about trials                      
     fr=cell2mat(fr);
     hp=cell2mat(hp);hv=cell2mat(hv);ha=cell2mat(ha);
     ep=cell2mat(ep);ev=cell2mat(ev);ea=cell2mat(ea);
     isgs=isgs(cellfun(@islogical,isgs));
     isgs=cell2mat(isgs);
try
     d=dataset(fr',hp',hv',ha',ep',ev',ea',isgs','varnames',{'fr','hp','hv','ha','ep','ev','ea','tType'});
catch
    display([length(fr),length(hp),length(hv),length(ha),length(ep),length(ev),length(ea),length(isgs)])
end
         
end

function [hp,hv,ha,ep,ev,ea,isgs,fr]=docalc(spiketimes,hp,hv,ha,ep,ev,ea,isgs,shift)
smoothval=0;
if isempty(spiketimes) || length(spiketimes)<2
    fr=[];
    hp=[];hv=[];ha=[];
    ep=[];ev=[];ea=[];
    isgs=[];
    
    return
else
    hp(end+1:10000)=NaN;hv(end+1:10000)=NaN;ha(end+1:10000)=NaN;
    ep(end+1:10000)=NaN;ev(end+1:10000)=NaN;ea(end+1:10000)=NaN;
    
    fr=spiketime2FR(spiketimes,smoothval);    
    spiketimes=round(spiketimes)+shift;
    mask=spiketimes(spiketimes>0);
    
    hp=hp(mask);hv=hv(mask);ha=ha(mask);
    ep=ep(mask);ev=ev(mask);ea=ea(mask);

    fr=fr(spiketimes>0);
    isgs=repmat(isgs,size(fr));
end
end
