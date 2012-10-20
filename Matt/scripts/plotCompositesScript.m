%-----------------------Plot Hurricane Counts-----------------------------
clear
if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end
addpath('/project/expeditions/lem/ClimateCode/Matt/');
addpath('/project/expeditions/lem/ClimateCode/Matt/indexExperiment/');
load /project/expeditions/ClimateCodeMatFiles/condensedHurDat.mat
[nYears, pYears] = getPositiveAndNegativeYears(condensedHurDat, 1);

plotIndividualComposites(vars, nYears, pYears, 'hurricaneCounts', 'AugOct');

%% -------------------Atlantic EOF PC 1------------------------------------

if ~exist('vars', 'var')
    vars = load('/project/expeditions/ClimateCodeMatFiles/compositeVariables.mat');
end

load /project/expeditions/ClimateCodeMatFiles/augOctAtlanticBasinEOFPCs.mat
[nYears, pYears] = getPosNegYearsFromVector(PCs(:, 1), 1, true, 1979);
plotIndividualComposites(vars, nYears, pYears, 'AtlanticBasinEOF1stPC', 'AugOct');
