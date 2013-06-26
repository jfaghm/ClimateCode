% %test SSTlon index
%  load('ersstv3_1854_2012_raw.mat')
%  [sstA sstA_dates] = getMonthlyAnomalies(sst,sstDates,1948,2010);
%  
%  load('fss_data_lat_-40_15_lon_-85_-30 (1).mat');
% fss = reshape(fss_aggregate_vectors,11*11,[]);
% %load condensedHurDat

% start_month =6;
% end_month =11;
% min_speed = 3;
% start_year = 1999;
% end_year = 2008;
% min_lat = 0;
% max_lat = 40;
% max_lon = -12;
% min_lon = -100;
% max_east_lon = -45;
% min_west_lon = -45;
% all_storms = condensedHurDat(condensedHurDat(:,10)>min_speed, [ 1 2 6 7 ]); %filter the data by strom strength
% storms = countStorms(all_storms, start_year, end_year, [start_month:end_month],[min_lat max_lat], [min_lon max_lon]);
% % 

%% evaluate NINO3.4 and fires
count =1;
for i=1:10
    for j=i+2:i+2
        nino{count} = getNINO(1999,2008,i,j,2);
        count = count+1;
    end
end

for l =1:121
    current_location = fss(l,:); 
    for i=1:10
         nino_cc(l,i) = corr(current_location',nino{i}');
    end
    
end

for i = 1:121
    current = nino_cc(i,:);
    [vv(i),x(i)] = max(abs(current(:)));
end

nino_max = reshape(vv,11,11);
nino_max(isnan(nino_max))=0;
imagesc(nino_max)
caxis([0,1]);
% 
nino_months = reshape(x,11,11);
imagesc(nino_months)

%% Evaluate S-ENSO and Fires
count =1;
for i=1:10
    for j=i+2:i+2
        sstA_year = getAnnualSSTAnomalies(i,j,1999,2008,sstA,sstA_dates);
        [index, maxI, maxJ, minI, minJ] = buildSSTLon(sstA_year, sstLat, sstLon);
        ii{count} = index;
        count = count+1;
    end
end
% 
for l =1:121
    current_location = fss(l,:); 
    for i=1:10
         cc(l,i) = corr(current_location',ii{i});
    end
    
end
% 
for i = 1:121
    current = cc(i,:);
    [v(i),ind(i)] = max(abs(current(:)));
    %temp(i) = current();
    %mm(i) = max(max(abs(space_scores{i}))); 
end

m = reshape(v,11,11);
m(isnan(m))=0;
imagesc(m)
caxis([0,1]);

diff = m - nino_max;
imagesc(diff)
caxis([-1,1]);
% 
months = reshape(ind,11,11);
imagesc(months)
