function plotHandles = plotBoxes( boxesToPlot, latlims, lonlims, heatMap )
%PLOTBOXES Plots the given boxes.
% 
% plotHandles = plotBoxes( boxesToPlot, latlims, lonlims, heatMap )
% 
%   Plots the given pairs of boxes on a map, optionally showing a heat map
%   simultaneously.
% 
% --------------------------------- INPUT ---------------------------------
%
% --> boxesToPlot - The pairs of boxes with their correlations that need to
% be plotted.  Each row represents one pair of boxes in the following
% format: 
% 
%   [ correlation box1LatLims box1LonLims box2LatLims box2LonLims ]
% 
% --> latlims - The latitude limits of the map to be created
% 
% --> lonlims - The longitude limits of the map to be created
% 
% --> heatMap - The heat map to display simultaneously on each map
% (optional)
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> plotHandles - The vector of the plot handles of all the plots that
% were created.  These can be iterated through so that each one can be
% saved or modified.  Be sure to close all the figures in this vector to
% return the resources to matlab.  If you don't do this, matlab will get
% slow and freeze eventually.
% 

plotHandles = zeros(size(boxesToPlot, 1), 1);

baseFigure = figure('Visible', 'off');
axesm('MapProjection', 'pcarree', 'MapLatLimit', latlims, 'MapLonLimit', lonlims, 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')

if nargin > 3
    geoshow(heatMap(180:-1:1, :), [1 90 -180], 'DisplayType', 'texturemap')
    colorbar
end

geoshow('landareas.shp', 'FaceColor', [0.5 0.7 0.5])

set(gca, 'Visible', 'off')
setm(gca, 'FFaceColor', 'blue')
setm(gca, 'Frame', 'on')

numBoxes = size(boxesToPlot, 1);

for i = 1:numBoxes
    
    % Grab the correlation and box limits for each box pair
    correlation = boxesToPlot(i, 1);
    
    sstlatlims = boxesToPlot(i, 2:3);
    sstlonlims = boxesToPlot(i, 4:5);
    
    % Create the 5 points that will create the sst box when connnected in
    % order
    sstLatVec = sstlatlims([1 1 2 2 1]);
    sstLonVec = sstlonlims([1 2 2 1 1]);
    
    stormlatlims = boxesToPlot(i, 6:7);
    stormlonlims = boxesToPlot(i, 8:9);
    
    % Create the 5 points that will create the storm box when connected in
    % order
    stormLatVec = stormlatlims([1 1 2 2 1]);
    stormLonVec = stormlonlims([1 2 2 1 1]);
    
    % Copy the base figure to add the boxes to it
    currentFigure = copyobj(baseFigure, 0);
    
    % Show the sst box
    geoshow(sstLatVec, sstLonVec, 'Color', 'red', 'LineWidth', 2);
    % Show the storm box
    geoshow(stormLatVec, stormLonVec, 'Color', 'yellow', 'LineWidth', 2);
    
    % Create a title which diplays the correlation between the boxes
    title(sprintf('Boxes with a Correlation of %.02f', correlation), 'FontSize', 12, 'Visible', 'on')
    
    % Store the plot handle in the output vector
    plotHandles(i) = currentFigure;

end
 
close(baseFigure)

end

