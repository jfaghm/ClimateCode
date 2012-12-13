
%Use this script to create the composites that will be used in the spatial
%ENSO draft.  

load /project/expeditions/ClimateCodeMatFiles/ersstv3_1854_2012_raw
[anomalies, anomalyDates] = getMonthlyAnomalies(sst, sstDates, 1948, 2010);
annualSST = getAnnualSSTAnomalies(6, 10, 1979, 2010, anomalies, anomalyDates);

[~,~,maxJ] = buildSSTLonDiff(annualSST, sstLat, sstLon);
lonRegion = sstLon(sstLon >= 140 & sstLon <= 260);
index = lonRegion(maxJ);

vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables');
[nYears, pYears] = getPosNegYearsFromVector(index, 1, false, 1979);
[~,~,composite] = getComposites(vars.PI, pYears, nYears, vars.dates, 8, 10);

%% 
[~,~,composite] = getComposites(vars.PI, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(lat, lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-18 18]);
colorbar
title('Spatial ENSO Jun-Oct PI Composite')
saveas(gcf, 'ncComposites/spatialENSOPIComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.gpiMat, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(lat, lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-11 6]);
colorbar
title('Spatial ENSO Jun-Oct GPI Composite')
saveas(gcf, 'ncComposites/spatialENSOGPIComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.windShear, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(lat, lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-10 10]);
colorbar
title('Spatial ENSO Jun-Oct Wind Shear Composite')
saveas(gcf, 'ncComposites/spatialENSOWindShearComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.sst, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(lat, lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-1 2]);
colorbar
title('Spatial ENSO Jun-Oct SST Composite')
saveas(gcf, 'ncComposites/spatialENSOSSTComposite.pdf', 'pdf');

%% 
clear 
vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables')
hurr = getASOTCs(1979, 2010);
[nYears, pYears] = getPosNegYearsFromVector(hurr, 1, true, 1979);
%% 
[~,~,composite] = getComposites(vars.PI, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-18 18]);
colorbar
title('Hurricane Counts PI Composite')
saveas(gcf, 'ncComposites/hurricaneCountsPIComposite.pdf', 'pdf');
%% 
[~,~,composite] = getComposites(vars.gpiMat, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-11 6]);
colorbar
title('Hurricane Counts GPI Composite')
saveas(gcf, 'ncComposites/hurricaneCountsGPIComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.windShear, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-10 10]);
colorbar
title('Hurricane Counts Wind Shear Composite')
saveas(gcf, 'ncComposites/hurricaneCountsWindShearComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.sst, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-1 2]);
colorbar
title('Hurricane Counts SST Composite')
saveas(gcf, 'ncComposites/hurricaneCountsSSTComposite.pdf', 'pdf');

%% 
clear
nino34 = getNINO(1979, 2010, 6, 10, 2);
vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables');
[nYears, pYears] = getPosNegYearsFromVector(nino34, 1, false, 1979);

%% 
[~,~,composite] = getComposites(vars.PI, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-18 18]);
colorbar
title('NINO 3.4 PI Composite')
saveas(gcf, 'ncComposites/nino3.4PIComposite.pdf', 'pdf');
%% 
[~,~,composite] = getComposites(vars.gpiMat, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-11 6]);
colorbar
title('NINO 3.4 GPI Composite')
saveas(gcf, 'ncComposites/nino3.4GPIComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.windShear, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-10 10]);
colorbar
title('NINO 3.4 Wind Shear Composite')
saveas(gcf, 'ncComposites/nino3.4WindShearComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.sst, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-1 2]);
colorbar
title('NINO 3.4 SST Composite')
saveas(gcf, 'ncComposites/nino3.4SSTComposite.pdf', 'pdf');


%% 
clear
nino12 = getNINO(1979, 2010, 6, 10, 1);
vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables');
[nYears, pYears] = getPosNegYearsFromVector(nino12, 1, false, 1979);

%% 
[~,~,composite] = getComposites(vars.PI, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-18 18]);
colorbar
title('NINO 1+2 PI Composite')
saveas(gcf, 'ncComposites/nino1+2PIComposite.pdf', 'pdf');
%% 
[~,~,composite] = getComposites(vars.gpiMat, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-11 6]);
colorbar
title('NINO 1+2 GPI Composite')
saveas(gcf, 'ncComposites/nino1+2GPIComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.windShear, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-10 10]);
colorbar
title('NINO 1+2 Wind Shear Composite')
saveas(gcf, 'ncComposites/nino1+2WindShearComposite.pdf', 'pdf');

%% 
[~,~,composite] = getComposites(vars.sst, pYears, nYears, vars.dates, 8, 10);
worldmap([0, 40],[280, 345])
pcolorm(vars.lat, vars.lon, composite);
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
caxis([-1 2]);
colorbar
title('NINO 1+2 SST Composite')
saveas(gcf, 'ncComposites/nino1+2SSTComposite.pdf', 'pdf');





















