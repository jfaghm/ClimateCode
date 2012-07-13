function [YVals, actual] = crossValidate(indices, target, k)
%Performs cross validation using the multivariate linear regression
%function.
%   Indices should be a matrix where each column is one of the indices that
%   we have created.  Target should be one of the hurricane statstics that
%   we are trying to correlate against

c = cvpartition(length(target), 'kfold', k);

YVals = [];
actual = [];
for i = 1:k
    mask = training(c, i);
    trainingSet = indices(mask, :);
    beta = multiVariateRegress(trainingSet, target(mask));
    predictors = indices(~mask, :);
    Y = bsxfun(@times, predictors, beta(2:end)');
    Y = sum(Y, 2);
    Y = bsxfun(@plus, Y, beta(1));
    YVals = [YVals; Y]; %#ok<AGROW>
    actual = [actual; target(~mask)]; %#ok<AGROW>
end

end





