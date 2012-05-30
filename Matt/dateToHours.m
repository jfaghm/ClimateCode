function [ hours ] = dateToHours(day, month, year, baseMonth, baseYear)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 
hours = 0;
if day ~= 1
        hours = (day - 1) * 24;
end

while month ~= baseMonth || year ~= baseYear
   switch month
       case{4, 6, 9, 11} %30 days
           hours = hours + 30 * 24;
           month = month - 1;
           continue;
       case{1, 3, 5, 7, 8, 10, 12}
           hours = hours + 31 * 24;
           month = month - 1;
           if month == 0
               month = 12;
               year = year-1;
           end
           continue;
       case{2}
           if mod(year, 4) == 0
               hours = hours + 29 * 24;
               month = month - 1;
           else
               hours = hours + 28 * 24;
               month = month - 1;
           end
   end
end

end

