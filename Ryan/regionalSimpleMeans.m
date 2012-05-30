function [ yearlyAverages ] = regionalSimpleMeans( sstMatrix, dates, gridInfo, latlims, lonlims, startYear, endYear, months )
%REGIONALSIMPLEMEANS Gets the yearly regional means of a data set, simply.
%
%   This function gets yearly regional means from a data set.  It does no
%   weighting by area of grid boxes or by number of days per month, thus
%   the "simple" moniker.a
%
% --------------------------------- INPUT ---------------------------------
%
% --> sstMatrix - The matrix of SST data, in which each slice contains the
% grid of SST data for a single month of a year.  The structure of the SST
% grid is specified in gridInfo.
% 
% --> dates - This is a vector of dates with length equal to size(sstMatrix,3).
% The dates should be integers in the format YYYYMM, and the index of a
% date in dates should correspond to the index of that month's data in
% sstMatrix.
% 
% --> gridInfo - A structure indicating the layout of the latitude and
% longitude grid.  It should have the fields lats and lons, which are just
% vectors of the latitude and longitude values of each row and column in
% the grid, respectively.  Alternatively (deprecated), it may have the
% following fields: northLimit, latStep, westLimit, lonStep.
% 
% --> latlims - The latitude limits of the region in degrees north.
% 
% --> lonlims - The longitude limits of the region in order from west to
% east. Units should be degrees east, so degrees west are negative.
% 
% --> startYear - The starting year of the averaging period.  Each season
% is specified by its ending year.  That is, if the starting season is
% December, 1999 - April, 2000, the startYear should be 2000.
% 
% --> endYear - The ending year of averaging period, follows the same
% convention as above for seasons spanning two years.
% 
% --> months - A vector of months which specifiy the season to be averaged.
% If the months are not strictly increasing, the function assumes that all
% months before the decrease belong to the previous year, and the months
% after the decrease belong to the current year.  Months should only
% decrease once, with months in the same year listed in increasing order.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> yearlyAverages - The vector of yearly averages.  Each entry,
% yearlyAverages(i) is the average for the ith season in the range
% [startYear:endYear].  These averages are in the same units the as
% sstMatrix.
% 

p = inputParser;
p.addRequired('sstMatrix', @(x)ndims(x) == 3);
p.addRequired('dates', @(x)isvector(x) && length(x) == size(sstMatrix, 3));
p.addRequired('gridInfo', @(x)isstruct(x) && ...
    ( all(ismember({'lats', 'lons'}, fieldnames(x))) || ...
    all(ismember({'northLimit', 'latStep', 'westLimit', 'lonStep'}, fieldnames(x))) ));
p.addRequired('latlims', @(x)isvector(x) && length(x) == 2);
p.addRequired('lonlims', @(x)isvector(x) && length(x) == 2);
p.addRequired('startYear', @isnumeric);
p.addRequired('endYear', @isnumeric);
p.addRequired('months', @(x)isvector(x) && length(x) <= 12 && sum(diff(x) < 0) <=1 && length(unique(x)) == length(x) ); 
p.parse( sstMatrix, dates, gridInfo, latlims, lonlims, startYear, endYear, months );

% Get the row and column indices from latitudes and longitudes
[ rowIndices, colIndices ] = getMatrixIndices(latlims, lonlims, gridInfo);

% Sort the rowIndices so that they specifiy a proper range
rowIndices = sort(rowIndices, 2);

if size(sstMatrix, 3) ~= length(dates)
    error('The number of SST grids should equal the number of dates given.\n')
end

% Get the year and month values for each season
[ hrDateNumbers, ~ ] = getSeasonalDates(startYear, endYear, months);

numSeasons = size(hrDateNumbers, 2);
numMonths = size(hrDateNumbers, 1);

% Initialize space to store averages for each month of each season
yearlyAverages = zeros(numMonths, numSeasons);

% Grab starting and ending limits
startRow = rowIndices(1);
endRow = rowIndices(2);
startCol = colIndices(1);
endCol = colIndices(2);

% Check if the region wraps around the edge of the data set
if startCol > endCol
    regionalSST = sstMatrix(startRow:endRow, [startCol:end 1:endCol], :);
else
    regionalSST = sstMatrix(startRow:endRow, startCol:endCol, :);
end

for season = 1:numSeasons
    
    for month = 1:numMonths
        
        index = find(hrDateNumbers(month, season) == dates);
        
        if length(index) < 1
            fprintf('Unable to find data for YYYYMM = %d.\n', hrDateNumbers(month, season))
            yearlyAverages(month, season) = NaN;
            break
        elseif length(index) > 1
            index = index(1);
        end
        
        region = regionalSST(:, :, index);
        
        yearlyAverages(month, season) = nanmean(region(:));
        
    end
end

% Compute the means for each year without weighting each month's value by
% the number of days in each month
yearlyAverages = nanmean(yearlyAverages, 1);

end