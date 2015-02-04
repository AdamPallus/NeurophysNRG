function o=getcoefs(t)

for i =1:height(t)
    rhv(i)=sub('rhv',t.coef{i});
    lhv(i)=sub('lhv',t.coef{i});
    
    rha(i)=sub('rha',t.coef{i});
    lha(i)=sub('lha',t.coef{i});
    
    rhp(i)=sub('rhp',t.coef{i});
    lhp(i)=sub('lhp',t.coef{i});
    
    rev(i)=sub('rev',t.coef{i});
    lev(i)=sub('lev',t.coef{i});
    
    rep(i)=sub('rep',t.coef{i});
    lep(i)=sub('lep',t.coef{i});
    
    rea(i)=sub('rea',t.coef{i});
    lea(i)=sub('lea',t.coef{i});
end
o=t(:,1:end-1);
z=table(rhv',lhv',rep',lep',rha',lha',rhp',lhp',rev',lev',rea',lea',...
    'variablenames',...
    {'rhv','lhv','rep','lep','rha','lha','rhp','lhp','rev','lev','rea','lea'});
o=horzcat(o,z);

function o=sub(coefString,t)

if any(strcmp(t.Properties.RowNames,coefString))
    o=t(coefString,1).Estimate;
else
    o=0;
end