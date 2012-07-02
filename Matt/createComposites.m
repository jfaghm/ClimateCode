function [] = createComposites(indexType, fileDest, pYears, nYears )
%This function is used to compute all of the composites for a certain index
%   

%%%%%%%%%Load the data necessary to create the composites
tic
load matFiles/PIMaps.mat;
sst = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
centralPressure = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var134')*.01;
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

fileDest = [fileDest '/'];

if strcmp(indexType, 'Hurr') == true || strcmp(indexType, 'AMO') == true || strcmp(indexType, 'SOI') == true
    pMinN = true;
else
    pMinN = false;
end
    
pMean = ['pMean' indexType];
nMean = ['nMean' indexType];
diff = ['diff' indexType];
latString = 'lat';
lonString = 'lon';
timeString = 'time';

matrixCell = 'cell';
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(pYears , nYears, PIData, time, matrixCell, pMinN, 8, 10);']);
matrixCell = 'matrix';
newFileDest = [fileDest 'PIComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(pYears, nYears, sst, time, matrixCell, pMinN, 8, 10);']);
newFileDest = [fileDest 'sstComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(pYears, nYears, centralPressure, time, matrixCell, pMinN, 8, 10);']);
newFileDest = [fileDest 'CentralPressureComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(pYears, nYears, relHumid, time, matrixCell, pMinN, 8, 10);']);
newFileDest = [fileDest 'relativeHumidityComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(pYears, nYears, windShear, time, matrixCell, pMinN, 8, 10);']);
newFileDest = [fileDest 'windShearComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);

end



