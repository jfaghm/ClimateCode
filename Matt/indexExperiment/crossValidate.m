function [YVals, actual] = crossValidate(indices, target, k)
%Performs cross validation using the multivariate linear regression
%function.
%   Indices should be a matrix where each column is one of the indices that
%   we have created.  Target should be one of the hurricane statstics that
%   we are trying to correlate against

c = cvpartition(length(target), 'kfold', k);

YVals = [];
actual = [];
parfor i = 1:k
    mask = training(c, i);
    mdl = LinearModel.fit(indices(mask, :), target(mask)); %#ok<PFBNS>
    Y = feval(mdl, indices(~mask, :));
        
    YVals = [YVals; Y];
    actual = [actual; target(~mask)]; 
    
end


end
