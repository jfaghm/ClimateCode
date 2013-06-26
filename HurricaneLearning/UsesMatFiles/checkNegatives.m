function checked = checkNegatives( observations, showOutput )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2
    showOutput = true;
end

persistent hurricaneTracks
persistent hurricaneDateNums

% Load the hurricane track data
if isempty(hurricaneTracks)
    load('/export/scratch/haasken/HurDat/atlantic_storms_1851_2010.mat')
    hurricaneTracks = hurDat(:, 1:7);
    hurricaneDateNums = datenum(hurricaneTracks(:, 2:4));
    clear hurDat labels types
end

numObs = size(observations, 1);
goodObservations = true(numObs, 1);

for i = 1:numObs
    % Check if it is a positive observation
    if observations(i, 1) == 1
        continue
    % Otherwise it is a negative observation
    else
        % Get the year and date number of the current observation
        year = observations(i, 2);
        obsDateNum = datenum(year, 0, 0) + observations(i, 3);
        [obsYear, obsMonth, obsDay] = datevec(obsDateNum);
        assert(year == obsYear)
        % Get the location of the current observation
        lat = observations(i, 4);
        lon = observations(i, 5);
        
        % Use a logical mask to get the year's data
        yearMask = hurricaneTracks(:, 2) == year;
        yearStorms = hurricaneTracks(yearMask, :);
        yearDateNums = hurricaneDateNums(yearMask);
        
        % Calculate the days between the observation and each storm
        diffs = obsDateNum - yearDateNums;
        % Find any storms present on the same date as the observation
        matches = find(diffs == 0);
        
        for j = 1:size(matches, 1)
            currentMatch = yearStorms(matches(j), :);
            distance = greatCircleDistance(lat*pi/180, lon*pi/180, currentMatch(6)*pi/180, currentMatch(7)*pi/180);
            % replaced euclidean distance below with greatCircleDistance
            % distance = sum(([lat lon] - currentMatch(6:7)).^2)^0.5;
            if (distance < 400)
                
                if showOutput
                    % Print some information showing a discarded negative
                    fprintf('The storm at %.2f%sN, %.2f%sE on the date: %02d/%02d/%02d\n', ...
                        currentMatch(6), char(176), currentMatch(7), char(176), ...
                        currentMatch(3), currentMatch(4), currentMatch(2))
                    fprintf('was too close to the negative at %.2f%sN, %.2f%sE on the date: %02d/%02d/%02d.\n', ...
                        lat, char(176), lon, char(176), obsMonth, obsDay, obsYear)
                end
                
                % Set the negative to be a bad observation
                goodObservations(i) = false;
                
                % No need to continue examining possible matches
                break
            end
        end
        
    end
end

if showOutput
    fprintf('%d negatives were too close to another storm.\n', sum(~goodObservations))
end

checked = observations(goodObservations, :);

end

