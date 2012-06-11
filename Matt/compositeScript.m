tic
[nYearsIndex, pYearsIndex] = getPosNegYearsIndex();
load /project/expeditions/jfagh/data/mat/monthly_nino_data.mat;
[nYearsENSO, pYearsENSO] = posNegNino3_4Years(data, 3, 10);
load condensedHurDat;
[nYearsHurr, pYearsHurr] = getPositiveAndNegativeYears(condensedHurDat);
%%%%%%%%%%%%%%%BUILD COMPOSITES FOR INDEX
load PIMaps.mat;
sst = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
relHumid = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var157');
relVort = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var138');
path = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
time = ncread(path, 'time');
lat = ncread(path, 'lat');
lon = ncread(path, 'lon');
levels = ncread(path, 'lev')*.01;
uWindSpeeds = ncread(path, 'var131');
vWindSpeeds = ncread(path, 'var132');
windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
windShear = windShear + sqrt((vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels == 850, :)).^2);
windShear = squeeze(windShear);

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, windShear, time, 'matrix', false, 8, 10);
save('composites/index/windShearComposite.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, sst, time, 'matrix', false, 8, 10);
save('composites/index/sstComposites.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, PIData, time, 'cell', false, 8, 10);
save('composites/index/PIComposites.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

composites = cell(size(relHumid, 3), 3);
for i = 1:size(relHumid, 3);
    [pMean, nMean, diff] = getComposites(pYearsIndex, nYearsIndex, squeeze(relHumid(:, :, i, :)), time, 'matrix', false, 8, 10);
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeHumidityCompositesIndex = composites;
save('composites/index/relativeHumidityComposites.mat', 'relativeHumidityCompositesIndex', 'levels', 'lat', 'lon', 'time');

composites = cell(size(relVort, 3), 3);
for i = 1:size(relVort, 3);
    [pMean, nMean, diff] = getComposites(pYearsIndex, nYearsIndex, squeeze(relVort(:, :, i, :)), time, 'matrix', false, 8, 10);
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeVorticityCompositesIndex = composites;
save('composites/index/relativeVorticityComposites.mat', 'relativeVorticityCompositesIndex', 'levels', 'lat', 'lon', 'time');

%%%%%%%%%%%%%%%%%BUILD COMPOSITES FOR ENSO
[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, windShear, time, 'matrix', false, 8, 10);
save('composites/ENSO_3.4/windShearComposite.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, sst, time, 'matrix', false, 8, 10);
save('composites/ENSO_3.4/sstComposites.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, PIData, time, 'cell', false, 8, 10);
save('composites/ENSO_3.4/PIComposites.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

composites = cell(size(relHumid, 3), 3);
for i = 1:size(relHumid, 3);
    [pMean, nMean, diff] = getComposites(pYearsENSO, nYearsENSO, squeeze(relHumid(:, :, i, :)), time, 'matrix', false, 8, 10);
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeHumidityCompositesENSO = composites;
save('composites/ENSO_3.4/relativeHumidityComposites.mat', 'relativeHumidityCompositesENSO', 'levels', 'lat', 'lon', 'time');

composites = cell(size(relVort, 3), 3);
for i = 1:size(relVort, 3);
    [pMean, nMean, diff] = getComposites(pYearsENSO, nYearsENSO, squeeze(relVort(:, :, i, :)), time, 'matrix', false, 8, 10);
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeVorticityCompositesENSO = composites;
save('composites/ENSO_3.4/relativeVorticityComposites.mat', 'relativeVorticityCompositesENSO', 'levels', 'lat', 'lon', 'time');

%%%%%%%%%%%%%%%%%%%%%%BUILD COMPOSITES FOR HURRICANE COUNTS
[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, windShear, time, 'matrix', true, 8, 10);
save('composites/hurricaneFrequency/windShearComposite.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, sst, time, 'matrix', true, 8, 10);
save('composites/hurricaneFrequency/sstComposites.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, PIData, time, 'cell', true, 8, 10);
save('composites/hurricaneFrequency/PIComposites.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

composites = cell(size(relHumid, 3), 3);
for i = 1:size(relHumid, 3);
    [pMean, nMean, diff] = getComposites(pYearsHurr, nYearsHurr, squeeze(relHumid(:, :, i, :)), time, 'matrix', true, 8, 10);
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeHumidityCompositesHurr = composites;
save('composites/hurricaneFrequency/relativeHumidityComposites.mat', 'relativeHumidityCompositesHurr', 'levels', 'lat', 'lon', 'time');

composites = cell(size(relVort, 3), 3);
for i = 1:size(relVort, 3);
    [pMean, nMean, diff] = getComposites(pYearsHurr, nYearsHurr, squeeze(relVort(:, :, i, :)), time, 'matrix', true, 8, 10);
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeVorticityCompositesHurr = composites;
save('composites/hurricaneFrequency/relativeVorticityComposites.mat', 'relativeVorticityCompositesHurr', 'levels', 'lat', 'lon', 'time');
toc

