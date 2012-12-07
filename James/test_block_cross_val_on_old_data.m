%test the predictive power of SST dist on old hurricane counts
clear
load condensedHurDat
start_month =8;
end_month =10;
min_speed = -8;
start_year = 1948;
end_year = 1979;
min_lat = 0;
max_lat = 40;
max_lon = -12;
min_lon = -100;
max_east_lon = -45;
min_west_lon = -45;
all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
storms_1948 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
east_storms_1948 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_east_lon]);
west_storms_1948 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_west_lon max_lon]);

start_year = 1979;
end_year = 2010;
all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
east_storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_east_lon]);
west_storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_west_lon max_lon]);

load('ersstv3Anom.mat','sstLat','sstLon');
sst_dist_index_1948 = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1948, 1979),sstLat,sstLon);
sst_dist_index_1979 = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1979, 2010),sstLat,sstLon);

[B, F] = lasso(sst_dist_index_1979,storms_1979','Lambda',0);
%[B, F, cc, fold_mse, result, summary, mean_mse,std_mse,mean_sub_mse,std_sub_mse] =  lassoBlockCrossValidation(index_1979,storms_1979',8, 0);
%[B, F, y_pred fold_mse] =  lassoCrossValidation(sst_dist_index_1979,storms_1979',8, 0);
y_pred_1948 = B * sst_dist_index_1948 + F.Intercept;
corr(y_pred_1948,storms_1948')
mse = mean(sqrt((y_pred_1948 - storms_1948').^2))
%plot(1948:1979,y_pred_1948);
%hold on
%plot(1948:1979,storms_1948,'-r');
%hold off
