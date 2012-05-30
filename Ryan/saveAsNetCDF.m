function saveAsNetCDF( data, gridInfo, savename )
%SAVEASNETCDF Saves the 2D data as a netcdf file.
% 
%   saveAsNetCDF( data, latInfo, lonInfo, savename )
% 
% Saves the 2D data as a netcdf file using the info given in lats and lons
% -------------------------------- INPUT --------------------------------
%
% --> data - The 2D matrix to be saved as a netcdf file.
% 
% --> gridInfo - A structure indicating the layout of the latitude and
% longitude grid.  It must have the fields lats and lons, which are just
% vectors of the latitude and longitude values of each row and column in
% the grid, respectively.
% 
% --> savename - The name of the netcdf file to create and save to.  If
% this file already exists, saveAsNetCDF will fail.
%
% -------------------------------- OUTPUT --------------------------------
%
% --> allCorrelations - A matrix which contains the correlation between
% every possible pair of rows from A and B.  The entry allCorrelations(i, j) 
% contains the correlation between the ith row of A and jth row of B.
% 

numLats = length(gridInfo.lats);
numLons = length(gridInfo.lons);

if exist(savename, 'file')
    error('Specified save file already exists.  Delete that file and try again.')
end

if length(size(data)) > 2
    error('The data can only be a 2D grid')
end

if numLats ~= size(data, 1) || numLons ~= size(data, 2)
    error('The size of data should match the size of the specified lat/long grid.\n')
end

if exist(savename, 'file')
    error('Specified file name already exists. Delete that file and try again.')
end

nccreate(savename, 'lon', 'Dimensions', {'lon', numLons})
nccreate(savename, 'lat', 'Dimensions', {'lat', numLats})
ncwrite(savename, 'lat', lats)
ncwrite(savename, 'lon', lons)
nccreate(savename, 'data', 'Dimensions', {'lat', numLats, 'lon', numLons});
ncwrite(savename, 'data', data)

end

