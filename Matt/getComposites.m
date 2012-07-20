function [pMean, nMean, diff] = ...
    getComposites(data, pYears, nYears, dates, startMonth, endMonth)
%This function calculates composites, where we average startMonth to
%endMonth for each year, and then average all of the years together for
%both positve and negative.  We then take the difference of the two sets of
%years.  Posivite years are years that correspond to high hurricane
%activity.

if size(data, 1) > size(data, 2)
    data = permute(data, [2, 1, 3]);
end

posComposites = zeros(size(data, 1), size(data, 2), size(pYears, 1));
negComposites = zeros(size(data, 1), size(data, 2), size(nYears, 1));

count = 1;
%composite the positive years
for i = 1:length(pYears)
    startIndex = find(dates(:, 3) == startMonth&dates(:, 4) == pYears(i));
    endIndex = find(dates(:, 3) == endMonth&dates(:, 4) == pYears(i));
    posComposites(:, :, count) = nanmean(data(:, :, startIndex:endIndex), 3);
    count = count+1;
end
count = 1;
%composite the negative years
for i = 1:length(nYears)
    startIndex = find(dates(:, 3) == startMonth&dates(:, 4) == nYears(i));
    endIndex = find(dates(:, 3) == endMonth&dates(:, 4) == nYears(i));
    negComposites(:,:,count) = nanmean(data(:,:,startIndex:endIndex), 3);
    count = count+1;
end

pMean = nanmean(posComposites, 3);
nMean = nanmean(negComposites, 3);
diff = pMean - nMean;


end

