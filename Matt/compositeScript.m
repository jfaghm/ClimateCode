tic
[nYearsIndex, pYearsIndex] = getPosNegYearsIndex();
load /project/expeditions/jfagh/data/mat/monthly_nino_data.mat;
[nYearsENSO, pYearsENSO] = posNegNino3_4Years(data, 3, 10);
load matFiles/condensedHurDat;
[nYearsHurr, pYearsHurr] = getPositiveAndNegativeYears(condensedHurDat);
%%%%%%%%%%%%%%%BUILD COMPOSITES FOR INDEX
load matFiles/PIMaps.mat;
sst = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
centralPressure = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var134')*.01;
%relVort = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var138');
path = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
time = ncread(path, 'time');
lat = ncread(path, 'lat');
lon = ncread(path, 'lon');
levels = ncread(path, 'lev')*.01;
relHumid = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var157');
relHumid = permute(relHumid, [2 1 4 3]);
relHumid = sum(relHumid(:, :, :, levels >= 500 & levels <= 850), 4) ./ numelements(find(levels >= 500 & levels <= 850));
uWindSpeeds = ncread(path, 'var131');
vWindSpeeds = ncread(path, 'var132');
windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
windShear = windShear + sqrt((vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels == 850, :)).^2);
windShear = squeeze(windShear);
toc
tic
[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, windShear, time, 'matrix', false, 8, 10);
save('composites/index/windShearComposite.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, sst, time, 'matrix', false, 8, 10);
save('composites/index/sstComposites.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, PIData, time, 'cell', false, 8, 10);
save('composites/index/PIComposites.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, relHumid, time, 'matrix', false, 8, 10);
save('composites/index/relativeHumidityComposites.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(pYearsIndex, nYearsIndex, centralPressure, time, 'matrix', false, 8, 10);
save('composites/index/centralPresComposites.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, windShear, time, 'matrix', false, 8, 10);
save('composites/ENSO_3.4/windShearComposite.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, sst, time, 'matrix', false, 8, 10);
save('composites/ENSO_3.4/sstComposites.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, PIData, time, 'cell', false, 8, 10);
save('composites/ENSO_3.4/PIComposites.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, relHumid, time, 'matrix', false, 8, 10);
save('composites/ENSO_3.4/relativeHumidityComposites.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

[pMeanENSO, nMeanENSO, diffENSO] = getComposites(pYearsENSO, nYearsENSO, centralPressure, time, 'matrix', false, 8, 10);
save('composites/ENSO_3.4/centralPresCompsites.mat', 'pMeanENSO', 'nMeanENSO', 'diffENSO', 'lat', 'lon', 'time');

%%%%%%%%%%%%%%%%%%%%%%BUILD COMPOSITES FOR HURRICANE COUNTS
[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, windShear, time, 'matrix', true, 8, 10);
save('composites/hurricaneFrequency/windShearComposite.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, sst, time, 'matrix', true, 8, 10);
save('composites/hurricaneFrequency/sstComposites.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, PIData, time, 'cell', true, 8, 10);
save('composites/hurricaneFrequency/PIComposites.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, relHumid, time, 'matrix', true, 8, 10);
save('composites/hurricaneFrequency/relativeHumidityComposites.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

[pMeanHurr, nMeanHurr, diffHurr] = getComposites(pYearsHurr, nYearsHurr, centralPressure, time, 'matrix', true, 8, 10);
save('composites/hurricaneFrequency/centralPresComposites.mat', 'pMeanHurr', 'nMeanHurr', 'diffHurr', 'lat', 'lon', 'time');

toc



