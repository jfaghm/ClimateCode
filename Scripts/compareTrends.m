%COMPARETRENDS.M Computes trends and plots data for several regions.
% AUTHOR: Ryan Haasken
% Date: 9/28/11
% Worked with revision 4 of the svn repository.
%
% This is a script for completing Tasks 7 and 8 in the spreadsheet. It
% plots the annual mean SST and annual mean air temperature (@850mbar) for
% several different regions: Webster's North Atlantic region, Trenberth's
% tropical atlantic region, and the most highly correlated regions obtained
% in earlier experiments.  It also computes the trends of each of these
% time series.

% Add the path to all the functions
addpath('../')

% Using the hadley SST data set, so I can get a longer time series
load('/project/expeditions/haasken/data/HadISST1/hadleySSTLatLon.mat')

% Load the ncep 850 mbar air temp data
load('/project/expeditions/haasken/data/ncep_air_temp/airTemp850.mat')
air850 = airTemp;
grid850 = gridInfo;
months850 = months;

% Load the ncep surface air temp data
load('/project/expeditions/haasken/data/ncep_air_temp/surfaceAirTemp.mat')
air2m = airTemp;
grid2m = gridInfo;
months2m = months;

% Set the start and end years for time series
startYear = 1966;
endYear = 2010;
numYears = endYear - startYear + 1;

regionNames = { 'Webster NATL', 'Trenberth TATL', 'Highly Correlated', ...
    'Preseason 1', 'Preseason 2' };
regionMonths = { 6:10, 6:10, 6:10, 5:6, 5:6 };
regionLimits = [ ...
    5 25 -90 20 ; ...
    10 20 -80 -20; ...
    5 20 -30 -20; ...
    35 45 -38 -18; ...
    20 40 -28 -18 ...
    ];

numRegions = length(regionNames);
allRegionSST = zeros(numRegions, numYears);
allRegionAirTemp850 = zeros(numRegions, numYears);
allRegionAirTemp2m = zeros(numRegions, numYears);
% Initialize space to store the upward trend and r^2 values
sstTrends = zeros(numRegions, 3);
airTrends850 = zeros(numRegions, 3);
airTrends2m = zeros(numRegions, 3);

% Get the means of SST and air temp for each region
for r = 1:numRegions
    
    meanSST = getMeanData( hadleySST, hadleyDates, hGridInfo, regionLimits(r, 1:2), ...
        regionLimits(r, 3:4), startYear, endYear, regionMonths{r}, true );
    
    stats = regstats( meanSST', [startYear:endYear]' );
    sstTrends(r, :) = [ stats.beta(2) stats.tstat.pval(2) stats.rsquare ];
    
    meanAir850 = getMeanData( air850, months850, grid850, regionLimits(r, 1:2), ...
        regionLimits(r, 3:4), startYear, endYear, regionMonths{r}, true );
    
    stats = regstats( meanAir850', [startYear:endYear]' );
    airTrends850(r, :) = [ stats.beta(2) stats.tstat.pval(2) stats.rsquare ];
    
    meanAir2m = getMeanData( air2m, months2m, grid2m, regionLimits(r, 1:2), ...
        regionLimits(r, 3:4), startYear, endYear, regionMonths{r}, true );
    
    stats = regstats( meanAir2m', [startYear:endYear]' );
    airTrends2m(r, :) = [ stats.beta(2) stats.tstat.pval(2) stats.rsquare ];
    
    allRegionSST(r, :) = meanSST;
    allRegionAirTemp850(r, :) = meanAir850;
    allRegionAirTemp2m(r, :) = meanAir2m;
    
end

% Plot the means of SST on one graph
colors = { 'red', 'blue', 'cyan', 'black', 'green' };
sstFig = figure( 'OuterPosition', [ 50 50 1000 800 ]); 
hold on;
for r = 1:numRegions
    plot(startYear:endYear, allRegionSST(r, :), 'Color', colors{r})
end
legend( regionNames, 'Location', 'EastOutside' );
title( 'Annual mean sst of several regions in the Atlantic' )
xlabel( 'Year' )
ylabel( 'Temperature (K)' )

% Plot the means of 850 mbar air temp on one graph
airFig850 = figure( 'OuterPosition', [ 50 50 1000 800 ]);
hold on;
for r = 1:numRegions
    plot(startYear:endYear, allRegionAirTemp850(r, :), 'Color', colors{r})
end
legend( regionNames, 'Location', 'EastOutside' );
title( 'Annual mean 850 mbar air temp of several regions in the Atlantic' )
xlabel( 'Year' )
ylabel( [ 'Temperature (' char(176) 'C)' ] )

% Plot the means of 2m air temp on one graph
airFig2m = figure( 'OuterPosition', [ 50 50 1000 800 ]);
hold on;
for r = 1:numRegions
    plot(startYear:endYear, allRegionAirTemp2m(r, :), 'Color', colors{r})
end
legend( regionNames, 'Location', 'EastOutside' );
title( 'Annual mean 2-meter air temp of several regions in the Atlantic' )
xlabel( 'Year' )
ylabel( [ 'Temperature (' char(176) 'C)' ] )

saveas(airFig850, 'AirTemps850.png')
saveas(airFig2m, 'AirTemps2m.png')
saveas(sstFig, 'SST.png')

close all

% Remove the directory one level up from current directory from search path
rmpath('../')