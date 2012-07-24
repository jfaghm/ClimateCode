function [coefficients] = randomCrossValCorrelations(indices, k, trials, label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tic
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
coefficients = zeros(trials, 5);
for i = 1:trials
    [yVals, actuals] = crossValidate(indices, aso_ace(randperm(32)), k);
    cc(1, 1) = corr(yVals, actuals);
    [yVals, actuals] = crossValidate(indices, aso_ntc(randperm(32)), k);
    cc(3, 1) = corr(yVals, actuals);
    [yVals, actuals] = crossValidate(indices, aso_pdi(randperm(32)), k);
    cc(4, 1) = corr(yVals, actuals);
    [yVals, actuals] = crossValidate(indices, aso_tcs(randperm(32)), k);
    cc(5, 1) = corr(yVals, actuals);
    coefficients(i, :) = cc';
end

[yVals, actuals] = crossValidate(indices, aso_ace, k);
subplot(4, 1, 1);
hist(coefficients(:, 1));
title([label ' Randomized Cross Validation Correlations ACE - Original Correlation = ' num2str(corr(yVals, actuals))]);
[yVals, actuals] = crossValidate(indices, aso_ntc, k);
subplot(4, 1, 2);
hist(coefficients(:, 3));
title([label ' Randomized Cross Validation Correlations NTC - Original Correlation = ' num2str(corr(yVals, actuals))]);

[yVals, actuals] = crossValidate(indices, aso_pdi, k);
subplot(4, 1,3);
hist(coefficients(:, 4));
title([label ' Randomized Cross Validation Correlations PDI - Original Correlation = ' num2str(corr(yVals, actuals))]);

[yVals, actuals] = crossValidate(indices, aso_tcs, k);
subplot(4, 1, 4);
hist(coefficients(:, 5));
title([label ' Randomized Cross Validation Correlations TCS - Original Correlation = ' num2str(corr(yVals, actuals))]);

toc
end
