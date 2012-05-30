function griddedBoxVals = gridBoxValues( values, boxes, gridInfo )
%GRIDBOXVALUES Creates a grid of the data in boxes.
% 
% This function creates a grid of the values associated with the boxes by
% putting the value associated with each box at the center of the box.
% 
% ------------------------------- INPUT -------------------------------
% 
% --> values: a vector of values associated with the boxes
% --> boxes: the boxes to place on a grid [lat1 lat2 westLon eastLon]
% --> gridInfo: A struct with lats and lons specifiying desired grid
% 
% ------------------------------- OUTPUT ------------------------------
% 
% --> griddedBoxVals: A grid with structure specified by gridInfo and with
% the values from the boxes in the appropriate spots on the grid
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have 10x10 sst boxes in allBoxSST and their trends
% griddedBoxVals = gridBoxValues( boxTrends, allBoxSST(:, 1:4), gridInfo );
% 


numDataBoxes = size(boxes, 1);

griddedBoxVals = NaN(length(gridInfo.lats), length(gridInfo.lons));

for i = 1:numDataBoxes
    
    [ midRow, midCol ] = getMidRowCol( boxes(i, 1:2), boxes(i, 3:4), gridInfo );
    
    griddedBoxVals(midRow, midCol) = values(i);
    
end

end 