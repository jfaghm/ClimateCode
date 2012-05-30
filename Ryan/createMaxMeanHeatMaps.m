function [ maxMap, meanMap ] = createMaxMeanHeatMaps( allHeatMaps, mapLatLims, mapLonLims, saveDir )
%CREATEMAXMEANHEATMAPS Creates and plots max and mean heat maps from random trials.
% 
% [ maxMap, meanMap ] = createMaxMeanHeatMaps( allHeatMaps, mapLatLims, mapLonLims, saveDir )
% 
%   This function creates two heat maps which are combinations of the heat
%   maps given as input.  One of these is a heat map in which every point
%   has the maximum value of that point in any of the heat maps given as
%   input, and the other is one in which every point is the mean of that
%   point across all heat maps.  This function also plots both heatmaps and
%   saves them.
% 
% ------------------------------INPUT------------------------------
% 
% --> allHeatMaps - The 3D array of gridded lat long heat maps.  They are
% on a 1-degree grid with a northern limit of 89.5N and a west limit of
% 179.5W.  Each location contains the highest correlation of the SST box centered
% at that location with any other storm box.
% 
% --> mapLatLims - The north and south latitude limits of each map plot.
% 
% --> mapLonLims - The west and east longitude limits of each map plot.
% 
% --> saveDir (optional) - The directory to which each figure is saved.  If
% none is given, the current directory is assumed.  Does not matter whether
% it is given with or without a trailing '/'
% 
% ------------------------------OUTPUT------------------------------
% 
% --> maxMap - The maximum heat map, where each point is the max of that
% point through all heat maps.
% --> meanMap - The mean heat map, where each point is the mean of that
% point through all heat maps.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume that we have 1-degree x 1-degree heat maps in a 3d array
% % Create the max and mean heat maps and plot atlantic region
% [ maxMap, meanMap ] = createMaxMeanHeatMaps(allHeatMaps, [-30 50], [-120 20], 'MaxMeanPlots')
% 

% Check if the save directory exists ...
if ~exist(saveDir, 'dir')
    mkdir(saveDir)
end
% ... and whether it was entered with a trailing forward slash.
if ~strcmp(saveDir(end), '/')
    saveDir = [saveDir '/'];
end

% Plot the maximum of all the random heatmaps
f = figure('Visible', 'off');
axesm('MapProjection', 'pcarree', 'MapLatLimit', mapLatLims, 'MapLonLimit', mapLonLims, 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')

maxMap = max(allHeatMaps(180:-1:1, :, :), [], 3);

geoshow(maxMap, [1 90 -180], 'DisplayType', 'texturemap')
caxis([-0.5 .8])
colorbar
geoshow('landareas.shp', 'FaceColor', [0.5 0.7 0.5])

title( sprintf('Max of all Randomized HeatMaps - Max = %.4f, Min = %.4f', ...
    max(max(maxMap)), min(min(maxMap))), 'FontSize', 12)

saveas(f, [ saveDir 'maxHeatMap.png' ] )

close(f)

% Plot the mean of all the random heatmaps
f = figure('Visible', 'off');
axesm('MapProjection', 'pcarree', 'MapLatLimit', mapLatLims, 'MapLonLimit', mapLonLims, 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')

meanMap = mean(allHeatMaps(180:-1:1, :, :), 3);

geoshow(meanMap, [1 90 -180], 'DisplayType', 'texturemap')
colorbar
caxis([-0.5 .8])
geoshow('landareas.shp', 'FaceColor', [0.5 0.7 0.5])

title( sprintf('Mean of all Randomized HeatMaps - Max = %.4f, Min = %.4f', ...
    max(max(meanMap)), min(min(meanMap))), 'FontSize', 12)

saveas(f, [ saveDir 'meanHeatMap.png' ] )

close(f)

end

