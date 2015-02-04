function joinedfits = joinfits()
[filenames, filepath]=uigetfile({'Spikes Sorted\*.mat'},'Select files to join',...
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
joinedfits=table();
progressbar=waitbar(0,'Joining Files...');

for f =1:length(filenames)
    waitbar(f/length(filenames),progressbar)
    o=load([filepath filenames{f}]);
    o=o.o;
    l=o(o.rL==max(o.rL),:);%best L
    r=o(o.rR==max(o.rR),:);%best R
    l(1,[1,2,4,6]);%get rid of r columns and extra rows
    r(1,[1,3,5,7]);%get rid of l columns
    z=table();
    
    z.Neuron=filenames{f}(1:9);
    
    try
    zz=horzcat(l(1,[2,4,6]),r(1,[3,5,7]));%join left and right into one row
    catch
        display(['Failed on ',filenames{f}])
        continue
    end
    z=horzcat(z,zz);
    
    z.rShift=r.shift(1);%add shift but give it a unique name
    z.lShift=l.shift(1);
    joinedfits=vertcat(joinedfits,z);
end
close(progressbar)
    
    