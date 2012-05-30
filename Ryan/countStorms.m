function stormCounts = countStorms(storms, startYear, endYear, months, latlims, lonlims)
%COUNTSTORMS Gets the storm counts for each year in the given region(s)
%
% stormCounts = countStorms(storms, startYear, endYear, months, latlims, lonlims)
% 
%   This function counts the number of storms which occur in one or more of
%   the given regions in each season from the season ending in startYear to
%   the season ending in endYear.
% 
% --------------------------------- INPUT ---------------------------------
%
% --> storms - A matrix containing all relevant storm data. It should have
% columns in the following order: year, month, lat, lon.  Each row should be
% the year, month, latitude (in degrees North), and longitude (in degrees
% East) of each storm to be considered.
% --> startYear - The beginning of the year range to consider.
% --> endYear - The end of the year range to consider.
% --> months - A vector of months to count storms for.  The month range may
% span one or two years (e.g. December-April).  However, it must only
% decrease once, which indicates the point at which the new year begins.
% Each month is associated with the ending year of its season.
% --> latlims - The latitude limits of the regions.  Each row should
% describe the north and south latitude limits of a region.  Degrees north
% should be positive, and degrees south should be negative.
% --> lonlims - The longitude limits of the regions.  Each row should
% describe the West and East limits, in that order, with degrees East
% positive and degrees West negative.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> stormCounts - A vector of storm counts which took place in the
% regions given for each year. The ith element of stormCounts is the number
% of storms which took place in the ith year in the range
% [startYear:endYear].
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Load the storm data and take relevant columns
% load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% storms = condensedHurDat(:, [ 1 2 6 7 ]);
% 
% % Count the number of storms occuring in the North Indian Ocean during
% % the its storm season (April-May, September-November from 1970-2000:
% nioCounts = countStorms(stormData, 1970, 2000, [4 5 9:11], [5 20], [55 90]);
%
% % Count the number of storms occurring in the Atlantic Basin during its
% % storm season from June-October for 1900-2010
% atlCounts = countStorms(stormData, 1900, 2010, 6:10, [5 25], [-90 -20]);
% 
% % Count the number of storms occuring in the southwest Pacific Ocean during
% % its season (Dec-Apr) from 1950-2000
% spacCounts = countStorms(stormData, 1950, 2000, [12 1:4], [-5 -20], [155 180]);
% 

overlapLocation = find(diff(months) < 0);
if isempty(overlapLocation)
    yearOverlap = false;
elseif length(overlapLocation) > 1
    error('There should only be one decrease in the months vector.\n')
else
    yearOverlap = true;
end

if yearOverlap
    % Get all the storms in the year limits in either part of the season
    relevantStorms = storms( ... 
        ( storms(:, 1) >= startYear-1 & storms(:, 1) <= endYear-1 ...
        & ismember(storms(:, 2), months(1:overlapLocation)) ) ...
        | ...
        ( storms(:, 1) >= startYear & storms(:, 1) <= endYear & ...
        ismember(storms(:, 2), months(overlapLocation+1:end)) ), :);
else
    % Get all the storms in the year limit within the given months
    relevantStorms = storms( storms(:, 1) >= startYear & storms(:, 1) <= endYear & ...
        ismember(storms(:, 2), months), : );
end
    
% Get a mask indicating which storms are in any of the given regions
inAnyRegion = getInRegionMask(relevantStorms(:, 3:4), latlims, lonlims);

% Mask out storms which are not in the given regions
relevantStorms = relevantStorms(inAnyRegion, :);

numYears = endYear - startYear + 1;
stormCounts = zeros(1, numYears);

% Check if a storm season was specified that spans from one year into the
% next year (e.g. November-April)
if yearOverlap
    % Count the number of storms in each season
    for year = startYear:endYear
        stormCounts(year-startYear+1) = sum(relevantStorms(:, 1) == year-1 & ...
            ismember(relevantStorms(:, 2), months(1:overlapLocation))) + ...
            sum(relevantStorms(:, 1) == year & ... 
            ismember(relevantStorms(:, 2), months(overlapLocation+1:end)));
    end
else
    % Count the number of storms in each season
    for year = startYear:endYear
        stormCounts(year-startYear+1) = sum(relevantStorms(:, 1) == year);
    end
end

end