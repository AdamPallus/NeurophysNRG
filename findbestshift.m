function [rsquare,shift]=findbestshift(celldata,iarray,leftorright)
%note: altered to use instantcorrelationGS! (11/24/14)
if nargin < 2
    iarray=1:10:200;
end

if nargin<3
    leftoright=0;
end
count=0;
rsquare=zeros(length(iarray),1);
shift=iarray;
for i =iarray
    count=count+1;
%     mdl=instantcorrelation(celldata,i,leftorright);
    mdl=instantcorrelationGS(celldata,i,leftorright);
    rsquare(count)=mdl.Rsquared.Ordinary;
%     c(:,count)=mdl.Coefficients{1:5,1};
end