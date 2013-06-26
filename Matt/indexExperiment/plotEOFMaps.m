function [] = plotEOFMaps()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

basin = {'PacificBasin', 'AtlanticBasin', 'JointBasins'};
sstData = load('/project/expeditions/ClimateCodeMatFiles/flippedSSTAnomalies.mat');

for i = 1:length(basin)
    eof = load(['/project/expeditions/ClimateCodeMatFiles/augOct'...
        basin{i} 'EOFPCs.mat']);
    
    for j = 1:32
        plotEOFHelper(eof.maps{j}, sstData.sstLat, sstData.sstLon, j, basin{i});
    end
    
end
end

function [] = plotEOFHelper(map, lat, lon, i, basin)

switch basin
    case 'PacificBasin'
        latRange = [-6, 36];
        lonRange = [120, 272];
    case 'AtlanticBasin'
        latRange = [0, 40];
        lonRange = [280, 345];
    case 'JointBasins'
        latRange = [0, 40];
        lonRange = [120, 345];
end

lat = lat(lat >= min(latRange) & lat <= max(latRange));
lon = lon(lon >= min(lonRange) & lon <= max(lonRange));

map(map == 0) = NaN;

worldmap(latRange, lonRange);
pcolorm(double(lat), double(lon), map);
colorbar
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15]);
title([basin ' Principal Component ' num2str(i)]);

saveDir = ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/'...
    'results/paperDraft/EOFPrincipalComponents/pcMaps/' basin '/' basin ...
    'PrincipalComponent' num2str(i) '.pdf'];
set(gcf, 'PaperPosition', [0, 0, 8, 11]);
set(gcf, 'PaperSize', [8, 11]);
try
    saveas(gcf, saveDir, 'pdf');
catch x
    disp(x)
    pause
end


end

