% This script tries a bunch of different temperature thresholds for
% negatives and computes the number of negatives and number of positives
% and their ratio which results.

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

% ------------------------------------------------------------------------
% This variable indicates how far back to go in time when taking data for
% each observation.  A value of 10 indicates getting the current day (4
% times) plus the previous 36 hours (6 more times).
% ------------------------------------------------------------------------
numPreviousMeasurements = 10;
incCol = numPreviousMeasurements - 1;

% This computes the number of columns that are needed in the data set
numFields = 1;
% Below, 6 columns added for [ storm, year, day #, lat, lon, grid index ]
numColumns = numFields * numPreviousMeasurements + 6;

% Initialize a matrix to store the number of positives and negatives for
% each different temperature threshold
posAndNeg = zeros(11, 2);
% Initialize a matrix to store average SST's for positives and negatives
avgSSTPosNeg = zeros(11, 2);
% Initialize a cell array to store each temperature's cell array
dataArray = cell(1, 11);

tempIndex = 0;

for temp = .1:.01:.2
    
    tempIndex = tempIndex + 1;
    
    % Initialize the dataSet cell array with one cell for each year
    dataSet = cell(1, endYear - startYear + 1);
    
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
        sstAndNegatives = getSSTandNegatives(yearStorms, nearestPoints, temp);
        numRows = size(sstAndNegatives, 1);
        
        % Initialize the cell with enough space for all the variables
        dataSet{year - startYear + 1} = zeros(numRows, numColumns);
        % Insert the sst data and header info
        dataSet{year - startYear + 1}(:, 1:16) = sstAndNegatives;
        
        yearEndTime = toc(yearStartTime);
        fprintf('Year %d took %.2f seconds.\n', year, yearEndTime)
    end
    fprintf('---- Finished getting SST and Negatives ----\n')
    
    % Remove the year and grid index columns from each cell
    for year = 1:(numYears)
        dataSet{year}(:, [2 6]) = [];
    end
    
    dataArray{tempIndex} = dataSet;
    
    [p n] = countPosNeg(dataSet);
    [avgP avgN] = getAvgSSTPosNeg(dataSet);
    
    posAndNeg(tempIndex, :) = [p n];
    avgSSTPosNeg(tempIndex, :) = [avgP avgN];
    
end

save('testTempResults.mat', 'dataArray', 'posAndNeg', 'avgSSTPosNeg')

!pwd | mail -s finished haask010@umn.edu

exit
