%randomize the hurricane counts and check robustness of model
clear 
close all

if matlabpool('size') == 0
    matlabpool open
end

load('regression_model_sst_data','pacific_indices_mar_oct');
load('regression_model_sst_data','pac_pcs_aug_oct');
load asoHurricaneStats
predictors = [pacific_indices_mar_oct];
num_iter = 1000;
lambda = 0;
leave_k_out = 8;
[W,f] = lasso(predictors,aso_tcs,'Lambda',lambda);
real_cc = corr(predictors * W + f.Intercept,aso_tcs);


%% 
pred = linearFitCrossVal(predictors, aso_tcs, leave_k_out);
real_xv_cc_linear_fit = corr(pred,aso_tcs);

parfor i=1:num_iter
    rand_ind = randperm(32);
    rand_tcs(:,i) = aso_tcs(rand_ind);
    
    x_val_y_hat_linear_fit = linearFitCrossVal(predictors, rand_tcs(:, i), leave_k_out);
    ccLinearfit(i) = corr(x_val_y_hat_linear_fit,rand_tcs(:,i));
end

%% 

mdl = LinearModel.fit(predictors, aso_tcs);
ypred = predict(mdl, predictors);
real_cc_linear_fit = corr(ypred, aso_tcs);

parfor i = 1:num_iter
   mdl = LinearModel.fit(predictors, rand_tcs(:, i));
   ypred = predict(mdl, predictors);
   ccLinearFitNoXVal(i) = corr(ypred, rand_tcs(:, i));
end

%% 
[~, ~, pred_y, mm] = lassoCrossValidation(predictors, aso_tcs ,leave_k_out,lambda, true);
real_xv_cc = corr(pred_y,aso_tcs);
parfor i=1:num_iter
    %rand_ind = randperm(32);
    %rand_tcs(:,i) = aso_tcs(rand_ind);
    [B{i}, FitInfo{i}] = lasso(predictors, rand_tcs(:,i),'Lambda',lambda);
    yhat{i} = predictors * B{i} + FitInfo{i}.Intercept;
    no_x_val_corr(i) = corr(yhat{i},rand_tcs(:,i));  
    [BB{i},FF,x_val_y_hat{i}, mse{i}] = lassoCrossValidation(predictors, rand_tcs(:,i) ,leave_k_out,lambda, true);
    cc(i) = corr(x_val_y_hat{i},rand_tcs(:,i));
end

%% 

numCols = 2;

figure
subplot(2,numCols,1)
hist(no_x_val_corr);
hold on
vline(real_cc);
title(['No-cross validation randomization - lambda = ' num2str(lambda) ' N = ' num2str(num_iter) ' random runs']);
hold off

subplot(2,numCols,2)
hist(cc)
hold on
vline(real_xv_cc);
title(['Leave ' num2str(leave_k_out) ' out cross validation randomization - lambda = ' num2str(lambda) ' N = ' num2str(num_iter) ' random runs']);
hold off


subplot(2, 2, 3)
hist(ccLinearFitNoXVal)
hold on
vline(real_cc_linear_fit);
title(['No-cross validation randomization - linear fit model']);
hold off

subplot(2, 2, 4);
hist(ccLinearfit);
hold on
vline(real_xv_cc_linear_fit);
title(['Leave ' num2str(leave_k_out) ' out Cross validation randomization - linear fit model']);
















































	

	
	

	

	
	


