function [negYears, posYears] = getPosNegYearsEPNP()
%Returns the positive and negative years for the East Pacific/North Pacific
%Pattern
%   Detailed explanation goes here

load matFiles/EPNPIndex.mat;

EPNPMat = EPNPMat(EPNPMat(:, 1) >= 1979 & EPNPMat(:, 1) <= 2010, 4:11);
%First Col is year, so 4-11 is march-october

EPNPMat = mean(EPNPMat, 2);
normalizedEPNP = (EPNPMat - mean(EPNPMat)) ./ std(EPNPMat);

baseYear = 1979;
posYears = find(normalizedEPNP >= 1) + baseYear - 1;
negYears = find(normalizedEPNP <= -1) + baseYear - 1;


end

