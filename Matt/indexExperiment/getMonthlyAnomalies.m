function [anomalies, anomalyDates] = getMonthlyAnomalies(data, dates, startYear, endYear)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


years = endYear - startYear + 1;
data = data(:, :, dates(:, 2) >= startYear & dates(:, 2) <= endYear);
anomalyDates = dates(dates(:, 2) >= startYear & dates(:, 2) <= endYear, :);

for i = 1:12
    current = data(:, :, i:12:end);
    means(:, :, i) = nanmean(current, 3);
    stds(:, :, i) = nanstd(current, 1, 3);
end

anomalies = (data - repmat(means, [1, 1, years])) ./ repmat(stds, [1, 1, years]);


end

