function d=makePeakDataset(celldata,leftorright)

if nargin<2
    leftorright='both';
end

    n=length(celldata.realspiketimes);
    switch(leftorright)
        case {'left'}
            slice=celldata.hpeak<0;
        case{'right'}
            slice=celldata.hpeak>0;
        otherwise
            slice=celldata.hpeak<100000;
    end
    %just extract the behavior parameters at each spike time from the data
    %stored in cell arrays
    isgs=strcmp(celldata.ttype,'Adam_Delay01');
    isgs=num2cell(isgs);
    
    headpositions=celldata.headpositions(slice);
    eyepositions=celldata.eyepositions(slice);
    numtrials=length(headpositions);
    sm=7; %size of parabolic smoothing
    
    headvelocities=cellfun(@(a) parabolicdiff(a,sm),headpositions,'uniformoutput',false);
    headaccelerations=cellfun(@(a) parabolicdiff(a,sm),headvelocities,'uniformoutput',false);
    
    eyevelocities=cellfun(@(a) parabolicdiff(a,sm),eyepositions,'uniformoutput',false);
    eyeaccelerations=cellfun(@(a) parabolicdiff(a,sm),eyevelocities,'uniformoutput',false);
    
    colnames={'HeadP','HeadV','HeadA','EyeP','EyeV','EyeA','peakFR','isGStask',...
              'HPTime','HVTime','HATime','EPTime','EVTime','EATime','FRTime'};
          

    [hp hv ha ep ev ea fr isgs,hpTime,hvTime,haTime,...
        epTime,evTime,eaTime,frTime]=...
        cellfun(@docalc,celldata.realspiketimes(slice),...
                              headpositions,...
                              headvelocities,...
                              headaccelerations,...
                              eyepositions,...
                              eyevelocities,...
                              eyeaccelerations,...
                              isgs(slice),'uniformoutput',0);
                          
     %it comes out with each trial's data in a cell. 
     %Put all of that together into one array since we don't care about trials                      
     fr=cell2mat(fr);
     hp=cell2mat(hp);hv=cell2mat(hv);ha=cell2mat(ha);
     ep=cell2mat(ep);ev=cell2mat(ev);ea=cell2mat(ea);
     hpTime=cell2mat(hpTime);hvTime=cell2mat(hvTime);haTime=cell2mat(haTime);
     epTime=cell2mat(epTime);evTime=cell2mat(evTime);eaTime=cell2mat(eaTime);
     frTime=cell2mat(frTime);
     isgs=isgs(cellfun(@islogical,isgs));
     isgs=cell2mat(isgs);
     
     d=dataset(hp',hv',ha',ep',ev',ea',fr',isgs',hpTime',hvTime',haTime',epTime',evTime',eaTime',frTime','varnames',colnames);

end

function [hp hv ha ep ev ea fr isgs,hpTime,hvTime,haTime,epTime,evTime,eaTime,frTime]=docalc(spiketimes,hp,hv,ha,ep,ev,ea,isgs)
smoothval=4;
if isempty(spiketimes) || length(spiketimes)<2
    fr=0;
    frTime=0;
else
    fr=spiketime2FR(spiketimes,smoothval);    
    [fr, frTime]=max(fr);
    frTime=spiketimes(frTime);
end
    [hp hpTime]=maxabs(hp);
    [hv hvTime]=maxabs(hv);
    [ha haTime]=maxabs(ha);
    [ep epTime]=maxabs(ep);
    [ev evTime]=maxabs(ev);
    [ea eaTime]=maxabs(ea);
end
