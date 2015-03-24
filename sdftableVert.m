
function d=sdftableVert(r,shift,FIX_DUR)

if ~isvariable(r,'headvelocities')
    r=recalculatevels(r);
end
if ~isvariable(r,'sdf')
    STANDARD_DEV=15;
    r=addsdf(r,STANDARD_DEV);
end

sdf=[];hp=[];hv=[];ha=[];ep=[];ev=[];ea=[];direction=[];
t=[]; trial=[]; dgs=[];
vhp=[];vhv=[];vha=[];vep=[];vev=[];vea=[];
neuron=[];

if nargin<3
    FIX_DUR=200;
end

for i =1:height(r)
    %find go signal then include FIX_DUR ms of fixation data
    timestart=r.goSignal(i)-FIX_DUR;
    if timestart<1
        timestart=1;
    end
    sdf=[sdf r.sdf{i}(timestart:end-shift)];
    
    hp=[hp r.headpositions{i}(shift+timestart:end)];
    hv=[hv r.headvelocities{i}(shift+timestart:end)];
    ha=[ha r.headaccelerations{i}(shift+timestart:end)];
    
    ep=[ep r.eyepositions{i}(shift+timestart:end)];
    ev=[ev r.eyevelocities{i}(shift+timestart:end)];
    ea=[ea r.eyeaccelerations{i}(shift+timestart:end)];
    
    %vertical
    vhp=[vhp r.headpositionsV{i}(shift+timestart:end)];
    vhv=[vhv r.headvelocitiesV{i}(shift+timestart:end)];
    vha=[vha r.headaccelerationsV{i}(shift+timestart:end)];
    
    vep=[vep r.eyepositionsV{i}(shift+timestart:end)];
    vev=[vev r.eyevelocitiesV{i}(shift+timestart:end)];
    vea=[vea r.eyeaccelerationsV{i}(shift+timestart:end)];
    
    
    tlength=length(r.eyeaccelerations{i}(shift+timestart:end));    
    t=[t 1:tlength];
    neuron=[neuron repmat({r.trialnum{i}(1:9)},[1,tlength])];
    trial=[trial repmat(i,[1,tlength])];
    gs=strcmp('Adam_Delay01',r.ttype{i});
    dgs=[dgs repmat(gs,[1,tlength])];
    
end
shift=repmat(shift,size(sdf));
sdf=sdf*1500;
variablenames={'neuron','trial','t','dgs','fr',...
    'rhp','lhp','rhv','lhv','rha','lha','rep','lep','rev','lev','rea','lea'...
    'uhp','dhp','uhv','dhv','uha','dha','uep','dep','uev','dev','uea','dea'};

d=table(neuron',trial',t',dgs',sdf',...
    hp',hp',hv',hv',ha',ha',ep',ep',ev',ev',ea',ea',...
    vhp',vhp',vhv',vhv',vha',vha',vep',vep',vev',vev',vea',vea',...
    'variablenames',variablenames);
d.rhp(d.rhp<0)=0;
d.lhp(d.lhp>0)=0;d.lhp=d.lhp*-1;
d.rep(d.rep<0)=0;
d.lep(d.lep>0)=0;d.lep=d.lep*-1;
d.rhv(d.rhv<0)=0;
d.lhv(d.lhv>0)=0;d.lhv=d.lhv*-1;
d.rev(d.rev<0)=0;
d.lev(d.lev>0)=0;d.lev=d.lev*-1;
d.rha(d.rha<0)=0;
d.lha(d.lha>0)=0;d.lha=d.lha*-1;
d.rea(d.rea<0)=0;
d.lea(d.lea>0)=0;d.lea=d.lea*-1;

d.uhp(d.uhp<0)=0;
d.dhp(d.dhp>0)=0;d.dhp=d.dhp*-1;
d.uep(d.uep<0)=0;
d.dep(d.dep>0)=0;d.dep=d.dep*-1;
d.uhv(d.uhv<0)=0;
d.dhv(d.dhv>0)=0;d.dhv=d.dhv*-1;
d.uev(d.uev<0)=0;
d.dev(d.dev>0)=0;d.dev=d.dev*-1;
d.uha(d.uha<0)=0;
d.dha(d.dha>0)=0;d.dha=d.dha*-1;
d.uea(d.uea<0)=0;
d.dea(d.dea>0)=0;d.dea=d.dea*-1;