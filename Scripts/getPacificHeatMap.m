

sstLims.step = 1;
sstLims.minWidth = 10;
sstLims.maxWidth = 10;
sstLims.minHeight = 10;
sstLims.maxHeight = 10;
sstLims.north = 30;
sstLims.south = 0;
sstLims.west = 120;
sstLims.east = -160;

stormLims.step = 1;
stormLims.minWidth = 15;
stormLims.maxWidth = 50;
stormLims.minHeight = 10;
stormLims.maxHeight = 50;
stormLims.north = 30;
stormLims.south = 0;
stormLims.west = 120;
stormLims.east = -160;

tic
[ allBoxStorms, allBoxSST, allCorrelations ] = prepareHeatMap(sstLims, stormLims);
fprintf('Finished prepareHeatMap in %.2f minutes.\n', toc/60)

tic
[ corrHeatMap, bestBoxes ] = createHeatMap( allBoxSST, allBoxStorms, allCorrelations );
fprintf('Finished createHeatMap in %.2f minutes.\n', toc/60)

lonInfo.start = -179.5; lonInfo.step = 1; lonInfo.end = 179.5;
latInfo.start = 89.5; latInfo.step = -1; latInfo.end = -89.5;

saveAsNetCDF( corrHeatMap, latInfo, lonInfo, 'pacificHeatMap.nc' )

save('pacificResults.mat')

!pwd | mail -s finished haask010@umn.edu