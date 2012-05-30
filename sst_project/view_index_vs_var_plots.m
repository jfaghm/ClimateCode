%plot index vs variables results
gridInfo.lats = double(gridInfo.lats);
gridInfo.lons = double(gridInfo.lons);

subplot(4,2,1)
worldmap world
pcolorm(erv3GridInfo.lats,erv3GridInfo.lons,anomalyCorrGrid)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('SST Anomalies Corr')

subplot(4,2,2)
worldmap world
pcolorm(erv3GridInfo.lats,erv3GridInfo.lons,anomalyMICGrid)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('SST Anomalies MIC')
subplot(4,2,3)
worldmap world
pcolorm(gridInfo.lats,gridInfo.lons,mslpCorr)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('MSLP Corr')
subplot(4,2,4)
worldmap world
pcolorm(gridInfo.lats,gridInfo.lons,mslpMIC)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('MSLP MIC')
subplot(4,2,5)
worldmap world
pcolorm(gridInfo.lats,gridInfo.lons,gphCorr)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('GPH Corr')
subplot(4,2,6)
worldmap world
pcolorm(gridInfo.lats,gridInfo.lons,gphMIC)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('GPH MIC')
subplot(4,2,7)
worldmap world
pcolorm(gridInfo.lats,gridInfo.lons,vwsCorr)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('VWS Corr')
subplot(4,2,8)
worldmap world
pcolorm(gridInfo.lats,gridInfo.lons,vwsMIC)
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
title('VWS MIC')
print('-dpdf', '-r400','index_vs_vars')


