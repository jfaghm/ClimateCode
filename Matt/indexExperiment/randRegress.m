function [correlations] = randRegress(index, trials, label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if matlabpool('size') == 0
    matlabpool open
end
tic
correlations = zeros(trials, 1);
correlations4 = zeros(trials, 1);
correlations2 = zeros(trials, 1);
correlations3 = zeros(trials, 1);
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
func1 = @crossVal;
func2 = @rmse;
parfor i = 1:trials
    %load the data inside the parfor so that workers have access to aso
    %variables
    s = load('/project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat');
    aso_tcs_par = s.aso_tcs;
    aso_pdi_par = s.aso_pdi;
    aso_ntc_par = s.aso_ntc;
    aso_ace_par = s.aso_ace;
    r = aso_tcs_par(randperm(32));
    [predictions, actuals] = func1(index, r);
    correlations(i) = func2(predictions, actuals);
    
    r = aso_pdi_par(randperm(32));
    [predictions, actuals] = func1(index, r);
    correlations2(i) = func2(predictions, actuals);
    
    r = aso_ntc_par(randperm(32));
    [predictions, actuals] = func1(index, r);
    correlations3(i) = func2(predictions, actuals);
    
    r = aso_ace_par(randperm(32));
    [predictions, actuals] = func1(index, r);
    correlations4(i) = func2(predictions, actuals);
    %}        
    %{
    [predictions, actuals] = crossVal(index, rand(32, 1));
    correlations(i, 1) = corr(predictions, actuals);
    
    [predictions, actuals] = crossVal(index, rand(32, 1));
    correlations(i, 2) = corr(predictions, actuals);
    
    [predictions, actuals] = crossVal(index, rand(32, 1));
    correlations(i, 3) = corr(predictions, actuals);
    
    [predictions, actuals] = crossVal(index, rand(32, 1));
    correlations(i, 4) = corr(predictions, actuals);
    %}
end
correlations = [correlations, correlations2, correlations3, correlations4];
if nargin == 3
testType = 'RMSE';
lessOrMore = 'smaller';
funcType = 'Cross Validation RMSE';
func3 = @le;
%%%%%%%%%%%%%%%%%%%%Plot data
subplot(4, 1, 1);
[pred, actual] = func1(index, aso_tcs);
c = func2(pred, actual);
hist(correlations(:, 1), 50);
n = numelements(find(func3(correlations(:, 1), c)));
title([label ' Randomized ' funcType ' TCs - Original ' testType ' = ' num2str(c) ' ' num2str(n) ' random ' testType 's were ' lessOrMore]);

subplot(4, 1, 2)
[pred, actual] = func1(index, aso_pdi);
c = func2(pred, actual);
hist(correlations(:, 2), 50);
n = numelements(find(func3(correlations(:, 2), c)));
title([label ' Randomized ' funcType ' PDI - Original ' testType ' = ' num2str(c) ' ' num2str(n) ' random ' testType 's were ' lessOrMore]);

subplot(4, 1, 3)
[pred, actual] = func1(index, aso_ntc);
c = func2(pred, actual);
hist(correlations(:, 3), 50);
n = numelements(find(func3(correlations(:, 3), c)));
title([label ' Randomized ' funcType ' NTC - Original ' testType ' = ' num2str(c) ' ' num2str(n) ' random ' testType 's were ' lessOrMore]);


subplot(4, 1, 4);
[pred, actual] = func1(index, aso_ace);
c = func2(pred, actual);
hist(correlations(:, 4), 50);
n = numelements(find(func3(correlations(:, 4), c)));
title([label ' Randomized ' funcType ' ACE - Original ' testType ' = ' num2str(c) ' ' num2str(n) ' random ' testType 's were ' lessOrMore]);

%%%%%%%%%%%%%%%%%%%%%%
end
toc
end

function [pred, target] = regressHelper(index, target)
    beta = polyfit(index, target, 1);
    pred = index * beta(1) + beta(2);
end

%manually written cross validation code
%{
function [predictions, target] = crossVal(index, target)
    predictions = zeros(32, 1);
    for i = 1:32
        trainingIndex = index([1:i-1, i+1:end]);
        trainingTarget = target([1:i-1, i+1:end]);
        beta = polyfit(trainingIndex, trainingTarget, 1);
        predictions(i) = index(i) * beta(1) + beta(2);
    end
end
%}


function [predictions, actuals] = crossVal(index, target)
    c = cvpartition(32, 'kfold', 32);
    predictions = zeros(32, 1);
    actuals = zeros(32, 1);
    for i = 1:32
       mask = training(c, i); %get the mask for the training set
       beta = polyfit(index(mask), target(mask), 1);  %calculate regressino coefficients
       predictions(i) = polyval(beta, index(~mask));
       actuals(i) = target(~mask); %add leftout actual value to actuals set
       %corr(actuals(actuals ~= 0), predictions(predictions ~= 0))
    end
    
end
%}

function r=rmse(data,estimate)
% Function to calculate root mean square error from a data vector or matrix 
% and the corresponding estimates.
% Usage: r=rmse(data,estimate)
% Note: data and estimates have to be of same size
% Example: r=rmse(randn(100,100),randn(100,100));
% Taken from Matlab File Exchange
% delete records with NaNs in both datasets first
I = ~isnan(data) & ~isnan(estimate); 
data = data(I); estimate = estimate(I);

r=sqrt(sum((data(:)-estimate(:)).^2)/numel(data));
end

