function [cc, ypred, model, bigModel] = atlanticSSTLassoScript(boxValues)
[cc(1), ypred(:, 1), model(:, 1)] = atlanticSSTLassoScriptHelper(boxValues, 1, 'Aug-OctBestSSTAnomalieBoxesWithPacific');
[cc(2), ypred(:, 2), model(:, 2)] = atlanticSSTLassoScriptHelper(boxValues, 2, 'May-JulBestSSTAnomalieBoxesWithPacific');
[cc(3), ypred(:, 3), model(:, 3)]= atlanticSSTLassoScriptHelper(boxValues, 3, 'Aug-OctBestRelativeSSTBoxesWithPacific');
[cc(4), ypred(:, 4), model(:, 4)] = atlanticSSTLassoScriptHelper(boxValues, 4, 'May-JulBestRelativeSSTBoxesWithPacific');
[cc(5), ypred(:, 5), model(:, 5)] = atlanticSSTLassoScriptHelper(boxValues, 5, 'Aug-OctBestGPIBoxesWithPacific');
[cc(6), ypred(:, 6), model(:, 6)] = atlanticSSTLassoScriptHelper(boxValues, 6, 'May-JulBestGPIBoxesWithPacific');
[cc(7), ypred(:, 7), bigModel] = atlanticSSTLassoScriptHelper(boxValues, [1, 2, 3, 4, 5, 6], 'AllBoxesAllMonthRangesWithPacific');

end
function [cc, ypred, model] = atlanticSSTLassoScriptHelper(boxValues, n, boxes)
load ../matFiles/asoHurricaneStats.mat
indices = getPacificIndices();
for j = 1:length(n)
    switch n(j)
        case 1
            indices = [indices, boxValues.augOctBestSSTAnomalyValues];
        case 2
            indices = [indices, boxValues.mayJulBestSSTAnomalyBoxValues];
        case 3
            indices = [indices, boxValues.augOctBestRelativeSSTValues];
        case 4
            indices = [indices, boxValues.mayJulBestRelativeSSTBoxValues];
        case 5
            indices = [indices, boxValues.augOctBestGPIBoxValues];
        case 6
            indices = [indices, boxValues.mayJulBestGPIBoxValues];
    end

end
tic
[B, fitInfo] = lasso(indices, aso_tcs);
numVars = 10;
toc
for i = 1:size(B, 2)
   if numelements(find(B(:, i) ~= 0)) <= numVars
       indices = indices(:, B(:, i) ~= 0);
       model = B(:, i);
       break;
   end
end

[ypred, ~, cc, mse] = lassoCrossVal(indices, aso_tcs, 4, .5);
nonzero = getNonZeroElements(B);
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
startMonth = 3;
sstMaxLon = buildIndexVariations(1, startMonth, 10);
sstBoxPress = buildIndexVariations(36, startMonth, 10);
sstBoxOLR = buildIndexVariations(37, startMonth, 10);
minPressureLon = buildIndexVariations(38, startMonth, 10);
sstLonDiff = buildIndexVariations(39, startMonth, 10);

indices = [sstMaxLon, sstBoxPress, sstBoxOLR, minPressureLon, sstLonDiff];

end



