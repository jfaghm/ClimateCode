
% Add the path to all the relevant functions
addpath('../')

stormLats = [ 5 20; 5 30; 5 30 ];
stormLons = [ -45 -10; -100 -15; -100 -70 ];
regionNames = { 'EastAtlantic', 'EntireAtlantic', 'WestAtlantic' };

stormSeasons = { 6:10, 8, 9, 8:9 };
sstRanges = { 5:7, 5:7, 5:8, 5:7 };

sstBoxSeasonNames = {};
% Index for saving sst box data
sstBoxIndex = 0;

% Load the SST data
load('/project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat');
% Remove the partial years, which are annoying
reynoldsSST(:, :, [ 1 2 end-5:end ]) = [];
reynoldsDates([ 1 2 end-5:end ]) = [];
% SST data variables used in the script
sstData = reynoldsSST;
sstDates = reynoldsDates;
sstGridInfo = rGridInfo;

% Load the storm data
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat');
storms = condensedHurDat(:, [ 1 2 6 7 ]);

% Set up the atlantic basin data limits
sstLims = struct('west', -90, 'east', -15, 'north', 35, 'south', 0, 'step', 5, ...
    'minBoxWidth', 15, 'maxBoxWidth', 30, 'minBoxHeight', 10, 'maxBoxHeight', 20, ...
    'months', 6:10, 'startYear', 1982, 'endYear', 2010);

% Set up the map info for plotting point correlation heat maps
mapInfo.latLims = [-90 90];
mapInfo.lonLims = [0 360];
mapInfo.colorLims = [ -1 1 ]; % Why doesn't this work??

% Set up the plotHeatMaps internal persistent variables for speedy plots
plotHeatMaps(zeros(size(sstData, 1), size(sstData, 2)), [1 90 0], mapInfo);

for sb = 1:length(regionNames)
    
    fprintf('Starting storm region: %s.\n', regionNames{sb})
    
    % Make a directory for the storm box
    if ~exist( regionNames{sb}, 'dir' )
        mkdir( regionNames{sb} )
    end
    
    for ss = 1:length( stormSeasons )
        
        % Construct the storm season name
        if ( length(stormSeasons{ss}) == 1 )
            stormSeasonName = datestr([2000 stormSeasons{ss} 1 0 0 0 ], 'mmm');
        else
            stormSeasonName = [ datestr([ 2000 stormSeasons{ss}(1) 1 0 0 0 ], 'mmm') '-' ...
                datestr([ 2000 stormSeasons{ss}(end) 1 0 0 0 ], 'mmm') ];
        end
        
        fprintf('\tStarting storm season: %s.\n', stormSeasonName)
        
        % Make a directory for the storm season within storm box directory
        if ~exist( [ regionNames{sb} '/' stormSeasonName ], 'dir' )
            mkdir( [ regionNames{sb} '/' stormSeasonName ] )
        end
        
        % Set the save path for all results for given storm box and season
        savePath = [ regionNames{sb} '/' stormSeasonName '/' ];
        
        % Get the storm counts
        stormCounts = countStorms(storms, sstLims.startYear, sstLims.endYear, ...
            stormSeasons{ss}, stormLats(sb, :), stormLons(sb, :) );
        
        sstRange = sstRanges{ss};
        numMonths = length(sstRange);
        
        % Allocate a cell array to store the most highly correlated boxes
        resultsIndex = 0;
        bestBoxes = cell( 1, nchoosek(numMonths, 2) + numMonths );
        bestBoxesLabels = cell( 1, nchoosek(numMonths, 2) + numMonths );
        
        % Initialize maxCorr for finding highest correlation among all
        % possible sst seasons
        maxCorr = -Inf;
        
        for i = 1:numMonths
            startMonth = sstRange(i);
            for j = i:numMonths
                endMonth = sstRange(j);
                
                % Construct the SST season
                if startMonth > endMonth
                    sstSeason = [ startMonth:12 1:endMonth ];
                else
                    sstSeason = startMonth:endMonth;
                end
                
                % Set the sstLims structure's months field
                sstLims.months = sstSeason;
                
                % Construct the SST season name
                if ( length(sstSeason) == 1)
                    sstSeasonName = datestr( [2000 sstSeason 1 0 0 0 ], 'mmm');
                else
                    sstSeasonName = [ datestr( [2000 sstSeason(1) 1 0 0 0], 'mmm') '-' ...
                        datestr( [2000 sstSeason(end) 1 0 0 0], 'mmm') ];
                end
                
                fprintf('\t\tStarting sst season: %s.\n', sstSeasonName)
                
                % Check if the sst box data for this season has already
                % been collected
                if ismember( sstSeasonName, sstBoxSeasonNames )
                    sstBoxData = savedSSTBoxes{ ismember(sstBoxSeasonNames, sstSeasonName) };
                else
                    getDataStartTime = tic;
                    fprintf('\t\t\tGetting sst box data for %s.\n', sstSeasonName)
                    % Get the SST box data and store it in the cell array
                    sstBoxIndex = sstBoxIndex + 1;
                    sstBoxSeasonNames{sstBoxIndex} = sstSeasonName;
                    sstBoxData = getAllBoxData( sstData, sstDates, sstGridInfo, sstLims, true );
                    
                    % Remove boxes which are over land
                    mask = isNonLand(sstBoxData(:, 1:4), 0.2);
                    sstBoxData = sstBoxData(mask, :);
                    
                    % Save the sst box data for possible reuse
                    savedSSTBoxes{sstBoxIndex} = sstBoxData;
                    
                    getDataEndTime = toc(getDataStartTime);
                    fprintf('\t\t\tFinished getting sst box data for %s in %.2f seconds.\n', sstSeasonName, getDataEndTime)
                    
                end
                
                % Now we have the sst box data and the storm counts
                
                % Correlate the sst box data time series with storm counts
                allCorrelations = rowCorr(sstBoxData(:, 5:end), stormCounts);
                % Sort the correlations matrix by correlation
                [~, sortIndices] = sort(allCorrelations(:, 1), 'descend');
                sortedBoxes = [ allCorrelations(sortIndices), sstBoxData(sortIndices, 1:4) ];
                sortedBoxes = sortedBoxes(~isnan(sortedBoxes(:, 1)), :);
                % Save the best correlated boxes in a cell array to be
                % saved at the end of this storm season as a matfile
                resultsIndex = resultsIndex + 1;
                bestBoxes{resultsIndex} = sortedBoxes;
                bestBoxesLabels{resultsIndex} = sstSeasonName;
                
                % Update the maximum correlation for this storm season
                if ( sortedBoxes(1, 1) > maxCorr )
                    maxBox = sortedBoxes(1, :);
                    maxCorr = maxBox(1, 1);
                    maxBoxSeasonName = sstSeasonName;
                end
                
                % Compute the pointwise correlation matrix with pointCorr
                seasonalAverageGrid = monthlyToSeasonal(reynoldsSST, reynoldsDates, sstLims.months);
                correlationMap = pointCorr(seasonalAverageGrid, stormCounts);
                % Plot the correlation heat map using plotHeatMaps
                % mapInfo.figureTitle = [ 'Correlation between ' sstSeasonName ' SST and storm counts' ];
                % heatMap = plotHeatMaps(correlationMap, [1 90 0], mapInfo);
                heatMap = plotHeatMaps(correlationMap);
                title( [ 'Correlation between ' sstSeasonName ' SST and storm counts' ] );
                caxis([-.8, .8]);
                saveas(heatMap, [ savePath 'sstCorr' sstSeasonName '.png' ])
                
                fprintf('\t\tFinished sst season: %s.\n', sstSeasonName);
                
            end
        end
        
        % Plot the most highly correlated box for this storm season
        boxPlot = plotBoxes( [ maxBox stormLats(sb, :) stormLons(sb, :) ], [-50 50 ], [-130 20 ] );
        title( [ maxBoxSeasonName ' SST box and storm box with correlation of ' num2str(maxCorr, '%.2f')] );
        saveas(boxPlot, [ savePath 'BestBox.png' ])
        
        % Save all the box correlation data
        save( [ savePath 'boxCorrelationData.mat' ], 'bestBoxes', 'bestBoxesLabels' )
        
        fprintf('\tFinished storm season: %s.\n', stormSeasonName)
        
    end
    
    fprintf('Finished storm region: %s.\n', regionNames{sb})
    
end


