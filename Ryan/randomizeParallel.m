function results = randomizeParallel(A, B, numTrials, sampling, relateFunc, which)
% RANDOMIZE Computes relationships between A and B in randomized trials.
%
% results = randomize(A, B, numTrials, sampling, relateFunc)
% 
% --------------------- INPUT ---------------------
% 
% --> A: n x k matrix where n is the number of timeseries, k is the number
% of time steps in the time series.
% 
% --> B: a k-vector, i.e. a single time series, or a m x k matrix where m
% is the number of time series of length k
% 
% --> sampling: 'bootstrap', 'permute', or 'blocks'.  'bootstrap' indicates a method
% of random sampling with replacement while 'permute' indicates a method of
% randomly permuting the time steps of a time series.  'blocks' shuffles
% overlapping blocks of the time series with replacement.
% 
% --> relateFunc: a function handle, which refers to a function that takes
% in A and B and returns an n x m matrix indicating how strongly related
% each row of A is to each row of B.  Examples of such existing functions
% are rowCorr and rowMIC.
% 
% --> which: indicates whether to randomize the time steps of A or B.  1
% indicates A, 2 indicates B.
% 
% --------------------- OUTPUT ---------------------
% 
% --> results: a n x m x numTrials matrix where the entry in results(i, j,
% k) is the score computed by relateFunc between the A(i, :) and B(j, :) on
% the kth random trial.
% 


% Check that sampling type is recognized
if ~ismember( sampling, { 'bootstrap', 'permute', 'blocks' } )
    error('sampling method not recognized; use permute or bootstrap')
end

% Check that the time series have same number of time steps
if (size(A, 2) ~= size(B, 2))
    error('A and B should have same number of time steps (columns)')
end
numCols = size(A, 2);

% Check if 'which' argument is given
if nargin < 6
    which = 1;
end

% Check to see that which is either 1 for A or 2 for B
if ( which ~= 1 && which ~= 2 )
    error('which should be either 1 or 2')
end

% Set up a results matrix to store random scores from each trial
results = zeros(size(A, 1), max( size(B, 1), 1 ), numTrials);

% Do numTrials randomizations in parallel
parfor i = 1:numTrials
    
    % Do the appropriate randomization of time steps
    if strcmp(sampling, 'permute')
        randomOrdering = randperm(numCols);
    elseif strcmp(sampling, 'bootstrap')
        randomOrdering = randsample(numCols, numCols, true);
    elseif strcmp(sampling, 'blocks')
        randomOrdering = randblocks(numCols, numCols, floor(numCols^(1/3)), true);
    end
    
    if which == 1
        
        randomizedA = A(:, randomOrdering);
        results(:, :, i) = relateFunc(randomizedA, B, num2str(i));
        
    else
        
        randomizedB = B(:, randomOrdering);
        results(:, :, i) = relateFunc(A, randomizedB, num2str(i));
        
    end
    
end


end