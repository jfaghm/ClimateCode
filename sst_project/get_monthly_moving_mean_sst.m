file_name = '/project/expeditions/jfagh/data/sst_era_daily_1989_2010.nc';
ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_data = netcdf.inqVarID(ncid,'var34');
varid_lat = netcdf.inqVarID(ncid,'lat');
varid_lon = netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid,varid_lon);
lat = netcdf.getVar(ncid,varid_lat);
sst = netcdf.getVar(ncid,varid_data);
sst(sst==min(min(min(sst))))=-999;
ndays = 92;
step =7;
X = zeros(512,256,21,22);
for i=1:22
    s_ind = 1+(i-1)*step:ndays:size(sst,3)-92+((i-1)*step); 
    f_ind = s_ind + 30;
    for j=1:length(s_ind)
        dd(:,:,j) = mean(sst(:,:,s_ind(j):f_ind(j)),3);
    end
    %xsize = size(X,4);
    %dsize = size(dd,3);
    X(:,:,:,i) = dd;
end
nlat = 256;
nlon = 512 ;
nyrs = 21;
nsteps=22;
fileout=  'video.nc' ;
nc_create_empty ( fileout );
nc_add_dimension ( fileout, 'lat', nlat );
nc_add_dimension ( fileout, 'lon', nlon );
nc_add_dimension ( fileout, 'year', nyrs );
nc_add_dimension ( fileout, 'frame', nsteps );

X_varstruct.Name = 'lat';
X_varstruct.Nctype = nc_float;
X_varstruct.Dimension = { 'lat' };
Y_varstruct.Name = 'lon';
Y_varstruct.Nctype = nc_float;
Y_varstruct.Dimension = { 'lon' };
% time_varstruct.Name = 'year';
% time_varstruct.Nctype = nc_float;
% time_varstruct.Dimension = { 'year' };
% f_varstruct.Name = 'frame';
% f_varstruct.Nctype = nc_float;
% f_varstruct.Dimension = { 'frame' };
nc_addvar ( fileout, X_varstruct )
nc_addvar ( fileout, Y_varstruct )
%nc_addvar ( fileout, time_varstruct )
%nc_addvar ( fileout, f_varstruct )

% lon_varstruct.Name = namlon;
% lon_varstruct.Nctype = nc_float;
% lon_varstruct.Dimension = { namY, namX };
% lat_varstruct.Name = namlat;
% lat_varstruct.Nctype = nc_float;
% lat_varstruct.Dimension = { namY, namX };
% nc_addvar ( fileout, lon_varstruct );
% nc_addvar ( fileout, lat_varstruct );

var_varstruct.Name = 'sst';
var_varstruct.Nctype = nc_float;
var_varstruct.Dimension = { 'year','frame','lon','lat'};
%var_varstruct.Dimension = { namY, namX };
nc_addvar ( fileout, var_varstruct );

nc_varput ( fileout, 'lon', lon);
nc_varput ( fileout, 'lat', lat);
Xnew = shiftdim(X,2);
nc_varput ( fileout, 'sst', Xnew);
nc_attput ( fileout, 'sst', '_FillValue', -999);
nc_attput ( fileout, 'sst', 'missing_value', -999);


% file = 'video.nc';
% mode = netcdf.getConstant('CLASSIC_MODEL');
% %mode = bitor(mode,netcdf.getConstant('CLASSIC_MODEL'));
% f = netcdf.create(file, mode);
% nlat = 256;
% nlon = 512 ;
% lat_did = netcdf.defDim(f,'lat',nlat);
% lon_did = netcdf.defDim(f,'lon',nlon);
% yr_did = netcdf.defDim(f,'nyrs',21);
% f_did = netcdf.defDim(f,'nf',22);
% %define variables
% lat_vid = netcdf.defVar(f,'lat','double',lat_did);
% lon_vid = netcdf.defVar(f,'lon','double',lon_did);
% sst_vid = netcdf.defVar(f,'sst','double',[lat_did lon_did yr_did f_did]);
% netcdf.close(f);
% nc_varput(file,'lat',lat');
% nc_varput(file,'lon',lon');
% nc_varput(file,'sst',X);
% ncdump(file)
% for i=1:22
%     dd{i} = mean(sst(:,:,s_ind(i):f_ind(i)),3);
% end
% aug = sst(:,:,1:ndays:end);
% a2 = sst(:,:,1+step:ndays:end);
% a3 = sst(:,:,1+(2*step):ndays:end);
% a3 = sst(:,:,1+(4*step):ndays:end);s