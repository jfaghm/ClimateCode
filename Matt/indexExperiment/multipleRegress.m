function [beta, prediction] = multipleRegress(indices, target)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x = [ones(size(indices, 1), 1), indices];

beta = regress(target, x);
prediction = x * beta;

end

