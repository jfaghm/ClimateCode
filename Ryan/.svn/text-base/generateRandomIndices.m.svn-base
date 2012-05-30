function randomIndices = generateRandomIndices( numTrials, numIndices, sampling )
% GENERATERANDOMINDICES Generates a set of random indices out of numIndices 
% 
% randomIndices = generateRandomIndices( numTrials, numIndices, sampling )
% 
% ------------------------------INPUT------------------------------
% 
% --> numTrials: number of sets of indices to generate
% 
% --> numIndices: number of indices to generate for each set
% 
% --> sampling: sampling method used to generate the indices.  Allowed
% values are 'bootstrap', 'permute', or 'blocks'.  'bootstrap' samples
% numIndices values from the values 1:numIndices with replacement.
% 'permute' simply permutes the values 1:numIndices.  'blocks' selects
% continuous blocks of indices with block length numIndices^(1/3) with
% replacement.
% 
% ------------------------------OUTPUT------------------------------
% 
% --> randomIndices: numTrials sets of indices. Each row of randomIndices
% contains a set of numIndices random indices sampled using the indicated
% sampling method.
% 
% ----------------------------- EXAMPLES -----------------------------
% 
% % Get 1000 sets of random indices, where each set is sampled from 1:40
% % using the bootstrap method
% randomIndices = generateRandomIndices( 1000, 40, 'bootstrap' );
% % Alternatively, use the permutation sampling method ...
% randomIndices = generateRandomIndices( 1000, 40, 'permute' );
% % or the blocks sampling method
% randomIndices = generateRandomIndices( 1000, 40, 'blocks' );
% 

p = inputParser;    % Create an instance of inputParser to parse name-value pairs
p.CaseSensitive = false;  % Turn off case sensitivity
p.FunctionName = 'createRandomIndices';
p.KeepUnmatched = false;  % Don't allow extra arguments

p.addRequired('sampling', @(x)ismember(x, { 'bootstrap', 'permute', 'blocks' }));
p.parse(sampling);

randomIndices = zeros(numTrials, numIndices);

for i = 1:numTrials
    % Do the appropriate randomization of time steps
    switch sampling
        case 'permute'
            randomOrdering = randperm(numIndices);
        case 'bootstrap'
            randomOrdering = randsample(numIndices, numIndices, true);
        case 'blocks'
            randomOrdering = randblocks(numIndices, numIndices, floor(numIndices^(1/3)), true);
            
    end
    randomIndices(i, :) = randomOrdering;
end

end