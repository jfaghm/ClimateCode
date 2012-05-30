function [ midLat, midLon ] = getMidLatLon( latlims, lonlims )
%GETMIDLATLON Gets the middle latitude and longitude.
%   
% [ midLat, midLon ] = getMidLatLon( latlims, lonlims )
% 
% Get the middle latitude and longitude of the two input latitude and
% longitude values.
% 
% ----------------------------- INPUT -----------------------------
% 
% --> latlims - A 2-column matrix indicating the northern and southern
% latitude limits of each region
% 
% --> lonlims - A 2-column matrix indicating the eastern and western
% longitude limits of each region
% 
% ----------------------------- OUTPUT -----------------------------
% 
% --> midLat - A column vector of middle latitudes of each region
% 
% --> midLon - A column vector of middle longitudes of each region
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example gets the middle latitude and longitude of each box
% % Assume we have allBoxSST from getAllBoxData
% [ midLats midLons ] = getMidLatLon(allBoxSST(:, 1:2), allBoxSST(:, 3:4));
% 

% Compute the middle latitude simply by using a mean
midLat = mean(latlims, 2);

% Preallocate the middle longitudes array
midLon = zeros(size(lonlims, 1), 1);

% Compute half the distance between each pair of longitude limits
midDist = mod(diff(lonlims, [], 2), 360) / 2;

% Check if the west edge of each limit is far enough from the 180th
% meridian to add the halfway distance to it
westFarEnough = ( 180 - lonlims(:, 1) ) >= midDist;

% Add the halfway distance to each west longitude which is far enough west
if any(westFarEnough)
    midLon(westFarEnough) = lonlims(westFarEnough, 1) + midDist(westFarEnough);
end

% For the others, subtract the half distance from the east longitude
if any(~westFarEnough)
    midLon(~westFarEnough) = lonlims(~westFarEnough, 2) - midDist(~westFarEnough);
end

end

