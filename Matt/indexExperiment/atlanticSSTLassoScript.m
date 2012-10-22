function [cc, ypred, model, boxesUsed, vars, coefficients] = atlanticSSTLassoScript(boxValues)
%{
[cc(1), ypred(:, 1), model(:, 1), boxesUsed{1}, vars{1}, coefficients{1}]...
    = atlanticSSTLassoScriptHelper(boxValues, 1, 'Aug-OctBestSSTAnomalieBoxesWithPacific');
[cc(2), ypred(:, 2), model(:, 2), boxesUsed{2}, vars{2}, coefficients{2}]...
    = atlanticSSTLassoScriptHelper(boxValues, 2, 'May-JulBestSSTAnomalieBoxesWithPacific');
[cc(3), ypred(:, 3), model(:, 3), boxesUsed{3}, vars{3}, coefficients{3}]...
    = atlanticSSTLassoScriptHelper(boxValues, 3, 'Aug-OctBestRelativeSSTBoxesWithPacific');
[cc(4), ypred(:, 4), model(:, 4), boxesUsed{4}, vars{4}, coefficients{4}]...
    = atlanticSSTLassoScriptHelper(boxValues, 4, 'May-JulBestRelativeSSTBoxesWithPacific');
[cc(5), ypred(:, 5), model(:, 5), boxesUsed{5}, vars{5}, coefficients{5}] = ...
    atlanticSSTLassoScriptHelper(boxValues, 5, 'Aug-OctBestGPIBoxesWithPacific');
[cc(6), ypred(:, 6), model(:, 6), boxesUsed{6}, vars{6}, coefficients{6}]...
    = atlanticSSTLassoScriptHelper(boxValues, 6, 'May-JulBestGPIBoxesWithPacific');
%}
[cc(7), ypred(:, 7), model(:, 7), boxesUsed{7}, vars{7}, coefficients{7}]...
    = atlanticSSTLassoScriptHelper(boxValues, [1, 2, 3, 4, 5, 6], 'AllBoxesAllMonthRangesWithPacific');
save('atlanticBoxCrossValResults5Predictors.mat', 'cc', 'boxesUsed', 'vars', 'coefficients');

end
function [cc, ypred, model, boxesUsed, vars, coefficients] = atlanticSSTLassoScriptHelper(boxValues, n, boxes)
addpath('/project/expeditions/ClimateCodeMatFiles/');
load asoHurricaneStats.mat
indices = getPacificIndices();
boxes = [];

for j = 1:length(n)
    switch n(j)
        case 1
            indices = [indices, boxValues.augOctBestSSTAnomalyValues(:, 6:end)'];
            boxes = [boxes, boxValues.augOctBestSSTAnomalyValues];
        case 2
            indices = [indices, boxValues.mayJulBestSSTAnomalyBoxValues(:, 6:end)'];
            boxes = [boxes, boxValues.mayJulBestSSTAnomalyBoxValues];
        case 3
            indices = [indices, boxValues.augOctBestRelativeSSTValues(:, 6:end)'];
            boxes = [boxes, boxValues.augOctBestRelativeSSTValues];
        case 4
            indices = [indices, boxValues.mayJulBestRelativeSSTBoxValues(:, 6:end)'];
            boxes = [boxes, boxValues.mayJulBestRelativeSSTBoxValues];
        case 5
            indices = [indices, boxValues.augOctBestGPIBoxValues(:,6:end)'];
            boxes = [boxes, boxValues.augOctBestGPIBoxValues];
        case 6
            indices = [indices, boxValues.mayJulBestGPIBoxValues(:,6:end)'];
            boxes = [boxes, boxValues.mayJulBestGPIBoxValues];
    end

end
tic
[B, fitInfo] = lasso(indices, aso_tcs);
numVars = 5;  %10, 5, 2, 1
leaveK = 4; %do 8 and 4
toc
for i = 1:size(B, 2)
   if numelements(find(B(:, i) ~= 0)) <= numVars
       indices = indices(:, B(:, i) ~= 0);
       model = B(:, i);
       break;
   end
end

[sortedCC, sortedIndices] = sort(abs(model));
vars = 1:length(model);
vars = vars(sortedIndices);

coefficients = sortedCC(sortedCC ~= 0);
vars = vars(sortedCC ~= 0);

i = model ~= 0;
boxesUsed = boxes(i(6:end), 2:5);

[ypred, ~, cc] = lassoCrossVal(indices, aso_tcs, leaveK, 0);

%plotFitInfo(fitInfo.Lambda, nonzero, fitInfo.MSE, boxes);
end

function nonzero = getNonZeroElements(B)
    nonzero = zeros(size(B, 2), 1);
    for i = 1:size(B, 2)
        nonzero(i) = numelements(find(B(:, i) ~= 0));
    end
end

function [] = plotFitInfo(lambda, nonzero, mse, boxes)
subplot(2, 1, 1);
plot(lambda, nonzero);
title(['Number of Predictors left in Model vs Lambda (' boxes ')']);
xlabel('Lambda Value');
ylabel('Number of predictors');
axis([-.1, max(lambda), 0, max(nonzero)]);

subplot(2, 1, 2);
plot(lambda, mse);
title('MSE vs Lambda');
xlabel('Lambda Value');
ylabel('MSE');
saveDir = ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/'...
    'results/paperDraft/EOFPrincipalComponents/PredictorsVsLambda/predictorsVsLambda'];
saveas(gcf, [saveDir boxes 'pdf'], 'pdf');
end

function indices = getPacificIndices()
startMonth = 8;
sstMaxLon = buildIndexVariations(1, startMonth, 10);
sstBoxPress = buildIndexVariations(36, startMonth, 10);
sstBoxOLR = buildIndexVariations(37, startMonth, 10);
minPressureLon = buildIndexVariations(38, startMonth, 10);
sstLonDiff = buildIndexVariations(39, startMonth, 10);

indices = [sstMaxLon, sstBoxPress, sstBoxOLR, minPressureLon, sstLonDiff];

end



