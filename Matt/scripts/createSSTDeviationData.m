 addpath('/project/expeditions/lem/ClimateCode/Matt/');


dir = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc';
sst = ncread(dir, 'sst');
sst = permute(sst, [2, 1, 4, 3]);
sstLat = ncread(dir, 'lat');
sstLon = ncread(dir, 'lon');
time = ncread(dir, 'time');

sstDates = zeros(length(time), 4);
for i = 1:length(time)
    sstDates(i, :) = hoursToDate(time(i) * 24, 15, 1, 1854);
end

%------------Only save 1979-2010 data------------------------
sst = sst(:, :, sstDates(:, 4) >= 1979);
sstDates = sstDates(sstDates(:, 4) >= 1979, :);
%------------------------------------------------------------

tropicalSST = sst(sstLat > -30 & sstLat < 30, :, :);
tropicalSST = nanmean(nanmean(tropicalSST, 1), 2);
tropicalSST = repmat(tropicalSST, [size(sst, 1), size(sst, 2), 1]);

sstDeviations = sst - tropicalSST;
for i = 1:size(sstDeviations, 3)
    temp(:, :, i) = flipud(sstDeviations(:, :, i));
end
sstLat = sort(sstLat, 'descend');

sstDeviations = temp;
save('/project/expeditions/lem/ClimateCode/Matt/matFiles/tropicalSSTDeviations.mat', ...
    'sstDeviations', 'sstLat', 'sstLon', 'sstDates');