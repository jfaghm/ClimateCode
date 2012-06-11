function [ negYears, posYears] = posNegNino3_4Years( data, startMonth, endMonth )
%This function takes in ENSO data, and normalized the data for NINO 3.4.
%It returns a set of positive and negative years that are at least one
%standard deviation away from the mean.

if data(1) < 1979
    data = data(data(:, 1) >= 1979, :);
end

baseYear = data(1);
totalYears = data(end, 1) - data(1, 1);
ENSO34 = zeros(totalYears, 1);

year = 1;
for i = 1:12:totalYears*12
    ENSO34(year) = mean(data(i + startMonth - 1:i+endMonth - 1, 9));
    year = year+1;
end

stdDev = std(ENSO34);
normalizedENSO = (ENSO34 - mean(ENSO34)) ./ stdDev;

posYears = find(normalizedENSO >= 1) + baseYear - 1;
negYears = find(normalizedENSO <= -1) + baseYear - 1;

end

