
lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
lati = find(lat >= 5 & lat <= 20);
loni = find(lon >= -70 & lon <= -15);
load PIMaps.mat;
sst = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
load /project/expeditions/jfagh/data/mat/monthly_nino_data.mat;
load condensedHurDat;
[nYearsIndex, pYearsIndex] = getPosNegYearsIndex();
[nYearsENSO, pYearsENSO] = posNegNino3_4Years(data, 3, 10);
[nYearsHurr, pYearsHurr] = getPositiveAndNegativeYears(condensedHurDat);
diffENSO = cell(10, 10);
diffIndex = cell(10, 10);
diffHurr = cell(10, 10);
ENSOMean = zeros(10, 10);
indexMean = zeros(10, 10);
hurrMean = zeros(10, 10);
for i = 1:10
    for j = i:10
        [~, ~, diffENSO{i, j}] = getComposites(pYearsENSO, nYearsENSO, sst, time, 'matrix', false, i, j);
        subset = diffENSO{i, j}(lati, loni);
        ENSOMean(i, j) = nanmean(mean(subset));
        [~, ~, diffIndex{i, j}] = getComposites(pYearsIndex, nYearsIndex, sst, time, 'matrix', false, i, j);
        subset = diffIndex{i, j}(lati, loni);
        indexMean(i, j) = nanmean(mean(subset));
        [~, ~, diffHurr{i, j}] = getComposites(pYearsHurr, nYearsHurr, sst, time, 'matrix', true, i, j);
        subset = diffHurr{i, j}(lati, loni);
        hurrMean(i, j) = nanmean(mean(subset));
    end
    i
end






