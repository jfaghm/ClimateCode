function [cc, ypred, target] = kfoldCrossValidate(indices, target, k)
%This function performs k-fold cross validation, where we leave out k
%elements to put into the testing set and use the rest for the training
%set.  We train a linear regression model with the training set, and then
%predict with the test set.  At the end of the function we correlate these
%predictions with their actual values.
%
%--------------------Input-----------------------------------
%
%--->indices - the indices that we want to use to predict the target
%values.  Indices should be a matrix where each column is an individual
%index, and each row coresponds to year.  
%--->target - the values that we are trying to predict with the indices.
%--->k - number of elements to be put into the training set in each
%iteration
%
%-------------------Output-------------------------------------
%--->cc - correlation between predicted values and actual values
%--->ypred - predicted values
%--->target - target values that were originally provided as a parameter to
%the function.

    if mod(length(target), k) ~= 0
        error('incorrect number of folds provided');
    end
    for i = 1:k:length(target)
        test = logical(zeros(length(target), 1));
        test(i:i+k-1) = 1;
        train = ~test;
        mdl = LinearModel.fit(indices(train), target(train), 'linear');
        ypred(i:i+k-1, 1) = predict(mdl, indices(test))';
    end
    %ypred = reshape(ypred, 32, []);
    cc = corr(ypred, target);
    

end


