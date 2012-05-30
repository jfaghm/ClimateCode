function [ origCorr, randPctl, resultMaps ] = testSignificance(data, counts, numTrials, confidence)
% TESTSIGNIFICANCE Tests significance of correlations of data and counts
% 
% [ origCorr, randPctl ]testSignificance(data, counts, numTrials, confidence)
% 
% This function takes in a
% 
% ------------------------- INPUT -------------------------
% -> 
% -> 
% 
% ------------------------- OUTPUT ------------------------
% -> origCorr - 
% -> randPctl - 
% 

% Check the input validity
if ~isvector(counts)
    error('counts should be a vector')
end

if size(data, 3) ~= length(counts)
    error('length of counts should equal size(data, 3)')
end

if ( confidence < 0 || confidence > 100 )
    error('confidence level should be between 0 and 100')
end

% Compute the original pointwise correlations
origCorr = pointCorr(data, counts);

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

% Preallocate a matrix to store the results of the randomization
% randomResults = zeros( size(reshapedData, 1), numTrials);
resultMaps = zeros( size(data, 1), size(data, 2) );

% Now do the time-step randomizations
for trial = 1:numTrials
    
    % Randomize the time steps of the reshaped data
    randIndices = randperm( size(reshapedData, 2) );
    randData = reshapedData(:, randIndices);
    % Compute the correlations
    %randomResults(:, trial) = rowCorr(randData, counts);
    
    resultMaps(:, :, trial) = reshape( rowCorr(randData, counts), size(data, 1), size(data, 2) );
    
end

% Now compute the magnitude of the correlation at the given confidence
% Note the absolute value for a two-tailed test, just compares magnitude
% pctlVals = prctile(abs(randomResults), confidence, 2);
% randPctl = reshape(pctlVals, size(data, 1), size(data, 2));
randPctl = prctile(abs(resultMaps), confidence, 3);

end