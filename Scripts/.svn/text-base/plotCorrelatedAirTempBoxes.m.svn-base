% This script computes the best correlation between any two boxes for the
% air temperature data at the various pressure levels and also for the u
% wind data at the 850 mbar pressure level

stormLims.step = 2.5;
stormLims.minWidth = 15;
stormLims.maxWidth = 60;
stormLims.minHeight = 10;
stormLims.maxHeight = 25;
stormLims.north = 35;
stormLims.south = 5;
stormLims.west = -90;
stormLims.east = 0;
stormLims.startYear = 1948;
stormLims.endYear = 2009;
stormLims.months = 6:10;
stormLims.minStormsPerYear = 4;

allBoxStorms = getAllBoxStormCounts(stormLims);
allBoxStorms = allBoxStorms(hasMinStorms(allBoxStorms, stormLims.minStormsPerYear), :);

dataLims = struct('step', 2.5, 'minWidth', 10, 'minHeight', 10, 'maxWidth', 30, 'maxHeight', 30, ...
    'north', 35, 'south', 5, 'west', -90, 'east', 0, 'months', 6:10, 'startYear', 1948, 'endYear', 2009);

pressureLevels = [1000,925,850,700,600,500,400,300,250,200,150,100,70,50,30,20,10];
numPressureLevels = length(pressureLevels);

allPLBestBoxes = cell(1, numPressureLevels);

% Create the air temp plots for each of the pressure levels
for i = 1:numPressureLevels
    
    fprintf('Starting Pressure Level %d ... ', i)
    
    load(['/project/expeditions/haasken/data/ncep_air_temp/airTemp' num2str(pressureLevels(i)) '.mat'])
    
    bestBoxes = findBestBoxes(dataLims, airTemp, months, gridInfo, allBoxStorms);

    allPLBestBoxes{i} = bestBoxes;
    
    plotBestBoxes(bestBoxes, 10, [ 'BestAirTempBoxes/Pressure' num2str(pressureLevels(i)) '/' ], [-20 60], [-90 10])
    
    fprintf('finished.\n')
    
end


% Create the air temp plots for the surface temperature
load('/project/expeditions/haasken/data/ncep_air_temp/surfaceAirTemp.mat')

surfaceBestBoxes = findBestBoxes(dataLims, airTemp, months, gridInfo, allBoxStorms);

plotBestBoxes(surfaceBestBoxes, 10, 'BestAirTempBoxes/Surface/', [-20 60], [-90 10])


% Create the best boxes plot for u wind 850 mbar

% Create the air temp plots for the surface temperature
load('/project/expeditions/haasken/data/ncep_air_temp/surfaceAirTemp.mat')

surfaceBestBoxes = findBestBoxes(dataLims, airTemp, months, gridInfo, allBoxStorms);

plotBestBoxes(surfaceBestBoxes, 10, 'BestAirTempBoxes/Surface/', [-20 60], [-90 10])

