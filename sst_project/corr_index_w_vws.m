clear
close all
load('/project/expeditions/jfagh/code/matlab/sst_project/results/dist_index_apl_nov.mat');
file_name = '/project/expeditions/jfagh/data/era_int_1979/pres_level/pres_vars.nc';


current_var = 'var132';
current_var_name = 'Vertical Wind Shear';
current_var_short = 'vwsin';
save_path = strcat('/project/expeditions/jfagh/code/matlab/sst_project/results/index_vs_',current_var_short,'/');

ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_data = netcdf.inqVarID(ncid,current_var);
varid_lat = netcdf.inqVarID(ncid,'lat');
varid_lon = netcdf.inqVarID(ncid,'lon');
varid_level = netcdf.inqVarID(ncid,'lev');
lon = netcdf.getVar(ncid,varid_lon);
lon(lon>180) = lon(lon>180)-360;
lat = netcdf.getVar(ncid,varid_lat);
levels = netcdf.getVar(ncid,varid_level);
var = netcdf.getVar(ncid,varid_data);

u_file_name = '/project/expeditions/data/era-interim/monthly/nc/ua_1979-2000.nc';
