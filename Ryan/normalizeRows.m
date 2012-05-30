function normalized = normalizeRows(A)
% NORMALIZEROWS Normalizes the rows of a matrix A quickly

norms = repmat( sqrt( sum( (A.^2), 2 ) ), 1, size(A, 2));
normalized = A ./ norms;

end