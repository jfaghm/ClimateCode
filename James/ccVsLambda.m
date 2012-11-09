clear
addpath('/project/expeditions/lem/ClimateCode/Matt/')
load('/project/expeditions/ClimateCodeMatFiles/pacific_indices_mar_oct.mat')
load('/project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat', 'aso_tcs');

lambdas = 0:0.2:2;

leave_k_out = 8;
predictors = pacific_indices_mar_oct;
trials = 1000;

for i = 1:length(lambdas)
    lambda = lambdas(i);
    [B, f] = lasso(predictors, aso_tcs, 'Lambda', lambda);
    real_cc(i) = corr(predictors * B + f.Intercept, aso_tcs);
    [~, ~, pred_y] = lassoCrossValidation(predictors, aso_tcs ,leave_k_out,lambda, true);
    real_xv_cc(i) = corr(pred_y,aso_tcs);
    
    parfor j = 1:trials
        target = aso_tcs(randperm(32));
        
        [B, f] = lasso(predictors, target, 'Lambda', lambda);
        cc(i, j) = corr(predictors * B + f.Intercept, target);
        
        [~,~,pred] = lassoCrossValidation(predictors, aso_tcs, leave_k_out, lambda, true);
        xv_cc(i, j) = corr(pred, target);
    end
end

for i = 1:length(lambdas)
    subplot(2, 1, 1);
    hist(cc(i, :));
    hold on
    vline(real_cc(i));
    hold off
    title(['Randomized Lasso Regression Lambda = ' num2str(lambdas(i))]);
    
    subplot(2, 1, 2);
    hist(xv_cc(i, :));
    hold on
    vline(real_xv_cc(i));
    hold off
    title(['Randomized Lass Cross Validation, Lambda = ' num2str(lambdas(i)) ...
        ', Leave ' num2str(leave_k_out) ' Out']);
    saveas(gcf, ['histograms/leave' num2str(leave_k_out) 'Out'/histogramLambda' num2str(lambdas(i)) '.pdf'], 'pdf');
end


%% 
parfor i = 1:length(lambdas)
   [ypred, ~, B{i}] = lassoCrossValWithLambda(pacific_indices_mar_oct, aso_tcs, 8, lambdas(i));
   cc(i) = corr(ypred, aso_tcs);
   
end
plot(lambdas, cc)


