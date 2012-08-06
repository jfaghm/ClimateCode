function [cc] = crossValCorrelations(indices, k, indexType)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
[yVals, actuals] = crossValidate(indices, aso_ace, k, 'ACE', indexType);
cc(1, 1) = corr(yVals, actuals);

[yVals, actuals] = crossValidate(indices, aso_major_hurricanes, k, 'MajorHurr', indexType);
cc(2, 1) = corr(yVals, actuals);

[yVals, actuals] = crossValidate(indices, aso_ntc, k, 'NTC', indexType);
cc(3, 1) = corr(yVals, actuals);

[yVals, actuals] = crossValidate(indices, aso_pdi, k, 'PDI', indexType);
cc(4, 1) = corr(yVals, actuals);

[yVals, actuals] = crossValidate(indices, aso_tcs, k, 'TCS', indexType);
cc(5, 1) = corr(yVals, actuals);

end

