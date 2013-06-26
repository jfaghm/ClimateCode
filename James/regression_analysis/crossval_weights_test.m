load('/project/expeditions/ClimateCodeMatFiles/regression_model_sst_data.mat', 'pacific_indices_mar_oct')
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');
load /project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat

predictors = [pacific_indices_mar_oct(:,1) pacific_indices_mar_oct(:,5) pac_pcs_aug_oct(:,1:2) atl_pcs_aug_oct(:,1:2) joint_pcs_aug_oct(:,1:2)];

%[~,~,~,~,BmatLeave2Out] = lassoCrossVal(predictors, aso_tcs, 2);
%[~,~,~,~,BmatLeave4Out] = lassoCrossVal(predictors, aso_tcs, 4);
[~,~,~,~,BmatLeave8Out] = lassoCrossVal(predictors, aso_tcs, 8);

%correlationsLeave2Out = zeros(size(BmatLeave2Out, 2), 1);
%correlationsLeave4Out = zeros(size(BmatLeave4Out, 2), 1);
correlationsLeave8Out = zeros(size(BmatLeave8Out, 2), 1);

%% 
for i = 1:size(BmatLeave8Out, 2)
   %correlationsLeave2Out(i) = corr(predictors * BmatLeave2Out(:, i), aso_tcs); 
   %correlationsLeave4Out(i) = corr(predictors * BmatLeave4Out(:, i), aso_tcs);
   correlationsLeave8Out(i) = corr(predictors * BmatLeave8Out(:, i), aso_tcs);
end
correlationsLeave8Out = correlationsLeave8Out';

%% 
%save('pacificIndicesLassoWeights.mat', 'BmatLeave2Out', 'BmatLeave4Out', ...
%'BmatLeave8Out', 'correlationsLeave2Out', 'correlationsLeave4Out', 'correlationsLeave8Out')