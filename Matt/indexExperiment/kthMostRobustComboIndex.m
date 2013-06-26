function [kthIndex, n] = kthMostRobustComboIndex(counts, bestVars, k)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

temp = reshape(counts, [size(counts, 1) * size(counts, 2) * size(counts, 3), 1]);
sortedCounts = sort(unique(temp), 'descend');
vars = [];
for i = 1:length(sortedCounts);
    indices = find(counts == sortedCounts(i));
    vars = [vars; unique(bestVars(indices));];
end

kthIndex = vars(k);
kthCounts = counts(bestVars == kthIndex);
n = kthCounts(1);

end

