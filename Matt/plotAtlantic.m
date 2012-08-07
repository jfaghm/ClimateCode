function [ ] = plotAtlantic()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%plotMDRDiffOnly('CentralPressureComposite.mat', [-3 3.5], true, 'Central Pressure');
%plotMDRDiffOnly('PIComposite.mat', [-15 20], true, 'PI');
%plotMDRDiffOnly('sstComposite.mat', [-1 2], true, 'SST');
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

function [] = plotMDRAll(var, scale1, landMask, scale, varName)

eval(['load composites/comboIndex/' var]);
eval(['load composites/ENSO_3.4/' var]);
eval(['load composites/hurricaneFrequency/' var]);

lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
fig(figure(1), 'units', 'inches', 'width', 10, 'height', 11)
subplot(3, 3, 1)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, pMeanENSO)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Positive Years ENSO' var])
colorbar

landMask = true;
subplot(3, 3, 2)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, nMeanENSO)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Negative Years ENSO' var])
colorbar

landMask = true;
subplot(3, 3, 3)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffENSO)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference ENSO' var])
colorbar



subplot(3, 3, 4)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, pMeanComboIndex)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Positive Years Combo Index' var])
colorbar

subplot(3, 3, 5)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, nMeanComboIndex)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Negative Years Combo Index' var])
colorbar
 
landMask = true;
subplot(3, 3, 6)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffComboIndex)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference Combo Index' var])
colorbar

landMask = true;
subplot(3, 3, 7)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, pMeanHurr)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Positve Years Hurr' var])
colorbar

landMask = true;
subplot(3, 3, 8)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, nMeanHurr)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Negative Years Hurr' var])
colorbar

landMask = true;
subplot(3, 3, 9)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffHurr)
if scale == true
    caxis(scale1)
end
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
title(['Difference Hurr' var])
colorbar
end
