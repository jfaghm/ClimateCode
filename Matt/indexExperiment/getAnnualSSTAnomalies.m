function [annualSST, sstLat, sstLon] = getAnnualSSTAnomalies(startMonth, ...
    endMonth, startYear, endYear, relativeSST)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

totalYears = endYear - startYear + 1;

%load /project/expeditions/ClimateCodeMatFiles/ersstv3Anomalies_1979_2010.mat

%load /project/expeditions/ClimateCodeMatFiles/ersstv3Anomalies_1948_2012.mat

load /project/expeditions/ClimateCodeMatFiles/ersstv3Anom.mat

sst = sst(:, :, sstDates(:, 4) >= startYear & sstDates(:, 4) <= endYear);

if nargin > 4 && relativeSST == true
   tropicalSST = sst(sstLat > -30 & sstLat < 30, :, :);
   tropicalSST = nanmean(nanmean(tropicalSST, 1), 2);
   tropicalSST = repmat(tropicalSST, [size(sst, 1), size(sst, 2), 1]);
   sst = sst - tropicalSST;
end

annualSST = zeros(size(sst, 1), size(sst, 2), totalYears);
year = 1;
for i = 1:12:totalYears * 12
    annualSST(:, :, year) = nanmean(sst(:, :, i+startMonth-1:i+endMonth-1), 3);
    year = year+1;
end



end

