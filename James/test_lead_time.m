% %test lead time forecast of indices
% clear
% load condensedHurDat
% start_month =8;
% end_month =10;
% min_speed = -8;
% start_year = 1979;
% end_year = 2010;
% min_lat = 0;
% max_lat = 40;
% max_lon = -12;
% min_lon = -100;
% max_east_lon = -45;
% min_west_lon = -45;
% all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
% storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
% east_storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_east_lon]);
% west_storms_1979 = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_west_lon max_lon]);
% load('ersstv3Anom.mat','sstLat','sstLon');
% for i=1:7
%     for j = i:7
%         ind(i,j,:) = buildSSTLonDiff(getAnnualSSTAnomalies(i, j, 1979, 2010),sstLat,sstLon);
%         cc1(i,j) = corr(squeeze(ind(i,j,:)),storms_1979');
%     end 
% end
% for i =1:7
%    mean_cc(i) = mean(cc1(i,i:end));
%    std_cc(i) = std(cc1(i,i:end));
% end

% test the EOF lead times
latRange = [0, 40];
lonRange = [280, 345];
row_i = sstLat >= min(latRange) & sstLat <= max(latRange);
col_i = sstLon >= min(lonRange) & sstLon <= max(lonRange);

for i=1:7
    for j=i:7
        sst_1979 = getAnnualSSTAnomalies(i, j, 1979, 2010); 
        sst = sst_1979(row_i,col_i,:);
        [maps, pc(i,j,:)] = eof(sst, 1);
        cc2(i,j) = corr(squeeze(pc(i,j,:)),storms_1979');
    end
end
for i =1:7
   mean_cc2(i) = mean(cc2(i,i:end));
   std_cc2(i) = std(cc2(i,i:end));
end


%test the NINO lead times
for i =1:7
    for j=i:7
        nino34_1979 = getNINO(1979,2010,i,j,4);
        cc3(i,j) = corr(nino34_1979',storms_1979');
    end
end
for i =1:7
   mean_cc3(i) = mean(cc3(i,i:end));
   std_cc3(i) = std(cc3(i,i:end));
end

