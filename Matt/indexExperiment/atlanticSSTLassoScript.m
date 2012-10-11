if ~exist('vars', 'var')
    vars = load('/project/expeditions/lem/ClimateCode/Matt/matFiles/compositeVariables.mat');
end
load /project/expeditions/lem/ClimateCode/Matt/matFiles/augOctBestSSTAnomalyBoxes.mat;
load ../matFiles/flippedSSTAnomalies.mat
indices = [];
lon = vars.sstLon;
lon(lon > 180) = lon(lon > 180) - 360;
for i = 1:108
    indices = [indices, getAtlanticSSTBox(sst, 8, 10, vars.sstLat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), ...
        sortedAtlCorr(i, 5))];
end

load ../matFiles/asoHurricaneStats.mat

[B, fitInfo] = lasso(indices, aso_tcs);

nonzero = zeros(1, length(fitInfo.MSE));
for i = 1:length(nonzero)
    nonzero(i) = numelements(find(B(:, i) ~= 0));
end

subplot(2, 1, 1);
plot(fitInfo.Lambda, nonzero);
title('Number of Predictors left in Model vs Lambda');
xlabel('Lambda Value');
ylabel('Number of predictors');

subplot(2, 1, 2);
plot(fitInfo.Lambda, fitInfo.MSE);
title('MSE vs Lambda');
xlabel('Lambda Value');
ylabel('MSE');



