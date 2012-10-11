function stormStats = stormStats(stormData, startYear, endYear, countDuplicates)

p = inputParser;
p.addRequired('stormData', @ismatrix);
p.addRequired('startYear', @isnumeric);
p.addRequired('endYear', @isnumeric);
p.addRequired('countDuplicates', @islogical);
p.FunctionName = 'stormStats';
p.CaseSensitive = false;
p.parse(stormData, startYear, endYear, countDuplicates);

numYears = endYear-startYear+1;
stormStats = zeros(numYears, 6);

for i = 1:numYears
    
    year = startYear+i-1;
    yearStorms = stormData( stormData(:, 2) == year, : );
    yearH = yearStorms( yearStorms(:, 12) >= 1, : );
    yearIH = yearStorms( yearStorms(:, 12) >=3, : );
    
    if isempty(yearStorms)
        continue;
    end
    
    if leapyear(year)
        dayMask = false(3, 366*4);
    else
        dayMask = false(3, 365*4);
    end
    
    % Count number of named storms, hurricanes and intense hurricanes
    ns = size(unique(yearStorms( yearStorms(:, 12) >= 0, 1 )), 1);
    nh = size(unique(yearStorms( yearStorms(:, 12) >= 1, 1 )), 1);
    nih = size(unique(yearStorms( yearStorms(:, 12) >= 3, 1 )), 1);
    
    
    % Base date number for subtraction
    baseDateNum = datenum([year, 1, 1]);
    
    % If we are counting a day with two storms as two days
    if countDuplicates
        sd = size(yearStorms, 1) / 4;
        hd = size(yearH, 1) / 4;
        ihd = size(yearIH, 1);
       
    else  % Only counting a day with two storms as one day
        
        % Count the number of days of storms, hurricanes, and intense
        % hurricanes
        if ~isempty(yearStorms)
            stormDayNums = (datenum(yearStorms(:, [ 2 3 4 ])) - baseDateNum)*4 + 1 + round(yearStorms(:, 5)/6);
            dayMask(1, stormDayNums) = true;
        end
        if ~isempty(yearH)
            hurDayNums = (datenum(yearH(:, [ 2 3 4 ])) - baseDateNum)*4 + 1 + round(yearH(:, 5)/6);
            dayMask(2, hurDayNums) = true;
        end
        if ~isempty(yearIH)
            ihurDayNums = (datenum(yearIH(:, [ 2 3 4 ])) - baseDateNum)*4 + 1 + round(yearIH(:, 5)/6);
            dayMask(3, ihurDayNums) = true;
        end
        
        % Count the number of storm, hurricane, and intense hurricane days
        sd = sum(dayMask(1, :))/4;
        hd = sum(dayMask(2, :))/4;
        ihd = sum(dayMask(3, :))/4;
    end
    
    stormStats(i, :) = [ ns, sd, nh, hd, nih, ihd ];
    
end