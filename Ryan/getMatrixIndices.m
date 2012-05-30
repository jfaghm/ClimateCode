function [ rowIndices, colIndices ] = getMatrixIndices( lats, lons, gridInfo )
%GETMATRIXINDICES Gets the matrix indices from the latitude/longitude
%
%   [ rowIndices, colIndices ] = getMatrixIndices( lats, lons, gridInfo )
%
%   This function gets the row and column indices into the matrix
%   representing latitude and longitude coordinates, which is laid out
%   according to gridInfo.
%
% --------------------------------- INPUT ---------------------------------
%
% --> lats - The latitudes vector to be converted into row indices
% --> lons - The longitudes vector to be converted into column indices
% --> gridInfo - A structure indicating the layout of the latitude and
% longitude grid.  It should have the following fields: northLimit,
% latStep, westLimit, lonStep.  Or it can have the fields lats and lons,
% which are just vectors of the latitude and longitude values of each row
% and column in the grid, respectively.
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> rowIndices - The row indices in the matrix.
% --> colIndices - The column indices in the matrix.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example gets the row and column indices in the reynolds sst data set of all storms
% % Load the storm data and the sst data (for the grid info)
% load /project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat
% load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% % Get the rows and columns from the lats and lons in the storm data
% [ rows, cols ] = getMatrixIndices( condensedHurDat(:, 6), condensedHurDat(:, 7), rGridInfo);
% 

if all(ismember({ 'northLimit', 'latStep', 'westLimit', 'lonStep' }, fieldnames(gridInfo)))
    gridInfoType = 'limits';
elseif all(ismember({ 'lats', 'lons' }, fieldnames(gridInfo)))
    gridInfoType = 'latlons';
else
    error('gridInfo structure must contain northLimit, latStep, westLimit, and lonStep fields\n or lats and lons fields.')
end

switch (gridInfoType)
    
    % The limits of the grid are given
    case 'limits'
        
        numRows = length( gridInfo.northLimit:-gridInfo.latStep:-90 );
        
        gridLons = [gridInfo.westLimit:gridInfo.latStep:180 gridInfo.westLimit:-gridInfo.latStep:-180];
        numCols = length(gridLons) - 1;
        if all(ismember([ 180 -180 ], gridLons))
            numCols = numCols - 1;
        end
        
        colIndices = round(mod(lons - gridInfo.westLimit, 360) / gridInfo.lonStep) + 1;
        colIndices(colIndices > numCols) = 1;
        
        rowIndices = round((gridInfo.northLimit - lats) / gridInfo.latStep) + 1;
        rowIndices(rowIndices < 1) = 1;
        rowIndices(rowIndices > numRows) = 180;
        
    % Vectors of the latitude and longitude values are given
    case 'latlons'
        
        % pdist2 always takes the first smallest element it encounters
        % Thus, if a value is halfway between two grid points, it takes the
        % one which occurs first in gridInfo.lats/lons.
        
        
        [~, rowIndices] = pdist2( reshape(gridInfo.lats, [], 1), reshape(lats, [], 1), 'euclidean', 'Smallest', 1);
        
        [colD, colIndices] = pdist2( reshape(gridInfo.lons, [], 1), reshape(lons, [], 1), 'euclidean', 'Smallest', 2);
        % Check if any lons are equidistant between first and last column
        colMask = [ true(1, size(colIndices, 2)); false(1, size(colIndices, 2)) ];
        equiDist = colD(1, :) == colD(2, :);
        edgePoints = (colIndices(2, :) == length(gridInfo.lons)) & (colIndices(1, :) == 1);
        colMask(:, equiDist & edgePoints) = ~colMask(:, equiDist & edgePoints);
        colIndices = colIndices(colMask)';
        
        
            
        
    otherwise
        
        error('Could not determine gridInfoType.')
        
end

end