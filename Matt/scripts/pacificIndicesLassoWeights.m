%%
clear
load('/project/expeditions/ClimateCodeMatFiles/regression_model_sst_data.mat', 'pacific_indices_mar_oct')
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat
load /project/expeditions/ClimateCodeMatFiles/augOctPacificBasinEOFPCs.mat
%% 
%predictors = [pacific_indices_mar_oct, zscore(pacific_indices_mar_oct)];
predictors = [pacific_indices_mar_oct, PCs(:, 1:2)];
predictorsName = 'pacificIndicesWithEOFs';
trials = 1000;
for i = 1:trials
    target = aso_tcs(randperm(32));
    
    [B, fitInfo] = lasso(predictors, target);
    
    for j = 1:size(B, 2)
        randRegressionCorr(i, j) = corr(predictors * B(:, j) + fitInfo.Intercept(j), target);
    end
    
    %[~,~,~,~,BmatLeave2Out, intercepts2] = lassoCrossVal(predictors, target, 2);
    %[~,~,~,~,BmatLeave4Out, intercepts4] = lassoCrossVal(predictors, target, 4);
    [~,~,~,~,BmatLeave8Out, intercepts8] = lassoCrossVal(predictors, target, 8);

    %leave2OutPred = predictForAllLambdasCrossVal(BmatLeave2Out, predictors, intercepts2);
    %leave4OutPred = predictForAllLambdasCrossVal(BmatLeave4Out, predictors, intercepts4);
    leave8OutPred = predictForAllLambdasCrossVal(BmatLeave8Out, predictors, intercepts8);
    
    for j = 1:size(leave8OutPred, 2)%min([size(leave2OutPred, 2), size(leave4OutPred, 2), size(leave8OutPred, 2)])
       %randCorrelationsLeave2Out(i, j) = corr(leave2OutPred(:, j), target);
       %randCorrelationsLeave4Out(i, j) = corr(leave4OutPred(:, j), target);
       randCorrelationsLeave8Out(i, j) = corr(leave8OutPred(:, j), target);
    end
    
end
%%

[BRegress, fi] = lasso(predictors, aso_tcs);
for i = 1:size(BRegress, 2)
    regressionCorr(i) = corr(predictors * BRegress(:, i) + fi.Intercept(i), aso_tcs);
end

[~,~,~,~,B2, int] = lassoCrossVal(predictors, aso_tcs, 2);
leave2OutPred = predictForAllLambdasCrossVal(B2, predictors, int);
[~,~,~,~,B2, int] = lassoCrossVal(predictors, aso_tcs, 4);
leave4OutPred = predictForAllLambdasCrossVal(B2, predictors, int);
[~,~,~,~,B2, int] = lassoCrossVal(predictors, aso_tcs, 8);
leave8OutPred = predictForAllLambdasCrossVal(B2, predictors, int);

for i = 1:min([size(leave2OutPred, 2), size(leave4OutPred, 2), size(leave8OutPred, 2)])
    %correlationsLeave2Out(i) = corr(leave2OutPred(:, i), aso_tcs);
    %correlationsLeave4Out(i) = corr(leave4OutPred(:, i), aso_tcs);
    correlationsLeave8Out(i) = corr(leave8OutPred(:, i), aso_tcs);
end

%% -------make histogram if random trials are used
% 1, end/2, 90, 95
lambda = fitInfo.Lambda(61);
lambdaInd = closestIndex(fitInfo.Lambda, lambda);

close all

n = size(randCorrelationsLeave8Out, 1);
subplot(4, 1, 1)
hold on
hist(randRegressionCorr(:, lambdaInd));
title(['Straight Regression with ' num2str(n) ' random trials (Lambda = ' num2str(lambda) ')'...
    ' nonRandCorr = ' num2str(regressionCorr(lambdaInd))])
xlabel('correlation')
vline(regressionCorr(lambdaInd), 'r');
hold off

subplot(4, 1, 2);
hold on
hist(randCorrelationsLeave8Out(:, lambdaInd))
title(['Leave 8 out cross validation with ' num2str(n) ' random trials (Lambda = ' num2str(lambda) ')'...
    ' nonRandCorr = ' num2str(correlationsLeave8Out(lambdaInd))]);
xlabel('Correlation');
vline(correlationsLeave8Out(lambdaInd), 'r');
hold off
%{
subplot(4, 1, 3);
hold on
hist(randCorrelationsLeave4Out(:, lambdaInd))
title(['Leave 4 out cross validation with ' num2str(n) ' random trials (Lambda = ' num2str(lambda) ')'...
    ' nonRandCorr = ' num2str(correlationsLeave4Out(lambdaInd))]);
xlabel('Correlation')
vline(correlationsLeave4Out(lambdaInd), 'r');
hold off

subplot(4, 1, 4);
hold on
hist(randCorrelationsLeave2Out(:, lambdaInd))
title(['Leave 2 out Cross Validation with ' num2str(n) ' random trials (Lambda = ' num2str(lambda) ')'...
    ' nonRandCorr = ' num2str(correlationsLeave2Out(lambdaInd))]);
xlabel('Correlation')
vline(correlationsLeave2Out(lambdaInd), 'r');
hold off
%}

numPred = size(predictors, 2);

saveDir = ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/'...
    'paperDraft/regressionWeights/histograms/' predictorsName '/trials'...
    num2str(trials)  '/' num2str(numPred) 'Predictors/lambda' num2str(lambda) '.pdf'];

set(gcf, 'PaperPosition', [0, 0, 8, 11]);
set(gcf, 'PaperSize', [8, 11]);
saveas(gcf, saveDir, 'pdf');
%% 
save('pacificIndicesLassoWeights.mat', 'BmatLeave2Out', 'BmatLeave4Out', ...
'BmatLeave8Out', 'correlationsLeave2Out', 'correlationsLeave4Out', 'correlationsLeave8Out')

%% 
addpath('../datTextFiles/');
pdoAugOct = parseFile('PDO.dat', 8, 10);
pdoMarOct = parseFile('PDO.dat', 3, 10);

load /project/expeditions/ClimateCodeMatFiles/augOctPacificBasinEOFPCs.mat

cc(1) = corr(predictors(:, 1), pdoAugOct);
cc(2) = corr(predictors(:, 2), pdoAugOct);
cc(3) = corr(predictors(:, 3), pdoAugOct);
cc(4) = corr(predictors(:, 4), pdoAugOct);
cc(5) = corr(predictors(:, 5), pdoAugOct);

cc(6) = corr(predictors(:, 1), pdoMarOct);
cc(7) = corr(predictors(:, 2), pdoMarOct);
cc(8) = corr(predictors(:, 3), pdoMarOct);
cc(9) = corr(predictors(:, 4), pdoMarOct);
cc(10) = corr(predictors(:, 5), pdoMarOct);

cc(11) = corr(sum(predictors(:, 6:end), 2), pdoAugOct);
cc(12) = corr(sum(predictors(:, 6:end), 2), pdoMarOct);

[B, fitInfo] = lasso(predictors(:, 1:5), aso_tcs);
pred = predictors(:, 1:5) * B(:, 1);
cc(13) = corr(pred, pdoAugOct);
cc(14) = corr(pred, pdoMarOct);