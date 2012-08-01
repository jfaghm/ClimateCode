function [regressCoef, crossValCoef] = multivariateCombos()
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

variables = {'sstMaxLat', 'sstMaxLon', 'sstMaxVal', 'olrMinVal', ...
    'olrMinLon', 'pressMinVal', 'pressMinLon', 'pressMaxVal', 'pressMaxLon'};

varNums = 1:9;
%{
for i = 1:9
    if i <= 5
        eval([variables{i} ' = buildIndexMV(' num2str(i) ', 3, 10);']);
    else
        eval([variables{i} ' = buildIndexMV(' num2str(i) ', 3, 10);']);
    end
    i
end
%}
load indexVars.mat

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;
addpath('/project/expeditions/lem/ClimateCode/Matt/');
%regress with one variable
regressCoef1 = zeros(9, 2);
crossValCoef1 = zeros(9, 2);
for i = 1:9
    eval(['[~,prediction] = multipleRegress(', variables{i}...
        ', aso_tcs);']);
    eval(['[yVals, actual] = crossValidate(', variables{i} ', aso_tcs, 32);']);
    num = i;
    regressCoef1(i, 1) = num;
    regressCoef1(i, 2) = corr(prediction, aso_tcs);
    crossValCoef1(i, 1) = i;
    crossValCoef1(i, 2) = corr(yVals, actual);
end

%regress with two variables
combos = npermutek(varNums, 2);
regressCoef2 = zeros(size(combos, 1), 2);
crossValCoef2 = zeros(size(combos, 1), 2);
for i = 1:size(combos, 1)
    if length(combos(i, :)) ~= length(unique(combos(i, :)))
        continue
    end
    eval(['[~,prediction] = multipleRegress([', variables{combos(i, 1)} ', '...
        variables{combos(i, 2)} '], aso_tcs);']);
    eval(['[yVals, actual] = crossValidate([', variables{combos(i, 1)} ', ' ...
        variables{combos(i, 2)} '], aso_tcs, 32);']);
    num = str2double([num2str(combos(i, 1)), num2str(combos(i, 2))]);
    regressCoef2(i, 1) = num;
    regressCoef2(i, 2) = corr(prediction, aso_tcs);
    crossValCoef2(i, 1) = num;
    crossValCoef2(i, 2) = corr(yVals, actual);
end

%regress with three variables
combos = npermutek(varNums, 3);
regressCoef3 = zeros(size(combos, 1), 2);
crossValCoef3 = zeros(size(combos, 1), 2);
for i = 1:size(combos, 1)
    if length(combos(i, :)) ~= length(unique(combos(i, :)))
        continue
    end
    eval(['[~,prediction] = multipleRegress([', variables{combos(i, 1)} ', '...
        variables{combos(i, 2)} ', ' variables{combos(i, 3)} '], aso_tcs);']);
    eval(['[yVals, actual] = crossValidate([' variables{combos(i, 1)} ', '...
        variables{combos(i, 2)} ', ' variables{combos(i, 3)} '], aso_tcs, 32);']);
    num = str2double([num2str(combos(i, 1)), num2str(combos(i, 2)), num2str(combos(i, 3))]);
    regressCoef3(i, 1) = num;
    regressCoef3(i, 2) = corr(prediction, aso_tcs);
    crossValCoef3(i, 1) = num;
    crossValCoef3(i, 2) = corr(yVals, actual);
end

regressCoef = struct('Vars3', regressCoef3, 'Vars2', regressCoef2, ...
    'Var1', regressCoef1);
crossValCoef = struct('Vars3', crossValCoef3, 'Vars2', crossValCoef2, ...
    'Var1', crossValCoef1);


end






function [index, cc, ccIndex, nYears, pYears] = buildIndexMV(indexNum, startMonth, endMonth)
load /project/expeditions/lem/ClimateCode/Matt/matFiles/sstAnomalies.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/pressureAnomalies.mat;
load /project/expeditions/lem/ClimateCode/Matt/matFiles/olrAnomalies.mat;

year = 1;
for i = 1:12:(2010-1979+1)*12
   sstMean(:, :, year) = nanmean(sst(:, :, i+startMonth - 1:i+endMonth - 1), 3); 
   pMean(:, :,year) = nanmean(pressure(:, :, i+startMonth-1:i+endMonth-1), 3);
   olrMean(:, :, year) = nanmean(olr(:, :, i+startMonth-1:i+endMonth-1), 3);
   year = year+1;
end

box_north = sstLat(minIndex(sstLat, 35));
box_south = sstLat(minIndex(sstLat, -5));
box_west = sstLon(minIndex(sstLon, 140));
box_east = sstLon(minIndex(sstLon, 270));
box_row = 5;
box_col = 18;
[sstI, sstJ, sstValues] = buildIndexGeneric(sstMean, box_north, box_south, box_west, box_east, sstLat, sstLon, box_row, box_col, true);

sstLonRegion = sstLon(sstLon >= box_west & sstLon <= box_east);
sstLatRegion = sstLat(sstLat >=  box_south & sstLat <= box_north);


box_north = olrLat(minIndex(olrLat, 35));
box_south = olrLat(minIndex(olrLat, -35));
box_west = olrLon(minIndex(olrLon, 140));
box_east = olrLon(minIndex(olrLon, 270));

[olrI, olrJ, olrValues] = buildIndexGeneric(olrMean, box_north, box_south, box_west, box_east, olrLat, olrLon, 5, 10, false);
olrLonRegion = olrLon(olrLon >= box_west & olrLon <= box_east);
olrLatRegion = olrLat(olrLat >= box_south & olrLat <= box_north);

box_north = pressureLat(minIndex(pressureLat, 35));
box_south = pressureLat(minIndex(pressureLat, -5));
box_west = pressureLon(minIndex(pressureLon, 140));
box_east = pressureLon(minIndex(pressureLon, 270));
pressureLonRegion = pressureLon(pressureLon >= box_west & pressureLon <= box_east);
pressureLatRegion = pressureLat(pressureLat >= box_south & pressureLat <= box_north);

[pressureI, pressureJ, pressureValues] = buildIndexGeneric(pMean, box_north, box_south, box_west, box_east, pressureLat, pressureLon, box_row, box_col, false);

switch indexNum
    case 1
        index = sstLatRegion(sstI.max);
    case 2
        index = sstLonRegion(sstJ.max);
    case 3
        index = sstValues.max';
    case 4
        index = olrValues.min';
    case 5
        index = olrLonRegion(olrJ.min);
    case 6
        index = pressureValues.min';
    case 7
        index = pressureLonRegion(pressureJ.min);
    case 8
        index = pressureValues.max';
    case 9
        index = pressureLonRegion(pressureJ.max);
end

load /project/expeditions/lem/ClimateCode/Matt/matFiles/asoHurricaneStats.mat;

sstIndex = sstLonRegion(sstJ.max);
ccIndex(1) = corr(sstIndex, aso_tcs);
ccIndex(2) = corr(sstIndex, aso_major_hurricanes);
ccIndex(3) = corr(sstIndex, aso_ace);
ccIndex(4) = corr(sstIndex, aso_pdi);
ccIndex(5) = corr(sstIndex, aso_ntc);

cc(1) = corr(index, aso_tcs); 
cc(2) = corr(index, aso_major_hurricanes);
cc(3) = corr(index, aso_ace);
cc(4) = corr(index, aso_pdi);
cc(5) = corr(index, aso_ntc);
%{
plot(index, aso_ntc, 'x');
xlabel('index')
ylabel('aso_ntc');
%}
normalizedIndex = (index - mean(index)) ./ std(index);
nYears = find(normalizedIndex <= -1) + 1979 - 1;
pYears = find(normalizedIndex >= 1) + 1979 - 1;
end

function [I, J, values] = buildIndexGeneric(data,box_north,box_south,box_west,box_east,lat,lon,box_row,box_col, upsideDown)

addpath('/project/expeditions/lem/ClimateCode/sst_project/');

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
if upsideDown == true
    annual_pacific = double(data(southRow:northRow,westCol:eastCol,:));
else
    annual_pacific = double(data(northRow:southRow, westCol:eastCol, :));
end



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
values = struct('min', minValues, 'max', maxValues);



end


function i = minIndex(A, x)
[~, i] = min(abs(A -x));
end