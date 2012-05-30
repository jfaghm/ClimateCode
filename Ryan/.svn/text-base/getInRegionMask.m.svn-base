function inAnyRegion = getInRegionMask( locations, latlims, lonlims )
%GETINREGIONMASK Returns a mask of the locations that are in the regions
%
%   inAnyRegion = getInRegionMask( locations, latlims, lonlims )
%
%   Returns a logical mask indicating which locations are in one or more of
%   the regions given in latlims and lonlims.
%
% --------------------------------- INPUT ---------------------------------
%
% --> locations - A matrix of latitude and longitude locations.  The first
% column is the latitude in degrees North, and the second column is the
% longitude in degrees East.
% --> latlims - The latitude limits of the regions.  Each row should
% describe the north and south latitude limits of a region.  Degrees north
% should be positive, and degrees south should be negative.
% --> lonlims - The longitude limits of the regions.  Each row should
% describe the West and East limits, in that order, with degrees East
% positive and degrees West negative.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> inAnyRegion - A logical mask of the same length as locations that
% indicates whether each location is in one of the given regions or not
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example gets a mask indicating which storms occurred in
% the east atlantic region from 5 to 25 N and 45 to 15 W.
% % Load the storm data
% load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% % Grab the locations
% stormLocs = condensedHurDat(:, 6:7);
% % Set up EATL region limits
% latlims = [ 5 25 ]; lonlims = [ -45 -15 ];
% % Get a mask for all east atlantic storms
% inRegion = getInRegionMask(stormLocs, latlims, lonlims);
% % Extract all the east atlantic storms
% eatlStorms = condensedHurDat(inRegion, :);
% 

numRegions = size(latlims, 1);
if numRegions ~= size(lonlims, 1)
    error('The number of rows in lonlims must match the number of rows in latlims.\n')
end

inAnyRegion = false(numRegions, 1);

for reg = 1:numRegions

    if latlims(reg, 1) > latlims(reg, 2)
        latlims(reg, :) = latlims(reg, [2 1]);
    end
    withinLatLims = (locations(:, 1) <= latlims(reg, 2) & ...
        locations(:, 1) >= latlims(reg, 1));
    
    
    if lonlims(reg, 1) < lonlims(reg, 2)
        withinLonLims = (locations(:, 2) <= lonlims(reg, 2) & ...
            locations(:, 2) >= lonlims(reg, 1));
    else
        withinLonLims = (locations(:, 2) <= lonlims(reg, 2) | ...
            locations(:, 2) >= lonlims(reg, 1));
    end
    
    inAnyRegion = (withinLatLims & withinLonLims) | inAnyRegion;
    
end

end