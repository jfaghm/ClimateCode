function [] = atlanticSSTLassoScript(vars)
%atlanticSSTLassoScriptHelper(vars, 1, 'Aug-OctBestSSTAnomalieBoxes');
%atlanticSSTLassoScriptHelper(vars, 2, 'May-JulBestSSTAnomalieBoxes');
%atlanticSSTLassoScriptHelper(vars, 3, 'Aug-OctBestRelativeSSTBoxes');
atlanticSSTLassoScriptHelper(vars, 4, 'May-JulBestRelativeSSTBoxes');
atlanticSSTLassoScriptHelper(vars, 5, 'Aug-OctBestGPIBoxes');
atlanticSSTLassoScriptHelper(vars, 6, 'May-JulBestGPIBoxes');
atlanticSSTLassoScriptHelper(vars, [1, 2, 3, 4, 5, 6], 'AllBoxesAllMonthRanges');

end
function [] = atlanticSSTLassoScriptHelper(vars, n, boxes)
load ../matFiles/asoHurricaneStats.mat
indices = [];
for j = 1:length(n)
switch n(j)
    case 1
%-------------------------Aug-OctBestSST Anomalies------------------------
load /project/expeditions/lem/ClimateCode/Matt/matFiles/augOctBestSSTAnomalyBoxes.mat;
load ../matFiles/flippedSSTAnomalies.mat
lon = vars.sstLon;
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(sst, 8, 10, vars.sstLat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end
    case 2
%------------------------May-Jul Best SST Anomalies-----------------------
clear nonzero B fitInfo sortedAtlCorr
load /project/expeditions/lem/ClimateCode/Matt/matFiles/mayJulBestSSTAnomalyBoxes.mat;
load ../matFiles/flippedSSTAnomalies.mat
lon = vars.sstLon;
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(sst, 5, 7, vars.sstLat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end
%---------------------Aug-Oct Best Relative SST Boxes---------------------
    case 3
clear nonzero B fitInfo sortedAtlCorr 
load /project/expeditions/lem/ClimateCode/Matt/matFiles/augOctBestRelativeSSTBoxes
load ../matFiles/tropicalSSTDeviations.mat
lon = vars.sstLon;
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(sstDeviations, 8, 10, vars.sstLat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end

%--------------------May-Jul Best Relative SST Boxes----------------------
    case 4
clear nonzero B fitInfo sortedAtlCorr
load /project/expeditions/lem/ClimateCode/Matt/matFiles/mayJulBestRelativeSSTBoxes
load ../matFiles/tropicalSSTDeviations.mat
lon = vars.sstLon;
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(sstDeviations, 5, 7, vars.sstLat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end
  
%-----------------Aug-Oct Best GPI Boxes----------------------------------
    case 5
clear nonzero B fitInfo sortedAtlCorr
load /project/expeditions/lem/ClimateCode/Matt/matFiles/augOctBestGPIBoxes.mat
load ../matFiles/GPIData.mat
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(gpiMat, 8, 10, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end
  
%-----------------May-Jul Best GPI Boxes-----------------------------------
    case 6
clear nonzero B fitInfo sortedAtlCorr
load /project/expeditions/lem/ClimateCode/Matt/matFiles/mayJulBestGPIBoxes.mat
load ../matFiles/GPIData.mat
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(gpiMat, 5, 7, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end

end
end

[B, fitInfo] = lasso(indices, aso_tcs);
nonzero = getNonZeroElements(B);
plotFitInfo(fitInfo.Lambda, nonzero, fitInfo.MSE, boxes);

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



