function [pMean, nMean, diff] = ...
    getComposites(data, pYears, nYears, dates, startMonth, endMonth)
%-------------------------Method-----------------------------------------
%
%This function calculates composites, where we average startMonth to
%endMonth for each year, and then average all of the years together for
%both positve and negative.  We then take the difference of the two sets of
%years.  Posivite years are years that correspond to high hurricane
%activity, not necessarily years with high index values (in the event that
%and index negatively correlates with hurricane activity.
%
%---------------------------Input----------------------------------------
%
%--->data - the data that we are compositing, this should be a three
%dimensional matrix (latitude x longitude x time)
%--->pYears - a vector containing the years of high hurricane activity
%--->nYears - a vector containing the years of low hurricane activity
%--->dates - a vector containing the dates for which the data was taken.
%This should be a two dimensional matrix, where each row corresponds to a
%different date, the columns should represent hours, day, month, and year
%respectivly (See hoursToDate.m documentation for more details).
%--->startMonth - the lower bound for what month to composite over for each
%year
%--->endMonth - the upper bound for what motnh to composite over for each
%year.
%
%--------------------------Output----------------------------------------
%
%--->pMean - the composite for the positive (high) years, as described in the method
%section
%--->nMean - the composite for the negative (low) years
%--->diff - the difference between the positive and negative years

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

