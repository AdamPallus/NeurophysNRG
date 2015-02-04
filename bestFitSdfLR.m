%I give it the cell structure. It returns the best model for left and right

function o= bestFitSdfLR(r)
% function [mLeft, mRight,bestLeft,bestRight]= bestFitSdf(r)

possibleShifts=0:10:200;

%find the best shift for the largest possible model
progressbar=waitbar(0,'Finding Best Shift');
r=addsdf(r,15);
r=recalculatevels(r);
for i =1:length(possibleShifts)
    tic
    waitbar(i/length(0:10:200),progressbar)
    d=sdftableLR(r,possibleShifts(i));
    m=stepwiselm(d,'fr~1','criterion','rsquared','verbose',0,...
    'penter',0.05,'premove',0.025);
    shift(i)=possibleShifts(i);
    rsquared(i)=m.Rsquared.Adjusted;
    coef{i}=m.Coefficients;
    f{i}=m.Formula.char;
    x(i)=toc;
    estimate=mean(x)*(length(possibleShifts)-i);
    waitbar(i/length(0:10:200),progressbar,sprintf('Time Remaining: %0.0f min %0.0f seconds',floor(estimate/60),floor(mod(estimate,60))))   
end

close(progressbar)

% o=table(shift,ml,mr,'variablenames',{'shift','ml','mr'});
o=table(shift',rsquared',f',coef','variablenames',{'shift','rsquared','f','coef'});

