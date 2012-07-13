function [cc] = crossValCorrelations(indices, k)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;

[yVals, actuals] = crossValidate(indices, aso_ace, k);
cc(1, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_major_hurricanes, k);
cc(2, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_ntc, k);
cc(3, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_pdi, k);
cc(4, 1) = corr(yVals, actuals);
[yVals, actuals] = crossValidate(indices, aso_tcs, k);
cc(5, 1) = corr(yVals, actuals);
end

