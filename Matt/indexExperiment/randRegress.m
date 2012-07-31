function [correlations] = randRegress(index, trials, label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

correlations = zeros(trials, 4);
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
for i = 1:trials
    %{
    r = aso_tcs(randperm(32));
    [predictions, actuals] = crossVal(index, r);
    correlations(i, 1) = corr(predictions, actuals);
    
    r = aso_pdi(randperm(32));
    [predictions, actuals] = crossVal(index, r);
    correlations(i, 2) = corr(predictions, actuals);
    
    r = aso_ntc(randperm(32));
    [predictions, actuals] = crossVal(index, r);
    correlations(i, 3) = corr(predictions, actuals);
    
    r = aso_ace(randperm(32));
    [predictions, actuals] = crossVal(index, r);
    correlations(i, 4) = corr(predictions, actuals);
    %}
    
    r = aso_tcs(randperm(32));
    predictions = regressHelper(index, r);
    correlations(i, 1) = corr(predictions, r);
    
    r = aso_pdi(randperm(32));
    predictions = regressHelper(index, r);
    correlations(i, 2) = corr(predictions, r);
    
    r = aso_ntc(randperm(32));
    predictions = regressHelper(index, r);
    correlations(i, 3) = corr(predictions, r);
    
    r  =aso_ace(randperm(32));
    predictions = regressHelper(index, r);
    correlations(i, 4) = corr(predictions, r);
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
%%%%%%%%%%%%%%%%%%%%Plot data
func = @regressHelper;
subplot(4, 1, 1);
[pred, actual] = func(index, aso_tcs);
c = corr(pred, actual);
hist(correlations(:, 1));
n = numelements(find(correlations(:, 1) >= c));
title([label ' Randomized Correlations TCs - Original Corr = ' num2str(c) ' ' num2str(n) ' random corr were greater']);

subplot(4, 1, 2)
[pred, actual] = func(index, aso_pdi);
c = corr(pred, actual);
hist(correlations(:, 2));
n = numelements(find(correlations(:, 2) >= c));
title([label ' Randomized Correlations PDI - Original Corr = ' num2str(c) ' ' num2str(n) ' random corr were greater']);

subplot(4, 1, 3)
[pred, actual] = func(index, aso_ntc);
c = corr(pred, actual);
hist(correlations(:, 3));
n = numelements(find(correlations(:, 3) >= c));
title([label ' Randomized Correlations NTC - Original Corr = ' num2str(c) ' ' num2str(n) ' random corr were greater']);


subplot(4, 1, 4);
[pred, actual] = func(index, aso_ace);
c = corr(pred, actual);
hist(correlations(:, 4));
n = numelements(find(correlations(:, 4) >= c));
title([label ' Randomized Correlations ACE - Original Corr = ' num2str(c) ' ' num2str(n) ' random corr were greater']);

%%%%%%%%%%%%%%%%%%%%%%
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

