function [index, cc] = sstBoxOtherVal(otherData, otherLat, otherLon)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load /project/expeditions/lem/ClimateCode/Matt/matFiles/flippedSSTAnomalies.mat;

if size(otherData, 3) ~= 384
    error('data must only contain years 1979-2010');
end

count = 1;
sstMean = zeros(size(sst, 1), size(sst, 2), size(sst, 3)/12);
otherMean = zeros(size(otherData, 1), size(otherData, 2), size(otherData, 3)/12);
for i = 1:12:size(otherData, 3)
    sstMean(:, :, count) = nanmean(sst(:, :, i+2:i+9), 3);
    otherMean(:, :, count) = nanmean(otherData(:, :, i+2:i+9), 3);
    count = count+1;
end

box_north = 36;
box_south = -6;
box_west = 140;
box_east = 270;

box_row = 5;
box_col = 10;

index = indexHelper(sstMean, otherMean, box_north, box_south, box_west, ...
    box_east, sstLat, sstLon, otherLat, otherLon, box_row, box_col);

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat
cc(1) = corr(index, aso_ace);
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ntc);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_tcs);

end

function index = indexHelper(sst, other, box_north, box_south, box_west,...
    box_east, sstLat, sstLon, otherLat, otherLon, box_row, box_col)

box_north = double(box_north);
box_south = double(box_south);
box_west = double(box_west);
box_east = double(box_east);
sstLat = double(sstLat);
sstLon = double(sstLon);
otherLat = double(otherLat);
otherLon = double(otherLon);


if ismember(box_north, sstLat)
   [~, northRow] = ismember(box_north, sstLat);
   [~, southRow] = ismember(box_south, sstLat);
else
    warning('Bad lat input! Taking closest values');
    northRow = closestIndex(sstLat, box_north);
    southRow = closestIndex(sstLat, box_south);
end
if ismember(box_east, sstLon)
   [~, eastCol] = ismember(box_east, sstLon);
   [~, westCol] = ismember(box_west, sstLon);
else
    warning('Bad lon input!  Taking closest values');
    eastCol = closestIndex(sstLon, box_east);
    westCol = closestIndex(sstLon, box_west);
end
annual_pacific = double(sst(northRow:southRow,westCol:eastCol,:));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_sst_pacific = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns
index = zeros(size(mean_box_sst_pacific, 3), 1);
sst_lat_region = sstLat(sstLat >= box_south & sstLat <= box_north);
sst_lon_region = sstLon(sstLon >= box_west & sstLon <= box_east);
for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
   otherLatIndex = closestIndex(otherLat, sst_lat_region(I(t)));
   otherLonIndex = closestIndex(otherLon, sst_lon_region(J(t)));
   otherLatIndex2 = closestIndex(otherLat, sst_lat_region(I(t)) - ((box_row-1) * 2));
   otherLonIndex2 = closestIndex(otherLon, sst_lon_region(J(t)) + ((box_col-1) * 2));
   
   %plotBoxes(other, sst, box_north, box_south, box_east, box_west...
   %    ,otherLat, otherLon, sstLat, sstLon, I(t), J(t), box_row, box_col);
   
   index(t) = nanmean(nanmean(other(otherLatIndex:otherLatIndex2, otherLonIndex...
       :otherLonIndex2, t)));
   
end

end

function plotBoxes(other, sst, box_north, box_south, box_east, ...
    box_west, otherLat, otherLon, sstLat, sstLon, I, J, box_row, box_col)

northRow = closestIndex(otherLat, box_north);
southRow = closestIndex(otherLat, box_south);
eastCol = closestIndex(otherLon, box_east);
westCol = closestIndex(otherLon, box_west);

sst_lat_region = sstLat(sstLat >= box_south & sstLat <= box_north);
sst_lon_region = sstLon(sstLon >= box_west & sstLon <= box_east);

otherLatIndex1 = closestIndex(otherLat, sst_lat_region(I));
otherLatIndex2 = closestIndex(otherLat, sst_lat_region(I) - (box_row - 1) * 2);
otherLonIndex1 = closestIndex(otherLon, sst_lon_region(J));
otherLonIndex2 = closestIndex(otherLon, sst_lon_region(J) + (box_col-1) * 2);

sstLatIndex1 = closestIndex(sstLat, sst_lat_region(I));
sstLatIndex2 = closestIndex(sstLat, sst_lat_region(I) - (box_row - 1) * 2);
sstLonIndex1 = closestIndex(sstLon, sst_lon_region(J));
sstLonIndex2 = closestIndex(sstLon, sst_lon_region(J) + (box_col-1) * 2);

other(otherLatIndex1:otherLatIndex2, otherLonIndex1:otherLonIndex2, :) = NaN;

close all
figure(1);
worldmap([box_south, box_north], [box_west, box_east]);
title('Other Variable');
pcolorm(otherLat, otherLon, other(:, :, 1));
geoshow('landareas.shp', 'FaceColor', [.25 .2 .15]);

figure(2)
worldmap([box_south, box_north], [box_west, box_east]);
title('SST');
sst(sstLatIndex1:sstLatIndex2, sstLonIndex1:sstLonIndex2, :) = NaN;
pcolorm(sstLat, sstLon, sst(:, :, 1));
geoshow('landareas.shp', 'FaceColor', [.25, .2, .15]);

end

function val = closestVal(A, x)
[~,ind] = min(abs(A-x));
val = A(ind);
end

function index = closestIndex(A, x)
    [~,index] = min(abs(A-x));
end