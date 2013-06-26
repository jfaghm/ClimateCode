% This script converts nc files for uv_wind into matlab data matrices

dataPath = '/project/expeditions/liesss/Data/faghmous/';

numLocations = 256*512;
numDays = 183;

prefix = 'uv_wind/ei.oper.an.pl.regn128uv.';
suffix = '.uv.nc';

% levels in uv_wind files corresponding to 200, 500, 700, and 850 mbar
levels = [ 1 8 12 17 ];
numLevels = length(levels);

for year = 2010:2010
    yearStartTime = tic;
    yearString = num2str(year);
    
    uWind = zeros(numLocations, numDays*4, numLevels);
    vWind = zeros(numLocations, numDays*4, numLevels);
    timeSlot = 0;
    for month = 6:11
        monthStartTime = tic;
        monthString = num2str(month, '%02d');
        endingDay = eomday(year, month);
        for day = 1:endingDay
            dayString = num2str(day, '%02d');
            for hour = 0:6:18
                hourString = num2str(hour, '%02d');
                dateString = [yearString monthString dayString hourString];
                ncid = netcdf.open([dataPath prefix dateString suffix], 'NC_NOWRITE');
                uWindID = netcdf.inqVarID(ncid, 'var131');
                vWindID = netcdf.inqVarID(ncid, 'var132');
                
                uWindMatrix = netcdf.getVar(ncid, uWindID);
                vWindMatrix = netcdf.getVar(ncid, vWindID);
                
                netcdf.close(ncid)
                
                timeSlot = timeSlot + 1;
                
                for lev = 1:numLevels
                    uWind(:, timeSlot, lev) = reshape(uWindMatrix(:, :, levels(lev))', [], 1);
                    vWind(:, timeSlot, lev) = reshape(vWindMatrix(:, :, levels(lev))', [], 1);
                end
                
            end
        end
        
        fprintf('The month %d of year %d took %.2f seconds to complete.\n', ...
                month, year, toc(monthStartTime));
            
    end
    
    uWind200 = uWind(:, :, 1);
    uWind500 = uWind(:, :, 2);
    uWind700 = uWind(:, :, 3);
    uWind850 = uWind(:, :, 4);
    
    vWind200 = vWind(:, :, 1);
    vWind500 = vWind(:, :, 2);
    vWind700 = vWind(:, :, 3);
    vWind850 = vWind(:, :, 4);
    
    save(['uWind200_' yearString '.mat'], 'uWind200');
    save(['uWind500_' yearString '.mat'], 'uWind500');
    save(['uWind700_' yearString '.mat'], 'uWind700');
    save(['uWind850_' yearString '.mat'], 'uWind850');
    
    save(['vWind200_' yearString '.mat'], 'vWind200');
    save(['vWind500_' yearString '.mat'], 'vWind500');
    save(['vWind700_' yearString '.mat'], 'vWind700');
    save(['vWind850_' yearString '.mat'], 'vWind850');
    
    fprintf('The year %d took %.2f seconds to complete.\n', year, toc(yearStartTime));
    
end

%{
saveNames = {'sst', 'mslp'};
prefixes = { 'sea_surface_temp/ei.oper.an.sfc.regn128sc.',  ... 
    'surface_pres/ei.oper.an.sfc.regn128sc.' };
suffixes = { '.sst.nc', '.mslp.nc' };
varNames = { 'var34', 'var151' };

numVars = length(prefixes);

numLocations = 256*512;
numDays = 183;

for varNum = 1:numVars
    
    prefix = prefixes{varNum};
    suffix = suffixes{varNum};
    varName = varNames{varNum};    
    
    if varNum == 1
        startYear = 2010;
    else
        startYear = 1989;
    end    

    for year = startYear:2009
        yearStartTime = tic;
        yearString = num2str(year);
        variable = zeros(numLocations, numDays);
        timeSlot = 0;
        for month = 6:11
            monthStartTime = tic;
            monthString = num2str(month, '%02d');
            endingDay = eomday(year, month);
            for day = 1:endingDay
                dayString = num2str(day, '%02d');
                for hour = 0:6:18
                    hourString = num2str(hour, '%02d');
                    dateString = [yearString monthString dayString hourString];
                    ncid = netcdf.open([dataPath prefix dateString suffix], 'NC_NOWRITE');
                    varID = netcdf.intimeSlotqVarID(ncid, varName);
                    var = reshape((netcdf.getVar(ncid, varID)'), [], 1);
                    %var = netcdf.getVar(ncid, varID)';
                    
                    netcdf.close(ncid);
                    timeSlot = timeSlot + 1;
                    
                    variable(:, timeSlot) = var;
                    
                    % replaced the following lines with a reshape
                    %{
                    entries = numel(var);
                    for i = 1:entries
                        variable(i, timeSlot) = var(i);
                    end
                    %}
                end
            end
            fprintf('The month %d of year %d took %.2f seconds to complete.\n', ...
                month, year, toc(monthStartTime));
        end
        
        switch saveNames{varNum}
            case 'sst'
                sst = variable;
                save([saveNames{varNum} yearString '.mat'], 'sst');
            case 'mslp'
                mslp = variable;
                save([saveNames{varNum} yearString '.mat'], 'mslp');
            otherwise
                save([saveNames{varNum} yearString '.mat'], 'variable');
        end
        
        fprintf('The year %d took %.2f seconds to complete.\n', year, toc(yearStartTime));
    end
end
%}

!pwd | mail -s finished haask010@umn.edu

exit
