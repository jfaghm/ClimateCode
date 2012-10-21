function [ypred, model, cc, mse] = lassoCrossVal(predictors, target, k, lambda)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
useVars = 10;
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
   options = statset('UseParallel', 'always');
   [B, fitInfo] = lasso(predictors(train, :), target(train), 'DFMax', useVars, 'Options', options);
   ypred(i:i+k-1, 1) = predictors(test, :) * B(:, closestVal(fitInfo.Lambda, lambda));
   actuals(i:i+k-1, 1) = target(i:i+k-1);
   model(:, iteration) = B(:, closestVal(fitInfo.Lambda, lambda));
   
   mse(iteration, :) = fitInfo.MSE(floor(length(fitInfo.MSE)/2));
   
   iteration = iteration+1;
end
cc = corr(ypred, actuals);

end

function n = closestVal(A, x)
    [~,n] = min(abs(A-x));
end
