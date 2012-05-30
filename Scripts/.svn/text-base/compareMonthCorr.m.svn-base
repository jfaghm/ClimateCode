% This script looks at SST boxes in each Ocean basin and reports the best
% correlation for each month range.  Several statistics for each month
% range are reported: maximum correlation, minimum correlation, 90th
% percentile correlation, mean correlation, and standard deviation of the
% correlations. It looks at month ranges from 1 to 6 months in length
% starting in each possible month.  It runs this experiment for the
% following ocean basins: West Pacific, East Pacific, Central Pacific, and
% Indian Ocean
% 
% |    Region     |  West Limit | East Limit | North Limit | South Limit | 
%  West Pacific       120          180         20            5
%  East Pacific      -120         -90          20            5
%  Central Pacific   -180         -120         20            5
%  N. Indian Ocean    55           90          20            5   
%  S. Indian Ocean    50           115         -5            -20
% 

% Add the function path the the MATLAB path
addpath('../')


fprintf('Counting storms . . . ')
% Load the atlantic storm count data and count storms in each box
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
storms = condensedHurDat(:, [1 2 6 7 ]);
%{
stormLims = struct('north', 40, 'south', 5, 'west', -100, 'east', -15, 'minWidth', 20, 'maxWidth', 70, ...
    'minHeight', 10, 'maxHeight', 30, 'step', 5, 'months', 6:10, 'startYear', 1982, 'endYear', 2010);
minStormsPerYear = 2.5;
allBoxStormCounts = getAllBoxStormCounts(stormLims);
hasMin = hasMinStorms(allBoxStormCounts, minStormsPerYear);
allBoxStormCounts = allBoxStormCounts(hasMin, 5:end);
%}
fprintf('finished.\n')

% Instead of counting storms in all boxes, just get the storm counts for
% three boxes in the Atlantic
stormLats = [ 5 45; 5 45; 5 45 ];
stormLons = [ -100 -75; -75 -45; -45 -15 ];
STORM_MONTHS = 6:10;
NUM_STORM_REGIONS = size(stormLons, 1);
START_YEAR = 1982;
END_YEAR = 2010;
NUM_YEARS = END_YEAR - START_YEAR + 1;
regionStormCounts = zeros(NUM_STORM_REGIONS, NUM_YEARS);
for i = 1:NUM_STORM_REGIONS
    regionStormCounts(i, :) = countStorms(storms, START_YEAR, END_YEAR, STORM_MONTHS, stormLats(i, :), stormLons(i, :));
end


% A few constants for the month ranges
MAX_RANGE = 5;
BEGIN_MONTH = 1;
END_MONTH = 12;

monthNames = { 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec' };
rowLabels = cell(12*MAX_RANGE, 1);
colLabels = { 'Maximum Correlation', 'North Limit', 'South Limit', 'West Limit', 'East Limit', ...
    'Minimum Correlation', 'North Limit', 'South Limit', 'West Limit', 'East Limit', ...
    'Mean Correlation', 'Std Dev.' };
NUM_STATS = length(colLabels);

% Set up the the row labels
for startMonth = BEGIN_MONTH:END_MONTH
    for range = 1:MAX_RANGE
        endMonth = startMonth + range - 1;
        if endMonth > 12
            endMonth = endMonth - 12;
        end
        
        rowIndex = (startMonth-BEGIN_MONTH)*MAX_RANGE + range;
        rowLabels{rowIndex} = [ monthNames{startMonth} '-' monthNames{endMonth} ];
    end
end

% Load the array of dataLims structures for each of the 5 ocean basins
load('../SmallData/basinDataLims.mat')
numBasins = length(basinDataLims);
COARSE_MULTIPLIER = 2;

% Set up the cell array which will store each basin's results
basinCorrResults = cell(1, numBasins);

% Load the SST data
load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat')

fprintf('Getting box data for each ocean basin\n')
% Get the data for each box in each basin
parfor i = 1:numBasins
    fprintf('Starting basin %d\n', i)
    
    % Initialize the Results matrix to contain correlation data for each
    % storm basin
    basinCorrResults{i} = zeros((END_MONTH - BEGIN_MONTH + 1)*MAX_RANGE, NUM_STATS*NUM_STORM_REGIONS);
    currentDataLims = basinDataLims(i);
    
    % Make the data boxes more coarse if desired
    currentDataLims.step = currentDataLims.step * COARSE_MULTIPLIER;
    
    % Iterate through all possible starting months
    for startMonth = BEGIN_MONTH:END_MONTH
        % Iterate through all month range lengths
        for range = 1:MAX_RANGE
            
            % Construct the month range
            endMonth = startMonth + range - 1;
            if endMonth > 12
                endMonth = endMonth - 12;
            end
            if startMonth > endMonth
                currentDataLims.months = [ startMonth:12 1:endMonth ];
            else
                currentDataLims.months = startMonth:endMonth;
            end
            
            % Get the box data for this basin during this month range
            allBoxData = getAllBoxData(reynoldsSST, reynoldsDates, rGridInfo, currentDataLims, true);
            allBoxData = allBoxData(isNonLand(allBoxData(:, 1:4), 0.2), :);
            if (all(isnan(allBoxData(:, 5))))
                % Compute the correlations matrix for 1983 onward
                allCorrelations = rowCorr( regionStormCounts(:, 2:end), allBoxData(:, 6:end) );            
            else
                % Compute the correlations matrix normally
                allCorrelations = rowCorr( regionStormCounts, allBoxData(:, 5:end) );
            end
            
            rowIndex = (startMonth-BEGIN_MONTH)*MAX_RANGE + range;
            
            % Iterate through the different storm regions
            for stormRegion = 1:NUM_STORM_REGIONS
                regionCorr = allCorrelations(stormRegion, ~isnan(allCorrelations(stormRegion, :)));
                regionStartIndex = (stormRegion-1)*NUM_STATS + 1;
                regionEndIndex = regionStartIndex + NUM_STATS - 1;
                
                % Compute statistics about the correlations for given
                % month range, region, and basin
                [ maxCorr, maxIndex ] = max(regionCorr);
                maxLatLons = allBoxData(maxIndex, 1:4);
                [ minCorr, minIndex ] = min(regionCorr);
                minLatLons = allBoxData(minIndex, 1:4);
                meanCorr = mean(regionCorr);
                stdDevCorr = std(regionCorr);
                
                basinCorrResults{i}(rowIndex, regionStartIndex:regionEndIndex) = ...
                    [ maxCorr, maxLatLons, minCorr, minLatLons, meanCorr, stdDevCorr ];
            end
        end
    end          
end

