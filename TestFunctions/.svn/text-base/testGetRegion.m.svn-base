function [ output_args ] = testGetRegion( landMask, latlims, lonlims, startYear, endYear, startMonth, endMonth, type)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numRegions = size(latlims, 1);
if numRegions ~= size(lonlims, 1);
    error('The number of rows in latlims must equal the number of rows in lonlims\n')
end

numCols = size(landMask, 2);
numRows = size(landMask, 1);

% Determine which SST data set is to be used
if strcmp(type, 'reynolds')
    
    % compute row indices into the SST data from latitude values
    rowIndices = ceil(90 - latlims);
    rowIndices(rowIndices > numRows) = numRows;
    rowIndices(rowIndices < 1) = 1;
    % sort the indices so that they specify a proper range for latitude
    rowIndices = sort(rowIndices, 2);
    % compute the columns indices into the SST data from longitude values
    colIndices = mod(ceil(lonlims), numCols);
    colIndices(colIndices == 0) = numCols;
    
elseif strcmp(type, 'hadley') || strcmp(type, 'testHadley')
    
    % compute row indices into the SST data from latitude values
    rowIndices = ceil(90 - latlims);
    rowIndices(rowIndices > numRows) = numRows;
    rowIndices(rowIndices < 1) = 1;
    % sort the indices so that they specify a proper range for latitude
    rowIndices = sort(rowIndices, 2);
    % compute the columns indices into the SST data from longitude values
    colIndices = ceil(180 + lonlims);
    
else
    % type must be 'reynolds' or 'hadley' or 'testHadley'
    error('type argument not recognized.\n')
    
end

if size(landMask, 3) ~= length(dates)
    error('The number of SST grids should equal the number of dates given.\n')
end

% Determine the number of regions to be averaged over
numRegions = size(latlims, 1);
% Make sure each region has latitude and longitude limits
if size(lonlims, 1) ~= numRegions
    error('The number of rows in latlims must match the number of rows in lonlims.\n')
end

% Check if the season starts in one year and ends in the next
yearOverlap = startMonth > endMonth;

if yearOverlap
    seasonMonths = [startMonth:12 1:endMonth];
    yearOffset = [ones(1, 13-startMonth) zeros(1, endMonth)];
else
    seasonMonths = startMonth:endMonth;
    yearOffset = (zeros(1, endMonth-startMonth+1));
end


end

