% This script turns nc data files into matlab data files for a bunch of different climate
% variables, which are listed below in saveNames


dataPath = '/project/expeditions/liesss/Data/faghmous/era_';
levels = { '200', '500', '700', '850' };
numLevels = length(levels);

savePath = '/project/expeditions/liesss/Data/faghmous/matfiles/';

% sample file name
% ei.oper.an.pl.regn128sc.2009113018.subset200.nc

prefix = '/ei.oper.an.pl.regn128sc.';
varNames = { 'var130', 'var133', 'var138', 'var155', 'var157' };
saveNames = { 'temperature', 'spec_hum', 'vorticity', 'divergence', 'rel_hum' };

numVars = length(varNames);
numLocations = 256*512;
numDays = 183;

variables = zeros(numLocations, numDays*4, numVars);


for lev = 1:numLevels
    
    levelStartTime = tic;
    
    level = levels{lev};
    
    for year = 1989:2009
        
        yearStartTime = tic;
        yearString = num2str(year);                
        
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
                    fileName = [dataPath level prefix dateString '.subset' level '.nc'];
                    
                    ncid = netcdf.open(fileName, 'NC_NOWRITE');
                    
                    timeSlot = timeSlot + 1;
                    
                    for var = 1:numVars
                        varID = netcdf.inqVarID(ncid, varNames{var});
                        variables(:, timeSlot, var) = reshape(netcdf.getVar(ncid, varID)', [], 1);
                    end
                    
                    netcdf.close(ncid)
                    
                end
            end
            
            fprintf('The month %d of year %d took %.2f seconds to complete.\n', ...
                month, year, toc(monthStartTime));
            
        end
        
        fprintf('Saving the variables for the year %d.\n', year)
        for var = 1:numVars
            data = variables(:, :, var);
            save([savePath saveNames{var} level '_' yearString '.mat'], 'data')
            fprintf('Finished saving %s.\n',saveNames{var})
        end
        
        fprintf('The year %d took %.2f seconds to complete.\n', year, toc(yearStartTime));
        
    end
    
    fprintf('The level %s took %.2f seconds to complete.\n', level, toc(levelStartTime));

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
