function [beta, yVals] = multiVariateRegress(indices, target)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

y = double(indices);
x = target;
[nobs, nregions] = size(y);

X = cell(nobs, 1);
for j = 1:nobs
    X{j} = [eye(nregions), repmat(x(j), nregions, 1)];
end
beta = mvregress(X, y);
yVals = indices * beta(2:end) + beta(1);

end

