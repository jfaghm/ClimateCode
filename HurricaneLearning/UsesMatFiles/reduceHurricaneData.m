% This script reduces the hurricane data set which contains many variables for each
% hurricane, including the surrounding locations, down to a simpler data set which only
% contains the data at the hurricane's location.  It also puts the data into a matrix with
% a column indicating the year of each storm instead of a cell array with each cell being
% a single year.  The purpose of this reduction is to get the data into a form that is
% more usable by a clustering algorithm.

% Use the unconstrained7day.mat data set.  No need to constrain since we are not taking
% any negative observations associated with each storm.
load unconstrained7day.mat

% CONSTANTS
STARTYEAR = 1989;
NUMVARS = 6;


numYears = length(dataSet);
years = STARTYEAR:(STARTYEAR + numYears - 1);

% Count the total number of storms in the data set
[ p ~ ] = countPosNeg(dataSet);
% Preallocate the new hurricane matrix
hurricaneData = zeros(p, NUMVARS);

outIndex = 0;

% Iterate through the data set year by year
for i = 1:numYears
    curYear = years(i);
    startDayNum = datenum(curYear, 0, 0);
    
    % Get all the positive storm observations
    yearStorms = dataSet{i}( dataSet{i}(:, 1) == 1, : );
    % Remove all the surrounding locations
    yearStorms = yearStorms( 1:9:size(yearStorms, 1), :);
    
    numStorms = size(yearStorms, 1);
    
    for j = 1:numStorms
        
        outIndex = outIndex + 1;
        
        % Get the latitude and longitude
        latlon = yearStorms(j, 3:4);
        
        % Get the month and day from the daynumber
        [~, month, day] = datevec( startDayNum + yearStorms(j, 2) );
        
        % Get the average SST during the day of the storm
        meanSST = mean( yearStorms(j, 5:8) );
        
        hurricaneData(outIndex, :) = [ curYear, month, day, latlon, meanSST ];
        
    end
    
end