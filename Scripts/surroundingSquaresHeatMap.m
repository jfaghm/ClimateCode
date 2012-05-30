% This script gets the heatmaps for the scenario in which each sst box can
% correlate only with its surrounding square storm boxes.

possibleStormBoxSizes = 10:10:80;
numStormBoxes = length(possibleStormBoxSizes);

sstBoxSize = 10;

sstLims.step = 1;
sstLims.minWidth = sstBoxSize;
sstLims.maxWidth = sstBoxSize;
sstLims.minHeight = sstBoxSize;
sstLims.maxHeight = sstBoxSize;
sstLims.north = 35;
sstLims.south = -5;
sstLims.west = -100;
sstLims.east = 0;
sstLims.startYear = 1982;
sstLims.endYear = 2010;
sstLims.months = 6:10;


numYears = sstLims.endYear - sstLims.startYear + 1;

load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
storms = condensedHurDat(:, [1 2 6 7]);

stormsToPlot = storms( storms(:, 1) >= sstLims.startYear & storms(:, 1) <= sstLims.endYear ...
    & ismember( storms(:, 2), sstLims.months ), 3:4 );

load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSST.mat')
allBoxSST = getAllBoxSST(sstLims, reynoldsSST, reynoldsDates, rGridInfo);

numSSTBoxes = size(allBoxSST, 1);

surroundingBoxes = zeros(numSSTBoxes, 4 + numYears, numStormBoxes);

% Getting storm counts of surrounding boxes of each size
fprintf('Getting storm counts of surrounding boxes of each size ... ')
for i = 1:numSSTBoxes
    
    sstBoxLats = allBoxSST(i, 1:2);
    sstBoxLons = allBoxSST(i, 3:4);
    [midLat, midLon] = getMidLatLon(sstBoxLats, sstBoxLons);
    
    stormBoxNumber = 0;
    for j = possibleStormBoxSizes
        
        stormBoxNumber = stormBoxNumber + 1;
        boxRadius = j/2;
        
        stormBoxLats = [ midLat - boxRadius, midLat + boxRadius ];
        stormBoxWest = mod( midLon - boxRadius + 180, 360 ) - 180;
        stormBoxEast = mod( midLon + boxRadius + 180, 360 ) - 180;
        
        stormBoxLons = [stormBoxWest stormBoxEast];
        
        stormCounts = countStorms(storms, sstLims.startYear, sstLims.endYear, sstLims.months, stormBoxLats, stormBoxLons);
        
        surroundingBoxes(i, :, stormBoxNumber) = [stormBoxLats, stormBoxLons, stormCounts];
        
    end
    
end
fprintf('finished.\n')

actualHeatMaps = NaN(180, 360, numStormBoxes);
gridInfo.northLimit = 89.5; gridInfo.westLimit = -179.5; gridInfo.latStep = 1; gridInfo.lonStep = 1;

% Computing actual correlation heat maps
fprintf('Computing actual correlation heat maps ... ')
for i = 1:numStormBoxes
    for j = 1:numSSTBoxes
        
        correlation = rowCorr(allBoxSST(j, 5:end), surroundingBoxes(j, 5:end, i));
        
        [row, col] = getMidRowCol(allBoxSST(j, 1:2), allBoxSST(j, 3:4), gridInfo);
        
        actualHeatMaps(row, col, i) = correlation;
        
    end
end
fprintf('finished.\n')

save('SquareBoxes/actualHeatMaps.mat', 'actualHeatMaps')

% Plot and save the actual heat maps for each box size
load('/project/expeditions/haasken/matlab/OptimizeCorr/atlanticMapInfo.mat')
mapInfo.figureTitle = 'Square SST boxes surrounded by square storm boxes (Actual Results)';

plotHeatMaps(actualHeatMaps, mapInfo, true, 'SquareBoxes/Actual/', [], false, stormsToPlot)

%% Begin randomized trials

numTrials = 1000;
randomHeatMaps = cell(1, numStormBoxes);
mapInfo.figureTitle = 'Square SST boxes surrounded by square storm boxes (Random Results)';

% Iterating through each size of surrounding storm boxes
fprintf('Beginning random trials ... ')
parfor k = 1:numStormBoxes
    
    stormBoxSize = possibleStormBoxSizes(k);
    
    randomHeatMaps{k} = NaN(180, 360, numTrials);
    
    annualCounts = surroundingBoxes(:, 5:end, k);
    
    for i = 1:numTrials
        
        randomOrdering = randperm(numYears);
        randomCounts = annualCounts(:, randomOrdering);
        
        for j = 1:numSSTBoxes
            
            correlation = rowCorr(allBoxSST(j, 5:end), randomCounts(j, :));
            
            [row, col] = getMidRowCol(allBoxSST(j, 1:2), allBoxSST(j, 3:4), gridInfo);
            
            randomHeatMaps{k}(row, col, i) = correlation;
            
        end
    end
end
fprintf('finished.\n')

fprintf('Plotting and saving random heat maps ... ')
for k = 1:numStormBoxes
    
    currentRandomHeatMaps = randomHeatMaps{k};
    
    eachMapMax = max( max( currentRandomHeatMaps, [], 1) , [], 2);
    [~, sortIndices] = sort(eachMapMax, 'descend');
    currentRandomHeatMaps = currentRandomHeatMaps(:, :, sortIndices);
    
    plotHeatMaps(currentRandomHeatMaps, mapInfo, true, sprintf('SquareBoxes/Random%d/', possibleStormBoxSizes(k)), 1:10, false, stormsToPlot)
    
    save(sprintf('SquareBoxes/randomHeatMaps%d.mat', possibleStormBoxSizes(k)), 'currentRandomHeatMaps')
    
end
fprintf('finished.\n')
