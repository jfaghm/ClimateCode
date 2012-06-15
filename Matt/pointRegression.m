function [ bestFitLines  ] = pointRegression( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if size(data, 1) == 512
    data = permute(data, [2 1 3]);
end
time = ncread('/project/expeditions/lem/data/sst_slp_eraInterim_1979-2010.nc', 'time');
dates = zeros(size(time, 1), 4);

for i = 1:size(time, 1)
   dates(i, :) = hoursToDate(time(i), 1, 1979);
end
yearlyData = zeros(size(data, 1), size(data, 2), size(data, 3)/12, 1);
i = 1;
for month = 1:12:size(data, 3)
    yearlyData(:, :, i) = data(:, :, month);
    i = i+1;
end
[~,~,index] = getPosNegYearsIndex();
bestFitLines = zeros(size(data, 1), size(data, 2), 2);
parfor i = 1:size(data, 1)
    bflRow = zeros(1, size(data, 2), 2);
    for j = 1:size(data, 2)
        p = polyfit(index, squeeze(yearlyData(i, j, :)), 1);
        bflRow(1, j, 1) = p(1);
        bflRow(1, j, 2) = p(2);
    end
    bestFitLines(i, :, :) = bflRow;
end


end

