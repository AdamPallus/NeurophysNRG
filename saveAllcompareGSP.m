%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then uses bestFitSdf on each file, and saves the output in a
%.mat file.

%note: this function was messed up accidentally. It used to run
%bestFitSdfLR
function output=saveAllcompareGSP

%read in the data file that I exported from R (see mm in code chunk
%"significant" where I just do all the testing for regression significance
d=readtable('C:\Users\adam2\Documents\MATLAB\NeurophysNRG\gspsSTATS.csv');
%identify the neurons with a difference between gs and ps
filenames=d.Neuron((d.p_left_slope<0.001|d.p_left_int<0.001|d.p_right_slope<0.001|d.p_right_int<0.001)&(d.p_left<0.001|d.p_right<0.001));

%fit a model to gs and ps separately for each of the identified neurons
otable=table();
for f =1:length(filenames)
    try
    tt=tic; %Start Timing
    filename=[filenames{f},'-prediction.mat'];
    filepath=('C:\Users\adam2\Documents\MATLAB\NeurophysNRG\vertical\');
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
    shiftvals=[20:10:200];
%     shiftvals=[100];display('DEBUGGING')
    o=bestFitSdfLR(t(t.isgs,:),shiftvals);
    o=o(o.rsquared==max(o.rsquared),:);
    o=o(1,:);
    o.gsp='gs';
    otable=vertcat(otable,o)
    
    o=bestFitSdfLR(t(~t.isgs,:),shiftvals);
    o=o(o.rsquared==max(o.rsquared),:);
    o=o(1,:);
    o.gsp='ps';
    otable=vertcat(otable,o)
    display(t(~t.isgs,:).trialnum{1})
    clear b
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
otable=getcoefs(otable);
display('Saving Results...')
output=otable;
try
    writetable(otable,'gspsComparisonFULL.csv')
catch
    output=otable;
    display('Save Failed')
end

    