
% This script runs and saves the randomization experiments several times
% with different numbers of trials and saves the data and figures to the
% folder randomCorrData.


%% Set up the latitude and longitude limits of sst boxes and the stormRegion
sstLims.step = 5;
sstLims.minWidth = 5;
sstLims.maxWidth = 20;
sstLims.minHeight = 5;
sstLims.maxHeight = 20;
sstLims.north = 45;
sstLims.south = 5;
sstLims.west = -80;
sstLims.east = -18;

stormRegion.latlims = [ 10 20 ]; 
stormRegion.lonlims = [-80 -20];

%% Run the experiment with 1,000,000 (one million) trials and save the results
%{
bestCorr = getRandomCorrelations(sstLims, stormRegion, 'atlantic', 1000000);

save('randomCorrData/megaRandomized.mat', 'bestCorr')

f = figure;
hist(bestCorr(:, 1), 100);
saveas(f, 'randomCorrData/megaHistogram.png')
saveas(f, 'randomCorrData/megaHistogram.fig')
%}
%% Run the experiment with 10,000 trials and save the results

bestCorr = getRandomCorrelations(sstLims, stormRegion, 'atlantic', 10000);

save('randomCorrData/randomized10K.mat', 'bestCorr')

f = figure;
hist(bestCorr(:, 1), 100);
saveas(f, 'randomCorrData/histogram10K.png')
saveas(f, 'randomCorrData/histogram10K.fig')

close(f)

sortedBestCorr = sortrows(bestCorr, -1);
topCorrelations = sortedBestCorr(1:floor(size(sortedBestCorr, 1) / 1000), :);

plotBestBoxes(bestCorr, size(bestCorr, 1) / 1000, 'randomCorrData/best10K', ...
    [ -30 50 ], [-100 10 ])


%% Run the experiment with 1,000 trials and save the results

bestCorr = getRandomCorrelations(sstLims, stormRegion, 'atlantic', 1000);

save('randomCorrData/randomized1K.mat', 'bestCorr')

f = figure;
hist(bestCorr(:, 1), 100);
saveas(f, 'randomCorrData/histogram1K.png')
saveas(f, 'randomCorrData/histogram1K.fig')


close all

clear

