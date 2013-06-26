% test the performance of up to 5 PCs to predict TCs activity

k = [1,2,4,8];
useVars = 1:5;
sst_predictors = PCs;
for i = 1:length(k)
    for j = 1:length(useVars)
        [ypred{i, j}, model{i, j}, cc(i, j), mse{i, j}] = lassoCrossVal(sst_predictors(:,1:j), aso_tcs, k(i), useVars(j));
    end
end