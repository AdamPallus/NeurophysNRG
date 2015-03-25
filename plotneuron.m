function plotneuron(r,plotlength)
if isempty(r)
    return
end
if nargin<2
plotlength=800;
end
preplot=100;
sameaxes=0;

xlimits=[1 plotlength];
r=recalculatevels(r);
r.goSignal=r.gosig;
figure
if sameaxes
subplot(2,1,1)
else
    subplot(3,1,1)
end
hold on
title([r.Neuron{1},':',r.ttype{1}])
mh=plotsub(r.headpositions,r.goSignal-preplot,plotlength);
me=plotsub(r.eyepositions,r.goSignal-preplot,plotlength);

mhv=plotsub(r.headvelocities,r.goSignal-preplot,plotlength);
mev=plotsub(r.eyevelocities,r.goSignal-preplot,plotlength);

plotribbon(mh,'k',0.2);
plotribbon(me,'k',0.2);
plot(nanmean(mh),'k','linewidth',2)
plot(nanmean(me),'color',[0.5,0.5,0.5],'linewidth',2)
%velocity
if ~sameaxes
    xlim(xlimits)
    ylabel('Position (deg)')
    
    subplot(3,1,2)
    hold on
else
    mhv=mhv/10;
    mev=mev/10;    
end

plotribbon(mhv,'k',0.2);
plotribbon(mev,'k',0.2);
plot(nanmean(mhv),'k','linewidth',2)
plot(nanmean(mev,1),'color',[0.5,0.5,0.5],'linewidth',2)
xlim(xlimits)
ylabel('Velocity (deg/s)')

if sameaxes
    subplot(2,1,2)
else
    subplot(3,1,3)
end
hold on
sdf=plotsub(r.sdf,r.goSignal-preplot,plotlength);
predict=plotsub(r.prediction,r.goSignal-preplot,plotlength);
plotribbon(sdf,'k',0.2)
plotribbon(predict,'k',0.2)
plot(nanmean(sdf),'k','linewidth',2)
plot(nanmean(predict),'color',[0.5,0.5,0.5],'linewidth',2)

xlim(xlimits)
ylim([0 300])
ylabel('Spike density (spk/s)')
xlabel('Time (ms)')
title(r.formula{1})

tightfig;
% figure;hold on
% plotribbon(mhv/10,'k',0.2)
% plot(nanmean(mhv/10),'k--')
% ax=plotyy(1:length(mh),nanmean(mh),1:length(mh),nanmean(mhv*10))
% axis(ax(1))
% plotribbon(mh,'k',0.2)
% axis(ax(2));
% plotribbon(mhv,'k',0.2)

function m=plotsub(x,goSignal,plotlength)
if nargin<5
    divideby10=0;
end

m=NaN(length(x),plotlength);
goSignal(goSignal<1)=1;
goSignal(isnan(goSignal))=1;
for i =1:length(x)
    p=x{i}(goSignal(i):end);
    endplot=min(length(p),plotlength);
    m(i,1:endplot)=p(1:endplot);

%     plot(p,colorchoice)
end
% if divideby10
%     m=m/10;
%     colorchoice2=[colorchoice,'--'];
% else
%     colorchoice2=colorchoice;
% end
%plotribbon(m,colorchoice,0.2)
%plot(nanmean(m,1),colorchoice2,'linewidth',2)



function plotribbon(m,fstr,a)
if nargin<2
    fstr='k';
end
if nargin<3
    a=0.2;
end

x=1:length(m);
y=[nanmean(m)-nanstd(m);nanmean(m)+nanstd(m)];

px=[x,fliplr(x)]; % make closed patch
py=[y(1,:), fliplr(y(2,:))];
try
    patch(px,py,1,'FaceColor',fstr,'EdgeColor','none','facealpha',a);
end

