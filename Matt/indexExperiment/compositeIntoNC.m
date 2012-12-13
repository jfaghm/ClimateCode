%--------------------------Description-----------------------------------
%Currently, this function takes in a time series and creates a potential
%intensity composite with p-values.  It then takes this composite and saves
%it as an NC file.  From here, you can run the conOncon_4.ncl script to
%make an NCL plot with 95% confidence intervals.
%
%-------------------------Input--------------------------------------------
%-->index - the time series to be composited
%-->theshold - the standard deviation threshold that is to be used for
%computing the positive and negative years (typically 1)
%-->positivelyCorrelated - boolean value that lets the function know
%whether or not the index time series is positively or negatively
%correlated with atlantic hurricane activity
%-->baseYear - baseYear of the index time series
%-->vars - the composite variables struct.  This can be found in
%/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat
%-->indexName - the name of the index time series
%
%------------------------Output-------------------------------------------
%-->none, this function is only used to save a netCDF file.
%
%-------------------------Example------------------------------------------
%  vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
%  [anomalies, anomalyDates] = getMonthlyAnomalies(sst, sstDates, 1948, 2010);
%  annualSST = getAnnualSSTAnomalies(6, 10, 1979, 2010, anomalies, anomalyDates);
%  index = buildSSTLonDiff(annualSST, sstLat, sstLon);
%  compositeIntoNC(index, 1, false, 1979, vars, 'sstMaxLon');

function [] = compositeIntoNC(index, threshold, positivelyCorrelated,...
    baseYear, vars, indexName, var, varName)

confidInterval = .95;

[nYears, pYears] = getPosNegYearsFromVector(index, threshold, positivelyCorrelated, baseYear);

[~,~,composite] = getComposites(var, pYears, nYears, vars.dates, 8, 10);

[~,mask, pvalues] = getSignificantComposite(index, var, threshold, composite, ...
    confidInterval, positivelyCorrelated);

lat = vars.lat;
lon = vars.lon;

saveFile();

function [] = saveFile()
savename = ['ncComposites/' indexName num2str(confidInterval) 'Confidence.nc'];
nccreate(savename, 'lon', 'Dimensions', {'lon', length(lon)})
nccreate(savename, 'lat', 'Dimensions', {'lat', length(lat)})
%nccreate(savename, 'time', 'Dimensions', {'time' 1});
ncwrite(savename, 'lon', lon);
ncwrite(savename, 'lat', lat);

landMask = isnan(vars.sst(:, :, 1));

%composite(landMask) = -9999;
%pvalues(landMask) = -9999;
nccreate(savename, 'index', 'Dimensions', {'lon', length(lon), 'lat', length(lat)});
ncwrite(savename, 'index', composite')
nccreate(savename, 'mask', 'Dimensions', {'lon', length(lon), 'lat', length(lat)});
ncwrite(savename, 'mask', mask')
nccreate(savename, 'pvals', 'Dimensions', { 'lon', length(lon), 'lat', length(lat)});
ncwrite(savename, 'pvals', pvalues');


end
end