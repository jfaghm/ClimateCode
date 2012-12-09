function [F] = sstLonDiffSlideShow(sstStartMonth, sstEndMonth, hurricaneStartMonth, ...
    hurricaneEndMonth)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[annualSST, lat, lon] = getAnnualSSTAnomalies(sstStartMonth, sstEndMonth, 1979, 2010);
[~, maxI, maxJ, minI, minJ] = buildSSTLonDiff(annualSST, lat, lon);

for i = 1:length(maxI)
   plotCurrentBox(i) 
end


function [F] = plotCurrentBox(i)

%---------------------------------Adjustable constants---------------------
box_north = 36;
box_south = -6;
box_east = 260;
box_west = 140;
box_row = 5;
box_col = 20;
grid_size = 2;
lon_region = lon(lon >= box_west & lon <= box_east);
lat_region = lat(lat >= box_south & lat <= box_north);

clmo('surface')
clmo('Line')
worldmap([-20 20],[140 -90])
worldmap world
setm(gca,'Origin',[0 180])
pcolorm(double(lat),double(lon),double(annualSST(:,:, i)))
%geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])

%----------------------------Plot Warm Box---------------------------------
current_lon = lon_region(maxJ(i));
current_lat = lat_region(maxI(i));
box_lat1 = current_lat;
box_lat2 = current_lat - (box_row-1) * grid_size;
box_lon1 = current_lon;
box_lon2 = current_lon + (box_col-1) * grid_size; 
[lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
[lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
[lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
[lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
plotm(double(lat1),double(lon1),'r-')
plotm(double(lat2),double(lon2),'r-')
plotm(double(lat3),double(lon3),'r-')
plotm(double(lat4),double(lon4),'r-')

%--------------------------Plot Cold Box-----------------------------------
current_lon = lon_region(minJ(i));
current_lat = lat_region(minI(i));
box_lat1 = current_lat;
box_lat2 = current_lat - (box_row-1) * grid_size;
box_lon1 = current_lon;
box_lon2 = current_lon + (box_col-1) * grid_size; 
[lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
[lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
[lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
[lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
plotm(double(lat1),double(lon1),'b-')
plotm(double(lat2),double(lon2),'b-')
plotm(double(lat3),double(lon3),'b-')
plotm(double(lat4),double(lon4),'b-')
%------------------------Plot Search Space---------------------------------
[lat1, lon1] = track2('rh', box_south, box_west, box_north, box_west);
[lat2, lon2] = track2('rh', box_north, box_west, box_north, box_east);
[lat3, lon3] = track2('rh', box_north, box_east, box_south, box_east);
[lat4, lon4] = track2('rh', box_south, box_west, box_south, box_east);
plotm(double(lat1), double(lon1), 'k--');
plotm(double(lat2), double(lon2), 'k--');
plotm(double(lat3), double(lon3), 'k--');
plotm(double(lat4), double(lon4), 'k--');
caxis([-5 5])
colorbar('EastOutside');

months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',...
    'Nov', 'Dec', 'Jun-Oct'};
years = 1979:2010;

stormData = load('/project/expeditions/ClimateCodeMatFiles/condensedHurDat.mat');

[tcs, tcLats, tcLons] = countStorms(stormData.condensedHurDat(:, [1 2 6 7]), 1979, 2010, hurricaneStartMonth:hurricaneEndMonth, [5 25], [-90 -20]);

%------------------------Plot The Hurricanes-------------------------------
tcLats = tcLats{i}; tcLons = tcLons{i};
for j = 1:length(tcLats)
    plotm(tcLats(j), tcLons(j), '*');
end

plotNinoBox(0, -10, -80, -90);   %Nino 1+2
%plotNinoBox(5, -5, -90, -150);   %Nino 3
%plotNinoBox(5, -5, -120, -170);  %Nino 4
%plotNinoBox(5, -5, -150, -160);  %Nino 3.4
title(['SST Warm and Cool Boxes ' months{sstStartMonth} '-' ...
    months{sstEndMonth} ', ' num2str(years(i)) ', ASO TCs = ' ...
    num2str(tcs(i)) ]);



%{
saveDir = ['sstLonDiffSlideShow/slide' num2str(years(year)) monthStr '.pdf'];
set(gcf, 'PaperPosition', [0, 0, 8, 11]);
set(gcf, 'PaperSize', [8, 11]);
saveas(gcf, saveDir, 'pdf');
%}


F = getframe(gcf);
end
end

function [] = plotNinoBox(box_lat1, box_lat2, box_lon1, box_lon2)
%--------------------Plot Nino 1+2-------------------------------------
[lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
[lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
[lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
[lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
plotm(double(lat1),double(lon1),'k-')
plotm(double(lat2),double(lon2),'k-')
plotm(double(lat3),double(lon3),'k-')
plotm(double(lat4),double(lon4),'k-')
end







