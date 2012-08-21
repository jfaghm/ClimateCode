function [cc, ypred, actuals] = kfoldCrossValidate(indices, target, k, ...
    varType, indexType)
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


for i = 1:k:length(target)
   if i+k-1 > length(target)
       break
   end
   test = false(length(target) - mod(length(target), k), 1);
   test(i:i+k-1) = 1;
   train = ~test;
   mdl = LinearModel.fit(indices(train), target(train), 'linear');
   ypred(i:i+k-1, 1) = predict(mdl, indices(test))';
   actuals(i:i+k-1, 1) = target(i:i+k-1);
end
ypred = reshape(ypred, length(target) - mod(length(target), k), []);
actuals = reshape(actuals, length(target) - mod(length(target), k), []);
cc = corr(ypred, actuals);

if nargin > 3
    plotCrossVal(ypred, actuals, varType, indexType, 1979:2010);
end

function[] = plotCrossVal(yVals, t, years)
    fig(figure(1), 'units', 'inches', 'width', 9.5, 'height', 8)
    plot(years, yVals, years, actuals);
    legend('Predictions', 'Actual');
    c = corr(yVals, actuals);
    %title(strcat('Cross Validation ', indexType, ' correlation = ', num2str(c), ' (', t, ')'));
    title(['Leave ' num2str(k) ' Out Cross Validation ' indexType ' correlation = ' ...
        num2str(c) '(' t ')']);
    ylabel(t);
    xlabel('Year');
    print(gcf, '-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/', ...
        'indexExperiment/results/comboIndex349/crossValidationPlots/leave'...
        num2str(k) 'Out' indexType t 'CrossValidationCorrelations.pdf']);
end


end




