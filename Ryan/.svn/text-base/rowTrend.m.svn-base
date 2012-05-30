function allTrends = rowTrend(y, varargin)
%ROWTREND Computes trend of rows of input matrix
%
% allTrends = rowTrendFast(y, x)
% 
%   rowTrend computes the trend of each row of y using linear regression
%
% -------------------------------- INPUT --------------------------------
%
% --> y: A matrix with a series on each row.
% 
% --> x: A time series of the same length as the time series of y. rowTrend
% will compute the slope of the line of best fit (in a least squares sense)
% through the points (x(i), y(i)).  This is optional; default is to use the
% vector 1:size(y, 2).
%
% **Ignores an extra input so that it can be used in the same way as rowMIC,
% which requires an extra argument for parallelization to work.
% 
% -------------------------------- OUTPUT --------------------------------
%
% --> allTrends: A column vector of trends where each element is the trend
% of the corresponding row of y.  That is, allTrends(i) = trend of the ith
% row of y.
%
% ----------------------------- EXAMPLES -----------------------------
% 
% % This example gets the trend of the reynolds sst data set
% seasonal = monthlyToSeasonal(reynoldsSST, reynoldsDates, 6:10);
% flattened = flattenData(seasonal);
% allTrends = rowTrend(flattened);
% trendGrid = reshape(allTrends, size(reynoldsSST, 1), size(reynoldsSST, 2));
% imagesc(trendGrid);
% 

p = inputParser;
p.addRequired('y', @ismatrix);
p.addOptional('x', 1:size(y, 2), @(x)isvector(x) & length(x) == size(y, 2));
p.parse(y, varargin{:});
x = p.Results.x;

% Compute components of normal equations to solve least squares approx.
A = [ x' ones(length(x), 1) ];  % Want to solve As = y
% Multiply on both sides by A'
y2 = A'*y';
B = A'*A;
% Solve the system of linear equations for slope and intercept
solutions = B \ y2;

% Extract the slope of each row of y from solutions
allTrends = solutions(1, :)';

end