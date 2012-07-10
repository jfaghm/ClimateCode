function [  negYears, posYears, cc, index ] = getPosNegYearsIndex()
%This function calcaulates the index
%for each year.  The indices are then normalized, and a set of positive and
%negative years are returned that are at least one standard deviation away
%from the average of the indices.
load matFiles/sstAnomalies.mat;
year = 1;
sstMean = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+3 - 1:i+10 - 1), 3); 
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

addpath('../sst_project/');
index = buildIndex(sstMean, box_north, box_south, box_west, box_east, lat, lon, box_row, box_col);

index = index';
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


