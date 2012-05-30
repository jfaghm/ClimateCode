function anomalies = computeAnomalies( dataSet, dates, varargin )
%COMPUTEANOMALIES Computes the anomalies of a data set.

% Convert dates into [ year month day ] format
dateMatrix = dateVectorToMatrix(dates, 'yyyymm');

% Compute the default basePeriod
defaultBasePeriod = [ dateMatrix(1, 1) dateMatrix(end, 1) ];

p = inputParser;
p.addRequired('dataSet', @(x)ndims(x)==3);
p.addRequired('dates', @(x)isvector(x) && length(x) == size(dataSet, 3));
p.addParamValue('basePeriod', defaultBasePeriod, @(x)isvector(x) && length(x) == 2 && x(1) <= x(2));
p.parse(dataSet, dates, varargin{:});

basePeriod = p.Results.basePeriod;

baseYearMask = dateMatrix(:, 1) >= basePeriod(1) & dateMatrix(:, 1) <= basePeriod(2);
baseYearData = dataSet(:, :, baseYearMask);
baseDates = dateMatrix(baseYearMask, :);

monthlyAverages = zeros(size(dataSet, 1), size(dataSet, 2), 12);

% Compute the average for the base period for each month
for month = 1:12
    
    % Get a mask for the current month data
    monthMask = baseDates(:, 2) == month;
    monthData = baseYearData(:, :, monthMask);
    monthlyAverages(:, :, month) = mean(monthData, 3);
    
end

anomalies = zeros(size(dataSet));

% Subtract monthly means from each month of data
for month = 1:12
    
    monthMask = dateMatrix(:, 2) == month;
    monthData = dataSet(:, :, monthMask);
    
    anomalies(:, :, monthMask) = monthData - repmat(monthlyAverages(:, :, month), [ 1 1 size(monthData, 3) ]);

end


end