function [ dataSet ] = buildData( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
startYear = 1989;
endYear = 2010;
totalYears = 2010 - 1989 + 1;
load condensedHurDat;


dataLoaded = false;
if dataLoaded == false
    lat = ncread('data/sst_era_1989_2010.nc', 'lat');
    lon = ncread('data/sst_era_1989_2010.nc', 'lon');
    time = ncread('data/sst_era_1989_2010.nc', 'time');
    sst = ncread('data/sst_era_1989_2010.nc', 'var34');
    sst = permute(sst, [2 1 3]);
end

hurricanes = condensedHurDat;   
    
%changes the range of longitudes from 0-360 to -180-180
lonSize = size(lon, 1);
latSize = size(lat, 1);

for i = 1:lonSize
    scaledLon = lon - 180;
end

latlonGrid = zeros(lonSize * latSize, 2);
%create the grid of latitutes and longitude
k = 1;
for i = 1:lonSize
    for j = 1:latSize
        latlonGrid(k, :) = [lat(j) scaledLon(i)];
        k = k+1;
    end
end

    

hurricanes = hurricanes(hurricanes(:, 1) >= 1989 & hurricanes(:, 2) >= 6 &...
       hurricanes(:, 2) <= 11, :);
   
  
dataSet = cell(1, totalYears);




for year = startYear:endYear
   yearStorms = hurricanes(hurricanes(:, 1) == year, [1:3 6:7]);
   if year == 1989
       yearStorms = yearStorms(yearStorms(:, 2) >= 8, :);
   end
   numStorms = size(yearStorms, 1);
   
   grid = zeros(numStorms, 2);
   

   [D, I] = pdist2(latlonGrid, yearStorms(:, 4:5), 'euclidean', 'smallest', 1);
   grid(:, :) = latlonGrid(I, :);
   
   
   dataSet{year - startYear + 1} = zeros(numStorms, 15);
   dataSet{year - startYear + 1} = getStormSSTInfo(yearStorms, grid, sst, time, lat, scaledLon);

    
end  

end

