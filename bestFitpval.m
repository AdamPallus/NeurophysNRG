%I give it the cell structure. It returns the best model for left and right

function [mLeft, mRight,bestLeft,bestRight]= bestFit(r,fitFull)
if nargin<2
    %useTType indicates that the model should be fit using trial type (gaze
    %shift or pursuit task) as an option. Trial type is a factor (0 for
    %pursuit or 1 for gaze shift)
    fitFull=1;
end
useTtype=0;

count=0;
%find the best shift for the largest possible model
progressbar=waitbar(0,'Finding Best Shift');
for i =-200:10:200
    count=count+1;
    waitbar(count/length(-200:10:200),progressbar)
    dLeft=makeSpikeDataset(r,i,'left');
    dRight=makeSpikeDataset(r,i,'right');
    
%     mdl=fitlm(dLeft,'fr~hp+hv+ha+ep+ev+ea+tType');
    mdl=fitlm(dLeft,'fr~hv');

    shiftLeft(count)=i;
    rsquareLeft(count)=mdl.Rsquared.Ordinary;
    
%     mdl=fitlm(dRight,'fr~hp+hv+ha+ep+ev+ea+tType');
    mdl=fitlm(dRight,'fr~hv');
    shiftRight(count)=i;
    rsquareRight(count)=mdl.Rsquared.Ordinary;
end
close(progressbar)
bestLeft=shiftLeft(rsquareLeft==max(rsquareLeft));
bestRight=shiftRight(rsquareRight==max(rsquareRight));
%return the stepwise model for the left and right
dLeft=makeSpikeDataset(r,bestLeft,'left');
dRight=makeSpikeDataset(r,bestRight,'right');
% mLeft=stepwiselm(dLeft,'fr~hv','criterion','rsquared','verbose',0);
% mRight=stepwiselm(dRight,'fr~hv','criterion','rsquared','verbose',0);

%Omit trial type as an option for the fit
if ~useTtype
    %omit the 8th column: trial type from the datasets
    dLeft=dLeft(:,1:7);
    dRight=dRight(:,1:7);
end
if ~fitFull
mLeft=stepwiselm(dLeft,'fr~hv','criterion','rsquared','verbose',0);
mRight=stepwiselm(dRight,'fr~hv','criterion','rsquared','verbose',0);
else
    mLeft=stepwiselm(dLeft,'fr~hv','verbose',0);
    mRight=stepwiselm(dRight,'fr~hv','verbose',0);
end
    