function normalized = normalizeRowsSlow(A)
% NORMALIZEROWSSLOW Normalizes the rows of A using a slow for loop

normalized = zeros( size(A) );
% Iterate through each row of A and divide by the norm
for i = 1:size(A, 1)
    normalized(i, :) = A(i, :) / norm(A(i, :));
end

end