%This script is used to load and scale the data correctly in order to
%calculate the genesis potential index.  The output of this script is a
%cell array, where each cell corresponds to a point in time with respect to
%the time vector that is read in line 16.  Each cell within the array
%contains a 256x512 matrix, where each point corresponds a point on the
%map, and represents the genesis potential index at that point.  The data
%that is used in this script was taken from rda.ucar.edu.  Information
%about the variables used can be found at:                       
%        http://rda.ucar.edu/datasets/ds627.1/metadata/grib.html

tic
if ~exist('dataLoaded', 'var') || dataLoaded == false    
    dataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
    lat = ncread(dataPath, 'lat');
    lon = ncread(dataPath, 'lon');
    time = ncread(dataPath, 'time');
    levels = ncread(dataPath, 'lev')*.01;
    relHumidity = ncread(dataPath, 'var157');
    relHumidity = squeeze(relHumidity(:, :, levels(:) == 700, :));
    relVorticity = ncread(dataPath, 'var138');
    relVorticity = squeeze(relVorticity(:, :, levels(:) == 850, :));
    earthVort = repmat(2 * (2*pi/24/60/60) *(ones(512, 1) * sin(degtorad(abs(lat')))), [1 1 size(relVorticity, 3)]);
    absVorticity = relVorticity + earthVort;
    uWindSpeeds = ncread(dataPath, 'var131');
    vWindSpeeds = ncread(dataPath, 'var132');
    vWindShear = sqrt(squeeze(uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
    vWindShear = vWindShear + sqrt(squeeze(vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels == 850, :)).^2);
    load ../matFiles/PIMaps.mat
    %Each cell in the PIData is a 256x512 matrix, so that the data is more
    %readable when you take an image of it, however, the nc files have data
    %in the form 512x256, so here we are transposing each cell and then
    %reshaping it from a cell array to a three dimensional matrix.
    PI = cellfun(@transpose, PIData, 'UniformOutput', false);
    PI = cell2mat(PI(:, 1)');
    PI = reshape(PI, [size(absVorticity, 1) size(absVorticity, 2) size(absVorticity, 3)]);
    dataLoaded = true;
end

gpiMat = ((10^5 *absVorticity).^(3/2)) .* ((relHumidity./50).^3) .* (PI./70).^3 .* ((1+(0.1*vWindShear)).^-2);
gpiMat(imag(gpiMat) ~= 0) = 0;
saveDir = '/project/expeditions/lem/ClimateCode/Matt/matFiles/GPIData.mat';
save(saveDir, 'gpiMat', 'time', 'lat', 'lon');