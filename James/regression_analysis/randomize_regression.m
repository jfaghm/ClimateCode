%randomize the hurricane counts and check robustness of model
clear 
close all
load('regression_model_sst_data','pacific_indices_mar_oct');
load('regression_model_sst_data','pac_pcs_aug_oct');
load asoHurricaneStats
predictors = [pacific_indices_mar_oct pac_pcs_aug_oct];
num_iter = 100;
lambda = 0.1;
leave_k_out = 8;
[W,~] = lasso(predictors,aso_tcs,'Lambda',lambda);
real_cc = corr(predictors * W,aso_tcs);

[~, ~, pred_y, mm] = lassoCrossValidation(predictors, aso_tcs ,leave_k_out,lambda);
real_xv_cc = corr(pred_y,aso_tcs);

parfor i=1:num_iter
    rand_ind = randperm(32);
    rand_tcs(:,i) = aso_tcs(rand_ind);
    [B{i}, FitInfo{i}] = lasso(predictors, rand_tcs(:,i),'Lambda',lambda);
    yhat{i} = predictors * B{i};
    no_x_val_corr(i) = corr(yhat{i},rand_tcs(:,i));  
    [BB,FF,x_val_y_hat, mse{i}] = lassoCrossValidation(predictors, rand_tcs(:,i) ,leave_k_out,lambda);
    rand_cc(i) = corr(x_val_y_hat,rand_tcs(:,i));
end

figure
subplot(2,1,1)
hist(no_x_val_corr);
hold on
vline(real_cc);
title(['Leave ' num2str(leave_k_out) ' out Null distribution for no-cross validation randomization - lambda = ' num2str(lambda) ' N = ' num2str(num_iter) ' random runs']);
hold off

subplot(2,1,2)
hist(rand_cc)
hold on
vline(real_xv_cc);
title(['Leave ' num2str(leave_k_out) ' out Null distribution for cross validation randomization - lambda = ' num2str(lambda) ' N = ' num2str(num_iter) ' random runs']);
hold off







