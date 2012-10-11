function obs = getNegatives( storms, indices, sstData, tempThreshold)
%GETNEGATIVES Gets the negative observation dates for each storm.
%   This function gets all the negative observation dates it can for each
%   storm (up to 3 negatives per storm).  
%   INPUT: storms - the date and location info for each storm, indices -
%   the nearest gaussian grid point index for each storm, sstData - a 3
%   element cell array containing the SST data for the current year and the
%   next and previous years.
%   OUTPUT: obs - a 2D matrix with each observation in a row.  Each row
%   contains whether a storm occured (0/1), the year of the observation,
%   day number, latitude, longitude, and the index in the grid.

% Check if a temperature threshold is given.  If not, require that each
% negative have an sst within 0.1 degrees of the storm day's average
if nargin < 4
    tempThreshold = Inf;
end

% Indicates the range of days that are considered a year before and a year
% after, i.e. +/-dayRange days from the given day number
dayRange = 7;

numStorms = size(storms, 1);

% Initialize a matrix to hold the positive and negative observations
obs = zeros(numStorms*4, 6);

for i = 1:numStorms
    
    % grab some information about the storm
    locIndex = indices(i);
    year = storms(i, 1);
    month = storms(i, 2);
    day = storms(i, 3);
    
    % get the dayNumber out of the entire year of the storm
    yearDayNum = datenum(year, month, day) - datenum(year, 1, 1) + 1;

    % fill in the storm's positive observation row
    obs(4*i - 3, :) = [ 1 year yearDayNum storms(i, 4:5) locIndex ];
    
    % get the day number of the storm within the months June - November
    seasonDayNum = datenum(year, month, day) - datenum(year, 6, 1) + 1;
    % get the sst the day of the storm for negative comparison
    targetSST = mean(sstData{2}(locIndex, (4*seasonDayNum-3):(4*seasonDayNum)));
    
    %% This cell finds a day between 7 and 13 days before the storm
    
    % compute the start and end day numbers for the 7-13 day before range
    startDay = seasonDayNum - 13;
    endDay = startDay + 6;
    
    
    % compute the time slots (columns) in the sstData
    startSlot = startDay*4 - 3;
    endSlot = endDay*4;
    
    % check for out-of-range indices
    if startSlot < 1
        startSlot = 1;
    elseif endSlot > 732
        endSlot = 732;
    end
    dayNumbers = ceil((startSlot:endSlot)/4) + datenum(year, 6, 1) - datenum(year, 1, 1);
    
    
    possibleSSTs = sstData{2}(locIndex, startSlot:endSlot);
    % compute the absolute differences and add a row of day numbers
    differences = [ abs(possibleSSTs - targetSST); dayNumbers ];
    
    % remove all differences outside of the threshold
    differences = differences(:, differences(1, :) < tempThreshold);
    
    % sort the differences matrix in order of the differences
    [~, diffOrder] = sort(differences(1, :));
    sortedDifferences = differences(:, diffOrder);
    
    % Find out how many possible negatives there are
    numCandidates = size(sortedDifferences, 2);
    % A column of ones to be used when constructing possible negatives
    ext = ones(numCandidates, 1);
    % Create a matrix of possible negatives
    possibleNegatives = [ zeros(numCandidates, 1) year*ext ...
        sortedDifferences(2, :)' storms(i, 4)*ext storms(i, 5)*ext locIndex*ext ];
    % Check those possible negatives for validity
    goodNegatives = checkNegatives(possibleNegatives, false);
    
    if isempty(goodNegatives)
        obs(4*i - 2, 1) = -1;
    else
        obs(4*i - 2, :) = goodNegatives(1, :);
    end
    
    %{
    % find the minimum difference in sst and where it came from
    [diff, mIndex] = min(differences);
    % check if found SST is within threshold
    if diff < tempThreshold
        dayNum = ceil(mIndex/4) + startDay - 1 + datenum(year, 6, 1) - datenum(year, 1, 1);
        obs(4*i - 2, :) = [ 0 year dayNum storms(i, 4:5) locIndex ];
    else
        obs(4*i - 2, 1) = -1;
    end
    %}
    
    %% This cell computes the starting and ending days/slots for the next two cells
    
    % compute the start and end day numbers for the +/- 5 days range
    % ***relative to June 1st***
    startDay = datenum(year, month, day) - datenum(year, 6, 1) - dayRange + 1;
    endDay = startDay + 2*dayRange;
    
    % compute the time slots (columns) in the sstData
    startSlot = startDay*4 - 3;
    endSlot = endDay*4;
    
    % check for out-of-range indices
    if startSlot < 1
        startSlot = 1;
    elseif endSlot > 732
        endSlot = 732;
    end
    
    %% This cell attempts to find a negative about a year before the storm
    
    % first check if sstData has data for previous year
    if ~isempty(sstData{1})
        
        % Compute the year day numbers of each time slot
        dayNumbers = ceil((startSlot:endSlot)/4) + datenum(year-1, 6, 1) - datenum(year-1, 1, 1);
        
        possibleSSTs = sstData{1}(locIndex, startSlot:endSlot);
        % compute the absolute differences and add a row of day numbers
        differences = [ abs(possibleSSTs - targetSST); dayNumbers ];
        
        % remove all differences outside of the threshold
        differences = differences(:, differences(1, :) < tempThreshold);
        
        % sort the differences matrix in order of the differences
        [~, diffOrder] = sort(differences(1, :));
        sortedDifferences = differences(:, diffOrder);
        
        % Find out how many possible negatives there are
        numCandidates = size(sortedDifferences, 2);
        % A column of ones to be used when constructing possible negatives
        ext = ones(numCandidates, 1);
        % Create a matrix of possible negatives
        possibleNegatives = [ zeros(numCandidates, 1) (year-1)*ext ...
            sortedDifferences(2, :)' storms(i, 4)*ext storms(i, 5)*ext locIndex*ext ];
        % Check those possible negatives for validity
        goodNegatives = checkNegatives(possibleNegatives, false);
        
        if isempty(goodNegatives)
            obs(4*i - 1, 1) = -1;
        else
            obs(4*i - 1, :) = goodNegatives(1, :);
        end

    else
        % no data for previous year
        obs(4*i - 1, 1) = -1;
    end
    
    %% This cell attempts to find a negative about a year after the storm
    
    % first check if sstData has data for the next year
    if ~isempty(sstData{3})
        
        % Compute the year day numbers of each time slot
        dayNumbers = ceil((startSlot:endSlot)/4) + datenum(year+1, 6, 1) - datenum(year+1, 1, 1);
        
        possibleSSTs = sstData{3}(locIndex, startSlot:endSlot);
        % compute the absolute differences and add a row of day numbers
        differences = [ abs(possibleSSTs - targetSST); dayNumbers ];
        
        % remove all differences outside of the threshold
        differences = differences(:, differences(1, :) < tempThreshold);
        
        % sort the differences matrix in order of the differences
        [~, diffOrder] = sort(differences(1, :));
        sortedDifferences = differences(:, diffOrder);
        
        % Find out how many possible negatives there are
        numCandidates = size(sortedDifferences, 2);
        % A column of ones to be used when constructing possible negatives
        ext = ones(numCandidates, 1);
        % Create a matrix of possible negatives
        possibleNegatives = [ zeros(numCandidates, 1) (year+1)*ext ...
            sortedDifferences(2, :)' storms(i, 4)*ext storms(i, 5)*ext locIndex*ext ];
        % Check those possible negatives for validity
        goodNegatives = checkNegatives(possibleNegatives, false);
        
        if isempty(goodNegatives)
            obs(4*i, 1) = -1;
        else
            obs(4*i, :) = goodNegatives(1, :);
        end
        
    else
        % no data for the next year
        obs(4*i, 1) = -1;
    end
end

obs(obs(:, 1) == -1, :) = [];

obs = checkNegatives(obs);

end

