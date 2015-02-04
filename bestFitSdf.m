%I give it the cell structure. It returns the best model for left and right




function o= bestFitSdf(r)
% function [mLeft, mRight,bestLeft,bestRight]= bestFitSdf(r)


count=0;
%find the best shift for the largest possible model
progressbar=waitbar(0,'Finding Best Shift');
for i =0:10:200
    count=count+1;
    waitbar(count/length(0:10:200),progressbar)
    d=sdftable(r,i);
    d=splitLR(d);
    ml{count}=stepwiselm(d(d.dir<0,:),'fr~1','criterion','rsquared','verbose',0,...
    'penter',0.05,'premove',0.025);
%     mdl=fitlm(d(d.dir<0,:),'fr~1+hv');

    shift(count)=i;
    rL(count)=ml{count}.Rsquared.Ordinary;
    fL{count}=ml{count}.Formula.char;
    mr{count}=stepwiselm(d(d.dir>0,:),'fr~1','criterion','rsquared','verbose',0,...
    'penter',0.05,'premove',0.025);
    rR(count)=mr{count}.Rsquared.Ordinary;
    fR{count}=mr{count}.Formula.char;
end

close(progressbar)

% o=table(shift,ml,mr,'variablenames',{'shift','ml','mr'});
o=table(shift',rL',rR',fL',fR',ml',mr','variablenames',{'shift','rL','rR','fL','fR','ml','mr'});


%subfunction for testing the idea of separating leftward and rightward into
%separate variables.
function o=splitLR(d)
o.rhp=d.hp; o.rhp(o.rhp<0)=0;
o.lhp=d.hp; o.lhp(o.lhp>0)=0;
o.rep=d.ep; o.rep(o.rep<0)=0;
o.lep=d.ep; o.lep(o.lep>0)=0;
o.rhv=d.hv; o.rhv(o.rhv<0)=0;
o.lhv=d.hv; o.lhv(o.lhv>0)=0;
o.rev=d.ev; o.rev(o.rev<0)=0;
o.lev=d.ev; o.lev(o.lev>0)=0;
o.rha=d.ha; o.rha(o.rha<0)=0;
o.lha=d.ha; o.lha(o.lha>0)=0;
o.rea=d.ea; o.rea(o.rea<0)=0;
o.lea=d.ea; o.lea(o.lea>0)=0;
o.dir=d.dir;
o.fr=d.fr;