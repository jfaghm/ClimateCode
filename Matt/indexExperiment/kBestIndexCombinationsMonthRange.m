function [cc, bestVars] = kBestIndexCombinationsMonthRange(k)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    if matlabpool('size') == 0
        matlabpool open
    end

    bestVars = zeros(12, 12, k);
    cc = zeros(12, 12, k);
    parfor i = 1:12
        for j = 1:12
            [~,~,cc(i, j, :), bestVars(i, j, :)] = tryAllIndexCombos(i, j, k);
        end
    end


end

