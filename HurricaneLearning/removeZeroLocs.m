% This script goes through the hurDat data set and removes the strange zero
% latitude and longitude observations, which are incorrect

load('atlantic_storms_1851_2010.mat')

numObs = size(hurDat, 1);
valid = true(numObs, 1);


for i = 1:numObs
    if all(hurDat(i, 6:7) == 0)
        prevIndex = i - 1;
        nextIndex = i + 1;
        prev = true;
        next = true;
        
        if prevIndex > 0 && hurDat(prevIndex, 1) == hurDat(i, 1)
            if sum((hurDat(prevIndex, 6:7) - hurDat(i, 6:7)).^2)^0.5 > 10
                prev = false;
            end
        end
        if nextIndex <= numObs && hurDat(nextIndex, 1) == hurDat(i, 1)
            if sum((hurDat(nextIndex, 6:7) - hurDat(i, 6:7)).^2)^0.5 > 10
                next = false;
            end
        end
        
        valid(i) = prev && next;
    end
end

hurDat(~valid, :) = [];