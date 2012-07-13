function [index, c] = buildIndexOLR()

    olr = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'olr');
    time = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'time');
    lat = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'lat');
    lon = ncread('/project/expeditions/lem/data/olr.mon.mean.nc', 'lon');
    if matlabpool('size') == 0
        matlabpool open
    end
    olr = permute(olr, [2, 1, 3]);
    addpath('../Matt');
    
    dates = zeros(size(olr, 3), 4);
    parfor i = 1:size(dates, 1);
        dates(i, :) = hoursToDate(time(i), 1,  1, 1);
    end
    
    olr = olr(:, :, dates(:, 4) >= 1979);
    dates = dates(dates(:, 4) >= 1979, :);
    lastYear = find(dates(:, 4) == 2010);
    olr = olr(:, :, 1:lastYear(end));
    dates = dates(1:lastYear(end), :);
    
    
    for i = 1:12
        currentMonth = olr(:, :, dates(:, 3) == i);
        olr(:, :, dates(:, 3) == i) = currentMonth - repmat(nanmean(currentMonth, 3), [1, 1, size(currentMonth, 3)]);
    end
    
    startYear = find(dates(:, 4) == 1979);
    count = 1;
    for i = startYear(1):12:size(olr, 3)
        annualOLR(:, :, count) = nanmean(olr(:, :, i+(4-1):i+(10-1)), 3);
        count = count+1;
    end
            
    box_north = 35;
    box_south = -5;
    box_west = 140;
    box_east = 270;
    box_row =5;
    box_col = 10;

    index = buildIndex(annualOLR, box_north, box_south, box_west, box_east, lat, lon, box_row, box_col, @min);
    
    years = 1979:2010;
    aso_tcs = zeros(length(years), 1);
    load /project/expeditions/lem/ClimateCode/Matt/matFiles/condensedHurDat.mat;
    
    for i = 1:length(years)
        aso_tcs(i) = length(condensedHurDat(condensedHurDat(:, 1) == years(i) & condensedHurDat(:, 2) >= 8 & condensedHurDat(:, 2) <= 10, 10));
    end
        
    c = corr(index, aso_tcs);

end