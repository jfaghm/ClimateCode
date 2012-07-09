function [ Means, bestYears ] = bestSubset(posYears, negYears, numPos, numNeg)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
lati = find(lat >= 5 & lat <= 20);
loni = find(lon >= -70 & lon <= -15);

nYearCombos = nchoosek(negYears, numNeg);
pYearCombos = nchoosek(posYears, numPos);

sstData = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
time = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');

DiffComposites = cell(size(nYearCombos, 1), size(pYearCombos, 1));
Means = zeros(size(nYearCombos, 1), size(pYearCombos, 1));
for i = 1:size(nYearCombos, 1)
    for j = 1:size(pYearCombos, 1)
        [~,~, DiffComposites{i, j}] = getComposites(pYearCombos(j, :)', nYearCombos(i, :)', sstData, time, 'matrix', false, 8, 10);
        subset = DiffComposites{i, j}(lati, loni);
        Means(i, j) = nanmean(subset(:));
    end
    i
end
[~, ind] = max(Means(:));
[i, j] = ind2sub(size(Means), ind);

bestYears = struct('negative', nYearCombos(i, :), 'positive', pYearCombos(j, :));





end

