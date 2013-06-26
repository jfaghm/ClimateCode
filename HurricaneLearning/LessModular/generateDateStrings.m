function [ dateStrings ] = generateDateStrings( year, month, day, numDates )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if ~ischar(year)
    yearString = num2str(year);
else
    yearString = year;
end

if nargin < 4
    numDates = 10;
end

dateStrings = cell(1, numDates);

if month < 6 || month > 11
    for i = 1:numDates
        dateStrings{i} = 'INVALID';
    end
    return
end

monthString = num2str(month, '%02d');
dayString = num2str(day, '%02d');

for i = 1:numDates
    hour = mod(24 - 6*i, 24);
    dateStrings{i} = [yearString monthString dayString num2str(hour, '%02d')];
    if mod(i, 4) == 0
        day = day - 1;
        if day < 1;
            month = month -1;
            if month < 6
                for j = (i+1):10
                    dateStrings{j} = 'INVALID';
                end
                break;
            else
                day = eomday(str2double(yearString), month);
                monthString = num2str(month, '%02d');
            end
        end
        dayString = num2str(day, '%02d');
    end
end

end