function [ pMeanComp, nMeanComp, diff ] = getComposites( posYears, negYears, data, time, dataType )
%This function is used to calculate the composites of a certain type of
%data that is specified by the data input argument.
%   The positive and negative years must be given as a one dimensional
%   matrix.  The times must also be passed in as a one dimensional matrix.
%   This function assumes that the time vectors are in the form "hours
%   since 1979-01-01 00:00:00"

posComposites = zeros(256, 512, size(posYears, 1) * 3);
negComposites = zeros(256, 512, size(negYears, 1) * 3);

if size(data, 1) == 512
    data = permute(data, [2, 1, 3]);
end

%The times are in hours from January 1, 1979, so we call the hoursToDate
%function in order to change them into a hour/day/month/year form.
dates = zeros(size(time, 1), 4);
for i = 1:size(time, 1)
   dates(i, :) = hoursToDate(time(i), 1, 1979);
end
year = 1;
if strcmp(dataType, 'cell') == 1
    for i = 1:3:(size(posYears)*3)
        [~, posIndex] = max(dates(:, 4) == posYears(year));
        [~, negIndex] = max(dates(:, 4) == negYears(year));
        posComposites(:, :, i) = data{posIndex+7, 1};
        posComposites(:, :, i+1) = data{posIndex+8, 1};
        posComposites(:, :, i+2) = data{posIndex+9, 1};
        negComposites(:, :, i) = data{negIndex+7, 1};
        negComposites(:, :, i+1) = data{negIndex+8, 1};
        negComposites(:, :, i+2) = data{negIndex+9, 1};
        year = year+1;
    end
elseif strcmp(dataType, 'matrix') == 1
    for i = 1:3:(size(posYears)*3)
        [~, posIndex] = max(dates(:, 4) == posYears(year));
        [~, negIndex] = max(dates(:, 4) == negYears(year));
        posComposites(:, :, i) = data(:, :, posIndex+7);
        posComposites(:, :, i+1) = data(:, :, posIndex+8);
        posComposites(:, :, i+2) = data(:, :, posIndex + 9);
        negComposites(:, :, i) = data(:, :, negIndex + 7);
        negComposites(:, :, i+1) = data(:, :, negIndex + 8);
        negComposites(:, :, i+2) = data(:, :, negIndex + 9);
        year = year+1;
    end
else
    error('dataType must either be cell or matrix');
end


pMeanComp = nanmean(posComposites, 3);
nMeanComp = nanmean(negComposites, 3);
diff = nMeanComp - pMeanComp;


end

