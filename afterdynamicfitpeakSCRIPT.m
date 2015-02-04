
%rune this code after dynamicfitpeak.m
for i =1:length(mLeft)
LeftRsquared(i)=mLeft{i}.Rsquared.Ordinary;
LeftFormula{i}=mLeft{i}.Formula.char;
RightRsquared(i)=mRight{i}.Rsquared.Ordinary;
RightFormula{i}=mRight{i}.Formula.char;
LeftCoef{i}=num2str(mLeft{i}.Coefficients.Estimate');
RightCoef{i}=num2str(mRight{i}.Coefficients.Estimate');
end
d=[num2cell(LeftShift);num2cell(LeftRsquared);LeftFormula;LeftCoef;num2cell(RightShift);num2cell(RightRsquared);RightFormula;RightCoef];
cnames={'Neuron','LeftShift','LeftRsquared','LeftFormula','LeftCoefficients','RightShift','RightRsquared','RightFormula','RightCoefficients'};
dataxls('MultiRegressNoTT.xls',cnames,Neurons',d')