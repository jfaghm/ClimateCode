function [predictions] = predictForAllLambdasCrossVal(B, predictors, intercepts)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

folds = length(B);
k = 32/folds;

fold = 1;
for i = 1:k:32
    temp = B{fold};
    for j = 1:size(temp, 2)
        predictions(i:i+k-1, j) = predictors(i:i+k-1, :) * temp(:, j) + intercepts{fold}(j);
    end
    fold = fold+1;
end

end

