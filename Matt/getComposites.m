function [ pMeanComp, nMeanComp, diff ] = getComposites( posYears, negYears, data, time, dataType, pMinN, startMonth, endMonth)
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

if strcmp(dataType, 'cell') == 1
    year = 1; month = startMonth;
    for i = 1:size(posYears, 1) * (endMonth - startMonth +1)
        [~, posIndex] = max(dates(:, 4) == posYears(year));
        posComposites(:, :, i) = data{posIndex + month - 1, 1};
        month = month+1;
        if month == endMonth + 1
           month = startMonth;
           year = year+1;
        end
    end
    year = 1; month = startMonth;
    for i = 1:size(negYears, 1) * (endMonth - startMonth +1)
        [~, negIndex] = max(dates(:, 4) == negYears(year));
        negComposites(:, :, i) = data{negIndex + month - 1, 1};
        month = month+1;
        if month == endMonth + 1
           month = startMonth;
           year = year+1;
        end
    end
elseif strcmp(dataType, 'matrix') == 1
    year = 1; month = startMonth;
    for i = 1:size(posYears, 1) * (endMonth - startMonth +1)
        [~, posIndex] = max(dates(:, 4) == posYears(year));
        posComposites(:, :, i) = data(:, :, posIndex + month - 1);
        month = month+1;
        if month == endMonth + 1
           month = startMonth;
           year = year+1;
        end
    end
    year = 1; month = startMonth;
    for i = 1:size(negYears, 1) * (endMonth - startMonth +1)
        [~, negIndex] = max(dates(:, 4) == negYears(year));
        negComposites(:, :, i) = data(:, :, negIndex + month - 1);
        month = month+1;
        if month == endMonth + 1
           month = startMonth;
           year = year+1;
        end
    end
else
    error('dataType must either be cell or matrix');
end


pMeanComp = mean(posComposites, 3);
nMeanComp = mean(negComposites, 3);

if pMinN == true
    diff = pMeanComp - nMeanComp;
else
    diff = nMeanComp - pMeanComp;
end

end

