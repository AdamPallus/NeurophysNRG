% function showmodel(t,lmodel,rmodel,shift)
function showmodel(t,o)
%new version takes the table output from sdftable
if ischar(t)
    disp(sprintf('Loading... %s',t))
    o=load(['Spikes Sorted\',t,'Sorted.mat']);
    t=o.(t);
end
if nargin<2
    disp(sprintf('Loading fit data...'))
    fn=[t.trialnum{1}(1:9),'-fit.mat'];
    o=load(['Spikes Sorted\',fn]);
    o=o.o;
end


%Find best left shift and model:
shiftL=o.shift(o.rL==max(o.rL));
shiftR=o.shift(o.rR==max(o.rR));
rmodel=o.mr{o.shift==shiftR};
lmodel=o.ml{o.shift==shiftL};
clear o
s.mRight=rmodel;
s.mLeft=lmodel;
s.leftShift=shiftL;
s.rightShift=shiftR;

%expand data file by calculating velocity/acceleration and spike density
t=recalculatevels(t);
t=addsdf(t);
s.t=t;

s.CurrentTrial=1;
s.spikeMaxFr=300;

s.MainFigure = figure('name', 'Data Viewer', 'numbertitle', 'off');
set(gcf,'CloseRequestFcn',@my_closefcn)
s.listbox = uicontrol('Style', 'listbox',...
    'Position', [8,67,120,320]);

set(s.listbox,'string',[s.t.trialnum]);
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
triallength=s.t.triallength(SelectedTrial);


%***************
%horizontal positions
%****************
hp=subplot(3,1,1);

whitebg('k')
hold off
plot(s.t.gazepositions{SelectedTrial},'g')
hold on
plot(s.t.headpositions{SelectedTrial},'c')
plot(s.t.stagepositions{SelectedTrial},'r')
plot(s.t.stagepositions2{SelectedTrial},'b')
plot(s.t.eyepositions{SelectedTrial},'y')
xlim([0,triallength])
%eye limits%%%%%%%%%%
plot(ones(1,triallength)*20,':w')
plot(ones(1,triallength)*-20,':w')


%horizontal velocities
%horizontal velocities
%horizontal velocities

subplot(3,1,2)
hold off
plot(s.t.gazevelocities{SelectedTrial},'g')
hold on
plot(s.t.stagevelocities{SelectedTrial},'r')
plot(s.t.stagevelocities2{SelectedTrial},'b')
plot(s.t.headvelocities{SelectedTrial},'c')
plot(s.t.eyevelocities{SelectedTrial},'y')
plot(zeros(1,triallength),'w')
xlim([0,triallength])

try
    plot([s.t.pursuitstart(SelectedTrial),s.t.pursuitstart(SelectedTrial)],[-70,70], 'LineStyle', ':','LineWidth', 1, 'Color', 'g');
end
try
    plot([s.t.hstart(SelectedTrial),s.t.hstart(SelectedTrial)],[-70,70], 'LineStyle', ':','LineWidth', 1, 'Color', 'c');
end
try
    plot([s.t.goSignal(SelectedTrial),s.t.goSignal(SelectedTrial)],[-150,150], 'LineStyle', ':','LineWidth', 2, 'Color', 'r');
end

%%%%spikes

spikewindowsize=s.spikeMaxFr;
subplot(3,1,3)
hold off
plot(0:1/25:length(s.t.wf{SelectedTrial})/25-1/25,s.t.wf{SelectedTrial}/10,'b')


hold on


    if isfield(s,'realspiketimes')
        spiketimes=s.t.realspiketimes{SelectedTrial};
        scolor=[1 1 0];
    else
        spiketimes=s.t.offlinespikes{SelectedTrial};
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
            tType=ones(size(s.t.headpositions{SelectedTrial}'))*strcmp(s.t.ttype{SelectedTrial},'Adam_Delay01');
            d=table(s.t.headpositions{SelectedTrial}',s.t.headvelocities{SelectedTrial}',s.t.headaccelerations{SelectedTrial}',...
                s.t.eyepositions{SelectedTrial}',s.t.eyevelocities{SelectedTrial}',s.t.eyeaccelerations{SelectedTrial}',tType,'variablenames',...
                {'hp','hv','ha','ep','ev','ea','tType'});
            if s.t.hpeak(SelectedTrial)<0
                m=s.mLeft;
                shift=s.leftShift;
            else
                m=s.mRight;
                shift=s.rightShift;
            end
            
            plot(s.t.sdf{SelectedTrial}*1500,'g--')
            
            p=predict(m,d);
            p(p<0)=0;
                plot(p(shift:end),'y','linewidth',1.5)

            title(sprintf(['(yellow)Model1 = ',m.Formula.char,...
                           '  |   R^2 = %.2f, shift=%d'],...
                m.Rsquared.Ordinary,shift))
            
        end

    end


ylim([max(-100,spikewindowsize/2*-1),spikewindowsize])
%ylim([-800,800])
xlim([0,triallength])
hold off
set(gcf,'name', ['Data Viewer: ', s.t.trialnum{SelectedTrial}, ' ', s.t.ttype{SelectedTrial}]);
end
