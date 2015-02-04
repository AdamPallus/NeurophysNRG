%Writing this function to load the stepwise fit, find the best shift, then
%load the data, do sdftableLR for the specified shift, then fitlm for all
%the coefficients and then save the coeficients in the table

function o=findlmcoefs
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

bestFits=readtable('bestFitLR.csv');
o=table();
for f =1:length(filenames)
    tt=tic; %Start Timing
    filename=filenames{f};
    b=load([filepath, filename]);
    %These files should contain one variable. Get its name.
    fn=fields(b);
    fn=fn{1};
    r=b.(fn);
    %find best shift:
    shift=bestFits.shift(strcmp(bestFits.Neuron,{fn}));
    display(sprintf('Calculating %s...',fn))
    d=sdftableLR(r,shift);
    m=fitlm(d,'fr~rhp+lhp+rep+lep+rhv+lhv+rev+lev+rha+lha+rea+lea');
    t=table({fn},m.Coefficients.Estimate','variablenames',{'Neuron','LMCoefs'});
    names=m.Coefficients.Properties.RowNames;
    t.int=m.Coefficients.Estimate(1);
    for i =2:length(names)
        t.(names{i})=m.Coefficients.Estimate(i);
        t.([names{i},'Inc'])=
    end
    x(f)=toc(tt);
    display(sprintf('Finished %s... It took %0.1f minutes.',fn,x(f)/60))
    estimate=mean(x)*(length(filenames)-f);
    display(sprintf('Estimating %0.1f minutes remaining',estimate/60))
    o=vertcat(o,t);
end
o=innerjoin(bestFits(:,1:4),o,'key','Neuron');
