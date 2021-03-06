clear
load('ersstv3_1854_2012_raw.mat')
load condensedHurDat

start_month =8;
end_month =10;
min_speed = -8;
start_year = 1979;
end_year = 2010;
min_lat = 0;
max_lat = 40;
max_lon = -12;
min_lon = -100;
max_east_lon = -45;
min_west_lon = -45;
all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);


[sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1948,2010);
latRange = [-6, 36];
lonRange = [120, 272];
row_i = sstLat >= min(latRange) & sstLat <= max(latRange);
col_i = sstLon >= min(lonRange) & sstLon <= max(lonRange);


for i=1:12
    parfor j=i:12
        sstA_year = getAnnualSSTAnomalies(i,j,1979,2010,sstA,sstA_dates);
        sstA_subset = sstA_year(row_i,col_i,:);
        [maps, pc(i,j,:)] = eof(sstA_subset, 1);
        cc2(i,j) = corr(squeeze(pc(i,j,:)),storms_1979');
    end
end
