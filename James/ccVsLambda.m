clear
load('/project/expeditions/ClimateCodeMatFiles/regression_model_sst_data.mat', 'pacific_indices_mar_oct');
load('/project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat', 'aso_tcs');

lambdas = 0:0.01:1;


for i = 1:length(lambdas)
   ypred = lassoCrossValWithLambda(pacific_indices_mar_oct, aso_tcs, 8, lambdas(i));
   cc(i) = corr(ypred, aso_tcs);
   
end
plot(lambdas, cc)
