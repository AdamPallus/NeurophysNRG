%This function allows the user to select .m files of measured data (output
%from EHAnalysis.m). The function then calculates the multiple linear
%regression for each neuron(datafile) selected.
%It will return the neuron's name and the associated model coefficients,
%rsquared values and p values. Neuron is a column cell vector of strings,
%DATA is a mxn matrix of coefficient values (m depends on the model used)
function [Neuron, cnames, DATA]=firingrateregression()

[filenames filepath]=uigetfile('*.mat','Select Files to Measure','multiselect','on');
if iscell(filenames)
    x=filenames;
else
    errordlg('Choose more than one file','Not Enough')
    return
end

%in this function, data is all of the coefficients, r and p values from the
%multiple linear regressions.Model: fr ~ 1 + hv OR fr~1+hp+hv+ha+ep
[d]=cellfun(@multlinearregress,x,'uniformoutput',false);
[Neuron]=cellfun(@(a) a(1:end-4),x,'uniformoutput',false);
Neuron=Neuron';
DATA=zeros(length(d),length(d{1}));
for i =1:length(d)
    DATA(i,:)=d{i};
end
cnames={'Neuron','LOffset','LRsquared','LIntercept','Lhp','Lhv','Lha','Lep',...
                 'ROffset','RRsquared','RIntercept','Rhp','Rhv','Rha','Rep',...
                 'pLhp','pLhv','pLha','pLep',...
                 'pRhp','pRhv','pRha','pRep'};
    

end


function [DATA]=multlinearregress(x)

    vname=x(1:end-4);
    %I've hard coded the filepath here to avoid having to turn it into a
    %cell array so it works with cellfun more easily
    filepath='C:\Users\adam2\Documents\MATLAB\dec12 analysis\sorted spikes\';
    r=load([filepath x]);
    r=r.(vname);
    display(sprintf('Attempting Cell: %s',vname))
    %leftward shift
    [rsquare, shift]=findbestshift(r,-200:10:200,'left');
    bestLeftShift=shift(rsquare==max(rsquare));
    bestRsquareLeft=max(rsquare);
    mdl_Left=instantcorrelation(r,bestLeftShift,'left');
    %rightward shift
    [rsquare,shift]=findbestshift(r,-200:10:200,'right');
    bestRightShift=shift(rsquare==max(rsquare));
    bestRsquareRight=max(rsquare);
    mdl_Right=instantcorrelation(r,bestRightShift,'right');
    
    %extract desired output components
    DATA(1)=bestLeftShift;
    DATA(2)=bestRsquareLeft;
    DATA(3:7)=mdl_Left.Coefficients{1:5,1};
    DATA(8)=bestRightShift;
    DATA(9)=bestRsquareRight;
    DATA(10:14)=mdl_Right.Coefficients{1:5,1};
    %pvalues
    DATA(15:18)=mdl_Left.anova.pValue(1:4)';
    DATA(19:22)=mdl_Right.anova.pValue(1:4)';
end
    