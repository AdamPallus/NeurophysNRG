function plotmeancelldata(r,timescale,oldplot)
if nargin<3
    oldplot=0;
end
if nargin<2
    timescale=1000;
end

if ~oldplot
    figure;hold on
end
count=0;
for i = 1:length(r)
    try
    m(i,:)=r{i}(1:timescale);
    catch
        count=count+1;
    end
end
plot(mean(m))
title(sprintf('Omitted %d of %d trials',[count,length(r)]))