function [ avgSST ] = getDailyAvgSST( year, month, day, index )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global ncDataPath
prefix = [ncDataPath 'sea_surface_temp/ei.oper.an.sfc.regn128sc.'];

dateStrings = generateDateStrings(year, month, day, 4);

% open each file, read the sea surface temperature
sst = zeros(1, 4);
for i = 1:4
    ncid = netcdf.open([prefix, dateStrings{i}, '.sst.nc'], 'NC_NOWRITE');
    varID = netcdf.inqVarID(ncid, 'var34');
    var = netcdf.getVar(ncid, varID)';
    sst(i) = var(index);
    netcdf.close(ncid);
end

avgSST = mean(sst);

end

