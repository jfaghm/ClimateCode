%This script is used to read in the data and calculate the YGP index
%described in the Menkes paper.
if ~exist('dataLoaded', 'var') || dataLoaded == false
    dataPath = '/project/expeditions/lem/data/pressureLevelData_1979-present.nc';
    
    lat = ncread(dataPath, 'lat');
    lon = ncread(dataPath, 'lon');
    levels = ncread(dataPath, 'lev') * .01;
    relVort = ncread(dataPath, 'var138');
    relVort = squeeze(relVort(:, :, levels(:) == 925, :));
    
    uWindSpeeds = ncread(dataPath, 'var131');
    vWindSpeeds = ncread(dataPath, 'var132');
    %wind shear = sqrt(u200-u850)^2+(v200-v850)^2
    windShear = sqrt((uWindSpeeds(:, :, levels(:) == 200, :) - uWindSpeeds(:, :, levels(:) == 850, :)).^2);
    windShear = windShear + sqrt((vWindSpeeds(:, :, levels(:) == 200, :) - vWindSpeeds(:,:,levels(:) == 850, :)).^2);
    windShear = squeeze(windShear) ./ 750;
    
    relHum = ncread(dataPath, 'var157');
    relHum = relHum(:, :, levels(:) <= 700 & levels(:) >= 500, :);
    
    temps = ncread(dataPath, 'var130');
    temps925 = squeeze(temps(:, :, levels(:) == 925, :));
    temps500 = squeeze(temps(:, :, levels(:) == 500, :));
    
    mixingRatio = ncread(dataPath, 'var133');
    mr925 = squeeze(mixingRatio(:, :, levels(:) == 925, :));
    mr500 = squeeze(mixingRatio(: ,:, levels(:) == 500, :));
    mr925 = 1000*mr925./(1-mr925);
    mr500 = 100*mr500./(1-mr500);
    dataLoaded = true;
end

%%%%%%%%Calculate Equivalent Potential Temperature
Lv = (2.501 - .00237) * 10^6;
Cp = 1005.7;
Rd = 287.04;
Itheta = (temps925 + (Lv/Cp)*mr925)*(1000/925).^(Rd/Cp) - (temps500 + (Lv/Cp)*mr500)*(1000/500).^(Rd/Cp);
Itheta = Itheta ./ 500;
%%%%%%%%%%%%%%%%

earthRot = 2*pi/24/60/60;
cp = 2*earthRot*ones(size(lon, 1), 1) * sin(degtorad(lat'));
corrParam = zeros(size(lon, 1), size(lat, 1), size(relVort, 3));
for i = 1:size(relVort, 3)
    corrParam(:, :, i) = cp;
end

avgRelHum = squeeze(mean(relHum, 3));
Irh = relVort;
for i = 1:size(avgRelHum, 3)
    Irh(:, :, i) = max(min((avgRelHum(:, :, i)-40)./30, 1), 0);
end
f = abs(corrParam);
Iv = (relVort .* (corrParam ./ f)) + 5;
Is = (windShear + 3).^-1;
E = 7.9; %cal/cm^2, this constant is taken from the Menkes paper.



yearlyGP = E*f.*Iv.*Is.*Itheta.*Irh;

yearlyGenesisPotential = cell(size(yearlyGP, 3), 1);
for i = 1:size(yearlyGP, 3)
    yearlyGenesisPotential{i} = yearlyGP(:, :, i);
end

