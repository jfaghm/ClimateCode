addpath('../indexExperiment');
startMonth = 3;

sstMaxLon = buildIndexVariations(1, startMonth, 10);

sstBoxPress = buildIndexVariations(36, startMonth, 10);

sstBoxOLR = buildIndexVariations(37, startMonth, 10);

minPressureLon = buildIndexVariations(38, startMonth, 10);

sstLonDiff = buildIndexVariations(39, startMonth, 10);%, 0, 10, 130 272);

data_path= '/Volumes/James@MSI/ClimateCodeMatFiles/';

%data_path = '../matFiles/'; %use this path when running from MSI

data = strcat(data_path,'asoHurricaneStats.mat')
load(data);

indices = [sstMaxLon, sstBoxPress, sstBoxOLR, minPressureLon, sstLonDiff];

%{
k = 4;
ccTemp(1) = kfoldCrossValidate(indices, aso_tcs, k);
ccTemp(2) = kfoldCrossValidate(indices, aso_pdi, k);
ccTemp(3) = kfoldCrossValidate(indices, aso_major_hurricanes, k);
ccTemp(4) = kfoldCrossValidate(indices, aso_ntc, k);
ccTemp(5) = kfoldCrossValidate(indices, aso_ace, k);
%}

%Add all of the Atlantic SST Boxes to the indices matrix
%------------AugOct SSTAnomalies
load ../matFiles/flippedSSTAnomalies.mat
load ../matFiles/augOctBestSSTAnomalyBoxes.mat
sstLon(sstLon >= 180) = sstLon(sstLon >= 180) - 360;
startMonth = 8;
endMonth = 10;
lat = sstLat;
lon = sstLon;
data = sst;
for i = 1:108
    atlBox = getAtlanticSSTBox(data, startMonth, endMonth, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), sortedAtlCorr(i, 5));
    if(any(isnan(atlBox)))
        continue
    end
    indices = [indices, atlBox];
end
%}

%------------May-July sstAnomalies-----------------------
load ../matFiles/flippedSSTAnomalies.mat
%sstLon(sstLon >= 180) = sstLon(sstLon >= 180) - 360;
load ../matFiles/mayJulBestSSTAnomalyBoxes.mat
startMonth = 5;
endMonth = 7;
lat = sstLat;
lon = sstLon;
lon(lon >= 180) = lon(lon >= 180) - 360;
data = sst;
for i = 1:108
    atlBox = getAtlanticSSTBox(data, startMonth, endMonth, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), sortedAtlCorr(i, 5));
    if(any(isnan(atlBox)))
        continue
    end
    indices = [indices, atlBox];
end
%}
%------------AugOct Relative SST-----------------------
load ../matFiles/tropicalSSTDeviations.mat
sstLon(sstLon >= 180) = sstLon(sstLon >= 180) - 360;
load ../matFiles/augOctBestRelativeSSTBoxes.mat
startMonth = 8;
endMonth = 10;
lat = sstLat;
lon = sstLon;
lon(lon >= 180) = lon(lon >= 180) - 360;
data = sstDeviations;
for i = 1:108
    atlBox = getAtlanticSSTBox(data, startMonth, endMonth, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), sortedAtlCorr(i, 5));
    if(any(isnan(atlBox)))
        continue
    end
    indices = [indices, atlBox];
end

%------------------MayJulRelative SST
load ../matFiles/tropicalSSTDeviations.mat
sstLon(sstLon >= 180) = sstLon(sstLon >= 180) - 360;
load ../matFiles/mayJulBestRelativeSSTBoxes.mat
startMonth = 5;
endMonth = 7;
lat = sstLat;
lon = sstLon;
lon(lon >= 180) = lon(lon >= 180) - 360;
data = sstDeviations;
for i = 1:108
    atlBox = getAtlanticSSTBox(data, startMonth, endMonth, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), sortedAtlCorr(i, 5));
    if(any(isnan(atlBox)))
        continue
    end
    indices = [indices, atlBox];
end

%----------------AugOct GPI
load ../matFiles/GPIData.mat
%sstLon(sstLon >= 180) = sstLon(sstLon >= 180) - 360;
load ../matFiles/augOctBestGPIBoxes.mat
startMonth = 8;
endMonth = 10;
lon(lon >= 180) = lon(lon >= 180) - 360;
data = gpiMat;
for i = 1:108
    atlBox = getAtlanticSSTBox(data, startMonth, endMonth, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), sortedAtlCorr(i, 5));
    if(any(isnan(atlBox)))
        continue
    end
    indices = [indices, atlBox];
end

%----------------MayJul GPI
load ../matFiles/GPIData.mat
%sstLon(sstLon >= 180) = sstLon(sstLon >= 180) - 360;
load ../matFiles/mayJulBestGPIBoxes.mat
startMonth = 5;
endMonth = 7;
lon(lon >= 180) = lon(lon >= 180) - 360;
data = gpiMat;
for i = 1:108
    atlBox = getAtlanticSSTBox(data, startMonth, endMonth, lat, lon, ...
        sortedAtlCorr(i, 2), sortedAtlCorr(i, 3), sortedAtlCorr(i, 4), sortedAtlCorr(i, 5));
    if(any(isnan(atlBox)))
        continue
    end
    indices = [indices, atlBox];
end


[B, fitInfo] = lasso(indices, aso_tcs);
m = find(min(fitInfo.MSE));
prediction = indices * B(:, m);
cc = corr(prediction, aso_tcs);

