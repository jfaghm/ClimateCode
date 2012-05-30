%verify our pacific index
clear
close all
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
load('sst_study.mat')
start_year = 1971;
end_year = 2010;
raw_data = 0;
if(raw_data)
   load('/project/expeditions/haasken/data/ERSSTV3/erSSTV3Ind.mat')
   sst_data = erSST(:,:,erDates >=start_year*100 & erDates<(end_year+1)*100);
   current_dates = erDates(erDates >=start_year*100 &erDates<(end_year+1)*100); 
   
else
    file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc';
    ncid = netcdf.open(file_name,'NC_NOWRITE');
    varid_sst = netcdf.inqVarID(ncid,'sst');
    sst_data =  squeeze(netcdf.getVar(ncid,varid_sst));
    sst_data(sst_data==-999)=NaN;
    sst_data = permute(sst_data,[2 1 3])./100;
    base_start = 1948;
    skip = start_year - base_start;
    sst_data = sst_data(:,:,(skip*12)+1:end); %skip until start year
end

season_start = 1;
season_end = 12;
count = 1;
for i=1:12:size(sst_data,3)
    annual_sst(:,:,count) = nanmean(sst_data(:,:,i+(season_start-1):i+(season_end-1)),3);
    count=count+1; 
end
load('monthly_nino_data.mat')
nino_data = data;
years = unique(nino_data(:,1));
years = years(years>=1971 & years <= 2010);
months = [season_start:season_end];

for i = 1:length(years)
    nino12_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i) & ismember(nino_data(:,2),months),4));
    nino3_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i)& ismember(nino_data(:,2),months),6));
    nino4_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i)& ismember(nino_data(:,2),months),8));
    nino34_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i)& ismember(nino_data(:,2),months),10));
end
lat = 88:-2:-88;
lon = 0:2:358;
box_north = 10;
box_south = -30;
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
annual_pacific = double(annual_sst(northRow:southRow,westCol:eastCol,:));
box_row =2;
box_col = 20;
for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end
mean_box_sst_pacific = ss(round(box_row/2):end-round(box_row/2),round(box_col/2):end-round(box_col/2),:)./(box_row*box_col);
for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [index(t) loc(t)] = max(current(:));
end
for i = 1:size(loc,2)
    [I(i),J(i)] = ind2sub(size(mean_box_sst_pacific),loc(i));
end

corr(J',all_storms(6,:)')
lat=-88:2:88;
lon=0:2:358;
%the subset region lat-lon
lat1 = -30:2:12;
lon1 = 140:2:270;

figure('visible','off')
year=1971:2010;
% for i =2:40
%     clmo('surface')
%     clmo('Line')
%     worldmap([-20 20],[140 -90])
%     worldmap world
%     setm(gca,'Origin',[0 180])
%     pcolorm(lat,lon,annual_sst(:,:,i))
%     geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
%     current_lon = lon1(J(i));
%     current_lat = lat1(I(i));
%     grid_size = 2;
%     box_lat1 = current_lat - (grid_size*round(box_row/2));
%     box_lat2 = current_lat + (grid_size*round(box_row/2));
%     box_lon1 = current_lon - (grid_size*round(box_col/2));
%     box_lon2 = current_lon + (grid_size*round(box_col/2));
%     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
%     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
%     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
%     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
%     plotm(lat1,lon1,'k-')
%     plotm(lat2,lon2,'k-')
%     plotm(lat3,lon3,'k-')
%     plotm(lat4,lon4,'k-')
%     caxis([-5 5])
%     colorbar('EastOutside');
%     current_pdi = sum(condensedHurDat(condensedHurDat(:,1)==year(i),11))/10^7;
%     current_ace = sum(condensedHurDat(condensedHurDat(:,1)==year(i),12))/10^5;
%     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
%     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
%     title([num2str(year(i)) ': ' 'ENSO= ' num2str(nino34_annual_anoms(i)) ' -  ' num2str(all_storms(6,i)) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes - PDI: ' num2str(current_pdi) ' - ACE: ' num2str(current_ace)])
%     print('-dpdf', '-r350',strcat('/project/expeditions/jfagh/code/matlab/sst_project/results/max_sst_location_10_by_40_location_minus_30_w_hurricanes',num2str(i)))
% end





