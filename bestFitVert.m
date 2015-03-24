%I give it the cell structure. It returns the best model for left and right

function [o, m]= bestFitVert(r,possibleShifts,formula)
% function [mLeft, mRight,bestLeft,bestRight]= bestFitSdf(r)
if nargin<2
    possibleShifts=0:10:200;
end
if nargin<3
    formula=[];
end

%find the best shift for the largest possible model
% progressbar=waitbar(0,'Finding Best Shift');
if ~isvariable(r,'sdf')
    r=addsdf(r,15);
end
if ~isvariable(r,'headvelocities')
    r=recalculatevels(r);
end
for i =1:length(possibleShifts)
    tic
%     waitbar(i/length(possibleShifts),progressbar)
    d=sdftableVert(r,possibleShifts(i));
    neuron(i)=d.neuron(i);
    %omit trial,t,dgs
    d=d(:,5:end);
    if ischar(formula)
        m=fitlm(d,formula);
    else
        m=stepwiselm(d,'fr~1','criterion','rsquared','verbose',0,...
            'penter',0.05,'premove',0.025);
    end
    
    shift(i)=possibleShifts(i);
    rsquared(i)=m.Rsquared.Adjusted;
    coef{i}=m.Coefficients;
    f{i}=m.Formula.char;
    x(i)=toc;
    estimate=mean(x)*(length(possibleShifts)-i);
%     waitbar(i/length(possibleShifts),progressbar,sprintf('Time Remaining: %0.0f min %0.0f seconds',floor(estimate/60),floor(mod(estimate,60))))   
end

% close(progressbar)

% o=table(shift,ml,mr,'variablenames',{'shift','ml','mr'});
o=table(neuron',shift',rsquared',f',coef','variablenames',{'Neuron','shift','rsquared','f','coef'});

