%pre/pos 1979 analysis
clear
load condensedHurDat
start_month =8;
end_month =10;
min_speed = -8;
start_year = 1979;
end_year = 2012;
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

start_year = 1950;
end_year = 2010;
all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
storms_full = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
east_storms_full = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_east_lon]);
west_storms_full = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_west_lon max_lon]);



nino34_1948 = getNINO(1950,1979,6,10,2);
nino34_1979 = getNINO(1979,2010,6,10,2);
nino34_full = getNINO(1950,2010,6,10,2);

nino12_1948 = getNINO(1950,1979,6,10,1);
nino12_1979 = getNINO(1979,2010,6,10,1);
nino12_full = getNINO(1950,2010,6,10,1);

nino3_1948 = getNINO(1950,1979,6,10,3);
nino3_1979 = getNINO(1979,2010,6,10,3);
nino3_full = getNINO(1950,2010,6,10,3);

nino4_1948 = getNINO(1950,1979,6,10,4);
nino4_1979 = getNINO(1979,2010,6,10,4);
nino4_full = getNINO(1950,2010,6,10,4);

cc(1) = corr(nino34_1948',storms_1948');
cc(2) = corr(nino34_1979',storms_1979');
cc(3) = corr(nino34_full',storms_full');

cc(4) = corr(nino12_1948',storms_1948');
cc(5) = corr(nino12_1979',storms_1979');
cc(6) = corr(nino12_full',storms_full');

cc(7) = corr(nino3_1948',storms_1948');
cc(8) = corr(nino3_1979',storms_1979');
cc(9) = corr(nino3_full',storms_full');

cc(10) = corr(nino4_1948',storms_1948');
cc(11) = corr(nino4_1979',storms_1979');
cc(12) = corr(nino4_full',storms_full');

%get the EOFs
% sst_1948 = getAnnualSSTAnomalies(6, 10, 1950, 1979);
% sst_1979 = getAnnualSSTAnomalies(6, 10, 1979,2010);
% sst_full = getAnnualSSTAnomalies(6, 10, 1950, 2010);
% 
% load('ersstv3Anom.mat','sstLat', 'sstLon');
% latRange = [0, 40];
% lonRange = [280, 345];
% row_i = sstLat >= min(latRange) & sstLat <= max(latRange);
% col_i = sstLon >= min(lonRange) & sstLon <= max(lonRange);
% 
% sst_1948 = sst_1948(row_i,col_i,:);
% sst_1979 = sst_1979(row_i,col_i,:);
% sst_full = sst_full(row_i,col_i,:);
% 
% [maps_1948, pc_1948] = eof(sst_1948, 1);
% [maps_1979, pc_1979] = eof(sst_1979, 1);
% [maps_full, pc_full] = eof(sst_full, 1);
% 
% cc(13) = corr(pc_1948,storms_1948');
% cc(14) = corr(pc_1979,storms_1979');
% cc(15) = corr(pc_full,storms_full');
% 
% %get the SST dist index
% sst_dist_1948 = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1950, 1979),sstLat,sstLon);
% sst_dist_1979 = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1979, 2010),sstLat,sstLon);
% sst_dist_full = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1950, 2010),sstLat,sstLon);
% 
% cc(16) = corr(sst_dist_1948,storms_1948');
% cc(17) =  corr(sst_dist_1979,storms_1979');
% cc(18) =  corr(sst_dist_full,storms_full');
