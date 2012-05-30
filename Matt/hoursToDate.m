function [ dates ] = hoursToDate( hours, baseMonth, baseYear )
%This function takes in an array of hours, the base month and the base year.
%Each entry is the number of hours from the date that is provided
%hour 0.  Each hour entry is converted to a date.  The date matrix has four columns.
%The first column is for hours, second is for day, third is for month, and the last column
%is for the year.

dates = zeros(1, 4);
days = floor(hours / 24); %gets total number of days
currentHours = mod(hours, 24);  %gets remaining hours
dates(1, 1) = currentHours;  %sets the hours field of the dates matrix
%set the base date
currentMonth = baseMonth;
currentYear = baseYear;	
while true  
    switch currentMonth
		case{4, 6, 9, 11} 
			if days >= 30
				currentMonth = currentMonth + 1;
				days = days - 30;
			else break; %id days is less than 30 then break out of loop
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
                else break; %if days is less than 28 then break out of loop
            end
    end
end

	dates(1, 2) = days+1;
	dates(1, 3) = currentMonth;
	dates(1, 4) = currentYear;
	
	

end


