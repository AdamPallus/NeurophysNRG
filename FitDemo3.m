%% Extract Peak Values
cellname='UC22may12';
if ~exist(cellname)
    load(cellname)
end
eval(['r=',cellname,';']);
d=makePeakDataset(r,'both');

%% Display Head Velocity
figure
scatter(d.HeadV,d.peakFR,'filled')
xlabel('Peak Head Velocity')
ylabel('Peak Firing Rate')

%% Time of Peak Firing Rate
figure
ind=find(d.FRTime<600 & d.FRTime>0);
scatter(d.HeadV(ind),d.FRTime(ind),'filled')
xlabel('Peak Head Velocity')
ylabel('Time of Peak Firing Rate')
%% Anova
%Test null hypothesis that peak firing rate happens at the same time for
%both directions
anova1(d.FRTime(ind),d.HeadV(ind)>0);

%% Fit a Model for Leftward
d=makePeakDataset(r,'left');
m=stepwiselm(d(:,1:7),'peakFR~HeadV','criterion','rsquared')

%% Display Head Velocity and Eye Position
figure
scatter(d.HeadV,d.EyeP,30,d.peakFR,'filled')
xlabel('Peak Head Velocity')
ylabel('Peak Eye Position')
h=colorbar;
h.Label.String='Peak Firing Rate';
%% Display Eye Position
%Leftward eye position seems to set a lower limit on firing rate
figure
scatter(d.EyeP,d.peakFR,'filled')
xlabel('Peak Eye Position')
ylabel('Peak Firing Rate')


%% Fit Model for Rightward
d=makePeakDataset(r,'right');
m=stepwiselm(d(:,1:7),'peakFR~HeadV','criterion','rsquared')

%% Display Eye Position
%The effect of eye position disappers when we look only at rightward
%movements. 
figure
scatter(d.EyeP,d.peakFR,'filled')
xlabel('Peak Eye Position')
ylabel('Peak Firing Rate')

%% Eye position effect for both directions
d=makePeakDataset(r,'both');
figure
scatter(d.EyeP,d.peakFR,'filled')
xlabel('Peak Eye Position')
ylabel('Peak Firing Rate')



