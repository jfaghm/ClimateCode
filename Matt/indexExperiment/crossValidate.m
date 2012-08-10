function [YVals, actual, cc] = crossValidate(indices, target, k, varType, indexType)
%Performs cross validation using the multivariate linear regression
%function.
%   Indices should be a matrix where each column is one of the indices that
%   we have created.  Target should be one of the hurricane statstics that
%   we are trying to correlate against

c = cvpartition(length(target), 'kfold', k);
addpath('../') %for fig.m
YVals = [];
actual = [];
if any(isnan(indices))
    disp(['i < j, returning', num2str(indices')])
    cc = 0;
    return
end
parfor i = 1:k
    mask = training(c, i);
    
    mdl = LinearModel.fit(indices(mask, :), target(mask)); %#ok<PFBNS>
    Y = predict(mdl, indices(~mask, :));
    YVals = [YVals; Y];
    actual = [actual; target(~mask)]; 
end
if nargin > 3
    plotCrossVal(YVals, actual, varType, indexType);
end
cc = corr(YVals, actual);
end


function[] = plotCrossVal(yVals, actuals, t, indexType)
    fig(figure(1), 'units', 'inches', 'width', 9.5, 'height', 8)
    years = 1979:2010;
    %bar(years, [yVals, actuals]);
    plot(years, yVals, years, actuals);
    legend('Predictions', 'Actual');
    c = corr(yVals, actuals);
    title(['Cross Validation ' indexType ' correlation = ' num2str(c) ' (' t ')']);
    ylabel(t);
    xlabel('Year');
    print('-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/', ...
        'indexExperiment/results/comboIndex/crossValidationPlots/' indexType t ...
        'crossValidationCorrelations.pdf']);
end