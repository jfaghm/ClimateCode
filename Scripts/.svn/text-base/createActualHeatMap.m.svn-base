% Create a real non-randomized heatmap

startYear = 1982;
endYear = 2010;
months = 6:10;
region = 'atlantic';

stormLims.step = 1;
stormLims.minWidth = 15;
stormLims.maxWidth = 30;
stormLims.minHeight = 10;
stormLims.maxHeight = 25;
stormLims.north = 35;
stormLims.south = -5;
stormLims.west = -90;
stormLims.east = 0;

sstLims.step = 1;
sstLims.minWidth = 10;
sstLims.maxWidth = 10;
sstLims.minHeight = 10;
sstLims.maxHeight = 10;
sstLims.north = 35;
sstLims.south = -5;
sstLims.west = -90;
sstLims.east = 0;

allBoxStorms = getAllBoxStormCounts(stormLims, startYear, endYear, months, region);

load('/project/expeditions/haasken/reynolds_monthly/reynoldsSST.mat')
allBoxSST = getAllBoxSSTParallel(sstLims, reynoldsSST, reynoldsDates, rGridInfo, startYear, endYear, months);
annualSST = allBoxSST(:, 5:end);

gridInfo.northLimit = 89.5; gridInfo.westLimit = -179.5; gridInfo.latStep = 1; gridInfo.lonStep = 1;
load('/project/expeditions/haasken/HadISST1/hadleyLandMask.mat')
landMask = hadleyLandMask;

fprintf('Begin getEncompassingMask.\n')
encStartTime = tic;
encMask = getEncompassingMask(allBoxStorms(:, 1:4), allBoxSST(:, 1:4));
encEndTime = toc(encStartTime);
fprintf('Finished getEncompassingMask in %.2f seconds.\n', encEndTime)

for minStormsPerYear = 1:7

    cleanMask = eliminateStormBoxes( allBoxStorms, minStormsPerYear );
    
    allBoxStorms = allBoxStorms(cleanMask, :);
    annualCounts = allBoxStorms(:, 5:end);
    encMask = encMask(cleanMask, :);
    
    allCorrelations = rowCorr(annualCounts, annualSST);
    
    allCorrelations(~encMask) = NaN;
    
    [ corrHeatMap, bestBoxes ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations, gridInfo );
    corrHeatMap(landMask) = NaN;
    
    lonInfo.start = -179.5; lonInfo.step = 1; lonInfo.end = 179.5;
    latInfo.start = 89.5; latInfo.step = -1; latInfo.end = -89.5;
    
    %plotBestBoxes(bestBoxes, 0, sprintf('realHeatMapWithBoxes%.2f', minStormsPerYear), [ -60 60 ], [ -120 10 ], corrHeatMap)
    
    %
    f = figure;
    axesm('MapProjection', 'pcarree', 'MapLatLimit', [-60 60], 'MapLonLimit', [-120 10], 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')
    
    geoshow(corrHeatMap(180:-1:1, :), [1 90 -180], 'DisplayType', 'texturemap')
    caxis( [ -0.5 0.8 ] )
    colorbar
    geoshow('landareas.shp', 'FaceColor', [0.5 0.7 0.5])
    
    title( sprintf('Heatmap of SST vs Annual Storm Counts - Max = %.4f, Min = %.4f', ...
        max(max(corrHeatMap)), min(min(corrHeatMap))), 'FontSize', 12)
    
    saveas(f, sprintf('realHeatMapMDRBig%d.png', minStormsPerYear) )
    
    %}
    
end
