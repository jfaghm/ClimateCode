function [cc, negYears, posYears] = buildSSTIndex()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
addpath('/project/expeditions/lem/ClimateCode/sst_project/');
addpath('/project/expeditions/lem/ClimateCode/Matt/');

load /project/expeditions/lem/ClimateCode/Matt/matFiles/flippedSSTAnomalies.mat;



sstMean = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
count = 1;
for i = 1:12:size(sst, 3)
    sstMean(:, :, count) = nanmean(sst(:, :, i+3-1:i+10-1), 3);
    count = count+1;
end

box_north = sstLat(minIndex(sstLat, 36));
box_south = sstLat(minIndex(sstLat, -6));
box_west = sstLon(minIndex(sstLon, 140));
box_east = sstLon(minIndex(sstLon, 270));

box_row = 5;
box_col = 18;

index = buildIndexHelper(sstMean, box_north, box_south, box_west, box_east, sstLat, sstLon, box_row, box_col);

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
    [~, index] = min(abs(A - x));
end

function index = buildIndexHelper(sst_a,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col, upsideDown)

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

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
   %ss2(:, :, t) = slowSubSum(annual_pacific(:, :, t), box_row, box_col)./ (box_row*box_col);
end


mean_box_sst_pacific = ss(box_row:end-box_row+1,box_col:end-box_col+1,:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns
%mean_box_sst_pacific2 = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns



for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   %current2 = mean_box_sst_pacific2(:, :, t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
   
   %[values2(t) loc2(t)] = max(current2(:));
   %[I2(t),J2(t)] = ind2sub(size(current2),loc2(t));
end

lon_region = lon(lon >= box_west & lon <= box_east);
lat_region = lat(lat >= box_south & lat <= box_north);
index = lon_region(J);
load ../matFiles/condensedHurDat.mat;
year = 1979:2010;
figure%('visible','off')
 for i =1:length(year)
     clmo('surface')
     clmo('Line')
     worldmap([-20 20],[140 -90])
     worldmap world
     setm(gca,'Origin',[0 180])
     pcolorm(double(lat),double(lon),double(sst_a(:,:,i)))
     geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
     
     grid_size = 2;
     %%%%%%%%%%%%%%%%%%%%%%% plot old box
     %{
     current_lon = lon_region(J2(i));
     current_lat = lat_region(I2(i));
     box_lat1 = current_lat - (grid_size*round(box_row/2));
     box_lat2 = current_lat + (grid_size*round(box_row/2));
     box_lon1 = current_lon - (grid_size*round(box_col/2));
     box_lon2 = current_lon + (grid_size*round(box_col/2));
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(double(lat1),double(lon1),'r-')
     plotm(double(lat2),double(lon2),'r-')
     plotm(double(lat3),double(lon3),'r-')
     plotm(double(lat4),double(lon4),'r-')
     %}
     %%%%%%%%%%%%%%%%%%%%%%% plot box
     %box_lat1 = current_lat - (grid_size*round(box_row/2));
     %box_lat2 = current_lat + (grid_size*round(box_row/2));
     %box_lon1 = current_lon - (grid_size*round(box_col/2));
     %box_lon2 = current_lon + (grid_size*round(box_col/2));
     current_lon = lon_region(J(i));
     current_lat = lat_region(I(i));
     box_lat1 = current_lat;
     box_lat2 = current_lat - (box_row-1) * grid_size;
     box_lon1 = current_lon;
     box_lon2 = current_lon + (box_col-1) * grid_size; 
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(double(lat1),double(lon1),'k-')
     plotm(double(lat2),double(lon2),'k-')
     plotm(double(lat3),double(lon3),'k-')
     plotm(double(lat4),double(lon4),'k-')
     %%%%%%%%%%%%%%%%%%%%%%%%%%% plot search space box
     [lat1, lon1] = track2('rh', box_south, box_west, box_north, box_west);
     [lat2, lon2] = track2('rh', box_north, box_west, box_north, box_east);
     [lat3, lon3] = track2('rh', box_north, box_east, box_south, box_east);
     [lat4, lon4] = track2('rh', box_south, box_west, box_south, box_east);
     plotm(double(lat1), double(lon1), 'k--');
     plotm(double(lat2), double(lon2), 'k--');
     plotm(double(lat3), double(lon3), 'k--');
     plotm(double(lat4), double(lon4), 'k--');
     
     caxis([-5 5])
     colorbar('EastOutside');
     current_pdi = sum(condensedHurDat(condensedHurDat(:,1)==year(i),11))/10^7;
     current_ace = sum(condensedHurDat(condensedHurDat(:,1)==year(i),12))/10^5;
     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
     all_storms = length(condensedHurDat(condensedHurDat(:, 1) == year(i)&condensedHurDat(:,10) >= 0));
     title([num2str(year(i)) ': ' num2str(all_storms) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes'])
     %print('-dpdf', '-r350',strcat('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/max_sst_location_10_by_40_location_minus_30_w_hurricanes',num2str(i)))
     %print('-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/sst/max_sst_location_10_by_40_location_minus_30_w_hurricanes' num2str(i)]);
 end



end