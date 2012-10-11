function [counts] = countInstances(bestVars)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

counts = zeros(size(bestVars));
for i = 1:size(bestVars, 1)
    for j = 1:size(bestVars, 2)
        for k = 1:size(bestVars, 3)
            if j < i 
                continue
            end
            counts(i, j, k) = numelements(find(bestVars(:) == bestVars(i, j, k)));
        end
    end
end

end

