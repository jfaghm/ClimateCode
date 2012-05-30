function heatMapHandles = plotHeatMaps( heatMaps, refvec, mapInfo, pointsToPlot )
%PLOTHEATMAPS Plots the given heat maps.
%
% heatMapHandles = plotHeatMaps( heatMaps, refvec, mapInfo, pointsToPlot )
%
%   Plots heat maps given in a 3D array, according to the information
%   in the given refvec and mapInfo parameters.
% 
% ----------------------------- INPUT -----------------------------
% 
% --> heatMaps - The 3D array of heatMaps to be plotted.  Each slice should
% represent one heat map, with columns representing longitude and rows
% representing latitude.
% 
% --> refvec - The geo-referencing vector needed to plot the data on a map.
%  It should consist of [ step northLimit westLimit ].
% 
% --> mapInfo - A structure containing at least latLims and lonLims fields,
% and optionally colorLims and figureTitle fields.  latLims and lonLims
% indicate the limits of the map which will be drawn.  colorLims is a
% two-element row vector indicating the lower and upper limits of the color
% axis.  figureTitle is the title given to each generated heat map.
% 
% ----------------------------- OUTPUT -----------------------------
% 
% --> heatMapHandles - A vector of figure handles to the heat map figures
% which were created.  Remember to close these when finished with them in
% order to free resources.  They can be altered and saved by iterating
% through and accessing each handle.
% 

persistent land;
persistent points;
persistent baseFigure;
persistent savedrefvec;
persistent latLims;
persistent lonLims;
persistent colorLims;
persistent figureTitle;

if nargin > 2
    
    savedrefvec = refvec;
    
    if ~(ismember( { 'latLims', 'lonLims' }, fieldnames(mapInfo) ))
        error('mapInfo structure must have latLims and lonLims fields.')
    else
        latLims = mapInfo.latLims;
        lonLims = mapInfo.lonLims;
    end
    
    if ~ismember('colorLims', fieldnames(mapInfo))
        fprintf('Using auto for color axis.  Use colorLims field of mapInfo to modify.\n')
        colorLims = 'auto';
    else
        colorLims = mapInfo.colorLims;
    end
    
    if ~ismember('figureTitle', fieldnames(mapInfo))
        figureTitle = 'Set mapInfo.figureTitle to change figure titles.';
    else
        figureTitle = mapInfo.figureTitle;
    end
    
    % Set up a base map figure to plot land areas just once
    baseFigure = figure('Visible', 'off');
    axesm('MapProjection', 'pcarree', 'MapLatLimit', latLims, 'MapLonLimit', lonLims, 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')
    set(gca, 'Visible', 'off')
    setm(gca, 'Frame', 'on')
    
    land = geoshow('landareas.shp', 'FaceColor', [0.5 0.7 0.5]);
    
    if nargin > 3
        points = geoshow(pointsToPlot(:, 1), pointsToPlot(:, 2), 'Marker', '.', 'MarkerSize', 8, 'Color', [.999 .999 .999], 'LineStyle', 'none');
    end
end

if isempty(land)
    error('The plotHeatMaps function must be called at least once with mapInfo and refvec arguments.')
end

caxis( colorLims )
colorbar

if iscell(heatMaps)
    numHeatMaps = length(heatMaps);
else
    numHeatMaps = size(heatMaps, 3);
end

heatMapHandles = zeros(1, numHeatMaps);

for i = 1:numHeatMaps
    
    currentFigure = figure('Visible', 'off');
    axesm('MapProjection', 'pcarree', 'MapLatLimit', latLims, 'MapLonLimit', lonLims, 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')
    set(gca, 'Visible', 'off')
    setm(gca, 'Frame', 'on')
    
    copyobj( land, gca )
    if nargin > 3
        copyobj( points, gca )
    end
    
    if iscell(heatMaps)
        currentHeatMap = heatMaps{i};
    else
        currentHeatMap = heatMaps(:, :, i);
    end
    
    previousChildren = get(gca, 'Children');
    hm = geoshow(flipud(currentHeatMap), savedrefvec, 'DisplayType', 'texturemap');
    colorbar
        
    set(gca, 'Children', [previousChildren; hm])
    
    title( { figureTitle, ...
        sprintf('Max = %.3f, Min = %.3f', max(max(currentHeatMap)), min(min(currentHeatMap)))} , ...
        'Visible', 'on', 'FontSize', 12)
    
    heatMapHandles(i) = currentFigure;
    
end

% close(baseFigure);

end

