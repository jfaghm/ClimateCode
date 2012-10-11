function [ypred, model, cc, mse] = lassoCrossVal(predictors, target, k)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

iteration = 1;
model = zeros(size(predictors, 2), floor(length(target)/k));
mse = zeros(floor(length(target)/k), 1);
for i = 1:k:length(target)
   if i+k-1 > length(target)
       break
   end
   test = false(length(target) - mod(length(target), k), 1);
   test(i:i+k-1) = 1;
   train = ~test;
   [B, fitInfo] = lasso(predictors(train, :), target(train), 'NumLambda', 51);
   ypred(i:i+k-1, 1) = predictors(test, :) * B(:, find(min(fitInfo.MSE)));
   actuals(i:i+k-1, 1) = target(i:i+k-1);
   model(:, iteration) = B(:, find(min(fitInfo.MSE)));
   
   mse(iteration, :) = fitInfo.MSE(floor(length(fitInfo.MSE)/2));
   
   iteration = iteration+1;
end
cc = corr(ypred, actuals);

end

