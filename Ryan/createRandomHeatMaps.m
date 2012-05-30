function [ allHeatMaps randomOrderings ] = createRandomHeatMaps( allBoxSST, allBoxStorms, numTrials, mustEncompass )
%CREATERANDOMHEATMAPS Creates many random storm-SST correlation heat maps.
% 
% [ allHeatMaps randomOrderings ] = createRandomHeatMaps( allBoxSST, allBoxStorms, numTrials, mustEncompass )
% 
%   This function creates a 3D array of heat maps which indicate the
%   correlation between the SST of every region in allBoxSST with the
%   randomized storm counts in any other region.
% 
% ------------------------------INPUT------------------------------
% 
% --> allBoxSST - A matrix of all the yearly box SST averages.  Each row
% should represent a single SST box.  The first four columns of each row
% should be the latitude and longitude limits of the box in that row in the
% following order:
% 
%    [ latitude latitude longitude-west-limit longitude-east-limit]
% 
% The order of the latitude limits does not matter as the maximum will be
% taken as the northern limit.  In order to get a sensible heat map, each
% box in allBoxSST should have a different center.  If any boxes in
% allBoxSST are concentric, this function's behavior is undefined.
% 
% --> allBoxStorms - A matrix of all the yearly box storm counts.  Each row
% should be a single box with the first four columns being the latitude and
% longitude limits of that box as described above.
% 
% --> numTrials - The number of times to randomize the storm counts and
% create a heat map of the resulting correlations.
% 
% --> mustEncompass - A boolean indicating whether each sst box can be
% correlated with all boxes (false) or only those which encompass them (true).
% 
% ------------------------------OUTPUT------------------------------
% 
% --> allHeatMaps - The 3D array of gridded lat long heat maps.  They are
% on a 1-degree grid with a northern limit of 89.5N and a west limit of
% 179.5W.  Each location contains the highest correlation of the SST box centered
% at that location with any other storm box.  The results of the ith
% randomization are located at allHeatMaps(:, :, i).
% 
% --> randomOrderings - A 2D array which records the random permutation of
% the storm counts that is used on each trial.  That is, the ith row of
% randomOrderings is the random permutation used to generate the heat map
% at allHeatMaps(:, :, i).
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have allBoxSST and allBoxStorms from getAllBoxData and
% % getAllBoxStormCounts, respectively (see documentation of those functions
% % for more information.
% % Get 100 randomized heat maps of correlation between storms and sst, and
% % require that the sst boxes are correlated only with the storm boxes
% % which encompass them.
% [allHeatMaps randomOrderings] = createRandomHeatMaps( allBoxSST, allBoxStorms, 100, true )
% % View the heat maps and print the random ordering which produced them
% for i = 1:100
%     randomOrderings(i, :)
%     imagesc(allHeatMaps(:, :, i))
%     pause()
% end
% 

if nargin < 4
    % Default value forces storm boxes to encompass sst boxes
    mustEncompass = true;
end

% Get just the counts from allBoxStorms, i.e. remove lat/lon info
annualCounts = allBoxStorms(:, 5:end);
% Get just the sst from allBoxSST
annualSST = allBoxSST(:, 5:end);

% Set up a grid for the heat map and get a matching coarse land mask
gridInfo = struct( 'lats', 89.5:-1:-89.5, 'lons', -179.5:1:179.5 );
load('/project/expeditions/haasken/data/HadISST1/hadleyLandMask.mat')
landMask = hadleyLandMask;

% Check if the storm boxes must encompass the sst boxes
if mustEncompass
    % if so, get a mask which can be used to remove invalid correlations
    encMask = getEncompassingMask(allBoxStorms(:, 1:4), allBoxSST(:, 1:4));
end

% Initialize output variables to all NaN/zeros
allHeatMaps = NaN(180, 360, numTrials);
randomOrderings = zeros(numTrials, size(annualCounts, 2));

% Use a parallel for loop if a matlabpool is open
% This does each independent random trial in parallel
parfor i = 1:numTrials
    
    % Get a random permutation of the storm counts
    randomOrder = randperm(size(annualCounts, 2));
    randomOrderings(i, :) = randomOrder;
    
    % Randomize the storm counts with the permutation
    randomizedCounts = annualCounts(:, randperm(size(annualCounts, 2)));
    
    % Correlate each row of counts with each row of SST
    allCorrelations = rowCorr(randomizedCounts, annualSST);
    
    if mustEncompass
        % Use the mask to remove any invalid correlations
        allCorrelations(~encMask) = NaN;
    end
    
    % Create a heat map of the best random correlations at each point
    [ corrHeatMap, ~ ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations, gridInfo );
    % Mask out all land points
    corrHeatMap(landMask) = NaN;
    
    % Save each random trial's heat map
    allHeatMaps(:, :, i) = corrHeatMap;
    
end

end

