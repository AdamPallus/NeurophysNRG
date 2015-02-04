
function d=sdftable(r,shift)

if ~isvariable(r,'headvelocities')
    r=recalculatevels(r);
end
if ~isvariable(r,'sdf')
    r=addsdf(r);
end

r.dir=sign(r.pursuit_velocity);
%find delay trials
tt=cellfun(@(a) strcmp(a,'Adam_Delay01'),r.ttype);
dd=cellfun(@(a) sign(mean(a)),r.gazepositions);
r.dir(tt)=dd(tt);



sdf=[];hp=[];hv=[];ha=[];ep=[];ev=[];ea=[];direction=[];

for i =1:height(r)
    
    sdf=[sdf r.sdf{i}(1:end-shift)];
    
    hp=[hp r.headpositions{i}(shift+1:end)];
    hv=[hv r.headvelocities{i}(shift+1:end)];
    ha=[ha r.headaccelerations{i}(shift+1:end)];
    
    ep=[ep r.eyepositions{i}(shift+1:end)];
    ev=[ev r.eyevelocities{i}(shift+1:end)];
    ea=[ea r.eyeaccelerations{i}(shift+1:end)];
        
    direction=[direction repmat(r.dir(i),[1,length(r.sdf{i})-shift])];
    
end
shift=repmat(shift,size(sdf));
sdf=sdf*1500;
d=table(sdf',hp',hv',ha',ep',ev',ea',direction',shift',...
    'variablenames',{'fr','hp','hv','ha','ep','ev','ea','dir','shift'});