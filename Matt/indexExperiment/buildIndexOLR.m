function [ccminLat, ccminLon, ccmaxLat, ccmaxLon]...
    = buildIndexOLR(startMonth, endMonth, plotBox)
%This function computes the outgoing longwave radiation index.  For this
%index, we look for the box that has the lowest OLR value, and then return
%its location.
%
%--------------------------Input------------------------------------------
%
%--->startMonth - the lower bound of the month range for which we average
%OLR anomaly data.
%--->endMonth - the upper bound of the month range for which we average OLR
%anomal data.
%--->plotBox - a boolean value that determines whether or not we plot the
%box with the lowest OLR on the whole OLR map.  This is fairly time
%consuming, so use with caution
%
%--------------------------Output---------------------------------------
%
%--->cc - a vector containing the correlation coefficients between the
%index and 5 hurricane statistics.

    olr = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'olr');
    time = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'time');
    lat = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'lat');
    lon = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'lon');
    if matlabpool('size') == 0
        matlabpool open
    end
    olr = permute(olr, [2, 1, 3]);
    addpath('/project/expeditions/lem/ClimateCode/Matt/');
    addpath('/project/expeditions/lem/ClimateCode/sst_project/');
    
    dates = zeros(size(olr, 3), 4);
    parfor i = 1:size(dates, 1);
        dates(i, :) = hoursToDate(time(i), 1,  1, 1);
    end
    
    %get data between 1979-2010 only
    olr = olr(:, :, dates(:, 4) >= 1979);
    dates = dates(dates(:, 4) >= 1979, :);
    lastYear = find(dates(:, 4) == 2010);
    olr = olr(:, :, 1:lastYear(end));
    dates = dates(1:lastYear(end), :);
    
    %compute anomalies
    for i = 1:12
        currentMonth = olr(:, :, dates(:, 3) == i);
        olr(:, :, dates(:, 3) == i) = currentMonth -...
            repmat(nanmean(currentMonth, 3), [1, 1, size(currentMonth, 3)]);
    end
    
    %average startMonth - endMonth
    startYear = find(dates(:, 4) == 1979);
    count = 1;
    annualOLR = zeros(size(olr, 1), size(olr, 2), size(olr, 3)/12);
    for i = startYear(1):12:size(olr, 3)
        annualOLR(:, :, count) = nanmean(olr(:, :, i+(startMonth-1):i+(endMonth-1)), 3);
        count = count+1;
    end
    box_north = 35;
    box_south = -5;
    
    box_west = 140;
    box_east = 270;
    box_row =5;
    box_col = 10;
    
    %build the index
    index = buildIndexHelper(annualOLR(:, :, 1:end), box_north, box_south, box_west,...
        box_east, lat, lon, box_row, box_col, plotBox);
        
    %correlate
    ccminLat = correlateAgainstHurr(index.minLat, 1, length(index.minLat));
    ccminLon = correlateAgainstHurr(index.minLon, 1, length(index.minLon));
    ccmaxLon = correlateAgainstHurr(index.maxLon, 1, length(index.maxLon));
    ccmaxLat = correlateAgainstHurr(index.maxLat, 1, length(index.maxLat));
end

function cc = correlateAgainstHurr(index, lower, upper)
    load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
    cc(1) = corr(index, aso_tcs(lower:upper));
    cc(2) = corr(index, aso_major_hurricanes(lower:upper));
    cc(3) = corr(index, aso_ntc(lower:upper));
    cc(4) = corr(index, aso_pdi(lower:upper));
    cc(5) = corr(index, aso_ace(lower:upper));
end

function index = buildIndexHelper(sst_a,box_north,box_south,box_west,...
    box_east,lat,lon,box_row,box_col, plotBox)

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

annual_pacific = double(sst_a(northRow:southRow,westCol:eastCol,:));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_sst_pacific = ss(box_row:end-box_row+1, box_col:end-box_col+1, :) ./ (box_row * box_col);
for t = 1:size(mean_box_sst_pacific,3)
   current = mean_box_sst_pacific(:,:,t);
   [values(t) loc(t)] = max(current(:));
   [I(t),J(t)] = ind2sub(size(current),loc(t));
   [minValues(t), minLoc(t)] = min(current(:));
   [minI(t), minJ(t)] = ind2sub(size(current), minLoc(t));
   
end

lon_region = lon(lon >= box_west & lon <= box_east);
lat_region = lat(lat >= box_south & lat <= box_north);
index = struct('maxLat', lat_region(I), 'maxLon', lon_region(J), ...
    'minLon', lon_region(minJ), 'minLat', lat_region(minI));

if plotBox == true
load ../matFiles/condensedHurDat.mat;
year = 1979:2010;
figure('visible','off')
 for i =1:length(year)
     fig(figure(1), 'units', 'inches', 'width', 8, 'height', 8)
     clmo('surface')
     clmo('Line')
     worldmap([-20 20],[140 -90])
     worldmap world
     setm(gca,'Origin',[0 180])
     pcolorm(double(lat),double(lon),double(sst_a(:,:,i)))
     geoshow('landareas.shp', 'FaceColor', [0.25 0.20 0.15])
     current_lon = lon_region(J(i));
     current_lat = lat_region(I(i));
     grid_size = 2.5;
     %%%%%%%%%%%%%%%%%%%%%%% plot box
     %box_lat1 = current_lat - (grid_size*round(box_row/2));
     %box_lat2 = current_lat + (grid_size*round(box_row/2));
     %box_lon1 = current_lon - (grid_size*round(box_col/2));
     %box_lon2 = current_lon + (grid_size*round(box_col/2));
     box_lat1 = current_lat;
     box_lat2 = current_lat - grid_size * box_row;
     box_lon1 = current_lon;
     box_lon2 = current_lon + grid_size * box_col; 
     [lat1,lon1] = track2('rh',box_lat1,box_lon1,box_lat2,box_lon1);
     [lat2,lon2] = track2('rh',box_lat2,box_lon1,box_lat2,box_lon2);
     [lat3,lon3] = track2('rh',box_lat2,box_lon2,box_lat1,box_lon2);
     [lat4,lon4] = track2('rh',box_lat1,box_lon1,box_lat1,box_lon2);
     plotm(double(lat1),double(lon1),'k-')
     plotm(double(lat2),double(lon2),'k-')
     plotm(double(lat3),double(lon3),'k-')
     plotm(double(lat4),double(lon4),'k-')
     %%%%%%%%%%%%%%%%%%%%%%%%%%% plot search space box
     [lat1, lon1] = track2('rh', box_south, box_west, box_north, box_west);
     [lat2, lon2] = track2('rh', box_north, box_west, box_north, box_east);
     [lat3, lon3] = track2('rh', box_north, box_east, box_south, box_east);
     [lat4, lon4] = track2('rh', box_south, box_west, box_south, box_east);
     plotm(double(lat1), double(lon1), 'k--');
     plotm(double(lat2), double(lon2), 'k--');
     plotm(double(lat3), double(lon3), 'k--');
     plotm(double(lat4), double(lon4), 'k--');
     
     %caxis([-5 5])
     colorbar('EastOutside');
     num_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=1&condensedHurDat(:,10)<=3 ,10));
     num_major_hurricanes = length(condensedHurDat(condensedHurDat(:,1)==year(i)&condensedHurDat(:,10)>=4 ,10));
     all_storms = length(condensedHurDat(condensedHurDat(:, 1) == year(i)&condensedHurDat(:,10) >= 0));
     title([num2str(year(i)) ': ' num2str(all_storms) ' JJASO TCs - ' num2str(num_hurricanes) ' hurricanes - ' num2str(num_major_hurricanes) ' major hurricanes'])
     %print('-dpdf', '-r350',strcat('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/max_sst_location_10_by_40_location_minus_30_w_hurricanes',num2str(i)))
     print('-dpdf', '-r400', ['/project/expeditions/lem/ClimateCode/Matt/indexExperiment/results/olr/max_olr_location_10_by_40_location_minus_30_w_hurricanes' num2str(i)]);
 end
end
end

