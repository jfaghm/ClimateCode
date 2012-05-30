%This script is used to load the data necessary for running the genesis
%potential index algorithm

tic
if ~exist('dataLoaded', 'var') || ~dataLoaded
    dataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
    windPath = '/project/expeditions/lem/data/windSpeeds_1979_2010.nc';
    
    lat = ncread(dataPath, 'lat');
 
    lon = ncread(dataPath, 'lon');
    
    time = ncread(dataPath, 'time');

    levels = ncread(dataPath, 'lev');
    %change levels from Pa to mb
    levels = levels*.01;
    
    relHumidity = ncread(dataPath, 'var157');
    %only need relative humidity from 700mb
    relHumidity = relHumidity(:, : , levels(:) == 700, :);
    relHumidity = permute(relHumidity, [2 1 4 3]);
    
    
    relVorticity = ncread(dataPath, 'var138');
    %only need vorticity at 850 mb
    relVorticity = relVorticity(:, :, levels(:) == 850, :);
    relVorticity = permute(relVorticity, [2 1 4 3]);
    earthRotation = 2*pi/24/60/60; %rad/sec
    %earth vorticity assumes that degrees are always positive.  i.e. they
    %range from 90 degrees north to 90 degrees south
    absVorticity = zeros(size(relVorticity));
    for i = 1:size(lat, 1)
        for j = 1:size(lon, 1)
            absVorticity(i, j, :) = 2*earthRotation * sin(degtorad(abs(lat(i)))) + relVorticity(i, j,:, :);
        end
    end
    
    uWindSpeeds = ncread(windPath, 'var131');
    vWindSpeeds = ncread(windPath, 'var132');
    windLevels = ncread(windPath, 'lev');
    windLevels = windLevels*.01;
    %wind shear = sqrt(u200-u850)^2+(v200-v850)^2
    vWindShear = sqrt((uWindSpeeds(:, :, windLevels(:) == 200, :) - uWindSpeeds(:, :, windLevels(:) == 850, :)).^2);
    vWindShear = vWindShear + sqrt((vWindSpeeds(:, :, windLevels(:) == 200, :) - vWindSpeeds(:,:,windLevels == 850, :)).^2);
    vWindShear = permute(vWindShear, [2 1 4 3]);
    load PIMaps.mat;
    maxWindSpeeds = zeros(size(absVorticity, 1), size(absVorticity, 2), size(absVorticity, 3));
    for i = 1:size(time, 1)
        maxWindSpeeds(:, :, i) = PIData{i, 1};
    end
    
    dataLoaded = true;
end
tic
GPIData = cell(size(vWindShear, 3), 1);
for currTime = 1:size(absVorticity, 3)
   GPIData{currTime} = parGPI(absVorticity(:, :, currTime), relHumidity(:, :, currTime), maxWindSpeeds(:, :, currTime), vWindShear(:, :, currTime));
    currTime
end
toc

time = toc;
%save('GPIData.mat', 'GPIData', 'time');


