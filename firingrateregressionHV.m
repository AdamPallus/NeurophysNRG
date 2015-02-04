%This function allows the user to select .m files of measured data (output
%from EHAnalysis.m). The function then calculates the multiple linear
%regression for each neuron(datafile) selected.
%It will return the neuron's name and the associated model coefficients,
%rsquared values and p values. Neuron is a column cell vector of strings,
%DATA is a mxn matrix of coefficient values (m depends on the model used)
function [Neuron, cnames, DATA]=firingrateregressionHV()

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
cnames={'Neuron','LOffset','LRsquared','LIntercept','Lhv',...
                 'ROffset','RRsquared','RIntercept','Rhv',...
                 'pLhv',...
                 'pRhv'};
    

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
    mdl_Left=instantcorrelationHV(r,bestLeftShift,'left');
    %rightward shift
    [rsquare,shift]=findbestshift(r,-200:10:200,'right');
    bestRightShift=shift(rsquare==max(rsquare));
    bestRsquareRight=max(rsquare);
    mdl_Right=instantcorrelationHV(r,bestRightShift,'right');
    
    %extract desired output components
    DATA(1)=bestLeftShift;
    DATA(2)=bestRsquareLeft;
    DATA(3:4)=mdl_Left.Coefficients{1:2,1};
    DATA(5)=bestRightShift;
    DATA(6)=bestRsquareRight;
    DATA(7:8)=mdl_Right.Coefficients{1:2,1};
    %pvalues
    DATA(9)=mdl_Left.anova.pValue(1)';
    DATA(10)=mdl_Right.anova.pValue(1)';
end

function mdl=instantcorrelationHV(celldata,shift,leftorright)
if nargin<2
    shift=0;
end
if nargin<3
    leftorright='both';
end
%this function will correlate head velocity and head acceleration with the
%instantaneous firing rate (1/(interspike interval))
    n=length(celldata.realspiketimes);
    %force this to be in a cell array since cellfun requires all inputs to
    %be cells, but we just want to keep giving the same int each time
    shift=num2cell(repmat(shift,[1 n]));
    
    
    switch(leftorright)
        case {'left'}
            slice=celldata.hpeak<0;
        case{'right'}
            slice=celldata.hpeak>0;
        otherwise
            slice=ones(1,length(celldata.hpeak));
    end
    %just extract the behavior parameters at each spike time from the data
    %stored in cell arrays
    [hv,fr]=cellfun(@docalcHV,celldata.realspiketimes(slice),...
                              celldata.headvelocities(slice),...
                              shift(slice),...
                              'uniformoutput',false);
     %it comes out with each trial's data in a cell. 
     %Put all of that together into one array since we don't care about trials                      
     fr=cell2mat(fr);
     hv=cell2mat(hv);
   
     %fit the simple linear model
%      mdl=fitlm([hp;hv;ha;ep;ev;ea]',fr,'VarNames',{'hp','hv','ha','ep','ev','ea','fr'});
     %just fit using hp hv ha and ep
     mdl=fitlm([hv]',fr,'VarNames',{'hv','fr'});
%      mdl=fitlm([hv]',fr,'VarNames',{'hv','fr'});
     

end

function [hv,fr]=docalcHV(spiketimes,hv,shift)
smoothval=4;
if isempty(spiketimes)
    fr=[];
    hp=[];hv=[];ha=[];
    ep=[];ev=[];ea=[];
    
    return
else
    fr=spiketime2FR(spiketimes,smoothval);    
    spiketimes=round(spiketimes)+shift;
    datalength=length(hv);
    mask=spiketimes(spiketimes<datalength&spiketimes>0);
    hv=hv(mask);
   
    fr=fr(spiketimes<datalength&spiketimes>0);
end
end

function [rsquare,shift]=findbestshift(celldata,iarray,leftorright)
if nargin < 2
    iarray=1:10:200;
end

if nargin<3
    leftoright=0;
end
count=0;
rsquare=zeros(length(iarray),1);
shift=iarray;
for i =iarray
    count=count+1;
    mdl=instantcorrelationHV(celldata,i,leftorright);
    rsquare(count)=mdl.Rsquared.Ordinary;
%     c(:,count)=mdl.Coefficients{1:5,1};
end
end