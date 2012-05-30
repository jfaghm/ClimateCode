% This script computes the trends of 10x10 boxes of data

addpath('../')

% Desired alpha for the p-val, 0.05 for 95% confidence
desiredAlpha = 0.05;

% Set up the 10x10 box limits for the entire Atlantic
dataLims = struct( 'north', 45, 'south', -20, 'west', -90, 'east', 10, 'step', 1, ...
    'width', 4, 'height', 4, 'startYear', 1970, 'endYear', 2010, 'months', 6:10 );

% Set up 2.5 degree grid info lats and lons
gridInfo.lats = [ 90:-2.5:-90 ];
gridInfo.lons = [ 0:2.5:180 -177.5:2.5:-2.5 ];
grid850 = gridInfo;
grid2m = gridInfo;

% Load the ncep 850 mbar air temp data
load('/project/expeditions/haasken/data/ncep_air_temp/airTemp850.mat')
air850 = airTemp; months850 = months;
clear airTemp gridInfo months

% Load the ncep 2m air temp data
load('/project/expeditions/haasken/data/ncep_air_temp/surfaceAirTemp.mat')
air2m = airTemp; months2m = months;

% Get the air temp means for every box described by dataLims
allBoxAir850 = getAllBoxData(air850, months850, grid850, dataLims, true);
allBoxAir2m = getAllBoxData(air2m, months2m, grid2m, dataLims, true);

% Put the different data into a cell array for iteration
boxData = { allBoxAir850, allBoxAir2m };
grids = { grid850, grid2m };
numDataSets = length(boxData);
% Names to save each map
saveNames = { 'airTemp850', 'airTemp2m' };
% Figure titles for each figure plotted
figureTitles = { 'Air Temp (850 mbar) ', 'AirTemp (2m) ' };

% Set up a cell array to store trends
trends = cell(1, numDataSets);
rsquareds = cell(1, numDataSets);
pvals = cell(1, numDataSets);

% Iterate through each type of data (sst, smallStormBoxes, ... )
for dataNum = 1:numDataSets
    
    % Grab the current data from cell array
    currentData = boxData{dataNum};
    
    % Get the trend, rsquare, and p-val for each time series
    [ m rsquare p ] = computeTrends( currentData(:, 5:end) );
    
    trends{dataNum} = m;
    rsquareds{dataNum} = rsquare;
    pvals{dataNum} = p;
    
    
end

trendGrids = cell(1, numDataSets);
rsquaredGrids = cell(1, numDataSets);
pvalGrids = cell(1, numDataSets);

for i = 1:numDataSets
    
    boxes = boxData{i}(:, 1:4);
    
    trendGrids{i} = gridBoxValues( trends{i}, boxes, grids{i});
    rsquaredGrids{i} = gridBoxValues( rsquareds{i}, boxes, grids{i} );
    pvalGrids{i} = gridBoxValues( pvals{i}, boxes, grids{i} );
    
    % Blank out the trends where pval > desiredAlpha
    trendGrids{i}(pvalGrids{i} > desiredAlpha) = NaN;
    
end


% Set up the mapInfo structure to plot maps of trends, pvals, and rsquared
mapInfo = struct( 'latLims', [ -20 50 ], 'lonLims', [ -130 20 ] );

% Create heat maps of each of the trend grids and coeff grids
trendMaps = plotHeatMaps( trendGrids, [ 1/2.5 90 0 ], mapInfo );
mapInfo.colorLims = [ -1 1 ];
rsquaredMaps = plotHeatMaps( rsquaredGrids, [ 1/2.5 90 0 ], mapInfo );
mapInfo.colorLims = 'auto';
pvalMaps = plotHeatMaps( pvalGrids, [ 1/2.5 90 0], mapInfo );

for i = 1:numDataSets
    
    %{
    if i == 1
        caxis( get(trendMaps(i), 'CurrentAxes'), [ -0.04 0.04 ] )
    end
    %}
    
    % Set the titles of each figure
    title( get( trendMaps(i), 'CurrentAxes' ), [ figureTitles{i} 'Trends' ] )
    title( get( rsquaredMaps(i), 'CurrentAxes' ), [ figureTitles{i} 'r squared' ])
    title( get( pvalMaps(i), 'CurrentAxes' ), [ figureTitles{i} 'p values' ])
    
    % Save each trend and correlation map
    saveas(trendMaps(i), [ saveNames{i} 'Trends.png' ])
    saveas(rsquaredMaps(i), [ saveNames{i} 'RSquared.png' ])
    saveas(pvalMaps(i), [ saveNames{i} 'PVals.png' ])
    
    % Close the figures
    close(trendMaps(i))
    close(rsquaredMaps(i))
    close(pvalMaps(i))
    
end

%}