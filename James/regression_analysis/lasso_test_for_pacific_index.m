%verify combo index

% load('regression_model_sst_data','pacific_indices_mar_oct');
% load('regression_model_sst_data','atl_pcs_aug_oct');
% load('regression_model_sst_data','pac_pcs_aug_oct');
% load('augOctJointBasinsEOFPCs.mat');
%joint_pcs_aug_oct = PCs;
%load asoHurricaneStats

%% run on raw data
predictors = pacific_indices_mar_oct(:, 2:end);
[B, FitInfo] = lasso(predictors,  aso_tcs, 'CV', 10);
best_weights = B(:, FitInfo.IndexMinMSE);
yhat = predictors * best_weights;
raw_corr = corr(yhat, aso_tcs);
for i=1:length(FitInfo.Lambda)
    w(:,i) = B(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end
%[ypred{i, j}, model{i, j}, cc(i, j), mse{i, j}] = lassoCrossVal(predictors,aso_tcs,8)
%% run on z-scores
predictors = zscore(pacific_indices_mar_oct(:, 2:end));
[B1, FitInfo1] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights1 = B1(:, FitInfo1.IndexMinMSE);
yhat1 = predictors * best_weights1;
zscore_corr = corr(yhat1, aso_tcs);

%% run on all
predictors= [pacific_indices_mar_oct zscore(pacific_indices_mar_oct)];
[B2, FitInfo2] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights2 = B2(:, FitInfo2.Index1SE);
yhat2 = predictors * best_weights2;
all_corr = corr(yhat2, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo2.Lambda)
    w(:,i) = B2(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end

%% run on all + 5 Pacific PCs
predictors = [pacific_indices_mar_oct zscore(pacific_indices_mar_oct) pac_pcs_aug_oct];
[B3, FitInfo3] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights3 = B3(:, FitInfo3.IndexMinMSE);
yhat3 = predictors * best_weights3;
pcs_corr = corr(yhat3, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo3.Lambda)
    w(:,i) = B3(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end

%% pacific only 
predictors = [pac_pcs_aug_oct];
[B4, FitInfo4] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights4 = B4(:, FitInfo4.IndexMinMSE);
yhat4 = predictors * best_weights4;
pac_corr = corr(yhat4, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo4.Lambda)
    w(:,i) = B4(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end

%% all PCs 
predictors = [atl_pcs_aug_oct pac_pcs_aug_oct joint_pcs_aug_oct];
[B5, FitInfo5] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights5 = B5(:, FitInfo5.IndexMinMSE);
yhat5 = predictors * best_weights5;
pcs_corr = corr(yhat5, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo5.Lambda)
    w(:,i) = B5(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end

%% final version: all pacific indeces, PDO, 1st, 2nd, and NINO
predictors = [pacific_indices_mar_oct pac_pcs_aug_oct nino'];
[B6, FitInfo6] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights6 = B6(:, FitInfo6.IndexMinMSE);
yhat6 = predictors * best_weights6;
pcs_corr = corr(yhat6, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo6.Lambda)
    w(:,i) = B6(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end

%% test the impact of SST distance
predictors = [pacific_indices_mar_oct(:,1:end-1)];
[B7, FitInfo7] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights7 = B7(:, FitInfo7.IndexMinMSE);
yhat7 = predictors * best_weights7;
pcs_corr = corr(yhat7, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo7.Lambda)
    w(:,i) = B7(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end


%% use SST variables only!
predictors = [pacific_indices_mar_oct(:,1) pacific_indices_mar_oct(:,5) pac_pcs_aug_oct(:,1:2) atl_pcs_aug_oct(:,1:2) joint_pcs_aug_oct(:,1:2)];
[B8, FitInfo8] = lasso(predictors, aso_tcs, 'CV', 10);
best_weights8 = B8(:, FitInfo8.IndexMinMSE);
yhat8 = predictors * best_weights8;
pcs_corr = corr(yhat8, aso_tcs);
clear w yhat cc
for i=1:length(FitInfo8.Lambda)
    w(:,i) = B8(:,i);
    yhat(:,i) = predictors * w(:,i);
    cc(i) = corr(yhat(:,i),aso_tcs);
end
