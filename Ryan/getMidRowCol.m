function [ midRow, midCol ] = getMidRowCol( latlims, lonlims, gridInfo )
%GETMIDROWCOL Gets the middle row and column from a lat/long box
%
%   This function gets the middle row and column from a given latitude and
%   longitude box.  The row and column returned is the approximate middle
%   of that box in a 1-degree grid centered on the prime meridian
%
% --------------------------------- INPUT ---------------------------------
%
% --> latlims - The north and south latitude limits of the region(s) to find
% the middle of.  Each region should be its own row.
% --> lonlims - The west and east longitude limits (in that order) of the
% region(s) to find the middle of.  Each region should be its own row.
% --> gridInfo - A structue indicating the layout of the grid being used to
% represent latitude and longitude points.  It should have the following
% fields: northLimit, latStep, westLimit, lonStep.  Or it can have lats and
% lons fields which are just the latitude and longitude values of each row
% and column.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> midRow - The middle row in the lat/lon matrix for each region.
% --> midCol - The middle column in the lat/lon matrix for each region.
% 
% NOTE: midRow and midCol each have the same number of rows as latlims and
% lonlims, respectively.
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example gets the middle row and column of each box in reynolds grid 
% % Assume we have allBoxSST from getAllBoxData
% [ midRows midCols ] = getMidRowCol(allBoxSST(:, 1:2), allBoxSST(:, 3:4), rGridInfo);
% 

% First get the middle latitude and longitude
[midLat midLon] = getMidLatLon(latlims, lonlims);

% Then convert to the row and column
[midRow midCol] = getMatrixIndices(midLat, midLon, gridInfo);

end