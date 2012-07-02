function [negYears, posYears ] = getPosNegYearsNAO()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load matFiles/NAOIndex.mat;
%NAO gets loaded from the NAOIndex.mat file.  Matlab thinks that it hasn't
%been defined because the code analyzer can't see look in the mat files, so
%the following error can be ignored.
NAO = NAO(NAO(:, 1) >= 1979, 4:11);

NAO = mean(NAO, 2);
normalizedNAO = (NAO - mean(NAO)) ./ std(NAO);

baseYear = 1979;
posYears = find(normalizedNAO >= 1) + baseYear - 1;
negYears = find(normalizedNAO <= -1) + baseYear - 1;

end

