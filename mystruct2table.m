function t=mystruct2table(s,nowarning)
if nargin<2
    nowarning=0;
end
f=fields(s);
nfields=length(f);
%this is to ensure that one field with a bad size doesn't throw it all off
for i =1:nfields
    ts(i)=length(s.(f{i}));
end
tablesize=mode(ts);
for field =1:nfields
    if length(s.(f{field}))==tablesize
        for i =1:tablesize
            ss(i).(f{field})=s.(f{field})(i);
        end
    else
        if ~nowarning
            warning(['Omitting ',f{field}])
        end
        continue
    end
    
end
    

t=struct2table(ss);
% t=t(:,[1 2 4 5 6 7 17 18 19 20 30 31 32 33]);