load /project/expeditions/lem/ClimateCode/Matt/matFiles/flippedSSTAnomalies.mat

%Get Aug-Oct annual means
year = 1;
for i = 1:12:size(sst, 3)
    annualSST(:, :, year) = nanmean(sst(:, :, i+7:i+9), 3);
    year = year+1;
end

sstAtlanticBasin = annualSST(sstLat >= 0 & sstLat <= 40, sstLon >= 280 & sstLon <= 345, :);
save('../matFiles/sstAtlanticBasinAugOct.mat', 'sstAtlanticBasin', 'sstLat', 'sstLon');

sstPacificBasin = annualSST(sstLat >= -6 & sstLat <= 36, sstLon >= 130 & sstLon <= 272, :);
save('../matFiles/sstPacificBasinAugOct.mat', 'sstPacificBasin', 'sstLat', 'sstLon');

sstJointBasins = annualSST(sstLat >= 0 & sstLat <= 40, sstLon >= 130 & sstLon <= 345, :);
save('../matFiles/sstJointBasinsAugOct.mat', 'sstJointBasins', 'sstLat', 'sstLon');

clear
load /project/expeditions/lem/ClimateCode/Matt/matFiles/flippedSSTAnomalies.mat

%Get March-Oct annual means
year = 1;
for i = 1:12:size(sst, 3)
    annualSST(:, :, year) = nanmean(sst(:, :, i+2:i+9), 3);
    year = year+1;
end

sstAtlanticBasin = annualSST(sstLat >= 0 & sstLat <= 40, sstLon >= 280 & sstLon <= 345, :);
save('../matFiles/sstAtlanticBasinMarOct.mat', 'sstAtlanticBasin', 'sstLat', 'sstLon');

sstPacificBasin = annualSST(sstLat >= -6 & sstLat <= 36, sstLon >= 130 & sstLon <= 272, :);
save('../matFiles/sstPacificBasinMarOct.mat', 'sstPacificBasin', 'sstLat', 'sstLon');

sstJointBasins = annualSST(sstLat >= 0 & sstLat <= 40, sstLon >= 130 & sstLon <= 345, :);
save('../matFiles/sstJointBasinsMarOct.mat', 'sstJointBasins', 'sstLat', 'sstLon');





