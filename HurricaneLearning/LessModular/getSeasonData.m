function [ out ] = getSeasonData(indices, season)
%GETSEASONDATA Gets the positive and negative observations for the season
%   getSeason data takes in a season structure, which has yr, months, days,
%   and numStorms fields.  yr and numStorms should be scalars, while months
%   and days should be vectors of the same length indicating the starting
%   dates of the storms.

% This is the path to the climate data nc files
global ncDataPath
    
yearString = num2str(season.yr);

out = cell(season.numStorms*4, 6);

for i = 1:season.numStorms
    
    dayNumber = datenum(season.yr, season.months(i), season.days(i)) - ...
        datenum(season.yr, 1, 1) + 1;

    isLeapYear = leapyear(season.yr);
    
    % Check if the day is before June 3rd or after November 30th
    if (dayNumber < 154 + isLeapYear  ... % day is before June 3rd
            || dayNumber > 334 + isLeapYear) % day is after November 30th
        % not enough data for this date and previous 36 hours
        continue;
    end
    
    out{4*(i-1)+1, 1} = [1 dayNumber season.lat(i) season.lon(i)];
    
    dateStrings = generateDateStrings(yearString, season.months(i), season.days(i));
    
    index = indices(i);
    
    negDates = getNegatives(season.yr, season.months(i), season.days(i), ...
        season.lat(i), season.lon(i), index);
    numDates = size(negDates, 1) + 1;
    
    % create the negative date strings and pack them into a cell array
    % also fill in the storm indicator, day, and location info
    for dateNum = 1:(numDates-1)
        date = negDates(dateNum, :);
        % create date strings for this negative date and add to cell array
        dateStrings(end+1, :) = ...
            generateDateStrings(date(1), date(2), date(3)); %#ok<AGROW>
        % compute the date number of the negative date
        dayNumber = datenum(date(1), date(2), date(3)) - datenum(date(1), 1, 1);
        % set info for that date
        out{4*(i-1) + dateNum+1, 1} = [0 dayNumber season.lat(i) season.lon(i)];
    end
    
    % Iterate through the positive and negative dates for this storm
    for dateNum = 1:numDates
        % variable that tracks whether an observation is over land
        isLand = false;
        
        outIndex = 4*(i-1) + dateNum;
        
        %% This cell gets the sea surface temperature for the last 36 hours
        sstVector = zeros(1, 10);
        for j = 1:10
            if strcmp(dateStrings{dateNum, j}, 'INVALID')
                sst = -1;
            else
                
                filename = [ncDataPath, 'sea_surface_temp/', 'ei.oper.an.sfc.regn128sc.', dateStrings{dateNum, j}, '.sst.nc'];
                try
                    ncid = netcdf.open(filename, 'NC_NOWRITE');
                    varID = netcdf.inqVarID(ncid, 'var34');
                    var = netcdf.getVar(ncid, varID)';
                    sst = var(index);
                    netcdf.close(ncid);
                catch ME
                    fprintf('%s\n', filename)
                    fprintf('%s\n', ME.message)
                    sst = -1;
                end
            end
            
            if sst < -8e33
                isLand = true;
                break
            end
            
            sstVector(1, j) = sst;
            
        end
        
        % stop processing this date if it is over land
        if isLand
            % first remove the day number and location info
            out{outIndex, 1} = [];
            continue
        end
        
        out{outIndex, 2} = sstVector;
        
        %{
        %% Gets uv wind data for the last 36 hours at 4 pressure levels
        uWindVector = zeros(1, 40);
        vWindVector = zeros(1, 40);
        
        % levels corresponds to the pressure levels 200, 500, 700, and 850
        levels = [1, 8, 12, 17];
        numLevels = size(levels, 2);
        
        for j = 1:10
            
            if strcmp(dateStrings{dateNum, j}, 'INVALID')
                uWind = ones(1, numLevels) * -1;
                vWind = ones(1, numLevels) * -1;
            else
                
                filename = [ncDataPath, 'uv_wind/', 'ei.oper.an.pl.regn128uv.', dateStrings{dateNum, j}, '.uv.nc'];
                try
                    ncid = netcdf.open(filename, 'NC_NOWRITE');
                    uID = netcdf.inqVarID(ncid, 'var131');
                    vID = netcdf.inqVarID(ncid, 'var132');
                    uWindArray = netcdf.getVar(ncid, uID);
                    vWindArray = netcdf.getVar(ncid, vID);
                    for k = 1:numLevels
                        uSlice = uWindArray(:, :, levels(k))';
                        uWind(k) = uSlice(index);
                        vSlice = vWindArray(:, :, levels(k))';
                        vWind(k) = vSlice(index);
                    end
                    netcdf.close(ncid);
                catch ME
                    fprintf('%s\n', filename)
                    fprintf('%s\n', ME.message)
                    uWind = ones(1, numLevels) * -1;
                    vWind = ones(1, numLevels) * -1;
                end
            end
            
            for k = 1:numLevels
                uWindVector((k-1)*10 + j) = uWind(k);
                vWindVector((k-1)*10 + j) = vWind(k);
            end
            
        end
        
        out{outIndex, 3} = uWindVector;
        out{outIndex, 4} = vWindVector;
        
        %% Gets the mean sea level pressure for the last 36 hours
        
        mslpVector = zeros(1, 10);
        for j = 1:10
            
            if strcmp(dateStrings{dateNum, j}, 'INVALID')
                mslp = -1;
            else
                filename = [ncDataPath, 'surface_pres/' 'ei.oper.an.sfc.regn128sc.' dateStrings{dateNum, j}, '.mslp.nc'];
                try
                    ncid = netcdf.open(filename, 'NC_NOWRITE');
                    varID = netcdf.inqVarID(ncid, 'var151');
                    mslpArray = netcdf.getVar(ncid, varID)';
                    mslp = mslpArray(index);
                    netcdf.close(ncid);
                catch ME
                    fprintf('%s\n', filename)
                    fprintf('%s\n', ME.message)
                    mslp = -1;
                end
            end
            
            mslpVector(j) = mslp;
            
        end
        
        out{outIndex, 5} = mslpVector;
        
        %% Gets the temperature, specific humidity, vorticity, divergence, and relative humidity
        
        % These are the names of the variables in the nc files
        variableNames = {'var130', 'var133', 'var138', 'var155', 'var157'};
        numVars = size(variableNames, 2);
        
        % These are the different pressure levels
        pressureLevels = {'200', '500', '700', '850' };
        numPresLevs = size(pressureLevels, 2);
        
        dataVector = zeros(1, 200);
        
        for k = 1:numPresLevs
            for j = 1:10
                
                if strcmp(dateStrings{dateNum, j}, 'INVALID')
                    data = ones(1, 5) * -1;
                else
                    filename = [ncDataPath, 'era_', pressureLevels{k}, '/ei.oper.an.pl.regn128sc.' ...
                        dateStrings{dateNum, j}, '.subset', pressureLevels{k}, '.nc' ];
                    try
                        ncid = netcdf.open(filename, 'NC_NOWRITE');
                        for varNum = 1:numVars
                            varID = netcdf.inqVarID(ncid, variableNames{varNum});
                            varArray = netcdf.getVar(ncid, varID)';
                            var = varArray(index);
                            data(varNum) = var;
                        end
                        netcdf.close(ncid);
                        
                    catch ME
                        fprintf('%s\n', filename)
                        fprintf('%s\n', ME.message)
                        data = ones(1, 5) * -1;
                    end
                end
                
                for varNum = 1:numVars
                    dataVector((varNum-1)*40 + (k-1)*10 + j) = data(varNum);
                end
                
            end
        end
        
        out{outIndex, 6} = dataVector;
        
        %}
    end
end

out = cell2mat(out);

end