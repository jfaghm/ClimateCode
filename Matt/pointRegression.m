function [ regressionMatrix, corrMatrix  ] = pointRegression( data )
%This function is used to calculate the linear regression coefficients for
%each point spatially in the data set that is provided.  
%   This function takes in a three dimensional matrix (latxlonxtime).  and
%   outputs another three dimensional matrix, where the first and second
%   dimensions are latitude and longitude respectively, and the third
%   dimension is of size 2, one for the intercept, and one for the slope.
if size(data, 1) == 512
    data = permute(data, [2 1 3]);
end
%%%%%%%%%%%%%%%%%%%%%%CALCULATE INDEX%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sst = ncread('/project/expeditions/jfagh/data/ersstv3/ersstv3_1948_2010_mon_anomalies.nc', 'sst');
sst = squeeze(sst);
sst = permute(sst, [2 1 3]);
sst = sst(:, :, (31*12)+1:end); %get 1979 - present
box_north = 52; 
box_south = -6;
box_west = 140;
box_east = 270;
box_row =5;
box_col = 18; 
lat=-88:2:88;
lon=0:2:358;
addpath('../sst_project/')
index = zeros(size(data, 3) / 12, 1);
month = 1;
year = 1;
annualSST = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
for i = 1:12:size(data, 3)
    annualSST(:, :, year) = nanmean(sst(:, :, i+7:i+9), 3);
    year = year+1;
end
for i = 1:12:size(data, 3)
     index(month) = buildIndex(annualSST(:, :, month), box_north, box_south, box_west, box_east, lat, lon, box_row, box_col);
     month = month+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%EXTRACT YEARLY DATA%%%%%%%%%%%%%%%%%%%
yearlyData = zeros(size(data, 1), size(data, 2), size(data, 3)/12, 1);
i = 1;
for month = 1:12:size(data, 3)
    yearlyData(:, :, i) = nanmean(data(:, :, month+7:month+9), 3);    
    i = i+1;
end
regressionMatrix = zeros(size(data, 1), size(data, 2), 3);
if matlabpool('size') == 0
    matlabpool open;
end
%%%%%%%%%%%%%%%%%%%%GET REGRESSION COEFFICIENTS AND P-VALUES%%%%
parfor i = 1:size(data, 1)
    bflRow = zeros(1, size(data, 2), 3);
    for j = 1:size(data, 2)
        yd = squeeze(yearlyData(i, j, :));
        
        if isnan(yd(1)) == true
            bflRow(1, j, 1) = NaN;
            bflRow(1, j, 2) = NaN;
            bflRow(1, j, 3) = 1;
            continue
        end        
        s = regstats(yd, index, 'linear', 'beta');
        bflRow(1, j, 1) = s.beta(1); %intercept
        bflRow(1, j, 2) = s.beta(2); %slope
        bflRow(1, j, 3) = 0;%s.tstat.pval; %pvalue
    end
    regressionMatrix(i, :, :) = bflRow;
end
%%%%%%%%%%%GET CORRELATION COEFFICIENTS%%%%%%%%%%%%%%%%%%%%%%%%%%
corrMatrix = zeros(size(data, 1), size(data, 2));
parfor i = 1:size(data, 1)
    corrRow = zeros(1, size(data, 2));
    for j = 1:size(data, 2)
        corrRow(1, j) = corr(index, squeeze(yearlyData(i, j, :)));
    end
    corrMatrix(i, :) = corrRow;
end

end






