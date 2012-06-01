%This script calculates the gensesis index that is proposed in the Tippett,
%Camargo, and Sobel Paper.  The index gives the expected number of tropical
%cyclone genesis events per month in a 40-year period.  The output of this
%script is a cell array where each cell corresponds to a time with respect
%to the times that the data was taken at.  Each cell contains a 256x512
%matrix, where each point corresponds to a point on the map, and each
%index in the matrix is the TCS index for that point.  The data used in
%this script was taken from rda.ucar.edu.  Information about the data used
%can be found at http://rda.ucar.edu/datasets/ds627.1/metadata/grib.html

tic
if ~exist('dataLoaded', 'var') || ~dataLoaded
    dataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
    sstPath = '/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc';
    sst = ncread(sstPath, 'var34') - 273.15;
    lat = ncread(sstPath, 'lat');
    lon = ncread(sstPath, 'lon'); 
    levels = ncread(dataPath, 'lev') * .01;
    relVorticity = ncread(dataPath, 'var138');
    relVorticity = squeeze(relVorticity(:, :, levels(:) == 850, :));
    earthVort = repmat(2 * (2*pi/24/60/60) *(ones(512, 1) * sin(degtorad(abs(lat')))), [1 1 size(relVorticity, 3)]);
    absVort = 10^5*(relVorticity + earthVort);
    absVort(absVort(:) > 3.7) = 3.7;
    relHum = ncread(dataPath, 'var157');
    relHum = squeeze(relHum(:, :, levels(:) == 600, :));
    uWindSpeeds = ncread(dataPath, 'var131');
    vWindSpeeds = ncread(dataPath, 'var132');
    %wind shear = sqrt(u200-u850)^2+(v200-v850)^2
    windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
    windShear = windShear + sqrt((vWindSpeeds(:, :,levels(:) == 200, :) - vWindSpeeds(:,:,levels == 850, :)).^2);
    windShear = squeeze(windShear);
    dataLoaded = true;    
end

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
logCosLat = repmat(ones(size(lon, 1), 1) * log10(cos(degtorad(abs(lat')))), [1 1 size(relHum, 3)]);
TCS = exp(b+bn*absVort+bv*windShear+bh*relHum+bt*T+logCosLat);
TCS = squeeze(mat2cell(TCS, 512, 256, 1*ones(1, 384)));
TCS = cellfun(@transpose, TCS, 'UniformOutput', false);
