function joinedfits = joinfitsLRGSP()
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
    filenames=filenames{1};
end
%if the user did not select anything (hit cancel), just exit the function
%with no further messaging.
if filenames{1}==0
    return
end
joinedfits=table();
progressbar=waitbar(0,'Joining Files...');

for f =1:length(filenames)
    waitbar(f/length(filenames),progressbar)
    tic
    o=load([filepath filenames{f}]);
    o=o.o;
    
    z=table();
    z=findbestfit(o);
    z.Neuron=repmat(filenames{f}(1:9),[height(z),1]);
    joinedfits=vertcat(joinedfits,z);
    x(f)=toc;
    estimate=mean(x)*(length(filenames)-f);
    waitbar(f/length(filenames),progressbar,sprintf('Time Remaining: %0.0f min %0.0f seconds',floor(estimate/60),floor(mod(estimate,60))))
end
close(progressbar)
% joinedfits=horzcat(joinedfits(:,5),joinedfits(:,1:4));
% display('adding coeficients as columns')
% joinedfits=getcoefs(joinedfits);

function outp=findbestfit(o)
for i =1:length(o.gsp)
    dgs(i)=strcmp(o.gsp(i,:),'gs');
end
mgs=max(o.rsquared(dgs));
mps=max(o.rsquared(~dgs));

o=o([find(o.rsquared==mgs,1),find(o.rsquared==mps,1)],:);
outp=o;
    
    