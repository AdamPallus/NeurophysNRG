function [Neuron,mLeft, mRight,shiftL,shiftR]=dynamicfit(useTType)

[filenames, filepath]=uigetfile('*.mat','Select Files to Measure','multiselect','on');
if iscell(filenames)
    x=filenames;
else
    errordlg('Choose more than one file','Not Enough')
    return
end
[Neuron]=cellfun(@(a) a(1:end-4),x,'uniformoutput',false);
Neuron=Neuron';
progressbar=waitbar(0,'Calculating...');
for i =1:length(x)
    try
        waitbar(i/length(x),progressbar)
        vname=x{i}(1:end-4);
        %I've hard coded the filepath here to avoid having to turn it into a
        %cell array so it works with cellfun more easily
    %     filepath='C:\Users\adam2\Documents\MATLAB\dec12 analysis\sorted spikes\';
        r=load([filepath x{i}]);
        r=r.(vname);
        display(sprintf('Attempting Cell: %s',vname))
        [mLeft{i},mRight{i},shiftL(i),shiftR(i)]=bestFit(r,useTType);
    catch
        display(sprintf('Failed Cell: %s',vname))
        continue
    end
end
close(progressbar)