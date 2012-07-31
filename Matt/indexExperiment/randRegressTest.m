
function [] = randRegressTest(trials)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

sstIndex = buildIndex4(1, 3, 10);
load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;

correlations = zeros(trials, 1);
for i = 1:trials
    r2 = aso_tcs(randperm(32));
    correlations(i) = corr(regressHelper(sstIndex, r2), r2);
    
end

hist(correlations)

end

function yVals = regressHelper(x, y)
    beta = polyfit(x, y, 1);
    yVals = x * beta(1) + beta(1);
end

