function [] = plotBoxOLRAndSST(overlap)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    load /project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat;
    load /project/expeditions/lem/ClimateCode/Matt/matFiles/olrAnomalies.mat;

    startYear = find(olrDates(:, 4) == 1979);
    count = 1;
    annualOLR = zeros(size(olr, 1), size(olr, 2), size(olr, 3)/12);
    annualSST = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
    for i = startYear(1):12:size(olr, 3)
        annualOLR(:, :, count) = nanmean(olr(:, :, i+2:i+9), 3);
        annualSST(:, :, count) = nanmean(sst(:, :, i+2:i+9), 3);
        count = count+1;
    end
    
    box_north = closestVal(olrLat, 36);
    box_south = closestVal(olrLat, -36);
    box_west = closestVal(olrLon, 140);
    box_east = closestVal(olrLon, 270);
    box_row =5;
    box_col = 10;

    [olrI, olrJ] = buildIndexHelper(annualOLR, box_north, box_south,...
        box_west, box_east, olrLat, olrLon, box_row, box_col, false);
    
    box_north = 36;
    box_south = -6;
    box_west = 140;
    box_east = 270;
    
    [sstI, sstJ] = buildIndexHelper(annualSST, box_north, box_south, ...
        box_west, box_east, sstLat, sstLon, box_row, box_col, true);
    

sst_lon_region = sstLon(sstLon >= box_west & sstLon <= box_east);
sst_lat_region = sstLat(sstLat >= box_south & sstLat <= box_north);
olr_lat_region = olrLat(olrLat >= -36 & olrLat <= box_north);
olr_lon_region = olrLon(olrLon >= box_west & olrLon <= box_east);
if overlap == true
load ../matFiles/condensedHurDat.mat;
year = 1979:2010;
figure('visible','off')
for i =1:length(year)
     clmo('surface')
     clmo('Line')
     worldmap([-20 20],[140 -90])
     worldmap world
     setm(gca,'Origin',[0 180])
     pcolorm(double(sstLat),double(sstLon),double(sst(:,:,i)))

     geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
     
     current_lon = sst_lon_region(sstJ(i));
     current_lat = sst_lat_region(sstI(i));
     grid_size = 2;
     
     %%%%%%%%%%%%%%%%%%%%%%% plot SST box
     box_lat1 = current_lat;
     box_lat2 = current_lat - grid_size * box_row - grid_size;
     box_lon1 = current_lon;
     box_lon2 = current_lon + grid_size * box_col - grid_size; 
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(double(lat1),double(lon1),'k-')
     plotm(double(lat2),double(lon2),'k-')
     plotm(double(lat3),double(lon3),'k-')
     plotm(double(lat4),double(lon4),'k-')
     
     %%%%%%%%%%%%%%%%%%%%%%%%%% plot olr box
     box_south = -36;
     olr_lon_region = olrLon(olrLon >= box_west & olrLon <= box_east);
     olr_lat_region = olrLat(olrLat >= box_south & olrLat <= box_north);
     current_lon = olr_lon_region(olrJ(i));
     size(olr_lat_region)
     olrI(i)
     current_lat = olr_lat_region(olrI(i));
     box_lat1 = current_lat;
     box_lat2 = current_lat - grid_size * box_row - grid_size;
     box_lon1 = current_lon;
     box_lon2 = current_lon + grid_size * box_col - grid_size; 
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(double(lat1),double(lon1),'r-')
     plotm(double(lat2),double(lon2),'r-')
     plotm(double(lat3),double(lon3),'r-')
     plotm(double(lat4),double(lon4),'r-')
     %%%%%%%%%%%%%%%%%%%%%%%%%%% plot search space box
     box_south = -36;
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
     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
     all_storms = length(condensedHurDat(condensedHurDat(:, 1) == year(i)&condensedHurDat(:,10) >= 0));
     title([num2str(year(i)) ': ' num2str(all_storms) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes'])
     print('-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/olrAndSST/max_olr_location_10_by_40_location_minus_30_w_hurricanes' num2str(i)]);
 end
else
load ../matFiles/condensedHurDat.mat;
year = 1979:2010;
close all
figure%('visible','off')
 for i =1:1%length(year)
     fig(figure(1), 'units', 'inches', 'width', 8, 'height', 11)
     subplot(2, 1, 1);
     clmo('surface')
     clmo('Line')
     worldmap([-20 20],[140 -90])
     worldmap world
     setm(gca,'Origin',[0 180])
     pcolorm(double(sstLat),double(sstLon),double(sst(:,:,i)))
     %geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
     current_lon = sst_lon_region(sstJ(i));
     current_lat = sst_lat_region(sstI(i));
     grid_size = 2;
     %%%%%%%%%%%%%%%%%%%%%%% plot box
     %box_lat1 = current_lat - (grid_size*round(box_row/2));
     %box_lat2 = current_lat + (grid_size*round(box_row/2));
     %box_lon1 = current_lon - (grid_size*round(box_col/2));
     %box_lon2 = current_lon + (grid_size*round(box_col/2));
     box_lat1 = current_lat;
     box_lat2 = current_lat - grid_size * box_row - grid_size;
     box_lon1 = current_lon;
     box_lon2 = current_lon + grid_size * box_col - grid_size; 
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
     
     colorbar('EastOutside');
     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
     all_storms = length(condensedHurDat(condensedHurDat(:, 1) == year(i)&condensedHurDat(:,10) >= 0));
     title(['SST' num2str(year(i)) ': ' num2str(all_storms) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes'])

     
     subplot(2, 1, 2)
     clmo('surface')
     clmo('Line')
     worldmap([-20 20],[140 -90])
     worldmap world
     setm(gca,'Origin',[0 180])
     pcolorm(double(olrLat),double(olrLon),double(olr(:,:,i)))
     %geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
     current_lon = olr_lon_region(olrJ(i));
     current_lat = olr_lat_region(olrI(i));
     grid_size = 2;
     %%%%%%%%%%%%%%%%%%%%%%% plot box
     %box_lat1 = current_lat - (grid_size*round(box_row/2));
     %box_lat2 = current_lat + (grid_size*round(box_row/2));
     %box_lon1 = current_lon - (grid_size*round(box_col/2));
     %box_lon2 = current_lon + (grid_size*round(box_col/2));
     box_lat1 = current_lat;
     box_lat2 = current_lat - grid_size * box_row - grid_size;
     box_lon1 = current_lon;
     box_lon2 = current_lon + grid_size * box_col - grid_size; 
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(double(lat1),double(lon1),'k-')
     plotm(double(lat2),double(lon2),'k-')
     plotm(double(lat3),double(lon3),'k-')
     plotm(double(lat4),double(lon4),'k-')
     %%%%%%%%%%%%%%%%%%%%%%%%%%% plot search space box
     box_south = -36;
     [lat1, lon1] = track2('rh', box_south, box_west, box_north, box_west);
     [lat2, lon2] = track2('rh', box_north, box_west, box_north, box_east);
     [lat3, lon3] = track2('rh', box_north, box_east, box_south, box_east);
     [lat4, lon4] = track2('rh', box_south, box_west, box_south, box_east);
     plotm(double(lat1), double(lon1), 'k--');
     plotm(double(lat2), double(lon2), 'k--');
     plotm(double(lat3), double(lon3), 'k--');
     plotm(double(lat4), double(lon4), 'k--');
     
     title(['OLR' num2str(year(i)) ': ' num2str(all_storms) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes'])
     colorbar('EastOutside');
     %caxis([-5 5])
     %print('-dpdf', '-r350',strcat('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/max_sst_location_10_by_40_location_minus_30_w_hurricanes',num2str(i)))
     print('-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/SSTOLRSideBySide/max_olr_location_10_by_40_location_minus_30_w_hurricanes' num2str(i)]);
 end
end
    
end

function closest = closestVal(A, x)
[~,index] = min(abs(A-x));
closest = A(index);
end

function [I, J] = buildIndexHelper(sst_a,box_north,box_south,...
    box_west,box_east,lat,lon,box_row,box_col, upsideDown)

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

if upsideDown == false
    annual_pacific = double(sst_a(northRow:southRow,westCol:eastCol,:));
else
    annual_pacific = double(sst_a(southRow:northRow, westCol:eastCol, :));
end

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

%mean_box_sst_pacific = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns
mean_box_sst_pacific = ss(box_row:end-box_row+1, box_col:end-box_col+1, :) ./ (box_row * box_col);
for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));   
end
end