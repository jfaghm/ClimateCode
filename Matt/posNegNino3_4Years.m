function [ negYears, posYears, ENSO34] = posNegNino3_4Years( data, startMonth, endMonth, sigma )
%--------------------------Method----------------------------------------
%
%This function normalizes the Nino 3.4 data, and then returns the positive
%years (those that are sigma standard deviations above from the mean), and 
%the negative years (sigma standard deviations below the mean), 
%
%-------------------------Input-------------------------------------------
%
%--->hurricanes - monthly_nino_data.mat data set (can be found in the
%matFiles directory
%--->startMonth - the lower bound for which we average the months for each
%year
%--->endMonth - the upper bound for which we average the months for each
%year
%--->sigma - the threshold for which we choose the positive and negative
%years.
%
%-------------------------Output------------------------------------------
%
%--->negYears - vector containing all negative years (years associated with
%low hurricane activity)
%--->posYears - vector containing all positive years (years associated with
%high hurricane activity)

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

negYears = find(normalizedENSO >= sigma) + baseYear - 1;
posYears = find(normalizedENSO <= -sigma) + baseYear - 1;

end

