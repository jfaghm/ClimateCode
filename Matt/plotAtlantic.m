function [ ] = plotAtlantic( startMonth, endMonth, landMask, diffVar, varName, diffIndex, diffHurr, var )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

scale1 = [-15 15];
scale2 = [-15 15];

lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
lon(lon > 180) = lon(lon > 180) - 360;
fig(figure(1), 'units', 'inches', 'width', 6, 'height', 10)
months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
subplot(3, 1, 1)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffVar)
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
caxis(scale1)
title([varName ' ' months{startMonth} ' to ' months{endMonth} ' ' var])
colorbar

subplot(3, 1, 2)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffIndex)
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
caxis(scale1)
title(['Index ' months{startMonth} ' to ' months{endMonth} ' ' var])
colorbar

subplot(3, 1, 3)
worldmap([0 45], [-80, -15])
pcolorm(lat, lon, diffHurr)
if landMask == true
    geoshow('landareas.shp', 'FaceColor', [.25 .2 .15])
end
caxis(scale2);
title(['Hurricane Counts ' months{startMonth} ' to ' months{endMonth} ' ' var])
colorbar

end

