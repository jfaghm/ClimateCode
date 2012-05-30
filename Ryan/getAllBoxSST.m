function [ allBoxSST ] = getAllBoxSST( sstLims, sstData, dates, gridInfo )
%GETALLBOXSST Gets mean SST for each possible box.
% ***Deprecated*** use getAllBoxMeans instead
%   allBoxSST = getAllBoxSST( sstLims, sstData, dates, gridInfo )
%
%   Gets the mean SST for each possible box specified by the sstLims
%   structure for the time period specified by the sstLims structure.
%
% ------------------------------INPUT------------------------------
% 
% --> sstLims - A structure specifiying the limits of the sst boxes to
% consider.  It should have the following fields:
%
%    north, south, east, west, minWidth, minHeight, maxWidth, maxHeight,
%    step, months, startYear, endYear
%
% These field names are case sensitive.  The north, south, east, and west
% fields indicate the corresponding limits for the box edges.  min/max
% width/height indicate the minimum and maximum widths and heights of any
% possible box.  months, startYear and endYear indicate the time range to
% average for each box.  These fields are passed to getMeanSST; see that
% function's documentation for more information.  The step field indicates
% the amount by which each box parameter is increased on each iteration
% through that parameter.
%
% --> sstData - The 3D matrix of SST data in which each slice contains data
% for one month.
% --> dates - The vector of human-readable date numbers used for looking up
% the location of a given date in the sstData matrix.  The format of each
% date number should be YYYYMM, which is (year*100 + month)
% --> gridInfo - A structure indicating the layout of the latitude and
% longitude grid.  It should have the following fields: northLimit,
% latStep, westLimit, lonStep.
%
% ------------------------------OUTPUT------------------------------
%
% --> allBoxSST - The 2D matrix of the SST averages for every possible box.
% The first two columns are the latitude limits of the box on that row.
% The second two columns are the longitude limits of the box on that row.
% The rest of the columns are the yearly SST averages for the box on that
% row.  That is, each row is of the following form:
%
%   [ latLim1 latLim2 lonLimWest lonLimEast yearlySSTAverages ]
%

if ~( all ( ismember( { 'north', 'south', 'east', 'west', 'minWidth', 'minHeight', ...
        'maxWidth', 'maxHeight', 'step', 'months', 'startYear', 'endYear' } , ...
        fieldnames(sstLims) ) ) )
    error('sstLims does not contain all required fields.')
else
    months = sstLims.months;
    startYear = sstLims.startYear;
    endYear = sstLims.endYear;
end

numYears = endYear - startYear + 1;

% Check whether the box limits cross the 180th meridian
crossover = sstLims.west > sstLims.east;

% These loops simply count the number of boxes within the limits
numBoxes = 0;
for sstBoxHeight = sstLims.minHeight:sstLims.step:sstLims.maxHeight
    for sstBoxWidth = sstLims.minWidth:sstLims.step:sstLims.maxWidth
        
        % If the box limits cross the 180th meridian ... 
        if crossover
            % get the eastern limit for the west edge of the box
            eastLimit = sstLims.east - sstBoxWidth + 1;
            % limit may end up back on the original side of meridian
            if eastLimit <= -180
                % if so, wrap it back over the boundary
                westBounds = sstLims.west:sstLims.step:(360+eastLimit);
            else
                % make limits specify a proper range
                westBounds = sstLims.west:sstLims.step:(eastLimit+360);
                needShifting = westBounds > 180;
                % shift back the values which are out of range
                westBounds(needShifting) = westBounds(needShifting) - 360;
            end
        else
            % The box does not cross 180th meridian, compute normally
            westBounds = sstLims.west:sstLims.step:sstLims.east-sstBoxWidth+1;
        end
            
        for sstWest = westBounds
            for sstNorth = sstLims.south+sstBoxHeight-1:sstLims.step:sstLims.north
                numBoxes = numBoxes + 1;
            end
        end
    end
end

% Now we can preallocate the space for storing each boxes limits
sstLatLims = zeros(numBoxes, 2);
sstLonLims = zeros(numBoxes, 2);

countIndex = 0;

% Populate the box limits with all possible boxes
for sstBoxHeight = sstLims.minHeight:sstLims.step:sstLims.maxHeight
    for sstBoxWidth = sstLims.minWidth:sstLims.step:sstLims.maxWidth
        % If the box limits cross the 180th meridian ...
        if crossover
            % get the eastern limit for the west edge of the box
            eastLimit = sstLims.east - sstBoxWidth + 1;
            % limit may end up back on the original side of meridian
            if eastLimit <= -180
                % if so, wrap it back over the boundary
                westBounds = sstLims.west:sstLims.step:(360+eastLimit);
            else
                % make limits specify a proper range
                westBounds = sstLims.west:sstLims.step:(eastLimit+360);
                needShifting = westBounds > 180;
                % shift back the values which are out of range
                westBounds(needShifting) = westBounds(needShifting) - 360;
            end
        else
            % The box does not cross 180th meridian, compute normally
            westBounds = sstLims.west:sstLims.step:sstLims.east-sstBoxWidth+1;
        end
        
        for sstWest = westBounds
            for sstNorth = sstLims.south+sstBoxHeight-1:sstLims.step:sstLims.north
                
                countIndex = countIndex + 1;
                
                sstLatLims(countIndex, :) = [sstNorth sstNorth-sstBoxHeight+1];
                
                sstEast = sstWest+sstBoxWidth-1;
                if sstEast > 180
                    sstEast = sstEast-360;
                end
                sstLonLims(countIndex, :) = [sstWest sstEast];

            end
        end
    end
end

% Check if a matlabpool is opened and if not, open one
try
    matlabpool('open', 8);
    poolOpened = true;
catch
    poolOpened = false;
end

sstAvgs = zeros(numBoxes, numYears);

% Use a parallel for loop to get the mean sst of each possible box
parfor box = 1:numBoxes
    
    lats = sstLatLims(box, :);
    lons = sstLonLims(box, :);

    sstAvgs(box, :) = getMeanSST( sstData, dates, gridInfo, lats, lons, startYear, endYear, months, true );
    
end

allBoxSST = [ sstLatLims sstLonLims sstAvgs ];

if poolOpened
    matlabpool('close')
end
    
end

