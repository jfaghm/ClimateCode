function trendGrid = globalTrend(data, varargin)
% GLOBALTREND Computes the trend of each point of a data set
% 
% trendGrid = globalTrend(data)
% trendGrid = globalTrend(data, dates, startYear, endYear)
% trendGrid = globalTrend(data, dates, startYear, endYear, months)
% 
% ------------------------------- INPUT -------------------------------
% 
% --> data: The 3D data set
% --> dates: The vector of dates associated with the data matrix.  If not
% given, then no seasonal averaging is done.
% --> startYear: The starting year for computing trends.
% --> endYear: The ending year for computing trends.
% --> months: The months to average over for each year.  Default is 1:12.
% 
% ------------------------------- OUTPUT ------------------------------
% 
% --> trendGrid: The grid of trends for each data point.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example computes the trend of the reynolds sst data set
% load /project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat
% % Compute the trend of the Jun-Oct seasonal SST from 1982-2010
% trends = globalTrend(reynoldsSST, reynoldsDates, 1982, 2010, 6:10);
% 

p = inputParser;
p.addRequired('data', @(x)ndims(x) == 3);
p.addOptional('dates', [], @(x)isvector(x) & length(x) == size(data, 3));
p.addOptional('startYear', [], @isnumeric);
p.addOptional('endYear', [], @isnumeric);
p.addOptional('months', 1:12, @(x)isvector(x) & max(x) <=12 & min(x) > 0);
p.parse(data, varargin{:});
dates = p.Results.dates;
startYear = p.Results.startYear;
endYear = p.Results.endYear;
months = p.Results.months;

% Determine whether we need to get seasonal averages first
if ~isempty(dates) && ~isempty(startYear) && ~isempty(endYear)
    seasonal = monthlyToSeasonal(data, dates, months, startYear, endYear);
    flattened = flattenData(seasonal);
else
    flattened = flattenData(data);
end

% Compute the trend of each location time series
trends = rowTrend(flattened);

% Reshape the trends into a grid
trendGrid = reshape(trends, size(data, 1), size(data, 2));

end