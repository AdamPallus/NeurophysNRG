%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then fits the linear model fr~rhp+lhp+rep+lep to each, just
%looking at the portions where the eyes and head are not moving. Also
%subsets to just the gaze shift trials

function findAllStatic
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

for f =1:length(filenames)
    try
    tt=tic; %Start Timing
    filename=filenames{f};
    b=load([filepath, filename]);
    %These files should contain one variable. Get its name.
    fn=fields(b);
    fn=fn{1};
    %Create the table of fits (This takes a long time)
    display(sprintf('Calculating %s...',fn))
    if ~isa(b.(fn),'table')
        b.(fn)=mystruct2table(b.(fn));
    end
    o=bestFitStatic(b.(fn),300);
    clear b
    savename=[fn,'-StaticFit.mat'];
    save([filepath, savename],'o');
    clear o
    x(f)=toc(tt);
    display(sprintf('Saved %s... It took %0.1f minutes.',fn,x(f)/60))
    estimate=mean(x)*(length(filenames)-f);
    display(sprintf('Estimating %0.1f minutes remaining',estimate/60))
    catch
        warning('failed')
        continue
    end
end

%I give it the cell structure. It returns the best model for left and right

function o= bestFitStatic(r,fixDur)
% function [mLeft, mRight,bestLeft,bestRight]= bestFitSdf(r)

possibleShifts=0:10:200;

%find the best shift for the largest possible model
progressbar=waitbar(0,'Finding Best Shift');
r=addsdf(r,15);
r=recalculatevels(r);
for i =1:length(possibleShifts)
    tic
    waitbar(i/length(0:10:200),progressbar)
    d=sdftableLR(r,possibleShifts(i),fixDur);

    d=d(d.rhv+d.lhv+d.lev+d.rev<5,:);
    d=d(d.dgs==1,:);
    m=fitlm(d,'fr~lhp+rhp+lep+rep');
    shift(i)=possibleShifts(i);
    rsquared(i)=m.Rsquared.Adjusted;
    coef{i}=m.Coefficients;
    f{i}=m.Formula.char;
    x(i)=toc;
    estimate=mean(x)*(length(possibleShifts)-i);
    waitbar(i/length(0:10:200),progressbar,sprintf('Time Remaining: %0.0f min %0.0f seconds',floor(estimate/60),floor(mod(estimate,60))))   
end

close(progressbar)

% o=table(shift,ml,mr,'variablenames',{'shift','ml','mr'});
o=table(shift',rsquared',f',coef','variablenames',{'shift','rsquared','f','coef'});


    