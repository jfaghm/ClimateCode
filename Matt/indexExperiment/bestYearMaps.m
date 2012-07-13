load /project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/pressureAnomalies.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/olrAnomalies.mat;

posYears = [1982;1983;1992];
negYears = [2003;2005;2010];
olrMat = zeros(size(olr, 1), size(olr, 2), 3*8);

sstMat = zeros(size(sst, 1), size(sst, 2), 3);
negSSTMat = zeros(size(sst, 1), size(sst, 2), 3);
pressureMat = zeros(size(pressure, 1), size(pressure, 2), 3*8);
for i = 1:3
    indices = find(sstDates(:, 4) == posYears(i));
    sstMat(:, :, i) = nanmean(sst(:, :, indices(3):indices(10)), 3);
    indices = find(sstDates(:, 4) == negYears(i));
    negSSTMat(:, :, i) = nanmean(sst(:, :, indices(3):indices(10)), 3);
end

figure(1)
subplot(3, 1, 1)
imagesc(sstMat(:, :, 1));
subplot(3, 1, 2)
imagesc(sstMat(:, :, 2));
subplot(3, 1, 3);
imagesc(sstMat(:, :, 3));


figure(2)
subplot(3, 1, 1)
imagesc(negSSTMat(:, :, 1));
subplot(3, 1, 2)
imagesc(negSSTMat(:, :, 2));
subplot(3, 1, 3);
imagesc(negSSTMat(:, :, 3));
