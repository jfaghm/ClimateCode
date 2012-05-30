
load('/project/expeditions/haasken/MATLAB/OptimizeCorr/boxLimits.mat')

sstLims.step = 2;
stormLims.step = 2;

[ bestH, bestR, allReynoldsSST, allHadleySST, allStormCounts, allReynoldsCorr, allHadleyCorr ] = findOptCorrBoxes( sstLims, stormLims );

save('correlationResults.mat', 'bestH', 'bestR', 'allReynoldsSST', 'allHadleySST', 'allStormCounts', 'allReynoldsCorr', 'allHadleyCorr')

!pwd | mail -s finished haask010@umn.edu 