function [ negYears, posYears] = posNegNino3_4Years( data )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if data(1) < 1979
    data = data(data(:, 1) >= 1979, :);
end

baseYear = data(1);
totalYears = data(end, 1) - data(1, 1);
ENSO34 = zeros(totalYears, 1);

year = 1;
for i = 1:12:totalYears*12
    ENSO34(year) = mean(data(i:i+11, 9));
    year = year+1;
end

stdDev = std(ENSO34);
normalizedENSO = (ENSO34 - mean(ENSO34)) ./ stdDev;

posYears = find(normalizedENSO >= 1) + baseYear - 1;
negYears = find(normalizedENSO <= -1.105) + baseYear - 1;

end

