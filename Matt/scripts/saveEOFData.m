clear
addpath('/project/expeditions/lem/ClimateCode/Matt');
load /project/expeditions/ClimateCodeMatFiles/flippedSSTAnomalies.mat;
pacificBasin = sst(sstLat >= -6 & sstLat <= 36, sstLon >= 120 & sstLon <= 272, :);

year = 1;
augOctPacificBasin = zeros(size(pacificBasin, 1), size(pacificBasin, 2), size(pacificBasin, 3)/12);
marOctPacificBasin = zeros(size(augOctPacificBasin));
previous = zeros(size(pacificBasin, 1), size(pacificBasin, 2));
for i = 1:12:size(pacificBasin, 3);
    augOctPacificBasin(:, :, year) = nanmean(pacificBasin(:, :, i+7:i+9), 3);
    marOctPacificBasin(:, :, year) = nanmean(pacificBasin(:, :, i+2:i+9), 3);
    year = year+1;
    
end

maps = cell(32, 1);
PCs = zeros(32, 32);
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(augOctPacificBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/augOctPacificBasinEOFPCs.mat', ...
    'maps', 'PCs');
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(marOctPacificBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/marOctPacificBasinEOFPCs.mat', ...
    'maps', 'PCs');
%% 
clear
load /project/expeditions/ClimateCodeMatFiles/flippedSSTAnomalies.mat;
atlanticBasin = sst(sstLat >= 0 & sstLat <= 40, sstLon >= 280 & sstLon <= 345, :);
year = 1;
for i = 1:12:size(atlanticBasin, 3)
    augOctAtlanticBasin(:, :, year) = nanmean(atlanticBasin(:, :, i+7:i+9), 3);
    marOctAtlanticBasin(:, :, year) = nanmean(atlanticBasin(:, :, i+2:i+9), 3);
    year = year+1;
end

maps = cell(32, 1);
PCs = zeros(32, 32);
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(augOctAtlanticBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/augOctAtlanticBasinEOFPCs.mat', ...
    'maps', 'PCs');
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(marOctAtlanticBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/marOctAtlanticBasinEOFPCs.mat', ...
    'maps', 'PCs');

%%
clear
load /project/expeditions/ClimateCodeMatFiles/flippedSSTAnomalies.mat;
jointBasins = sst(sstLat >= -6 & sstLat <= 40, sstLon >= 120 & sstLon <= 345, :);
year = 1;
for i = 1:12:size(jointBasins, 3)
    augOctJointBasins(:, :, year) = nanmean(jointBasins(:, :, i+7:i+9), 3);
    marOctJointBasins(:, :, year) = nanmean(jointBasins(:, :, i+2:i+9), 3);
    year = year+1;
end

maps = cell(32, 1);
PCs = zeros(32, 32);
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(augOctJointBasins, i);
end
save('/project/expeditions/ClimateCodeMatFiles/augOctJointBasinsEOFPCs.mat', ...
    'maps', 'PCs');
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(marOctJointBasins, i);
end
save('/project/expeditions/ClimateCodeMatFiles/marOctJointBasinsEOFPCs.mat', ...
    'maps', 'PCs');


%% -----------------------Detrended Pacific EOF-------------------------

clear
load /project/expeditions/ClimateCodeMatFiles/detrendedSSTAnomalies.mat;
addpath('/project/expeditions/lem/ClimateCode/Matt/');
pacificBasin = sst(sstLat >= -6 & sstLat <= 36, sstLon >= 120 & sstLon <= 272, :);
year = 1;
augOctPacificBasin = zeros(size(pacificBasin, 1), size(pacificBasin, 2), size(pacificBasin, 3)/12);
marOctPacificBasin = zeros(size(augOctPacificBasin));
previous = zeros(size(pacificBasin, 1), size(pacificBasin, 2));
for i = 1:12:size(pacificBasin, 3);
    augOctPacificBasin(:, :, year) = nanmean(pacificBasin(:, :, i+7:i+9), 3);
    marOctPacificBasin(:, :, year) = nanmean(pacificBasin(:, :, i+2:i+9), 3);
    year = year+1;
end

maps = cell(32, 1);
PCs = zeros(32, 32);
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(augOctPacificBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/detrendedAugOctPacificBasinEOFPCs.mat', ...
    'maps', 'PCs');
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(marOctPacificBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/detrendedMarOctPacificBasinEOFPCs.mat', ...
    'maps', 'PCs');


%% -------------------Detrended Atlantic EOF-----------------------------
clear
load /project/expeditions/ClimateCodeMatFiles/detrendedSSTAnomalies.mat
atlanticBasin = sst(sstLat >= 0 & sstLat <= 40, sstLon >= 280 & sstLon <= 345, :);
year = 1;
for i = 1:12:size(atlanticBasin, 3)
    augOctAtlanticBasin(:, :, year) = nanmean(atlanticBasin(:, :, i+7:i+9), 3);
    marOctAtlanticBasin(:, :, year) = nanmean(atlanticBasin(:, :, i+2:i+9), 3);
    year = year+1;
end

maps = cell(32, 1);
PCs = zeros(32, 32);
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(augOctAtlanticBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/detrendedAugOctAtlanticBasinEOFPCs.mat', ...
    'maps', 'PCs');
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(marOctAtlanticBasin, i);
end
save('/project/expeditions/ClimateCodeMatFiles/detrendedMarOctAtlanticBasinEOFPCs.mat', ...
    'maps', 'PCs');

%% -------------------Detrended Joint Basins EOF--------------------------
clear
load /project/expeditions/ClimateCodeMatFiles/detrendedSSTAnomalies.mat
jointBasins = sst(sstLat >= -6 & sstLat <= 40, sstLon >= 120 & sstLon <= 345, :);
year = 1;
for i = 1:12:size(jointBasins, 3)
    augOctJointBasins(:, :, year) = nanmean(jointBasins(:, :, i+7:i+9), 3);
    marOctJointBasins(:, :, year) = nanmean(jointBasins(:, :, i+2:i+9), 3);
    year = year+1;
end

maps = cell(32, 1);
PCs = zeros(32, 32);
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(augOctJointBasins, i);
end
save('/project/expeditions/ClimateCodeMatFiles/detrendedAugOctJointBasinsEOFPCs.mat', ...
    'maps', 'PCs');
for i = 1:32
    [maps{i}, PCs(:, i)] = eof(marOctJointBasins, i);
end
save('/project/expeditions/ClimateCodeMatFiles/detrendedMarOctJointBasinsEOFPCs.mat', ...
    'maps', 'PCs');




