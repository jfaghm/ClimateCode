%builds the new pacific index
clear
close all
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat');

load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat


file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc';
ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_sst = netcdf.inqVarID(ncid,'sst');
sst_1971_2010 =  squeeze(netcdf.getVar(ncid,varid_sst));
sst_1971_2010(sst_1971_2010==-999)=NaN;
sst_1971_2010 = permute(sst_1971_2010,[2 1 3])./100;
sst_1971_2010 = sst_1971_2010(:,:,(23*12)+1:end);
netcdf.close(ncid);


count = 1;
for i =1:12:size(sst_1971_2010,3)
    annual_sst(:, :, count) = nanmean(sst_1971_2010(:,:,i+(4-1):i+(11-1)),3);
    count = count+1;
end



box_north = 10;
box_south = -10;
box_west = 140;
box_east = 270;
box_row =5;
box_col = 20;
lat=-88:2:88;
lon=0:2:358;
count = 1;
i = 1; 
for box_north = 60:-2:10
    j = 1;
    for box_south = -10:-2:-60
        index{i, j} = buildIndex(annual_sst, box_north, box_south, box_west, box_east, lat, lon, box_row, box_col);
        index{i, j} = index{i, j}(9:end);
        j = j+1;
    end    
    i = i+1;
end

year = 1979:2010;
parfor i=1:length(year)
    aso_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    aso_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    aso_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,12))/10^5;
    aso_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,11))/10^7;
    aso_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 8:10);  
end


for i=1:size(index,1)
    for j = 1:size(index, 2)
        cc11(i, j) = corr(index{i, j}', aso_tcs');
        cc12(i, j) = corr(index{i, j}', aso_major_hurricanes');
        cc13(i, j) = corr(index{i, j}', aso_ace');
        cc14(i, j) = corr(index{i, j}', aso_pdi');
        cc15(i, j) = corr(index{i, j}', aso_ntc');
    end
end