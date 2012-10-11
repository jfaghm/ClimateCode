function [index, cc] = findBoxUseOtherVal(firstData, firstLat, firstLon,...
    secondData, secondLat, secondLon, func)
%This function takes in two data sets.  It finds either the max or min
%average box (specified by the func parameter), and then takes the location
%of that box and averages the second dataset within that same box.
if size(firstData, 3) ~= size(secondData, 3)
    error('data sets must have same dates');
end

count = 1;
firstMean = zeros(size(firstData, 1), size(firstData, 2), size(firstData, 3)/12);
secondMean = zeros(size(secondData, 1), size(secondData, 2), size(secondData, 3)/12);
for i = 1:12:size(firstData, 3)
    firstMean(:, :, count) = nanmean(firstData(:, :, i+2:i+9), 3);
    secondMean(:, :, count) = nanmean(secondData(:, :, i+2:i+9), 3);
    count = count+1;
end

box_north = closestVal(firstLat, 36);
box_south = closestVal(firstLat, -6);
box_west = closestVal(firstLon, 140);
box_east = closestVal(firstLon, 270);

box_row = 5;
box_col = 7;

index = indexHelper(firstMean, secondMean, box_north, box_south, box_west, ...
    box_east, firstLat, firstLon, secondLat, secondLon, box_row, box_col, func);

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat
cc(1) = corr(index, aso_ace);
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ntc);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_tcs);

end

function index = indexHelper(first, second, box_north, box_south, box_west,...
    box_east, firstLat, firstLon, secondLat, secondLon, box_row, box_col, func)

box_north = double(box_north);
box_south = double(box_south);
box_west = double(box_west);
box_east = double(box_east);
firstLat = double(firstLat);
firstLon = double(firstLon);
secondLat = double(secondLat);
secondLon = double(secondLon);


if ismember(box_north, firstLat)
   [~, northRow] = ismember(box_north, firstLat);
   [~, southRow] = ismember(box_south, firstLat);
else
    warning('Bad lat input! Taking closest values');
    northRow = closestIndex(firstLat, box_north);
    southRow = closestIndex(firstLat, box_south);
end
if ismember(box_east, firstLon)
   [~, eastCol] = ismember(box_east, firstLon);
   [~, westCol] = ismember(box_west, firstLon);
else
    warning('Bad lon input!  Taking closest values');
    eastCol = closestIndex(firstLon, box_east);
    westCol = closestIndex(firstLon, box_west);
end
annual_pacific = double(first(northRow:southRow,westCol:eastCol,:));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_sst_pacific = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns
index = zeros(size(mean_box_sst_pacific, 3), 1);
sst_lat_region = firstLat(firstLat >= box_south & firstLat <= box_north);
sst_lon_region = firstLon(firstLon >= box_west & firstLon <= box_east);
res = spatialResolution(firstLat);
for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = func(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
   otherLatIndex = closestIndex(secondLat, sst_lat_region(I(t)));
   otherLonIndex = closestIndex(secondLon, sst_lon_region(J(t)));
   otherLatIndex2 = closestIndex(secondLat, sst_lat_region(I(t)) - ((box_row-1) * res));
   otherLonIndex2 = closestIndex(secondLon, sst_lon_region(J(t)) + ((box_col-1) * res));
   
   %plotBoxes(second, first, box_north, box_south, box_east, box_west,...
   %    secondLat, secondLon, firstLat, firstLon, I(t), J(t), box_row, box_col);
   
   index(t) = nanmean(nanmean(second(otherLatIndex:otherLatIndex2, otherLonIndex...
       :otherLonIndex2, t)));
   
end

end

function plotBoxes(second, first, box_north, box_south, box_east, ...
    box_west, secondLat, secondLon, firstLat, firstLon, I, J, box_row, box_col)

res = spatialResolution(firstLat);

northRow = closestIndex(secondLat, box_north);
southRow = closestIndex(secondLat, box_south);
eastCol = closestIndex(secondLon, box_east);
westCol = closestIndex(secondLon, box_west);

sst_lat_region = firstLat(firstLat >= box_south & firstLat <= box_north);
sst_lon_region = firstLon(firstLon >= box_west & firstLon <= box_east);

otherLatIndex1 = closestIndex(secondLat, sst_lat_region(I));
otherLatIndex2 = closestIndex(secondLat, sst_lat_region(I) - (box_row - 1) * res);
otherLonIndex1 = closestIndex(secondLon, sst_lon_region(J));
otherLonIndex2 = closestIndex(secondLon, sst_lon_region(J) + (box_col-1) * res);

sstLatIndex1 = closestIndex(firstLat, sst_lat_region(I));
sstLatIndex2 = closestIndex(firstLat, sst_lat_region(I) - (box_row - 1) * res);
sstLonIndex1 = closestIndex(firstLon, sst_lon_region(J));
sstLonIndex2 = closestIndex(firstLon, sst_lon_region(J) + (box_col-1) * res);

second(otherLatIndex1:otherLatIndex2, otherLonIndex1:otherLonIndex2, :) = NaN;

close all
figure(1);
worldmap([box_south, box_north], [box_west, box_east]);
title('Other Variable');
pcolorm(secondLat, secondLon, second(:, :, 1));
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15]);

figure(2)
worldmap([box_south, box_north], [box_west, box_east]);
title('SST');
first(sstLatIndex1:sstLatIndex2, sstLonIndex1:sstLonIndex2, :) = NaN;
pcolorm(firstLat, firstLon, first(:, :, 1));
geoshow('landareas.shp', 'FaceColor', [.25, .2, .15]);

end

function val = closestVal(A, x)
[~,ind] = min(abs(A-x));
val = A(ind);
end

function index = closestIndex(A, x)
    [~,index] = min(abs(A-x));
end

function res = spatialResolution(lat)
    total = 0;
    for i = 1:length(lat)-1
        total = total + abs(lat(i+1) - lat(i));
    end
    res = total/length(lat);
end