function [ m rsquare p ] = computeTrends( timeSeriesData )
% COMPUTETRENDS Computes the upward trend and p-value of time series
%
% [ m rsquare p ] = computeTrends( timeSeriesData )
%
% ------------------------------- INPUT -------------------------------
%
% --> timeSeriesData - The time series data, with each individual time
% series on a row.  The slope of the line of best fit (trend) for the data
% along with the p-value of that trend are computed for each row.
%
% ------------------------------- OUTPUT -------------------------------
%
% --> m - The slope of the line which best fits the data (trend)
%
% --> rsquare - The r squared value for the line of best fit.
%
% --> p - The p-value of that trend.
%
% ----------------------------- EXAMPLE -----------------------------
% 
% The following example computes the trend, rsquared, and p value of a
% bunch of SST time series:
% 
% % Load and reformat the sst data
% load /project/expeditions/haasken/data/reynolds_monthly/reynoldsSSTLatLon.mat
% seasonal = monthlyToSeasonal(reynoldsSST, reynoldsDates, 6:10, 1982, 2010);
% sstSeries = flattenData(seasonal);
% % Compute trends (takes a few minutes for this large data set)
% [ m rsquare p ] = computeTrends(sstSeries);
% 

numCols = size(timeSeriesData, 2);
numRows = size(timeSeriesData, 1);
m = NaN(numRows, 1);
rsquare = NaN(numRows, 1);
p = NaN(numRows, 1);


for i = 1:numRows
    
    if ~all(isnan(timeSeriesData(i, :)))
        
        stats = regstats( timeSeriesData(i, :)', 1:numCols );
        m(i) = stats.beta(2);
        rsquare(i) = stats.rsquare;
        p(i) = stats.tstat.pval(2);
        
    end
end


end