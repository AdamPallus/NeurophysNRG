%regress script
useTType=0;
[Neurons,mLeft, mRight, LeftShift,RightShift]=dynamicfit(useTType);

NAs=cellfun(@isempty,mLeft);
if sum(NAs)>0
    Neurons=Neurons(~NAs);
    mLeft=mLeft(~NAs);
    mRight=mRight(~NAs);
    LeftShift=LeftShift(~NAs);
    RightShift=RightShift(~NAs);
end

%convert everything back from cell arrays and extract the appropriate
%values for plotting

for i =1:length(mLeft)
    if ~strcmp(mRight{i}.Formula.char,'fr ~ 1 + hv')
        x=mRight{i}.Variables;
        mRightHV{i}=fitlm(x,'fr ~ 1 + hv');
        RightRsquaredHV(i)=mRightHV{i}.Rsquared.Ordinary;
        RightFormulaHV{i}=mRightHV{i}.Formula.char;
        RightCoefHV{i}=num2str(mRightHV{i}.Coefficients.Estimate');
    end
    if ~strcmp(mLeft{i}.Formula.char,'fr ~ 1 + hv')
        x=mLeft{i}.Variables;
        mLeftHV{i}=fitlm(x,'fr ~ 1 + hv');
        LeftRsquaredHV(i)=mLeftHV{i}.Rsquared.Ordinary;
        LeftFormulaHV{i}=mLeftHV{i}.Formula.char;
        LeftCoefHV{i}=num2str(mLeftHV{i}.Coefficients.Estimate');
    end
    LeftRsquared(i)=mLeft{i}.Rsquared.Ordinary;
    LeftFormula{i}=mLeft{i}.Formula.char;
    RightRsquared(i)=mRight{i}.Rsquared.Ordinary;
    RightFormula{i}=mRight{i}.Formula.char;
    LeftCoef{i}=num2str(mLeft{i}.Coefficients.Estimate');
    RightCoef{i}=num2str(mRight{i}.Coefficients.Estimate');
end
d=[num2cell(LeftShift);num2cell(LeftRsquared);LeftFormula;LeftCoef;...
    num2cell(RightShift);num2cell(RightRsquared);RightFormula;RightCoef;...
    num2cell(LeftRsquaredHV);LeftFormulaHV;LeftCoefHV;...
    num2cell(RightRsquaredHV);RightFormulaHV;RightCoefHV];
cnames={'Neuron','LeftShift','LeftRsquared','LeftFormula','LeftCoefficients',...
    'RightShift','RightRsquared','RightFormula','RightCoefficients',...
    'LeftRsquaredHV','LeftFormulaHV','LeftCoefHV',...
    'RightRsquaredHV','RightFormulaHV','RightCoefHV'};
dataxls('RegressRedoMulti.xls',cnames,Neurons',d')