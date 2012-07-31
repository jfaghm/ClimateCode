function [ predictions ] = singleRegress(indices, target)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

beta = polyfit(indices, target, 1);

predictions = polyval(beta, indices);

end

