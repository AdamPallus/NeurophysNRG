function convertalltoCSV()
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

for i =1:length(filenames)
    tt=tic; %Start Timing
    a=load([filepath filenames{i}]);
    f=fields(a);
    a=a.(f{1});
    if ~isa(a,'table')
        a=mystruct2table(a,1);
    end
    t=converttocsv(a);
    writetable(t,['converted-',num2str(i),'.csv'])
    x(i)=toc(tt);
    display(sprintf('Saved %s... It took %0.1f minutes.',f{1},x(i)/60))
    estimate=mean(x)*(length(filenames)-i);
    display(sprintf('Estimating %0.1f minutes remaining',estimate/60))
end


function t= converttocsv(a)
t=table();
for i =1:height(a)
    temp=table();
    temp.gaze=a.gazepositions{i}';
    temp.head=a.headpositions{i}';
    temp.eye=a.eyepositions{i}';
    n=height(temp);
    temp.time=(1:n)';
    temp.rasters=zeros(n,1);
    temp.rasters(ceil(a.realspiketimes{i}))=1;
    temp.subject=repmat(a.subject{i},n,1);
    temp.ttype=repmat(a.ttype(i),n,1);
    temp.trialnum=repmat(a.trialnum(i),n,1);
    t=vertcat(t,temp);
end