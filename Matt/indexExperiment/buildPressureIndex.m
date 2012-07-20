function [index, negYears, posYears, cc] = ...
    buildPressureIndex(indexNum, compositeNum, startMonth, endMonth)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
addpath('../');
addpath('../../sst_project/');
pressure = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var134')*.01;
pressure = permute(pressure, [2, 1, 3]);
time = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');
dates = zeros(length(time), 4);
for i = 1:length(time)
    dates(i, :) = hoursToDate(time(i),1, 1, 1979);
end
switch compositeNum
    case 1
        for i = 1:12
            current = pressure(:, :, dates(:, 3) == i);
            pressure(:, :, dates(:, 3) == i) = (current - repmat(nanmean(current, 3), [1, 1, size(current, 3)]))...
             ./ repmat(nanstd(current, 0, 3), [1, 1, size(current, 3)]);
        end
    case 2
        pressure = pressure - repmat(nanmean(pressure, 3), [1, 1, size(pressure, 3)]);
    case 3
        pressure = (pressure - repmat(nanmean(pressure, 3), [1, 1, size(pressure, 3)]))...
            ./ repmat(std(pressure, 0, 3), [1, 1, size(pressure, 3)]);
end

pLat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
pLon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');

year = 1;
for i = 1:12:size(pressure, 3)
   pMean(:, :,year) = nanmean(pressure(:, :, i+startMonth-1:i+endMonth-1), 3);
   year = year+1;
end

box_north = pLat(minIndex(pLat, 35));
box_south = pLat(minIndex(pLat, -5));
box_west = pLon(minIndex(pLon, 140));
box_east = pLon(minIndex(pLon, 270));

box_row = 5;
box_col = 18;

index = buildIndexHelper(pMean, box_north, box_south, box_west, box_east, pLat, pLon, box_row, box_col, indexNum);

baseYear = 1979;
stdDev = std(index);
normalizedIndex = (index - mean(index)) ./ stdDev;

posYears = find(normalizedIndex >= 1) + baseYear - 1;
negYears = find(normalizedIndex <= -1) + baseYear - 1;

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
      
cc(1) = corr(index, aso_tcs);
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ace);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_ntc);

end

function index = minIndex(A, x)
    [~,index] = min(abs(A - x));
end

function index = buildIndexHelper(sst_a,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col, indexNum)

if ismember(box_north, lat)
   [~, northRow] = ismember(box_north, lat);
   [~, southRow] = ismember(box_south, lat);
else
    error('Bad lat input!');
end
if ismember(box_east, lon)
   [~, eastCol] = ismember(box_east, lon);
   [~, westCol] = ismember(box_west, lon);
else
    error('Bad lat input!');
end
annual_pacific = double(sst_a(northRow:southRow,westCol:eastCol,:));
%annual_pacific = double(sst_a(southRow:northRow,westCol:eastCol,:));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end
 
mean_box_sst_pacific = ss(box_row:end-box_row+1,box_col:end-box_col+1,:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns

for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
   [minValues(t), minLoc(t)] = min(current(:));
   [minI(t), minJ(t)] = ind2sub(size(current), minLoc(t));
end


lon_region = lon(lon >= box_west & lon <= box_east);
lat_region = lat(lat >= box_south & lat <= box_north);
switch indexNum
    case 1
        index = lon_region(J); %.4333 correlation
    case 2
        index = lon_region(minJ); %-.1821 correlation
    case 3
        index = lat_region(I); %-.04714 correlation
    case 4
        index = lat_region(minI); %1.4318 correlation
    case 5
        index = lat_region(minI) - lat_region(I); %.9349 correlation
    case 6
        
end

end


