%buildIndex
%Input: 
% sst_a: Sea Surface Temperature anomaly data
% box_south, box_noth, box_east, box_west: the south, north, east, west
% boundaries of the search space
% box_col, box_row: the width and height of the box we average SSTA over.
% unites are grid points so box_row =2 means a box height of 2 x
% data_resolution for example 2x 2.5 = 5 degrees
%Output:
% index: a 1-d array with the longitude of the box with the highest
% anomaly
function [index, latIndex, euclidIndex] = buildIndex(sst_a,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col, func)

%Let the user decide if they want the maximum or minimum valued box.  If
%not specified by the user, then use max by default
if nargin == 9
    func = @max;
end

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
end

%mean_box_sst_pacific = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns
mean_box_sst_pacific = ss(box_row:end-box_row+1, box_col:end-box_col+1, :) ./ (box_row * box_col);

for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
end

lon_region = lon(lon >= box_west & lon <= box_east);
lat_region = lat(lat >= box_south & lat <= box_north);
%lon_region = box_west:box_east;
index = lon_region(J);
latIndex = lat_region(I);
euclidIndex = sqrt(lat_region(I).^2 + lon_region(J).^2);

  
%{
%the subset region lat-lon
%lat1 = -30:2.5:12;
%lon1 = 140:2.5:270;

lat1 = double(lat(lat >= box_south & lat <= box_north));
lon1 = double(lon(lon >= box_west & lon <= box_east));


load /project/expeditions/lem/ClimateCode/Matt/matFiles/condensedHurDat.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/flippedSSTAnomalies.mat
figure%('visible','off')
year=1979:2010;
 for i =2:3  %40
     clmo('surface')
     clmo('Line')
     %worldmap([-20 20],[140 -90])
     worldmap world
     %setm(gca,'Origin',[0 180])
     pcolorm(double(lat),double(lon),sst(:,:,i))
     geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
     current_lon = lon1(J(i));
     current_lat = lat1(I(i));
     grid_size = 2;
     box_lat1 = current_lat;% - (grid_size*round(box_row/2));
     box_lat2 = current_lat - (grid_size*box_row);
     box_lon1 = current_lon;
     box_lon2 = current_lon + (grid_size*box_col);
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(lat1,lon1,'k-')
     plotm(lat2,lon2,'k-')
     plotm(lat3,lon3,'k-')
     plotm(lat4,lon4,'k-')
     caxis([-5 5])
     colorbar('EastOutside');
     current_pdi = sum(condensedHurDat(condensedHurDat(:,1)==year(i),11))/10^7;
     current_ace = sum(condensedHurDat(condensedHurDat(:,1)==year(i),12))/10^5;
     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
     title('No Title For Now');
     %title([num2str(year(i)) ': ' 'ENSO= ' num2str(nino34_annual_anoms(i)) ' -  ' num2str(all_storms(6,i)) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes - PDI: ' num2str(current_pdi) ' - ACE: ' num2str(current_ace)])
     %print('-dpdf', '-r350',strcat('/project/expeditions/lem/ClimateCode/sst_project/results/olrImages/max_sst_location_10_by_40_location_minus_30_w_hurricanes',num2str(i)))
 end
%}
%}
