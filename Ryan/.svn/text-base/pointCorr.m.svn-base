function corrGrid = pointCorr(data, counts)
% 
% corrGrid = pointCorr(data, counts)
% 
% ------------------------- INPUT -------------------------
% 
% --> data - The 3D data grid to correlate with the counts time series
% --> counts - A time series of storm counts to correlate with each point
% of the gridded data.  This vector should have the same number of elements
% as tthe number of time steps in data.
% 
% ------------------------- OUTPUT ------------------------
% 
% --> corrGrid - The grid of point correlations.  Has the same number of
% rows and columns as input data.  The value at corrGrid(i, j) is the
% correlation between the time series counts and the time series data(i, j, :)
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

% Now use rowCorr to compute the correlation between rows of reshaped data
% and counts
corrVector = rowCorr(reshapedData, counts);
% Now reshape the vector of correlations into a matrix
corrGrid = reshape(corrVector, size(data, 1), size(data, 2));

end