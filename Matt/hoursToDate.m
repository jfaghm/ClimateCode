function [ date ] = hoursToDate( hours, baseDay, baseMonth, baseYear )
%This function takes in  hours from a certain date in time, and
%then converts it to a date.  Many of the netCDF files document their time
%in the hours since xx/xx/xxxx form
%
%----------------------------Input----------------------------------------
%
%--->hours - a scaler value that represents the number of hours from a
%certain base date
%--->baseDay - the day of the base date that the hours are from
%--->baseMonth - the month of the base date
%--->baseYear - the year of the base date
%
%-----------------------------Output--------------------------------------
%
%--->date - the date that is equivalent to the number of hours from the
%base date.  This is a matrix with one row and 4 columns.  the first column
%corresponds to hours, the second corresponds to day, then month, and then
%year.

date = zeros(1, 4);
days = floor(hours / 24) + baseDay - 1; %gets total number of days
currentHours = mod(hours, 24);  %gets remaining hours
date(1, 1) = currentHours;  %sets the hours field of the dates matrix
currentMonth = baseMonth;
currentYear = baseYear;	
while true  
    switch currentMonth
		case{4, 6, 9, 11} 
			if days >= 30
				currentMonth = currentMonth + 1;
				days = days - 30;
            else
                break; %if days is less than 30 then break out of loop
			end
		case{1, 3, 5, 7, 8, 10, 12}
			if days >= 31 && currentMonth ~= 12
				currentMonth = currentMonth + 1;
				days = days - 31;
			elseif days >= 31 && currentMonth == 12
				currentMonth = 1;
				currentYear = currentYear + 1;
				days = days - 31;
			else
				 break; % if days is less than 31 then break out of loop
			end
		case 2
			if days >= 28 && mod(currentYear, 4) ~= 0 %#ok<ALIGN>
				currentMonth = currentMonth + 1;
				days = days - 28;
                elseif days >= 29 && mod(currentYear, 4) == 0 || mod(currentYear, 100) == 0 %leap year.
				currentMonth = currentMonth + 1;		
				days = days - 29;
            else
                break; %if days is less than 28 then break out of loop
            end
    end
end

	date(1, 2) = days+1;
	date(1, 3) = currentMonth;
	date(1, 4) = currentYear;
end


