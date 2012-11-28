function [Bmat, fitInfo, ypred, fold_mse] = ...
    lassoCrossValWithLambda(predictors, target, k, lambda)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

iteration = 1;
for i = 1:k:length(target)
   if i+k-1 > length(target)
       break
   end
   test = false(length(target) - mod(length(target), k), 1);
   test(i:i+k-1) = 1;
   train = ~test;
   options = statset('UseParallel', 'always');
   [B, fitInfo] = lasso(predictors(train, :), target(train), 'Options', options, 'Lambda', lambda);
   %assert(fitInfo.DF > 0, ['Lambda = ' num2str(lambda) ' is too high, all predictors dropped.'])
   
   ypred(i:i+k-1, 1) = predictors(test, :) * B + fitInfo.Intercept;
   actuals(i:i+k-1, 1) = target(i:i+k-1);   

   fold_mse(i) = sum((target(test) - ypred(i:i+k-1) ).^2);
   
   Bmat{iteration} = B;
   lambdaVals{iteration} = fitInfo.Lambda;
   iteration = iteration+1;
end

end

