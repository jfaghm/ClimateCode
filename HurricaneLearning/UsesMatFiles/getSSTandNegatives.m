function sstAndNegatives = getSSTandNegatives( storms, indices, tempThreshold )
%GETYEARDATA Gets the data for all storms in a year
%   This function gets all the data for each storm in a year.  This
%   includes the negative observations for each storm.  It takes in a
%   storms matrix which is the year, month, day, and location of each storm
%   in a year.  It also takes in indices, which is column major index of
%   the nearest grid point to each storms location on the gaussian grid
%   that the variables are stored in.

% grab the year being processed from the first storm
year = storms(1, 1);

sstData = loadData(year, 'sst');

if nargin < 3
    tempThreshold = Inf;
end

observations = getNegatives(storms, indices, sstData, tempThreshold);

% Right here I may be able to get the surrounding locations ... 
obsWithSurround = addSurrounding(observations);

sstObs = getObsData(obsWithSurround, sstData);

%sstAndNegatives = [observations(:, [ 1 3:5 ]) sstObs];
sstAndNegatives = [obsWithSurround(:, 1:6) sstObs];

end