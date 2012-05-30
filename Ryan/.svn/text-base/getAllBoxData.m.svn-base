function allBoxData = getAllBoxData( data, dates, gridInfo, dataLims, weighted )
%GETALLBOXDATA Gets yearly averages for each box specified.
%
%   allBoxData = getAllBoxData( data, dates, gridInfo, dataLims, weighted )
%
%   Gets the yearly (or seasonal) averages for each box within the
%   specified limits.
%
% ------------------------------ INPUT ------------------------------
%
% --> data - The gridded data to be averaged for each box.  Each slice
% should contain the gridded data for one month.
%
% --> dates - A vector of date numbers of the form YYYYMM.  This indicates
% the dates for each slice of data.  That is data(:, :, i) should be the
% data for the year and month at dates(i).
%
% --> gridInfo - A structure indicating the latitudes and longitudes of
% each row and column, respectively.  It should have fields lats and lons,
% which are lists of latitude and longitude values in degrees north and
% degrees east respectively.  The value at lats(i) should be the latitude
% of the ith row in data, and the value at lons(j) should be the longitude
% of the jth column in data.
% ***Important: Use units that are consistent with the lat/lon fields of
% dataLimits.  For example if degrees west are passed in as negative
% values in dataLimits, then do the same for gridInfo.lons.
%
% --> dataLimits - A structure indicating the limits of the boxes to be
% considered and the time range to be averaged over.  It should have north,
% south, east, west, step, minWidth, maxWidth, minHeight,
% maxHeight, months, startYear, and endYear fields.  The north, south,
% east, and west limits should be in degrees north and degrees east.  The
% *Width *Height and step fields should be in units of data grid boxes.
% Instead of min and max heights and widths, it may simply contain fields
% width and height which will be the only allowed heights and widths.
%
% --> weighted - An optional boolean argument indicating whether or not to
% weight the data averages based on latitude.  The default is to weight the
% averages.  True weights the averages, false does not.
%
% ------------------------------ OUTPUT ------------------------------
%
% --> allBoxData - The 2D matrix of the data averages for every possible
% box. The first two columns are the latitude limits of the box on that
% row. The second two columns are the longitude limits of the box on that
% row. The rest of the columns are the yearly data averages for the box on
% that row.  That is, each row is of the following form:
%
%   [ latLim1 latLim2 lonLimWest lonLimEast yearlyDataAverages ]
%
% **NOTE: The latitude and longitude values returned in allBoxData are
% pulled from gridInfo.lats and gridInfo.lons. This means that a box of
% height of 5 grid boxes on a 2x2 grid might have latlims of 8 and 16 since
% these indicate the centers of the upper and lower rows.  Thus, such a
% data box actually spans from 7 to 17.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Get data for all boxes ranging in width from 5 grid boxes to 10 grid
% % boxes and height equal to 5 grid boxes in the east atlantic region
% % Set up the dataLims structure
% dataLims = struct('west', -45, 'east', -10, 'north', 45, 'south', 5, ...
%      'minWidth', 5, 'maxWidth', 10, 'height', 5, 'step', 1, ...
%      'months', 6:10, 'startYear', 1971, 'endYear', 2010);
% % Load the ERV3SST data set
% load /project/expeditions/haasken/data/ERSST/ersstv3.mat
% % Get all the box SST means
% eatlBoxSST = getAllBoxData(erv3sst, erv3Dates, erv3GridInfo, dataLims);
% 
% % Now modify the dataLims structure to search various height boxes
% dataLims = rmfield(dataLims, 'height');
% dataLims.minHeight = 5; dataLims.maxHeight = 10;
% eatlBoxSST = getAllBoxData(erv3sst, erv3Dates, erv3GridInfo, dataLims);
% 

% -----------------------------------------------------------------------------
% Check the input structures for all necessary fields.
% -----------------------------------------------------------------------------

if ~all(ismember( {'lats', 'lons'}, fieldnames(gridInfo) ))
    error('gridInfo structure must have lats and lons fields.')
end
if all(ismember( {'north', 'south', 'east', 'west', 'step', 'months', 'startYear', 'endYear' }, ...
        fieldnames(dataLims) ))
    if (ismember('height', fieldnames(dataLims)))
        dataLims.minHeight = dataLims.height;
        dataLims.maxHeight = dataLims.height;
    end
    if (ismember('width', fieldnames(dataLims)))
        dataLims.minWidth = dataLims.width;
        dataLims.maxWidth = dataLims.width;
    end
    
    if ~all(ismember( {'minWidth', 'maxWidth', 'minHeight', 'maxHeight' }, ...
            fieldnames(dataLims) ))
        error('dataLimits must have all fields listed in function documentation')
    end
else
    error('dataLimits must have all fields listed in function documentation')
end

if nargin < 5
    weighted = true;
end

numCols = size(data, 2);
numYears = dataLims.endYear - dataLims.startYear + 1;

% -----------------------------------------------------------------------------
% Get closest rows and columns to the north, south, east, and west limits
% -----------------------------------------------------------------------------

[~, rows] = pdist2(reshape(gridInfo.lats, [], 1), [dataLims.north; dataLims.south], 'euclidean', 'Smallest', 1);
northRow = rows(1);
southRow = rows(2);

[~, cols] = pdist2(reshape(gridInfo.lons, [], 1), [dataLims.west; dataLims.east], 'euclidean', 'Smallest', 1);
westCol = cols(1);
eastCol = cols(2);

% Determine whether the west column is to the right of the east column
crossover = westCol > eastCol;

% -----------------------------------------------------------------------------
% A loop to determine the number of boxes needed for preallocation
% -----------------------------------------------------------------------------
numBoxes = 0;
for boxHeight = dataLims.minHeight:dataLims.step:dataLims.maxHeight
    for boxWidth = dataLims.minWidth:dataLims.step:dataLims.maxWidth
        
        % If the box limits cross the edge of the grid ...
        if crossover
            % get the eastern limit for the west edge of the box
            eastLimit = eastCol - boxWidth + 1;
            % limit may end up back on the original side of grid edge
            if eastLimit < 1
                % if so, wrap it back over the boundary
                westBounds = westCol:dataLims.step:(numCols+eastLimit);
            else
                westBounds = [ westCol:numCols 1:eastLimit ];
            end
        else
            % The box does not cross the edge of grid, compute normally
            westBounds = westCol:dataLims.step:(eastCol-boxWidth+1);
        end
        
        for boxWest = westBounds
            for boxNorth = northRow:dataLims.step:(southRow-boxHeight+1)
                numBoxes = numBoxes + 1;
            end
        end
    end
end

% Now preallocate matrices for the box limits
boxRowLimits = zeros(numBoxes, 2);
boxColLimits = zeros(numBoxes, 2);

% -----------------------------------------------------------------------------
% A loop to get just the box limits
% -----------------------------------------------------------------------------
countIndex = 0;
for boxHeight = dataLims.minHeight:dataLims.step:dataLims.maxHeight
    for boxWidth = dataLims.minWidth:dataLims.step:dataLims.maxWidth
        
        % If the box limits cross the edge of the grid ...
        if crossover
            % get the eastern limit for the west edge of the box
            eastLimit = eastCol - boxWidth + 1;
            % limit may end up back on the original side of grid edge
            if eastLimit < 1
                % if so, wrap it back over the boundary
                westBounds = westCol:dataLims.step:(numCols+eastLimit);
            else
                westBounds = [ westCol:numCols 1:eastLimit ];
            end
        else
            % The box does not cross the edge of grid, compute normally
            westBounds = westCol:dataLims.step:(eastCol-boxWidth+1);
        end
        
        for boxWest = westBounds
            for boxNorth = northRow:dataLims.step:(southRow-boxHeight+1)
                
                countIndex = countIndex + 1;
                boxRowLimits(countIndex, :) = [boxNorth boxNorth+boxHeight-1];
                
                boxEast = mod(boxWest + boxWidth - 1, numCols);
                if boxEast == 0
                    boxEast = numCols;
                end
                boxColLimits(countIndex, :) = [boxWest boxEast];
                
            end
        end
    end
end

% -----------------------------------------------------------------------------
% Get the dates and number of days per month for each season
% -----------------------------------------------------------------------------
[ seasonDates, daysPerMonth ] = getSeasonalDates(dataLims.startYear, dataLims.endYear, dataLims.months);
[~, monthIndices] = ismember(seasonDates, dates);

% Initialize the matrix for the means of each box
allBoxMeans = zeros(numBoxes, numYears);

% -----------------------------------------------------------------------------
% Get the mean of the data for each of the boxes (consider parallelizing)
% -----------------------------------------------------------------------------

parfor box = 1:numBoxes
    
    % Get the annual means for each month
    boxMeans = getBoxMeans( data, gridInfo, monthIndices, daysPerMonth, boxRowLimits(box, :), boxColLimits(box, :), weighted );
    
    % Save it in allBoxMeans
    allBoxMeans(box, :) = boxMeans;
    
end

% -----------------------------------------------------------------------------
% Group together the box limits and the means to return them
% -----------------------------------------------------------------------------
allBoxData = [ gridInfo.lats(boxRowLimits) gridInfo.lons(boxColLimits) allBoxMeans ];


end

