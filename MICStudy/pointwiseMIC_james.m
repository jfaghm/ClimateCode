% Prepares data for pointwise MIC computation between SST and storm counts

addpath('../')

sstSeasons = { 5, 5:6, 5:7, 6:7, 6:10, 8:10, 8:9 };

START_YEAR = 1971;
END_YEAR = 2010;
MIN_INTENSITY = -Inf;
MAX_INTENSITY = Inf;

stormRegions = { 'EATL', 'WATL', 'CATL','ATL' };
stormRegionsLatLims = [ 5 20; 5 35; 5 20; 5 35 ];
stormRegionsLonLims = [ -45 -15; -100 -70;-69 -46; -100 -15 ];
% stormRegions = { 'EATL' };
% stormRegionsLatLims = [ 5 20 ];
% stormRegionsLonLims = [ -45 -15 ];
stormSeasons = { 6:10, 8:9, 8:10 };

% Load storm data
load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
% Keep only storms with intensity between MAX_INTENSITY and MIN_INTENSITY
intensityMask = (condensedHurDat(:, 10) <= MAX_INTENSITY) & ... 
    (condensedHurDat(:, 10) >= MIN_INTENSITY);
storms = condensedHurDat(intensityMask, [ 1 2 6 7 ]);

% Load sst data
load /project/expeditions/haasken/data/ERSST/ersstv3.mat
sstData = erv3sst;
sstDates = erv3Dates;
sstrefvec = [ 0.5 88 0 ];
count = 1;
% For each storm region
for i = 1:length(stormRegions)
    stormRegion = stormRegions{i};
    stormLatLims = stormRegionsLatLims(i, :);
    stormLonLims = stormRegionsLonLims(i, :);
    
    % For each storm season
    for j = 1:length(stormSeasons)
        stormSeason = stormSeasons{j};
        stormSeasonName = nameSeason(stormSeason);
        
        % Count the storms
        stormCounts = countStorms(storms, START_YEAR, END_YEAR, stormSeason, stormLatLims, stormLonLims);
        
        % For each sst season
        for k = 1:length(sstSeasons)
            sstSeason = sstSeasons{k};
            sstSeasonName = nameSeason(sstSeason);
            
        
            % Get the SST into workable form
            %seasonal = monthlyToSeasonal(sstData, sstDates, sstSeason, START_YEAR, END_YEAR);
            %flattened = flattenData(seasonal);
            
            % Compute the correlation between SST and storm counts
            %correlation = rowCorr( flattened, stormCounts );
            %correlationMap{count} = pointCorr(seasonal, stormCounts);
            
            % Set up a save name for everything
            saveName = [ stormRegion stormSeasonName '_' sstSeasonName '_SST'];
            
            %fprintf('Computing MIC for %s . . . ', saveName)
            %MIC{count} = rowMIC( flattened, stormCounts);
            %fprintf('finished.\n')
            name{count} = saveName;
            count = count+1;
            %{
            % Concatenate SST and storm counts
            sstAndStormCounts = [ flattened; stormCounts ];
            sstAndStormCounts = [ [1:size(sstAndStormCounts)]' sstAndStormCounts ];
            
            % Remove all NaN rows
            sstAndStormCounts( any(isnan(sstAndStormCounts), 2), :) = [];
            dataSetSize = size(sstAndStormCounts, 1);
            
            % Set up a save name for everything
            saveName = [ stormRegion stormSeasonName '_' sstSeasonName ];
            
            % Now write the SST and storm counts data to a csv file in another
            % directory
            inputFile = 'sstAndStormCounts.csv';
            dlmwrite(inputFile, sstAndStormCounts)
            
            fprintf('Computing MIC for %s . . . ', saveName);
            % Call the java program to compute MIC and store results in a text file
            commandString = [ 'java -jar MINE.jar ' inputFile ' -pairsBetween ' num2str(dataSetSize-1) ...
                ' id=' saveName ...
                ' > /dev/null' ]; % Don't display output
            system( commandString );
            fprintf('finished.\n')
            
            
            % Now process the output file to create a heat map of MIC
            outputFile = [ inputFile ',' saveName ',Results.csv' ];
            % Open the file
            fid = fopen(outputFile);
            % Use textscan to read the output file appropriately
            % First grab the column headings (8 total)
            % Here are the headings:
            % X var,Y var,MIC (strength),MIC-p^2 (nonlinearity),
            % MAS (non-monotonicity),MEV (functionality),MCN (complexity),
            % Linear regression (p)
            columnHeadings = textscan(fid, '%s %s %s %s %s %s %s %s', 1, 'Delimiter', ',');
            % Now read the rest of the file and convert to a double matrix
            results = textscan(fid, '%f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32', 'Delimiter', ',');
            results = cell2mat(results);
            
            % Put the MIC back into a vector to plot against the
            % correlation coefficient
            MIC = zeros( size(flattened, 1), 1 );
            MIC(results(:, 1)) = results(:, 3);
            %}
            
            % Get the pointwise correlation and compare to that returned by
            % MINE program
            %{
            mineCorrelation = zeros( size(flattened, 1), 1 );
            mineCorrelation( results(:, 1) ) = results(:, 8);
            difference = abs( mineCorrelation - correlation );
            if any(difference > 1e-5)
                fprintf('There is a discrepancy of %.5f between MINE correlation and rowCorr.\n', ...
                    max(difference));
            end
            %}
            
            % Plot the MIC versus the correlation
            %sf = figure('Visible', 'off');
            %scatter( MIC, correlation, 6);
            %xlim([0 1]); ylim([-1 1]);
            %xlabel('MIC'); ylabel('Correlation');
            %title( [ 'MIC vs Correlation for ' sstSeasonName ' SST vs ' stormSeasonName ...
            %    ' ' stormRegion ' Storms' ] );
            %saveas( sf, [ saveName '_CCvsMIC.png' ] );
            %close(sf);
            
            % Now put the coefficients back into a matrix of the same size as sstData
            %{
            micHeatMap = nan(size(sstData, 1), size(sstData, 2));
            micHeatMap(results(:, 1)) = results(:, 3);
            %}
            %micHeatMap = reshape( MIC, size(sstData, 1), size(sstData, 2) );
            
            % Now plot the resulting MIC heat map
%             mapInfo.latLims = [ -90 90]; mapInfo.lonLims = [ 0 360 ];
%             mapInfo.figureTitle = [ 'Pointwise MIC - ' sstSeasonName ' SST vs ' stormSeasonName ...
%                 ' ' stormRegion ' Storms' ];
%             mapInfo.colorLims = [ -1 1 ]; % doesn't work
            
            %plotHeatMaps(micHeatMap, sstrefvec, mapInfo);
                      
            %saveas( h, [ saveName '.png' ] );
            %close(h)
%             figure('Visible','O ff');
%             subplot(1,2,1)
%             worldmap world
%             pcolorm(-90:90,0:360,flipdim(micHeatMap,1))
%             title(['MIC - Min: ' num2str(min(min(micHeatMap))) ' - Max: ' num2str(max(max(micHeatMap)))]);
%             caxis( [ 0 1 ] );  
            %{subp
            % Plot the MIC - p^2 heat map
%             nonLinearityHeatMap = nan(size(sstData, 1), size(sstData, 2));
%             nonLinearityHeatMap(results(:, 1)) = results(:, 4);
%             mapInfo.figureTitle = [ 'Pointwise MIC vs Correlation - ' sstSeasonName ' SST vs ' stormSeasonName ...
%                 ' ' stormRegion ' Storms' ];
%             h = plotHeatMaps(nonLinearityHeatMap, sstrefvec, mapInfo);
%             caxis([-.1 .5]);
%             saveas(h, [ 'micVSp_' saveName '.png' ]);
%             close(h)
            %}
            
            % Plot the correlation map
%             mapInfo.figureTitle = [ 'Pointwise Correlation - ' sstSeasonName ' SST vs ' stormSeasonName ...
%                 ' ' stormRegion ' Storms' ];
            
            %plotHeatMaps(correlationMap, sstrefvec, mapInfo);
%             subplot(1,2,2)
%             caxis([-1 1]);
%             worldmap world
%             pcolorm(-90:90,0:360,flipdim(correlationMap,1))
%             title(['Correlation - Min: ' num2str(min(min(correlationMap))) ' - Max: ' num2str(max(max(correlationMap)))]);
%             %saveas(h, [ 'corr_' saveName '.png' ])
%             %close(h)
%             ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%             main_title = [sstSeasonName ' SST vs ' stormSeasonName ' ' stormSeasonName ' ' stormRegion ' Storms' ];
%             text(0.5, 1,main_title,'HorizontalAlignment' ,'center','VerticalAlignment', 'top')
%             print('-dpdf','-r350',saveName)
%             close all 
        end
    end
end

