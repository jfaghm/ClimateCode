function [beta, Y] = multiVariateRegress(indices, target)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
pred_cell = cell(length(target), 1);

for i = 1:length(target)
    pred_cell{i} = [1, indices(i, :)];
end

beta = mvregress(pred_cell, target);
Y = bsxfun(@times, indices, beta(2:end)');
Y = sum(Y, 2);
Y = bsxfun(@plus, Y, beta(1));
end

