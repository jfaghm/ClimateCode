function [ hrDateNumbers, numDaysPerMonth ] = getSeasonalDates( startYear, endYear, months )
%GETSEASONALDATES Gets a matrix of YYYYMM date numbers and days per month
% [ hrDateNumbers, numDaysPerMonth ] = getSeasonalDates( startYear, endYear, months )
% 
%   Gets a 2D matrix of date numbers of the form YYYYMM for the months in
%   the years from startYear to endYear
% 
% ----------------------------- INPUT -----------------------------
% 
% --> startYear - The year to start generating date numbers
% 
% --> endYear - The last year to generate date numbers for.
% 
% --> months - The months to generate date numbers for each year.
% 
% ----------------------------- OUTPUT -----------------------------
% 
% --> hrDateNumbers - A 2D matrix where hrDateNumbers(i, j) is the date
% number for the ith month of the jth year.  Thus is has length(months)
% rows and (endYear-startYear+1) columns.
% 
% --> numDaysPerMonth - A 2D matrix where numDaysPerMonth(i, j) is the
% number of days in the ith month of the jth year.  Thus is has
% length(months) rows and (endYear-startYear+1) columns.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example gets the date numbers and days per month for a June-Oct
% % storm season from 1979-2010
% [ dateNums daysPerMonth ] = getSeasonalDates( 1979, 2010, 6:10 );
% 

% Calculate the number of seasons (years) and months for preallocation
numSeasons = endYear - startYear + 1;
numMonths = length(months);

hrDateNumbers = zeros(numMonths, numSeasons);
numDaysPerMonth = zeros(numMonths, numSeasons);

% Check if and where the specified season overlaps into the next year
overlapIndex = find(diff(months) < 0);

% Determine the structure of the season
if isempty(overlapIndex)
    yearOffset = zeros(1, numMonths);
elseif length(overlapIndex) > 1
    error('The months must be in order and must span only one or two years.')
else
    yearOffset = [ones(1, overlapIndex) zeros(1, numMonths - overlapIndex)];
end

for year = startYear:endYear
    
    monthIndex = 0;
    for month = months
        
        monthIndex = monthIndex + 1;
        
        % Correct for overlapping seasons
        actualYear = year - yearOffset(monthIndex);
        
        % Calculate and store the YYYYMM date number
        hrDateNumbers(monthIndex, year-startYear+1) = actualYear*100 + month;
        
        % Calculate and store the end of month day
        numDaysPerMonth(monthIndex, year-startYear+1) = eomday(actualYear, month);
        
    end
end
    

end

