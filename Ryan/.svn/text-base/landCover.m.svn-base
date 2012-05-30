function [ ratio ] = landCover( latlims, lonlims )
%LANDCOVER Compute fraction land cover of region
%   
% [ ratio ] = landCover( latlims, lonlims )
% 
% Computes the approximate fraction of land cover of the given region on the globe.
% 
% ------------------------------ INPUT ------------------------------
% 
% --> latlims - The north and south latitude limits of the region in a
% 2-element vector.
% 
% --> lonlims - The west and east longitude limits of the region in a
% 2-element vector.
% 
% ------------------------------ OUTPUT ------------------------------
% 
% --> ratio - The approximate fraction of land cover of the given region of
% the globe.
% 
% NOTE: This function uses the reynolds land mask stored in 
% /project/expeditions/haasken/data/reynolds_monthly/reynoldsLandMask.mat
% to compute the land cover of the given region.
% 

persistent landMask
persistent gridInfo

if isempty(landMask)
    % Load the reynolds 1-degree resolution landmask
    load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsLandMask.mat')
    landMask = reynoldsLandMask;
    gridInfo = rGridInfo;
end

[rows, cols] = getMatrixIndices(latlims, lonlims, gridInfo);

rows = sort(rows);
startRow = rows(1);
endRow = rows(2);
startCol = cols(1);
endCol = cols(2);

if startCol < endCol
    region = landMask(startRow:endRow, startCol:endCol); 
else
    region = landMask(startRow:endRow, [startCol:end, 1:endCol]);
end

ratio = mean(region(:));

end

