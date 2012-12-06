function [annualSST, sstLat, sstLon] = getAnnualSSTAnomalies(startMonth, endMonth, startYear, endYear)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

totalYears = endYear - startYear + 1;
load /project/expeditions/ClimateCodeMatFiles/ersstv3Anom.mat
sst = sst(:, :, sstDates(:, 4) >= startYear & sstDates(:, 4) <= endYear);

annualSST = zeros(size(sst, 1), size(sst, 2), totalYears);
year = 1;
for i = 1:12:totalYears * 12
    annualSST(:, :, year) = nanmean(sst(:, :, i+startMonth-1:i+endMonth-1), 3);
    year = year+1;
end



end

