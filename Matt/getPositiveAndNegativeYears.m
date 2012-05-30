function [ negYears, posYears, normalizedHurr ] = getPositiveAndNegativeYears(hurricanes)
%This function is used to find the positive and negative years with respect
%to normalized hurricane frequency.
%   This function normalizes the hurricane frequency from the
%   condensedHurDat data set, and then takes the positive years (those that
%   are above one standard deviation from the mean), and the negative years
%   (those that are one standard deviation below the mean.  The two sets of
%   years are returned and used for the getComposites function.

if hurricanes(1) < 1979
    hurricanes = hurricanes(hurricanes(:, 1) >= 1979, :);
end

baseYear = hurricanes(1);
numYears = hurricanes(end, 1) - hurricanes(1, 1) + 1;
hurrFrequency = zeros(numYears, 1);

for i = 1:numYears
   currentHurricanes = hurricanes(hurricanes(:, 1) == baseYear + i-1, :);
   hurrFrequency(i) = numelements(currentHurricanes);
end

stdDev = std(hurrFrequency);
normalizedHurr = (hurrFrequency - mean(hurrFrequency)) ./ stdDev;

negYears = find(normalizedHurr <= -1) + baseYear - 1;
posYears = find(normalizedHurr >= .678) + baseYear - 1;

end

