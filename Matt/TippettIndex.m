%This script calculates the gensesis index that is proposed in the Tippett,
%Camargo, and Sobel Paper.  The index gives the expected number of tropical
%cyclone genesis events per month in a 40-year period.

tic
if ~exist('dataLoaded', 'var') || ~dataLoaded
    dataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
    sstPath = '/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc';
    windPath = '/project/expeditions/lem/data/windSpeeds_1979_2010.nc';
    
    sst = ncread(sstPath, 'var34') - 273.15;
    lat = ncread(sstPath, 'lat');
    lon = ncread(sstPath, 'lon');
    
    relVorticity = ncread(dataPath, 'var138');
    levels = ncread(dataPath, 'lev') * .01;
    relVorticity = squeeze(relVorticity(:, :, levels(:) == 850, :));
    
    relHum = ncread(dataPath, 'var157');
    relHum = squeeze(relHum(:, :, levels(:) == 600, :));
    
    uWindSpeeds = ncread(windPath, 'var131');
    vWindSpeeds = ncread(windPath, 'var132');
    windLevels = ncread(windPath, 'lev');
    windLevels = windLevels*.01;
    %wind shear = sqrt(u200-u850)^2+(v200-v850)^2
    windShear = sqrt((uWindSpeeds(:, :, windLevels(:) == 200, :) - uWindSpeeds(:, :, windLevels(:) == 850, :)).^2);
    windShear = windShear + sqrt((vWindSpeeds(:, :, windLevels(:) == 200, :) - vWindSpeeds(:,:,windLevels == 850, :)).^2);
    windShear = squeeze(windShear);
    dataLoaded = true;    
end
earthRot = 2*pi/24/60/60;
absVort = relVorticity;
earthVort = 2*earthRot*ones(size(lon, 1), 1) * sin(degtorad(abs(lat)'));

for i = 1:size(relVorticity, 3)
    absVort(:, :, i) = 10^5*(earthVort + relVorticity(:, :, i));
end
absVort(absVort(:) > 3.7) = 3.7;

sstSubset = sst(:,lat(:) <= 20 & lat(:) >= -20 , :);
sstMean = squeeze(nanmean(nanmean(sstSubset, 1), 2)); 
T = zeros(size(sst, 1), size(sst, 2), size(sst, 3));
for i = 1:size(sst, 3)
    T(:, :, i) = sst(:, :, i)-sstMean(i);
end

%These are the constants used, that are described in the Menkes paper.
b = -5.8; %Menkes paper states this should be 5.8, but the TCS paper says it should be negative.
bn = 1.03;
bh = 0.05;
bt = 0.56;
bv = -0.15;

lcl = ones(size(lon, 1), 1) * log10(cos(degtorad(abs(lat'))));
logCosLat = zeros(size(lon, 1), size(lat, 1), size(relHum, 3));
for i = 1:size(windShear, 3)
    logCosLat(:, :,i) = lcl;
end

TCS = exp(b+bn*absVort+bv*windShear+bh*relHum+bt*T+logCosLat);
Tippett = cell(size(TCS, 3), 1);
for i = 1:size(TCS, 3)
    Tippett{i} = TCS(:, :, i)';
end

