%This script is used to load the data necessary to compute the convective
%yearly gensis potential described in the menkes paper.
if ~exist('dataLoaded', 'var') || dataLoaded == false
   dataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
   
   lat = ncread(dataPath, 'lat');
   lon = ncread(dataPath, 'lon');
   levels = ncread(dataPath, 'lev') * .01;
   time = ncread(dataPath, 'time');
   
   relVort = ncread(dataPath, 'var138');
   relVort = squeeze(relVort(:, :, levels(:) == 925, :));
   
   uWindSpeeds = ncread(dataPath, 'var131');
   vWindSpeeds = ncread(dataPath, 'var132');
   %wind shear = sqrt(u200-u850)^2+(v200-v850)^2
   windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
   windShear = windShear + sqrt((vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels(:) == 850, :)).^2);
   windShear = squeeze(windShear) ./ 750;
    
   convPrec = ncread('/project/expeditions/lem/data/convectivePrecip.nc', 'var143');
   
   dataLoaded = true; 
end

earthRot = 2*pi/24/60/60;
cp = 2*earthRot*ones(size(lon, 1), 1) * sin(degtorad(lat'));
corrParam = zeros(size(lon, 1), size(lat, 1), size(relVort, 3));
for i = 1:size(relVort, 3)
    corrParam(:, :, i) = cp;
end

f = abs(corrParam);
Iv = (relVort .* (corrParam ./ f)) + 5;

Is = (windShear + 3).^-1;

P0 = 3; %taken from menkes paper on the last page.
k = 2;
CYGPData = f.*Iv.*Is.*(k*(convPrec - P0));
CYGPData = squeeze(mat2cell(CYGPData, 512, 256, 1*ones(1, 384)));
CYGPData = cellfun(@transpose, CYGPData, 'UniformOutput', false);