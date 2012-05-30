function [ corrHeatMap, bestBoxes ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations, gridInfo )
%CREATEHEATMAP Create a heat map of best correlation for SST vs storm counts
%
% [ corrHeatMap, bestBoxes ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations, gridInfo )
% 
%   Creates a matrix of the best correlations between each SST box and any
%   storm box.  Each correlation is located at the center of its associated
%   SST box.
%
% --------------------------------- INPUT ---------------------------------
%
% --> allBoxSST - A matrix of all the yearly box SST averages.  Each row
% should represent a single SST box.  The first four columns of each row
% should be the latitude and longitude limits of the box in that row in the
% following order:
%    [ latitude latitude longitude-west-limit longitude-east-limit]
% The order of the latitude limits does not matter as the maximum will be
% taken as the northern limit.
% NOTE: If any of the SST boxes have the same center, the function will
% give an error.
% 
% --> allBoxStorms - A matrix of all the yearly box storm counts.  Each row
% should be a single box with the first four columns being the latitude and
% longitude limits of that box as described above.
% 
% --> allCorrelations - A matrix of the correlations between each storm box
% and SST box.  Each entry, allCorrelations(i, j) is the correlation
% between the storm box at allBoxStorms(i, :) and the SST box at
% allBoxSST(j, :).
%
% --> gridInfo - A structure indicating the layout of the desired heat map
% grid.  It should have lats and lons fields which are the latitudes and
% longitudes of each row and each column respectively.
% 
% --------------------------------- OUTPUT ---------------------------------
%
% --> corrHeatMap - A matrix of all of the highest correlations found
% between each SST box and any storm box.  It is a blank X blank matrix
% with latitude as the rows and longitude as the columns.
% --> bestBoxes - A matrix of each SST box with its best storm box and the
% correlation between them.  The columns are laid out in the following
% order where lat/lon-limits are as described above in INPUT:
%    [ maximum-correlation SSTBox-lat/lon-limits StormBox-lat/lon-limits
%
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have allBoxSST and allBoxStorms from getAllBoxData and
% % getAllBoxStormCounts, respectively (see documentation of those functions
% % for more information.
% % Get the correlations between each storm count box and sst box
% allCorrelations = rowCorr(allBoxStorms(:, 5:end), allBoxSST(:, 5:end));
% % Set up a gridInfo structure to describe the desired grid
% gridInfo = struct('lats', 89.5:-1:-89.5, 'lons', [ 0.5:179.5 -179.5:-0.5])
% % Create the heat map and get the best boxes matrix indicating where each
% % best storm box came from for each SST box
% [ heatMap, bestBoxes ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations, gridInfo );
% % View the created heat map with imagesc
% imagesc(heatMap)
% 

numSSTBoxes = size(allBoxSST, 1);

numRows = length(gridInfo.lats);
numCols = length(gridInfo.lons);

corrHeatMap = NaN(numRows, numCols);
visitedLocations = false(numRows, numCols);
bestBoxes = zeros(numSSTBoxes, 9);

for s = 1:numSSTBoxes
    [maxCorr, maxInd] = max(allCorrelations(:, s));
    [row, col] = getMidRowCol(allBoxSST(s, 1:2), allBoxSST(s, 3:4), gridInfo);
    
    % Check if this location was already visited
    if (visitedLocations(row, col))
        fprintf( [ 'allBoxSST contains two or more boxes which share the same center on the given grid.\n' ...
            'Results may not be accurate.\n' ])
    end
    
    corrHeatMap(row, col) = maxCorr;
    visitedLocations(row, col) = true;
    
    % save most strongly correlated boxes
    bestBoxes(s, :) = [maxCorr, allBoxSST(s, 1:4) allBoxStorms(maxInd, 1:4)];
    
end

end