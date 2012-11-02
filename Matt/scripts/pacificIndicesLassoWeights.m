%%
clear
load('/project/expeditions/ClimateCodeMatFiles/regression_model_sst_data.mat', 'pacific_indices_mar_oct')
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat
load /project/expeditions/ClimateCodeMatFiles/augOctPacificBasinEOFPCs.mat
%% 
%predictors = [pacific_indices_mar_oct, zscore(pacific_indices_mar_oct)];
predictors = [pacific_indices_mar_oct];%, PCs];

trials = 1;
for i = 1:trials
    target = aso_tcs;%aso_tcs(randperm(32));
    
    [~,~,~,~,BmatLeave2Out] = lassoCrossVal(predictors, target, 2);
    [~,~,~,~,BmatLeave4Out] = lassoCrossVal(predictors, target, 4);
    [~,~,~,~,BmatLeave8Out] = lassoCrossVal(predictors, target, 8);

    leave2OutPred = predictForAllLambdasCrossVal(BmatLeave2Out, predictors);
    leave4OutPred = predictForAllLambdasCrossVal(BmatLeave4Out, predictors);
    leave8OutPred = predictForAllLambdasCrossVal(BmatLeave8Out, predictors);

    for j = 1:min([size(leave2OutPred, 2), size(leave4OutPred, 2), size(leave8OutPred, 2)])
       correlationsLeave2Out(i, j) = corr(leave2OutPred(:, j), target);
       correlationsLeave4Out(i, j) = corr(leave4OutPred(:, j), target);
       correlationsLeave8Out(i, j) = corr(leave8OutPred(:, j), target);
    end
end


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