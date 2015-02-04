function [fr, isi]=spiketime2FR(spiketimes,smoothval)
if nargin<2
    smoothval=4;
end
if smoothval>0
    spikes=smooth(spiketimes,smoothval);
else
    spikes=spiketimes;
end
isi=spikes(2:end)-spikes(1:end-1);
fr=zeros(1,length(spikes));
fr(2:end)=1./isi*1000;