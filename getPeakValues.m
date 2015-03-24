%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then extracts the peak head velocity and peak firing rate of
%the neuron and returns one tall table.

function t=getPeakValues

try
[filenames, filepath]=uigetfile({'Resort\*.mat'},'Select Files to Analyze',...
    'multiselect','on');
catch
    [filenames, filepath]=uigetfile({'*.mat'},'Select Files to Analyze',...
    'multiselect','on');
end

%if there is only one file selected, it will be a character array. Convert
%this to a cell array so we don't have to keep checking.
if ~iscell(filenames)
    filenames={filenames};
end
%if the user did not select anything (hit cancel), just exit the function
%with no further messaging.
if filenames{1}==0
    return
end
t=table();
for f =1:length(filenames)
%     try
    tt=tic; %Start Timing
    filename=filenames{f};
    r=load([filepath, filename]);
    %These files should contain one variable. Get its name.
    fn=fields(r);
    fn=fn{1};
    %Create the table of fits (This takes a long time)
    display(sprintf('Calculating %s...',fn))
    if ~isa(r.(fn),'table')
        nowarning=1;
        r.(fn)=mystruct2table(r.(fn),nowarning);
    end
    
    r=addsdf(r.(fn),15);
    r=recalculatevels(r);
    r.Neuron=cellfun(@(a) {a(1:9)},r.trialnum);
    r.trial=cellfun(@(a) str2num(a(16:end)),r.trialnum);
    r.isgap=cellfun(@(a) ~isempty(regexp(a,'gap')),r.ttype);
    r.isgs=cellfun(@(a) ~isempty(regexp(a,'Delay')),r.ttype);
    r.isstep=cellfun(@(a) ~isempty(regexp(a,'[Rr]amp')),r.ttype);
    r.is2traj=cellfun(@(a) ~isempty(regexp(a,'rajec')),r.ttype);
    r=r(~r.isgap,:);
    clear gosig;clear dchange
    for i =1:height(r)
        
        a=abs(r.stageaccelerations{i});
        g=find(a(1:end-1)<150 & a(2:end) > 150);
        if r.isgs(i)
            gosig(i)=NaN;
            dchange(i)=NaN;
        else
            gosig(i)=g(1);
            if r.is2traj(i)
                if length(g)>1
                    dchange(i)=g(2);
                else
                    dchange(i)=NaN;
                end
            else %probably step ramp
                dchange(i)=NaN;
            end
        end
    end
    
    %r.maxFR=findmaxfr(r,4)';
   
    r.maxsdf=cellfun(@maxabsDC,r.sdf,num2cell(dchange'),num2cell(gosig'));
    r.head_peak=cellfun(@maxabsDC,r.headvelocities,num2cell(dchange'),num2cell(gosig'));
    
    r.maxh=cellfun(@maxDC,r.headvelocities,num2cell(dchange'),num2cell(gosig'));
    r.minh=cellfun(@minDC,r.headvelocities,num2cell(dchange'),num2cell(gosig'));
    
    r=r(:,end-9:end);
    t=vertcat(t,r);
%     catch
%         warning('failed')
%         continue
%     end
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

function o=minDC(a,directionChange,goSignal)
    if ~isnan(directionChange)
        try
            a=a(goSignal:directionChange);
        catch
            a=a(goSignal:end);
        end
    end
    o=min(a);
function o=maxDC(a,directionChange,goSignal)
    if ~isnan(directionChange)
        try
            a=a(goSignal:directionChange);
        catch
            a=a(goSignal:end);
        end
    end
    o=max(a);
    