function [ negYears, posYears, cc, index ] = buildPressureIndex(data, pLat, pLon)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

pMean = zeros(size(data, 1), size(data, 2), size(data, 3)/12);

meanPressure = nanmean(data, 3);
meanPressure = repmat(meanPressure, [1, 1, size(data, 3)]);
stdPress = std(data, 0, 3);
stdPress = repmat(stdPress, [1, 1, size(data, 3)]);
data = (data - meanPressure) ./ stdPress;


year = 1;
for i = 1:12:(2010-1979+1)*12
   pMean(:, :,year) = nanmean(data(:, :, i+3-1:i+10-1), 3);
   year = year+1;
end

pLat = sort(pLat);

box_north = pLat(pLat > 51.7 & pLat < 52.7);
box_south = pLat(pLat > -6.5 & pLat < -5.3);
box_west = pLon(pLon > 139.3 & pLon < 140.5);
box_east = pLon(pLon > 269.4 & pLon < 270.5);

box_row = 5;
box_col = 18;

index = buildIndex2(pMean, box_north, box_south, box_west, box_east, pLat, pLon, box_row, box_col);

baseYear = 1979;
stdDev = std(index);
normalizedIndex = (index - mean(index)) ./ stdDev;

posYears = find(normalizedIndex >= 1) + baseYear - 1;
negYears = find(normalizedIndex <= -1) + baseYear - 1;

load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat
load matFiles/condensedHurDat.mat;
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


cc(1) = corr(index, aso_tcs);
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ace);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_ntc);

end

