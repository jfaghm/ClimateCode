function [coefficients] = randomCrossValCorrelations(indices, k, trials, label)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function randomly changes the order of the target values that we are
%trying to predict in the cross validation code, and repeats the process
%"trials" times.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: nxm matrix of indices, where n = number of years and m = number of
%       indices
%       
%       k = number of folds performed in the cross validation code
%
%       trials = how many times the cross valdation code is performed
%      
%       label is used for the plot that is made at the end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output: a matrix of correlation coefficients, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
coefficients = zeros(trials, 4);
for i = 1:trials
    
    r = aso_ace(randperm(32));
    [yVals1, actuals1] = crossValidate(indices, r, k);
    cc(1, 1) = corr(yVals1, actuals1);
    
    r = aso_ntc(randperm(32));
    [yVals2, actuals2] = crossValidate(indices, r, k);
    cc(2, 1) = corr(yVals2, actuals2);
    
    r = aso_pdi(randperm(32));
    [yVals3, actuals3] = crossValidate(indices, r, k);
    cc(3, 1) = corr(yVals3, actuals3);
    
    r = aso_tcs(randperm(32));
    [yVals4, actuals4] = crossValidate(indices, r, k);
    cc(4, 1) = corr(yVals4, actuals4);

    coefficients(i, :) = cc';

end
if nargin == 4
%plot results
    [yVals, actuals] = crossValidate(indices, aso_ace, k);
    subplot(4, 1, 1);
    hist(coefficients(:, 1), 9);
    title([label ' Randomized Cross Validation Correlations ACE - Original Correlation = ' num2str(corr(yVals, actuals))]);
    [yVals, actuals] = crossValidate(indices, aso_ntc, k);
    subplot(4, 1, 2);
    hist(coefficients(:, 2), 9);
    title([label ' Randomized Cross Validation Correlations NTC - Original Correlation = ' num2str(corr(yVals, actuals))]);

    [yVals, actuals] = crossValidate(indices, aso_pdi, k);
    subplot(4, 1,3);
    hist(coefficients(:, 3), 9);
    title([label ' Randomized Cross Validation Correlations PDI - Original Correlation = ' num2str(corr(yVals, actuals))]);

    [yVals, actuals] = crossValidate(indices, aso_tcs, k);
    subplot(4, 1, 4);
    hist(coefficients(:, 4), 9);
    title([label ' Randomized Cross Validation Correlations TCS - Original Correlation = ' num2str(corr(yVals, actuals))]);
    %print('-dpdf', '-r400', [label ' RandomizedCrossValidation']);
end
toc
end
