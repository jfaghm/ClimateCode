% ************************************************************************
% This script builds the data set with data for each hurricane that
% occurred from 1989 to 2009 along with associated negatives
% Author: Ryan Haasken
% Date: 07/06/2011
% ************************************************************************

% ------------------------------------------------------------------------
% These are the variables which store the year range
% ------------------------------------------------------------------------
startYear = 1989;
endYear = 2010;
numYears = endYear - startYear + 1;

% ------------------------------------------------------------------------
% Load the hurricane and latitude/longitude grid data
% ------------------------------------------------------------------------
hurDataPath = '/export/scratch/haasken/Hurricane/';
load([hurDataPath 'condensedHurDat.mat'])
hurricanes = condensedHurDat;
clear condensedHurDat
load([hurDataPath 'grid.mat'])

% ------------------------------------------------------------------------
% Get just the applicable hurricanes from the loaded data
% ------------------------------------------------------------------------
hurricanes = hurricanes(hurricanes(:, 1) >= startYear & ...
    hurricanes(:, 2) >= 6 & hurricanes(:, 2) <= 11, :);

% ------------------------------------------------------------------------
% This line finds the closest grid index to each hurricane location
% ------------------------------------------------------------------------
[~, gridIndices] = pdist2(latlonGrid, hurricanes(:, 6:7), 'euclidean', 'Smallest', 1);

% Initialize the dataSet cell array with one cell for each year
dataSet = cell(1, endYear - startYear + 1);

% ------------------------------------------------------------------------
% These are the other variables needed at four pressure levels except
% mslp, which only has one level
% ------------------------------------------------------------------------
variables = { 'geopotential', 'temperature', 'spec_hum', 'vert_vel', ...
    'vorticity', 'divergence', 'rel_hum', 'mslp', 'uWind', 'vWind' };
numVars = length(variables);

% The variables are needed at the following pressure levels
pressureLevels = { '200', '500', '700', '850' };
numPL = length(pressureLevels);

% ------------------------------------------------------------------------
% This variable indicates how far back to go in time when taking data for
% each observation.  A value of 10 indicates getting the current day (4
% times) plus the previous 36 hours (6 more times).
% ------------------------------------------------------------------------
numPreviousMeasurements = 10;
incCol = numPreviousMeasurements - 1;

% This computes the number of columns that are needed in the data set
numFields = (numVars - ismember('mslp', variables))*numPL + ismember('mslp', variables) + 1;
% Below, 6 columns added for [ storm, year, day #, lat, lon, grid index ]
numColumns = numFields * numPreviousMeasurements + 6;

% This variable indicates the next open column in dataSet
nextOpenColumn = 7;

% ------------------------------------------------------------------------
% The following loop gets the SST and the negatives for each year's storms.
% Upon completion of this loop, each of the matrices in the dataSet cell
% array has its first six columns populated with the header information
% listed above.  There are nine rows for each positive and negative
% observation for the nine locations including the hurricane's location.
% ------------------------------------------------------------------------
fprintf('---- Starting to get the SST and Negatives ----\n')
for year = startYear:endYear
    yearStartTime = tic;
    
    % Get the storms and grid indices for the current year
    yearStorms = hurricanes(hurricanes(:, 1) == year, [1:3 6:7]);
    nearestPoints = gridIndices(hurricanes(:, 1) == year);

    % get the SST and negatives for the current year
    sstAndNegatives = getSSTandNegatives(yearStorms, nearestPoints);
    numRows = size(sstAndNegatives, 1);
    
    % Initialize the cell with enough space for all the variables
    dataSet{year - startYear + 1} = zeros(numRows, numColumns);
    % Insert the sst data and header info
    dataSet{year - startYear + 1}(:, 1:16) = sstAndNegatives;
    
    yearEndTime = toc(yearStartTime);
    fprintf('Year %d took %.2f seconds.\n', year, yearEndTime)
end
fprintf('---- Finished getting SST and Negatives ----\n')

nextOpenColumn = nextOpenColumn + numPreviousMeasurements;

% ------------------------------------------------------------------------
% This loop gets data for each of the other variables except for mslp
% ------------------------------------------------------------------------
for var = 1:numVars
    
    variable = variables{var};
    
    % Check if dealing with mslp
    if strcmp(variable, 'mslp')
        % skip mslp to deal with it later
        continue;
    end
    
    fprintf('-------- Starting %s --------\n', variable)
    
    for p = 1:numPL
        
        pressure = pressureLevels{p};
        fprintf('\t-------- Starting Pressure Level %s --------\n', pressure)
        filename = [ variable pressure '_' ];
        
        for year = startYear:endYear
            yearStartTime = tic;
            
            yearData = getYearData(dataSet{year - startYear + 1}(:, 1:6), filename);
            
            dataSet{year - startYear + 1}(:, nextOpenColumn:nextOpenColumn+incCol) = yearData;
            
            yearEndTime = toc(yearStartTime);
            %fprintf('Year %d took %.2f seconds.\n', year, yearEndTime)
        end
        
        nextOpenColumn = nextOpenColumn + numPreviousMeasurements;
        
        fprintf('\t-------- Finished Pressure Level %s --------\n', pressure)
    end
    
    fprintf('-------- Finished %s --------\n', variable)
    
end

% ------------------------------------------------------------------------
% This loop gets data for mslp if it is needed
% ------------------------------------------------------------------------
if ismember('mslp', variables)
    fprintf('-------- Starting mslp --------\n')
    filename = 'mslp';
    for year = startYear:endYear
        %yearStartTime = tic;
        
        yearData = getYearData(dataSet{year - startYear + 1}(:, 1:6), filename);
        
        dataSet{year - startYear + 1}(:, nextOpenColumn:nextOpenColumn+incCol) = yearData;
                
        yearEndTime = toc(yearStartTime);
        %fprintf('year %d took %.2f seconds.\n', year, yearEndTime)
    end
    
    nextOpenColumn = nextOpenColumn + numPreviousMeasurements;
    fprintf('-------- Finished mslp --------\n')
end

% Remove the year and grid index columns from each cell
for year = 1:(numYears)
    dataSet{year}(:, [2 6]) = [];
end


save('hurricanesWithSurround.mat', 'dataSet')

!pwd | mail -s finished haask010@umn.edu

exit