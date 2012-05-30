%build el nino index based on distance of warmest point
%file_name = '/project/expeditions/jfagh/data/reynolds_monthly/monthly_anomalies_1983_2010.nc';
%ncid = netcdf.open(file_name,'NC_NOWRITE');
%varid_data = netcdf.inqVarID(ncid,'sst');
%varid_lat = netcdf.inqVarID(ncid,'lat');
%varid_lon = netcdf.inqVarID(ncid,'lon');
%lon = netcdf.getVar(ncid,varid_lon);
%lat = netcdf.getVar(ncid,varid_lat);
%sst = netcdf.getVar(ncid,varid_data);
%load('/project/expeditions/jfagh/data/modoki.mat');
%lat = 88:-2:-88;
%lon = 0:2:358;
sst = sst_1971_2010;
box_north = 40;
box_south = -6;
box_west = 140;
box_east = 282;
if ismember(box_north, lat)
   [~, northRow] = ismember(box_north, lat);
   [~, southRow] = ismember(box_south, lat);
else
    error('Bad lat input!');
end
if ismember(box_east, lon)
   [~, eastCol] = ismember(box_east, lon);
   [~, westCol] = ismember(box_west, lon);
else
    error('Bad lat input!');
end
sst_pacific = sst(northRow:southRow,westCol:eastCol,:);
[a,ind]=max(max(sst_pacific));
sst_anom = reshape(a,1,[]);
index = reshape(ind,1,[]);
