function [ yearlyAverages ] = regionalMeans( data, dates, gridInfo, latlims, lonlims, startYear, endYear, months, varargin )
%REGIONALMEANS Gets the yearly regional means of a data set, with weighting
%
%   yearlyAverages = getMeanData( data, dates, gridInfo, latlims, lonlims, startYear, endYear, months )
%   yearlyAverages = getMeanData( data, dates, gridInfo, latlims, lonlims, startYear, endYear, months, weighted )
%
%   This function gets yearly regional means from the given data set. It
%   can use a single region or combine several disjoint regions.  It will
%   not work properly if the regions given are not disjoint.  It weights
%   the averages by multiplying each month's values by the number of days
%   in that month.  It can also weight by the area of each grid point using
%   the latitude of each point.
%
% --------------------------------- INPUT ---------------------------------
%
% --> data - The matrix of data, in which each slice contains the
% grid of data for a single month of a year.  The structure of the data
% grid is specified in gridInfo
% 
% --> dates - This is a vector of dates with length equal to size(data,3).
% The dates should be integers in the format YYYYMM, and the index of a
% date in dates should correspond to the index of that month's data in
% data.
% 
% --> gridInfo - A structure indicating the layout of the latitude and
% longitude grid.  It should have the following fields: northLimit,
% latStep, westLimit, lonStep.  Or it can simply have the fields lats and
% lons, which are the latitudes and longitudes of the rows and columns,
% respectively.
% 
% --> latlims - The latitude limits of the regions.  Each row should
% describe the north and south latitude limits of a region.  Degrees north
% should be positive, and degrees south should be negative.
% 
% --> lonlims - The longitude limits of the regions.  Each row should
% describe the West and East limits, in that order, with degrees East
% positive and degrees West negative.
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
% --> weighted - A boolean agrument indicating whether the averages should
% be weighted by area. It is an optional argument.  The default is true.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> yearlyAverages - The vector of yearly averages.  Each entry,
% yearlyAverages(i) is the average for the ith season in the range
% [startYear:endYear].  These averages are in the same units the as
% data and are weighted by the number of days in each month and
% possibly by the area of each point.

% Check input arguments for validity
p = inputParser;
p.addRequired('data', @(x)ndims(x) == 3);
p.addRequired('dates', @(x)isvector(x) && length(x) == size(sstMatrix, 3));
p.addRequired('gridInfo', @(x)isstruct(x) && ...
    ( all(ismember({'lats', 'lons'}, fieldnames(x))) || ...
    all(ismember({'northLimit', 'latStep', 'westLimit', 'lonStep'}, fieldnames(x))) ));
p.addRequired('latlims', @(x)ismatrix(x) && size(x, 2) == 2);
p.addRequired('lonlims', @(x)ismatrix(x) && size(x, 2) == 2);
p.addRequired('startYear', @isnumeric);
p.addRequired('endYear', @isnumeric);
p.addRequired('months', @(x)isvector(x) && length(x) <= 12 && sum(diff(x) < 0) <=1 && length(unique(x)) == length(x) ); 
p.addOptional('weighted', true, @islogical);
p.parse( sstMatrix, dates, gridInfo, latlims, lonlims, startYear, endYear, months, varargin{:} );
weighted = p.Results.weighted;

% Determine the number of regions to be averaged over
numRegions = size(latlims, 1);
% Make sure each region has latitude and longitude limits
if size(lonlims, 1) ~= numRegions
    error('The number of rows in latlims must match the number of rows in lonlims.\n')
end

[ rowIndices, colIndices ] = getMatrixIndices(latlims, lonlims, gridInfo);

% Sort the rowIndices so that they specifiy a proper range
rowIndices = sort(rowIndices, 2);

if weighted
    weightingMatrix = getWeightingMatrix(gridInfo);
end

if size(data, 3) ~= length(dates)
    error('The number of data grids should equal the number of dates given.\n')
end

[ hrDateNumbers daysPerMonth ] = getSeasonalDates(startYear, endYear, months);

numSeasons = size(hrDateNumbers, 2);
numMonths = size(hrDateNumbers, 1);

% Initialize variables to hold Data sums and number of points in regions
yearlySums = zeros(size(hrDateNumbers));
yearlyNumPoints = zeros(size(hrDateNumbers));

% Iterate through each region
for r = 1:numRegions
    
    % Grab starting and ending limits
    startRow = rowIndices(r, 1);
    endRow = rowIndices(r, 2);
    startCol = colIndices(r, 1);
    endCol = colIndices(r, 2);
    
    if startCol > endCol
        regionalData = data(startRow:endRow, [startCol:end 1:endCol], :);
        if weighted
            regionalWeight = weightingMatrix(startRow:endRow, [startCol:end 1:endCol], :);
        end
    else
        regionalData = data(startRow:endRow, startCol:endCol, :);
        if weighted
            regionalWeight = weightingMatrix(startRow:endRow, startCol:endCol, :);
        end
    end 
    
    for season = 1:numSeasons
        
        for month = 1:numMonths
            
            index = find(hrDateNumbers(month, season) == dates);
            
            if length(index) < 1
                yearlySums(:, season) = NaN;
                yearlyNumPoints(:, season) = NaN;
                break
            elseif length(index) > 1
                index = index(1);
            end
        
            % Get the Data grid for the current month and year
            region = regionalData(:, :, index);
            % Find the locations of the valid data
            validData = ~((region == -32768) | (region == -1000) | isnan(region));
            
            % Check if the Data should be weighted and weight it
            if weighted
                region = region .* regionalWeight;
            end
                
            % remove all the NaN values and make sure data is 1-dimensional
            region = region(validData);
            
            if weighted
                pointSum = sum(regionalWeight(validData));
            else
                pointSum = sum(sum(validData));
            end
            
            % Add sum of the region weighted by the number of days in the
            % month to the running sum for that month
            yearlySums(month, season) = yearlySums(month, season) + ...
                daysPerMonth(month, season)*sum(region);
            
            % Add the total weight for the current region and month to the
            % running total for all regions in this month
            yearlyNumPoints(month, season) = yearlyNumPoints(month, season) + ...
                pointSum;
             
        end
    end
end

% Divide each monthly sum by the number of data points accumulated
yearlyAverages = sum((yearlySums ./ yearlyNumPoints), 1) ./ sum(daysPerMonth, 1);

end

