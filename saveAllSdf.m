%This function loads the selected .mat files containing the table format of
%the sorted spikes data. Each .mat file corresponds to an H5 file of the
%same name code. 

%The function then uses bestFitSdf on each file, and saves the output in a
%.mat file.

function saveAllSdf
[filenames, filepath]=uigetfile({'Spikes Sorted\*.mat'},'Select Files to Analyze',...
    'multiselect','on');

%if there is only one file selected, it will be a character array. Convert
%this to a cell array so we don't have to keep checking.
if ~iscell(filenames)
    filenames=filenames{1};
end
%if the user did not select anything (hit cancel), just exit the function
%with no further messaging.
if filenames{1}==0
    return
end

for f =1:length(filenames)
    tic %Start Timing
    filename=filenames{f};
    b=load([filepath, filename]);
    %These files should contain one variable. Get its name.
    fn=fields(b);
    fn=fn{1};
    %Create the table of fits (This takes a long time)
    display(sprintf('Calculating %s...',fn))
    o=bestFitSdf(b.(fn));
    
    savename=[fn,'-fit.mat'];
    save([filepath, savename],'o');
    x=toc;
    display(sprintf('Saved %s... It took %0.1f minutes.',fn,x/60))
end
    