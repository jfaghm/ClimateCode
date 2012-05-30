function dateVector = dateMatrixToVector( dateMatrix, columnLabels )
% Converts a matrix of year, month, and day to a single vector
% 
% dateVector = dateMatrixToVector( dateMatrix, columnLabels )
% 
% ----------------------- INPUT -----------------------
% 
% --> dateMatrix - a matrix of dates with any combination of year, month,
% and day columns.
% --> columnLabels - a cell array of labels for each column of dateMatrix.
% It should have a 'y', 'm', or 'd' for a column which is a year, month, or
% day column respectively.
% 
% ----------------------- OUTPUT -----------------------
% 
% --> dateVector - a vector of dates with each date in the form
% [yyyy][mm][dd], with year, day, year and month, month and day, or year
% and day omitted.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have a date matrix with year and month columns in that order
% % Convert it to a single date vector with each date of the form
% % [yyyy][mm]
% dateVector = dateMatrixToVector( dateMatrix, { 'y', 'm' } );
% % Suppose instead that dateMatrix has year, month, and day columns
% % Convert it to a vector with dates of the form [yyyy][mm][dd]
% dateVector = dateMatrixToVector( dateMatrix, { 'y', 'm', 'd' } );
% 


if ~iscell(columnLabels)
    error('columnLabels should be a cell array of strings.')
elseif size(dateMatrix, 2) ~= length(columnLabels)
    error('The number of elements in columnLabels should be equal to the number of columns in dateMatrix')
end

% Check for any duplicates in columnLabels
if sum(ismember('y', columnLabels)) > 1 ...
        || sum(ismember('m', columnLabels)) > 1 ...
        || sum(ismember('d', columnLabels)) > 1
    error('columnLabels should not contain duplicates')
end

% Check for any non 'y', 'm', or 'd' columnLabels
if any( ~ismember(columnLabels, { 'y', 'm', 'd' }) )
    error('columnLabels should only contain y, m, d')
end

% By default, all offsets to 0 to handle trivial case of only one column
yearOffset = 0;
monthOffset = 0;
dayOffset = 0;

if all(ismember({'y', 'm', 'd'}, columnLabels))
    yearOffset = 4;
    monthOffset = 2;
    dayOffset = 0;
elseif all(ismember({'y', 'm'}, columnLabels) )
    yearOffset = 2;
    monthOffset = 0;
elseif all(ismember({'y', 'd'}, columnLabels) )
    % This doesn't make sense to have a year and a day, but we'll do it
    yearOffset = 2;
    dayOffset = 0;
elseif all(ismember({'m', 'd'}, columnLabels))
    yearOffset = 2;
    monthOffset = 0;
end

dateVector = zeros( size(dateMatrix, 1), 1 );

for col = 1:length(columnLabels)
    switch columnLabels{col}
        
        case 'y'
            offset = yearOffset;
        case 'm'
            offset = monthOffset;
        case 'd'
            offset = dayOffset;
            
    end
    
    dateVector = dateVector + dateMatrix(:, col)*10^offset;
    
end


end