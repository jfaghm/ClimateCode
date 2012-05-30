function seasonalData = monthlyToSeasonal(monthlyData, dates, seasonMonths, startYear, endYear) 
% MONTHLYTOSEASONAL Converts a monthly data set to seasonal averages
% 
% seasonalData = monthlyToSeasonal(monthlyData, dates, seasonMonths)
% 
% This function converts a data set which has data for each month into a
% data set of seasonal means.
% 
% ------------------------- INPUT -------------------------
% -> monthlyData - A data set which has data for each month of the year.
% 
% -> seasonMonths - 
% 
% ------------------------- OUTPUT ------------------------
% -> seasonalData
% 

% Get starting year and ending year
if nargin < 5
    endYear = floor(dates(end) / 100);
end
if nargin < 4
    startYear = floor(dates(1) / 100);
end
seasonalDates = getSeasonalDates(startYear, endYear, seasonMonths)';

% Check to see that all that data is present for all dates
datesPresent = ismember(seasonalDates, dates);
seasonsPresent = all(datesPresent, 2);

% Assume no middle seasons missing
seasonalDates = seasonalDates(seasonsPresent, :);

% Preallocate the seasonal data matrix
seasonalData = zeros(size(monthlyData, 1), size(monthlyData, 2), size(seasonalDates, 1));

% For each season, get the seasonal average
for i = 1:size(seasonalDates, 1)
    
    currentSeason = monthlyData(:, :, ismember(dates, seasonalDates(i, :)));
    seasonalData(:, :, i) = nanmean(currentSeason, 3);
    
end

end