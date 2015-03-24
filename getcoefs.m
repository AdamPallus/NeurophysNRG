function o=getcoefs(t)

for i =1:height(t)
    rhv(i)=sub('rhv',t,i);
    lhv(i)=sub('lhv',t,i);
    
    rha(i)=sub('rha',t,i);
    lha(i)=sub('lha',t,i);
    
    rhp(i)=sub('rhp',t,i);
    lhp(i)=sub('lhp',t,i);
    
    rev(i)=sub('rev',t,i);
    lev(i)=sub('lev',t,i);
    
    rep(i)=sub('rep',t,i);
    lep(i)=sub('lep',t,i);
    
    rea(i)=sub('rea',t,i);
    lea(i)=sub('lea',t,i);
    
    %vertical
    uhv(i)=sub('uhv',t,i);
    dhv(i)=sub('dhv',t,i);
   
    uha(i)=sub('uha',t,i);
    dha(i)=sub('dha',t,i);
    
    uhp(i)=sub('uhp',t,i);
    dhp(i)=sub('dhp',t,i);
    
    uev(i)=sub('uev',t,i);
    dev(i)=sub('dev',t,i);
    
    uep(i)=sub('uep',t,i);
    dep(i)=sub('dep',t,i);
    
    uea(i)=sub('uea',t,i);
    dea(i)=sub('dea',t,i);
    
    %trialtype
    dgs(i)=sub('dgs',t,i);
end
% o=t(:,1:end-1);
z=table(rhv',lhv',rep',lep',rha',lha',rhp',lhp',rev',lev',rea',lea',...
    uhv',dhv',uep',dep',uha',dha',uhp',dhp',uev',dev',uea',dea',...
    dgs',...
    'variablenames',...
    {'rhv','lhv','rep','lep','rha','lha','rhp','lhp','rev','lev','rea','lea',...
     'uhv','dhv','uep','dep','uha','dha','uhp','dhp','uev','dev','uea','dea',...
     'ttype'});
o=horzcat(t,z);
o.coef=[];

function o=sub(coefString,t,i)

if any(strcmp(t.coef{i}.Properties.RowNames,coefString))
% if ~isempty(regexp(t.f{1},coefString))
    o=t.coef{i}(coefString,1).Estimate;
else
    o=NaN;
end