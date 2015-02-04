function d=makeSpikeTable(c,shift,leftorright)
if nargin<2
    shift=0;
end
if nargin<3
    leftorright='both';
end

       
    switch(leftorright)
        case {'left'}
%             slice=celldata.hpeak<0;
            c=c(c.hpeak<0,:);
        case{'right'}
            c=c(c.hpeak>0,:);
%             slice=celldata.hpeak>0;
        otherwise
%             slice=ones(1,length(celldata.hpeak));
    end
    
    %just extract the behavior parameters at each spike time from the data
    %stored in cell arrays
    n=height(c);
    shift=num2cell(repmat(shift,[n 1])); 
    c.isgs=strcmp(c.ttype,'Adam_Delay01');
    isgs=num2cell(c.isgs);
    c=recalculatevels(c);
    [hp,hv,ha,ep,ev,ea,isgs,fr]=cellfun(@docalc,c.realspiketimes,...
                              c.headpositions,...
                              c.headvelocities,...
                              c.headaccelerations,...
                              c.eyepositions,...
                              c.eyevelocities,...
                              c.eyeaccelerations,...
                              isgs,...                              
                              shift,...
                              'uniformoutput',false);
     %it comes out with each trial's data in a cell. 
     %Put all of that together into one array since we don't care about trials                      
     fr=cell2mat(fr');
     hp=cell2mat(hp');hv=cell2mat(hv');ha=cell2mat(ha');
     ep=cell2mat(ep');ev=cell2mat(ev');ea=cell2mat(ea');
     isgs=isgs(cellfun(@islogical,isgs));
     isgs=cell2mat(isgs');
     
     d=table(fr',hp',hv',ha',ep',ev',ea',isgs','variablenames',{'fr','hp','hv','ha','ep','ev','ea','tType'});

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
    fr=fr(2:end);
    spiketimes=spiketimes(2:end);
    spiketimes=round(spiketimes)+shift;
    datalength=length(hv);
    mask=spiketimes(spiketimes<datalength&spiketimes>0);
    hp=hp(mask);hv=hv(mask);ha=ha(mask);
    ep=ep(mask);ev=ev(mask);ea=ea(mask);
    fr=fr(spiketimes<datalength&spiketimes>0);
    isgs=repmat(isgs,size(fr));
end
end
