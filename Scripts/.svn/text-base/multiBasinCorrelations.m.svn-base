% This script runs the correlation optimization experiment on each of the
% ocean basins.  It looks at the mean SST of boxes in a basin and finds the
% most highly correlated SST box in that region with a cyclogenesis box in
% the Atlantic Ocean.  It runs this experiment for the following ocean
% basins: West Pacific, East Pacific, Central Pacific, and Indian Ocean
% 
% |    Region     |  West Limit | East Limit | North Limit | South Limit | 
%  West Pacific       120          180         20            5
%  East Pacific      -120         -90          20            5
%  Central Pacific   -180         -120         20            5
%  N. Indian Ocean    55           90          20            5   
%  S. Indian Ocean    50           115         -5            -20

% Add the function path the the MATLAB path
addpath('../')

% Load the array of dataLims structures for each of the 5 ocean basins
load('../SmallData/basinDataLims.mat')
numBasins = length(basinDataLims);
dataBoxes = cell(1, numBasins);

% Load the SST data
load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat')

fprintf('Getting box data for each ocean basin\n')
% Get the data for each box in each basin
for i = 1:numBasins
    fprintf('Starting basin %d\n', i)
    allBoxData = getAllBoxData(reynoldsSST, reynoldsDates, rGridInfo, basinDataLims(i), true);
    nonLandMask = isNonLand(allBoxData(:, 1:4), 0.2);
    dataBoxes{i} = allBoxData(nonLandMask, :);
end

fprintf('Counting storms . . . ')
% Load the atlantic storm count data and count storms in each box
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
storms = condensedHurDat(:, [1 2 6 7 ]);
stormLims = struct('north', 40, 'south', 5, 'west', -100, 'east', -15, 'minWidth', 20, 'maxWidth', 70, ...
    'minHeight', 10, 'maxHeight', 30, 'step', 5, 'months', 6:10, 'startYear', 1982, 'endYear', 2010);
minStormsPerYear = 2.5;
allBoxStormCounts = getAllBoxStormCounts(stormLims);
hasMin = hasMinStorms(allBoxStormCounts, minStormsPerYear);
allBoxStormCounts = allBoxStormCounts(hasMin, :);
fprintf('finished.\n')

% Set up a best boxes cell array to contain the best storm box for every
% sst box in each ocean basin
bestBoxes = cell(1, numBasins);

% For each basin, get the most highly correlated storm box for each sst box
for i = 1:numBasins
    bestBoxes{i} = findBestBoxes(dataBoxes{i}, allBoxStormCounts, false, true);
end

% Plot the most highly correlated boxes from each basin
basinPlots = zeros(1, numBasins);
for i = 1:numBasins
    
    % Use fixed latitude and longitude limits for the maps
    latLims = [ -40 60 ];
    lonLims = [ 80 10 ];
    
    basinPlots(i) = plotBoxes(bestBoxes{i}(1, :), latLims, lonLims);
end

% Save each plot
for i = 1:numBasins
    saveName = basinDataLims(i).name;
    saveName(saveName == ' ') = '_';
    saveas(basinPlots(i), [ saveName '.png' ])
end
