
function [index, cc, ccIndex] = buildIndex4()
load /project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/olrAnomalies.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/pressureAnomalies.mat;

year = 1;
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+3 - 1:i+10 - 1), 3); 
   pMean(:, :,year) = nanmean(pressure(:, :, i+3-1:i+10-1), 3);
   olrMean(:, :, year) = nanmean(olr(:, :, i+3-1:i+10-1), 3);
   year = year+1;
end

box_north = sstLat(minIndex(sstLat, 35));
box_south = sstLat(minIndex(sstLat, -5));
box_west = sstLon(minIndex(sstLon, 140));
box_east = sstLon(minIndex(sstLon, 270));
box_row = 5;
box_col = 18;
[sstI, sstJ, sstValues] = buildIndexGeneric(sstMean, box_north, box_south, box_west, box_east, sstLat, sstLon, box_row, box_col, @max);
sstLonRegion = sstLon(sstLon >= box_west & sstLon <= box_east);
sstLatRegion = sstLat(sstLat >=  box_south & sstLat <= box_north);


box_north = olrLat(minIndex(olrLat, 35));
box_south = olrLat(minIndex(olrLat, -5));
box_west = olrLon(minIndex(olrLon, 140));
box_east = olrLon(minIndex(olrLon, 270));

[olrI, olrJ, olrValues] = buildIndexGeneric(olrMean, box_north, box_south, box_west, box_east, olrLat, olrLon, box_row, box_col, @max);
olrLonRegion = olrLon(olrLon >= box_west & olrLon <= box_east);
olrLatRegion = olrLat(olrLat >= box_south & olrLat <= box_north);

box_north = pressureLat(minIndex(pressureLat, 35));
box_south = pressureLat(minIndex(pressureLat, -5));
box_west = pressureLon(minIndex(pressureLon, 140));
box_east = pressureLon(minIndex(pressureLon, 270));
pressureLonRegion = pressureLon(pressureLon >= box_west & pressureLon <= box_east);
pressureLatRegion = pressureLat(pressureLat >= box_south & pressureLat <= box_north);

[pressureI, pressureJ, pressureValues] = buildIndexGeneric(pMean, box_north, box_south, box_west, box_east, pressureLat, pressureLon, box_row, box_col, @min);

midpoint = box_west + ((box_east - box_west) / 2);

%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
index = sstLonRegion(sstJ); %-2.5984 correlation
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
indexMatrix = [sstLonRegion(sstJ), olrLonRegion(olrJ), pressureLonRegion(pressureJ)];
index = zeros(length(sstJ), 1);
for i = 1:length(sstJ)
    [~, ind] = max(abs(indexMatrix(i, :) - midpoint)); %correlation 1.1825
    index(i) = indexMatrix(ind);
end
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
indexMatrix = [sstLonRegion(sstJ), olrLonRegion(olrJ), pressureLonRegion(pressureJ)];
index = zeros(length(sstJ), 1);
for i = 1:length(sstJ)
    [~, ind] = min(abs(indexMatrix(i, :) - midpoint)); %correlation -.8803
    index(i) = indexMatrix(ind);
end
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
indexMatrix = [sstLonRegion(sstJ), olrLonRegion(olrJ), pressureLonRegion(pressureJ)];
index = mean(indexMatrix, 2); %correlation -1.7599
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
index = sstLonRegion(sstJ) + olrLonRegion(olrJ) + pressureLatRegion(pressureI);%correlation -2.9478
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
index = sqrt(sstLonRegion(sstJ) + olrLonRegion(olrJ) + pressureLatRegion(pressureI)); %correlation -2.5984
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
indexMatrix = [sstLonRegion(sstJ), olrLonRegion(olrJ), pressureLonRegion(pressureJ)];
index = std(indexMatrix, 0, 2);  %correlation 2.0484
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min
indexMatrix = [sstLonRegion(sstJ), olrLonRegion(olrJ), pressureLonRegion(pressureJ)];
index = range(indexMatrix, 2); %correlation 2.1186
%%%%%%%%%%%%%%%%%%% sst:max, olr:max, pressure:min



load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat
load /project/expeditions/lem/ClimateCode/Matt/matFiles/condensedHurDat.mat;
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
sstIndex = sstLonRegion(sstJ);
ccIndex(1) = corr(sstIndex, aso_tcs);
ccIndex(2) = corr(sstIndex, aso_major_hurricanes);
ccIndex(3) = corr(sstIndex, aso_ace);
ccIndex(4) = corr(sstIndex, aso_pdi);
ccIndex(5) = corr(sstIndex, aso_ntc);

cc(1) = corr(index, aso_tcs); 
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ace);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_ntc);

end


function [I, J, values] = buildIndexGeneric(data,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col, func)

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
annual_pacific = double(data(southRow:northRow,westCol:eastCol,:));



for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_sst_pacific = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns

for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = func(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
end


end


function i = minIndex(A, x)
[~, i] = min(abs(A -x));
end