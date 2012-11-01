function [ypred, model, cc, mse, Bmat] = lassoCrossVal(predictors, target, k)
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
   options = statset('UseParallel', 'always');
   [B, fitInfo] = lasso(predictors(train, :), target(train), 'Options', options);
   ypred(i:i+k-1, 1) = predictors(test, :) * B(:, fitInfo.MSE == min(fitInfo.MSE));
   actuals(i:i+k-1, 1) = target(i:i+k-1);
   model(:, iteration) = B(:, fitInfo.MSE == min(fitInfo.MSE));
   
   mse(iteration, :) = fitInfo.MSE(fitInfo.MSE == min(fitInfo.MSE));
   y = actuals(i:i+k-1, 1);
   yHat = ypred(i:i+k-1, 1);
   mse(iteration, :) = mean((y - yHat).^2);
   
   Bmat{iteration} = B;
   
   iteration = iteration+1;
end
cc = corr(ypred, actuals);

end

function n = closestVal(A, x)
    [~,n] = min(abs(A-x));
end
