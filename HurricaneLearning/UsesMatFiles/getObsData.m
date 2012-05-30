function [ obsData ] = getObsData( observations, data )
%GETOBSDATA Gets the data for each observation.
%   Takes in observations and data and returns the data associated with
%   those observations in a matrix.  INPUT: observations - the 2d matrix
%   containing the date and location of positive and negative observations,
%   data - the data for a variable for a year and its previous and next
%   years in a cell array.  OUTPUT - the 2D array of data corresponding to
%   the observations given.  Each column is the observation at a different
%   time

% get the year of storms that is being processed, assumes first observation
% is positive (storm occurred)
assert(observations(1, 1) == 1);
year = observations(1, 2);

numObs = size(observations, 1);

% initialize the obsData matrix
obsData = zeros(numObs, 10);

% get the data for each observation
for i = 1:numObs
    
    if observations(i, 1) == -1
        continue
        
    else
        
        obsYear = observations(i, 2);
        
        % get the index into data (1 -> previous, 2 -> current, 3 -> next)
        dataIndex = obsYear - year + 2;
        
        % compute the day number relative to June 1st
        dayNum = observations(i, 3) - datenum(obsYear, 6, 1) + datenum(obsYear, 1, 1);
        
        % compute the starting and ending slots in the data array
        startSlot = 4*dayNum;
        endSlot = startSlot - 9; % goes back 10 time steps, 60 hr range
        
        outOfRange = 0;
        if endSlot < 1
            outOfRange = 1 - endSlot;
            endSlot = 1;
        end
        
        
        obsData(i, :) = [data{dataIndex}(observations(i, 6), startSlot:-1:endSlot) ...
            -1*ones(1, outOfRange)];
        
        
    end
    
end

end

