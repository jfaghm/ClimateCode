
%relHumid = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var157');
relVort = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var138');
path = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
%time = ncread(path, 'time');
%levels = ncread(path, 'lev');
%levels = ncread(path, 'lev')*.01;
%{
time = ncread(path, 'time');
lat = ncread(path, 'lat');
lon = ncread(path, 'lon');
levels = ncread(path, 'lev')*.01;
uWindSpeeds = ncread(path, 'var131');
vWindSpeeds = ncread(path, 'var132');
windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
windShear = windShear + sqrt((vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels == 850, :)).^2);
windShear = squeeze(windShear);

[pMeanIndex, nMeanIndex, diffIndex] = getComposites(posYears, negYears, windShear, time, 'matrix');
save('composites/index/windShearComposite.mat', 'pMeanIndex', 'nMeanIndex', 'diffIndex', 'lat', 'lon');
%}

composites = cell(size(relVort, 3), 3);
for i = 1:size(relVort, 3);
    [pMean, nMean, diff] = getComposites(posYears, negYears, squeeze(relVort(:, :, i, :)), time, 'matrix');
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeVorticityCompositesIndex = composites;
save('composites/index/relativeVorticityComposites.mat', 'relativeVorticityCompositesIndex', 'levels', 'lat', 'lon');




