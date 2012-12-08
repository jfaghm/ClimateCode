function [F] = sstLonDiffSlideShow()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if matlabpool('size') == 0
    matlabpool open
end

[annualSST,lat, lon] = getAnnualSSTAnomalies(1, 1, 1979, 2010);

annualSSTMat = zeros(size(annualSST, 1), size(annualSST, 2), size(annualSST, 3), 12);

parfor i = 1:12
    annualSSTMat(:, :, :, i) = getAnnualSSTAnomalies(i, i, 1979, 2010);
    [~, maxI(:, i), maxJ(:, i), minI(:, i), minJ(:, i)] = ...
        buildSSTLonDiff(annualSSTMat(:, :, :, i), lat, lon);
end

annualSSTMat(:, :, :, 13) = getAnnualSSTAnomalies(6, 10, 1979, 2010);
[~, maxI(:, 13), maxJ(:, 13), minI(:, 13), minJ(:, 13)] = ...
    buildSSTLonDiff(annualSSTMat(:, :, :, 13), lat, lon);

F = makeSlideShow(maxI, maxJ, minI, minJ, annualSSTMat, lat, lon);

end

function [F] = makeSlideShow(maxI, maxJ, minI, minJ, annualSSTMat, lat, lon)

    
    for month = 1:size(maxI, 2)
        for year = 1:size(maxI, 1)
            plotCurrentBox(lat, lon, maxI(year, month), maxJ(year, month), minI(year, month), ...
                minJ(year, month), annualSSTMat(:, :, year, month), month, year);
            display(['printing ' num2str(month) ', ' num2str(year)]);
            F(month, year) = getframe;
        end
    end
end



function [F] = plotCurrentBox(lat, lon, maxI, maxJ, minI, minJ, sst_a, month, year)

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

load /project/expeditions/lem/ClimateCode/Matt/matFiles/condensedHurDat.mat;

clmo('surface')
clmo('Line')
worldmap([-20 20],[140 -90])
worldmap world
setm(gca,'Origin',[0 180])

pcolorm(double(lat),double(lon),double(sst_a(:,:)))
%geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])

%----------------------------Plot Warm Box---------------------------------
current_lon = lon_region(maxJ);
current_lat = lat_region(maxI);
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
current_lon = lon_region(minJ);
current_lat = lat_region(minI);
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

aso_tcs = getASOTCs(1979, 2010);

title(['SST Warm and Cool Boxes ' months{month} ', ' num2str(years(year)) ', ASO TCs = ' ...
    num2str(aso_tcs(year)) ]);

if(month < 10)
    monthStr = ['0' num2str(month)];
else
    monthStr = num2str(month);
end

saveDir = ['sstLonDiffSlideShow/slide' num2str(years(year)) monthStr '.pdf'];
set(gcf, 'PaperPosition', [0, 0, 8, 11]);
set(gcf, 'PaperSize', [8, 11]);
saveas(gcf, saveDir, 'pdf');

F = getframe;
end











