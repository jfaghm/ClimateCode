function [ sstIndex, pressureIndex, comboIndex ] = buildIndex3( sst_a, pressure, sstSS, pressureSS, box, sstGrid, pressureGrid )

%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if ismember(sstSS.north, sstGrid.lat)
   [~, sstNorthRow] = ismember(sstSS.north, sstGrid.lat);
   [~, sstSouthRow] = ismember(sstSS.south, sstGrid.lat);
else
    error('Bad lat input!');
end
if ismember(sstSS.east, sstGrid.lon)
   [~, sstEastCol] = ismember(sstSS.east, sstGrid.lon);
   [~, sstWestCol] = ismember(sstSS.west, sstGrid.lon);
else
    error('Bad lon input!');
end

if ismember(pressureSS.north, pressureGrid.lat)
   [~, pressNorthRow] = ismember(pressureSS.north, pressureGrid.lat);
   [~, pressSouthRow] = ismember(pressureSS.south, pressureGrid.lat);
else
    error('Bad Lat input for pressure');
end

if ismember(pressureSS.east , pressureGrid.lon)
   [~, pressEastCol] = ismember(pressureSS.east, pressureGrid.lon);
   [~, pressWestCol] = ismember(pressureSS.west, pressureGrid.lon);
else
    error('Bad lon input!');
end



annual_pacific_sst = double(sst_a(sstSouthRow:sstNorthRow,sstWestCol:sstEastCol,:));
annual_pacific_pressure = double(pressure(pressSouthRow:pressNorthRow, pressWestCol:pressEastCol, :));

for t=1:size(annual_pacific_sst,3)
   sstSubset(:,:,t) = sub_sum(annual_pacific_sst(:,:,t),box.row,box.col); 
   pressSubset(:, :, t) = sub_sum(annual_pacific_pressure(:, :, t), box.row, box.col);
end
 
mean_box_sst = sstSubset(round(box.row/2):end-round(box.row/2),round(box.col/2):end-round(box.col/2),:)./(box.row*box.col);%sub_sum pads the matrix so we can ignore the outer rows/columns
mean_box_pressure = pressSubset(round(box.row/2):end-round(box.row/2), round(box.col/2):end-round(box.col/2), :) ./ (box.row*box.col);

sstLonRegion = sstGrid.lon(sstGrid.lon >= sstSS.west & sstGrid.lon <= sstSS.east);
pressLonRegion = pressureGrid.lon(pressureGrid.lon >= pressureSS.west & pressureGrid.lon <= pressureSS.east);
pressLatRegion = pressureGrid.lat(pressureGrid.lat >= pressureSS.south & pressureGrid.lat <= pressureSS.north);


for t = 1:size(mean_box_sst,3)
   currentSST = mean_box_sst(:,:,t);
   currentPressure = mean_box_pressure(:, :, t);
   
   [sstValues(t) sstLoc(t)] = max(currentSST(:));
   [pressValues(t) pressLoc(t)] = max(currentPressure(:));
   
   [sstI(t),sstJ(t)] = ind2sub(size(currentSST),sstLoc(t));
   [pressI(t), pressJ(t)] = ind2sub(size(currentPressure), pressLoc(t));
   
   [sstMinValues(t), sstMinLoc(t)] = min(currentSST(:));
   [pressMinValues(t), pressMinLoc(t)] = min(currentPressure(:));
   
   [sstMinI(t), sstMinJ(t)] = ind2sub(size(currentSST), sstMinLoc(t));
   [pressMinI(t), pressMinJ(t)] = ind2sub(size(currentPressure), pressMinLoc(t));
   
   
   %%%%%%%%%%%for comboIndex%%%%%%%%%%%% 205 is the midpoint
   %{
   if sstLonRegion(sstJ(t)) <= 205 && pressLonRegion(pressJ(t)) <= 205
        if sstJ(t) > pressJ(t)
            comboIndex(t) = sstLonRegion(sstJ(t));
        else
            comboIndex(t) = pressLonRegion(pressJ(t));
        end
   elseif sstLonRegion(sstJ(t)) > 205 && pressLonRegion(pressJ(t)) > 205
        if sstJ(t) > pressJ(t)
            comboIndex(t) = sstLonRegion(sstJ(t));
        else
            comboIndex(t) = pressLonRegion(pressJ(t));
        end
   else
        comboIndex(t) = sstLonRegion(sstJ(t));
   end
   
   %}
   %{
   if abs(sstLonRegion(sstJ(t)) - 205) >= abs(pressLonRegion(pressJ(t)) - 205) 
        if sstJ(t) > pressJ(t)
            comboIndex(t) = sstLonRegion(sstJ(t));
        else
            comboIndex(t) = pressLonRegion(pressJ(t));
        end
   else
        if sstJ(t) > pressJ(t)
            comboIndex(t) = sstLonRegion(sstJ(t));
        else
            comboIndex(t) = pressLonRegion(pressJ(t));
        end
   end
   %}
   
end


sstIndex = sstLonRegion(sstJ);
%pressureIndex = pressLonRegion(pressJ);
pressureIndex = pressLatRegion(pressMinI) + pressLonRegion(pressJ) .* pressMinValues';

comboIndex = (sstIndex - pressureIndex'); %-2.99 correlation

comboIndex = min(sstLonRegion(sstJ), pressLonRegion(pressJ)'); %.36

comboIndex = sstLonRegion(sstJ) - pressLonRegion(pressMinI)'; %-2.78 correlation

comboIndex = sstLonRegion(sstJ) - pressLatRegion(pressI)' .* pressMinValues; %-3.22 correlation




end

















