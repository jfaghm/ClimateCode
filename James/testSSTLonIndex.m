% %test SSTlon index
load('ersstv3_1854_2012_raw.mat')
[sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1948,2010);
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
storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
% 

% for i=1:6
%     for j=10:10
%         sstA_year = getAnnualSSTAnomalies(6,10,1979,2010,sstA,sstA_dates);
%         [index, maxI, maxJ, minI, minJ] = buildSSTLon(sstA_year, sstLat, sstLon);
%         cc(i,j) = corr(storms',index);
%     end
% end


for i=1:12
        sstA_year = getAnnualSSTAnomalies(6,10,1979,2010,sstA,sstA_dates);
        [index{i}, maxI, maxJ, minI, minJ] = buildSSTLon(sstA_year, sstLat, sstLon);
        %cc(i,j) = corr(storms',index);
end

% for i=1:12
%     parfor j=i:12
%         ind = getNINO(1979,2010,i,j,4);
%         cc4(i,j) = corr(storms',ind');
%     end
% end
