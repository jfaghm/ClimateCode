function [ hasMin ] = hasMinStorms( allBoxStorms, minStormsPerYear )
%HASMINSTORMS Returns a mask of which storm boxes have minimum storms per year (on average).
%
%   hasMin = hasMinStorms( allBoxStorms, minStormsPerYear )
%
%   Returns a logical mask of the same length as size(allBoxStorms, 1) that
%   indicates whether each box in allBoxStorms has the indicated minimum
%   number of storms per year.
%
% ------------------------------INPUT------------------------------
% 
% --> allBoxStorms - The 2D matrix of the storm counts for every possible box.
% The first two columns are the latitude limits of the box on that row.
% The second two columns are the longitude limits of the box on that row.
% The rest of the columns are the yearly storm counts for the box on that
% row.  That is, each row is of the following form:
%
%   [ latLim1 latLim2 lonLimWest lonLimEast yearlyStormCounts ]
% 
% --> minStormsPerYear - The minimum number of storms required per year.
%
% ------------------------------OUTPUT------------------------------
%
% --> hasMin - A logical mask with length equal to the number of rows
% (boxes) in allBoxStorms.  It is true where the storm box has the minimum
% number of storms per year and false elsewhere.
% 

hasMin = mean( allBoxStorms(:, 5:end), 2 ) >= minStormsPerYear;

end

