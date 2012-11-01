load('/project/expeditions/ClimateCodeMatFiles/regression_model_sst_data.mat', 'pacific_indices_mar_oct')
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat

predictors = [pacific_indices_mar_oct, zscore(pacific_indices_mar_oct)];

[~,~,~,~,BmatLeave2Out] = lassoCrossVal(predictors, aso_tcs, 2);
[~,~,~,~,BmatLeave4Out] = lassoCrossVal(predictors, aso_tcs, 4);
[~,~,~,~,BmatLeave8Out] = lassoCrossVal(predictors, aso_tcs, 8);

correlationsLeave2Out = zeros(size(BmatLeave2Out, 2), 1);
correlationsLeave4Out = zeros(size(BmatLeave4Out, 2), 1);
correlationsLeave8Out = zeros(size(BmatLeave8Out, 2), 1);

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
%% 
for i = 1:size(BmatLeave2Out, 2)
   correlationsLeave2Out(i) = corr(predictors * BmatLeave2Out(:, i), aso_tcs); 
   correlationsLeave4Out(i) = corr(predictors * BmatLeave4Out(:, i), aso_tcs);
   correlationsLeave8Out(i) = corr(predictors * BmatLeave8Out(:, i), aso_tcs);
end


%% 
save('pacificIndicesLassoWeights.mat', 'BmatLeave2Out', 'BmatLeave4Out', ...
'BmatLeave8Out', 'correlationsLeave2Out', 'correlationsLeave4Out', 'correlationsLeave8Out')