%builds the new pacific index, varying the start and end month
tic
clear
close all
load('/project/expeditions/haasken/data/stormData/atlanticStorms/condensedHurDat.mat')



load('/project/expeditions/jfagh/data/norway/jfa005/data/mac_backup/jamesfaghmous/Documents/MATLAB/data/modoki/nino_indices.mat');
load /project/expeditions/haasken/data/stormData/atlanticStorms/HurDat_1851_2010.mat


file_name = '/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc';
ncid = netcdf.open(file_name,'NC_NOWRITE');
varid_sst = netcdf.inqVarID(ncid,'sst');
sst_1971_2010 =  squeeze(netcdf.getVar(ncid,varid_sst));
sst_1971_2010(sst_1971_2010==-999)=NaN;
sst_1971_2010 = permute(sst_1971_2010,[2 1 3])./100;
sst_1971_2010 = sst_1971_2010(:,:,(23*12)+1:end);
netcdf.close(ncid);



%test month ranges
count2=1;
for season_start = 1:12
    for season_end = 1:12
        count = 1;
        for i =1:12:size(sst_1971_2010,3)
            annual_sst(:,:,count) = nanmean(sst_1971_2010(:,:,i+(season_start-1):i+(season_end-1)),3);
            count = count+1;
        end
        season{season_start,season_end} = annual_sst; %this contains the mean SST anomaly for range = strat_month:end_month
        start{count2} = season_start;
        finish{count2} = season_end;
        count2 = count2+1;
    end
end

%these are the parameters that affect the quality of the index
%search space
box_north = 36;
box_south = -6;
box_west = 140;
box_east = 270;
%box size
box_row =5;
box_col = 20;

%these are the lats and lons of the data, they never change
lat=-88:2:88;
lon=0:2:358;

for i=1:11
    for  j=1:11
        if(~isempty(season{i,j}))
            index{i,j} = buildIndex(season{i,j},box_north,box_south,box_west,box_east,lat,lon,box_row,box_col);
            %SHORTEN Time series TO GO FROM 1979%
            index{i,j} = index{i,j}(9:end);
        end
    end
end

year = 1979:2010;
%these are all quantites we want to correlate against and have nothing to
%do with building the index
for i=1:length(year)
    %seasonal = 6,7,8,9,10 (June-Oct)
    seasonal_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i),11))/10^7;
    seasonal_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i),12))/10^5;
    seasonal_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
    seasonal_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=6&condensedHurDat(:,2)<=10 ,10));
    %seasonal_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 6:10);
    
    %as = Aug-Sep
    %jaso = July-October
    as_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9 ,10));
    aso_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    jaso_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10 ,10));
    jas_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9 ,10));
    
    as_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9 ,10));
    aso_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10 ,10));
    jaso_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10 ,10));
    jas_major_hurricanes(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9 ,10));
    
    as_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9,12))/10^5;
    aso_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,12))/10^5;
    jaso_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10,12))/10^5;
    jas_ace(i) = sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9,12))/10^5;
    
    as_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9,11))/10^7;
    aso_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10,11))/10^7;
    jaso_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=10,11))/10^7;
    jas_pdi(i)=sum(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=7&condensedHurDat(:,2)<=9,11))/10^7;
    %{
    as_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 8:9);
    aso_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 8:10);
    jaso_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 7:10);
    jas_ntc(i) = computeNTC(hurDat, [1950 2000 ], [ year(i) year(i) ], 'countDuplicates', true, 'months', 7:9);
    %}
    seasonal_mdr_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=6&condensedHurDat(:,2)<=10&condensedHurDat(:,6)>=5&condensedHurDat(:,6)<=30&condensedHurDat(:,7)>=-80&condensedHurDat(:,7)<=-15 ,10));
    as_mdr_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=9&condensedHurDat(:,6)>=5&condensedHurDat(:,6)<=30&condensedHurDat(:,7)>=-80&condensedHurDat(:,7)<=-15 ,10));
    aso_mdr_tcs(i) = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,2)>=8&condensedHurDat(:,2)<=10&condensedHurDat(:,6)>=5&condensedHurDat(:,6)<=30&condensedHurDat(:,7)>=-80&condensedHurDat(:,7)<=-15 ,10));
    
end

for i=1:11
    for j=i:11
        cc11(i,j) = corr(index{i,j}', aso_tcs');
        cc12(i,j) = corr(index{i,j}', aso_major_hurricanes');
        cc13(i,j) = corr(index{i,j}', aso_ace');
        cc14(i,j) = corr(index{i,j}', aso_pdi');
        %cc15(i,j) = corr(index{i,j}', aso_ntc');
    end
end

toc
