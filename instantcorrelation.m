function mdl=instantcorrelation(celldata,shift,leftorright)
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
    [hp,hv,ha,ep,ev,ea,fr]=cellfun(@docalc,celldata.realspiketimes(slice),...
                              celldata.headpositions(slice),...
                              celldata.headvelocities(slice),...
                              celldata.headaccelerations(slice),...
                              celldata.eyepositions(slice),...
                              celldata.eyevelocities(slice),...
                              celldata.eyeaccelerations(slice),...
                              shift(slice),...
                              'uniformoutput',false);
     %it comes out with each trial's data in a cell. 
     %Put all of that together into one array since we don't care about trials                      
     fr=cell2mat(fr);
     hp=cell2mat(hp);hv=cell2mat(hv);ha=cell2mat(ha);
     ep=cell2mat(ep);ev=cell2mat(ev);ea=cell2mat(ea);
     
     %fit the simple linear model
%      mdl=fitlm([hp;hv;ha;ep;ev;ea]',fr,'VarNames',{'hp','hv','ha','ep','ev','ea','fr'});
     %just fit using hp hv ha and ep
     mdl=fitlm([hp;hv;ha;ep]',fr,'VarNames',{'hp','hv','ha','ep','fr'});
%      mdl=fitlm([hv]',fr,'VarNames',{'hv','fr'});
     

end

function [hp,hv,ha,ep,ev,ea,fr]=docalc(spiketimes,hp,hv,ha,ep,ev,ea,shift)
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
    hp=hp(mask);hv=hv(mask);ha=ha(mask);
    ep=ep(mask);ev=ev(mask);ea=ea(mask);
    fr=fr(spiketimes<datalength&spiketimes>0);
end
end
