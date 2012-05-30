function [ results randIndices ] = randomize(A, B, numTrials, relateFunc, sampling, varargin)
% RANDOMIZE Computes relationships between A and B in randomized trials.
%
% results = randomize(A, B, numTrials, relateFunc, sampling)
% results = randomize(A, B, numTrials, relateFunc, sampling, 'Name1', Value1, ... )
% [ results, randIndices ] = randomize(A, B, numTrials, relateFunc, sampling)
% [ results, randIndices ] = randomize(A, B, numTrials, relateFunc, sampling, ...)
%
% --------------------- INPUT ---------------------
%
% --> A: n x k matrix where n is the number of timeseries, k is the number
% of time steps in the time series.
%
% --> B: a k-vector, i.e. a single time series, or a m x k matrix where m
% is the number of time series of length k
%
% --> numTrials: the number of random trials to perform
% 
% --> relateFunc: a function handle, which refers to a function that takes
% in A and B and returns an n x m matrix indicating how strongly related
% each row of A is to each row of B.  Examples of such existing functions
% are rowCorr and rowMIC.
%
% --> sampling: 'bootstrap', 'permute', or 'blocks'.  'bootstrap' indicates a method
% of random sampling with replacement while 'permute' indicates a method of
% randomly permuting the time steps of a time series.  'blocks' shuffles
% overlapping blocks of the time series with replacement.
% 
% Optional Name/Value Pairs:
% -'which' -- indicates whether to randomize the time steps of A or B.  1
% indicates A, 2 indicates B.  Default is to randomize A.
% -'parallel' -- a boolean, true for running in parallel, false otherwise.
% Defauls is false.
% -'randomOrderings' -- A numTrials x k matrix consisting of
% pre-constructed random orderings of the time steps of A or B.  This is
% good for computing two different relate functions of A and B using the
% same random orderings.
% 
%
% --------------------- OUTPUT ---------------------
%
% --> results: a n x m x numTrials matrix where the entry in results(i, j,
% k) is the score computed by relateFunc between the A(i, :) and B(j, :) on
% the kth random trial.
%
% --> randIndices: a numTrials x k matrix consisting of the random
% orderings used on each randomization trial.  This can be passed back in
% on a subsequent call to use the same randomization.
% 

p = inputParser;    % Create an instance of inputParser to parse name-value pairs
p.CaseSensitive = false;  % Turn off case sensitivity
p.FunctionName = 'randomize';
p.KeepUnmatched = false;  % Don't allow extra arguments

p.addRequired('sampling', @(x)ismember(x, { 'bootstrap', 'permute', 'blocks' }));
p.addParamValue('randomOrderings', [], @(x)ismatrix(x) && size(x, 2) == size(A, 2) && size(x, 1) == numTrials);
p.addParamValue('which', 1, @(x)isnumeric(x) && (x==1 || x == 2));
p.addParamValue('parallel', false, @(x)islogical(x));
p.parse(sampling, varargin{:});

% Now p.Results contains fields for which, parallel, and randomOrderings
sampling = p.Results.sampling;
which = p.Results.which;
parallel = p.Results.parallel;
randomOrderings = p.Results.randomOrderings;
if isempty(randomOrderings)
    randIndices = zeros( numTrials, size(A, 2) );
else
    randIndices = randomOrderings;
end

% Check that the time series have same number of time steps
if (size(A, 2) ~= size(B, 2))
    error('A and B should have same number of time steps (columns)')
end
numCols = size(A, 2);

% Set up a results matrix to store random scores from each trial
results = zeros(size(A, 1), max( size(B, 1), 1 ), numTrials);

% Check to see whether to use for or parfor
if parallel
    
    % Do numTrials randomizations in parallel
    parfor i = 1:numTrials
        
        % Either get new random order or use from input arguments
        if isempty(randomOrderings)
        
            % Do the appropriate randomization of time steps
            switch sampling
                case 'permute'
                    randomOrdering = randperm(numCols);
                case 'bootstrap'
                    randomOrdering = randsample(numCols, numCols, true);
                case 'blocks'
                    randomOrdering = randblocks(numCols, numCols, floor(numCols^(1/3)), true);
            end
            randIndices(i, :) = randomOrdering;
        else 
            randomOrdering = randomOrderings(i, :);
        end
            
        if which == 1
            
            randomizedA = A(:, randomOrdering);
            results(:, :, i) = relateFunc(randomizedA, B, num2str(i));
            
        else
            
            randomizedB = B(:, randomOrdering);
            results(:, :, i) = relateFunc(A, randomizedB, num2str(i));
            
        end
        
    end
    
else
    
    % Do numTrials randomizations not in parallel
    for i = 1:numTrials
        
        % Either get new random order or use from input arguments
        if isempty(randomOrderings)
        
            % Do the appropriate randomization of time steps
            switch sampling
                case 'permute'
                    randomOrdering = randperm(numCols);
                case 'bootstrap'
                    randomOrdering = randsample(numCols, numCols, true);
                case 'blocks'
                    randomOrdering = randblocks(numCols, numCols, floor(numCols^(1/3)), true);
            end
            randIndices(i, :) = randomOrdering;
        else 
            randomOrdering = randomOrderings(i, :);
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

end