function [ allStormCounts ] = getAllBoxStormCounts( stormLims, storms )
%GETALLBOXSTORMCOUNTS Gets all the storm counts for all possible boxes
%
%   allStormCounts = getAllBoxStormCounts( stormLims, storms )
%
%   Gets the yearly storm counts for each possible box specified by the
%   stormLims structure for the time period specified by the stormLims
%   structure.
%
% ------------------------------INPUT------------------------------
% 
% --> stormLims - A structure specifiying the limits of the storm boxes to
% consider.  It should have the following fields:
%
%    north, south, east, west, minWidth*, minHeight*, maxWidth*, maxHeight*,
%    step, months, startYear, endYear
% 
% *Instead of min and max heights and widths, it may simply contain fields
% width and height which will be the only allowed heights and widths.
%
% These field names are case sensitive.  The north, south, east, and west
% fields indicate the corresponding limits for the box edges.  min/max
% width/height indicate the minimum and maximum widths and heights of any
% possible box.  months, startYear and endYear indicate the time range to
% average for each box.  These fields are passed to countStorms; see that
% function's documentation for more information.  The step field indicates
% the amount by which each box parameter is increased on each iteration
% through that parameter.
%
% --> storms - Storm data set.  It should have the following columns on
% each row for each storm: [ year, month, latitude, longitude ]
% 
% ------------------------------OUTPUT------------------------------
%
% --> allStormCounts - The 2D matrix of the storm counts for every possible box.
% The first two columns are the latitude limits of the box on that row.
% The second two columns are the longitude limits of the box on that row.
% The rest of the columns are the yearly storm counts for the box on that
% row.  That is, each row is of the following form:
%
%   [ latLim1 latLim2 lonLimWest lonLimEast yearlyStormCounts ]
%
% ----------------------------- EXAMPLES -----------------------------
% 
% % Get the storm counts for all boxes in the atlantic ocean with height 10
% % and width ranging from 20 to 40 degrees longitude
% % Set up the stormLims structure
% stormLims = struct('west', -100, 'east', -10, 'north', 45, 'south', 5, ...
%      'minWidth', 20, 'maxWidth', 40, 'height', 10, 'step', 1, ...
%      'months', 6:10, 'startYear', 1971, 'endYear', 2010);
% % Load the atlantic storm data and get year, month, lat, lon in a matrix
% load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% storms = condensedHurDat(:, [ 1 2 6 7 ]);
% % Get all the box storm counts
% boxStorms = getAllBoxStormCounts(stormLims, storms);
% 
% % Now modify the stormLims structure to get various height boxes
% stormLims = rmfield(stormLims, 'height');
% stormLims.minHeight = 10; stormLims.maxHeight = 20;
% boxStorms2 = getAllBoxStormCounts(stormLims, storms);
% 

% Check validity of stormLims data structure
if all(ismember( {'north', 'south', 'east', 'west', 'step', 'months', 'startYear', 'endYear' }, ...
        fieldnames(stormLims) ))
    
    % Unpack months, startYear, and endYear
    months = stormLims.months;
    startYear = stormLims.startYear;
    endYear = stormLims.endYear;
    
    if (ismember('height', fieldnames(stormLims)))
        stormLims.minHeight = stormLims.height;
        stormLims.maxHeight = stormLims.height;
    end
    if (ismember('width', fieldnames(stormLims)))
        stormLims.minWidth = stormLims.width;
        stormLims.maxWidth = stormLims.width;
    end
    
    if ~all(ismember( {'minWidth', 'maxWidth', 'minHeight', 'maxHeight' }, ...
            fieldnames(stormLims) ))
        error('stormLims must have all fields listed in function documentation')
    end
else
    error('stormLims must have all fields listed in function documentation')
end

% Check whether the box limits cross the 180th meridian
crossover = stormLims.west > stormLims.east;

numYears = endYear - startYear + 1;

numBoxes = 0;
% These loops simply count the number of boxes within the limits
for stormBoxHeight = stormLims.minHeight:stormLims.step:stormLims.maxHeight
    for stormBoxWidth = stormLims.minWidth:stormLims.step:stormLims.maxWidth
        % If the box limits cross the 180th meridian ...
        if crossover
            % get the eastern limit for the west edge of the box
            eastLimit = stormLims.east - stormBoxWidth + 1;
            % limit may end up back on the original side of meridian
            if eastLimit <= -180
                % if so, wrap it back over the boundary
                westBounds = stormLims.west:stormLims.step:(360+eastLimit);
            else
                % make limits specify a proper range
                westBounds = stormLims.west:stormLims.step:(eastLimit+360);
                needShifting = westBounds > 180;
                % shift back the values which are out of range
                westBounds(needShifting) = westBounds(needShifting) - 360;
            end
        else
            % The box does not cross 180th meridian, compute normally
            westBounds = stormLims.west:stormLims.step:stormLims.east-stormBoxWidth+1;
        end
        
        for stormWest = westBounds
            for stormNorth = stormLims.south+stormBoxHeight-1:stormLims.step:stormLims.north
                
                numBoxes = numBoxes + 1;
                
            end
        end
    end
end

% Now we can preallocate the space for storing each boxes limits
latLims = zeros(numBoxes, 2);
lonLims = zeros(numBoxes, 2);
countIndex = 0;

% Populate the box limits with all possible boxes
for stormBoxHeight = stormLims.minHeight:stormLims.step:stormLims.maxHeight
    for stormBoxWidth = stormLims.minWidth:stormLims.step:stormLims.maxWidth
        % If the box limits cross the 180th meridian ...
        if crossover
            % get the eastern limit for the west edge of the box
            eastLimit = stormLims.east - stormBoxWidth + 1;
            % limit may end up back on the original side of meridian
            if eastLimit <= -180
                % if so, wrap it back over the boundary
                westBounds = stormLims.west:stormLims.step:(360+eastLimit);
            else
                % make limits specify a proper range
                westBounds = stormLims.west:stormLims.step:(eastLimit+360);
                needShifting = westBounds > 180;
                % shift back the values which are out of range
                westBounds(needShifting) = westBounds(needShifting) - 360;
            end
        else
            % The box does not cross 180th meridian, compute normally
            westBounds = stormLims.west:stormLims.step:stormLims.east-stormBoxWidth+1;
        end
        
        for stormWest = westBounds
            for stormNorth = stormLims.south+stormBoxHeight-1:stormLims.step:stormLims.north
                
                countIndex = countIndex + 1;
                
                latLims(countIndex, :) = [stormNorth stormNorth-stormBoxHeight+1];
                
                stormEast = stormWest+stormBoxWidth-1;
                if stormEast > 180
                    stormEast = stormEast-360;
                end
                
                lonLims(countIndex, :) = [stormWest stormEast];
                
            end
        end
    end
end

boxCounts = zeros(numBoxes, numYears);

% Check if a matlabpool is opened and if not, open one
try
    matlabpool('open', 8);
    poolOpened = true;
catch
    poolOpened = false;
end

% Use a parallel loop to get the mean sst of each possible box
parfor b = 1:numBoxes
    
    lats = latLims(b, :);
    lons = lonLims(b, :);
    
    boxCounts(b, :) = countStorms(storms, startYear, endYear, months, ...
        lats, lons);
end

if poolOpened
    matlabpool('close')
end
    
allStormCounts = [ latLims lonLims boxCounts ];

end