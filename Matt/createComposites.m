function [] = createComposites(indexType, fileDest, pYears, nYears )
%This function is used to compute all of the composites for a certain index
%   

%%%%%%%%%Load the data necessary to create the composites
tic
load matFiles/PIMaps.mat;
load matFiles/compositeVariables.mat
toc

fileDest = [fileDest '/'];

if strcmp(indexType, 'Hurr') == true || strcmp(indexType, 'AMO') == true...
    || strcmp(indexType, 'SOI') == true || strcmp(indexType, 'QBO') == true...
    || strcmp(indexType, 'PNA') == true
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



