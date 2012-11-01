clear 
%---------------------Get Lat, Lon, and Dates---------------------------
%These latitutudes, longitudes, and dates apply to all variables unless
%otherwise noted, i.e. they are on the same spatial and temporal ranges.
lat = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lat');
lon = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'lon');
levels = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'lev') * .01;
times = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');
addpath('/project/expeditions/lem/ClimateCode/Matt/');
dates = zeros(length(times), 4);
for i = 1:length(times)
    dates(i, :) = hoursToDate(times(i), 1, 1, 1979);
end
%-------------------SST-------------------------------------------------
sst = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var34');
sst = permute(sst, [2, 1, 3]);
disp('done with SST');
%------------------PI---------------------------------------------------
%Potential Intensity is very time consuming to compute, so it has been
%saved in the matfiles folder already.
load /project/expeditions/lem/ClimateCode/Matt/matFiles/PI3dMatrix.mat;
disp('done with PI');
%------------------Central Pressure---------------------------------
pressure = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'var134');
pressure = permute(pressure, [2, 1, 3]);
disp('done with central pressure');
%------------------Wind Shear---------------------------------------
uWind = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var131');
vWind = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var132');
windShear = sqrt(squeeze(uWind(:, :, levels == 200, :) - uWind(:, :, levels == 850, :)).^2) + ...
    sqrt(squeeze(vWind(:, :, levels == 200, :) - vWind(:,:,levels == 850, :)).^2);
windShear = permute(windShear, [2, 1, 3]);
disp('done with wind shear');
%--------------------Wind Field----------------------------------------
windField = permute(sqrt(uWind.^2 + vWind.^2), [2, 1, 4, 3]);
windField850 = windField(:, :, :, levels == 850);
windField500 = windField(:, :, :, levels == 500);
windField200 = windField(:, :, :, levels == 200);
%-----------------Relative Humidity---------------------------------
rh = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var157');
rh = permute(rh, [2, 1, 4, 3]);
relHumid850 = rh(:, :, :, levels == 850);
relHumid500 = rh(:, :, :, levels == 500);
relHumid850_500Diff = rh(:, :, :, levels == 850) - rh(:, :, :, levels == 500);
disp('done with relative humidity');
%----------------Geopotential Height--------------------------------
gp = ncread('/project/expeditions/lem/data/pressureLevelData_1979-present.nc', 'var129');
gp = permute(gp, [2, 1, 4, 3]);
geoPotential500 = gp(:, :, :, levels == 500);
geoPotential200 = gp(:, :, :, levels == 200);
geoPotential500_1000Diff = gp(:, :, :, levels == 500) - gp(:, :, :, levels == 1000);
disp('done with geopotential height');
%----------------PrecipitableWater---------------------------------
precipitableWater = ncread('/project/expeditions/lem/data/precipitableWater.nc', 'var137');
precipitableWater = permute(precipitableWater, [2, 1, 3]);
disp('done with precipitable water');
%----------------Saturation Deficit--------------------------------
satDefLat = ncread('/project/expeditions/jfagh/data/era_int_1979/pres_level/sat_def_1979-2011.nc', 'lat');
satDefLon = ncread('/project/expeditions/jfagh/data/era_int_1979/pres_level/sat_def_1979-2011.nc', 'lon');
time = ncread('/project/expeditions/jfagh/data/era_int_1979/pres_level/sat_def_1979-2011.nc', 'time');
satDefDates = zeros(length(time), 4);
satDefDates(:, 2) = mod(time, 100);
satDefDates(:, 3) = mod(floor(time/100), 100);
satDefDates(:, 4) = floor(time/10000);
satDef = ncread('/project/expeditions/jfagh/data/era_int_1979/pres_level/sat_def_1979-2011.nc', 'sat_def');
lastYear = find(satDefDates(:, 4) == 2010);

satDef = satDef(:, :, :, 1:lastYear(end));
satDefLevels = ncread('/project/expeditions/jfagh/data/era_int_1979/pres_level/sat_def_1979-2011.nc', 'lev') * .01;
satDef = permute(satDef, [2, 1, 4, 3]);
satDef850 = satDef(:, :, :, satDefLevels == 850);
satDef500 = satDef(:, :, :, satDefLevels == 500);
satDef500_850Avg = nanmean(satDef(:, :, :, satDefLevels >= 500 & satDefLevels <= 850), 4);
disp('done with saturation deficit');
load ../matFiles/GPIData.mat

load ../matFiles/tropicalSSTDeviations.mat;
%-------------------Save Data--------------------------------------------
save('/project/expeditions/lem/ClimateCode/Matt/matFiles/compositeVariables.mat', ...
    'lat', 'lon', 'dates', 'sst', 'pressure', 'windShear', 'relHumid850', ...
    'relHumid500', 'relHumid850_500Diff', 'geoPotential200', 'geoPotential500', 'geoPotential500_1000Diff', ...
    'precipitableWater', 'satDefLat', 'satDefLon', 'satDefDates', 'satDef500',...
    'satDefLevels', 'satDef850', 'PI', 'satDef500_850Avg', 'gpiMat', ...
    'sstDates', 'sstDeviations', 'sstLat', 'sstLon', 'windField200', ...
    'windField500', 'windField850');















