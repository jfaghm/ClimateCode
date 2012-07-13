clear all
sst = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'sst');
sst = squeeze(sst);
sst = permute(sst, [2, 1, 3]);
sstLat = double(ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'lat'));
sstLon = double(ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'lon'));

%time:units = "days since 1854-01-15 00:00:00"
sstTimes = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'time');
addpath('../');
dates = zeros(length(sstTimes), 4);
for i = 1:length(sstTimes)
    dates(i, :) = hoursToDate(sstTimes(i)*24, 15, 1, 1854);
end

sst = sst(:, :, dates(:, 4) >= 1979);
sstDates = dates(dates(:, 4) >= 1979, :);

save('/project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat', 'sst', 'sstDates', 'sstLon', 'sstLat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%Pressure Anomalies%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
pressure = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var134');
pressure = permute(pressure, [2, 1, 3]);

%time:units = "hours since 1979-01-01 00:00:00"  
times = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');
pressureDates = zeros(length(times), 4);
for i = 1:length(times)
    pressureDates(i, :) = hoursToDate(times(i), 1, 1, 1979);
end

for i = 1:12
    current = pressure(:, :, pressureDates(:, 3) == i);
    pressure(:, :, pressureDates(:, 3) == i) = current - repmat(nanmean(current, 3), [1, 1, size(current, 3)]);
end
pressureLat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
pressureLon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
save('/project/expeditions/lem/ClimateCode/Matt/matFiles/pressureAnomalies.mat', 'pressure', 'pressureDates', 'pressureLon', 'pressureLat');

%%%%%%%%%%%%%%%%%%%%%%%%%OLR Anomalies%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
olr = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'olr');
olr = permute(olr, [2, 1, 3]);
%time:units = "hours since 1-1-1 00:00:0.0"
times = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'time');
dates = zeros(length(times), 4);
for i = 1:length(times)
    dates(i, :) = hoursToDate(times(i), 1, 1, 1);
end
olr = olr(:, :, dates(:, 4) >= 1979);
dates = dates(dates(:, 4) >= 1979, :);
lastYear = find(dates(:, 4) == 2010);
olr = olr(:, :, 1:lastYear(end));
dates = dates(1:lastYear(end), :);

olrRaw = olr;

for i = 1:12
    current = olr(:, :, dates(:, 3) == i);
    olr(:, :, dates(:, 3) == i) = current - repmat(nanmean(current, 3), [1, 1, size(current, 3)]);
end

olrLat = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'lat');
olrLon = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'lon');
olrDates = dates;
save('/project/expeditions/lem/ClimateCode/Matt/matFiles/olrAnomalies.mat', 'olr', 'olrLon', 'olrLat', 'olrDates');
save('/project/expeditions/lem/ClimateCode/Matt/matFiles/olrRaw.mat', 'olrRaw', 'olrLat', 'olrLon', 'olrDates');
%}




