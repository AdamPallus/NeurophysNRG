%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then uses bestFitSdf on each file, and saves the output in a
%.mat file.

%note: this function was messed up accidentally. It used to run
%bestFitSdfLR
function saveAllcompareGSP

d=readtable('C:\Users\adam2\Documents\MATLAB\NeurophysNRG\bestFitLRResort.csv');
filenames=d.Neuron;
filepath='C:\Users\adam2\Documents\MATLAB\NeurophysNRG\Resort\';

for f =1:length(filenames)
    try
    tt=tic; %Start Timing
    filename=[filenames{f},'-spiketimes.mat'];
    shift=d.shift(f);
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
    
    clear b
    savename=[fn,'-fitGSPALL.mat'];
    save([filepath, savename],'o');
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
    