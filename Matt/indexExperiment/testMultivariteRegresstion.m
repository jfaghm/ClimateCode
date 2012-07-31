function [correlations] = testMultivariteRegresstion(trials)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

sstIndex = buildIndex4(1, 3, 10);
olrIndex = buildIndex4(2, 3, 10);
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat

correlations = zeros(trials, 1);
for i = 1:trials
    r = aso_tcs(randperm(32));
    [~,prediction] = multipleRegress([sstIndex, olrIndex], r);
    correlations(i) = corr(r, prediction);
end

hist(correlations)
[~,prediction] = multipleRegress([sstIndex, olrIndex], aso_tcs);
c = corr(prediction, aso_tcs);
title(['Original Correlation = ' num2str(c)]);


end

