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
%% Find a model 
m=stepwiselm(d(:,1:7),'peakFR~HeadV','criterion','rsquared')


%% Display Head Velocity and Eye Velocity
figure
scatter(d.HeadV,d.EyeV,30,d.peakFR,'filled')
xlabel('Peak Head Velocity')
ylabel('Peak Eye Velocity')

%% Display Head Velocity and Eye Position
figure
scatter(d.HeadV,d.EyeP,30,d.peakFR,'filled')
xlabel('Peak Head Velocity')
ylabel('Peak Eye Position')

%% Display Eye Position
figure
scatter(d.EyeP,d.peakFR,'filled')
xlabel('Peak Eye Position')
ylabel('Peak Firing Rate')


