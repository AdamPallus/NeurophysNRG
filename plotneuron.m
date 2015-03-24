function plotneuron(r,plotlength)
if isempty(r)
    return
end
if nargin<2
plotlength=1000;
end
preplot=200;
xlimits=[1 plotlength];
r=recalculatevels(r);
r.goSignal=r.gosig;
figure
subplot(3,1,1)
hold on
title([r.Neuron{1},':',r.ttype{1}])
plotsub(r.headpositions,r.goSignal-preplot,'k',plotlength)
plotsub(r.eyepositions,r.goSignal-preplot,'b',plotlength)
xlim(xlimits)
ylabel('Position (deg)')

subplot(3,1,2)
hold on
plotsub(r.headvelocities,r.goSignal-preplot,'k',plotlength)
plotsub(r.eyevelocities,r.goSignal-preplot,'b',plotlength)
xlim(xlimits)
ylabel('Velocity (deg/s)')

subplot(3,1,3)
hold on
plotsub(r.sdf,r.goSignal-preplot,'k',plotlength)
plotsub(r.prediction,r.goSignal-preplot,'m',plotlength)
xlim(xlimits)
ylim([0 300])
ylabel('Spike density (spk/s)')
xlabel('Time (ms)')
title(r.formula{1})

tightfig;


function plotsub(x,goSignal,colorchoice,plotlength)

m=NaN(length(x),plotlength);
goSignal(goSignal<1)=1;
goSignal(isnan(goSignal))=1;
for i =1:length(x)
    p=x{i}(goSignal(i):end);
    endplot=min(length(p),plotlength);
    m(i,1:endplot)=p(1:endplot);

%     plot(p,colorchoice)
end
plotribbon(m,colorchoice,0.2)
plot(nanmean(m,1),colorchoice,'linewidth',2)



function plotribbon(m,fstr,a)
if nargin<2
    fstr='k';
end
if nargin<3
    a=1;
end
x=1:length(m);
y=[nanmean(m)-nanstd(m);nanmean(m)+nanstd(m)];

px=[x,fliplr(x)]; % make closed patch
py=[y(1,:), fliplr(y(2,:))];
try
patch(px,py,1,'FaceColor',fstr,'EdgeColor','none','facealpha',a);
end

