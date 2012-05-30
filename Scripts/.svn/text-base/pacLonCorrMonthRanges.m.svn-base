% This script finds the locations of the warmest boxes in the pacific ocean
% and correlates the longitude of those boxes against the storm counts for
% the entire atlantic ocean

% Add the path to the functions
addpath('../')

% Some constants which modify the behavior of the script
START_MONTH = 4;
END_MONTH = 4;
NUM_MONTHS = END_MONTH - START_MONTH + 1;
MIN_RANGE = 7;
MAX_RANGE = 7;
RANGE_LENGTH = MAX_RANGE - MIN_RANGE + 1;

% Load the erv3sst data set
load /project/expeditions/haasken/data/ERSST/ersstv3.mat

% Set up the limits for the pacific ocean box to be searched
dataLimits = struct('north', 20, 'south', -20, 'east', -100, 'west', 150, ...
    'step', 1, 'width', 20, 'height', 5, ...
    'months', 1:12, 'startYear', 1971, 'endYear', 2010);

% Compute anomalies from the SST data with a base period of 1971-2000
anomalies = computeAnomalies(erv3sst, erv3Dates, 'basePeriod', [1971 2000]);

% Load the storm data
load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
storms = condensedHurDat(:, [ 1 2 6 7 ]);
% Count the June-Oct storms in the atlantic ocean
stormCounts = countStorms(storms, 1971, 2010, 6:10, [ 5 25 ], [ -100 -10 ]);


allMonthMaxAnomaly = zeros( dataLimits.endYear - dataLimits.startYear + 1, ...
    5, NUM_MONTHS * RANGE_LENGTH );
allMonthMaxSST = zeros( dataLimits.endYear - dataLimits.startYear + 1, ...
    5, NUM_MONTHS * RANGE_LENGTH );
anomalyCorrelations = zeros(NUM_MONTHS * RANGE_LENGTH, 2);
sstCorrelations = zeros(NUM_MONTHS * RANGE_LENGTH, 2);
seasonNames = cell(1, NUM_MONTHS * RANGE_LENGTH);

% Do an exhaustive search of all month ranges
for startMonth = START_MONTH:END_MONTH
    for range = MIN_RANGE:MAX_RANGE

        index = (startMonth-START_MONTH)*RANGE_LENGTH + (range - MIN_RANGE + 1);
        
        % Construct the months vector
        endMonth = startMonth + range - 1;
        if endMonth > 12
            endMonth = endMonth - 12;
            months = [ startMonth:12 1:endMonth ];
        else
            months = startMonth:endMonth;
        end
        
        seasonName = nameSeason(months);
        fprintf('Starting season %s\n', seasonName);
        seasonNames{index} = seasonName;
        dataLimits.months = months;
        
        % Get the mean sst and anomalies for all 10x40 boxes in the pacific ocean
        allBoxSST = getAllBoxData(erv3sst, erv3Dates, erv3GridInfo, dataLimits);
        allBoxAnomaly = getAllBoxData(anomalies, erv3Dates, erv3GridInfo, dataLimits);
        
        
        % Initialize storage for the maximum SST and anomaly boxes
        yearMaxSST = zeros(size(allBoxSST, 2)-4, 5);
        yearMaxAnomaly = zeros(size(allBoxAnomaly, 2)-4, 5);
        
        % Get the maximum SST and anomaly boxes for each year
        for i = 5:size(allBoxSST, 2)
            
            % SST
            [ m, maxIndex ] = max(allBoxSST(:, i));
            yearMaxSST(i-4, :) = [ m, allBoxSST(maxIndex, 1:4) ];
            
            % Anomaly
            [ m, maxIndex ] = max(allBoxAnomaly(:, i));
            yearMaxAnomaly(i-4, :) = [ m, allBoxAnomaly(maxIndex, 1:4) ];
            
        end
        
        % Save the max anomaly and sst boxes for the month range
        allMonthMaxSST(:, :, index) = yearMaxSST;
        allMonthMaxAnomaly(:, :, index) = yearMaxAnomaly;



        % Compute the correlation between east longitude limit and storm counts
        sstCorr = corr( yearMaxSST(:, 1), stormCounts' );
        sstLongCorr = corr( yearMaxSST(:, 5), stormCounts' );
        anomalyCorr = corr( yearMaxAnomaly(:, 1), stormCounts' );
        anomalyLongCorr = corr( yearMaxAnomaly(:, 5), stormCounts');
        
        anomalyCorrelations(index, :) = [anomalyCorr, anomalyLongCorr];
        sstCorrelations(index, :) = [sstCorr, sstLongCorr];
        
    end
end



