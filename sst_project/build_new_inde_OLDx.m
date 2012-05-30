%builds the new pacific index
clear
close all
file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1971_2010.nc';
ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_sst = netcdf.inqVarID(ncid,'sst');
sst_1971_2010 =  squeeze(netcdf.getVar(ncid,varid_sst));
sst_1971_2010(sst_1971_2010==-999)=NaN;
sst_1971_2010 = permute(sst_1971_2010,[2 1 3])./100;
count=1;
for i=1:12:size(sst_1971_2010,3)
    annual_sst(:,:,count) = nanmean(sst_1971_2010(:,:,i:i+11),3);
    count=count+1;
    
end
load('sst_study.mat')
load('modoki.mat')
load('/project/expeditions/jfagh/data/norway/jfa005/data/mac_backup/jamesfaghmous/Documents/MATLAB/data/modoki/nino_indices.mat');
box_north = 20;
box_south = -20;
box_west = 140;
box_east = 270;
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
sst_pacific = double(sst_1971_2010(northRow:southRow,westCol:eastCol,:));
count=1;
for i=1:12:size(sst_pacific,3)
    annual_pacific(:,:,count) = nanmean(sst_pacific(:,:,i:i+11),3);
    count=count+1;
end

box_row =5;
box_col = 15;
for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_sst_pacific = ss(round(box_row/2):end-round(box_row/2),round(box_col/2):end-round(box_col/2),:)./(box_row*box_col);
%mean_box_sst_pacific = ss./(box_row*box_col);
for t = 1:size(mean_box_sst_pacific,3)
    current = mean_box_sst_pacific(:,:,t);
   [index(t) loc(t)] = max(current(:));
end
for i = 1:size(loc,2)
    [I(i),J(i)] = ind2sub(size(mean_box_sst_pacific),loc(i));
end
lat=-88:2:88;
lon=0:2:358;
% figure('visible','off')
% for i =1:40
%     
%     subplot(3,1,1)
%     clmo('surface')
%     worldmap world
%     pcolorm(lat,lon,annual_sst(:,:,i));
%     %geoshow('landareas.shp', 'FaceColor', [0.15 0.5 0.15])
%     caxis([-10 35])
%     
%     subplot(3,1,2)
%     clmo('surface')
%     worldmap([-20 20],[140 -90])
%     pcolorm(lat,lon,annual_pacific(:,:,i))
%     %geoshow('landareas.shp', 'FaceColor', [0.15 0.5 0.15])
%     caxis([-10 35])
%     
%     subplot(3,1,3)
%     clmo('surface')
%     clmo('Line')
%     worldmap([-20 20],[140 -90])
%     lat1 = 20:-2:-20;
%     lon1 = 140:2:270;
%     pcolorm(lat1,lon1,mean_box_sst_pacific(:,:,i))
%     %geoshow('landareas.shp', 'FaceColor', [0.15 0.5 0.15])
%     current_lon = lon1(J(i));
%     current_lat = lat1(I(i));
%     grid_size = 2;
%     box_lat1 = max(-20,current_lat - (grid_size*round(box_row/2)));
%     box_lat2 = min(20,current_lat + (grid_size*round(box_row/2)));
%     box_lon1 = max(current_lon - (grid_size*round(box_col/2)),140);
%     box_lon2 = min(current_lon + (grid_size*round(box_col/2)),270);
%     %linem([box_lat1;box_lat2; box_lat2;box_lat2;box_lat2;box_lat1;box_lat1;box_lat1],[box_lon1;box_lon1;box_lon1;box_lon2;box_lon2;box_lon1;box_lon1;box_lon2],'k-')
%     linem([box_lat1;box_lat2;box_lat1;box_lat1;box_lat2;box_lat2],[box_lon1;box_lon1;box_lon1;box_lon2;box_lon2;box_lon1],'k-')
%     caxis([-10 35])
%     print('-dpdf', '-r350',strcat('max_sst_location_10_by_30',num2str(i)))
% end

% index_1971_2010 = index(24:end);
% %index_1971_2010 = index((23*12)+1:end);%monthly index from 1971-2010
% %index_1971_2010 = reshape(index_1971_2010,12,[]);
% 
% 
% month_offset = 1:12;
% %data = mean(index_1971_2010(1:12,:),1);
% % zone_a = mean(zone_a(month_offset,yr_offset:end));
% % zone_b = mean(zone_b(month_offset,yr_offset:end));
% % zone_c = mean(zone_c(month_offset,yr_offset:end));
% % annual_modoki = mean(annual_modoki(month_offset,yr_offset:end));
% % 
% % %correlate with storms
% % data = [zone_a;zone_b;zone_c;annual_modoki];
for i =1:7
    cc(i) = corr(ea_stroms(i,:)',index')
end