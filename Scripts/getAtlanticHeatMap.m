
sstLims.step = 1;
sstLims.minWidth = 10;
sstLims.maxWidth = 10;
sstLims.minHeight = 10;
sstLims.maxHeight = 10;
sstLims.north = 50;
sstLims.south = -50;
sstLims.west = -90;
sstLims.east = 0;

stormLims.step = 5;
stormLims.minWidth = 15;
stormLims.maxWidth = 90;
stormLims.minHeight = 10;
stormLims.maxHeight = 100;
stormLims.north = 50;
stormLims.south = -50;
stormLims.west = -90;
stormLims.east = 0;

tic
[ allBoxStorms, allBoxSST, allCorrelations ] = prepareHeatMap(sstLims, stormLims, 'atlantic');
fprintf('Finished prepareHeatMap in %.2f minutes.\n', toc/60)

gridInfo.northLimit = 89.5; gridInfo.westLimit = -179.5; gridInfo.latStep = 1; gridInfo.lonStep = 1;

tic
[ corrHeatMap, bestBoxes ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations, gridInfo );
fprintf('Finished createHeatMap in %.2f minutes.\n', toc/60)

load('/project/expeditions/haasken/MATLAB/OptimizeCorr/reynoldsLandMask.mat')
corrHeatMap(circshift(reynoldsLandMask, [0 180 0])) = NaN;

lonInfo.start = -179.5; lonInfo.step = 1; lonInfo.end = 179.5;
latInfo.start = 89.5; latInfo.step = -1; latInfo.end = -89.5;

saveAsNetCDF( corrHeatMap, latInfo, lonInfo, 'atlanticHeatMapFaster3.nc' )

save('atlanticResultsFaster3.mat')

!pwd | mail -s finished haask010@umn.edu