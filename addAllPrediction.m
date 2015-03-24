%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then uses bestFitSdf on each file, and saves the output in a
%.mat file.

function addAllPrediction

try
[filenames, filepath]=uigetfile({'vertical\*.mat'},'Select Files to Analyze',...
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

for f =1:length(filenames)
    try
    tt=tic; %Start Timing
    filename=[filenames{f}];

    b=load([filepath, filename]);
    %These files should contain one variable. Get its name.
    fn=fields(b);
    fn=fn{1};
    %Create the table of fits (This takes a long time)
    display(sprintf('Calculating %s...',fn))
    if ~isa(b.(fn),'table')
        nowarning=1;
        t=mystruct2table(b.(fn),nowarning);
    else
        t=b.(fn);
    end
    t=addsdf(t);
    r=recalculatevels(t);
    t.Neuron=cellfun(@(a) {a(1:9)},r.trialnum);
    t.trial=cellfun(@(a) str2num(a(16:end)),r.trialnum);
    t.isgap=cellfun(@(a) ~isempty(regexp(a,'gap')),r.ttype);
    t.isgs=cellfun(@(a) ~isempty(regexp(a,'Delay')),r.ttype);
    t.isstep=cellfun(@(a) ~isempty(regexp(a,'[Rr]amp')),r.ttype);
    t.is2traj=cellfun(@(a) ~isempty(regexp(a,'rajec')),r.ttype);
%     r=r(~r.isgap,:);
    clear gosig;clear dchange
    for i =1:height(r)

            a=abs(r.stageaccelerations{i});
            g=find(a(1:end-1)<150 & a(2:end) > 150);
            if t.isgs(i)
                gosig(i)=t.goSignal(i);
                dchange(i)=NaN;
            else
                gosig(i)=g(1);
                if t.is2traj(i)
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
    t.gosig=gosig';
    t.dchange=dchange';
    %r.maxFR=findmaxfr(r,4)';
   
    t.maxsdf=cellfun(@maxabsDC,t.sdf,num2cell(dchange'),num2cell(gosig'));
    t.head_peak=cellfun(@maxabsDC,r.headvelocities,num2cell(dchange'),num2cell(gosig'));
    
    t.maxh=cellfun(@maxDC,r.headvelocities,num2cell(dchange'),num2cell(gosig'));
    t.minh=cellfun(@minDC,r.headvelocities,num2cell(dchange'),num2cell(gosig'));
      
    clear b
    savename=[fn,'-prediction.mat'];
    savetab.(fn)=addPrediction(t);
    save([filepath, savename],'-struct','savetab',fn);
    clear o
    x(f)=toc(tt);
    display(sprintf('Saved %s... It took %0.1f minutes.',fn,x(f)/60))
    estimate=mean(x)*(length(filenames)-f);
    display(sprintf('Estimating %0.1f minutes remaining',estimate/60))
    catch
        warning('failed')
        lasterr
        continue
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