function [ ] = plotAtlantic()
%This function loads the difference in positive and negative composites,
%and then plots the data inside the main development region
%
%----------------------------Input----------------------------------------
%--->none, the data is loaded from the composites directory where the .mat
%files are saved
%
%----------------------------Ouput----------------------------------------
%--->nothing gets returned from this function, howver, the images of the
%main development regions are printed to the directory specified in the
%call to print.

plotMDRDiffOnly('CentralPressureComposite.mat', [-3 3.5], true, 'Central Pressure');
plotMDRDiffOnly('PIComposite.mat', [-15 20], true, 'PI');
plotMDRDiffOnly('sstComposite.mat', [-1 2], true, 'SST');
plotMDRDiffOnly('windShearComposite.mat', [-10 10], false, 'Wind Shear');
end

function [] = plotMDRDiffOnly(var, scaleDims, landMask, varName)
if isempty(scaleDims)
    scale = false;
else
    scale = true;
end
eval(['load composites/comboIndex/' var]);
eval(['load composites/ENSO_3.4/' var]);
eval(['load composites/hurricaneFrequency/' var]);

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
title(['Difference ENSO ' varName])
colorbar

subplot(3, 1, 2)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffComboIndex)
if scale == true
    caxis(scaleDims)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference Combo Index ' varName])
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
title(['Difference Hurr ' varName])
colorbar

end


