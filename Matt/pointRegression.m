function [ bestFitLines  ] = pointRegression( data )
%This function is used to calculate the linear regression coefficients for
%each point spatially in the data set that is provided.  
%   This function takes in a three dimensional matrix (latxlon.time).  and
%   outputs another three dimensional matrix, where the first and second
%   dimensions are latitude and longitude respectively, and the third
%   dimension is of size 2, one for the intercept, and one for the slope.
if size(data, 1) == 512
    data = permute(data, [2 1 3]);
end
time = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');
dates = zeros(size(time, 1), 4);

sst = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'sst');
sst = squeeze(sst);
sst = permute(sst, [2 1 3]);
sst = sst(:, :, (31*12)+1:end); %get 1979 - present

box_north = 52; 
box_south = -6;
box_west = 140;
box_east = 270;
box_row =5;
box_col = 18; 
lat=-88:2:88;
lon=0:2:358;
addpath('../sst_project/')
index = zeros(size(data, 3) / 12, 1);
month = 1;
for i = 1:12:size(data, 3)
     index(month) = buildIndex(sst(:, :, i), box_north, box_south, box_west, box_east, lat, lon, box_row, box_col);
     month = month+1;
end

for i = 1:size(time, 1)
   dates(i, :) = hoursToDate(time(i), 1, 1979);
end
yearlyData = zeros(size(data, 1), size(data, 2), size(data, 3)/12, 1);
i = 1;
for month = 1:12:size(data, 3)
    yearlyData(:, :, i) = data(:, :, month);
    i = i+1;
end
bestFitLines = zeros(size(data, 1), size(data, 2), 2);
if matlabpool('size') == 0
    matlabpool open;
end
parfor i = 1:size(data, 1)
    bflRow = zeros(1, size(data, 2), 2);
    for j = 1:size(data, 2)
        p = polyfit(index, squeeze(yearlyData(i, j, :)), 1);
        bflRow(1, j, 1) = p(1);
        bflRow(1, j, 2) = p(2);
    end
    bestFitLines(i, :, :) = bflRow;
end

end

