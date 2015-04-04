function viewspikes(s,playSound)

%heavily trimmed down version of EHanalysis that takes the output of
%EHanalysis and just lets you view them
if nargin<1
    display('This function requires a structure input - run EHAnalysis to load an H5 file')
    return
end

if nargin<2
    s.playSound=0;
else
    s.playSound=playSound;
end
if ~isfield(s,'realspiketimes')
%     errordlg('These spiketimes have not been spikesorted','Not Updated')
    display('Update structure with field ''realspiketimes''')
end

s.MainFigure = figure('name', 'Data Viewer', 'numbertitle', 'off');
set(gcf,'CloseRequestFcn',@my_closefcn)
s.listbox = uicontrol('Style', 'listbox',...
    'Position', [8,67,120,320]);
set(s.listbox,'Callback', {@ListCallback s});
set(s.listbox,'string',[s.trialnum]);
set(s.MainFigure,'toolbar','figure')
PlotTrial(s,1)


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
plotThis=get(cbo,'Value');
s=varargin{2};
if s.playSound
    w=double(s.wf{plotThis});
    sound(w/max(w),25000)
end
PlotTrial(s,plotThis)
end

function PlotTrial(s,plotThis)

comparecells=0;

plotVertical=0;
triallength=s.triallength(plotThis);


%***************
%horizontal positions
%****************
hp=subplot(3,1,1);

whitebg('k')
hold off
plot(s.gazepositions{plotThis},'g')
hold on
plot(s.headpositions{plotThis},'c')
plot(s.stagepositions{plotThis},'r')
plot(s.stagepositions2{plotThis},'b')
plot(s.eyepositions{plotThis},'y')
xlim([0,triallength])
%eye limits%%%%%%%%%%
plot(ones(1,triallength)*20,':w')
plot(ones(1,triallength)*-20,':w')


%horizontal velocities
%horizontal velocities
%horizontal velocities

subplot(3,1,2)
hold off
plot(s.gazevelocities{plotThis},'g')
hold on
plot(s.stagevelocities{plotThis},'r')
plot(s.stagevelocities2{plotThis},'b')
plot(s.headvelocities{plotThis},'c')
plot(s.eyevelocities{plotThis},'y')
plot(zeros(1,triallength),'w')
xlim([0,triallength])

try
    plot([s.pursuitstart(plotThis),s.pursuitstart(plotThis)],[-70,70], 'LineStyle', ':','LineWidth', 1, 'Color', 'g');
end
try
    plot([s.hstart(plotThis),s.hstart(plotThis)],[-70,70], 'LineStyle', ':','LineWidth', 1, 'Color', 'c');
end
try
    plot([s.goSignal(plotThis),s.goSignal(plotThis)],[-150,150], 'LineStyle', ':','LineWidth', 2, 'Color', 'r');
end

%%%%spikes

spikewindowsize=300;
subplot(3,1,3)
hold off
try
plot(0:1/25:length(s.wf{plotThis})/25-1/25,s.wf{plotThis}/10,'b')
end

hold on

if comparecells
    cell1=s.cell1{plotThis};
    cell2=s.cell2{plotThis};
    
    if ~isempty(cell1)
        plot(cell1, 220,'Markersize',4,'Marker','v','Linestyle','none','color',[1,0,0]);
    end
    if ~isempty(cell2)
        plot(cell2, 200,'Markersize',4,'Marker','v','Linestyle','none','color',[1,1,0]);
    end
    
else
    if isfield(s,'realspiketimes')
        spiketimes=s.realspiketimes{plotThis};
        scolor=[1 1 0];
    else
        spiketimes=s.offlinespikes{plotThis};
        scolor=[0 1 0];
    end
    oldspiketimes=s.offlinespikes{plotThis};
    
    if ~isempty(spiketimes)
       
        if ~isempty(oldspiketimes)
            plot(oldspiketimes, 220,'Markersize',4,'Marker','v','Linestyle','none','color',[1,0,0]);
        end
        plot(spiketimes, 200,'Markersize',4,'Marker','v','Linestyle','none','color',scolor);
        if length(spiketimes)>3
            spiketimes=smooth(spiketimes,4); %smooth for histogram
            histo=spiketimes(2:end)-spiketimes(1:end-1);
            histo=1./histo*1000;
            b=bar(spiketimes(2:end),histo,'hist');
            set(b,'facecolor','none')
        end
        title('Spike Sorting in Yellow, Amplitude-only in Red')
    end
end

ylim([-100,spikewindowsize])
%ylim([-800,800])
xlim([0,triallength])
hold off
set(gcf,'name', ['Data Viewer: ', s.trialnum{plotThis}, ' ', s.ttype{plotThis}]);
end