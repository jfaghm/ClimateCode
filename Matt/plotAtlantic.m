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

plotMDRDiffOnly('CentralPressureComposite.mat', [-300 300], true, 'Central Pressure');
plotMDRDiffOnly('PIComposite.mat', [-15 20], true, 'PI');
plotMDRDiffOnly('sstComposite.mat', [-1 2], true, 'SST');
plotMDRDiffOnly('windShearComposite.mat', [-10 10], true, 'Wind Shear');
plotMDRDiffOnly('relativeHumidity850mbarComposite.mat', [-10.5 11], true, 'RelHumidity (850mbar)');
plotMDRDiffOnly('relativeHumidity500mbarComposite.mat', [-13 13], true, 'RelHumidity (500mbar)');
plotMDRDiffOnly('relativeHumidity850_500mbarDiffComposite.mat', [-11 11], true, ...
    'RelHumidity (850-500mbar Diff)');
plotMDRDiffOnly('precipitableWaterComposite.mat', [-4 5], true, 'Precipitable Water');
plotMDRDiffOnly('geoPotential500_1000DiffmbarComposite.mat', [-200 300], true, ...
    'Geopotential Height (500-1000mbar Diff)');
plotMDRDiffOnly('geoPotential500mbarComposite.mat', [-150 150], true, ...
    'Geopotential Height (500mbar)');
plotMDRDiffOnly('saturationDeficit500mbarComposite.mat', [-.5 .5], true, ...
    'Saturation Deficit (500mbar)');
plotMDRDiffOnly('saturationDeficit850mbarComposite.mat', [-3 2], true, ...
    'Saturation Deficit (850mbar)');

end

function [] = plotMDRDiffOnly(var, scaleDims, landMask, varName)
if isempty(scaleDims)
    scale = false;
else
    scale = true;
end

%----Change these two variables when using a differnt index--------
indexType = 'comboIndex9';
suffix = 'ComboIndex9';
indexName = 'sstBoxDiff';
%dir = 'bestComboIndexMonthRange';

eval(['load composites/'  '/' indexType '/' var]);
eval(['load composites/'  '/ENSO_3.4/' var]);
eval(['load composites/' '/hurricaneFrequency/' var]);

lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
fig(figure(1), 'units', 'inches', 'width', 6, 'height', 11)

subplot(3, 1, 1)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffENSO)
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference NINO3.4 ' varName '1StdDev'])
colorbar

subplot(3, 1, 2)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, eval(['diff' suffix]))
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference ' indexName ' ' varName ' 1StdDev'])
colorbar

subplot(3, 1, 3)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffHurr)
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference Hurr ' varName ' 1StdDev'])
colorbar
if landMask == true
    print('-dpdf', '-r400', ['indexExperiment/results/' indexType ...
        '/atlanticComposites/' varName 'Composite.pdf']);
    %print('-dpdf', '-r400', ['indexExperiment/results/comboIndex349' ...
    %    '/bestComboIndexMonthRangeAtlanticComposites/' varName 'Composite.pdf']);
end
end


