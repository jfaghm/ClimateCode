pressureDataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
sstDataPath = '/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc';

%Read in the data
if ~exist('dataLoaded', 'var') || dataLoaded == false
   lat = ncread(pressureDataPath, 'lat');
   lon = ncread(pressureDataPath, 'lon');
   time = ncread(pressureDataPath, 'time');
   lev = ncread(pressureDataPath, 'lev') * .01;
   [levels, sortedIndices] = sort(lev, 'descend');
   temps = ncread(pressureDataPath, 'var130') - 273.15;
   temps = temps(:, :, sortedIndices, :);
   specificHumidity = ncread(pressureDataPath, 'var133');
   specificHumidity = specificHumidity(:, :, sortedIndices, :);
   mixingRatio = specificHumidity ./ (1 - specificHumidity);
   sst = ncread(sstDataPath, 'var34') - 273.15;
   centralPressure = ncread(sstDataPath, 'var134') * .01;
   dataLoaded = true;
end

%Open up the matlabpool so that the parfor runs in parallel
if matlabpool('size') == 0
    matlabpool open
end

tic
PIData = cell(size(time, 1), 1);
parfor currTime = 1:size(time, 1)
    for i = 1:size(sst, 1)
        vMaxRow = zeros(1, size(sst, 2));
        for j = 1:size(sst, 2)
            currSST = sst(i, j, currTime);
            pres = centralPressure(i, j, currTime);
            t = squeeze(temps(i, j, :, currTime));
            mr = squeeze(mixingRatio(i, j, :, currTime));
            [~,vMax, ~, ifl] = mpikerry(currSST, pres, levels, t, mr);
            if ifl == 2
                error('mpikerry failed');
            end
            vMaxRow(1, j) = vMax;
        end
        PIData{currTime}(i, :) = vMaxRow;
        i
    end
end
computeTime = toc;
save('newPIData.mat', 'PIData', 'computeTime');

