%This script is used to calculate the potential intensity composites for
%positive and negative years of ENSO.  Each year averages the PI's from
%Aug-Oct, and the the averages are then again averaged into one map.
%Finally, we take the difference of the positive from the negative map to
%see where they differ.
if ~exist('dataLoaded', 'var') || dataLoaded == false
    load('/project/expeditions/lem/hurricanerepo/Matt/PIMaps.mat');
    dataLoaded = true;
end

positiveYears = [1997; 1982; 1987; 2002; 2009];
negativeYears = [2010; 1988; 1999; 1998; 2007];

posComposites = zeros(256, 512, 15);
negComposites = zeros(256, 512, 15);

%The times are in hours from January 1, 1979, so we call the hoursToDate
%function in order to change them into a hour/day/month/year form.
dates = zeros(size(time, 1), 4);
for i = 1:size(time, 1)
   dates(i, :) = hoursToDate(time(i), 1, 1, 1979);
end
year = 1;
for i = 1:3:15
    [~, posIndex] = max(dates(:, 4) == positiveYears(year));
    [~, negIndex] = max(dates(:, 4) == negativeYears(year));
    posComposites(:, :, i) = PIData{posIndex+7, 1};
    posComposites(:, :, i+1) = PIData{posIndex+8, 1};
    posComposites(:, :, i+2) = PIData{posIndex+9, 1};
    negComposites(:, :, i) = PIData{negIndex+7, 1};
    negComposites(:, :, i+1) = PIData{negIndex+8, 1};
    negComposites(:, :, i+2) = PIData{negIndex+9, 1};
    year = year+1;
end


posMeanComposites = nanmean(posComposites, 3);
negMeanComposites = nanmean(negComposites, 3);
differenceOfComposites = negMeanComposites - posMeanComposites;
