function [index, indexMat, cc] = buildComboIndex(startMonth, endMonth, ...
    box_row, box_col, box_south, box_north)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
load /project/expeditions/lem/ClimateCode/Matt/matFiles/flippedSSTAnomalies.mat
load /project/expeditions/lem/ClimateCode/Matt/matFiles/olrAnomalies.mat
load /project/expeditions/lem/ClimateCode/Matt/matFiles/pressureAnomalies.mat

addpath('/project/expeditions/lem/ClimateCode/sst_project/');

annualOLR = zeros(size(olr, 1), size(olr, 2), size(olr, 3)/12);
annualSST = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
annualPressure = zeros(size(pressure, 1), size(pressure, 2), size(pressure, 3)/12);
count = 1;
for i = 1:12:size(olr, 3)
    annualOLR(:, :, count) = nanmean(olr(:, :, i+startMonth-1:i+endMonth-1), 3);
    annualSST(:, :, count) = nanmean(sst(:, :, i+startMonth-1:i+endMonth-1), 3);
    annualPressure(:, :, count) = nanmean(pressure(:, :, i+startMonth-1:i+endMonth-1), 3);
    count = count+1;
end
if nargin <= 4
    box_north = 36;
    box_south = -6;
end

box_west = 140;
box_east = 270;

if nargin == 2
    box_row = 5;
    box_col = 10;
end
%%%%%%%%%%%%% Version 1 of the combo index%%%%%%%%%%%%%%%%%
%{
sstMaxVal = buildIndexGeneric(annualSST, box_north, box_south, box_west, box_east, ...
    sstLat, sstLon, box_row, box_col, 'maxVal');

olrMinVal = buildIndexGeneric(annualOLR, box_north, box_south, box_west, box_east, ...
    olrLat, olrLon, box_row, box_col, 'minVal');

pressureMinVal = buildIndexGeneric(annualPressure, box_north, box_south, box_west, ...
    box_east, pressureLat, pressureLon, box_row, box_col, 'minVal');

sstBoxOLRVal = sstBoxOtherVal(olr, olrLat, olrLon);

sstBoxPressureVal = sstBoxOtherVal(pressure, pressureLat, pressureLon);

indexMat = [norm(sstMaxVal), norm(olrMinVal), norm(pressureMinVal), ...
    norm(sstBoxOLRVal), norm(sstBoxPressureVal)];
%}
%%%%%%%%%%%%%%%%% Version 2 of the combo index%%%%%%%%%%%%%%

sstBoxPress = norm(sstBoxOtherVal(pressure, pressureLat, pressureLon));
sstBoxOLR = norm(sstBoxOtherVal(olr, olrLat, olrLon));
pressureMinLon = norm(buildIndexGeneric(annualPressure, box_north, box_south, box_west, ...
    box_east, pressureLat, pressureLon, box_row, box_col, 'minLon'));
sstMaxLon = buildIndexGeneric(annualSST, box_north, box_south, box_west, ...
    box_east, sstLat, sstLon, box_row, box_col, 'maxLon');
sstMinLon = buildIndexGeneric(annualSST, box_north, box_south, box_west, ...
    box_east, sstLat, sstLon, box_row, box_col, 'minLon');
sstDif = norm(sstMinLon - sstMaxLon);

indexMat = [sstBoxPress, sstBoxOLR, pressureMinLon, sstDif];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

index = sum(indexMat, 2);

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
cc(1) = corr(index, aso_tcs);
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ntc);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_ace);
end

function aNorm = norm(A)
    aNorm = (A - mean(A)) ./ std(A);
end

%%%%Build Index
function val = buildIndexGeneric(data,box_north,box_south,...
    box_west,box_east,lat,lon,box_row,box_col, valReturned)

addpath('/project/expeditions/lem/ClimateCode/sst_project/');

northRow = closestIndex(lat, box_north);
southRow = closestIndex(lat, box_south);
eastCol = closestIndex(lon, box_east);
westCol = closestIndex(lon, box_west);

annual_pacific = double(data(northRow:southRow, westCol:eastCol, :));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_data_pacific = ss(box_row:end-box_row+1, box_col:end-box_col+1, :) ./ (box_row *box_col);


for t = 1:size(mean_box_data_pacific,3)
   current = mean_box_data_pacific(:,:,t);
   [minValues(t) minLoc(t)] = min(current(:));
   [minI(t),minJ(t)] = ind2sub(size(current),minLoc(t));
   [maxValues(t), maxLoc(t)] = max(current(:));
   [maxI(t), maxJ(t)] = ind2sub(size(current), maxLoc(t));
end

lat_region = lat(lat >= box_south & lat <= box_north);
lon_region = lon(lon >= box_west & lon <= box_east);

switch valReturned
    case 'minVal'
        val = minValues';
    case 'maxVal', 
        val = maxValues';
    case 'minLat'
        val = lat_region(minI);
    case 'maxLat'
        val = lat_region(maxI);
    case 'minLon'
        val = lon_region(minJ);
    case 'maxLon'
        val = lon_region(maxJ);
    otherwise
        error('valReturned type not recognized');
end

end



function index = closestIndex(A, x)
    [~,index] = min(abs(A-x));
end