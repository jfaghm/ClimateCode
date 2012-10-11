% This script builds the cell array that consists of a 2-dimensional matrix
% for each year between 1989 and 2009.  Each of those matrices contains the
% conditions for each storm that occurred and also examples of similar
% conditions when a storm did not occur.

% variable indicating the first year for which we have data
earliest_year = 1989;

% path to the .mat data files
data_path = '/project/expeditions/haasken/MATLAB/Hurricane/';

% Load the storm data, creates hurricanes and labels variables
load([data_path 'atlantic_storms_1870_2009.mat'])
% Get the storm data only for the years that we want
data = hurricanes(hurricanes(:, 1) >= earliest_year, [1:3 6 7]);

clear hurricanes

% load the locations of the gridded data
load([data_path 'revised_grid.mat'])
% calculate the nearest point in the grid for each hurricane
[~, nearest_points] = pdist2(grid, data(:, 4:5), 'euclidean', 'Smallest', 1);

% load which data is needed for each hurricane
% load([data_path 'vars_needed.mat'])

% calculate the starting and ending year to be considered
start_year = min(data(:, 1));
end_year = max(data(:, 1));

% set up the cell array in which each cell contains a year's storm data
model_data = cell(1, (end_year-start_year+1));

% accumulate the data for each storm season
for year = start_year:end_year
    season.yr = year;
    % get all the storm dates that occurred in current year
    stormMask = (data(:, 1) == year);
    season.months = data(stormMask, 2);
    season.days = data(stormMask, 3);
    season.lat = data(stormMask, 4);
    season.lon = data(stormMask, 5);
    season.numStorms = size(season.days, 1);

    %seasonData = getSeasonData(nearest_points(stormMask), season, varsNeeded);
    seasonData = getSeasonData(nearest_points(stormMask), season);
    
    model_data{year - start_year + 1} = seasonData;
    
end