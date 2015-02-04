function d=makeSpikeDataset(celldata,shift,leftorright)
if nargin<2
    shift=0;
end
if nargin<3
    leftorright='both';
end
celldata=recalculatevels(celldata);

    n=height(celldata);
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
    isgs=strcmp(celldata.ttype,'Adam_Delay01');
    isgs=num2cell(isgs);
    
    headpositions=celldata.headpositions(slice);
    eyepositions=celldata.eyepositions(slice);

    
    [hp,hv,ha,ep,ev,ea,isgs,fr]=cellfun(@docalc,celldata.realspiketimes(slice),...
                              headpositions,...
                              headvelocities,...
                              headaccelerations,...
                              eyepositions,...
                              eyevelocities,...
                              eyeaccelerations,...
                              isgs(slice),...                              
                              shift(slice),...
                              'uniformoutput',false);
     %it comes out with each trial's data in a cell. 
     %Put all of that together into one array since we don't care about trials                      
     fr=cell2mat(fr);
     hp=cell2mat(hp);hv=cell2mat(hv);ha=cell2mat(ha);
     ep=cell2mat(ep);ev=cell2mat(ev);ea=cell2mat(ea);
     isgs=isgs(cellfun(@islogical,isgs));
     isgs=cell2mat(isgs);
     
     d=dataset(fr',hp',hv',ha',ep',ev',ea',isgs','varnames',{'fr','hp','hv','ha','ep','ev','ea','tType'});

end

function [hp,hv,ha,ep,ev,ea,isgs,fr]=docalc(spiketimes,hp,hv,ha,ep,ev,ea,isgs,shift)
smoothval=0;
if isempty(spiketimes) || length(spiketimes)<2
    fr=[];
    hp=[];hv=[];ha=[];
    ep=[];ev=[];ea=[];
    isgs=[];
    
    return
else
    fr=spiketime2FR(spiketimes,smoothval);    
    spiketimes=round(spiketimes)+shift;
    datalength=length(hv);
    mask=spiketimes(spiketimes<datalength&spiketimes>0);
    hp=hp(mask);hv=hv(mask);ha=ha(mask);
    ep=ep(mask);ev=ev(mask);ea=ea(mask);
    fr=fr(spiketimes<datalength&spiketimes>0);
    isgs=repmat(isgs,size(fr));
end
end
