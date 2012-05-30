function dateMatrix = dateVectorToMatrix( dateVector, dateFormat )
% Converts a vector of date numbers into a matrix of year, month, and day.
% 
% dateMatrix = dateVectorToMatrix( dateVector, dateFormat )
% 
% ----------------------- INPUT -----------------------
% 
% --> dateVector - a vector of dates
% --> dateFormat - a string representing the format of the date numbers.
% e.g. 'yyyymm' or 'yyyymmdd' or 'yymmdd', etc
% 
% ----------------------- OUTPUT -----------------------
% 
% --> dateMatrix - a matrix with years, months, and days columns in that
% order when applicable
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have a date vector with dates of the form [yyyy][mm]
% % Convert it to a date matrix with year and month columns
% dateMatrix = dateVectorToMatrix( dateVector, 'yyyymm' );
% % Or, dates of the form [yyyy][mm][dd]
% dateMatrix = dateVectorToMatrix( dateVector, 'yyyymmdd' );
% 

% Just a safety check to guard against floating point inaccuracy for
% numbers larger than 2^53 (53 bits of mantissa in doubles)
if length(dateFormat) > 8
    error('dateFormat should have maximumum length of 8')
end

dateStrings = num2str(dateVector);

if length(dateFormat) > size(dateStrings, 2)
    error('dateFormat has too many format specifiers')
end

dateFormat = lower(dateFormat);
yearLocs = ( dateFormat == 'y' );
monthLocs = ( dateFormat == 'm' );
dayLocs = ( dateFormat == 'd' );

years = str2num( dateStrings(:, yearLocs) ); %#ok<*ST2NM>
months = str2num( dateStrings(:, monthLocs) );
days = str2num( dateStrings(:, dayLocs) );

dateMatrix = [ years months days ];

end