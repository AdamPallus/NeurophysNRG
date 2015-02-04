
function [x,pRight, pLeft FRdiffR FRdiffL normFRdiffR normFRdiffL]=compareGSPursuitFR

[filenames filepath]=uigetfile('*.mat','Select Files to Measure','multiselect','on');
if iscell(filenames)
    x=filenames;
else
    errordlg('Choose more than one file','Not Enough')
    return
end

[pRight pLeft FRdiffR FRdiffL normFRdiffR normFRdiffL]=cellfun(@compare_gs_pursuit,x);

end


function [pRight pLeft FRdiffR FRdiffL normFRdiffR normFRdiffL]=compare_gs_pursuit(x)

    vname=x(1:end-4);
    filepath='C:\Users\adam2\Documents\MATLAB\dec12 analysis\sorted spikes\';
    r=load([filepath x]);
    r=r.(vname);
    %find max firing rate between 100-500 ms
    %smoothed 4 points. go signal at 100
    gazeshift=[];
    spmaxfr=findmaxfr(r,4,100,500);
    gazeshift=cellfun(@(a) strcmp(a,'Adam_Delay01'),r.ttype);
    indRight = find(r.hpeak>100&r.hpeak<200);
    indLeft  = find(r.hpeak<-100&r.hpeak>-200);
    
    [pRight atab statsRight]=anova1(spmaxfr(indRight),gazeshift(indRight),'off');
    [pLeft atab statsLeft]=anova1(spmaxfr(indLeft),gazeshift(indLeft),'off');
    if ~isnan(pRight)
        FRdiffR=statsRight.means(1)-statsRight.means(2);
        normFRdiffR=FRdiffR/(sum(statsRight.means));
    else
        FRdiffR=NaN;
        normFRdiffR=NaN;
    end
    if ~isnan(pLeft)
        FRdiffL=statsLeft.means(1)-statsLeft.means(2);
        normFRdiffL=FRdiffL/(sum(statsLeft.means));
    else
        FRdiffL=NaN;
        normFRdiffL=NaN;
    end

end
    