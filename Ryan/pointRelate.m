function resultGrid = pointRelate(data, counts, relateFunction)
% 
% resultGrid = pointCorr(data, counts)
% 
% ------------------------- INPUT -------------------------
% 
% --> data - The 3D data grid to relate with the counts time series
% --> counts - A time series of storm counts to relate with each point
% of the gridded data.  This vector should have the same number of elements
% as tthe number of time steps in data.
% --> relateFunction - A function handle which takes in two matrices with
% time series data on their rows and computes a statistic between them
% (e.g. rowCorr)
% 
% ------------------------- OUTPUT ------------------------
% 
% --> resultGrid - The grid of pointwise results.  Has the same number of
% rows and columns as input data.  The value at resultGrid(i, j) is the
% result between the time series counts and the time series data(i, j, :)
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Assume we have stormCounts and sstData with same number of time steps 
% % Compute the correlation between every point sst and storm counts
% pointwiseCorr = pointRelate(sstData, stormCounts, @rowCorr);
% % Compute the MIC as well
% pointwiseMIC = pointRelate(sstData, stormCounts, @rowMIC);
% 

% Check the input validity
if ~isvector(counts)
    error('counts should be a vector')
end

if size(data, 3) ~= length(counts)
    error('length of counts should equal size(data, 3)')
end

% Should be able to use reshape, but it seems to behave inconsistently, and
% it's behavior is insufficiently documented
%{
reshapedData = reshape( data, size(data, 1)*size(data, 2), size(data, 3), 1);
%}

% Instead use a preallocation and a for loop
reshapedData = zeros( size(data, 1) * size(data, 2), size(data, 3) );

for col = 1:size(data, 2)
    for row = 1:size(data, 1)
        reshapedData( (col-1)*size(data, 1) + row, :) = data(row, col, :);
    end
end

% Make sure that counts is a row vector to work properly in rowCorr
counts = reshape(counts, 1, []);

% Now use relateFunction to compute the relationship between rows of reshaped data
% and counts
resultVector = relateFunction(reshapedData, counts, '');
% Now reshape the vector of results into a matrix
resultGrid = reshape(resultVector, size(data, 1), size(data, 2));

end