function [  negYears, posYears, index ] = ...
    getPosNegYearsIndex(startMonth, endMonth, sigma)
%This function calcaulates the index
%for each year.  The indices are then normalized, and a set of positive and
%negative years are returned that are at least one standard deviation away
%from the average of the indices.

load /project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat;

year = 1;
sstMean = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+startMonth - 1:i+endMonth - 1), 3); 
   year = year+1;
end

box_north = 52; %previosly was 36, but 52 gives better results
box_south = -6;
box_west = 140;
box_east = 270;

%box size
box_row = 5;
box_col = 18; %previously was 10, but 18 gives better results



%these are the lats and lons of the data, they never change
lat=-88:2:88;
lon=0:2:358;

addpath('/project/expeditions/lem/ClimateCode/sst_project/');
index = buildIndex(sstMean, box_north, box_south, box_west, box_east, lat, lon, box_row, box_col, @max);

index = index';
baseYear = 1979;
normalizedIndex = (index - mean(index)) ./ std(index);


%Positive years correspond to years with high hurricane activity.  In the
%case of the spatial ENSO index, those are the years with lower index
%values.
negYears = find(normalizedIndex >= sigma) + baseYear - 1;
posYears = find(normalizedIndex <= -sigma) + baseYear - 1;

end
