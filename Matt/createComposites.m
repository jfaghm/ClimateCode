function [] = createComposites(indexType, fileDest, pYears, nYears )
%This function is used to compute all of the composites for a certain index
%
%------------------------Input--------------------------------------------
%
%--->indexType - the name of the index for which we are creating composites
%for, this should be a string.
%--->fileDest - a path to the directory where the mat files should be
%saved.  This should also be a string
%--->pYears - a vector containing the positive years.  Positive years
%should correspond to years of high hurricane activity, not neccessarily
%years where the index value is high (in the event that an index negatively
%correlates with hurricane activity)
%--->nYears - a vector containing the negative yeras (save convention used
%for positive yeras)
%
%---------------------Output----------------------------------------------
%
%--->nothing, all matFiles are simply saved in the destination that is
%supplied as one of the input parameters.
%
%--------------Example-------------------------------------------
%
%   createComposites('SSTIndex', 'composites/sstIndex', pYears, nYears);

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



