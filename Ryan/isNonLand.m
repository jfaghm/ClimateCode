function cleanMask = isNonLand( boxes, maxLandCover )
%ISNONLAND Gets a mask indicating which boxes are non-land.
% 
%   cleanMask = isNonLand( boxes, maxLandCover )
% 
%   Gets a mask of which boxes consist of a certain fraction of land.
% 
% ----------------------------- INPUT -----------------------------
% 
% --> boxes - A 2D matrix of box limits where each row represents a box in
% the following format:
% 
%    [ latLim1 latLim2 westLonLim eastLonLim ]
% 
% --> maxLandCover - A number between 0 and 1 indicating what fraction of a
% box can be covered with land.  Any region that has more than this
% fraction of itself covered by land will be removed.
% 
% ----------------------------- OUTPUT -----------------------------
% 
% --> cleanMask - A mask, which when applied to boxes as follows:
%     
%    cleanedBoxes = boxes(cleanMask, :);
% 
% will remove all the boxes which have more land cover than
% maxLandCover.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example removes all boxes which are over 30% land from allBoxSST 
% cleanMask = isNonLand( allBoxSST(:, 1:4), .30 );
% nonLandBoxes = allBoxSST(cleanMask, :);
% 

if nargin < 2
    % Default of one half land cover
    maxLandCover = 0.5;
end

numBoxes = size(boxes, 1);
cleanMask = true(size(boxes, 1), 1);

for i = 1:numBoxes
    
    landRatio = landCover(boxes(i, 1:2), boxes(i, 3:4));
    
    if landRatio > maxLandCover
        % Mark this row for deletion
        cleanMask(i) = false;
    end
    
end

end

