function obsWithSurround = addSurrounding( observations, neighborWidth )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

persistent locations_grid

if isempty(locations_grid)
    load('/export/scratch/haasken/Hurricane/grid.mat')
    locations_grid = latlonGrid;
end

if nargin < 2
    neighborWidth = 1;
end

numNeighbors = (neighborWidth*2 + 1)^2;

numObservations = size(observations, 1);

obsWithSurround = zeros(numObservations*numNeighbors, 6);

for i = 1:numObservations
    currentIndex = observations(i, 6);
    surroundIndices = getSurroundingIndices(256, 512, currentIndex, neighborWidth);
    assert(numNeighbors == length(surroundIndices));
    
    % remove the actual location from surroundIndices
    surroundIndices(ceil(numNeighbors/2)) = [];
    
    rowOffset = (i-1)*9 + 1;
    
    obsWithSurround(rowOffset, :) = observations(i, :);
    
    for n = 1:numNeighbors-1
        obsWithSurround(rowOffset + n, 1:3) = observations(i, 1:3);
        obsWithSurround(rowOffset + n, 4:5) = locations_grid(surroundIndices(n), :);
        obsWithSurround(rowOffset + n, 6) = surroundIndices(n);
    end
    
end


end

