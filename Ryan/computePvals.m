
correlations = zeros(180, 360); 
pvals = zeros(180, 360);

for i = 1:180
    for j = 1:360
        [r  p] = corr(permute(seasonal(i, j, :), [3 1 2]), stormCounts');
        correlations(i, j) = r;
        pvals(i, j) = p;
    end
end
