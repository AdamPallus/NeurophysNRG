function r=addPrediction(r)

rr=addsdf(r);
rr=recalculatevels(rr);

try
    d=readtable('C:\Users\adam2\Documents\MATLAB\NeurophysNRG\regressionUD.csv');
    thisNeuron=rr.trialnum{1}(1:9);
    shift=d.shift(strcmp(d.Neuron,thisNeuron));
    formula=d.f(strcmp(d.Neuron,thisNeuron));
    [~, m]=bestFitVert(rr,shift,formula);
catch
    error('Can''t get model');
    lasterr
end

for i =1:height(r)
    
    d=table(rr.headpositions{i}',rr.headvelocities{i}',rr.headaccelerations{i}',...
        rr.eyepositions{i}',rr.eyevelocities{i}',rr.eyeaccelerations{i}',...
        rr.headpositionsV{i}',rr.headvelocitiesV{i}',rr.headaccelerationsV{i}',...
        rr.eyepositionsV{i}',rr.eyevelocitiesV{i}',rr.eyeaccelerationsV{i}',...
        'variablenames',...
        {'hp','hv','ha','ep','ev','ea',...
        'vhp','vhv','vha','vep','vev','vea'});
    d=splitLR(d);
    p=predict(m,d);
    p(p<0)=0;
    prediction{i}=p(shift:end)';
    rr.sdf{i}=rr.sdf{i}*1400;
    formulas{i}=formula;
end
r.sdf=rr.sdf;
r.prediction=prediction';
r.formula=formulas';
end

function o=splitLR(d)
o=table();
% o.fr=d.fr;
o.rhp=d.hp; o.rhp(o.rhp<0)=0;
o.lhp=d.hp*-1; o.lhp(o.lhp<0)=0;
o.rep=d.ep; o.rep(o.rep<0)=0;
o.lep=d.ep*-1; o.lep(o.lep<0)=0;
o.rhv=d.hv; o.rhv(o.rhv<0)=0;
o.lhv=d.hv*-1; o.lhv(o.lhv<0)=0;
o.rev=d.ev; o.rev(o.rev<0)=0;
o.lev=d.ev*-1; o.lev(o.lev<0)=0;
o.rha=d.ha; o.rha(o.rha<0)=0;
o.lha=d.ha*-1; o.lha(o.lha<0)=0;
o.rea=d.ea; o.rea(o.rea<0)=0;
o.lea=d.ea*-1; o.lea(o.lea<0)=0;

o.uhp=d.vhp; o.uhp(o.uhp<0)=0;
o.dhp=d.vhp*-1; o.dhp(o.dhp<0)=0;
o.uep=d.vep; o.uep(o.uep<0)=0;
o.dep=d.vep*-1; o.dep(o.dep<0)=0;
o.uhv=d.vhv; o.uhv(o.uhv<0)=0;
o.dhv=d.vhv*-1; o.dhv(o.dhv<0)=0;
o.uev=d.vev; o.uev(o.uev<0)=0;
o.dev=d.vev*-1; o.dev(o.dev<0)=0;
o.uha=d.vha; o.uha(o.uha<0)=0;
o.dha=d.vha*-1; o.dha(o.dha<0)=0;
o.uea=d.vea; o.uea(o.uea<0)=0;
o.dea=d.vea*-1; o.dea(o.dea<0)=0;
end