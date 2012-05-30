% This script runs randomizations and computes both MIC and correlation
% heat maps for each one

addpath('../')

% Constants
START_YEAR = 1971;
END_YEAR = 2010;
MIN_INTENSITY = -Inf;
MAX_INTENSITY = Inf;
NUM_TRIALS = 9000;
RAND_INDEPENDENT = 0;

if RAND_INDEPENDENT
    savedir = 'RandomizationsIndShuffle/';
else
    savedir = 'RandomizationsSingleShuffle/';
end
if ~exist(savedir, 'dir')
    mkdir(savedir)
end

stormSeason = 8:10;
stormSeasonName = 'Aug-Oct';
stormRegion = 'EATL';
stormLatLims = [ 5 20 ];
stormLonLims = [ -45 -15 ];
sstSeason = 5:7;
sstSeasonName = 'May-July';

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
sstrefvec = [ 0.5 90 0 ];

% Count the storms
stormCounts = countStorms(storms, START_YEAR, END_YEAR, stormSeason, stormLatLims, stormLonLims);

% Get the seasonal SST mean grid for May-June from 1971-2010
seasonalSST = monthlyToSeasonal(sstData, sstDates, sstSeason, START_YEAR, END_YEAR);
flattenedSST = flattenData( seasonalSST );
allMIC = zeros(89,180,NUM_TRIALS);
parfor t = 1:NUM_TRIALS
    t
    % Determine how to randomize the data
%     if RAND_INDEPENDENT
%         % Shuffle the SST time steps independently at each point
%         shuffledSST = flattenedSST;
%         for i = 1:size(flattenedSST, 1)
%             shuffledSST(i, :) = flattenedSST(i, randperm(size(flattenedSST, 2)));
%         end
%         
%     else
        randIndices = randperm(size(flattenedSST, 2));
        shuffledSST = flattenedSST(:, randIndices);
%     end
    
    % Compute the MIC and correlation between each SST loc and storm counts
    allCorr(:,:,t) = reshape(rowCorr( shuffledSST, stormCounts ),89,180);
    allMIC(:,:,t) = reshape(parRowMIC( shuffledSST, stormCounts,num2str(t) ),89,180);
    
    % Create heat maps of correlation and MIC
%     corrMap = reshape(allCorr, size(sstData, 1), size(sstData, 2));
%     micMap = reshape(allMIC, size(sstData, 1), size(sstData, 2));
%     
%     % Plot the heat maps and save them
%     mapInfo.latLims = [ -90 90]; mapInfo.lonLims = [ 0 360 ];
%     mapInfo.figureTitle = [ 'Pointwise MIC - ' sstSeasonName ' Randomized SST vs ' stormSeasonName ...
%         ' ' stormRegion ' Storms' ];
%     h = plotHeatMaps(micMap, sstrefvec, mapInfo);
%     caxis( [ 0 1 ] );
%     saveas( h, [ savedir 'RandomMIC' num2str(t) '.png' ] );
%     close(h)
%     
%     mapInfo.figureTitle = [ 'Pointwise Correlation - ' sstSeasonName ' Randomized SST vs ' stormSeasonName ...
%         ' ' stormRegion ' Storms' ];
%     h = plotHeatMaps(corrMap, sstrefvec, mapInfo);
%     caxis( [ -1 1 ] );
%     saveas( h, [ savedir 'RandomCorr' num2str(t) '.png' ] );
%     close(h)
    
end
save('rand10k.mat','allMIC','allCorr');


