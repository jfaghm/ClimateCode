function [cc] = testRand(train, test)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


sstIndex = buildIndex4(1, 3, 10);

correlations = zeros(trials, 1);
for i = 1:length(train)
    
    beta = polyfit(index, train([]), 1);
    prediction(i) = index * beta(1) + beta(2);
    correlations(i) = corr(regressHelper(sstIndex, r2), r2);
    
end

hist(correlations)


end

