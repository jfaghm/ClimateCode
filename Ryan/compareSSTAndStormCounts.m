function [ c f ] = compareSSTAndStormCounts( sstData, gridInfo, sstDates, sstLoc, storms, stormBox, timePeriod )
% COMPARESSTANDSTORMCOUNTS Compares SST and storm counts time series
% 
% [ c f ] = compareSSTAndStormCounts( sstData, gridInfo, sstDates, sstLoc, storms, stormBox, timePeriod )
% 
% This function compares the SST time series of a single grid point with
% the storm counts time series for a region.  It does so by computing the
% correlation between the two time series and by plotting the two time
% series on the same axis with SST scaled to storm counts.
% 
% ----------------------------- INPUT -----------------------------
% 
% --> sstData - The sst data grid
% --> gridInfo - A struct describing the grid layout (see getMatrixIndices
% for more details)
% --> sstDates - a vector of dates corresponding to the third dimension of
% the sst data grid
% --> sstLoc - a struct with a lat and a lon field to indicate the desired
% sst location
% --> storms - the storm data, with [ year, month, lat, lon ]
% --> stormBox - A struct with lats and lons fields representing the
% north, south, west, and east limits of the storm box.
% --> timePeriod - A struct with startYear, endYear, and months fields
% 
% ----------------------------- OUTPUT -----------------------------
% 
% --> c - the correlation between the two time series
% --> f - the handle to the figure created
% 
% ----------------------------- EXAMPLE -----------------------------
% 
% The following example compares the East Atlantic storm counts and the SST
% of a point off the coast of Africa:
% 
% % Load the sst data, grid info, and dates
% load /project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat
% % Load the storm data and take only year, month, lat, lon
% load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% storms = condensedHurDat(:, [ 1 2 6 7 ]);
% % Set up the stormLims and sstLoc structures
% stormBox = struct('lats', [ 5 20 ], 'lons', [ -45 -15 ]);
% sstLoc = struct('lat', 10, 'lon', -20);
% timePeriod = struct('startYear', 1982, 'endYear', 2010, 'months', 6:10);
% [ c, f ] = compareSSTAndStormCounts(reynoldsSST, rGridInfo, reynoldsDates, sstLoc, storms, stormBox, timePeriod);
% 

% Get the relevant storm counts time series
stormCounts = countStorms(storms, timePeriod.startYear, timePeriod.endYear, timePeriod.months, ...
    stormBox.lats, stormBox.lons);

% Get index into the SST Data corresponding to the SSTLoc
[row, col] = getMatrixIndices( sstLoc.lat, sstLoc.lon, gridInfo );

% Get the seasonal average for the sst location
seasonalSST = monthlyToSeasonal(sstData, sstDates, timePeriod.months, ... 
    timePeriod.startYear, timePeriod.endYear);

% Get the time series for the SST Location
sstTimeSeries = reshape( seasonalSST(row, col, :), 1, [], 1 );

% Compute the correlation between the two time series
c = rowCorr(stormCounts, sstTimeSeries);

scaledSSTTimeSeries = (sstTimeSeries - mean(sstTimeSeries)) / std(sstTimeSeries) ...
    * std(stormCounts) + mean(stormCounts);

% Plot the two time series (scaled) on a single axis
f = figure; hold on;
plot(timePeriod.startYear:timePeriod.endYear, stormCounts, 'Color', 'red');
plot(timePeriod.startYear:timePeriod.endYear, scaledSSTTimeSeries, 'Color', 'blue');
legend({'Storm Counts', 'Scaled SST'})

end