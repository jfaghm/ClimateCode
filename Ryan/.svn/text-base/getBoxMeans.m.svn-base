function boxMeans = getBoxMeans( data, gridInfo, monthIndices, daysPerMonth, rows, cols, weighted )
% GETBOXMEANS Gets the yearly means of the data.
% 
% boxMeans = getBoxMeans( data, gridInfo, monthIndices, daysPerMonth, rows, cols, weighted )
% 
% ------------------------------- INPUT -------------------------------
% 
% --> data - The 3D data matrix, where each slice represents one month of
% one year.
% 
% --> gridInfo - A structure with lats and lons fields indicating the
% latitude and longitude values of each row and column.
% 
% --> monthIndices - A 2D matrix where each column has the indices of the
% slices of data to be taken for each year.  Each row is a month, and each
% column is a year, so the entry at monthIndices(i, j) is the index of the
% slice of data corresponding to the ith month of the jth year.
% 
% --> daysPerMonth - A 2D matrix in which daysPerMonth(i, j) indicates the
% number of days in the ith month of the jth year.
% 
% --> rows - A 2-element vector indicating the start and end rows to
% average the data over.
% 
% --> cols - A 2-element vector indicating the start and end columns to
% average the data over.
% 
% --> weighted - A boolean indicating whether or not to weight the averages
% by the area of each grid on the earth.
% 
% ------------------------------- OUTPUT -------------------------------
% 
% --> boxMeans - A 2D matrix where each row contains the yearly means for a
% single box in the following format:
% 
%  [ boxLatLims boxLonLims boxMeans ]
% 
% ----------------------------- EXAMPLES -----------------------------
%  *** Note that this function is not meant for simplicity, but rather for
%  better performance within getAllBoxData.  See regionalMeans and
%  regionalSimpleMeans for another option. ***
% 
% % In this example, we get the Jun-Oct yearly mean sst for the atlantic
% % Load the ERSSTV3 sst data
% load /project/expeditions/haasken/data/ERSST/ersstv3.mat
% % Get the seasonal dates for 1971-2010, June-October season
% [ seasonDates, daysPerMonth ] = getSeasonalDates(1971, 2010, 6:10);
% % Get indices which point to the proper slice of the data set for each month
% [~, monthIndices ] = ismember(seasonDates, erv3Dates);
% % Get the row and column indices for the atlantic region
% [ rows, cols ] = getMatrixIndices([ 5 20], [ -100 -10 ], erv3GridInfo)
% % Finally, call the function to get the means
% boxMeans = getBoxMeans( erv3sst, erv3GridInfo, monthIndices, daysPerMonth, rows, cols)
% 

if nargin < 7
    % weighted by default
    weighted = true;
end

% Grab the current box's edge limits
rows = sort(rows);
northRow = rows(1);
southRow = rows(2);
westCol = cols(1);
eastCol = cols(2);

% If box crosses the edge of the gridded data
if westCol > eastCol
    boxData = data(northRow:southRow, [ westCol:end 1:eastCol ], :);
else
    % box does not cross the edge of the grid
    boxData = data(northRow:southRow, westCol:eastCol, :);
end

if weighted
    % Get a column of the weights of each latitude in the region
    weightColumn = cos( (gridInfo.lats(northRow:southRow)) * pi/180 )';
    % Make this column into a matrix the size of the regional data
    weightMatrix = repmat(weightColumn, 1, size(boxData, 2));
end

numSeasons = size(monthIndices, 2);
numMonths = size(monthIndices, 1);

yearlyNumPoints = zeros(numMonths, numSeasons);
yearlySums = zeros(numMonths, numSeasons);

for season = 1:numSeasons
    
    for month = 1:numMonths
        
        if ~monthIndices(month, season)
            monthData = NaN( size(boxData, 1), size(boxData, 2));
        else
            if weighted
                % multiply month's data by weighting matrix
                monthData = boxData(:, :, monthIndices(month, season)) .* weightMatrix;
            else
                monthData = boxData(:, :, monthIndices(month, season));
            end
        end
            
        % Get a mask indicating valid data locations
        validData = ~isnan(monthData);
        
        if weighted
            % if weighted, sum total valid weight
            yearlyNumPoints(month, season) = sum(weightMatrix(validData));
        else
            % otherwise sum total valid points
            yearlyNumPoints(month, season) = sum(validData(:));
        end
        
        % Weight the month's sum by the number of days in a month
        yearlySums(month, season) = sum(monthData(validData)) * daysPerMonth(month, season);
        
    end
end

% Divide each monthly sum by the number of data points accumulated and
% then divide by the number of days in each season
boxMeans = sum((yearlySums ./ yearlyNumPoints), 1) ./ sum(daysPerMonth, 1);

end