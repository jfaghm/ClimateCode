%load the path to functions I need
clear
fcnPath = '/project/expeditions/haasken/matlab/OptimizeCorr';
addpath(fcnPath)
%load('/project/expeditions/haasken/data/HadISST1/hadleySSTLatLon.mat');
%load Reynolds sst data
load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat')
load('/project/expeditions/haasken/matlab/OptimizeCorr/ExperimentArchive/Trends/trendBoxLimits.mat')
%start_year = 1989;
%end_year = 2010;
months = 1:12;
%[ seasonDates, daysPerMonth ] = getSeasonalDates(dataLims.startYear, dataLims.endYear, dataLims.months);
%[ seasonDates, daysPerMonth ] = getSeasonalDates(start_year, end_year, months);
dates_index = ismember(hadleyDates,seasonDates);
seasonal_sst = hadleySST(:,:,dates_index);
north_east_lat = 30.5;
north_east_lon =179.5;
gridInfo = hGridInfo;

if ismember(north_east_lat, gridInfo.lats)
   [~, northRow] = ismember(north_east_lat, gridInfo.lats);
   [~, southRow] = ismember(-north_east_lat, gridInfo.lats);
else
    error('Bad lat input!');
end
if ismember(north_east_lon, gridInfo.lons)
   [~, eastCol] = ismember(north_east_lon, gridInfo.lons);
   [~, westCol] = ismember(-north_east_lon, gridInfo.lons);
else
    error('Bad lat input!');
end
sst_subset = seasonal_sst(northRow:southRow,westCol:eastCol,:);
tropical_mean = nanmean(nanmean(nanmean(sst_subset)));
sst_anomalies = sst - tropical_mean;
years = 1982:2010
for i =1:29
  [seasonDates, daysPerMonth ] = getSeasonalDates(years(i), years(i), dataLims.months);
  seasonal_mean_sst{j} = mean(sst_anomalies(:,:,i:i),3);
end
% [~, rows] = pdist2(reshape(gridInfo.lats, [], 1), [dataLims.north; dataLims.south], 'euclidean', 'Smallest', 1);
% northRow = rows(1);
% southRow = rows(2);
% 
% [~, cols] = pdist2(reshape(gridInfo.lons, [], 1), [dataLims.west; dataLims.east], 'euclidean', 'Smallest', 1);
% westCol = cols(1);
% eastCol = cols(2);

