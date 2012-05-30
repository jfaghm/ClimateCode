function [ weightMatrix ] = getWeightingMatrix( gridInfo )
%GETWEIGHTINMATRIX Gets the weighting matrix for a grid
% 
% This function returns a matrix with values between 0 and 1 indicating the
% weight that should be given to each grid box in a grid specified by
% gridInfo when computing means of global variables
% 
% --------------------------------- INPUT ---------------------------------
% 
% --> gridInfo - A structure indicating the layout of the latitude and
% longitude grid.  It should have the following fields: northLimit,
% latStep, westLimit, lonStep.  Or it can have the fields lats and lons,
% which are just vectors of the latitude and longitude values of each row
% and column in the grid, respectively.
% 
% --------------------------------- OUTPUT ---------------------------------
% 
% --> weightMatrix - A matrix with the number of rows and columns specified
% by gridInfo.  The matrix indicates the weight to be applied to each grid
% point, which is just the cosine of the latitude (in radians) of that grid
% point.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Get the weighting matrix for the reynold's data set
% [ weightMatrix ] = getWeightingMatrix(rGridInfo);
% 

if all(ismember({ 'northLimit', 'latStep', 'westLimit', 'lonStep' }, fieldnames(gridInfo)))
    gridInfoType = 'limits';
elseif all(ismember({ 'lats', 'lons' }, fieldnames(gridInfo)))
    gridInfoType = 'latlons';
else
    error('gridInfo structure must contain northLimit, latStep, westLimit, and lonStep fields\n or lats and lons fields.')
end

switch(gridInfoType)
    
    case 'limits'
        
        lons = [gridInfo.westLimit:gridInfo.lonStep:180 gridInfo.westLimit:-gridInfo.lonStep:-180];
        if all(ismember( [180, -180], lons ) )
            numCols = length(lons) - 2;
        else
            numCols = length(lons) - 1;
        end
        
        weightCol = cos( (gridInfo.northLimit:-gridInfo.latStep:-90)' * pi/180);
        
    case 'latlons'
        
        numCols = length(gridInfo.lons);
        
        weightCol = cos( (reshape(gridInfo.lats, [], 1) * pi/180) );
        
    otherwise
        
        error('Could not determine gridInfoType.')
end

weightMatrix = repmat( weightCol, 1, numCols );
        
end

