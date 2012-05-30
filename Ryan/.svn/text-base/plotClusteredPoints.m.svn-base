function plotHandle = plotClusteredPoints( points, clusters, latlims, lonlims )
%PLOTCLUSTEREDPOINTS Plots the given clustered points.
%
% plotHandles = plotClusteredPoints( points, clusters, latlims, lonlims )
%
%   Plots the given points on a map with the given latitude and longitude
%   limits.  It plots each cluster of points in a different color.
%
% --------------------------------- INPUT ---------------------------------
%
% --> points - The points which are to be plotted.  Each point should be on
% its own row of the form
%
%   [ latitude, longitude]
%
% --> clusters - The cluster indices assigned to each point.  The range of
% this vector should be 1..n, where n is the number of clusters.  This will
% ensure optimal spacing of the color map.  The entry at clusters(i)
% indicates which cluster the ith point belongs to.  Its length should be
% equal to that of points.
%
% --> latlims - The latitude limits of the map to be created
%
% --> lonlims - The longitude limits of the map to be created
%
%
% --------------------------------- OUTPUT ---------------------------------
%
% --> plotHandle - The handle of the plot that was created.
%

% Validate Input
if size(points, 2) ~= 2
    error('points input should have 2 columns')
end
if numel(clusters) ~= length(clusters)
    error('clusters input should be a vector')
end
if size(points, 1) ~= length(clusters)
    error('points should have the same number of rows as the length of clusters')
end
if ~all(size(latlims) == [ 1 2 ]) || ~all(size(lonlims) == [1 2])
    error('latlims and lonlims should be 1x2 matrices')
end

% Set up the color map to get unique colors for each cluster
uniqueIndices = unique(clusters);
numClusters = length(uniqueIndices);

% Use lines function to get a fairly unique range of colors
colors = lines(numClusters);

% Set up the figure and map axes and plot
figure;
axesm('MapProjection', 'pcarree', 'MapLatLimit', latlims, 'MapLonLimit', lonlims, 'Grid', 'on', 'ParallelLabel', 'on', 'MeridianLabel', 'on')
geoshow('landareas.shp', 'FaceColor', [0.5 0.7 0.5])
% Make some aesthetic adjustments
set(gca, 'Visible', 'off')
% setm(gca, 'FFaceColor', 'blue')
setm(gca, 'Frame', 'on')

% Iterate through each cluster and plot the associated points
for i = 1:numClusters
    
    currentCluster = points(clusters == uniqueIndices(i), :);
    
    geoshow(currentCluster(:, 1), currentCluster(:, 2), 'Marker', '.', 'MarkerSize', 12, 'Color', colors(i, :), 'LineStyle', 'none');
    
end

end

