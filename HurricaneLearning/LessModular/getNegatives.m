function [ negatives ] = getNegatives( year, month, day, lat, lon, index )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global hurData
global ncDataPath

dayNumber = datenum(year, month, day) - datenum(year, 1, 1) + 1;
prefix = [ncDataPath 'sea_surface_temp/ei.oper.an.sfc.regn128sc.'];
negatives = [];

isLeapYear = leapyear(year);

if dayNumber > (152 + isLeapYear)  && dayNumber < (335 + isLeapYear)
    
    % This is the target sea surface temp that we want to match
    targetSST = getDailyAvgSST(year, month, day, index);
    
    
    %% This cell searches for a good day 7 to 14 days before the storm
    prevWeekSST = NaN(1, 7);
    prevWeekDayNum = datenum(year, month, day) - 7;
    twoWeeksPrev = prevWeekDayNum - 6;
    for dayNumber = prevWeekDayNum:-1:twoWeeksPrev
        dateVector = datevec(dayNumber);
        % Check if the day is before June 1st
        if dateVector(2) < 6
            break; % no data for such a day, so break
        elseif dateVector(2) == 6 && dateVector(3) < 3
            break; % there will be no data for the preceding 36 hours
        end
        yearString = num2str(dateVector(1));
        monthString = num2str(dateVector(2), '%02d');
        dayString = num2str(dateVector(3), '%02d');
        filename = [prefix, yearString, monthString, dayString, '12', '.sst.nc'];
        try 
            ncid = netcdf.open(filename, 'NC_NOWRITE');
            varID = netcdf.inqVarID(ncid, 'var34');
            var = netcdf.getVar(ncid, varID)';
            prevWeekSST(prevWeekDayNum - dayNumber + 1) = var(index);
            netcdf.close(ncid);
        catch ME
            fprintf('%s\n', ME.message)
            fprintf('%s\n', filename)
        end
    end
    
   prevWeekSST = abs(prevWeekSST - targetSST);
   
   [minVal minIndex] = min(prevWeekSST);
   
   if minVal < .1
       negDay = datenum(year, month, day) - 6 - minIndex;
       negDate = datevec(negDay);
       negatives(end+1, :) = negDate(:, 1:3);
   end
   
   %% This cell searches for a good day a year before the storm
   if year-1 >= 1989
       prevYearSST = NaN(1, 11);
       prevYearDayNum = datenum(year-1, month, day);
       fiveDaysAhead = prevYearDayNum + 5;
       
       for offset = 1:11
           dateVector = datevec(fiveDaysAhead - offset + 1);
           if dateVector(2) > 11
               continue
           elseif dateVector(2) < 6
               break
           elseif dateVector(2) == 6 && dateVector(3) < 3
               break % no data for the preceding 36 hours
           else
               yearString = num2str(dateVector(1));
               monthString = num2str(dateVector(2), '%02d');
               dayString = num2str(dateVector(3), '%02d');
               filename = [prefix, yearString, monthString, dayString, '12', '.sst.nc'];
               try
                   ncid = netcdf.open(filename, 'NC_NOWRITE');
                   varID = netcdf.inqVarID(ncid, 'var34');
                   var = netcdf.getVar(ncid, varID)';
                   prevYearSST(offset) = var(index);
                   netcdf.close(ncid)
               catch ME
                   fprintf('%s\n', ME.message)
                   fprintf('%s\n', filename)
               end
           end
       end
       
       prevYearSST = abs(prevYearSST - targetSST);
       [minVal minIndex] = min(prevYearSST);
       
       if minVal < .1
           negDay = fiveDaysAhead - minIndex + 1;
           negDate = datevec(negDay);
           negatives(end+1, :) = negDate(:, 1:3);
       end
   end
               
   %% This cell searches for a good day a year after the storm
   if year+1 >= 1989 && year < 2009
       prevYearSST = NaN(1, 11);
       prevYearDayNum = datenum(year+1, month, day);
       fiveDaysAhead = prevYearDayNum + 5;
       
       for offset = 1:11
           dateVector = datevec(fiveDaysAhead - offset + 1);
           if dateVector(2) > 11
               continue
           elseif dateVector(2) < 6
               break
           elseif dateVector(2) == 6 && dateVector(3) < 3
               break % no data for the preceding 36 hours
           else
               yearString = num2str(dateVector(1));
               monthString = num2str(dateVector(2), '%02d');
               dayString = num2str(dateVector(3), '%02d');
               filename = [prefix, yearString, monthString, dayString, '12', '.sst.nc'];
               try
                   ncid = netcdf.open(filename, 'NC_NOWRITE');
                   varID = netcdf.inqVarID(ncid, 'var34');
                   var = netcdf.getVar(ncid, varID)';
                   prevYearSST(offset) = var(index);
                   netcdf.close(ncid)
               catch ME
                   fprintf('%s\n', ME.message)
                   fprintf('%s\n', filename)
               end
           end
       end
       
       prevYearSST = abs(prevYearSST - targetSST);
       [minVal minIndex] = min(prevYearSST);
       
       if minVal < .1
           negDay = fiveDaysAhead - minIndex + 1;
           negDate = datevec(negDay);
           negatives(end+1, :) = negDate(:, 1:3);
       end
   end
               
   
   %% This cell checks the negatives that were found for negativity
   
   numNegatives = size(negatives, 1);
   yearStorms = hurData(hurData(1, :) == year, :);
   mask = true(numNegatives, 1);
   for i = 1:numNegatives
       diffs = datenum(negatives(i, :)) - datenum(yearStorms(:, 1:3));
       matches = find(~(diffs > 14 | diffs < -2));
       for j = 1:size(matches, 1)
           fprintf('%s %d-%d-%d \n', 'Negative Date:', ...
               negatives(i, 1), negatives(i, 2), negatives(i, 3))
           fprintf('%s %d-%d-%d \n', 'Hurricane Date:', ...
               yearStorms(matches(j), 1), yearStorms(matches(j), 2), yearStorms(matches(j), 3))
           fprintf('%s %f degrees north, %f degrees east\n', 'Negative location: ', ...
               lat, lon)
           fprintf('%s %f degrees north, %f degrees east\n', 'Hurricane location: ', ...
               yearStorms(j, 4), yearStorms(j, 5))
           distance = sum(([lat lon] - yearStorms(matches(j), 4:5)).^2)^0.5;
           fprintf('The euclidean distance is %d.\n', distance)          
           if (distance < 10)
               fprintf('%s\n', 'The hurricane was too close.')
               mask(i) = false;
           end
       end
   end
   
   % Now remove the negatives which are too near other hurricanes
   
   negatives = negatives(mask, :);
   
end
    
