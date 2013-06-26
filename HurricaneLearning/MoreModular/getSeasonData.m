function [ out ] = getSeasonData(indices, season)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% numVars = size(varsNeeded, 2);

%{
for i = 1:numVars
    if iscell(varsNeeded(2, i)
        numPL = size(varsNeeded{2, i}, 2);
        additionalColumns = numPL*10;
    else
        additionalColumns = 10;
    end
    columnsNeeded = columnsNeeded + additionalColumns;
end
%}

data_path = '/project/expeditions/liesss/Data/faghmous/';
    
yearString = num2str(season.yr);

%out = cell(season.numStorms, numVars + 1);
out = cell(season.numStorms, 6);

for i = 1:season.numStorms
    
    day_number = datenum(season.yr, season.months(i), season.days(i)) - ...
        datenum(season.yr, 1, 1) + 1;

    out{i, 1} = [1 day_number season.lat(i) season.lon(i)];
    
    dateStrings = generateDateStrings(yearString, season.months(i), season.days(i));
    
    index = indices(i);
    
    %{
    for k = 1:numVars;
        
        stormVar = getVarData(dateStrings, varsNeeded{1, k}, varsNeeded{2, k}, index);
    
        out{i, 1+k} = stormVar;
        
    end
    %}
    
    %% This cell gets the sea surface temperature for the last 36 hours
    sstVector = zeros(1, 10);
    for j = 1:10
        if strcmp(dateStrings{j}, 'INVALID')
            sst = -1;
        else
            
            filename = [data_path, 'sea_surface_temp/', 'ei.oper.an.sfc.regn128sc.', dateStrings{j}, '.sst.nc'];
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
        
        sstVector(1, j) = sst;
        
    end
    
    out{i, 2} = sstVector;
    
    %% Gets uv wind data for the last 36 hours at 4 pressure levels
    uWindVector = zeros(1, 40);
    vWindVector = zeros(1, 40);
    
    % levels corresponds to the pressure levels 200, 500, 700, and 850
    levels = [1, 8, 12, 17];
    numLevels = size(levels, 2);
    
    for j = 1:10
        
        if strcmp(dateStrings{j}, 'INVALID')
            uWind = ones(1, numLevels) * -1;
            vWind = ones(1, numLevels) * -1;
        else
            
            filename = [data_path, 'uv_wind/', 'ei.oper.an.pl.regn128uv.', dateStrings{j}, '.uv.nc'];
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
    
    out{i, 3} = uWindVector;
    out{i, 4} = vWindVector;
    
    %% Gets the mean sea level pressure for the last 36 hours
    
    mslpVector = zeros(1, 10);
    for j = 1:10
        
        if strcmp(dateStrings{j}, 'INVALID')
            mslp = -1;
        else
            filename = [data_path, 'surface_pres/' 'ei.oper.an.sfc.regn128sc.' dateStrings{j}, '.mslp.nc'];
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
    
    out{i, 5} = mslpVector;
    
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
        
            if strcmp(dateStrings{j}, 'INVALID')
                data = ones(1, 5) * -1;
            else
                filename = [data_path, 'era_', pressureLevels{k}, '/ei.oper.an.pl.regn128sc.' ...
                    dateStrings{j}, '.subset', pressureLevels{k}, '.nc' ];
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
    
    out{i, 6} = dataVector;
        
end


out = cell2mat(out);
    
end