%builds the new pacific index
clear
close all
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')
load('monthly_nino_data.mat')
load('sst_study.mat')
load('modoki.mat')
load('/project/expeditions/jfagh/data/norway/jfa005/data/mac_backup/jamesfaghmous/Documents/MATLAB/data/modoki/nino_indices.mat');
load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat
nino_data = data;
years = unique(nino_data(:,1));
years = years(years>=1971 & years <= 2010);
for i = 1:length(years)
    nino12_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),4));
    nino3_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),6));
    nino4_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),8));
    nino34_annual_anoms(i) = mean(nino_data(nino_data(:,1)==years(i),10));
end
% file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1971_2010.nc';
% ncid = netcdf.open(file_name,'NC_NOWRITE');
% varid_sst = netcdf.inqVarID(ncid,'sst');
% raw_sst_1971_2010 =  squeeze(netcdf.getVar(ncid,varid_sst));
% raw_sst_1971_2010(raw_sst_1971_2010==-999)=NaN;
% raw_sst_1971_2010 = permute(raw_sst_1971_2010,[2 1 3])./100;
% netcdf.close(ncid);
file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc';
ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_sst = netcdf.inqVarID(ncid,'sst');
sst_1971_2010 =  squeeze(netcdf.getVar(ncid,varid_sst));
sst_1971_2010(sst_1971_2010==-999)=NaN;
sst_1971_2010 = permute(sst_1971_2010,[2 1 3])./100;
sst_1971_2010 = sst_1971_2010(:,:,(23*12)+1:end);
netcdf.close(ncid);



% for i=1:12:size(sst_1971_2010,3)
%     %annual_sst(:,:,count) = nanmean(sst_1971_2010(:,:,i:i+11),3);
%     annual_sst(:,:,count) = nanmean(sst_1971_2010(:,:,i+(season_start-1):i+(season_end-1)),3);
%     raw_annual_sst(:,:,count) = nanmean(raw_sst_1971_2010(:,:,i:i+11),3);
%     count=count+1;
% end

%test month ranges
count2=1;
for season_start = 1:12
    for season_end = season_start:12
        count = 1;
        for i =1:12:size(sst_1971_2010,3)
            annual_sst(:,:,count) = nanmean(sst_1971_2010(:,:,i+(season_start-1):i+(season_end-1)),3);
            count = count+1;
        end
        season{count2} = annual_sst;
        start{count2} = season_start;
        finish{count2} = season_end;
        count2 = count2+1;
    end
    
end






% for i=1:12:size(sst_1971_2010,3)
%     annual_sst(:,:,count) = nanmean(sst_1971_2010(:,:,i:i+11),3);
%     count=count+1;
%     
% end

box_north = 36;
box_south = -6;
box_west = 140;
box_east = 270;
lat = -88:2:88;
% if ismember(box_north, lat)
%    [~, northRow] = ismember(box_north, lat);
%    [~, southRow] = ismember(box_south, lat);
% else
%     error('Bad lat input!');
% end
% if ismember(box_east, lon)
%    [~, eastCol] = ismember(box_east, lon);
%    [~, westCol] = ismember(box_west, lon);
% else
%     error('Bad lat input!');
% end
% annual_pacific = double(annual_sst(southRow:northRow,westCol:eastCol,:));
% raw_annual_pacific = double(raw_annual_sst(southRow:northRow,westCol:eastCol,:));
% 

% for t=1:size(annual_pacific,3)
%    ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
%    raw_ss(:,:,t) = sub_sum(raw_annual_pacific(:,:,t),box_row,box_col); 
% end
% 
% mean_box_sst_pacific = ss(round(box_row/2):end-round(box_row/2),round(box_col/2):end-round(box_col/2),:)./(box_row*box_col);
% raw_mean_box_sst_pacific = raw_ss(round(box_row/2):end-round(box_row/2),round(box_col/2):end-round(box_col/2),:)./(box_row*box_col);
% for t = 1:size(mean_box_sst_pacific,3)
%    current = mean_box_sst_pacific(:,:,t);
%    [index(t) loc(t)] = max(current(:));
%    [I(t),J(t)] = ind2sub(size(current),loc(t));
%   
%    %get the actual temperature in that box
%    raw_current = raw_mean_box_sst_pacific(:,:,t);
%    [raw_index(t) raw_loc(t)] = max(raw_current(:));
% end
% 
%    lat_box = box_south:2:box_north;
%    %lat_box = box_north:-2:box_south;
%    
%    lon_box = 140:2:270;
% 
% corr(all_storms(6,:)',lon_box(J)')
box_row =5;
box_col = 20;
lat=-88:2:88;
lon=0:2:358;
for i=1:size(season,2)
    index{i} = buildIndex(season{i},box_north,box_south,box_west,box_east,lat,lon,box_row,box_col);
    %SHORTEN TS TO GO FROM 1979%
    index{i} = index{i}(9:end);
end
year = 1979:2010;
for i=1:length(year)
    seasonal_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i),11))/10^7;
    seasonal_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i),12))/10^5;
    seasonal_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
    seasonal_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=6&condensedHurDat(:,2)<=10 ,10));
    seasonal_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 6:10);
    
    as_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9 ,10));
    aso_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    jaso_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10 ,10));
    jas_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9 ,10));
    
    as_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9 ,10));
    aso_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    jaso_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10 ,10));
    jas_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9 ,10));
    
    as_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9,12))/10^5;
    aso_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,12))/10^5;
    jaso_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10,12))/10^5;
    jas_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9,12))/10^5;
    
    as_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9,11))/10^7;
    aso_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,11))/10^7;
    jaso_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10,11))/10^7;
    jas_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9,11))/10^7;
    
    as_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 8:9);
    aso_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 8:10);
    jaso_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 7:10);
    jas_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 7:9);
    
    seasonal_mdr_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=6&condensedHurDat(:,2)<=10&condensedHurDat(:,6)>=5&condensedHurDat(:,6)<=30&condensedHurDat(:,7)>=-80&condensedHurDat(:,7)<=-15 ,10));
    as_mdr_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9&condensedHurDat(:,6)>=5&condensedHurDat(:,6)<=30&condensedHurDat(:,7)>=-80&condensedHurDat(:,7)<=-15 ,10));
    aso_mdr_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10&condensedHurDat(:,6)>=5&condensedHurDat(:,6)<=30&condensedHurDat(:,7)>=-80&condensedHurDat(:,7)<=-15 ,10));
    
end


for i=1:size(season,2)
    cc(i) = corr(index{i}', seasonal_tcs');
    cc2(i) = corr(index{i}', seasonal_major_hurricanes');
    cc3(i) = corr(index{i}', seasonal_ace');
    cc4(i) = corr(index{i}', seasonal_pdi');
    cc5(i) = corr(index{i}', seasonal_ntc');
    
    cc6(i) = corr(index{i}', as_tcs');
    cc7(i) = corr(index{i}', as_major_hurricanes');
    cc8(i) = corr(index{i}', as_ace');
    cc9(i) = corr(index{i}', as_pdi');
    cc10(i) = corr(index{i}', as_ntc');
    
    cc11(i) = corr(index{i}', aso_tcs');
    cc12(i) = corr(index{i}', aso_major_hurricanes');
    cc13(i) = corr(index{i}', aso_ace');
    cc14(i) = corr(index{i}', aso_pdi');
    cc15(i) = corr(index{i}', aso_ntc');
    
    cc16(i) = corr(index{i}', jaso_tcs');
    cc17(i) = corr(index{i}', jaso_major_hurricanes');
    cc18(i) = corr(index{i}', jaso_ace');
    cc19(i) = corr(index{i}', jaso_pdi');
    cc20(i) = corr(index{i}', jaso_ntc');
    
    cc21(i) = corr(index{i}', jas_tcs');
    cc22(i) = corr(index{i}', jas_major_hurricanes');
    cc23(i) = corr(index{i}', jas_ace');
    cc24(i) = corr(index{i}', jas_pdi');
    cc25(i) = corr(index{i}', jas_ntc');
    
    cc26(i) = corr(index{i}',seasonal_mdr_tcs');
    cc27(i) = corr(index{i}',as_mdr_tcs');
    cc28(i) = corr(index{i}',aso_mdr_tcs');
    
end

[val,ii] = sort(cc28);
ss = cell2mat(start');
ff = cell2mat(finish');

results = [ss(ii) ff(ii) val' cc17(ii)' cc18(ii)' cc19(ii)' cc20(ii)'];


%figure('visible','on')
% year=1971:2010;
% for i =1:40
% 
%     clmo('surface')
%     clmo('Line')
%     worldmap world
%     setm(gca,'Origin',[0 180])
%  
%     pcolorm(lat,lon,annual_sst(:,:,i))
%     geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
%     current_lon = lon_box(J(i));
%     current_lat = lat_box(I(i));
%     grid_size = 2;
% 
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
%     caxis([-3 3])
%     colorbar('EastOutside')
%     current_pdi = sum(condensedHurDat(condensedHurDat(:,1)==year(i),11))/10^7;
%     current_ace = sum(condensedHurDat(condensedHurDat(:,1)==year(i),12))/10^5;
%     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
%     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
%     title([num2str(year(i)) ': ' 'ENSO= ' num2str(nino34_annual_anoms(i)) ' -  ' num2str(all_storms(6,i)) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes - PDI: ' num2str(current_pdi) ' - ACE: ' num2str(current_ace)])
%     print('-dpdf', '-r350',strcat('new_plot_30_',num2str(i)))
% end

% for i =1:7
%     cc(i) = corr(all_storms(i,:)',lon_box(J)');
%     cc2(i) = corr(all_storms(i,:)',I');
% end
% r(1) = cc(6);
% r(4)= corr(seasonal_pdi',J');
% r(5)=corr(seasonal_ace',J');
% r(2)=corr(seasonal_hurricanes',J');
% r(3)=corr(seasonal_major_hurricanes',J');

