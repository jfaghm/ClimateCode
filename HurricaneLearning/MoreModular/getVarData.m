function [ varData ] = getVarData( dateStrings, var, pres, index)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

data_path = '/project/expeditions/liesss/Data/faghmous/';

switch var
    
    case 'sst'
        folders = {'sea_surface_temp/'};
        prefixes = {'ei.oper.an.sfc.regn128sc.'};
        suffixes = {'.sst.nc'};
        varName = 'var34';
        
    case { 'temp', 'spec_hum', 'vorticity', 'divergence', 'rel_hum'}
        
        for i = 1:size(pres, 2);
            folders{i} = ['era_' pres{i} '/' ];
            prefixes{i} = 'ei.oper.an.pl.regn128sc.';
            suffixes{i} = ['.subset' pres{i} '.nc'];
        end
        
        switch var
            case 'temp'
                varName = 'var130';
                
            case 'spec_hum'
                varName = 'var133';

            case 'vorticity'
                varName = 'var138';

            case 'divergence'
                varName = 'var155';

            case 'rel_hum'
                varName = 'var157';

        end
       
    case 'mslp'
        
        folders = {'surface_pres/'};
        prefixes = {'ei.oper.an.sfc.regn128sc.' };
        suffixes = {'.mslp.nc' };
        varName = 'var151';
        
    case { 'u_vel', 'v_vel' }
        folders = { 'uv_wind/' };
        prefixes = { 'ei.oper.an.pl.regn128uv.' };
        suffixes = { '.uv.nc' };
        
        switch var
            case 'u_vel'
                varName = 'var131';
            case 'v_vel'
                varName = 'var132';
        end
end

% compute the number of pressure levels that need to be examined
if iscell(pres)
    numPL = size(pres, 2);
else
    numPL = 1;
end

% initialize the data vector to the correct size
varData = zeros(1, 10*numPL);

for p = 1:numPL
    
    for i = 1:10
        if strcmp(dateStrings{i}, 'INVALID')
            value = -1;
        else
        
            filename = [ data_path, folders{p}, prefixes{p}, dateStrings{i}, suffixes{p} ];
            try
                ncid = netcdf.open(filename, 'NC_NOWRITE');
                varID = netcdf.inqVarID(ncid, varName);
                var = netcdf.getVar(ncid, varID)';
                value = var(index);
                netcdf.close(ncid);
            catch ME
                fprintf('%s\n', filename)
                fprintf('%s\n', ME.message)
                value = -1;
            end
        end
        
        varData(i + (p-1)*10) = value;
    
    end

end

end