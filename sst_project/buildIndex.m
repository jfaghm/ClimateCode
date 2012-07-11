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
function index = buildIndex(sst_a,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col, func)

%Let the user decide if they want the maximum or minimum valued box.  If
%not specified by the user, then use max by default
if nargin == 9
    func = @max;
end

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

mean_box_sst_pacific = ss(round(box_row/2)+1:end-round(box_row/2),round(box_col/2)+1:end-round(box_col/2),:)./(box_row*box_col);%sub_sum pads the matrix so we can ignore the outer rows/columns

for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = func(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
end
lon_region = box_west:box_east;
index = lon_region(J);


