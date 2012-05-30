function bestBoxes = findBestBoxes( allBoxData, allBoxStorms, mustEncompass, absValue)
%FINDBESTBOXES Gets the most highly correlated data and storm boxes
%
%   bestBoxes = findBestBoxes( allBoxData, allBoxStorms, mustEncompass)
%
% Computes the correlation between every pair of boxes in allBoxData and
% allBoxStorms.  Returns the best (most highly correlated) boxes in a
% matrix.
%
% ------------------------------INPUT------------------------------
% 
% --> allBoxData - The 2D matrix of the yearly data averages for every
% possible box.  The first two columns are the latitude limits of the box
% on that row. The second two columns are the longitude limits of the box
% on that row. The rest of the columns are the yearly data means for the
% box on that row.  That is, each row is of the following form:
%
%   [ latLim1 latLim2 lonLimWest lonLimEast yearlyDataMeans ]
% 
% --> allBoxStorms - The 2D matrix of the storm counts for every possible box.
% The first two columns are the latitude limits of the box on that row.
% The second two columns are the longitude limits of the box on that row.
% The rest of the columns are the yearly storm counts for the box on that
% row.  That is, each row is of the following form:
%
%   [ latLim1 latLim2 lonLimWest lonLimEast yearlyStormCounts ]
%
% --> mustEncompass - A boolean indicating whether each storm box must
% encompass each data box
% 
% --> absValue - A boolean, true if absolute value of correlations should be
% maximized.
% 
% ------------------------------OUTPUT------------------------------
%
% --> bestBoxes - A matrix of the best storm box paired with each data box
% with the rows sorted in order of their correlation.  Each row is of the
% following form:
% 
%   [ correlation dataBoxLatLims dataBoxLonLims stormBoxLatLims stormBoxLonLims ]
%
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have allBoxSST and allBoxStorms from getAllBoxData and
% % getAllBoxStormCounts, respectively (see documentation of those functions
% % for more information.
% % Find the storm box most highly correlated with each sst box.  Require
% % that storm boxes encompass sst boxes for correlation to be considered.
% % Do not take absolute value of correlations.
% bestBoxes = findBestBoxes( allBoxSST, allBoxStorms, true, false)
% 


if nargin < 3
    mustEncompass = true;
end
if nargin < 4
    absValue = false;
end

allCorrelations = rowCorr(allBoxStorms(:, 5:end), allBoxData(:, 5:end));

if mustEncompass
    encMask = getEncompassingMask(allBoxStorms(:, 1:4), allBoxData(:, 1:4));
    allCorrelations(~encMask) = NaN;
end

if absValue
    [ ~, maxIndices ] = max(abs(allCorrelations), [], 1);
    signIndices = (0:(size(allCorrelations, 2)-1)) * size(allCorrelations, 1) + maxIndices;
    maxCorrelations = allCorrelations(signIndices);
    % alternatively, consider using sub2ind matlab function
else
    [ maxCorrelations, maxIndices ] = max(allCorrelations, [], 1);
end

bestBoxes = [ maxCorrelations', allBoxData(:, 1:4), allBoxStorms(maxIndices, 1:4) ];

[~, sortIndices] = sort(abs(bestBoxes(:, 1)), 'descend');
bestBoxes = bestBoxes(sortIndices, :);
% bestBoxes = sortrows(bestBoxes, -1);
badBoxes = isnan(bestBoxes(:, 1));
bestBoxes = bestBoxes(~badBoxes, :);

end
