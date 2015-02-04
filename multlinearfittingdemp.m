%% Preview
% 
%  Look at the relationship between the peak firing rate and the peak head
%  velocity, displaying the two trial types as differently colored circles.
% 

plotscatter(r,1);
xlabel('Peak Head Velocity (deg/s)')
ylabel('Peak Firing Rate (spk/s)')
%% Find Best Time Shift
% 
%  Find the time shift that maximizes the r-squared value for the model
%  using all 7 terms with no interactions
% 

[rsquare, shift]=findbestshift(r,-200:10:200,'right');
figure
plot(shift,rsquare,'.')
xlabel('shift (ms)')
ylabel('r-squared')
hold on
bestshift=(shift(rsquare==max(rsquare)));
plot(bestshift,max(rsquare),'o','markersize',15)
line([bestshift bestshift],[0 max(rsquare)])

%% Find an initial Model
%
%Display the simple model with no interaction and all terms included
%
mdl=instantcorrelationGS(r,bestshift,'right')
%% Stepwise with R-squared as the criterion for inclusion
%
%Use the stepwise function to add or remove terms based on an r-squared
%criterion. Terms are added if they improve the fit by 0.1 or more and are
%removed if removing them will reduce the r-squared by 0.05 or less.
%
mdl1=step(mdl,'nsteps',20,'criterion','rsquared')
