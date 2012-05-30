%correlate, regress, and MIC with other variables
clear
close all
load('/project/expeditions/jfagh/code/matlab/sst_project/results/dist_index_apl_nov.mat')
file_name = '/project/expeditions/data/era-interim/monthly/nc/zg500_1979-2011.nc';
current_var = 'z';
current_var_name = 'Geopotential height at 500hPa';
current_var_short = 'gph500';
save_path = strcat('/project/expeditions/jfagh/code/matlab/sst_project/results/index_vs_',current_var_short,'/');


ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_data = netcdf.inqVarID(ncid,current_var);
varid_lat = netcdf.inqVarID(ncid,'latitude');
varid_lon = netcdf.inqVarID(ncid,'longitude');
lon = double(netcdf.getVar(ncid,varid_lon));
lon(lon>180) = lon(lon>180)-360;
lat = double(netcdf.getVar(ncid,varid_lat));
var = squeeze(netcdf.getVar(ncid,varid_data));
var(var==min(min(min(var))))=NaN;
var = permute(var,[2 1 3]);

figure('visible','off')
worldmap world
geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
count = 1;
months ={'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};
for m_s=1:12
    for m_e=m_s:12
        parfor y=1:length(dist_index)
            start = m_s+((y-1)*12);
            finish = m_e+((y-1)*12);
            seasonal_var(:,:,y) = nanmean(var(:,:,m_s+((y-1)*12):m_e+((y-1)*12)),3);
        end
    r(:,:,count) = pointCorr(seasonal_var,dist_index);
    %[B(:,:,count),mse(:,:,count),rSqr(:,:,count)] = pointReg(seasonal_var,dist_index,'linear');
    clmo('surface')
    pcolorm(lat,lon,r(:,:,count))
    title(['Correlation Coefficents Between Apr-Nov Index and ' months{m_s} '-' months{m_e} ' ' current_var_name])
    caxis([-1 1]);
    colorbar('EastOutside')
    print('-dpdf', '-r400',strcat(save_path,'corr_',months{m_s},'_',months{m_e}));
    count = count+1;
    end
end