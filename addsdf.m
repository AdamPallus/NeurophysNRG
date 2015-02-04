function d=addsdf(d,stdev)
%d is a table. d.realspiketimes contains the spiketimes
if nargin<2
    stdev=15;
end

for i =1:height(d)
    tl=d.triallength(i);
    sp=round(d.realspiketimes{i}); %round to nearest milisecond
    sp=sp(sp<=tl); %make sure only to consider spikes during trial
    rasters=zeros([1,tl]);
    rasters(sp)=1; %rasters is 0 if no spike and 1 if spike during that ms
    h=fspecial('gaussian',[1,90],stdev);
    sdf{i}=conv(rasters,h,'same');
end
d.sdf=sdf';

    
    
