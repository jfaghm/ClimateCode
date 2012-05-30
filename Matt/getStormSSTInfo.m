function [ output ] = getStormSSTInfo( storms, grid, sst, hours, lat, lon )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

n = size(storms, 1);
output = zeros(n, 11);

for i = 1:n
    year = storms(i, 1);
    month = storms(i, 2);
    day = storms(i, 3);
    
    %dayNumber = datenum(year, month, day) - datenum(year, 1, 1);
    if month < 8 && year == 1989
        continue;
    end
    output(i, 1) = day;
    output(i, 2) = month;
    output(i, 3) = year;
    [~, timeIndex] = max(hours(:) == dateToHours(day, month, year, 8, 1989));
    [~, latIndex] = max(lat(:, 1) == grid(i, 1));
    [~, lonIndex] = max(lon(:, 1) == grid(i, 2));
    output(i, 4) = lat(latIndex);
    output(i, 5) = lon(lonIndex);
    
    
    if timeIndex == 1 %no data available for this day.
        for j = 6:15
            output(i, j) = NaN;
        end
         continue;
    end
    
   timeIndex = timeIndex + 3; %18 hours into the day of the hurricane.
            
    for j = 6:15 %get readings from 18 hours into and 36 hours prior
        if timeIndex == 0
            output(i, j) = NaN;
            continue;
        end
        output(i, j) = sst(latIndex, lonIndex, timeIndex);
        timeIndex = timeIndex - 1;
    end
        
        
            
end
 
    
end

