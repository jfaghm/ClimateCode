function [  negYears, posYears, index ] = getPosNegYearsIndex()
%This function takes in sea surface temperature and calcaulates the index
%for each year.  The indices are then normalized, and a set of positive and
%negative years are returned that are at least one standard deviation away
%from the average of the indices.
sst = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'sst');
sst = squeeze(sst);
sst = permute(sst, [2 1 3]);
sst = sst(:, :, (31*12)+1:end); %get 1979 - present
totalYears = 0;
year = 1;
sstMean = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+3 - 1:i+10 - 1), 3); 
   year = year+1;
   totalYears = totalYears + 1;
end

box_north = 52; %previosly was 36, but 52 gives better results
box_south = -6;
box_west = 140;
box_east = 270;
%box size
box_row =5;
box_col = 18; %previously was 10, but 18 gives better results

%these are the lats and lons of the data, they never change
lat=-88:2:88;
lon=0:2:358;

addpath('../sst_project/');
index = buildIndex(sstMean, box_north, box_south, box_west, box_east, lat, lon, box_row, box_col);
index = index';
baseYear = 1979;
stdDev = std(index);
normalizedIndex = (index - mean(index)) ./ stdDev;

posYears = find(normalizedIndex >= 1) + baseYear - 1;
negYears = find(normalizedIndex <= -1) + baseYear - 1;

end


