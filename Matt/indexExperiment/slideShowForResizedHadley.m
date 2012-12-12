
clear
load /project/expeditions/ClimateCodeMatFiles/hadleySST.mat
f = @(x) mean2(x.data);
%% 

hadleySST = convtemp(hadleySST, 'K', 'C');

resizedHadley = zeros(90, 180, size(hadleySST, 3));
parfor i = 1:size(hadleySST, 3)
    resizedHadley(:, :, i) = blockproc(hadleySST(:, :, i), [2, 2], f);
    disp(['iteration = ' num2str(i)])
end

count = 1;
for i = 1:2:length(hGridInfo.lats)
    resizedLat(count) = mean(hGridInfo.lats(i:i+1));
    count = count+1;
end

count = 1;
for i = 1:2:length(hGridInfo.lons)
    resizedLon(count) = mean(hGridInfo.lons(i:i+1));
    count = count+1;
end

%% 
sstLonDiffSlideShow(6, 10, 1979, 2010, resizedHadley, resizedLat, resizedLon, ...
    hadleyDates, 'HadleyTwoDegree');

%% Two Degree
[anomalies, anomalyDates] = getMonthlyAnomalies(resizedHadley, hadleyDates, 1948, 2010);
annualSST = getAnnualSSTAnomalies(6, 10, 1979, 2010, anomalies, anomalyDates);
index1 = buildSSTLonDiff(annualSST, resizedLat, resizedLon);
load('/project/expeditions/ClimateCodeMatFiles/asoHurricaneStats.mat', 'aso_tcs');
corr(index1', aso_tcs)

%% One Degree

sstLonDiffSlideShow(6, 10, 1979, 2010, hadleySST, hGridInfo.lats, hGridInfo.lons, ...
    hadleyDates, 'HadleyOneDegree');

[anomalies, anomalyDates] = getMonthlyAnomalies(hadleySST, hadleyDates, 1948, 2010);
annualSST = getAnnualSSTAnomalies(6, 10, 1979, 2010, anomalies, anomalyDates);
index2 = buildSSTLonDiff(annualSST, hGridInfo.lats, hGridInfo.lons);
corr(index2, aso_tcs)

%% ERSSTV3
load /project/expeditions/ClimateCodeMatFiles/ersstv3_1854_2012_raw.mat
[anomalies, anomalyDates] = getMonthlyAnomalies(sst, sstDates, 1948, 2010);
[annualSST] = getAnnualSSTAnomalies(6, 10, 1979, 2010, anomalies, anomalyDates);
index3 = buildSSTLonDiff(annualSST, sstLat, sstLon);
