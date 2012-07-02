function [ negYears, posYears] = getPosNegYearsAMO()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load matFiles/AMOIndex.mat;
AMO = AMO(AMO(:, 1) >= 1979 & AMO(:, 1) <= 2010, 4:11); %First column is the year, so 4-11 is actually march to october

AMO = nanmean(AMO, 2);

normalizedAMO = (AMO - mean(AMO)) ./ std(AMO);
baseYear = 1979;
posYears = find(normalizedAMO >= 1) + baseYear - 1;
negYears = find(normalizedAMO <= -1) + baseYear - 1;


end

