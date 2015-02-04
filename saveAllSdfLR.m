%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then uses bestFitSdf on each file, and saves the output in a
%.mat file.

function saveAllSdfLR
try
[filenames, filepath]=uigetfile({'Spikes Sorted\*.mat'},'Select Files to Analyze',...
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
    tt=tic; %Start Timing
    filename=filenames{f};
    b=load([filepath, filename]);
    %These files should contain one variable. Get its name.
    fn=fields(b);
    fn=fn{1};
    %Create the table of fits (This takes a long time)
    display(sprintf('Calculating %s...',fn))
    o=bestFitSdfLR(b.(fn));
    clear b
    savename=[fn,'-fitLR.mat'];
    save([filepath, savename],'o');
    clear o
    x(f)=toc(tt);
    display(sprintf('Saved %s... It took %0.1f minutes.',fn,x(f)/60))
    estimate=mean(x)*(length(filenames)-f);
    display(sprintf('Estimating %0.1f minutes remaining',estimate/60))
end
    