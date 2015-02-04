function dataxls(savepath,cnames,rnames,d,sheet)
if nargin<5
    sheet=1;
end

xlswrite(savepath,cnames,sheet,'A1')
xlswrite(savepath,rnames',sheet,'A2')
xlswrite(savepath,d,sheet,'B2');
