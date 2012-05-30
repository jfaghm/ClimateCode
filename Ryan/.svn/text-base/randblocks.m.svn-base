function y = randblocks(n, k, blockSize, replacement)
% RANDBLOCKS Randomly samples indices in blocks.
% 
% 
% 
% --------------------- INPUT ---------------------
% 
% --> n: The number of indices to sample from.
% 
% --> k: The size of the random sample to take.
% 
% --> blockSize: The size of the blocks of indices to take together
% 
% --> replacement: A boolean, true for sampling from the blocks with
% replacement, and false for sampling from the blocks without replacement
% 
% --------------------- OUTPUT ---------------------
% 
% --> y: The randomly sampled indices in a row vector of length k.
% 


% Construct the block indices
blocks = cell(1, n-blockSize+1);
for i = 1:(n-blockSize+1)
    blocks{i} = i:(i+blockSize-1);
end

% Now that the blocks have been created, select n/blocksize of them with replacement
indices = randsample(length(blocks), ceil( k/blockSize), replacement);
y = cell2mat(blocks(indices));

% Chop off the extra indices
y = y(1:k);

end