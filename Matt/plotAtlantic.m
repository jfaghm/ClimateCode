function [ ] = plotAtlantic()
%This function loads the difference in positive and negative composites,
%and then plots the data inside the main development region
%
%----------------------------Input----------------------------------------
%--->none, the data is loaded from the composites directory where the .mat
%files are saved
%
%----------------------------Ouput----------------------------------------
%--->nothing gets returned from this function, however, the images of the
%main development regions are printed to the directory specified in the
%call to print.

sigma = 1.0;

comboIndex = buildIndexVariations(34, 3, 10);
[nYears, pYears] = getPosNegYearsFromVector(comboIndex, sigma, true, 1979);
comboYears = struct('pYears', pYears, 'nYears', nYears);

load /project/expeditions/lem/ClimateCode/Matt/matFiles/monthly_nino_data.mat;
[nYears, pYears] = posNegNino3_4Years(data, 3, 10, sigma);
ninoYears = struct('nYears', nYears, 'pYears', pYears);

load /project/expeditions/lem/ClimateCode/Matt/matFiles/condensedHurDat.mat;
[nYears, pYears] = getPositiveAndNegativeYears(condensedHurDat, sigma);
hurrYears = struct('nYears', nYears, 'pYears', pYears);

years = struct('nino', ninoYears, 'hurr', hurrYears, 'combo', comboYears);

%plotMDRDiffOnly('CentralPressureComposite.mat', [-300 300], true, 'Central Pressure', years, sigma);
plotMDRDiffOnly('PIComposite.mat', [-15 20], true, 'PI', years, sigma);
plotMDRDiffOnly('sstComposite.mat', [-1 2], true, 'SST', years, sigma);
plotMDRDiffOnly('windShearComposite.mat', [-10 10], true, 'Wind Shear', years, sigma);
%plotMDRDiffOnly('relativeHumidity850mbarComposite.mat', [-10.5 11], true, 'RelHumidity (850mbar)', years, sigma);
%plotMDRDiffOnly('relativeHumidity500mbarComposite.mat', [-13 13], true, 'RelHumidity (500mbar)', years, sigma);
%plotMDRDiffOnly('relativeHumidity850_500mbarDiffComposite.mat', [-11 11], true, ...
%    'RelHumidity (850-500mbar Diff)', years, sigma);
%plotMDRDiffOnly('precipitableWaterComposite.mat', [-4 5], true, 'Precipitable Water', years, sigma);
%plotMDRDiffOnly('geoPotential500_1000DiffmbarComposite.mat', [-200 300], true, ...
%    'Geopotential Height (500-1000mbar Diff)', years, sigma);
%plotMDRDiffOnly('geoPotential500mbarComposite.mat', [-150 150], true, ...
%    'Geopotential Height (500mbar)', years, sigma);
%plotMDRDiffOnly('saturationDeficit500mbarComposite.mat', [-.5 .5], true, ...
    'Saturation Deficit (500mbar)', years, sigma);
%plotMDRDiffOnly('saturationDeficit850mbarComposite.mat', [-3 2], true, ...
%    'Saturation Deficit (850mbar)', years, sigma);
%plotMDRDiffOnly('saturationDeficit500_850DiffmbarComposite.mat', [-3, 2], true, ...
%    'Saturation Deficit (500-850mbar Diff)', years, sigma);
end

function [] = plotMDRDiffOnly(var, scaleDims, landMask, varName, years, sigma)
if isempty(scaleDims)
    scale = false;
else
    scale = true;
end
close all
%----Change these variables when using a differnt index--------
indexType = 'pacificHurr';
suffix = 'PacificHurr';
indexName = 'sstBoxDiff';
saveDir = '/project/expeditions/lem/ClimateCode/Matt/';
saveDir = [saveDir 'indexExperiment/results/' indexType '/atlanticComposites/'...
    varName '.pdf'];

eval(['load composites'  '/' indexType '/' var]);
eval(['load composites'  '/ENSO_3.4/' var]);
eval(['load composites' '/hurricaneFrequency/' var]);
%-------------------------------------------------------------------
lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
fig(figure(1), 'units', 'inches', 'width', 8, 'height', 11)

subplot(3, 1, 1)
%worldmap([0 45], [-80, -15])
worldmap world
pcolorm(lat, lon, diffENSO)
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title({['NINO3.4 ' varName ' ' num2str(sigma) 'StdDev']; ...
    ['pYears = ' num2str(years.nino.pYears')]; ['nYears = ' num2str(years.nino.nYears')]})
colorbar

subplot(3, 1, 2)
%worldmap([0 45], [-80, -15])
worldmap world
pcolorm(lat, lon, eval(['diff' suffix]))
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title({[indexName ' ' varName ' 1StdDev'];...
    ['pYears = ' num2str(years.combo.pYears')]; ['nYears = ' num2str(years.combo.nYears')]})
colorbar

subplot(3, 1, 3)
%worldmap([0 45], [-80, -15])
worldmap world
pcolorm(lat, lon, diffHurr)
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title({['Hurr ' varName ' 1StdDev']; ['pYears = ' num2str(years.hurr.pYears')]; ...
    ['nyears = ' num2str(years.hurr.nYears')]})
colorbar
if landMask == true
    set(gcf, 'PaperPosition', [0, 0, 8, 11]);
    set(gcf, 'PaperSize', [8, 11]);
    saveas(gcf, saveDir, 'pdf');
end
end


