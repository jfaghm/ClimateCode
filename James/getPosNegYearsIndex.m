function [  negYears, posYears, index ] = ...
    getPosNegYearsIndex(startMonth, endMonth, sigma)
%-----------------------Method------------------------------------------
%
%This function calculates the index for each year.  The indices are then
%normalized, and a set of positive and negative yeras are returned that are
%at least sigma standard deviations away from the mean of the indices.
%Positive years are those that are associated with high hurricane activity,
%so in this case they are associated with low index values, because the
%spatial ENSO index negatively correlates with hurricane activity.
%
%-----------------------Input-------------------------------------------
%
%--->startMonth - the lower end of the range of months for which we average
%the SST anomaly data when computing the index.
%--->endMonth - the upper bound of the range of months for which we average
%the SST anomaly data when computing the index.
%--->sigma - the standard deviation threshold for which we choose the
%positive and negative years.
%
%-----------------------Output---------------------------------------------
%
%--->negYears - a vector containing all years that are associated with low
%hurricane activity
%--->posYears - a vector containing all years that are associated with high
%hurricane activity
%--->index - returns the actual index

load /project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat;

year = 1;
sstMean = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+startMonth - 1:i+endMonth - 1), 3); 
   year = year+1;
end

box_north = 36; 
box_south = -6;
box_west = 140;
box_east = 270;

%box size
box_row = 5;
box_col = 10; 

lat=-88:2:88;
lon=0:2:358;

addpath('/project/expeditions/lem/ClimateCode/sst_project/');
%index = buildIndex(sstMean, box_north, box_south, box_west, box_east, lat, lon, box_row, box_col, @max);

[index, maxI, maxJ, minI, minJ, maxValues, minValues] = ...
    buildSSTLon(sstMean, lat, lon);

index = index';
baseYear = 1979;
normalizedIndex = (index - mean(index)) ./ std(index);


%Positive years correspond to years with high hurricane activity.  In the
%case of the spatial ENSO index, those are the years with lower index
%values.
negYears = find(normalizedIndex >= sigma) + baseYear - 1;
posYears = find(normalizedIndex <= -sigma) + baseYear - 1;

end
