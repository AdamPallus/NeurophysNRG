
function d=sdftableLR(r,shift)

if ~isvariable(r,'headvelocities')
    r=recalculatevels(r);
end
if ~isvariable(r,'sdf')
    STANDARD_DEV=15;
    r=addsdf(r,STANDARD_DEV);
end

sdf=[];hp=[];hv=[];ha=[];ep=[];ev=[];ea=[];direction=[];

for i =1:height(r)
    
    sdf=[sdf r.sdf{i}(1:end-shift)];
    
    hp=[hp r.headpositions{i}(shift+1:end)];
    hv=[hv r.headvelocities{i}(shift+1:end)];
    ha=[ha r.headaccelerations{i}(shift+1:end)];
    
    ep=[ep r.eyepositions{i}(shift+1:end)];
    ev=[ev r.eyevelocities{i}(shift+1:end)];
    ea=[ea r.eyeaccelerations{i}(shift+1:end)];
        
    
end
shift=repmat(shift,size(sdf));
sdf=sdf*1500;
variablenames={'fr','rhp','lhp','rhv','lhv','rha','lha','rep','lep','rev','lev','rea','lea'};
d=table(sdf',hp',hp',hv',hv',ha',ha',ep',ep',ev',ev',ea',ea',...
    'variablenames',variablenames);
d.rhp(d.rhp<0)=0;
d.lhp(d.lhp>0)=0;
d.rep(d.rep<0)=0;
d.lep(d.lep>0)=0;
d.rhv(d.rhv<0)=0;
d.lhv(d.lhv>0)=0;
d.rev(d.rev<0)=0;
d.lev(d.lev>0)=0;
d.rha(d.rha<0)=0;
d.lha(d.lha>0)=0;
d.rea(d.rea<0)=0;
d.lea(d.lea>0)=0;