function [index, cc] = buildIndexVariations(indexNum, startMonth, endMonth, ...
    lowerBound, upperBound, westBound, eastBound)
%This function is a collection of all the various ways that we have
%experimented with our index.  You specifiy which index you want to compute
%by the indexNum parameter
%
%-----------------------------Input---------------------------------------
%
%--->indexNum - the number of the index that should be computed.  See
%switch statement bellow to see all variations.
%--->startMonth - the lower bound of the month range for which we average
%the anomaly data for each year.
%--->endMonth - the upper bound of the month range for which we average the
%anomaly data for each year.
%
%--------------------------Output-----------------------------------------
%
%--->index - the computed index specified by the indexNum
%--->cc - a vector containing correlation coefficients between the index
%and 5 hurricane statistics.

%data_path ='/project/expeditions/lem/ClimateCode/Matt/matFiles/';
data_path ='/Volumes/James@MSI/ClimateCodeMatFiles/';



load(strcat(data_path,'flippedSSTAnomalies.mat'));
load(strcat(data_path,'pressureAnomalies.mat'));
load(strcat(data_path,'olrAnomalies.mat'));
%indexMat = [];
year = 1;
for i = 1:12:size(olr, 3)
   sstMean(:, :, year) = nanmean(sst(:, :, i+startMonth - 1:i+endMonth - 1), 3); 
   pMean(:, :,year) = nanmean(pressure(:, :, i+startMonth-1:i+endMonth-1), 3);
   olrMean(:, :, year) = nanmean(olr(:, :, i+startMonth-1:i+endMonth-1), 3);
   year = year+1;
end

if nargin <= 3
    upperBound = 36;
    lowerBound = -6;
    westBound = 140;
    eastBound = 260;
end

box_north = sstLat(minIndex(sstLat, upperBound));
box_south = sstLat(minIndex(sstLat, lowerBound));
box_west = sstLon(minIndex(sstLon, westBound));
box_east = sstLon(minIndex(sstLon, eastBound));
box_row = 5;
box_col = 20;
[sstI, sstJ, sstValues] = buildIndexGeneric(sstMean, box_north, box_south, box_west, box_east, sstLat, sstLon, box_row, box_col);

sstLonRegion = sstLon(sstLon >= box_west & sstLon <= box_east);
sstLatRegion = sstLat(sstLat >=  box_south & sstLat <= box_north);


box_north = olrLat(minIndex(olrLat, 36));
box_south = olrLat(minIndex(olrLat, -6));
box_west = olrLon(minIndex(olrLon, 140));
box_east = olrLon(minIndex(olrLon, 260));

[olrI, olrJ, olrValues] = buildIndexGeneric(olrMean, box_north, box_south, box_west, box_east, olrLat, olrLon, 5, 10);
olrLonRegion = olrLon(olrLon >= box_west & olrLon <= box_east);
olrLatRegion = olrLat(olrLat >= box_south & olrLat <= box_north);

box_north = pressureLat(minIndex(pressureLat, 36));
box_south = pressureLat(minIndex(pressureLat, -6));
box_west = pressureLon(minIndex(pressureLon, 140));
box_east = pressureLon(minIndex(pressureLon, 260));
pressureLonRegion = pressureLon(pressureLon >= box_west & pressureLon <= box_east);
pressureLatRegion = pressureLat(pressureLat >= box_south & pressureLat <= box_north);

[pressureI, pressureJ, pressureValues] = buildIndexGeneric(pMean, box_north, box_south, box_west, box_east, pressureLat, pressureLon, box_row, box_col);

midpoint = box_west + ((box_east - box_west) / 2);

sstMaxVals = sstValues.max;
sstLon = sstLonRegion(sstJ.max);
sstBoxPress = sstBoxOtherVal(pressure, pressureLat, pressureLon, startMonth, endMonth);
sstBoxOLR = sstBoxOtherVal(olr, olrLat, olrLon, startMonth, endMonth);
olrMinVals = olrValues.min;
pressMinVals = pressureValues.min;

switch indexNum
    case 1
        index = sstLonRegion(sstJ.max); %-2.5984 correlation
    case 2 
        %index = olrLonRegion(olrJ.min);
        index = olrLatRegion(olrI.max);
    case 3
        %best if you average data Jan-Jul
        index = pressureLonRegion(pressureJ.min);
    case 4
        indexMatrix = [sstLonRegion(sstJ.max), olrLonRegion(olrJ.min), pressureLonRegion(pressureJ.max)];
        index = zeros(length(sstJ.max), 1);
        for i = 1:length(sstJ.max)
            [~, ind] = max(abs(indexMatrix(i, :) - midpoint)); %correlation 1.5938
            index(i) = indexMatrix(ind);
        end
    case 5
        indexMatrix = [sstLonRegion(sstJ.max), olrLonRegion(olrJ.min), pressureLonRegion(pressureJ.max)];
        index = zeros(length(sstJ.max), 1);
        for i = 1:length(sstJ.max)
            [~, ind] = min(abs(indexMatrix(i, :) - midpoint)); %correlation -1.0646
            index(i) = indexMatrix(ind);
        end
    case 6
        indexMatrix = [sstLonRegion(sstJ.max), olrLonRegion(olrJ.min), pressureLonRegion(pressureJ.max)];
        index = mean(indexMatrix, 2); %correlation -2.439
    case 7
        index = sstLonRegion(sstJ.max) + olrLonRegion(olrJ.min) + pressureLatRegion(pressureI.max);%correlation -0.935
    case 8
        index = sqrt(sstLonRegion(sstJ.max) + olrLonRegion(olrJ.min) + pressureLatRegion(pressureI.max)); %correlation -.957
    case 9
        indexMatrix = [sstLonRegion(sstJ.max), olrLonRegion(olrJ.min), pressureLonRegion(pressureJ.max)];
        index = std(indexMatrix, 0, 2);  %correlation .9616
    case 10
        indexMatrix = [sstLonRegion(sstJ.max), olrLonRegion(olrJ.min), pressureLonRegion(pressureJ.max)];
        index = range(indexMatrix, 2); %correlation 1.04424
    case 11
        index = sstLonRegion(sstJ.max) - pressureLonRegion(pressureJ.max); %correlation .0476
    case 12
        index = sstLonRegion(sstJ.max) + pressureLatRegion(pressureI.max) .* pressureValues.min' .* olrLonRegion(olrJ.max); %correlation -2.4309
    case 13
        %weightIndex function is defined below.
        index = weightIndex(sstLonRegion(sstJ.max), pressureLatRegion(pressureI.max), pressureValues.min); %correlation -3.22
    case 14
        index = sstLonRegion(sstJ.max) - sstLonRegion(sstJ.min); %correlation -3.0654
    case 15
        index = weightIndex(sstLonRegion(sstJ.max) - sstLonRegion(sstJ.min), pressureLatRegion(pressureI.max), pressureValues.min); %correlation -3.5534
    case 16
        index = weightIndex(.5*(sstLonRegion(sstJ.max) - sstLonRegion(sstJ.min)), pressureLatRegion(pressureI.max), pressureValues.min); %correlation -3.6935
    case 17
        index = weightIndex(.5*(sstLonRegion(sstJ.max) - .8*sstLonRegion(sstJ.min)), pressureLatRegion(pressureI.max), pressureValues.min); %correlation -3.6776
    case 18
        index = sstValues.max;
    case 19
        index = sstValues.min;
    case 20
        index = olrValues.max;
    case 21
        index = olrValues.min;
    case 22
        index = sstBoxOtherVal(olr, olrLat, olrLon, startMonth, endMonth);
    case 23
        index = sstBoxOtherVal(pressure, pressureLat, pressureLon, startMonth, endMonth);
    case 24
        indexMat = [sstLonRegion(sstJ.max), pressureLonRegion(pressureJ.min)...
            , olrLonRegion(olrJ.min)];
        [~, i] = max(abs(indexMat - nanmean(indexMat(:))), [], 2);
        rows = (1:32)';
        index = indexMat(sub2ind([32, 3], rows, i));
    case 25
        indexMat = [norm(sstMaxVals), norm(sstLon), norm(sstBoxPress), ...
            norm(sstBoxOLR), norm(olrMinVals), norm(pressMinVals)];
        index = sum(indexMat,  2);
    case 26
        indexMat = [norm(sstMaxVals), norm(olrMinVals), ...
            norm(pressMinVals), norm(sstBoxOLR), norm(sstBoxPress)];
        index = sum(indexMat,  2);
    case 27
        index = sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max);
    case 28
        index = sstLonRegion(sstJ.min);
    case 29
        indexMat = [zscore(sstBoxOLR), zscore(sstBoxPress), ...   %349
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = sum(indexMat, 2);
    case 30
        indexMat = [zscore(sstBoxOLR), zscore(sstBoxPress), ...
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = indexMat(:, 1) + indexMat(:, 2) - indexMat(:, 3);
    case 31
        indexMat = [zscore(sstBoxOLR), zscore(sstBoxPress), ...
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = indexMat(:, 2) + indexMat(:, 3) - indexMat(:, 1);
    case 32
        indexMat = [zscore(sstBoxOLR), zscore(sstBoxPress), ...   
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = indexMat(:, 1) + indexMat(:, 3) - indexMat(:, 2);
    case 33
        indexMat = [zscore(pressureLonRegion(pressureJ.min)), ...   %89
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = sum(indexMat, 2);
    case 34
        indexMat = [zscore(sstBoxPress), zscore(sstBoxOLR), ...  %3489
            zscore(pressureLonRegion(pressureJ.min)), ...
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = sum(indexMat, 2);
    case 35
        indexMat = [zscore(sstBoxPress), zscore(sstBoxOLR)];  %index 34
        index = sum(indexMat, 2);
    case 36
        index = sstBoxPress; %index 3
    case 37
        index = sstBoxOLR;  %index 4
    case 38
        index = pressureLonRegion(pressureJ.min);  %index 8
    case 39
        index = sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max);  %index9
    case 40
        indexMat = [zscore(sstBoxOLR), ...
            zscore(sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max))];
        index = sum(indexMat, 2);
    case 41
        index = sqrt((sstLonRegion(sstJ.min) - sstLonRegion(sstJ.max)).^2 + ...
            (sstLatRegion(sstI.min) - sstLatRegion(sstI.max)).^2);

end


%{
sstMaxVals = sstValues.max;
sstLon = sstLonRegion(sstJ.max);
sstBoxPress = findBoxUseOtherVal(pressure, pressureLat, pressureLon);
sstBoxOLR = findBoxUseOtherVal(olr, olrLat, olrLon);
olrMinVals = olrValues.min;
pressMinVals = pressureValues.min;
%}

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;

cc(1) = corr(index, aso_tcs); 
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ace);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_ntc);

end

function index = weightIndex(sstLoc, pressureLoc, pressureVals)
normalizedSST = (sstLoc - mean(sstLoc)) ./ std(sstLoc);
normalizedPressure = (pressureLoc - mean(pressureLoc)) ./ std(pressureLoc);
index = zeros(size(sstLoc));
for i = 1:length(sstLoc)
    if normalizedPressure(i) > normalizedSST(i)
        index(i) = sstLoc(i) + pressureLoc(i) * pressureVals(i) / 2;
    else
        index(i) = sstLoc(i) + pressureLoc(i) * pressureVals(i) * 2;
    end
        
end


end


function [I, J, values] = buildIndexGeneric(data,box_north,box_south,...
    box_west,box_east,lat,lon,box_row,box_col)

addpath('/project/expeditions/lem/ClimateCode/sst_project/');

northRow = minIndex(lat, box_north);
southRow = minIndex(lat, box_south);
eastCol = minIndex(lon, box_east);
westCol = minIndex(lon, box_west);

annual_pacific = double(data(northRow:southRow, westCol:eastCol, :));

for t=1:size(annual_pacific,3)
   ss(:,:,t) = sub_sum(annual_pacific(:,:,t),box_row,box_col); 
end

mean_box_data_pacific = ss(box_row:end-box_row+1, box_col:end-box_col+1, :) ./ (box_row *box_col);

for t = 1:size(mean_box_data_pacific,3)
   current = mean_box_data_pacific(:,:,t);
   [minValues(t) minLoc(t)] = min(current(:));
   [minI(t),minJ(t)] = ind2sub(size(current),minLoc(t));
   [maxValues(t), maxLoc(t)] = max(current(:));
   [maxI(t), maxJ(t)] = ind2sub(size(current), maxLoc(t));
end
I = struct('min', minI, 'max', maxI);
J = struct('min', minJ, 'max', maxJ);
values = struct('min', minValues', 'max', maxValues');



end


function i = minIndex(A, x)
[~, i] = min(abs(A -x));
end