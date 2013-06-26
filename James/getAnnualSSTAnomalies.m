function annualSST = getAnnualSSTAnomalies(startMonth, ...
    endMonth, startYear, endYear, sst, sstDates)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

totalYears = endYear - startYear + 1;

sst = sst(:, :, sstDates(:, 2) >= startYear & sstDates(:, 2) <= endYear);

annualSST = zeros(size(sst, 1), size(sst, 2), totalYears);
year = 1;
for i = 1:12:totalYears * 12
    annualSST(:, :, year) = nanmean(sst(:, :, i+startMonth-1:i+endMonth-1), 3);
    year = year+1;
end



end

