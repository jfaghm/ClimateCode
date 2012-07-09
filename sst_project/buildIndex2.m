%buildIndex
%Input: 
% sst_a: Sea Surface Temperature anomaly data
% box_south, box_noth, box_east, box_west: the south, north, east, west
% boundaries of the search space
% box_col, box_row: the width and height of the box we average SSTA over.
% unites are grid points so box_row =2 means a box height of 2 x
% data_resolution for example 2x 2.5 = 5 degrees
%Output:
% index: a 1-d array with the longitude of the box with the highest
% anomaly
function index = buildIndex2(sst_a,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col)

if ismember(box_north, lat)
   [~, northRow] = ismember(box_north, lat);
   [~, southRow] = ismember(box_south, lat);
else
    error('Bad lat input!');
end
if ismember(box_east, lon)
   [~, eastCol] = ismember(box_east, lon);
   [~, westCol] = ismember(box_west, lon);
else
    error('Bad lat input!');
end
annual_pacific = double(sst_a(southRow:northRow,westCol:eastCol,:));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end
 
mean_box_sst_pacific = ss(round(box_row/2):end-round(box_row/2),round(box_col/2):end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns

for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
   [minValues(t), minLoc(t)] = min(current(:));
   [minI(t), minJ(t)] = ind2sub(size(current), minLoc(t));
end


lon_region = lon(lon >= box_west & lon <= box_east);
lat_region = lat(lat >= box_south & lat <= box_north);

%index = lon_region(J); %1.25 correlation
%index = lon_region(J) - lon_region(minJ); %1.15 correlation
%index = lon_region(J) .* values'; %1.2 correlation
%index = lon_region(J) .* minValues'; %2.06 correlation
%index = lon_region(minJ); %-.35 correlation
%index = lat_region(I); %-1.3 correlation
%index = lat_region(minI); % 1.83 correlation
index = lat_region(minI) + lon_region(J) .* minValues'; %2.42 correlation
%index = lat_region(minI) .* lon_region(J) .* minValues'; %.23 correlation



end