function flattened = flattenData( dataSet )
% FLATTENDATA - Puts a 3D data matrix into 2D
% 
% flattened = flattenData( dataSet )
% 
% ------------------------------INPUT------------------------------
% 
% --> dataSet: A 3-dimensional data matrix where each row and column is a
% location, and dataSet(i, j, :) is a time series of data for that
% location.
% 
% ------------------------------OUTPUT------------------------------
%
% --> flattened: Each row contains a time series for a single location.
% The time series for each location are laid out in column major order.
%
% ----------------------------- EXAMPLES -----------------------------
% 
% % Flatten the reynolds SST data set
% flattened = flattenData( reynoldsSST );
% 

numRows = size(dataSet, 1);
numCols = size(dataSet, 2);

flattened = zeros(numRows * numCols, size(dataSet, 3));

for col = 1:numCols
    for row = 1:numRows
        flattened( (col-1)*numRows + row, : ) = permute( dataSet(row, col, :), [ 1 3 2 ] );
    end
end

end