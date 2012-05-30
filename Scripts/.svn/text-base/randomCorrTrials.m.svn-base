
addpath('../')

NUM_TRIALS = 1000;
START_YEAR = 1971;
END_YEAR = 2010;

stormLatLims = [ 5 20; 5 20; 5 35; 5 35 ];
stormLonLims = [ -45 -15; -75 -45; -100 -75; -100 -15 ];
stormRegions = { 'EATL', 'CATL', 'WATL', 'ATL' };

sstSeasons = { 5:7, 6:10 };

% Load storm data and SST data
load /project/expeditions/haasken/data/ERSST/ersstv3.mat
sstData = erv3sst;
sstDates = erv3Dates;

load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
storms = condensedHurDat(:, [ 1 2 6 7 ]);

yearMask = floor(sstDates / 100) >= START_YEAR & floor(sstDates / 100) <= END_YEAR;
sstData = sstData( :, :, yearMask );
sstDates = sstDates(yearMask);

% Open a matlabpool for parallel computation of correlations and MIC
matlabpool open 8

for i = 1:length(stormRegions)
    
    regionStartTime = tic;
    fprintf('Starting the storm region: %s.\n', stormRegions{i});
    
    stormCounts = countStorms(storms, START_YEAR, END_YEAR, 6:10, stormLatLims(i, :), stormLonLims(i, :));
    
    for j = 1:length(sstSeasons)
        
        sstSeasonName = nameSeason(sstSeasons{j});
        saveName = [ stormRegions{i} '_' sstSeasonName 'SST_RandomResults' ];
        
        % Get the seasonal average sst and flatten it
        seasonal = monthlyToSeasonal(sstData, sstDates, sstSeasons{j} );
        flattened = flattenData(seasonal);
        
        % Run the randomization for MIC and Correlation
        randomCorr = randomizeParallel(flattened, stormCounts, NUM_TRIALS, 'bootstrap', @rowCorr);
        randomMIC = randomizeParallel(flattened, stormCounts, NUM_TRIALS, 'bootstrap', @rowMIC);
        
        % Save the results for the given storm region and sst season
        save( [ saveName '.mat' ], 'randomCorr', 'randomMIC' )
        
    end
    
    regionEndTime = toc(regionStartTime);
    fprintf('Finished storm region %s in %.2f minutes.\n', stormRegions{i}, regionEndTime / 60)
    
end


