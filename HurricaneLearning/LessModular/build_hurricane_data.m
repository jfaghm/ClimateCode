% This script builds the cell array that consists of a 2-dimensional matrix
% for each year between 1989 and 2009.  Each of those matrices contains the
% conditions for each storm that occurred and also examples of similar
% conditions when a storm did not occur.

% If all years are needed uncomment the following line, and comment the
% line after that
years = 1989:2009;
% years = [ 2000, 2001, 2003, 2008 ];
numYears = size(years, 2);

ncFileTime = zeros(1, numYears);

% This is the earliest year that you expect to have data for, allows for 
% correct offset into model data, not necessarily the same as start_year 
earliest_year = 1989;
% This is the latest year expected to have data
latest_year = 2009;

% calculate the starting and ending year to be considered
start_year = min(years);
end_year = max(years);

% width of surrounding elements to get data for
global surroundWidth
surroundWidth = 1;

% path to the .mat data files
global matDataPath
matDataPath = '/project/expeditions/haasken/MATLAB/Hurricane/';

% path to the climate data nc files
global ncDataPath
ncDataPath = '/project/expeditions/liesss/Data/faghmous/';

% Load the storm data, creates hurricanes and labels variables
load([matDataPath 'atlantic_storms_1870_2009.mat'])
% Get the storm data only for the years that we want
global hurData
hurData = hurricanes(hurricanes(:, 1) >= start_year, [1:3 6 7]);

clear hurricanes

% load the locations of the gridded data
load([matDataPath 'grid.mat'])
% calculate the nearest point in the grid for each hurricane
[~, nearest_points] = pdist2(grid, hurData(:, 4:5), 'euclidean', 'Smallest', 1);

% set up the cell array in which each cell contains a year's storm data
if ~(exist('model_data', 'var') == 1)
    model_data = cell(1, (latest_year-earliest_year+1));
end

% accumulate the data for each storm season
for i = 1:numYears
    yearStartTime = tic;
    year = years(i);
    season.yr = year;
    % get all the storm dates that occurred in current year
    stormMask = (hurData(:, 1) == year);
    season.months = hurData(stormMask, 2);
    season.days = hurData(stormMask, 3);
    season.lat = hurData(stormMask, 4);
    season.lon = hurData(stormMask, 5);
    season.numStorms = size(season.days, 1);

    %seasonData = getSeasonData(nearest_points(stormMask), season);
    seasonData = getSeasonData(nearest_points(stormMask), season);
    
    model_data{year - earliest_year + 1} = seasonData;
    yearEndTime = toc(yearStartTime);
    ncFileTime(i) = yearEndTime;
    fprintf('Year %d took %.2f seconds to complete.\n', year, yearEndTime)
end