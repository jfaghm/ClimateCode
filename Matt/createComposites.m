function [] = createComposites(indexType, fileDest, pYears, nYears )
%This function is used to compute all of the composites for a certain index
%   

%%%%%%%%%Load the data necessary to create the composites

load matFiles/compositeVariables.mat

fileDest = [fileDest '/'];

pMean = ['pMean' indexType];
nMean = ['nMean' indexType];
diff = ['diff' indexType];
latString = 'lat';
lonString = 'lon';
timeString = 'dates';

eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(PI, pYears , nYears, dates, 8, 10);']);
newFileDest = [fileDest 'PIComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(sst, pYears, nYears, dates, 8, 10);']);
newFileDest = [fileDest 'sstComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(centralPressure, pYears, nYears, dates, 8, 10);']);
newFileDest = [fileDest 'CentralPressureComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(relHumid, pYears, nYears, dates, 8, 10);']);
newFileDest = [fileDest 'relativeHumidityComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);
eval(['[pMean' indexType ', nMean' indexType ', diff' indexType '] = getComposites(windShear, pYears, nYears, dates, 8, 10);']);
newFileDest = [fileDest 'windShearComposite'];
eval(['save(newFileDest, pMean, nMean, diff, latString, lonString, timeString);']);

end



