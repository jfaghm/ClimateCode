function [ negYears, posYears] = ...
    getPositiveAndNegativeYears(hurricanes, sigma)
%--------------------------Method----------------------------------------
%
%This function normalizes the hurricane frequency from the condensedHurDat
%data set, and then returns the positive years (those that are sigma standard
%deviations above from the mean), and the negative years (sigma standard
%deviations below the mean), 
%
%-------------------------Input-------------------------------------------
%
%--->hurricanes - This must be the condensedHurDat.mat data set
%--->sigma - the threshold for which we choose the positive and negative
%years.
%
%-------------------------Output------------------------------------------
%
%--->negYears - vector containing all negative years (years associated with
%low hurricane activity)
%--->posYears - vector containing all positive years (years associated with
%high hurricane activity)

if hurricanes(1) < 1979
    hurricanes = hurricanes(hurricanes(:, 1) >= 1979, :);
end

baseYear = hurricanes(1);
numYears = hurricanes(end, 1) - hurricanes(1, 1) + 1;
hurrFrequency = zeros(numYears, 1);

for i = 1:numYears
   currentHurricanes = hurricanes(hurricanes(:, 1) == baseYear + i-1, :);
   currentHurricanes = currentHurricanes(currentHurricanes(:, 10) >= 0, :);
   hurrFrequency(i) = numelements(currentHurricanes);
end

stdDev = std(hurrFrequency);
normalizedHurr = (hurrFrequency - mean(hurrFrequency)) ./ stdDev;

negYears = find(normalizedHurr <= -sigma) + baseYear - 1;
posYears = find(normalizedHurr >= sigma) + baseYear - 1;

end

