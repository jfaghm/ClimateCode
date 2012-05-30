%correlate, regress, and MIC with SST Tropical Anomaly
clear
close all
load('/project/expeditions/jfagh/code/matlab/sst_project/results/dist_index_apl_nov.mat')
file_name = '/project/expeditions/jfagh/data/era_int_1979/surface/sst_tropical_anomalies.nc';
save_path = '/project/expeditions/jfagh/code/matlab/sst_project/results/index_vs_sst_reg/';
ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_data = netcdf.inqVarID(ncid,'var34');
varid_lat = netcdf.inqVarID(ncid,'lat');
varid_lon = netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid,varid_lon);
lon(lon>180) = lon(lon>180)-360;
lat = netcdf.getVar(ncid,varid_lat);
sst = netcdf.getVar(ncid,varid_data);
sst(sst==min(min(min(sst))))=NaN;
sst = double(permute(sst,[2 1 3]));



figure('visible','off')
worldmap world
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
count = 1;
months ={'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};
for m_s=5:12
    for m_e=m_s:12
        parfor y=1:length(dist_index)
            start = m_s+((y-1)*12);
            finish = m_e+((y-1)*12);
            seasonal_sst(:,:,y) = nanmean(sst(:,:,m_s+((y-1)*12):m_e+((y-1)*12)),3);
        end
    [r(:,:,count),mse(:,:,count),rSqr(:,:,count)] = pointReg(seasonal_sst,dist_index,'linear');
    clmo('surface')
    pcolorm(lat,lon,r(:,:,count))
    title(['Regression Coefficents Between Apr-Nov Index and ' months{m_s} '-' months{m_e} ' SST'])
    %caxis([-1 1]);
    colorbar('EastOutside')
    print('-dpdf', '-r400',strcat(save_path,'corr_',months{m_s},'_',months{m_e}));
    count = count+1;
    end
end

