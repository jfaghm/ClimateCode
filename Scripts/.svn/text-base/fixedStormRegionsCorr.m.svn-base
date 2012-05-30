
% Load the storm data
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
storms = condensedHurDat(:, [ 1 2 6 7 ]);

% The location to save the finished heat maps to
saveDir = '/project/expeditions/haasken/matlab/OptimizeCorr/FixedStormRegions/';

startYear = 1982;
endYear = 2010;
numYears = endYear - startYear + 1;

regionNames = { 'ATL', 'TATL', 'CATL', 'GULF', 'ETATL' };

regionLatLims = [ 5 40; 5 20; 10 30; 15 30; 20 40 ];
regionLonLims = [ -100 0; -60 0; -82 -60; -98 -82; -82 0 ];
regionMonths = { 6:10, 6:10, 6:10, 6:10, 6:10 };

numRegions = length(regionNames);

regionStormCounts = zeros(numRegions, numYears);

% Get the storm counts for each region
fprintf('Getting the storm counts for each region ... ')
for r = 1:numRegions
    
    % Get the storm counts for that region and save them
    regionStormCounts(r, :) = countStorms(storms, startYear, endYear, regionMonths{r}, regionLatLims(r, :), regionLonLims(r, :));
    
end
fprintf('finished.\n')

% Set up the sst box limits

sstBoxSize = 10;

sstLims.step = 1;
sstLims.minWidth = sstBoxSize;
sstLims.maxWidth = sstBoxSize;
sstLims.minHeight = sstBoxSize;
sstLims.maxHeight = sstBoxSize;
sstLims.north = 45;
sstLims.south = -5;
sstLims.west = -100;
sstLims.east = 0;
sstLims.startYear = 1982;
sstLims.endYear = 2010;
sstLims.months = 6:10;

% Load the preferred SST data set
load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSST.mat')

% Get the SST for every possible 10x10 box in the entire atlantic basin
fprintf('Getting the SST for every possible box ... ')
allBoxSST = getAllBoxSST(sstLims, reynoldsSST, reynoldsDates, rGridInfo);
fprintf('finished.\n')

actualHeatMaps = zeros(180, 360, numRegions);

% Create and plot the heat map for each region
mapInfo.colorLimits = [ -0.5, 0.8 ];
mapInfo.latLims = [ -20 50 ];
mapInfo.lonLims = [ -110 20 ];

fprintf('Creating and plotting each region heat map ... ')
for r = 1:numRegions
    
    gridInfo = struct( 'northLimit', 89.5, 'westLimit', -179.5, 'latStep', 1, 'lonStep', 1 );
    
    allCorrelations = rowCorr(regionStormCounts(r, :), allBoxSST(:, 5:end));
    
    currentHeatMap = createHeatMap( allBoxSST, [ regionLatLims(r, :) regionLonLims(r, :) regionStormCounts(r, :) ], allCorrelations, gridInfo );
    actualHeatMaps(:, :, r) = currentHeatMap;
    
    mapInfo.figureTitle = [ 'Heat map of corelation between SST and storm counts in ', regionNames{r} ];
    
    plotHeatMaps(currentHeatMap, mapInfo, true, [ saveDir regionNames{r} '/' ], 1, false)
    
    save([saveDir regionNames{r} '/heatMap.mat'], 'currentHeatMap')
   
    f = figure; hold on
    plot(1982:2010, regionStormCounts(r, :))
    title( ['Storm Counts for Region ' regionNames{r}] )
    xlabel('Year')
    ylabel('Annual Storm Counts')
    saveas(f, [ 'stormCounts' regionNames{r} '.png' ])
    
    [~, corrSSTBox] = max(allCorrelations);
    bestSST = allBoxSST(corrSSTBox, 5:end);
    scaledSST = (bestSST-mean(bestSST))/std(bestSST) + mean(regionStormCounts(r, :));
    
    plot(1982:2010, scaledSST, 'Color', 'red')
    ylabel('Annual Storm Counts and Mean SST')
    saveas(f, [ 'stormCountsSST' regionNames{r} '.png' ])
    close(f)
    
end
fprintf('finished.\n')
