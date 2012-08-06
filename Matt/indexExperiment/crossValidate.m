function [YVals, actual] = crossValidate(indices, target, k, varType, indexType)
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
    
    mdl = LinearModel.stepwise(indices(mask, :), target(mask)); %#ok<PFBNS>
    Y = predict(mdl, indices(~mask, :));
    YVals = [YVals; Y];
    actual = [actual; target(~mask)]; 
end
if nargin > 3
    plotCrossVal(YVals, actual, varType, indexType);
end

end


function[] = plotCrossVal(yVals, actuals, t, indexType)
    years = 1979:2010;
    plot(years, yVals, years, actuals);
    legend('Predictions', 'Actual');
    c = corr(yVals, actuals);
    title(['Cross Validation ' indexType ' correlation = ' num2str(c) ' (' t ')']);
    ylabel(t);
    xlabel('Year');
    print('-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/', ...
        'indexExperiment/results/stepwiseCrossVal/' indexType t ...
        'crossValidationCorrelations.pdf']);
end