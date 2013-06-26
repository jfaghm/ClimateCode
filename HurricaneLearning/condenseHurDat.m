% This script condenses the newly obtained hurDat data set into a format
% similar to the older hurricane data set.  It gets rid of tracks and just
% records the cyclogenesis date and time and location along with the
% maximum strength, wind speed, and minimum pressure.

load('/project/expeditions/haasken/data/atlanticStorms/HurDat_1851_2010.mat')

numStorms = max(hurDat(:, 1));

condensedHurDat = zeros(numStorms, 10);

for i = 1:numStorms
    % pull out the track data of the ith storm
    stormTrack = hurDat(hurDat(:, 1) == i, :);
    
    % find the row containing the maximum wind speed
    [~, maxInd] = max(stormTrack(:, 10));
    
    maxStrength = stormTrack(maxInd, 12);
    maxWind = stormTrack(maxInd, 10);
    
    stormTrack(stormTrack(:, 11) == -1, 11) = Inf;
    [minPressure, minInd] = min(stormTrack(:, 11));
    if isinf(minPressure)
        minPressure = -1;
    end
    
    condensedHurDat(i, :) = [stormTrack(1, 2:4) stormTrack(end, 3:4) stormTrack(1, 6:7) maxWind minPressure maxStrength];
    
end

labels = [labels(2:4) labels(3:4) labels(6:7) labels(10:12)];

save('condensedHurDat.mat', 'condensedHurDat', 'labels', 'types')