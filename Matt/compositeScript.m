
%relHumid = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var157');
%relVort = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var138') * 10^5;
path = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
%time = ncread(path, 'time');
%levels = ncread(path, 'lev');
%levels = ncread(path, 'lev')*.01;

time = ncread(path, 'time');
levels = ncread(path, 'lev')*.01;
uWindSpeeds = ncread(path, 'var131');
vWindSpeeds = ncread(path, 'var132');
windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
windShear = windShear + sqrt((vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels == 850, :)).^2);
windShear = squeeze(windShear);

[pMean, nMean, diff] = getComposites(posYears, negYears, windShear, time, 'matrix');
save('composites/ENSO_3.4/windShearComposite.mat', 'pMean', 'nMean', 'diff');

%{
composites = cell(size(relHumid, 3), 3);
for i = 1:size(relHumid, 3);
    [pMean, nMean, diff] = getComposites(posYears, negYears, squeeze(relHumid(:, :, i, :)), time, 'matrix');
    composites{i, 1} = pMean;
    composites{i, 2} = nMean;
    composites{i, 3} = diff;
end

relativeHumidityComposites = composites;
save('composites/ENSO_3.4/relativeHumidityComposites.mat', 'relativeHumidityComposites');
%}



