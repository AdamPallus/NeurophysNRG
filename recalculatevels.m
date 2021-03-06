%%This function recalculates the velocitiy and acceleration using the newer
%%parabolic diff function.This is necessary for older .mat files, or files
%%that have had the velocity and acceleration data removed to save space.

function [s]=recalculatevels(s)

    psize=7;
    s.headvelocities=cellfun(@(a) parabolicdiff(smooth(a,50)',psize),s.headpositions,'uniformoutput',0);
    s.headaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.headvelocities,'uniformoutput',0);
    s.eyevelocities=cellfun(@(a) parabolicdiff(a,psize), s.eyepositions,'uniformoutput',0);
    s.eyeaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.eyevelocities,'uniformoutput',0);
    s.gazevelocities=cellfun(@(a) parabolicdiff(a,psize), s.gazepositions,'uniformoutput',0);
    s.gazeaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.gazevelocities,'uniformoutput',0);
    
    s.stagevelocities=cellfun(@(a) parabolicdiff(smooth(a,50),psize), s.stagepositions,'uniformoutput',0);
    s.stageaccelerations=cellfun(@(a) parabolicdiff(a,psize), s.stagevelocities,'uniformoutput',0);
    s.stagevelocities2=cellfun(@(a) parabolicdiff(smooth(a,50),psize), s.stagepositions2,'uniformoutput',0);
    s.stageaccelerations2=cellfun(@(a) parabolicdiff(a,psize), s.stagevelocities2,'uniformoutput',0);

    if isvariable(s,'headpositionsV')
        s.headvelocitiesV=cellfun(@(a) parabolicdiff(smooth(a,50)',psize),s.headpositionsV,'uniformoutput',0);
        s.headaccelerationsV=cellfun(@(a) parabolicdiff(a,psize), s.headvelocitiesV,'uniformoutput',0);
        s.eyevelocitiesV=cellfun(@(a) parabolicdiff(a,psize), s.eyepositionsV,'uniformoutput',0);
        s.eyeaccelerationsV=cellfun(@(a) parabolicdiff(a,psize), s.eyevelocitiesV,'uniformoutput',0);
        s.gazevelocitiesV=cellfun(@(a) parabolicdiff(a,psize), s.gazepositionsV,'uniformoutput',0);
        s.gazeaccelerationsV=cellfun(@(a) parabolicdiff(a,psize), s.gazevelocitiesV,'uniformoutput',0);
        
        s.stagevelocitiesV=cellfun(@(a) parabolicdiff(smooth(a,50),psize), s.stagepositionsV,'uniformoutput',0);
        s.stageaccelerationsV=cellfun(@(a) parabolicdiff(a,psize), s.stagevelocitiesV,'uniformoutput',0);
        s.stagevelocities2V=cellfun(@(a) parabolicdiff(smooth(a,50),psize), s.stagepositions2V,'uniformoutput',0);
        s.stageaccelerations2V=cellfun(@(a) parabolicdiff(a,psize), s.stagevelocities2V,'uniformoutput',0);
    end
end


function vels=parabolicdiff(pos,n)
if nargin<2
    n=9;
end
q = sum(2*((1:n).^2));

vels=zeros(size(pos));
c=-conv(pos,[-n:-1 1:n],'valid');
vels(1:n)=ones(n,1)*c(1);
vels(end-n+1:end)=ones(n,1)*c(end);
vels(n:end-n)=c;
vels=vels/q*1000;

end
