function plotHurricaneLocs( startYear, endYear, southLim, northLim, westLim, eastLim )
%PLOTHURRICANELOCS Plots hurrican locations on a map using mapping toolbox
% ------------- DEPRECATED ------------- 
% Use plotClusteredPoints in hurricanerepo instead.
% 

dataPath = '/export/scratch/haasken/Hurricane/';

load([dataPath 'atlantic_storms_1870_2009'])

relevantStorms = hurricanes( ( ( hurricanes(:, 1) >= startYear ) & ...
    (hurricanes(:, 1) <= endYear) ), :);

relevantStorms = relevantStorms((relevantStorms(:, 2) >= 5 & relevantStorms(:, 2) <= 10), :);

relevantStorms = relevantStorms(relevantStorms(:, 10) > 0, :);


clear hurricanes

hurricanes(size(relevantStorms, 1), 1) = struct('geometry', [], 'lat', [], ...
    'long', [], 'year', [], 'magnitude', []);

numStorms = size(relevantStorms, 1);

for i = 1:numStorms
    hurricanes(i).geometry = 'Point';
    hurricanes(i).lat = relevantStorms(i, 6);
    hurricanes(i).long = relevantStorms(i, 7);
    hurricanes(i).year = relevantStorms(i, 1);
    hurricanes(i).magnitude = relevantStorms(i, 10);
end

latlim = [southLim, northLim];
lonlim = [westLim, eastLim];

ax = worldmap(latlim, lonlim);

land = shaperead('landareas', 'UseGeoCoords', true);

lakes = shaperead('worldlakes', 'UseGeoCoords', true);

geoshow(ax, land, 'FaceColor', [0.5 0.7 0.5])
geoshow(lakes, 'FaceColor', 'blue')
geoshow(hurricanes, 'Marker', '.', 'Color', 'red', 'MarkerSize', 16)
    
end

