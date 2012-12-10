%% --------------------------Load the data---------------------------------
clear
ersst = permute(squeeze(ncread('/project/expeditions/lem/data/sst.mnmean.nc', 'sst')), [2, 1, 3]);
sstLat = ncread('/project/expeditions/lem/data/ersstv3_1948_2012.nc', 'lat');
sstLon = ncread('/project/expeditions/lem/data/ersstv3_1948_2012.nc', 'lon');
%time = ncread('/project/expeditions/lem/data/sst.mnmean.nc', 'time');
addpath('/project/expeditions/lem/ClimateCode/Matt/');

%Flip the data
ersst = flipdim(ersst, 1);
sstLat = sort(sstLat, 'descend');

dates = zeros(size(ersst, 3), 2);
months = repmat((1:12)', (size(ersst, 3)+1)/12

%{
for i = 1:length(time)
    sstDates(i, :) = hoursToDate(time(i)*24, 15, 1, 1854);
end



ersst = ersst(:, :, sstDates(:, 4) >= 1948);
sstDates = sstDates(sstDates(:, 4) >= 1948, :);

%Put December 2011 in place of December 2012 because it is missing
ersst = cat(3, ersst, ersst(:, :, sstDates(:, 3) == 12 & sstDates(:, 4) == 2011));
sstDates = [sstDates; [0, 14, 12, 2012]];
%}
%% -------------------Compute 1948-2012 Anomalies-------------------------

for i = 1:12
    current = ersst(:, :, i:12:end);
    means(:, :, i) = nanmean(current, 3);
    stds(:, :, i) = std(current, 1, 3);
end
ersstAnom = (ersst - repmat(means, [1, 1, 63])) ./ repmat(stds, [1, 1, 63]);
sst = ersstAnom;
    

%{

ersstAnom = zeros(size(ersst));
for i = 1:12
    current = ersst(:, :, sstDates(:, 3) == i);
    meanCurrent = repmat(nanmean(current, 3), [1, 1, size(current, 3)]);
    stdCurrent = repmat(std(current, 0, 3), [1, 1, size(current, 3)]);
    ersstAnom(:, :, sstDates(:, 3) == i) = (current - meanCurrent) ./ stdCurrent;
end

sst = ersstAnom;
%{
sst = reshape(sst, [], size(sst, 3))';
sst = detrend(sst);
sst = reshape(sst', size(ersstAnom, 1), size(ersstAnom, 2), size(ersstAnom, 3));
%}

sst = sst(:, :, sstDates(:, 4) >= 1979);
sstDates = sstDates(sstDates(:, 4) >= 1979, :);
lastYear = find(sstDates(:, 4) == 2010);
sstAnomaly = sst(:, :, 1:lastYear(end));
%}

save('/project/expeditions/ClimateCodeMatFiles/ersstv3Anomalies_1948_2012.mat', ...
    'sst', 'sstLat', 'sstLon');

%% ------------------Compute 1979-2010 Anomalies---------------------------

ersst = ersst(:, :, sstDates(:, 4) >= 1979);
sstDates = sstDates(sstDates(:, 4) >= 1979, :);
lastYear = find(sstDates(:, 4) == 2010);
ersst = ersst(:, :, 1:lastYear(end));
sstDates = sstDates(1:lastYear(end), :);

ersstAnom = zeros(size(ersst));
for i = 1:12
    current = ersst(:, :, sstDates(:, 3) == i);
    meanCurrent = repmat(nanmean(current, 3), [1, 1, size(current, 3)]);
    stdCurrent = repmat(std(current, 0, 3), [1, 1, size(current, 3)]);
    ersstAnom(:, :, sstDates(:, 3) == i) = (current - meanCurrent) ./ stdCurrent;
end
sst = ersstAnom;

sst = reshape(sst, [], size(sst, 3))';
sst = detrend(sst);
sst = reshape(sst', size(ersstAnom, 1), size(ersstAnom, 2), size(ersstAnom, 3));


save('/project/expeditions/ClimateCodeMatFiles/ersstv3Anomalies_1979_2010.mat', ...
    'sst', 'sstLat', 'sstLon', 'sstDates');