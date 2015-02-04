function r=getMaxFRandGS(r,smoothnum,starttime,stoptime)
if nargin < 4
    display('using default values')
    smoothnum=4;
    starttime=100;
    stoptime=500;
end

gazeshift=[];
    spmaxfr=findmaxfr(r,smoothnum,starttime,stoptime);
    gazeshift=cellfun(@(x) strcmp(x,'Adam_Delay01'),r.ttype);
    r.spmaxfr=spmaxfr;
    r.gazeshift=gazeshift;