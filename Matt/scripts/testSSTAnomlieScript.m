sst = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'sst');
sst = permute(squeeze(sst), [2, 1, 3]);
sstTime = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'time');
sstLat = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'lat');
sstLon = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'lon');
sstLat = sort(sstLat, 'descend');

ersst = permute(squeeze(ncread('/project/expeditions/lem/data/ersstv3.nc', 'sst')), [2, 1, 3]);
ersstLat = ncread('/project/expeditions/lem/data/ersstv3.nc', 'lat');
ersstLon = ncread('/project/expeditions/lem/data/ersstv3.nc', 'lon');
time = ncread('/project/expeditions/lem/data/ersstv3.nc', 'time');
addpath('/project/expeditions/lem/ClimateCode/Matt/');
ersstDates = zeros(length(time), 4);
sstDates = zeros(length(sstTime), 4);

for i = 1:length(time)
    ersstDates(i, :) = hoursToDate(time(i)*24, 15, 1, 1854);
    
end

for i = 1:length(sstTime)
    sstDates(i, :) = hoursToDate(sstTime(i)*24, 15, 1, 1854);
end

ersst = ersst(:, :, ersstDates(:, 4) >= 1948);
ersstDates = ersstDates(ersstDates(:, 4) >= 1948, :);
lastYear = find(ersstDates(:, 4) == 2010);
ersst = ersst(:, :, 1:lastYear(end));
ersstDates = ersstDates(1:lastYear(end), :);
%}
ersstAnom = zeros(size(ersst));

for i = 1:12
    current = ersst(:, :, ersstDates(:, 3) == i);
    meanCurrent = repmat(nanmean(current, 3), [1, 1, size(current, 3)]);
    stdCurrent = repmat(nanstd(current, 0, 3), [1, 1, size(current, 3)]);
    ersstAnom(:, :, ersstDates(:, 3) == i) = (current - meanCurrent) ./ stdCurrent;
    %ersstAnom(:, :, ersstDates(:, 3) == i) = current ./ stdCurrent;
    %ersstAnom(:, :, ersstDates(:, 3) == i) = (current - meanCurrent);
end
%}

%ersstAnom = (ersst - repmat(nanmean(ersst, 3), [1, 1, size(ersst, 3)])) ./ ...
%    repmat(nanstd(ersst, 0, 3), [1, 1, size(ersst, 3)]);

%ersstAnom = ersst ./ repmat(std(ersst, 0, 3), [1, 1, size(ersst, 3)]);

%{
ersstAnom = ersstAnom(:, :, ersstDates(:, 4) >= 1948);
ersstDates = ersstDates(ersstDates(:, 4) >= 1948, :);
lastYear = find(ersstDates(:, 4) == 2010);
ersstAnom = ersstAnom(:, :, 1:lastYear(end));
ersstDates = ersstDates(1:lastYear(end), :);
%}
    
subset1 = ersstAnom(:, :, 1);
subset2 = sst(:, :, 1);
diff = nansum(ersstAnom(:) - sst(:));
if abs(diff) >= .1
    diff / (numelements(ersstAnom(:, :, 1)) * size(ersstAnom, 3))
    warning('Anomalies were not computed correctly')
else
    save('/project/expeditions/lem/ClimateCode/Matt/matFiles/ersstv3.mat', ...
        'ersst', 'ersstLat', 'ersstLon', 'ersstDates');
end
diff / (numelements(ersstAnom(:, :, 1)) * size(ersstAnom, 3))

plotMaps = false;
if plotMaps == true

for i = 1:384
    figure(1)
    imagesc(sst(:, :, i));
    caxis([-6 6]);
    colorbar
    figure(2)
    imagesc(ersstAnom(:, :, i));
    caxis([-6 6]);
    colorbar
    pause
end
end