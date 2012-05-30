function [ actualCorr, tsDist ] = testCorr( A, B, numTrials, numBins )
% TESTCORR Randomization test on the correlations between A and B
% 
% [ actualCorr, tsCorr, lsCorr ] = testCorr( A, B )
% 
% This function takes in a matrix of time series and another single time
% series and computes the correlations unshuffled, shuffled by time, and
% shuffled by location
% 
% ------------------------- INPUT -------------------------
% -> A - A matrix of time series.  Each row of A should be a time series.
% -> B - A time series vector.  Its length should equal the number of
% columns of A.
% 
% ------------------------- OUTPUT ------------------------
% -> actualCorr - A vector of the actual correlations between each time
% series of A and the time series B.  actualCorr(i) is the correlation
% between the ith row of A and B.
% -> tsDist - The distribution of the correlations of time-step-shuffled A
% with the vector B.  Each element counts the number of correlations which
% occurred which were in a bin of width 0.01.
% 

% Check the input validity
if ~isvector(B) 
    error('B should be a vector')
end
if (size(A, 2) ~= length(B))
    error('The length of B must equal the number of columns in A')
end
if nargin < 4
    numBins = 200;
elseif ( mod(numBins, 2) ~= 0 ) 
    error('The number of bins must be even.')
end

% Compute the actual correlations between A and B
actualCorr = rowCorr(A, B);

% Set up a bin vector
binvector = (-1 + 1/numBins):(2/numBins):(1 - 1/numBins);

% Initialize vector to store distribution of the time-randomization tests
tsDist = zeros(1, numBins);

% Do numTrials time-step randomizations of A
for i = 1:numTrials
    
    % Randomize the time steps of A
    randIndices = randperm( size(A, 2) );
    tsA = A(:, randIndices);
    % Correlate time-randomized A with B
    tsCorr = rowCorr(tsA, B);
    % Get the distribution of this trial's correlations and add to total
    n = hist(tsCorr, binvector);
    tsDist = tsDist + n;
    
    %{
    % Randomize the locations of A by shuffling rows
    randIndices = randperm( size(A, 1) );
    lsA = A(randIndices, :);
    % Correlate location-randomized A with B
    lsCorr = rowCorr(lsA, B);
    % Get the distribution of this trial's correlations and add to total
    n = hist(lsCorr, binvector);
    lsDist = lsDist + n;
    %}
    
end
    
% Plot the distribution of the randomized time-step correlations
bar(binvector, tsDist);
% Compute the 95th percentile of the distribution.
absDist = tsDist(numBins/2:-1:1) + tsDist( (numBins/2+1):numBins);
numElementsIn = sum(absDist) * 0.05;
i = numBins/2;
while (numElementsIn - absDist(i) > 0)
    numElementsIn = numElementsIn - absDist(i);
    i = i - 1;
end
pctl95 = (numElementsIn / absDist(i)) * -(2/numBins) + binvector(numBins/2 + i) + 1/numBins;
title( { 'Distribution of time-step randomized correlations'; ...
    [ '95th Percentile: ' num2str(pctl95, '%.2f') ] } );


end