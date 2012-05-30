
load('/project/expeditions/haasken/ERSST/ersstv2.mat')
load('/project/expeditions/haasken/ERSST/ersstv3.mat')
load('/project/expeditions/haasken/reynolds_monthly/reynoldsSST.mat')
load('/project/expeditions/haasken/HadISST1/hadleySST.mat')

sstData{1} = reynoldsSST;
sstData{2} = hadleySST;
sstData{3} = erv2sst;
sstData{4} = erv3sst;

dataDates{1} = reynoldsDates;
dataDates{2} = hadleyDates;
dataDates{3} = erv2Dates;
dataDates{4} = erv3Dates;

grids = struct('westLimit', { 0.5, -179.5, 0, 0 }, 'northLimit', { 89.5, 89.5, 88, 88 }, ...
    'latStep', { 1, 1, 2, 2 }, 'lonStep', { 1, 1, 2, 2 }, ...
    'units', {'Kelvin', 'Kelvin', 'Celsius', 'Celsius'} );

datasetNames = {'Reynolds SST', 'Hadley SST', 'ERSSTV2', 'ERSSTV3'};

numDataSets = length(datasetNames);

latlims(:, :, 1) = [ 5 20 ];  % west North Pacific
latlims(:, :, 2) = [ 5 20 ];  % east North Pacific
latlims(:, :, 3) = [ -5 -20 ];  % Southwest Pacific
latlims(:, :, 4) = [ 5 20 ];  % North Indian Ocean
latlims(:, :, 5) = [ -5 -20 ];  % South Indian Ocean
latlims(:, :, 6) = [ 5 25 ];  % North Atlantic Ocean

lonlims(:, :, 1) = [ 120 180 ];  % west North Pacific
lonlims(:, :, 2) = [ -120 -90 ];  % east NorthPacific
lonlims(:, :, 3) = [ 155 180 ];  % Southwest Pacific
lonlims(:, :, 4) = [ 55 90 ];  % North Indian Ocean
lonlims(:, :, 5) = [ 50 115 ];  % South Indian Ocean
lonlims(:, :, 6) = [ -90 -20 ];  % North Atlantic Ocean

months = cell(1, 5);
months{1} = 5:12;  % west North Pacific
months{2} = 6:10;  % east North Pacific
months{3} = [ 12 1:4 ];  % Southwest Pacific
months{4} = [ 4:5 9:11 ];  % North Indian Ocean
months{5} = [ 11:12 1:4 ];  % South Indian Ocean
months{6} = 6:10;  % North Atlantic Ocean

basinIDs = { 'WPAC', 'EPAC', 'SPAC', 'NIO', 'SIO', 'NATL' };

colors = { 'green', [.5 0 1], 'cyan', 'red', 'black', [1 .55 0] };
numBasins = length(basinIDs);

startYear = 1970;
endYear = 2010;
numYears = endYear - startYear + 1;

counts = zeros(numBasins, numYears);

sstAverages = zeros(numBasins, numYears, numDataSets);

for d = 1:numDataSets

    sstMatrix = sstData{d};
    dates = dataDates{d};
    gridInfo = grids(d);
    
    for basin = 1:numBasins
        
        averages = getMeanSST(sstMatrix, dates, gridInfo, latlims(:, :, basin), lonlims(:, :, basin), ...
            startYear, endYear, months{basin}, true);
        
        %averages = getSimpleMeanSST(sstMatrix, dates, gridInfo, latlims(:, :, basin), lonlims(:, :, basin), ...
         %   startYear, endYear, months{basin});
        
        sstAverages(basin, :, d) = averages;
        
    end
    
    % Create a plot of each basin's sst averages
    f = figure; hold on;
    
    validMask = ~any( isnan(sstAverages(:, :, d)) | sstAverages(:, :, d) == 0, 1 );
    validYears = startYear:endYear;
    validYears = validYears(validMask);
    
    handlevector = zeros(numBasins*2);
    
    for basin = 1:numBasins
        
        if strcmpi(gridInfo.units, 'Kelvin')
            basinAvgs = kelvin2Celsius(sstAverages(basin, validMask, d));
        else
            basinAvgs = sstAverages(basin, validMask, d);
        end
        
        handlevector( basin*2 - 1 ) = plot(validYears, basinAvgs, ...
            'Color', colors{basin});
        handlevector( basin*2 ) = plot(validYears, tsmovavg(basinAvgs, 's', 5), ... 
            'Color', colors{basin}, 'LineWidth', 6);
    
    end

    title( [ datasetNames{d} ' Averages from 1950-2010' ] )
    xlabel('Year')
    ylabel(['Sea Surface Temperature (' char(176) 'C)'])
    legend(basinIDs(floor(1:.5:(numBasins+.5))))
    legend(handlevector(2:2:(numBasins*2)), 'location', 'NorthEastOutside')
   
    saveas(f, [ 'sstPlots/' datasetNames{d}(~isspace(datasetNames{d})) '.png' ])
    
end
        
% % Create a plot of each basin's stormCounts
% figure; hold on;
% handlevector(1) = plot(1950:2010, wpacCounts, 'Color', 'green');
% handlevector(2) = plot(1950:2010, tsmovavg(wpacCounts, 's', 5), 'Color', 'green', 'LineWidth', 6);
% handlevector(3) = plot(1950:2010, epacCounts, 'Color', 'blue');
% handlevector(4) = plot(1950:2010, tsmovavg(epacCounts, 's', 5), 'Color', 'blue', 'LineWidth', 6);
% handlevector(5) = plot(1950:2010, spacCounts, 'Color', 'red');
% handlevector(6) = plot(1950:2010, tsmovavg(spacCounts, 's', 5), 'Color', 'red', 'LineWidth', 6);
% handlevector(7) = plot(1950:2010, nioCounts, 'Color', 'magenta');
% handlevector(8) = plot(1950:2010, tsmovavg(nioCounts, 's', 5), 'Color', 'magenta', 'LineWidth', 6);
% handlevector(9) = plot(1950:2010, sioCounts, 'Color', 'black');
% handlevector(10) = plot(1950:2010, tsmovavg(sioCounts, 's', 5), 'Color', 'black', 'LineWidth', 6);
% 
% title('Storm Counts for 1950-2010')
% xlabel('Year')
% ylabel('Number of Storms')
% legend('WPAC', '', 'EPAC', '',  'SPAC', '', 'NIO', '', 'SIO')
% legend(handlevector(1:2:9), 'location', 'NorthEastOutside')
% 
