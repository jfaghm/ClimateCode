% %make tropospheric warming composites
% load('ersstv3_1854_2012_raw.mat')
% load('trop_warming_jan_1979_dec_2010.mat');
% season_trop_anomalies = permute(season_trop_anomalies,[2 1 3]);
% trop_temp_anoms = permute(trop_temp_anoms,[2 1 3]);
% lon_trop_temp = double(lon_trop_temp);
% lat_trop_temp = double(lat_trop_temp);
% 
% sigma = 0.5;
% baseYear = 1979;
% 
% [sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1948,2010);
% sstA_year = getAnnualSSTAnomalies(6,10,1979,2010,sstA,sstA_dates);
% [index, maxI, maxJ, minI, minJ] = buildSSTLon(sstA_year, sstLat, sstLon);
% normalizedIndex = (index - mean(index)) ./ std(index);
% 
% corr(normalizedIndex,PCs);
% 
% negYears = find(normalizedIndex >= sigma) + baseYear - 1;
% posYears = find(normalizedIndex <= -sigma) + baseYear - 1;
% 
% years = 1979:2010;
% 
% posIndex = ismember(years,posYears);
% negIndex = ismember(years,negYears);
% 
% 
% 
% 
% %get the DEQ-PC regions
% %region1
% lat_min1 = 0;
% lat_max1 = 20;
% lon_min1 = -70+360;
% lon_max1 = -20+360;
% 
% 
% 
% lon_mask1 = lon_trop_temp <= lon_max1 & lon_trop_temp >= lon_min1;
% lat_mask1 = lat_trop_temp >= lat_min1 & lat_trop_temp <= lat_max1;
% 
% 
% 
% 
% %region2
% lat_min2 = 8;
% lat_max2 = 20;
% lon_min2 = -84+360;
% lon_max2= -70+360;
% 
% lon_mask2 = lon_trop_temp <= lon_max2 & lon_trop_temp >= lon_min2;
% lat_mask2 = lat_trop_temp >= lat_min2 & lat_trop_temp <= lat_max2;
% 
% %region3
% lat_min3 = 14;
% lat_max3 = 20;
% lon_min3 = -90+360;
% lon_max3= -84+360;
% 
% lon_mask3 = lon_trop_temp <= lon_max3 & lon_trop_temp >= lon_min3;
% lat_mask3 = lat_trop_temp >= lat_min3 & lat_trop_temp <= lat_max3;
% 
% %big pacific region we want to remove
% lat_min4 = 0;
% lat_max4 = 20;
% lon_min4 = -90+360;
% lon_max4= -70+360;
% 
% lon_mask4 = lon_trop_temp <= lon_max4 & lon_trop_temp >= lon_min4;
% lat_mask4 = lat_trop_temp >= lat_min4 & lat_trop_temp <= lat_max4;
% 
% 
% mask1 = buildmask(lat_mask1,lon_mask1);
% mask2 = buildmask(lat_mask2,lon_mask2);
% mask3 = buildmask(lat_mask3,lon_mask3);
% mm = mask1|mask2|mask3;
% 
% 
% %mask data
% for i=1:size(season_trop_anomalies,3)
%     tt = season_trop_anomalies(:,:,i);
%     tt(~mm)=NaN;
%     dd(:,:,i)=tt;
% end
% 
% %mdr_temp = season_trop_anomalies(lat_mask,lon_mask,:);
% [maps, PCs] = eof(dd, 2);
% 
% % get post and negative DEQ-PC
% [map_pos, mdr_deq_pc_pos] = eof(dd(:,:,posIndex),2);
% [map_neg, mdr_deq_pc_neg] = eof(dd(:,:,negIndex),2);
% 
figure
worldmap([0 20],[-90 -20])
pcolorm(double(lat_trop_temp),double(lon_trop_temp),map_neg)
coast = load('coast');
geoshow(coast.lat, coast.long, 'Color', 'black')

figure
worldmap([0 20],[-90 -20])
pcolorm(double(lat_trop_temp),double(lon_trop_temp),map_pos)
coast = load('coast');
geoshow(coast.lat, coast.long, 'Color', 'black')
% 
% figure
% worldmap([0 35],[-90 0]);
% pcolorm(double(lat_trop_temp),double(lon_trop_temp),meanPosWarming);
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% caxis([-0.5,0.5])
% title(['Mean tropospheric anomalies for positive years with ' num2str(sigma) ' std']);
% 
% figure
% worldmap([0 35],[-90 0]);
% pcolorm(double(lat_trop_temp),double(lon_trop_temp),meanNegWarming);
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% caxis([-0.5,0.5])
% title(['Mean tropospheric anomalies for negative years with ' num2str(sigma) ' std']);
% 
% figure
% worldmap([0 35],[-90 0]);
% pcolorm(double(lat_trop_temp),double(lon_trop_temp),meanPosWarming-meanNegWarming);
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% caxis([-0.75,0.75])
% title(['Composite mean tropospheric anomalies (positive - negative) with ' num2str(sigma) ' std']);
% 
% figure
% plot(1979:2010,normalizedIndex);
% hold on
% plot(posYears,normalizedIndex(posIndex),'g*');
% plot(negYears,normalizedIndex(negIndex),'r*');
% title(['June-October S-ENSO with ' num2str(sigma) ' std']);
% 
% 
% %%%%% Get the VWS composites
% load('windShear.mat')
% windShear = permute(windShear,[2 1 3]);
% count = 1;
% for i=6:12:size(windShear,3)
%    mean_wind_shear_june_october(:,:,count) =  mean(windShear(:,:,i:i+4),3);
%    count = count+1;
% end
% 
% meanPosShear = mean(mean_wind_shear_june_october(:,:,posIndex),3);
% meanNegShear = mean(mean_wind_shear_june_october(:,:,negIndex),3);
% 
% figure
% worldmap([0 35],[-90 0]);
% pcolorm(double(lat),double(lon),double(meanPosShear));
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% caxis([0,30])
% title(['Mean wind shear for positive years with ' num2str(sigma) ' std']);
% 
% figure
% worldmap([0 35],[-90 0]);
% pcolorm(double(lat),double(lon),double(meanNegShear));
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% caxis([0,30])
% title(['Mean wind shear for negative years with ' num2str(sigma) ' std']);
% 
% figure
% worldmap([0 35],[-90 0]);
% pcolorm(double(lat),double(lon),double(meanPosShear)-double(meanNegShear));
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% caxis([-10,10])
% title(['Composite mean wind shear (positive - negative) with ' num2str(sigma) ' std']);
% 
% %% get storm origin composites
% load condensedHurDat
% 
% 
% 
% for y =1:length(negYears)
%    current_year =negYears(y);
%    neg_stroms{y} = condensedHurDat(condensedHurDat(:,1)==current_year & condensedHurDat(:,2)>=6 & condensedHurDat(:,4)<=10,:);
% end
% 
% for y =1:length(posYears)
%    current_year =posYears(y);
%    pos_stroms{y} = condensedHurDat(condensedHurDat(:,1)==current_year & condensedHurDat(:,2)>=6 & condensedHurDat(:,4)<=10,:);
% end
% 
% 
% a = cell2mat(neg_stroms');
% b= cell2mat(pos_stroms');
% 
% neg_lats = a(:,6);
% neg_lons = a(:,7);
% 
% 
% k = length(find(a(:,6)>=20))
% kk = length(find(a(:,6)<20))
% 
% ratio = kk/length(neg_lats)
% 
% figure
% worldmap world
% plotm(neg_lats, neg_lons,'r*')
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% 
% pos_lats = b(:,6);
% pos_lons = b(:,7);
% 
% p = length(find(b(:,6)>=20))
% pp = length(find(b(:,6)<20))
% 
% rr = pp/length(pos_lats)
% 
% rr-ratio
% 
% 
% figure
% worldmap world
% plotm(pos_lats, pos_lons,'g*')
% coast = load('coast');
% geoshow(coast.lat, coast.long, 'Color', 'black')
% 
% %% visualize storm data
%  load('all_storms_pos_and_neg_s_nino_years.mat')
%  %view by intensity
%  pos_stomrs_by_strength{1} = all_storms_positive_s_nino(all_storms_positive_s_nino(:,10)<1,:);
%  for i=2:6
%     pos_stomrs_by_strength{i} = all_storms_positive_s_nino(all_storms_positive_s_nino(:,10)==i-1,:);
%  end
%  
% for i=1:6
%     title = ['Strength: ' num2str(i-1) ' Postive years'];
%     figure
%     plot_storm_locations(pos_stomrs_by_strength{i}(:,6),pos_stomrs_by_strength{i}(:,7),'*b', title);
%     saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/by_strength/pos_stength',num2str(i-1),'.eps'),'eps');
% end
% close all
%  
% neg_stomrs_by_strength{1} = all_storms_negative_s_nino(all_storms_negative_s_nino(:,10)<1,:);
%  for i=2:6
%     neg_stomrs_by_strength{i} = all_storms_negative_s_nino(all_storms_negative_s_nino(:,10)==i-1,:);
%  end
%  
% for i=1:6
%     title = ['Strength: ' num2str(i-1) ' Negative years'];
%     figure
%     plot_storm_locations(neg_stomrs_by_strength{i}(:,6),neg_stomrs_by_strength{i}(:,7),'*', title);
%     saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/by_strength/neg_stength',num2str(i-1),'.eps'),'eps');
% end
% close all
% 
% 
% %% month by month analysis
% for i=1:5
%     pos_storms_by_month{i} = all_storms_positive_s_nino(all_storms_positive_s_nino(:,2)==i+5,:);
% end
% for i=1:5
%     title = ['Month: ' num2str(i+5) ' Postive years'];
%     figure
%     plot_storm_locations(pos_storms_by_month{i}(:,6),pos_storms_by_month{i}(:,7),'*b', title);
%     saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/by_month/pos_month',num2str(i+5),'.eps'),'eps');
% end
% close all
% 
% for i=1:5
%     neg_storms_by_month{i} = all_storms_negative_s_nino(all_storms_negative_s_nino(:,2)==i+5,:);
% end
% for i=1:5
%     title = ['Month: ' num2str(i+5) ' Negative years'];
%     figure
%     plot_storm_locations(neg_storms_by_month{i}(:,6),neg_storms_by_month{i}(:,7),'*b', title);
%     saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/by_month/neg_month',num2str(i+5),'.eps'),'eps');
% end
% close all

%% analyze month by month SST, Trop Temp, VWS, and DEQPC
%assumes sstA is already computed
for i=1:6
    sstA_by_month{i} = getAnnualSSTAnomalies(i+4,i+4,1979,2010,sstA,sstA_dates); %may to oct monthly anomalies
end
for i =1:6
    current_month = sstA_by_month{i};
    pos_sst_by_month = mean(current_month(:,:,posIndex),3);
    pos_sst_by_month_std = std(current_month(:,:,posIndex),0,3);
    fig_title = ['SST Anomalies Month: ' num2str(i+4) ' Positive years'];
    figure
    worldmap world
    title(fig_title);
    pcolorm(double(sstLat),double(sstLon),pos_sst_by_month);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([-2 2])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/sst/pos_mean_ssta',num2str(i+4),'.pdf'),'pdf');
    figure
    worldmap world
    title(strcat('std',num2str(i)));
    pcolorm(double(sstLat),double(sstLon),pos_sst_by_month_std);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([0 2])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/sst/pos_std_ssta',num2str(i+4),'.pdf'),'pdf');
    close all
end
for i =1:6
    current_month = sstA_by_month{i};
    neg_sst_by_month = mean(current_month(:,:,negIndex),3);
    neg_sst_by_month_std = std(current_month(:,:,negIndex),0,3);
    fig_title = ['SST Anomalies Month: ' num2str(i+4) ' Negative years'];
    figure
    worldmap world
    title(fig_title);
    pcolorm(double(sstLat),double(sstLon),neg_sst_by_month);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([-2 2])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/sst/neg_mean_ssta',num2str(i+4),'.pdf'),'pdf');
    figure
    worldmap world
    title(strcat('std',num2str(i)));
    pcolorm(double(sstLat),double(sstLon),neg_sst_by_month_std);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([0 2])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/sst/neg_std_ssta',num2str(i+4),'.pdf'),'pdf');
    close all
end
%trop temps
%assumes trop_temp_anomalies_dates
for i=1:6
    trop_temp_anom_by_month{i} = getAnnualSSTAnomalies(i+4,i+4,1979,2010,trop_temp_anoms,trop_temp_anomalies_dates); %may to oct monthly anomalies
end
for i=1:6
    current_month = trop_temp_anom_by_month{i};
    pos_mean_trop_temp_anom_by_month = mean(current_month(:,:,posIndex),3);
    pos_std_trop_temp_anom_by_month = std(current_month(:,:,posIndex),0,3);
    fig_title = ['Tropospheric Temp Anomalies Month: ' num2str(i+4) ' Positive years'];
    figure
    worldmap([0 20],[-90 -15])
    title(fig_title);
    pcolorm(lat_trop_temp,lon_trop_temp,pos_mean_trop_temp_anom_by_month);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([-0.5 0.5])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/trop_temp_anoms/pos_mean_trop_temp_anoms',num2str(i+4),'_mdr.pdf'),'pdf');
    figure
    worldmap([0 20],[-90 -15])
    title(strcat('std',num2str(i)));
    pcolorm(lat_trop_temp,lon_trop_temp,pos_std_trop_temp_anom_by_month);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([0 1])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/trop_temp_anoms/pos_std_trop_temp_anoms',num2str(i+4),'_mdr.pdf'),'pdf');
    close all
end

for i=1:6
    current_month = trop_temp_anom_by_month{i};
    neg_mean_trop_temp_anom_by_month = mean(current_month(:,:,negIndex),3);
    neg_std_trop_temp_anom_by_month = std(current_month(:,:,negIndex),0,3);
    fig_title = ['Tropospheric Temp Anomalies Month: ' num2str(i+4) ' Negative years'];
    figure
    worldmap([0 20],[-90 -15])
    title(fig_title);
    pcolorm(lat_trop_temp,lon_trop_temp,neg_mean_trop_temp_anom_by_month);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([-0.5 0.5])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/trop_temp_anoms/neg_mean_trop_temp_anoms',num2str(i+4),'_mdr.pdf'),'pdf');
    figure
    worldmap([0 20],[-90 -15])
    title(strcat('std',num2str(i)));
    pcolorm(lat_trop_temp,lon_trop_temp,neg_std_trop_temp_anom_by_month);
    coast = load('coast');
    geoshow(coast.lat, coast.long, 'Color', 'black')
    caxis([0 1])
    colorbar
    saveas(gcf,strcat('/project/expeditions/jfagh/code/matlab/ClimateCode/james/s_nino_and_trop_warming/trop_temp_anoms/neg_std_trop_temp_anoms',num2str(i+4),'.pdf'),'pdf');
    close all
end