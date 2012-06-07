sst = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'sst');
sst = squeeze(sst);
sst = permute(sst, [2 1 3]);
sst = sst(:, :, (31*12)+1:end); %get 1979 - present
lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
lati = find(lat >= 5 & lat <= 20);
loni = find(lon >= -70 & lon <= -15);
load PIMaps.mat;

%box north goes from 10 to 60
%box col goes from 5 to 30

box_south = -6;
box_west = 140;
box_east = 270;
%box size
box_row =5;
i = 1;
j = 1;
indexMeans = zeros(21, 26);
for box_north = 20:2:60
   j = 1;
   for box_col = 5:30
       [negYears, posYears, ~] = getPosNegYearsIndex(sst, box_north, box_south, box_east, box_west, box_row, box_col);
       [~, ~, diffIndex] = getComposites(posYears, negYears, PIData, time, 'cell', false, 8, 10);
       subset = diffIndex(lati, loni);
       indexMeans(i, j) = mean(mean(subset));
      j = j+1;
   end
   i = i+1;
   box_north
end





