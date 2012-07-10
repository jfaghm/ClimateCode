lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
lati = find(lat >= 5 & lat <= 20);
loni = find(lon >= -70 & lon <= -15);

sst = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
time = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');

%box north goes from 10 to 60
%box col goes from 5 to 30

box_south = -6;
box_west = 140;
box_east = 270;
%box size
box_row =5;
i = 1;
j = 1;
indexMeans = zeros(16, 16);
for box_row = 2:2:30
   j = 1;
   for box_col = 2:2:30
       [negYears, posYears] = getPosNegYearsIndex(box_row, box_col);
       [~, ~, diffIndex] = getComposites(posYears, negYears, sst, time, 'matrix', false, 8, 10);
       subset = diffIndex(lati, loni);
       indexMeans(i, j) = nanmean(subset(:));
      j = j+1;
   end
   i = i+1;
   box_row
end


