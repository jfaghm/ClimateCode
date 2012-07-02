function [ negYears, posYears ] = getPosNegYearsSOI( input_args )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
load matFiles/SOIIndex.mat;

SOI = SOI(SOI(:, 1) >= 1979 & SOI(:, 1) <= 2010, :);

SOI = SOI(:, 4:11);

SOI = nanmean(SOI, 2);
normalizedSOI = (SOI - mean(SOI)) ./ std(SOI);

baseYear = 1979;
posYears = find(normalizedSOI >= 1) + baseYear - 1;
negYears = find(normalizedSOI <= -1) + baseYear - 1;

end

