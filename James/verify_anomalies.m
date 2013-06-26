%verify sst anomalies
load('/project/expeditions/jfagh/data/norway/jfa005/data/mac_backup/jamesfaghmous/Documents/MATLAB/data/sst/erSSTV3Ind.mat')
dates_ind = erDates >=194800 & erDates <=201100;
sst =erSST(:,:,dates_ind);

for i=1:12
    mon_data = sst(:,:,[i:12:end]);
    mon_mean(:,:,i) = nanmean(mon_data,3);
    mon_std(:,:,i) = std(mon_data,1,3);
end

mon_anoms_1948 = sst - repmat(mon_mean,[1 1 size(sst,3)/12]);
load /project/expeditions/ClimateCodeMatFiles/ersstv3Anom.mat
a = buildSSTLonDiff(getAnnualSSTAnomalies(6, 10, 1979, 2010),sstLat,sstLon);
load 'asoHurricaneStats'
corr(a,aso_tcs)