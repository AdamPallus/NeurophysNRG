function plotcelldata(r,oldplot)
if nargin<2
    oldplot=0;
end

if ~oldplot
    figure;hold on
end
cellfun(@(a) plot(a),r);