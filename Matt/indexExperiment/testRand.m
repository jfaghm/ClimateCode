function [cc] = testRand()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

index = rand(32, 1);
target = rand(32, 1);
for i = 1:10000
    ix = randperm(32);
    targetTemp = target(ix);
    cc(i) = corr(index, targetTemp);
end

end

