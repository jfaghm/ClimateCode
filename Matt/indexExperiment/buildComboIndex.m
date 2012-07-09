function[sstYears, pressYears, comboYears, ccIndex, ccPressure, ccCombo ] = buildComboIndex(data)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

pMean = zeros(size(data, 1), size(data, 2), size(data, 3)/12);

meanPressure = nanmean(data, 3);
meanPressure = repmat(meanPressure, [1, 1, size(data, 3)]);
stdPress = std(data, 0, 3);
stdPress = repmat(stdPress, [1, 1, size(data, 3)]);
data = (data - meanPressure) ./ stdPress;

load ../matFiles/sstAnomalies.mat;

addpath('../../sst_project/');

year = 1;
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+3 - 1:i+10 - 1), 3); 
   pMean(:, :,year) = nanmean(data(:, :, i+3-1:i+10-1), 3);
   year = year+1;
end


pLat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
pLon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
pLat = sort(pLat);


box_north = pLat(pLat > 51.7 & pLat < 52.7);
box_south = pLat(pLat > -6.5 & pLat < -5.3);
box_west = pLon(pLon > 139.3 & pLon < 140.5);
box_east = pLon(pLon > 269.4 & pLon < 270.5);

box_row = 5;
box_col = 10;

pressureSS = struct('north', box_north, 'south', box_south, 'east', box_east, 'west', box_west);
sstSS = struct('north', 52, 'south', -6,'east', 270, 'west', 140);
box = struct('row', 5, 'col', 18);


sstGrid = struct('lat', -88:2:88, 'lon', 0:2:358);
pressureGrid = struct('lat', pLat, 'lon', pLon);

[index, pressureIndex, comboIndex] = buildIndex3(sstMean, pMean, sstSS, pressureSS, box, sstGrid, pressureGrid);

baseYear = 1979;
stdDev = std(index);
normalizedIndex = (index - mean(index)) ./ stdDev;

sstYears = struct('positive', find(normalizedIndex >= 1) + baseYear - 1, 'negative', find(normalizedIndex <= -1) + baseYear - 1);

normalizedIndex = (pressureIndex - mean(pressureIndex)) ./ std(pressureIndex);
pressYears = struct('positive', find(normalizedIndex >= 1)' + baseYear - 1, 'negative', find(normalizedIndex <= -1)' + baseYear - 1);

normalizedIndex = (comboIndex - mean(comboIndex)) ./ std(comboIndex);
comboYears = struct('positive', find(normalizedIndex >= 1) + baseYear - 1, 'negative', find(normalizedIndex <= -1) + baseYear - 1);

load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat
load ../matFiles/condensedHurDat.mat;
year = 1979:2010;
aso_tcs = zeros(size(1979:2010, 2), 1);
aso_major_hurricanes = zeros(size(1979:2010, 2), 1);
aso_ace = zeros(size(1979:2010, 2), 1);
aso_pdi = zeros(size(1979:2010, 2), 1);
aso_ntc = zeros(size(1979:2010, 2), 1);
for i = 1:(2010-1979+1)
    aso_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    aso_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    aso_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,12))/10^5;
    aso_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,11))/10^7;
    aso_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 8:10); 
end



ccIndex(1) = corr(index', aso_tcs);
ccIndex(2) = corr(index', aso_major_hurricanes);
ccIndex(3) = corr(index', aso_ace);
ccIndex(4) = corr(index', aso_pdi);
ccIndex(5) = corr(index', aso_ntc);

ccPressure(1) = corr(pressureIndex, aso_tcs);
ccPressure(2) = corr(pressureIndex, aso_major_hurricanes);
ccPressure(3) = corr(pressureIndex, aso_ace);
ccPressure(4) = corr(pressureIndex, aso_pdi);
ccPressure(5) = corr(pressureIndex, aso_ntc);

ccCombo(1) = corr(comboIndex', aso_tcs);
ccCombo(2) = corr(comboIndex', aso_major_hurricanes);
ccCombo(3) = corr(comboIndex', aso_ace);
ccCombo(4) = corr(comboIndex', aso_pdi);
ccCombo(5) = corr(comboIndex', aso_ntc);
end

