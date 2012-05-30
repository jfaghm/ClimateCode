
addpath('../')

load /project/expeditions/haasken/data/ERSST/ersstv3.mat
sstData = erv3sst;
sstDates = erv3Dates;
sstrefvec = [ .5 88 0 ];
START_YEAR = 1971;
END_YEAR = 2010;

load /project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat
storms = condensedHurDat(:, [ 1 2 6 7 ]);
stormCounts = countStorms(storms, START_YEAR, END_YEAR, 8:10, [ 5 20 ], [-45 -15]);

seasonal = monthlyToSeasonal(sstData, sstDates, 5:7, START_YEAR, END_YEAR);
flattened = flattenData(seasonal);

results = randomize(flattened, stormCounts, 100, 'bootstrap', @rowMIC);

for i = 1:100
    heatMap = reshape(results(:, :, i), size(sstData, 1), size(sstData, 2));
    imagesc(heatMap);
    caxis([0 1]);
    colorbar
    pause(1)
end